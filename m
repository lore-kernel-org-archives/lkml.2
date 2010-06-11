Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab0FKW1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:27:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932522Ab0FKW1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:27:04 -0400
Date: Fri, 11 Jun 2010 15:26:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
Message-Id: <20100611152620.97bc3e59.akpm@linux-foundation.org>
In-Reply-To: <1276294003.2385.48.camel@mudge.jf.intel.com>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	<20100601145126.f46572d1.akpm@linux-foundation.org>
	<87ocftyfnh.fsf@basil.nowhere.org>
	<20100609153654.0061e9c8.akpm@linux-foundation.org>
	<1276189574.2385.32.camel@mudge.jf.intel.com>
	<20100611145219.017a87c0.akpm@linux-foundation.org>
	<1276294003.2385.48.camel@mudge.jf.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 15:06:43 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> > afacit, your proposed implementation could have used percpu_counters. 
> > If so, that would be by far the best way of doing it, because that
> > doesn't require the addition of new infrastructure.
> 
> Just having percpu counters is not enough.
> There is additional logic required to manage the per cpu counters: 
> (1) set limit on the total number of tokens (2) distribute tokens into
> per cpu counter (3) logic to coordinate where to get additional tokens
> when we run out of tokens in the per cpu counter. (4) rebalance the
> tokens when we have too many of the tokens returned to a per cpu
> counter.  I'm trying to encapsulate these logic into the library.
> Otherwise, these logic will still need to be duplicated in the code
> using the per cpu counters.  

There's no need for any of that.

free_blocks is just a counter.  You add things to it, you subtract
things from it and you compare it with a threshold.

Something like the below.

It a bit buggy - using percpu_counter_init() against an
already-initialised percpu_counter() is leaky.  I suspect that's
happening in remount_fs.

A better approach would be to remove free_blocks altogether and add a
new `percpu_counter used_blocks;' which simply counts how many blocks
are presently in use.  Such a thing would then never need to be
reinitialised.

 include/linux/shmem_fs.h |    3 ++-
 mm/shmem.c               |   20 +++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/shmem.c~a mm/shmem.c
--- a/mm/shmem.c~a
+++ a/mm/shmem.c
@@ -28,6 +28,7 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/percpu_counter.h>
 #include <linux/swap.h>
 
 static struct vfsmount *shm_mnt;
@@ -233,8 +234,8 @@ static void shmem_free_blocks(struct ino
 {
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	if (sbinfo->max_blocks) {
+		percpu_counter_add(&sbinfo->free_blocks, pages);
 		spin_lock(&sbinfo->stat_lock);
-		sbinfo->free_blocks += pages;
 		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
 		spin_unlock(&sbinfo->stat_lock);
 	}
@@ -422,11 +423,11 @@ static swp_entry_t *shmem_swp_alloc(stru
 		 */
 		if (sbinfo->max_blocks) {
 			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks <= 1) {
+			if (percpu_counter_read(&sbinfo->free_blocks) <= 1) {
 				spin_unlock(&sbinfo->stat_lock);
 				return ERR_PTR(-ENOSPC);
 			}
-			sbinfo->free_blocks--;
+			percpu_counter_dec(&sbinfo->free_blocks);
 			inode->i_blocks += BLOCKS_PER_PAGE;
 			spin_unlock(&sbinfo->stat_lock);
 		}
@@ -1389,14 +1390,14 @@ repeat:
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
 			spin_lock(&sbinfo->stat_lock);
-			if (sbinfo->free_blocks == 0 ||
+			if (percpu_counter_read(&sbinfo->free_blocks) <= 0 ||
 			    shmem_acct_block(info->flags)) {
 				spin_unlock(&sbinfo->stat_lock);
 				spin_unlock(&info->lock);
 				error = -ENOSPC;
 				goto failed;
 			}
-			sbinfo->free_blocks--;
+			percpu_counter_dec(&sbinfo->free_blocks);
 			inode->i_blocks += BLOCKS_PER_PAGE;
 			spin_unlock(&sbinfo->stat_lock);
 		} else if (shmem_acct_block(info->flags)) {
@@ -1795,7 +1796,8 @@ static int shmem_statfs(struct dentry *d
 	spin_lock(&sbinfo->stat_lock);
 	if (sbinfo->max_blocks) {
 		buf->f_blocks = sbinfo->max_blocks;
-		buf->f_bavail = buf->f_bfree = sbinfo->free_blocks;
+		buf->f_bavail = buf->f_bfree =
+				percpu_counter_read(&sbinfo->free_blocks);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
@@ -2251,7 +2253,7 @@ static int shmem_remount_fs(struct super
 		return error;
 
 	spin_lock(&sbinfo->stat_lock);
-	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
+	blocks = sbinfo->max_blocks - percpu_counter_read(&sbinfo->free_blocks);
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
 	if (config.max_blocks < blocks)
 		goto out;
@@ -2270,7 +2272,7 @@ static int shmem_remount_fs(struct super
 
 	error = 0;
 	sbinfo->max_blocks  = config.max_blocks;
-	sbinfo->free_blocks = config.max_blocks - blocks;
+	percpu_counter_init(&sbinfo->free_blocks, config.max_blocks - blocks);
 	sbinfo->max_inodes  = config.max_inodes;
 	sbinfo->free_inodes = config.max_inodes - inodes;
 
@@ -2345,7 +2347,7 @@ int shmem_fill_super(struct super_block 
 #endif
 
 	spin_lock_init(&sbinfo->stat_lock);
-	sbinfo->free_blocks = sbinfo->max_blocks;
+	percpu_counter_init(&sbinfo->free_blocks, sbinfo->max_blocks);
 	sbinfo->free_inodes = sbinfo->max_inodes;
 
 	sb->s_maxbytes = SHMEM_MAX_BYTES;
diff -puN include/linux/shmem_fs.h~a include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~a
+++ a/include/linux/shmem_fs.h
@@ -3,6 +3,7 @@
 
 #include <linux/swap.h>
 #include <linux/mempolicy.h>
+#include <linux/percpu_counter.h>
 
 /* inode in-kernel data */
 
@@ -23,7 +24,7 @@ struct shmem_inode_info {
 
 struct shmem_sb_info {
 	unsigned long max_blocks;   /* How many blocks are allowed */
-	unsigned long free_blocks;  /* How many are left for allocation */
+	struct percpu_counter free_blocks;  /* How many are left for allocation */
 	unsigned long max_inodes;   /* How many inodes are allowed */
 	unsigned long free_inodes;  /* How many are left for allocation */
 	spinlock_t stat_lock;	    /* Serialize shmem_sb_info changes */
_

