Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526Ab0JSD4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:18 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28449 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758037Ab0JSD4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSoUA
Message-Id: <20101019034656.732498317@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:28 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 12/35] fs: inode atomic last_ino, iunique lock
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-6c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make last_ino atomic in preperation for removing inode_lock.
Make a new lock for iunique counter, for removing inode_lock.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:32.000000000 +1100
@@ -742,7 +742,7 @@
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
-	static unsigned int last_ino;
+	static atomic_t last_ino = ATOMIC_INIT(0);
 	struct inode *inode;
 
 	spin_lock_prefetch(&inode_lock);
@@ -752,7 +752,7 @@
 		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
-		inode->i_ino = ++last_ino;
+		inode->i_ino = (unsigned int)atomic_inc_return(&last_ino);
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
@@ -903,6 +903,29 @@
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
@@ -924,20 +947,18 @@
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
+	static DEFINE_SPINLOCK(unique_lock);
 	static unsigned int counter;
-	struct inode *inode;
-	struct hlist_head *head;
 	ino_t res;
 
 	spin_lock(&inode_lock);
+	spin_lock(&unique_lock);
 	do {
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-		head = inode_hashtable + hash(sb, res);
-		inode = find_inode_fast(sb, head, res);
-		spin_unlock(&inode->i_lock);
-	} while (inode != NULL);
+	} while (!is_ino_hashed(sb, res));
+	spin_unlock(&unique_lock);
 	spin_unlock(&inode_lock);
 
 	return res;


