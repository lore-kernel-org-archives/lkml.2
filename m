Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0JRGWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:22:06 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:41704 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753626Ab0JRGVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:21:50 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] fs: move i_ref increments into find_inode/find_inode_fast
Date: Mon, 18 Oct 2010 17:20:47 +1100
Message-Id: <1287382856-29529-12-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287382856-29529-1-git-send-email-david@fromorbit.com>
References: <1287382856-29529-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Now that iunique is not abusing find_inode anymore we can move the i_ref
increment back to where it belongs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 0128f82..d45c908 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -657,11 +657,9 @@ static struct shrinker icache_shrinker = {
 };
 
 static void __wait_on_freeing_inode(struct inode *inode);
+
 /*
  * Called with the inode lock held.
- * NOTE: we are not increasing the inode-refcount, you must take a reference
- * by hand after calling find_inode now! This simplifies iunique and won't
- * add any additional branch in the common code.
  */
 static struct inode *find_inode(struct super_block *sb,
 				struct hlist_head *head,
@@ -681,9 +679,12 @@ repeat:
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
-		break;
+		spin_lock(&inode->i_lock);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
+		return inode;
 	}
-	return node ? inode : NULL;
+	return NULL;
 }
 
 /*
@@ -706,9 +707,12 @@ repeat:
 			__wait_on_freeing_inode(inode);
 			goto repeat;
 		}
-		break;
+		spin_lock(&inode->i_lock);
+		inode->i_ref++;
+		spin_unlock(&inode->i_lock);
+		return inode;
 	}
-	return node ? inode : NULL;
+	return NULL;
 }
 
 static inline void
@@ -853,9 +857,6 @@ static struct inode *get_new_inode(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_lock(&old->i_lock);
-		old->i_ref++;
-		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -902,9 +903,6 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
 		 * us. Use the old inode instead of the one we just
 		 * allocated.
 		 */
-		spin_lock(&old->i_lock);
-		old->i_ref++;
-		spin_unlock(&old->i_lock);
 		spin_unlock(&inode_lock);
 		destroy_inode(inode);
 		inode = old;
@@ -1022,9 +1020,6 @@ static struct inode *ifind(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode(sb, head, test, data);
 	if (inode) {
-		spin_lock(&inode->i_lock);
-		inode->i_ref++;
-		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		if (likely(wait))
 			wait_on_inode(inode);
@@ -1057,9 +1052,6 @@ static struct inode *ifind_fast(struct super_block *sb,
 	spin_lock(&inode_lock);
 	inode = find_inode_fast(sb, head, ino);
 	if (inode) {
-		spin_lock(&inode->i_lock);
-		inode->i_ref++;
-		spin_unlock(&inode->i_lock);
 		spin_unlock(&inode_lock);
 		wait_on_inode(inode);
 		return inode;
-- 
1.7.1

