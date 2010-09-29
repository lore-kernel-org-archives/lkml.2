Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0I2MVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:21:50 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:44269 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755621Ab0I2MT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:29 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/17] fs: Make last_ino, iunique independent of inode_lock
Date: Wed, 29 Sep 2010 22:18:41 +1000
Message-Id: <1285762729-17928-10-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Before removing the inode_lock, we need to make the last_ino  and iunique
counters independent of the inode_lock. last_ino can be trivially converted to
an atomic variable, while the iunique counter needs a new lock nested inside
the inode_lock to provide the same protection that the inode_lock previously
provided.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8fbc4d4..c45b2db 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -736,7 +736,7 @@ struct inode *new_inode(struct super_block *sb)
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
-	static unsigned int last_ino;
+	static atomic_t last_ino = ATOMIC_INIT(0);
 	struct inode *inode;
 
 	spin_lock_prefetch(&inode_lock);
@@ -746,7 +746,7 @@ struct inode *new_inode(struct super_block *sb)
 		spin_lock(&inode_lock);
 		spin_lock(&sb_inode_list_lock);
 		spin_lock(&inode->i_lock);
-		inode->i_ino = ++last_ino;
+		inode->i_ino = (unsigned int)atomic_inc_return(&last_ino);
 		inode->i_state = 0;
 		__inode_add_to_lists(sb, NULL, inode);
 		spin_unlock(&inode->i_lock);
@@ -897,6 +897,22 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
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
@@ -918,20 +934,20 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
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
-- 
1.7.1

