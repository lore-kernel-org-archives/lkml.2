Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0FXDQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:16:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab0FXDPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:48 -0400
Message-Id: <20100624030730.935119101@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:45 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 33/52] fs: icache atomic last_ino, iunique lock
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-inode_lock-scale-6c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make last_ino atomic in preperation for removing inode_lock.
Make a new lock for iunique counter, for removing inode_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/inode.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -742,7 +742,7 @@ struct inode *new_inode(struct super_blo
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
-	static unsigned int last_ino;
+	static atomic_t last_ino = ATOMIC_INIT(0);
 	struct inode *inode;
 
 	spin_lock_prefetch(&inode_lock);
@@ -752,7 +752,7 @@ struct inode *new_inode(struct super_blo
 		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
-		inode->i_ino = ++last_ino;
+		inode->i_ino = atomic_inc_return(&last_ino);
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
@@ -903,6 +903,22 @@ static struct inode *get_new_inode_fast(
 	return inode;
 }
 
+static int test_inode_iunique(struct super_block * sb, struct hlist_head *head, unsigned long ino)
+{
+	struct hlist_node *node;
+	struct inode * inode = NULL;
+
+	spin_lock(&inode_hash_lock);
+	hlist_for_each_entry(inode, node, head, i_hash) {
+		if (inode->i_ino == ino && inode->i_sb == sb) {
+			spin_unlock(&inode_hash_lock);
+			return 0;
+		}
+	}
+	spin_unlock(&inode_hash_lock);
+	return 1;
+}
+
 /**
  *	iunique - get a unique inode number
  *	@sb: superblock
@@ -924,20 +940,20 @@ ino_t iunique(struct super_block *sb, in
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
+	static DEFINE_SPINLOCK(unique_lock);
 	static unsigned int counter;
-	struct inode *inode;
 	struct hlist_head *head;
 	ino_t res;
 
 	spin_lock(&inode_lock);
+	spin_lock(&unique_lock);
 	do {
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
 		head = inode_hashtable + hash(sb, res);
-		inode = find_inode_fast(sb, head, res);
-		spin_unlock(&inode->i_lock);
-	} while (inode != NULL);
+	} while (!test_inode_iunique(sb, head, res));
+	spin_unlock(&unique_lock);
 	spin_unlock(&inode_lock);
 
 	return res;


