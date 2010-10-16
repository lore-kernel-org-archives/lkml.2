Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0JPIPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:15:20 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:54184 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753758Ab0JPIPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:15:09 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] fs: Make iunique independent of inode_lock
Date: Sat, 16 Oct 2010 19:14:09 +1100
Message-Id: <1287216853-17634-16-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287216853-17634-1-git-send-email-david@fromorbit.com>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Before removing the inode_lock, the iunique counter needs to be made
independent of the inode_lock. Add a new lock to protect the iunique
counter and nest it inside the inode_lock to provide the same
protection that the inode_lock currently provides.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 05852a1..6526d70 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1063,6 +1063,30 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 	return inode;
 }
 
+/*
+ * search the inode cache for a matching inode number.
+ * If we find one, then the inode number we are trying to
+ * allocate is not unique and so we should not use it.
+ *
+ * Returns 1 if the inode number is unique, 0 if it is not.
+ */
+static int test_inode_iunique(struct super_block * sb, unsigned long ino)
+{
+	struct hlist_bl_head *b = inode_hashtable + hash(sb, ino);
+	struct hlist_bl_node *node;
+	struct inode *inode;
+
+	hlist_bl_lock(b);
+	hlist_bl_for_each_entry(inode, node, b, i_hash) {
+		if (inode->i_ino == ino && inode->i_sb == sb) {
+			hlist_bl_unlock(b);
+			return 0;
+		}
+	}
+	hlist_bl_unlock(b);
+	return 1;
+}
+
 /**
  *	iunique - get a unique inode number
  *	@sb: superblock
@@ -1084,20 +1108,17 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
+	static DEFINE_SPINLOCK(iunique_lock);
 	static unsigned int counter;
-	struct inode *inode;
-	struct hlist_bl_head *b;
 	ino_t res;
 
-	spin_lock(&inode_lock);
+	spin_lock(&iunique_lock);
 	do {
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-		b = inode_hashtable + hash(sb, res);
-		inode = find_inode_fast(sb, b, res);
-	} while (inode != NULL);
-	spin_unlock(&inode_lock);
+	} while (!test_inode_iunique(sb, res));
+	spin_unlock(&iunique_lock);
 
 	return res;
 }
-- 
1.7.1

