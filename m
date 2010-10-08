Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0JHFWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:22:38 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:47974 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752979Ab0JHFWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:22:32 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/18] fs: Make iunique independent of inode_lock
Date: Fri,  8 Oct 2010 16:21:30 +1100
Message-Id: <1286515292-15882-17-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286515292-15882-1-git-send-email-david@fromorbit.com>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
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
---
 fs/inode.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 13e1325..4ec360e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1070,6 +1070,30 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
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
+	struct inode_hash_bucket *b = inode_hashtable + hash(sb, ino);
+	struct hlist_bl_node *node;
+	struct inode *inode;
+
+	spin_lock_bucket(b);
+	hlist_bl_for_each_entry(inode, node, &b->head, i_hash) {
+		if (inode->i_ino == ino && inode->i_sb == sb) {
+			spin_unlock_bucket(b);
+			return 0;
+		}
+	}
+	spin_unlock_bucket(b);
+	return 1;
+}
+
 /**
  *	iunique - get a unique inode number
  *	@sb: superblock
@@ -1091,19 +1115,18 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
+	static DEFINE_SPINLOCK(unique_lock);
 	static unsigned int counter;
-	struct inode *inode;
-	struct inode_hash_bucket *b;
 	ino_t res;
 
 	spin_lock(&inode_lock);
+	spin_lock(&unique_lock);
 	do {
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-		b = inode_hashtable + hash(sb, res);
-		inode = find_inode_fast(sb, b, res);
-	} while (inode != NULL);
+	} while (!test_inode_iunique(sb, res));
+	spin_unlock(&unique_lock);
 	spin_unlock(&inode_lock);
 
 	return res;
-- 
1.7.1

