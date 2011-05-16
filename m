Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1EPOss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:48:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50379 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab1EPOsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:48:46 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Roberto Sassu <roberto.sassu@polito.it>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 20/21] evm: permit only valid security.evm xattrs to be updated
Date: Mon, 16 May 2011 10:45:14 -0400
Message-Id: <1305557115-15652-21-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to requiring CAP_SYS_ADMIN permission to modify/delete
security.evm, prohibit invalid security.evm xattrs from changing,
unless in fixmode. This patch prevents inadvertent 'fixing' of
security.evm to reflect offline modifications.

Reported-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 Documentation/kernel-parameters.txt |    6 +++
 security/integrity/evm/evm_main.c   |   77 ++++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 14 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cc85a92..d9901cd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -48,6 +48,7 @@ parameter is applicable:
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
 	EFI	EFI Partitioning (GPT) is enabled
 	EIDE	EIDE/ATAPI support is enabled.
+	EVM	Extended Verification Module
 	FB	The frame buffer device is enabled.
 	GCOV	GCOV profiling is enabled.
 	HW	Appropriate hardware is enabled.
@@ -750,6 +751,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			This option is obsoleted by the "netdev=" option, which
 			has equivalent usage. See its documentation for details.
 
+	evm_mode=	[EVM]
+			Format: { "fix" }
+			Permit 'security.evm' to be updated regardless of
+			current integrity status.
+
 	failslab=
 	fail_page_alloc=
 	fail_make_request=[KNL]
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 3afefff..af9d229 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -38,13 +38,25 @@ char *evm_config_xattrnames[] = {
 	NULL
 };
 
+static int evm_fixmode;
+static int __init evm_set_fixmode(char *str)
+{
+	if (strncmp(str, "fix", 3) == 0)
+		evm_fixmode = 1;
+	return 0;
+}
+__setup("evm_mode=", evm_set_fixmode);
+
 /*
  * evm_verify_hmac - calculate and compare the HMAC with the EVM xattr
  *
  * Compute the HMAC on the dentry's protected set of extended attributes
- * and compare it against the stored security.evm xattr. (For performance,
- * use the previoulsy retrieved xattr value and length to calculate the
- * HMAC.)
+ * and compare it against the stored security.evm xattr.
+ *
+ * For performance:
+ * - use the previoulsy retrieved xattr value and length to calculate the
+ *   HMAC.)
+ * - cache the verification result in the iint, when available.
  *
  * Returns integrity status
  */
@@ -55,9 +67,10 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 					     struct integrity_iint_cache *iint)
 {
 	char hmac_val[MAX_DIGEST_SIZE + 1];
+	enum integrity_status evm_status;
 	int rc;
 
-	if (iint->evm_status == INTEGRITY_PASS)
+	if (iint && iint->evm_status == INTEGRITY_PASS)
 		return iint->evm_status;
 
 	/* if status is not PASS, try to check again - against -ENOMEM */
@@ -73,18 +86,21 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 			   GFP_NOFS);
 	if (rc < 0)
 		goto err_out;
-	iint->evm_status = INTEGRITY_PASS;
-	return iint->evm_status;
+	evm_status = INTEGRITY_PASS;
+	goto out;
 
 err_out:
 	switch (rc) {
 	case -ENODATA:		/* file not labelled */
-		iint->evm_status = INTEGRITY_NOLABEL;
+		evm_status = INTEGRITY_NOLABEL;
 		break;
 	default:
-		iint->evm_status = INTEGRITY_FAIL;
+		evm_status = INTEGRITY_FAIL;
 	}
-	return iint->evm_status;
+out:
+	if (iint)
+		iint->evm_status = evm_status;
+	return evm_status;
 }
 
 static int evm_protected_xattr(const char *req_xattr_name)
@@ -157,6 +173,22 @@ static int evm_protect_xattr(struct dentry *dentry, const char *xattr_name,
 	return 0;
 }
 
+/*
+ * evm_verify_current_integrity - verify the dentry's metadata integrity
+ * @dentry: pointer to the affected dentry
+ *
+ * Verify and return the dentry's metadata integrity. The exceptions are
+ * before EVM is initialized or in 'fix' mode.
+ */
+static enum integrity_status evm_verify_current_integrity(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if (!evm_initialized || !S_ISREG(inode->i_mode) || evm_fixmode)
+		return 0;
+	return evm_verify_hmac(dentry, NULL, NULL, 0, NULL);
+}
+
 /**
  * evm_inode_setxattr - protect the EVM extended attribute
  * @dentry: pointer to the affected dentry
@@ -164,13 +196,22 @@ static int evm_protect_xattr(struct dentry *dentry, const char *xattr_name,
  * @xattr_value: pointer to the new extended attribute value
  * @xattr_value_len: pointer to the new extended attribute value length
  *
- * Prevent 'security.evm' from being modified
+ * Updating 'security.evm' requires CAP_SYS_ADMIN privileges and that
+ * the current value is valid.
  */
 int evm_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		       const void *xattr_value, size_t xattr_value_len)
 {
-	return evm_protect_xattr(dentry, xattr_name, xattr_value,
-				 xattr_value_len);
+
+	enum integrity_status evm_status;
+	int ret;
+
+	ret = evm_protect_xattr(dentry, xattr_name, xattr_value,
+				xattr_value_len);
+	if (ret)
+		return ret;
+	evm_status = evm_verify_current_integrity(dentry);
+	return evm_status == INTEGRITY_PASS ? 0 : -EPERM;
 }
 
 /**
@@ -178,11 +219,19 @@ int evm_inode_setxattr(struct dentry *dentry, const char *xattr_name,
  * @dentry: pointer to the affected dentry
  * @xattr_name: pointer to the affected extended attribute name
  *
- * Prevent 'security.evm' from being removed.
+ * Removing 'security.evm' requires CAP_SYS_ADMIN privileges and that
+ * the current value is valid.
  */
 int evm_inode_removexattr(struct dentry *dentry, const char *xattr_name)
 {
-	return evm_protect_xattr(dentry, xattr_name, NULL, 0);
+	enum integrity_status evm_status;
+	int ret;
+
+	ret = evm_protect_xattr(dentry, xattr_name, NULL, 0);
+	if (ret)
+		return ret;
+	evm_status = evm_verify_current_integrity(dentry);
+	return evm_status == INTEGRITY_PASS ? 0 : -EPERM;
 }
 
 /**
-- 
1.7.3.4

