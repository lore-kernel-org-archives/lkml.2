Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab0FBXp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:45:58 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37247 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850Ab0FBXp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:45:56 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] ima: appraise measurement required
Date: Wed,  2 Jun 2010 19:45:08 -0400
Message-Id: <1275522308-7247-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1275522308-7247-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1275522308-7247-1-git-send-email-zohar@linux.vnet.ibm.com>
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
index 62a7cf6..44fd452 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -385,18 +385,47 @@ int ima_protect_xattr(struct dentry *dentry, const char *xattr_name,
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
1.6.6.1

