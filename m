Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2A3WS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:18:28 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42937 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab2A3WSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:18:23 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Safford <safford@watson.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [RFC][PATCH v1 8/9] ima: add support for different security.ima data types
Date: Mon, 30 Jan 2012 17:14:03 -0500
Message-Id: <1327961644-6886-9-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1327961644-6886-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12013022-8974-0000-0000-000005B796A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA-appraisal currently verifies the integrity of a file based on a
known 'good' measurement value.  This patch reserves the first byte
of 'security.ima' as a place holder for the type of method used for
verifying file data integrity.

Changelog v1:
- Use the newly defined 'struct evm_ima_xattr_data'

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_api.c      |    6 +++---
 security/integrity/ima/ima_appraise.c |   23 +++++++++++++----------
 security/integrity/integrity.h        |    2 +-
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index d73b13e..e1f6019 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -147,8 +147,8 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	if (!(iint->flags & IMA_COLLECTED)) {
 		u64 i_version = file->f_dentry->d_inode->i_version;
 
-		memset(iint->digest, 0, IMA_DIGEST_SIZE);
-		result = ima_calc_hash(file, iint->digest);
+		iint->ima_xattr.type = IMA_XATTR_DIGEST;
+		result = ima_calc_hash(file, iint->ima_xattr.digest);
 		if (!result) {
 			iint->version = i_version;
 			iint->flags |= IMA_COLLECTED;
@@ -195,7 +195,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 		return;
 	}
 	memset(&entry->template, 0, sizeof(entry->template));
-	memcpy(entry->template.digest, iint->digest, IMA_DIGEST_SIZE);
+	memcpy(entry->template.digest, iint->ima_xattr.digest, IMA_DIGEST_SIZE);
 	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
 
 	result = ima_store_template(entry, violation, inode);
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 5fd90fc..3deb37f 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -47,9 +47,9 @@ int ima_must_appraise(struct inode *inode, enum ima_hooks func, int mask)
 static void ima_fix_xattr(struct dentry *dentry,
 			  struct integrity_iint_cache *iint)
 {
-	iint->digest[0] = IMA_XATTR_DIGEST;
-	__vfs_setxattr_noperm(dentry, XATTR_NAME_IMA,
-			      iint->digest, IMA_DIGEST_SIZE + 1, 0);
+	iint->ima_xattr.type = IMA_XATTR_DIGEST;
+	__vfs_setxattr_noperm(dentry, XATTR_NAME_IMA, (u8 *)&iint->ima_xattr,
+			      sizeof iint->ima_xattr, 0);
 }
 
 /*
@@ -65,7 +65,7 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 {
 	struct dentry *dentry = file->f_dentry;
 	struct inode *inode = dentry->d_inode;
-	u8 xattr_value[IMA_DIGEST_SIZE];
+	struct evm_ima_xattr_data xattr_value;
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	const char *op = "appraise_data";
 	char *cause = "unknown";
@@ -76,8 +76,8 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 	if (iint->flags & IMA_APPRAISED)
 		return iint->ima_status;
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_IMA, xattr_value,
-				   IMA_DIGEST_SIZE);
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_IMA, (u8 *)&xattr_value,
+				   sizeof xattr_value);
 	if (rc <= 0) {
 		if (rc && rc != -ENODATA)
 			goto out;
@@ -88,7 +88,8 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 		goto out;
 	}
 
-	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
+	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, (u8 *)&xattr_value,
+				 rc, iint);
 	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
 		if ((status == INTEGRITY_NOLABEL)
 		    || (status == INTEGRITY_NOXATTRS))
@@ -98,14 +99,16 @@ int ima_appraise_measurement(struct integrity_iint_cache *iint,
 		goto out;
 	}
 
-	rc = memcmp(xattr_value, iint->digest, IMA_DIGEST_SIZE);
+	rc = memcmp(xattr_value.digest, iint->ima_xattr.digest,
+		    IMA_DIGEST_SIZE);
 	if (rc) {
 		status = INTEGRITY_FAIL;
 		cause = "invalid-hash";
 		print_hex_dump_bytes("security.ima: ", DUMP_PREFIX_NONE,
-				     xattr_value, IMA_DIGEST_SIZE);
+				     &xattr_value, sizeof xattr_value);
 		print_hex_dump_bytes("collected: ", DUMP_PREFIX_NONE,
-				     iint->digest, IMA_DIGEST_SIZE);
+				     (u8 *)&iint->ima_xattr,
+				     sizeof iint->ima_xattr);
 		goto out;
 	}
 	status = INTEGRITY_PASS;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 295702d..c145331 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -39,7 +39,7 @@ struct integrity_iint_cache {
 	struct inode *inode;	/* back pointer to inode in question */
 	u64 version;		/* track inode changes */
 	unsigned char flags;
-	u8 digest[SHA1_DIGEST_SIZE];
+	struct evm_ima_xattr_data ima_xattr;
 	enum integrity_status ima_status;
 	enum integrity_status evm_status;
 };
-- 
1.7.6.5

