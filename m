Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1A0NNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:13:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1A0NNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:13:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nick Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 15/20] ufs: remove the BKL
Date: Thu, 27 Jan 2011 14:13:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Nick Bowler <nbowler@elliptictech.com>,
        Evgeniy Dushistov <dushistov@mail.ru>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-16-git-send-email-arnd@arndb.de> <AANLkTinKO=HM1BqDdFkdcCAGz85co64Ma79qomw6PDPp@mail.gmail.com>
In-Reply-To: <AANLkTinKO=HM1BqDdFkdcCAGz85co64Ma79qomw6PDPp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101271413.01204.arnd@arndb.de>
X-Provags-ID: V02:K0:IAy6x7pwIzxo0f1jUiNopJ4t03m55+qlwKiuABsL07z
 5fGeYG2s575hQtyabI/gsPIx0cd8uBVXULB4mxpAgRgr1VyoV8
 BKQAudj5WHf31Dj5kD4DN7S/mb5wDuHSpmvH+ob6k7PkYXWrUr
 P2y79bqzGnlsQ5cld4iNCtp2zZhav6J14DcrI/FCL8peu5HtBP
 e803Mu0ybErIlNC3HVrRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 January 2011, Nick Piggin wrote:
> On Wed, Jan 26, 2011 at 9:17 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > This introduces a new per-superblock mutex in UFS to replace
> > the big kernel lock. I have been careful to avoid nested
> > calls to lock_ufs and to get the lock order right with
> > respect to other mutexes, in particular lock_super.
> 
> When I looked at removing bkl from minix a long time ago,
> I was a bit worried about reclaim and fs/io recursion in some
> of the filesystems with bkl.

Thanks for looking at this, you certainly understand these interactions
much better than me!

> > @@ -436,7 +439,8 @@ int ufs_getfrag_block(struct inode *inode, sector_t fragment, struct buffer_head
> >        ret = 0;
> >        bh = NULL;
> >
> > -       lock_kernel();
> > +       if (needs_lock)
> > +               lock_ufs(sb);
> >
> >        UFSD("ENTER, ino %lu, fragment %llu\n", inode->i_ino, (unsigned long long)fragment);
> >        if (fragment >


> So, get_block can be called for .writepage in page reclaim,
> which takes the lock. ufs_lookup takes the lock and winds
> up calling ufs_alloc_inode. And ufs_alloc_inode does
> GFP_KERNEL, which can enter reclaim with __GFP_FS
> set.

This is one path that I did not consider. My initial thought when you
mentioned it was that this is still fine because ufs_getfrag_block can be
called with the lock held by the current task, but you are of course
right that this won't work when we are called by the writeback task.

> I didn't look through all your filesystem conversions, but it is
> something tricky to watch out for I think.

The only other one where I added locks is isofs, and I'm pretty sure that's
fine because it's read-only and does not do writeback. HPFS with Andi's suggested
solution of making it UP-only is of course also fine.
 
> Changing everything to GFP_NOFS may be an option, for
> such crufty old filesystems...

Yes. All performance optimizations in UFS are pointless anyway as long as we
do most of the disk I/O under a global mutex. The patch below converts all
allocations that are done under a lock in UFS to GFP_NOFS. If nobody comes
up with a better solution, I'll fold that into my other patch.

	Arnd
---

 fs/ufs/super.c |    8 ++++----
 fs/ufs/util.c  |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index e4e06ef..7693d62 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -539,7 +539,7 @@ static int ufs_read_cylinder_structures(struct super_block *sb)
 	 */
 	size = uspi->s_cssize;
 	blks = (size + uspi->s_fsize - 1) >> uspi->s_fshift;
-	base = space = kmalloc(size, GFP_KERNEL);
+	base = space = kmalloc(size, GFP_NOFS);
 	if (!base)
 		goto failed; 
 	sbi->s_csp = (struct ufs_csum *)space;
@@ -564,7 +564,7 @@ static int ufs_read_cylinder_structures(struct super_block *sb)
 	 * Read cylinder group (we read only first fragment from block
 	 * at this time) and prepare internal data structures for cg caching.
 	 */
-	if (!(sbi->s_ucg = kmalloc (sizeof(struct buffer_head *) * uspi->s_ncg, GFP_KERNEL)))
+	if (!(sbi->s_ucg = kmalloc (sizeof(struct buffer_head *) * uspi->s_ncg, GFP_NOFS)))
 		goto failed;
 	for (i = 0; i < uspi->s_ncg; i++) 
 		sbi->s_ucg[i] = NULL;
@@ -582,7 +582,7 @@ static int ufs_read_cylinder_structures(struct super_block *sb)
 		ufs_print_cylinder_stuff(sb, (struct ufs_cylinder_group *) sbi->s_ucg[i]->b_data);
 	}
 	for (i = 0; i < UFS_MAX_GROUP_LOADED; i++) {
-		if (!(sbi->s_ucpi[i] = kmalloc (sizeof(struct ufs_cg_private_info), GFP_KERNEL)))
+		if (!(sbi->s_ucpi[i] = kmalloc (sizeof(struct ufs_cg_private_info), GFP_NOFS)))
 			goto failed;
 		sbi->s_cgno[i] = UFS_CGNO_EMPTY;
 	}
@@ -1415,7 +1415,7 @@ static struct kmem_cache * ufs_inode_cachep;
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
 	struct ufs_inode_info *ei;
-	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_KERNEL);
+	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
 	ei->vfs_inode.i_version = 1;
diff --git a/fs/ufs/util.c b/fs/ufs/util.c
index d2c36d5..95425b5 100644
--- a/fs/ufs/util.c
+++ b/fs/ufs/util.c
@@ -27,7 +27,7 @@ struct ufs_buffer_head * _ubh_bread_ (struct ufs_sb_private_info * uspi,
 	if (count > UFS_MAXFRAG)
 		return NULL;
 	ubh = (struct ufs_buffer_head *)
-		kmalloc (sizeof (struct ufs_buffer_head), GFP_KERNEL);
+		kmalloc (sizeof (struct ufs_buffer_head), GFP_NOFS);
 	if (!ubh)
 		return NULL;
 	ubh->fragment = fragment;
