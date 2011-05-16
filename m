Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab1EPOtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:49:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42806 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1EPOtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:49:00 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Roberto Sassu <roberto.sassu@polito.it>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 21/21] evm: add evm_inode_setattr to prevent updating an invalid security.evm
Date: Mon, 16 May 2011 10:45:15 -0400
Message-Id: <1305557115-15652-22-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Permit changing of security.evm only when valid, unless in fixmode.

Reported-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/evm.h               |    6 ++++++
 security/integrity/evm/evm_main.c |   15 +++++++++++++++
 security/security.c               |    7 ++++++-
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index 8db7b74..afc0669 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -19,6 +19,7 @@ extern enum integrity_status evm_verifyxattr(struct dentry *dentry,
 					     void *xattr_value,
 					     size_t xattr_value_len,
 					     struct integrity_iint_cache *iint);
+extern int evm_inode_setattr(struct dentry *dentry, struct iattr *attr);
 extern void evm_inode_post_setattr(struct dentry *dentry, int ia_valid);
 extern int evm_inode_setxattr(struct dentry *dentry, const char *name,
 			      const void *value, size_t size);
@@ -44,6 +45,11 @@ static inline enum integrity_status evm_verifyxattr(struct dentry *dentry,
 }
 #endif
 
+static int evm_inode_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	return 0;
+}
+
 static inline void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 {
 	return;
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index af9d229..61fe355 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -278,6 +278,21 @@ void evm_inode_post_removexattr(struct dentry *dentry, const char *xattr_name)
 }
 
 /**
+ * evm_inode_setattr - prevent updating an invalid EVM extended attribute
+ * @dentry: pointer to the affected dentry
+ */
+int evm_inode_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	unsigned int ia_valid = attr->ia_valid;
+	enum integrity_status evm_status;
+
+	if (ia_valid & ~(ATTR_MODE | ATTR_UID | ATTR_GID))
+		return 0;
+	evm_status = evm_verify_current_integrity(dentry);
+	return evm_status == INTEGRITY_PASS ? 0 : -EPERM;
+}
+
+/**
  * evm_inode_post_setattr - update 'security.evm' after modifying metadata
  * @dentry: pointer to the affected dentry
  * @ia_valid: for the UID and GID status
diff --git a/security/security.c b/security/security.c
index 635bcc9..d21f899 100644
--- a/security/security.c
+++ b/security/security.c
@@ -534,9 +534,14 @@ int security_inode_exec_permission(struct inode *inode, unsigned int flags)
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {
+	int ret;
+
 	if (unlikely(IS_PRIVATE(dentry->d_inode)))
 		return 0;
-	return security_ops->inode_setattr(dentry, attr);
+	ret = security_ops->inode_setattr(dentry, attr);
+	if (ret)
+		return ret;
+	return evm_inode_setattr(dentry, attr);
 }
 EXPORT_SYMBOL_GPL(security_inode_setattr);
 
-- 
1.7.3.4

