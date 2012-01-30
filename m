Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2A3WR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:17:58 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60227 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab2A3WRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:17:54 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH v1 9/9] ima: digital signature verification support
Date: Mon, 30 Jan 2012 17:14:04 -0500
Message-Id: <1327961644-6886-10-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12013022-3534-0000-0000-000005092A86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

This patch adds support for digital signature based integrity appraisal.
With this patch, 'security.ima' contains either the file data hash or
a digital signature of the file data hash. The file data hash provides
the security attribute of file integrity. In addition to file integrity,
a digital signature provides the security attribute of authenticity.

Unlike EVM, when the file metadata changes, the digital signature is
replaced with an HMAC, modification of the file data does not cause the
'security.ima' digital signature to be replaced with a hash. As a
result, after any modification, subsequent file integrity appraisals
would fail.

Although digitally signed files can be modified, but by not updating
'security.ima' to reflect these modifications, in essence digitally
signed files could be considered 'immutable'.

IMA uses a different keyring than EVM. While the EVM keyring should not
be updated after initialization and locked, the IMA keyring should allow
updating or adding new keys when upgrading or installing packages.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_appraise.c |   69 ++++++++++++++++++++++++---------
 security/integrity/integrity.h        |    1 +
 2 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 3deb37f..fad87c3 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -65,7 +65,7 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 {
 	struct dentry *dentry = file->f_dentry;
 	struct inode *inode = dentry->d_inode;
-	struct evm_ima_xattr_data xattr_value;
+	struct evm_ima_xattr_data *xattr_value = NULL;
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	const char *op = "appraise_data";
 	char *cause = "unknown";
@@ -76,8 +76,8 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 	if (iint->flags & IMA_APPRAISED)
 		return iint->ima_status;
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_IMA, (u8 *)&xattr_value,
-				   sizeof xattr_value);
+	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)&xattr_value,
+				0, GFP_NOFS);
 	if (rc <= 0) {
 		if (rc && rc != -ENODATA)
 			goto out;
@@ -88,8 +88,7 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 		goto out;
 	}
 
-	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, (u8 *)&xattr_value,
-				 rc, iint);
+	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
 	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
 		if ((status == INTEGRITY_NOLABEL)
 		    || (status == INTEGRITY_NOXATTRS))
@@ -99,30 +98,57 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 		goto out;
 	}
 
-	rc = memcmp(xattr_value.digest, iint->ima_xattr.digest,
-		    IMA_DIGEST_SIZE);
-	if (rc) {
-		status = INTEGRITY_FAIL;
-		cause = "invalid-hash";
-		print_hex_dump_bytes("security.ima: ", DUMP_PREFIX_NONE,
-				     &xattr_value, sizeof xattr_value);
-		print_hex_dump_bytes("collected: ", DUMP_PREFIX_NONE,
-				     (u8 *)&iint->ima_xattr,
-				     sizeof iint->ima_xattr);
-		goto out;
+	switch (xattr_value->type) {
+	case IMA_XATTR_DIGEST:
+		rc = memcmp(xattr_value->digest, iint->ima_xattr.digest,
+			    IMA_DIGEST_SIZE);
+		if (rc) {
+			cause = "invalid-hash";
+			status = INTEGRITY_FAIL;
+			print_hex_dump_bytes("security.ima: ", DUMP_PREFIX_NONE,
+					     xattr_value, sizeof(*xattr_value));
+			print_hex_dump_bytes("collected: ", DUMP_PREFIX_NONE,
+					     (u8 *)&iint->ima_xattr,
+					     sizeof iint->ima_xattr);
+			break;
+		}
+		status = INTEGRITY_PASS;
+		break;
+	case EVM_IMA_XATTR_DIGSIG:
+		iint->flags |= IMA_DIGSIG;
+		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+					     xattr_value->digest, rc - 1,
+					     iint->ima_xattr.digest,
+					     IMA_DIGEST_SIZE);
+		if (rc == -EOPNOTSUPP) {
+			status = INTEGRITY_UNKNOWN;
+		} else if (rc) {
+			cause = "invalid-signature";
+			status = INTEGRITY_FAIL;
+		} else {
+			status = INTEGRITY_PASS;
+		}
+		break;
+	default:
+		status = INTEGRITY_UNKNOWN;
+		cause = "unknown-ima-data";
+		break;
 	}
-	status = INTEGRITY_PASS;
-	iint->flags |= IMA_APPRAISED;
+
 out:
 	if (status != INTEGRITY_PASS) {
-		if (ima_appraise & IMA_APPRAISE_FIX) {
+		if ((ima_appraise & IMA_APPRAISE_FIX) &&
+		    (xattr_value->type != EVM_IMA_XATTR_DIGSIG)) {
 			ima_fix_xattr(dentry, iint);
 			status = INTEGRITY_PASS;
 		}
 		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
 				    op, cause, 1, 0);
+	} else {
+		iint->flags |= IMA_APPRAISED;
 	}
 	iint->ima_status = status;
+	kfree(xattr_value);
 	return status;
 }
 
@@ -134,9 +160,14 @@ void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file)
 	struct dentry *dentry = file->f_dentry;
 	int rc = 0;
 
+	/* do not collect and update hash for digital signatures */
+	if (iint->flags & IMA_DIGSIG)
+		return;
+
 	rc = ima_collect_measurement(iint, file);
 	if (rc < 0)
 		return;
+
 	ima_fix_xattr(dentry, iint);
 }
 
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index c145331..0594a57 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -21,6 +21,7 @@
 #define IMA_APPRAISE		4
 #define IMA_APPRAISED		8
 #define IMA_COLLECTED		16
+#define IMA_DIGSIG		32
 
 enum evm_ima_xattr_type {
 	IMA_XATTR_DIGEST = 0x01,
-- 
1.7.6.5

