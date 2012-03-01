Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab2CATRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:17:23 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41156 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2CATRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:17:21 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v2 05/11] ima: allocating iint improvements
Date: Thu,  1 Mar 2012 14:10:42 -0500
Message-Id: <1330629048-5933-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030119-2398-0000-0000-000004B31DA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

With IMA-appraisal's removal of the iint mutex and taking the i_mutex
instead, allocating the iint becomes a lot simplier, as we don't need
to be concerned with two processes racing to allocate the iint. This
patch cleans up and improves performance for allocating the iint.

- removed redundant double i_mutex locking
- combined iint allocation with tree search

Changelog v2:
- removed the rwlock/read_lock changes from this patch

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/integrity.h         |    7 +++--
 security/integrity/iint.c         |   45 +++++++++++++++---------------------
 security/integrity/ima/ima_main.c |   13 +++-------
 3 files changed, 27 insertions(+), 38 deletions(-)

diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index a0c4125..66c5fe9 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -22,13 +22,14 @@ enum integrity_status {
 
 /* List of EVM protected security xattrs */
 #ifdef CONFIG_INTEGRITY
-extern int integrity_inode_alloc(struct inode *inode);
+extern struct integrity_iint_cache *integrity_inode_get(struct inode *inode);
 extern void integrity_inode_free(struct inode *inode);
 
 #else
-static inline int integrity_inode_alloc(struct inode *inode)
+static inline struct integrity_iint_cache *
+				integrity_inode_get(struct inode *inode)
 {
-	return 0;
+	return NULL;
 }
 
 static inline void integrity_inode_free(struct inode *inode)
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index e600986..c91a436 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -80,24 +80,26 @@ static void iint_free(struct integrity_iint_cache *iint)
 }
 
 /**
- * integrity_inode_alloc - allocate an iint associated with an inode
+ * integrity_inode_get - find or allocate an iint associated with an inode
  * @inode: pointer to the inode
+ * @return: allocated iint
+ *
+ * Caller must lock i_mutex
  */
-int integrity_inode_alloc(struct inode *inode)
+struct integrity_iint_cache *integrity_inode_get(struct inode *inode)
 {
 	struct rb_node **p;
-	struct rb_node *new_node, *parent = NULL;
-	struct integrity_iint_cache *new_iint, *test_iint;
-	int rc;
+	struct rb_node *node, *parent = NULL;
+	struct integrity_iint_cache *iint, *test_iint;
 
-	new_iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
-	if (!new_iint)
-		return -ENOMEM;
+	iint = integrity_iint_find(inode);
+	if (iint)
+		return iint;
 
-	new_iint->inode = inode;
-	new_node = &new_iint->rb_node;
+	iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
+	if (!iint)
+		return NULL;
 
-	mutex_lock(&inode->i_mutex);	/* i_flags */
 	spin_lock(&integrity_iint_lock);
 
 	p = &integrity_iint_tree.rb_node;
@@ -105,29 +107,20 @@ int integrity_inode_alloc(struct inode *inode)
 		parent = *p;
 		test_iint = rb_entry(parent, struct integrity_iint_cache,
 				     rb_node);
-		rc = -EEXIST;
 		if (inode < test_iint->inode)
 			p = &(*p)->rb_left;
-		else if (inode > test_iint->inode)
-			p = &(*p)->rb_right;
 		else
-			goto out_err;
+			p = &(*p)->rb_right;
 	}
 
+	iint->inode = inode;
+	node = &iint->rb_node;
 	inode->i_flags |= S_IMA;
-	rb_link_node(new_node, parent, p);
-	rb_insert_color(new_node, &integrity_iint_tree);
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, &integrity_iint_tree);
 
 	spin_unlock(&integrity_iint_lock);
-	mutex_unlock(&inode->i_mutex);	/* i_flags */
-
-	return 0;
-out_err:
-	spin_unlock(&integrity_iint_lock);
-	mutex_unlock(&inode->i_mutex);	/* i_flags */
-	iint_free(new_iint);
-
-	return rc;
+	return iint;
 }
 
 /**
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index fba2f7b..9fe0597 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -145,19 +145,14 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 	if (!action)
 		return 0;
 
-retry:
-	iint = integrity_iint_find(inode);
-	if (!iint) {
-		rc = integrity_inode_alloc(inode);
-		if (!rc || rc == -EEXIST)
-			goto retry;
-		return rc;
-	}
-
 	must_appraise = action & IMA_APPRAISE;
 
 	mutex_lock(&inode->i_mutex);
 
+	iint = integrity_inode_get(inode);
+	if (!iint)
+		goto out;
+
 	/* Determine if already appraised/measured based on bitmask
 	 * (IMA_MEASURE, IMA_MEASURED, IMA_APPRAISE, IMA_APPRAISED) */
 	iint->flags |= action;
-- 
1.7.6.5

