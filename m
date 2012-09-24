Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2IXI1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:27:07 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:40779 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213Ab2IXI1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:27:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKAKYYYFB5Lafp/2dsb2JhbAA9CL0iA4EGgQmCIAEBBScTHCMQCAMOBwMuFCUDIROIBLhDFIsIFmaFLgOVZJAkgnk
Date: Mon, 24 Sep 2012 18:26:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Guo Chao <yan@linux.vnet.ibm.com>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@infradead.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 Patch 0/4] fs/inode.c: optimization for inode lock usage
Message-ID: <20120924082654.GG20960@dastard>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
 <20120921224912.GA20960@dastard>
 <20120924024221.GB7984@yanx>
 <20120924042343.GC20960@dastard>
 <20120924061205.GA27244@yanx>
 <20120924062812.GD20960@dastard>
 <20120924070852.GA10280@yanx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924070852.GA10280@yanx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 03:08:52PM +0800, Guo Chao wrote:
> On Mon, Sep 24, 2012 at 04:28:12PM +1000, Dave Chinner wrote:
> > > Ah, this is intended to be a code clean patchset actually. I thought these
> > > locks are redundant in an obvious and trivial manner. If, on the contrary, 
> > > they are such tricky, then never mind :) Thanks for your patient.
> > 
> > The RCU conversion is actually trivial - everything is already set
> > up for it to be done, and is simpler than this patch set. It pretty
> > much is simply replacing all the read side inode_hash_lock pairs
> > with rcu_read_lock()/rcu_read_unlock() pairs. Like I said, if you
> > want to clean up this code, then RCU traversals are the conversion
> > to make.
> >
> 
> Thanks for your suggestion. Though I doubt it's such trivial, I will try this
> after a little investigation.

Probably best to start with the patch below - it's run under heavy
concurrent load on ext4 with a working set of inodes about 20x
larger than can fit in memory for the past hour....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

fs: Use RCU lookups for inode cache

From: Dave Chinner <dchinner@redhat.com>

Convert inode cache lookups to be protected by RCU locking rather
than the global inode_hash_lock. This will improve scalability of
inode lookup intensive workloads.

Smoke tested w/ ext4 on concurrent fsmark/lookup/unlink workloads
over 50 million or so inodes...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   74 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 32 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ac8d904..2e92674 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -464,7 +464,7 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_add_head(&inode->i_hash, b);
+	hlist_add_head_rcu(&inode->i_hash, b);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
@@ -480,7 +480,7 @@ void __remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
-	hlist_del_init(&inode->i_hash);
+	hlist_del_init_rcu(&inode->i_hash);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
@@ -783,14 +783,19 @@ static void __wait_on_freeing_inode(struct inode *inode);
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_head *head,
 				int (*test)(struct inode *, void *),
-				void *data)
+				void *data, bool locked)
 {
 	struct hlist_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(inode, node, head, i_hash) {
 		spin_lock(&inode->i_lock);
+		if (inode_unhashed(inode)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		if (inode->i_sb != sb) {
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -800,13 +805,20 @@ repeat:
 			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			rcu_read_unlock();
+			if (locked)
+				spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
+			if (locked)
+				spin_lock(&inode_hash_lock);
 			goto repeat;
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
+		rcu_read_unlock();
 		return inode;
 	}
+	rcu_read_unlock();
 	return NULL;
 }
 
@@ -815,14 +827,20 @@ repeat:
  * iget_locked for details.
  */
 static struct inode *find_inode_fast(struct super_block *sb,
-				struct hlist_head *head, unsigned long ino)
+				     struct hlist_head *head,
+				     unsigned long ino, bool locked)
 {
 	struct hlist_node *node;
 	struct inode *inode = NULL;
 
 repeat:
-	hlist_for_each_entry(inode, node, head, i_hash) {
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(inode, node, head, i_hash) {
 		spin_lock(&inode->i_lock);
+		if (inode_unhashed(inode)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		if (inode->i_ino != ino) {
 			spin_unlock(&inode->i_lock);
 			continue;
@@ -832,13 +850,20 @@ repeat:
 			continue;
 		}
 		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
+			rcu_read_unlock();
+			if (locked)
+				spin_unlock(&inode_hash_lock);
 			__wait_on_freeing_inode(inode);
+			if (locked)
+				spin_lock(&inode_hash_lock);
 			goto repeat;
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
+		rcu_read_unlock();
 		return inode;
 	}
+	rcu_read_unlock();
 	return NULL;
 }
 
@@ -995,9 +1020,7 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode(sb, head, test, data);
-	spin_unlock(&inode_hash_lock);
+	inode = find_inode(sb, head, test, data, false);
 
 	if (inode) {
 		wait_on_inode(inode);
@@ -1009,8 +1032,7 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 		struct inode *old;
 
 		spin_lock(&inode_hash_lock);
-		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
+		old = find_inode(sb, head, test, data, true);
 		if (!old) {
 			if (set(inode, data))
 				goto set_failed;
@@ -1065,9 +1087,7 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode_fast(sb, head, ino);
-	spin_unlock(&inode_hash_lock);
+	inode = find_inode_fast(sb, head, ino, false);
 	if (inode) {
 		wait_on_inode(inode);
 		return inode;
@@ -1078,8 +1098,7 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 		struct inode *old;
 
 		spin_lock(&inode_hash_lock);
-		/* We released the lock, so.. */
-		old = find_inode_fast(sb, head, ino);
+		old = find_inode_fast(sb, head, ino, true);
 		if (!old) {
 			inode->i_ino = ino;
 			spin_lock(&inode->i_lock);
@@ -1122,14 +1141,15 @@ static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 	struct hlist_node *node;
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
+	rcu_read_lock();
 	hlist_for_each_entry(inode, node, b, i_hash) {
-		if (inode->i_ino == ino && inode->i_sb == sb) {
-			spin_unlock(&inode_hash_lock);
+		if (inode->i_ino == ino && inode->i_sb == sb &&
+		    !inode_unhashed(inode)) {
+			rcu_read_unlock();
 			return 0;
 		}
 	}
-	spin_unlock(&inode_hash_lock);
+	rcu_read_unlock();
 
 	return 1;
 }
@@ -1210,13 +1230,8 @@ struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
 	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
-	struct inode *inode;
-
-	spin_lock(&inode_hash_lock);
-	inode = find_inode(sb, head, test, data);
-	spin_unlock(&inode_hash_lock);
 
-	return inode;
+	return find_inode(sb, head, test, data, false);
 }
 EXPORT_SYMBOL(ilookup5_nowait);
 
@@ -1261,10 +1276,7 @@ struct inode *ilookup(struct super_block *sb, unsigned long ino)
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 
-	spin_lock(&inode_hash_lock);
-	inode = find_inode_fast(sb, head, ino);
-	spin_unlock(&inode_hash_lock);
-
+	inode = find_inode_fast(sb, head, ino, false);
 	if (inode)
 		wait_on_inode(inode);
 	return inode;
@@ -1711,10 +1723,8 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_hash_lock);
 	schedule();
 	finish_wait(wq, &wait.wait);
-	spin_lock(&inode_hash_lock);
 }
 
 static __initdata unsigned long ihash_entries;
