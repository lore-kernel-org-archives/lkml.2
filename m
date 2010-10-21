Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab0JUNWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:22:50 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11481 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758002Ab0JUNWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+FSgSKTYUB
Message-Id: <20101021131016.858768236@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:38 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 09/14] fs: inode atomic last_ino, iunique lock
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-6c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make last_ino atomic in preperation for removing inode_lock.
Make a new lock for iunique counter, for removing inode_lock.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c |   44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:43.000000000 +1100
@@ -817,7 +817,7 @@ struct inode *new_inode(struct super_blo
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
-	static unsigned int last_ino;
+	static atomic_t last_ino = ATOMIC_INIT(0);
 	struct inode *inode;
 
 	spin_lock_prefetch(&inode_lock);
@@ -826,7 +826,7 @@ struct inode *new_inode(struct super_blo
 	if (inode) {
 		spin_lock(&inode_lock);
 		spin_lock(&inode->i_lock);
-		inode->i_ino = ++last_ino;
+		inode->i_ino = (unsigned int)atomic_inc_return(&last_ino);
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
@@ -982,6 +982,29 @@ static struct inode *get_new_inode_fast(
 	return inode;
 }
 
+/* Is the ino for this sb hashed right now? */
+static int is_ino_hashed(struct super_block *sb, unsigned long ino)
+{
+	struct hlist_node *node;
+	struct inode *inode = NULL;
+	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+
+	spin_lock(&inode_hash_lock);
+	hlist_for_each_entry(inode, node, head, i_hash) {
+		if (inode->i_ino == ino && inode->i_sb == sb) {
+			spin_unlock(&inode_hash_lock);
+			return 0;
+		}
+		/*
+		 * Don't bother checking for I_FREEING etc., because
+		 * we don't want iunique to wait on freeing inodes. Just
+		 * skip it and get the next one.
+		 */
+	}
+	spin_unlock(&inode_hash_lock);
+	return 1;
+}
+
 /**
  *	iunique - get a unique inode number
  *	@sb: superblock
@@ -992,34 +1015,33 @@ static struct inode *get_new_inode_fast(
  *	permanent inode numbering system. An inode number is returned that
  *	is higher than the reserved limit but unique.
  *
+ *	Callers must serialise calls to iunique, because this function drops
+ *	all locks after it returns, so if concurrency on the same sb is
+ *	allowed, the value is racy by the time it returns.
+ *
  *	BUGS:
  *	With a large number of inodes live on the file system this function
  *	currently becomes quite slow.
  */
 ino_t iunique(struct super_block *sb, ino_t max_reserved)
 {
+	static DEFINE_SPINLOCK(unique_lock);
 	/*
 	 * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
 	static unsigned int counter;
-	struct inode *inode;
-	struct hlist_head *head;
 	ino_t res;
 
 	spin_lock(&inode_lock);
-	spin_lock(&inode_hash_lock);
+	spin_lock(&unique_lock);
 	do {
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-		head = inode_hashtable + hash(sb, res);
-		inode = find_inode_fast(sb, head, res);
-	} while (inode != NULL);
-	spin_unlock(&inode_hash_lock);
-	if (inode)
-		spin_unlock(&inode->i_lock);
+	} while (!is_ino_hashed(sb, res));
+	spin_unlock(&unique_lock);
 	spin_unlock(&inode_lock);
 
 	return res;


