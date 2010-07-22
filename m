Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab0GVUqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:46:15 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33913 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759961Ab0GVUqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:46:03 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v2 14/14] ima: appraise measurement required
Date: Thu, 22 Jul 2010 16:44:15 -0400
Message-Id: <1279831456-2765-15-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279831456-2765-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1279831456-2765-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if allowed to update security.ima, reset the appraisal
flags, forcing re-appraisal.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/ima/ima_main.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 3713d55..0dbfdd6 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -386,18 +386,47 @@ static int ima_protect_xattr(struct dentry *dentry, const char *xattr_name,
 	return 0;
 }
 
+static void ima_reset_appraise_flags(struct inode *inode)
+{
+	struct integrity_iint_cache *iint;
+
+	if (!ima_initialized || !ima_appraise || !S_ISREG(inode->i_mode))
+		return;
+
+	iint = integrity_iint_find_get(inode);
+	if (!iint)
+		return;
+
+	mutex_lock(&iint->mutex);
+	iint->flags &= ~(IMA_COLLECTED | IMA_APPRAISED | IMA_MEASURED);
+	mutex_unlock(&iint->mutex);
+	kref_put(&iint->refcount, iint_free);
+	return;
+}
+
 int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		       const void *xattr_value, size_t xattr_value_len)
 {
-	return ima_protect_xattr(dentry, xattr_name, xattr_value,
+	int result;
+
+	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
 				 xattr_value_len);
+	if (!result)
+		ima_reset_appraise_flags(dentry->d_inode);
+	return result;
 }
 
 int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
 {
-	return ima_protect_xattr(dentry, xattr_name, NULL, 0);
+	int result;
+
+	result = ima_protect_xattr(dentry, xattr_name, NULL, 0);
+	if (!result)
+		ima_reset_appraise_flags(dentry->d_inode);
+	return result;
 }
 
+
 static int __init init_ima(void)
 {
 	int error;
-- 
1.7.1.1

