Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1EPOqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:46:31 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33722 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab1EPOq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:46:27 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v5 04/21] evm: add support for different security.evm data types
Date: Mon, 16 May 2011 10:44:58 -0400
Message-Id: <1305557115-15652-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

EVM protects a file's security extended attributes(xattrs) against integrity
attacks. The current patchset maintains an HMAC-sha1 value across the security
xattrs, storing the value as the extended attribute 'security.evm'. We
anticipate other methods for protecting the security extended attributes.
This patch reserves the first byte of 'security.evm' as a place holder for
the type of method.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/integrity.h           |    6 ++++++
 security/integrity/evm/evm_crypto.c |   10 ++++++----
 security/integrity/evm/evm_main.c   |    5 +++--
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index e715a2a..6659757 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -19,6 +19,12 @@ enum integrity_status {
 	INTEGRITY_UNKNOWN,
 };
 
+enum evm_ima_xattr_type {
+	IMA_XATTR_DIGEST = 0x01,
+	EVM_XATTR_HMAC,
+	EVM_IMA_XATTR_DIGSIG,
+};
+
 #ifdef CONFIG_INTEGRITY
 extern int integrity_inode_alloc(struct inode *inode);
 extern void integrity_inode_free(struct inode *inode);
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index c43be5a..644df7e 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -138,14 +138,16 @@ int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 			const char *xattr_value, size_t xattr_value_len)
 {
 	struct inode *inode = dentry->d_inode;
-	u8 hmac[MAX_DIGEST_SIZE];
+	u8 hmac[MAX_DIGEST_SIZE + 1];
 	int rc = 0;
 
 	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
-			   xattr_value_len, hmac);
-	if (rc == 0)
+			   xattr_value_len, hmac + 1);
+	if (rc == 0) {
+		hmac[0] = EVM_XATTR_HMAC;
 		rc = __vfs_setxattr_noperm(dentry, XATTR_NAME_EVM,
-					   hmac, evm_hmac_size, 0);
+					   hmac, evm_hmac_size + 1, 0);
+	}
 	else if (rc == -ENODATA)
 		rc = inode->i_op->removexattr(dentry, XATTR_NAME_EVM);
 	return rc;
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 66d7544..42c792f 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -52,7 +52,7 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 					     size_t xattr_value_len,
 					     struct integrity_iint_cache *iint)
 {
-	char hmac_val[MAX_DIGEST_SIZE];
+	char hmac_val[MAX_DIGEST_SIZE + 1];
 	int rc;
 
 	if (iint->hmac_status != INTEGRITY_UNKNOWN)
@@ -60,10 +60,11 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 
 	memset(hmac_val, 0, sizeof hmac_val);
 	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
-			   xattr_value_len, hmac_val);
+			   xattr_value_len, hmac_val + 1);
 	if (rc < 0)
 		return INTEGRITY_UNKNOWN;
 
+	hmac_val[0] = EVM_XATTR_HMAC;
 	rc = vfs_xattr_cmp(dentry, XATTR_NAME_EVM, hmac_val, sizeof hmac_val,
 			   GFP_NOFS);
 	if (rc < 0)
-- 
1.7.3.4

