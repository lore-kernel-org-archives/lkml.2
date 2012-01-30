Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2A3WUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:20:12 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44399 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab2A3WUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:20:10 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC][PATCH v1 7/9] ima: add ima_inode_setxattr/removexattr function and calls
Date: Mon, 30 Jan 2012 17:14:02 -0500
Message-Id: <1327961644-6886-8-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12013022-5930-0000-0000-000004969E90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on xattr_permission comments, the restriction to modify 'security'
xattr is left up to the underlying fs or lsm. Ensure that not just anyone
can modify or remove 'security.ima'.

Changelog v1:
- Unless IMA-APPRAISE is configured, use stub ima_inode_removexattr()/setxattr()
  functions.  (Moved ima_inode_removexattr()/setxattr() to ima_appraise.c)

Changelog:
  - take i_mutex to fix locking (Dmitry Kasatkin)
  - ima_reset_appraise_flags should only be called when modifying or
    removing the 'security.ima' xattr. Requires CAP_SYS_ADMIN privilege.
    (Incorporated fix from Roberto Sassu)
  - Even if allowed to update security.ima, reset the appraisal flags,
    forcing re-appraisal.
  - Replace CAP_MAC_ADMIN with CAP_SYS_ADMIN
  - static inline ima_inode_setxattr()/ima_inode_removexattr() stubs
  - ima_protect_xattr should be static

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/ima.h                   |   17 ++++++++++
 security/integrity/ima/ima_appraise.c |   57 +++++++++++++++++++++++++++++++++
 security/security.c                   |    6 +++
 3 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index e2bfbb1..2c7223d 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -44,10 +44,27 @@ static inline int ima_file_mmap(struct file *file, unsigned long prot)
 
 #ifdef CONFIG_IMA_APPRAISE
 extern void ima_inode_post_setattr(struct dentry *dentry);
+extern int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
+		       const void *xattr_value, size_t xattr_value_len);
+extern int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name);
 #else
 static inline void ima_inode_post_setattr(struct dentry *dentry)
 {
 	return;
 }
+
+static inline int ima_inode_setxattr(struct dentry *dentry,
+				     const char *xattr_name,
+				     const void *xattr_value,
+				     size_t xattr_value_len)
+{
+	return 0;
+}
+
+static inline int ima_inode_removexattr(struct dentry *dentry,
+					const char *xattr_name)
+{
+	return 0;
+}
 #endif /* CONFIG_IMA_APPRAISE_H */
 #endif /* _LINUX_IMA_H */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 392ceb2..5fd90fc 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -168,3 +168,60 @@ void ima_inode_post_setattr(struct dentry *dentry)
 		rc = inode->i_op->removexattr(dentry, XATTR_NAME_IMA);
 	return;
 }
+
+/*
+ * ima_protect_xattr - protect 'security.ima'
+ *
+ * Ensure that not just anyone can modify or remove 'security.ima'.
+ */
+static int ima_protect_xattr(struct dentry *dentry, const char *xattr_name,
+			     const void *xattr_value, size_t xattr_value_len)
+{
+	if (strcmp(xattr_name, XATTR_NAME_IMA) == 0) {
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		return 1;
+	}
+	return 0;
+}
+
+static void ima_reset_appraise_flags(struct inode *inode)
+{
+	struct integrity_iint_cache *iint;
+
+	if (!ima_initialized || !ima_appraise || !S_ISREG(inode->i_mode))
+		return;
+
+	iint = integrity_iint_find(inode);
+	if (!iint)
+		return;
+
+	iint->flags &= ~(IMA_COLLECTED | IMA_APPRAISED | IMA_MEASURED);
+	return;
+}
+
+int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
+		       const void *xattr_value, size_t xattr_value_len)
+{
+	int result;
+
+	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
+				   xattr_value_len);
+	if (result == 1) {
+		ima_reset_appraise_flags(dentry->d_inode);
+		result = 0;
+	}
+	return result;
+}
+
+int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
+{
+	int result;
+
+	result = ima_protect_xattr(dentry, xattr_name, NULL, 0);
+	if (result == 1) {
+		ima_reset_appraise_flags(dentry->d_inode);
+		result = 0;
+	}
+	return result;
+}
diff --git a/security/security.c b/security/security.c
index 556c64c..1203077 100644
--- a/security/security.c
+++ b/security/security.c
@@ -569,6 +569,9 @@ int security_inode_setxattr(struct dentry *dentry, const char *name,
 	ret = security_ops->inode_setxattr(dentry, name, value, size, flags);
 	if (ret)
 		return ret;
+	ret = ima_inode_setxattr(dentry, name, value, size);
+	if (ret)
+		return ret;
 	return evm_inode_setxattr(dentry, name, value, size);
 }
 
@@ -604,6 +607,9 @@ int security_inode_removexattr(struct dentry *dentry, const char *name)
 	ret = security_ops->inode_removexattr(dentry, name);
 	if (ret)
 		return ret;
+	ret = ima_inode_removexattr(dentry, name);
+	if (ret)
+		return ret;
 	return evm_inode_removexattr(dentry, name);
 }
 
-- 
1.7.6.5

