Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab0JUAu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:50:29 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:47576 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755338Ab0JUAu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:26 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/21] fs: Stop abusing find_inode_fast in iunique
Date: Thu, 21 Oct 2010 11:49:35 +1100
Message-Id: <1287622186-1935-11-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Stop abusing find_inode_fast for iunique and opencode the inode hash walk.
Introduce a new iunique_lock to protect the iunique counters once inode_lock
is removed.

Based on a patch originally from Nick Piggin.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cfcafee..77ff091 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -913,6 +913,27 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 	return inode;
 }
 
+/*
+ * search the inode cache for a matching inode number.
+ * If we find one, then the inode number we are trying to
+ * allocate is not unique and so we should not use it.
+ *
+ * Returns 1 if the inode number is unique, 0 if it is not.
+ */
+static int test_inode_iunique(struct super_block *sb, unsigned long ino)
+{
+	struct hlist_head *b = inode_hashtable + hash(sb, ino);
+	struct hlist_node *node;
+	struct inode *inode;
+
+	hlist_for_each_entry(inode, node, b, i_hash) {
+		if (inode->i_ino == ino && inode->i_sb == sb)
+			return 0;
+	}
+
+	return 1;
+}
+
 /**
  *	iunique - get a unique inode number
  *	@sb: superblock
@@ -934,19 +955,18 @@ ino_t iunique(struct super_block *sb, ino_t max_reserved)
 	 * error if st_ino won't fit in target struct field. Use 32bit counter
 	 * here to attempt to avoid that.
 	 */
+	static DEFINE_SPINLOCK(iunique_lock);
 	static unsigned int counter;
-	struct inode *inode;
-	struct hlist_head *head;
 	ino_t res;
 
 	spin_lock(&inode_lock);
+	spin_lock(&iunique_lock);
 	do {
 		if (counter <= max_reserved)
 			counter = max_reserved + 1;
 		res = counter++;
-		head = inode_hashtable + hash(sb, res);
-		inode = find_inode_fast(sb, head, res);
-	} while (inode != NULL);
+	} while (!test_inode_iunique(sb, res));
+	spin_unlock(&iunique_lock);
 	spin_unlock(&inode_lock);
 
 	return res;
-- 
1.7.1

