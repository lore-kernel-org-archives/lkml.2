Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2CATOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:14:45 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47866 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab2CATOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:14:42 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v2 03/11] ima: integrity appraisal extension
Date: Thu,  1 Mar 2012 14:10:40 -0500
Message-Id: <1330629048-5933-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030119-4242-0000-0000-000000EEF075
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds local measurement integrity appraisal to IMA.  New is the
creation and maintainance of an extended attribute 'security.ima' containing
the file hash measurement.  Protection of the xattr is provided by EVM, if
enabled and configured.

Based on policy, IMA calls evm_verifyxattr() to verify the security.ima
xattr integrity and, assuming success, compares the xattr hash value with
the collected file measurement.

Changelog v2:
- fix audit msg 'res' value
- removed unused 'ima_appraise=' values

Changelog v1:
- removed unused iint mutex (Dmitry Kasatkin)
- setattr hook must not reset appraised (Dmitry Kasatkin)
- evm_verifyxattr() now differentiates between no 'security.evm' xattr
  (INTEGRITY_NOLABEL) and no EVM 'protected' xattrs included in the
  'security.evm' (INTEGRITY_NOXATTRS).
- replace hash_status with ima_status (Dmitry Kasatkin)
- re-initialize slab element ima_status on free (Dmitry Kasatkin)
- include 'security.ima' in EVM if CONFIG_IMA_APPRAISE, not CONFIG_IMA
- merged half "ima: ima_must_appraise_or_measure API change" (Dmitry Kasatkin)
- removed unnecessary error variable in process_measurement() (Dmitry Kasatkin)
- use ima_inode_post_setattr() stub function, if IMA_APPRAISE not configured
  (moved ima_inode_post_setattr() to ima_appraise.c)
- make sure ima_collect_measurement() can read file

Changelog:
- add 'iint' to evm_verifyxattr() call (Dimitry Kasatkin)
- fix the race condition between chmod, which takes the i_mutex and then
  iint->mutex, and ima_file_free() and process_measurement(), which take
  the locks in the reverse order, by eliminating iint->mutex. (Dmitry Kasatkin)
- cleanup of ima_appraise_measurement() (Dmitry Kasatkin)
- changes as a result of the iint not allocated for all regular files, but
  only for those measured/appraised.
- don't try to appraise new/empty files
- expanded ima_appraisal description in ima/Kconfig
- IMA appraise definitions required even if IMA_APPRAISE not enabled
- add return value to ima_must_appraise() stub
- unconditionally set status = INTEGRITY_PASS *after* testing status,
  not before.  (Found by Joe Perches)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 Documentation/kernel-parameters.txt   |    4 +
 include/linux/xattr.h                 |    3 +
 security/integrity/evm/evm_main.c     |    3 +
 security/integrity/iint.c             |    3 +-
 security/integrity/ima/Kconfig        |   15 +++
 security/integrity/ima/Makefile       |    2 +
 security/integrity/ima/ima.h          |   37 +++++++-
 security/integrity/ima/ima_api.c      |   50 +++++++---
 security/integrity/ima/ima_appraise.c |  165 +++++++++++++++++++++++++++++++++
 security/integrity/ima/ima_crypto.c   |    8 ++-
 security/integrity/ima/ima_main.c     |   78 +++++++++++-----
 security/integrity/ima/ima_policy.c   |   32 +++++--
 security/integrity/integrity.h        |    8 +-
 13 files changed, 355 insertions(+), 53 deletions(-)
 create mode 100644 security/integrity/ima/ima_appraise.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 033d4e6..a86765d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1004,6 +1004,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
+	ima_appraise=	[IMA] appraise integrity measurements
+			Format: { "off" | "enforce" | "fix" }
+			default: "enforce"
+
 	ima_audit=	[IMA]
 			Format: { "0" | "1" }
 			0 -- integrity auditing messages. (Default)
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index e5d1220..77a3e68 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -33,6 +33,9 @@
 #define XATTR_EVM_SUFFIX "evm"
 #define XATTR_NAME_EVM XATTR_SECURITY_PREFIX XATTR_EVM_SUFFIX
 
+#define XATTR_IMA_SUFFIX "ima"
+#define XATTR_NAME_IMA XATTR_SECURITY_PREFIX XATTR_IMA_SUFFIX
+
 #define XATTR_SELINUX_SUFFIX "selinux"
 #define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
 
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 8901501..eb54845 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -34,6 +34,9 @@ char *evm_config_xattrnames[] = {
 #ifdef CONFIG_SECURITY_SMACK
 	XATTR_NAME_SMACK,
 #endif
+#ifdef CONFIG_IMA_APPRAISE
+	XATTR_NAME_IMA,
+#endif
 	XATTR_NAME_CAPS,
 	NULL
 };
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index 399641c..e600986 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -74,6 +74,7 @@ static void iint_free(struct integrity_iint_cache *iint)
 {
 	iint->version = 0;
 	iint->flags = 0UL;
+	iint->ima_status = INTEGRITY_UNKNOWN;
 	iint->evm_status = INTEGRITY_UNKNOWN;
 	kmem_cache_free(iint_cache, iint);
 }
@@ -157,7 +158,7 @@ static void init_once(void *foo)
 	memset(iint, 0, sizeof *iint);
 	iint->version = 0;
 	iint->flags = 0UL;
-	mutex_init(&iint->mutex);
+	iint->ima_status = INTEGRITY_UNKNOWN;
 	iint->evm_status = INTEGRITY_UNKNOWN;
 }
 
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 35664fe..b7465a1 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -54,3 +54,18 @@ config IMA_LSM_RULES
 	default y
 	help
 	  Disabling this option will disregard LSM based policy rules.
+
+config IMA_APPRAISE
+	bool "Appraise integrity measurements"
+	depends on IMA
+	default n
+	help
+	  This option enables local measurement integrity appraisal.
+	  It requires the system to be labeled with a security extended
+	  attribute containing the file hash measurement.  To protect
+	  the security extended attributes from offline attack, enable
+	  and configure EVM.
+
+	  For more information on integrity appraisal refer to:
+	  <http://linux-ima.sourceforge.net>
+	  If unsure, say N.
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 5690c02..bd31516 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_IMA) += ima.o
 
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
 	 ima_policy.o ima_audit.o
+
+ima-$(CONFIG_IMA_APPRAISE) += ima_appraise.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 3ccf7ac..d5bf463 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -40,6 +40,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 extern int ima_initialized;
 extern int ima_used_chip;
 extern char *ima_hash;
+extern int ima_appraise;
 
 /* IMA inode template definition */
 struct ima_template_data {
@@ -98,6 +99,7 @@ static inline unsigned long ima_hash_key(u8 *digest)
 }
 
 /* LIM API function definitions */
+int ima_must_appraise_or_measure(struct inode *inode, int mask, int function);
 int ima_must_measure(struct inode *inode, int mask, int function);
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file);
@@ -114,14 +116,45 @@ struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
 struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
 
 /* IMA policy related functions */
-enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK };
+enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK, POST_SETATTR };
 
-int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask);
+int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
+		     int flags);
 void ima_init_policy(void);
 void ima_update_policy(void);
 ssize_t ima_parse_add_rule(char *);
 void ima_delete_rules(void);
 
+/* Appraise integrity measurements */
+#define IMA_APPRAISE_ENFORCE	0x01
+#define IMA_APPRAISE_FIX	0x02
+
+#ifdef CONFIG_IMA_APPRAISE
+int ima_appraise_measurement(struct integrity_iint_cache *iint,
+			     struct file *file, const unsigned char *filename);
+int ima_must_appraise(struct inode *inode, enum ima_hooks func, int mask);
+void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file);
+
+#else
+static inline int ima_appraise_measurement(struct integrity_iint_cache *iint,
+					   struct file *file,
+					   const unsigned char *filename)
+{
+	return INTEGRITY_UNKNOWN;
+}
+
+static inline int ima_must_appraise(struct inode *inode,
+				    enum ima_hooks func, int mask)
+{
+	return 0;
+}
+
+static inline void ima_update_xattr(struct integrity_iint_cache *iint,
+				    struct file *file)
+{
+}
+#endif
+
 /* LSM based policy rules require audit */
 #ifdef CONFIG_IMA_LSM_RULES
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 88a2788..646e92d 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -9,13 +9,17 @@
  * License.
  *
  * File: ima_api.c
- *	Implements must_measure, collect_measurement, store_measurement,
- *	and store_template.
+ *	Implements must_appraise_or_measure, collect_measurement,
+ *	appraise_measurement, store_measurement and store_template.
  */
 #include <linux/module.h>
 #include <linux/slab.h>
-
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/xattr.h>
+#include <linux/evm.h>
 #include "ima.h"
+
 static const char *IMA_TEMPLATE_NAME = "ima";
 
 /*
@@ -93,7 +97,7 @@ err_out:
 }
 
 /**
- * ima_must_measure - measure decision based on policy.
+ * ima_must_appraise_or_measure - appraise & measure decision based on policy.
  * @inode: pointer to inode to measure
  * @mask: contains the permission mask (MAY_READ, MAY_WRITE, MAY_EXECUTE)
  * @function: calling function (FILE_CHECK, BPRM_CHECK, FILE_MMAP)
@@ -105,15 +109,22 @@ err_out:
  * 	mask: contains the permission mask
  *	fsmagic: hex value
  *
- * Return 0 to measure. For matching a DONT_MEASURE policy, no policy,
- * or other error, return an error code.
-*/
-int ima_must_measure(struct inode *inode, int mask, int function)
+ * Returns IMA_MEASURE, IMA_APPRAISE mask.
+ *
+ */
+int ima_must_appraise_or_measure(struct inode *inode, int mask, int function)
 {
-	int must_measure;
+	int flags = IMA_MEASURE | IMA_APPRAISE;
+
+	if (!ima_appraise || !inode->i_op->getxattr)
+		flags &= ~IMA_APPRAISE;
+
+	return ima_match_policy(inode, function, mask, flags);
+}
 
-	must_measure = ima_match_policy(inode, function, mask);
-	return must_measure ? 0 : -EACCES;
+int ima_must_measure(struct inode *inode, int mask, int function)
+{
+	return ima_match_policy(inode, function, mask, IMA_MEASURE);
 }
 
 /*
@@ -129,16 +140,24 @@ int ima_must_measure(struct inode *inode, int mask, int function)
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file)
 {
-	int result = -EEXIST;
+	struct inode *inode = file->f_dentry->d_inode;
+	const char *filename = file->f_dentry->d_name.name;
+	int result = 0;
 
-	if (!(iint->flags & IMA_MEASURED)) {
+	if (!(iint->flags & IMA_COLLECTED)) {
 		u64 i_version = file->f_dentry->d_inode->i_version;
 
 		memset(iint->digest, 0, IMA_DIGEST_SIZE);
 		result = ima_calc_hash(file, iint->digest);
-		if (!result)
+		if (!result) {
 			iint->version = i_version;
+			iint->flags |= IMA_COLLECTED;
+		}
 	}
+	if (result)
+		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
+				    filename, "collect_data", "failed",
+				    result, 0);
 	return result;
 }
 
@@ -167,6 +186,9 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 	struct ima_template_entry *entry;
 	int violation = 0;
 
+	if (iint->flags & IMA_MEASURED)
+		return;
+
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
 		integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
new file mode 100644
index 0000000..17dc55c
--- /dev/null
+++ b/security/integrity/ima/ima_appraise.c
@@ -0,0 +1,165 @@
+/*
+ * Copyright (C) 2011 IBM Corporation
+ *
+ * Author:
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+#include <linux/module.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/xattr.h>
+#include <linux/magic.h>
+#include <linux/ima.h>
+#include <linux/evm.h>
+
+#include "ima.h"
+
+static int __init default_appraise_setup(char *str)
+{
+	if (strncmp(str, "off", 3) == 0)
+		ima_appraise = 0;
+	else if (strncmp(str, "fix", 3) == 0)
+		ima_appraise = IMA_APPRAISE_FIX;
+	return 1;
+}
+
+__setup("ima_appraise=", default_appraise_setup);
+
+/*
+ * ima_must_appraise - set appraise flag
+ *
+ * Return 1 to appraise
+ */
+int ima_must_appraise(struct inode *inode, enum ima_hooks func, int mask)
+{
+	return 0;
+}
+
+static void ima_fix_xattr(struct dentry *dentry,
+			  struct integrity_iint_cache *iint)
+{
+	iint->digest[0] = IMA_XATTR_DIGEST;
+	__vfs_setxattr_noperm(dentry, XATTR_NAME_IMA,
+			      iint->digest, IMA_DIGEST_SIZE + 1, 0);
+}
+
+/*
+ * ima_appraise_measurement - appraise file measurement
+ *
+ * Call evm_verifyxattr() to verify the integrity of 'security.ima'.
+ * Assuming success, compare the xattr hash with the collected measurement.
+ *
+ * Return 0 on success, error code otherwise
+ */
+int ima_appraise_measurement(struct integrity_iint_cache *iint,
+			     struct file *file, const unsigned char *filename)
+{
+	struct dentry *dentry = file->f_dentry;
+	struct inode *inode = dentry->d_inode;
+	u8 xattr_value[IMA_DIGEST_SIZE];
+	enum integrity_status status = INTEGRITY_UNKNOWN;
+	const char *op = "appraise_data";
+	char *cause = "unknown";
+	int rc;
+
+	if (!ima_appraise || !inode->i_op->getxattr)
+		return 0;
+	if (iint->flags & IMA_APPRAISED)
+		return iint->ima_status;
+
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_IMA, xattr_value,
+				   IMA_DIGEST_SIZE);
+	if (rc <= 0) {
+		if (rc && rc != -ENODATA)
+			goto out;
+
+		cause = "missing-hash";
+		status =
+		    (inode->i_size == 0) ? INTEGRITY_PASS : INTEGRITY_NOLABEL;
+		goto out;
+	}
+
+	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc, iint);
+	if ((status != INTEGRITY_PASS) && (status != INTEGRITY_UNKNOWN)) {
+		if ((status == INTEGRITY_NOLABEL)
+		    || (status == INTEGRITY_NOXATTRS))
+			cause = "missing-HMAC";
+		else if (status == INTEGRITY_FAIL)
+			cause = "invalid-HMAC";
+		goto out;
+	}
+
+	rc = memcmp(xattr_value, iint->digest, IMA_DIGEST_SIZE);
+	if (rc) {
+		status = INTEGRITY_FAIL;
+		cause = "invalid-hash";
+		print_hex_dump_bytes("security.ima: ", DUMP_PREFIX_NONE,
+				     xattr_value, IMA_DIGEST_SIZE);
+		print_hex_dump_bytes("collected: ", DUMP_PREFIX_NONE,
+				     iint->digest, IMA_DIGEST_SIZE);
+		goto out;
+	}
+	status = INTEGRITY_PASS;
+	iint->flags |= IMA_APPRAISED;
+out:
+	if (status != INTEGRITY_PASS) {
+		if (ima_appraise & IMA_APPRAISE_FIX) {
+			ima_fix_xattr(dentry, iint);
+			status = INTEGRITY_PASS;
+		}
+		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
+				    op, cause, rc, 0);
+	}
+	iint->ima_status = status;
+	return status;
+}
+
+/*
+ * ima_update_xattr - update 'security.ima' hash value
+ */
+void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file)
+{
+	struct dentry *dentry = file->f_dentry;
+	int rc = 0;
+
+	rc = ima_collect_measurement(iint, file);
+	if (rc < 0)
+		return;
+	ima_fix_xattr(dentry, iint);
+}
+
+/**
+ * ima_inode_post_setattr - reflect file metadata changes
+ * @dentry: pointer to the affected dentry
+ *
+ * Changes to a dentry's metadata might result in needing to appraise.
+ *
+ * This function is called from notify_change(), which expects the caller
+ * to lock the inode's i_mutex.
+ */
+void ima_inode_post_setattr(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct integrity_iint_cache *iint;
+	int must_appraise, rc;
+
+	if (!ima_initialized || !ima_appraise || !S_ISREG(inode->i_mode)
+	    || !inode->i_op->removexattr)
+		return;
+
+	must_appraise = ima_must_appraise(inode, MAY_ACCESS, POST_SETATTR);
+	iint = integrity_iint_find(inode);
+	if (iint) {
+		if (must_appraise)
+			iint->flags |= IMA_APPRAISE;
+		else
+			iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED);
+	}
+	if (!must_appraise)
+		rc = inode->i_op->removexattr(dentry, XATTR_NAME_IMA);
+	return;
+}
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 9b3ade7..b21ee5b 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -48,7 +48,7 @@ int ima_calc_hash(struct file *file, char *digest)
 	struct scatterlist sg[1];
 	loff_t i_size, offset = 0;
 	char *rbuf;
-	int rc;
+	int rc, read = 0;
 
 	rc = init_desc(&desc);
 	if (rc != 0)
@@ -59,6 +59,10 @@ int ima_calc_hash(struct file *file, char *digest)
 		rc = -ENOMEM;
 		goto out;
 	}
+	if (!(file->f_mode & FMODE_READ)) {
+		file->f_mode |= FMODE_READ;
+		read = 1;
+	}
 	i_size = i_size_read(file->f_dentry->d_inode);
 	while (offset < i_size) {
 		int rbuf_len;
@@ -80,6 +84,8 @@ int ima_calc_hash(struct file *file, char *digest)
 	kfree(rbuf);
 	if (!rc)
 		rc = crypto_hash_final(&desc, digest);
+	if (read)
+		file->f_mode &= ~FMODE_READ;
 out:
 	crypto_free_hash(desc.tfm);
 	return rc;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 5b222eb..fba2f7b 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -22,12 +22,19 @@
 #include <linux/mount.h>
 #include <linux/mman.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include <linux/ima.h>
 
 #include "ima.h"
 
 int ima_initialized;
 
+#ifdef CONFIG_IMA_APPRAISE
+int ima_appraise = IMA_APPRAISE_ENFORCE;
+#else
+int ima_appraise;
+#endif
+
 char *ima_hash = "sha1";
 static int __init hash_setup(char *str)
 {
@@ -52,7 +59,7 @@ static void ima_rdwr_violation_check(struct file *file)
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	fmode_t mode = file->f_mode;
-	int rc;
+	int must_measure;
 	bool send_tomtou = false, send_writers = false;
 
 	if (!S_ISREG(inode->i_mode) || !ima_initialized)
@@ -66,8 +73,8 @@ static void ima_rdwr_violation_check(struct file *file)
 		goto out;
 	}
 
-	rc = ima_must_measure(inode, MAY_READ, FILE_CHECK);
-	if (rc < 0)
+	must_measure = ima_must_measure(inode, MAY_READ, FILE_CHECK);
+	if (!must_measure)
 		goto out;
 
 	if (atomic_read(&inode->i_writecount) > 0)
@@ -84,17 +91,21 @@ out:
 }
 
 static void ima_check_last_writer(struct integrity_iint_cache *iint,
-				  struct inode *inode,
-				  struct file *file)
+				  struct inode *inode, struct file *file)
 {
 	fmode_t mode = file->f_mode;
 
-	mutex_lock(&iint->mutex);
-	if (mode & FMODE_WRITE &&
-	    atomic_read(&inode->i_writecount) == 1 &&
-	    iint->version != inode->i_version)
-		iint->flags &= ~IMA_MEASURED;
-	mutex_unlock(&iint->mutex);
+	if (!(mode & FMODE_WRITE))
+		return;
+
+	mutex_lock(&inode->i_mutex);
+	if (atomic_read(&inode->i_writecount) == 1 &&
+	    iint->version != inode->i_version) {
+		iint->flags &= ~(IMA_COLLECTED | IMA_APPRAISED | IMA_MEASURED);
+		if (iint->flags & IMA_APPRAISE)
+			ima_update_xattr(iint, file);
+	}
+	mutex_unlock(&inode->i_mutex);
 }
 
 /**
@@ -123,14 +134,17 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct integrity_iint_cache *iint;
-	int rc = 0;
+	int rc = -ENOMEM, action, must_appraise;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return 0;
 
-	rc = ima_must_measure(inode, mask, function);
-	if (rc != 0)
-		return rc;
+	/* Determine if in appraise/measurement policy,
+	 * returns IMA_MEASURE, IMA_APPRAISE bitmask.  */
+	action = ima_must_appraise_or_measure(inode, mask, function);
+	if (!action)
+		return 0;
+
 retry:
 	iint = integrity_iint_find(inode);
 	if (!iint) {
@@ -140,18 +154,32 @@ retry:
 		return rc;
 	}
 
-	mutex_lock(&iint->mutex);
+	must_appraise = action & IMA_APPRAISE;
 
-	rc = iint->flags & IMA_MEASURED ? 1 : 0;
-	if (rc != 0)
+	mutex_lock(&inode->i_mutex);
+
+	/* Determine if already appraised/measured based on bitmask
+	 * (IMA_MEASURE, IMA_MEASURED, IMA_APPRAISE, IMA_APPRAISED) */
+	iint->flags |= action;
+	action &= ~((iint->flags & (IMA_MEASURED | IMA_APPRAISED)) >> 1);
+
+	/* Nothing to do, just return existing appraised status */
+	if (!action) {
+		if (iint->flags & IMA_APPRAISED)
+			rc = iint->ima_status;
 		goto out;
+	}
 
 	rc = ima_collect_measurement(iint, file);
-	if (!rc)
+	if (rc != 0)
+		goto out;
+	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, filename);
+	if (action & IMA_APPRAISE)
+		rc = ima_appraise_measurement(iint, file, filename);
 out:
-	mutex_unlock(&iint->mutex);
-	return rc;
+	mutex_unlock(&inode->i_mutex);
+	return (rc && must_appraise) ? -EACCES : 0;
 }
 
 /**
@@ -167,14 +195,14 @@ out:
  */
 int ima_file_mmap(struct file *file, unsigned long prot)
 {
-	int rc;
+	int rc = 0;
 
 	if (!file)
 		return 0;
 	if (prot & PROT_EXEC)
 		rc = process_measurement(file, file->f_dentry->d_name.name,
 					 MAY_EXEC, FILE_MMAP);
-	return 0;
+	return (ima_appraise & IMA_APPRAISE_ENFORCE) ? rc : 0;
 }
 EXPORT_SYMBOL_GPL(ima_file_mmap);
 
@@ -197,7 +225,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
 
 	rc = process_measurement(bprm->file, bprm->filename,
 				 MAY_EXEC, BPRM_CHECK);
-	return 0;
+	return (ima_appraise & IMA_APPRAISE_ENFORCE) ? rc : 0;
 }
 
 /**
@@ -218,7 +246,7 @@ int ima_file_check(struct file *file, int mask)
 	rc = process_measurement(file, file->f_dentry->d_name.name,
 				 mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
 				 FILE_CHECK);
-	return 0;
+	return (ima_appraise & IMA_APPRAISE_ENFORCE) ? rc : 0;
 }
 EXPORT_SYMBOL_GPL(ima_file_check);
 
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d8edff2..8ee301c 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -25,7 +25,13 @@
 #define IMA_FSMAGIC	0x0004
 #define IMA_UID		0x0008
 
-enum ima_action { UNKNOWN = -1, DONT_MEASURE = 0, MEASURE };
+#define UNKNOWN			0
+#define MEASURE			1	/* same as IMA_MEASURE */
+#define DONT_MEASURE		2
+#define MEASURE_MASK		3
+#define APPRAISE		4	/* same as IMA_APPRAISE */
+#define DONT_APPRAISE		8
+#define APPRAISE_MASK		12
 
 #define MAX_LSM_RULES 6
 enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
@@ -34,7 +40,7 @@ enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
 
 struct ima_measure_rule_entry {
 	struct list_head list;
-	enum ima_action action;
+	int action;
 	unsigned int flags;
 	enum ima_hooks func;
 	int mask;
@@ -161,18 +167,28 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
  * as elements in the list are never deleted, nor does the list
  * change.)
  */
-int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
+int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask,
+		     int flags)
 {
 	struct ima_measure_rule_entry *entry;
+	int action = 0, actmask = flags | (flags << 1);
 
 	list_for_each_entry(entry, ima_measure, list) {
-		bool rc;
 
-		rc = ima_match_rules(entry, inode, func, mask);
-		if (rc)
-			return entry->action;
+		if (!(entry->action & actmask))
+			continue;
+
+		if (!ima_match_rules(entry, inode, func, mask))
+			continue;
+
+		action |= (entry->action & (IMA_APPRAISE | IMA_MEASURE));
+		actmask &= (entry->action & APPRAISE_MASK) ?
+		    ~APPRAISE_MASK : ~MEASURE_MASK;
+		if (!actmask)
+			break;
 	}
-	return 0;
+
+	return action;
 }
 
 /**
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 7a25ece..295702d 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -16,7 +16,11 @@
 #include <crypto/sha.h>
 
 /* iint cache flags */
-#define IMA_MEASURED		0x01
+#define IMA_MEASURE		1
+#define IMA_MEASURED		2
+#define IMA_APPRAISE		4
+#define IMA_APPRAISED		8
+#define IMA_COLLECTED		16
 
 enum evm_ima_xattr_type {
 	IMA_XATTR_DIGEST = 0x01,
@@ -36,7 +40,7 @@ struct integrity_iint_cache {
 	u64 version;		/* track inode changes */
 	unsigned char flags;
 	u8 digest[SHA1_DIGEST_SIZE];
-	struct mutex mutex;	/* protects: version, flags, digest */
+	enum integrity_status ima_status;
 	enum integrity_status evm_status;
 };
 
-- 
1.7.6.5

