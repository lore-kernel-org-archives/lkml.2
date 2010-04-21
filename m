Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0DUVvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:51:47 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50954 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab0DUVvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:51:44 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 11/14] ima: integrity appraisal extension
Date: Wed, 21 Apr 2010 17:49:51 -0400
Message-Id: <1271886594-3719-12-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds local measurement integrity appraisal to IMA. (Taken
from the original EVM postings.) New is the creation and maintainance
of an extended attribute 'security.ima' containing the file hash
measurement.  Protection of the xattr is provided by EVM, if enabled
and configured.

Based on policy, IMA calls evm_verifyxattr() to verify the security.ima
xattr integrity and, assuming success, compares the xattr hash value with
the collected file measurement.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 23f95ea..26eecc9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -962,6 +962,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	ihash_entries=	[KNL]
 			Set number of hash buckets for inode cache.
 
+	ima_appraise=	[IMA] appraise integrity measurements
+			Format: { "off" | "enforce" | "log" | "fix" }
+			default: "enforce"
+
 	ima_audit=	[IMA]
 			Format: { "0" | "1" }
 			0 -- integrity auditing messages. (Default)
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index e90377e..4f6608f 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -37,6 +37,9 @@
 #define XATTR_EVM_SUFFIX "evm"
 #define XATTR_NAME_EVM XATTR_SECURITY_PREFIX XATTR_EVM_SUFFIX
 
+#define XATTR_IMA_SUFFIX "ima"
+#define XATTR_NAME_IMA XATTR_SECURITY_PREFIX XATTR_IMA_SUFFIX
+
 #define XATTR_SELINUX_SUFFIX "selinux"
 #define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
 
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index acc5176..278e0de 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -32,6 +32,9 @@ char *evm_config_xattrnames[] = {
 #ifdef CONFIG_SECURITY_SMACK
 	XATTR_NAME_SMACK,
 #endif
+#ifdef CONFIG_IMA
+	XATTR_NAME_IMA,
+#endif
 	XATTR_NAME_CAPS,
 	NULL
 };
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index 66013f2..b182ce5 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -137,6 +137,7 @@ static void init_once(void *foo)
 	iint->readcount = 0;
 	iint->writecount = 0;
 	iint->opencount = 0;
+	iint->hash_status = INTEGRITY_UNKNOWN;
 	iint->hmac_status = INTEGRITY_UNKNOWN;
 	kref_init(&iint->refcount);
 }
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index dc60e40..39abced 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -55,3 +55,17 @@ config IMA_LSM_RULES
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
+	  To protect extended attributes from offline attack, enable
+	  and configure EVM.
+
+	  For more information on integrity appraisal refer to:
+	  <http://linux-ima.sourceforge.net>
+	  If unsure, say N.
+
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
index a58ac9f..aabd615 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -37,9 +37,11 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 #define IMA_MEASURE_HTABLE_SIZE (1 << IMA_HASH_BITS)
 
 /* set during initialization */
+extern char *ima_xattr_name;
 extern int ima_initialized;
 extern int ima_used_chip;
 extern char *ima_hash;
+extern int ima_appraise;
 
 /* IMA inode template definition */
 struct ima_template_data {
@@ -97,8 +99,9 @@ static inline unsigned long ima_hash_key(u8 *digest)
 }
 
 /* LIM API function definitions */
-int ima_must_measure(struct integrity_iint_cache *iint, struct inode *inode,
-		     int mask, int function);
+int ima_must_appraise_or_measure(struct integrity_iint_cache *iint,
+				 struct inode *inode, int mask, int function,
+				 int *must_measure, int *must_appraise);
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file);
 void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
@@ -116,7 +119,7 @@ void iint_free(struct kref *kref);
 void iint_rcu_free(struct rcu_head *rcu);
 
 /* IMA policy related functions */
-enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK };
+enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK, POST_SETATTR };
 
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask);
 void ima_init_policy(void);
@@ -124,6 +127,39 @@ void ima_update_policy(void);
 ssize_t ima_parse_add_rule(char *);
 void ima_delete_rules(void);
 
+/* Appraise integrity measurements */
+#ifdef CONFIG_IMA_APPRAISE
+#define IMA_APPRAISE_ENABLED	0x01
+#define IMA_APPRAISE_ENFORCE	0x02
+#define IMA_APPRAISE_LOG	0x04
+#define IMA_APPRAISE_FIX	0x08
+
+int ima_appraise_measurement(struct integrity_iint_cache *iint,
+			     struct file *file, const unsigned char *filename);
+int ima_must_appraise(struct integrity_iint_cache *iint, struct inode *inode,
+		      enum ima_hooks func, int mask);
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
+static inline int ima_must_appraise(struct integrity_iint_cache *iint,
+				    struct inode *inode,
+				    enum ima_hooks func, int mask)
+{
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
index bb307fb..8c5375c 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -9,12 +9,17 @@
  * License.
  *
  * File: ima_api.c
- *	Implements must_measure, collect_measurement, store_measurement,
- *	and store_template.
+ *	Implements must_appraise_or_measure, collect_measurement,
+ *	 appraise_measurement, 	store_measurement and store_template.
  */
 #include <linux/module.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/xattr.h>
+#include <linux/evm.h>
 
 #include "ima.h"
+
 static const char *IMA_TEMPLATE_NAME = "ima";
 
 /*
@@ -92,10 +97,12 @@ err_out:
 }
 
 /**
- * ima_must_measure - measure decision based on policy.
+ * ima_must_appraise_or_measure - appraise & measure decision based on policy.
  * @inode: pointer to inode to measure
  * @mask: contains the permission mask (MAY_READ, MAY_WRITE, MAY_EXECUTE)
  * @function: calling function (FILE_CHECK, BPRM_CHECK, FILE_MMAP)
+ * @must_measure: pointer to measure flag
+ * @must_appraise: pointer to appraise flag
  *
  * The policy is defined in terms of keypairs:
  * 		subj=, obj=, type=, func=, mask=, fsmagic=
@@ -106,20 +113,32 @@ err_out:
  *
  * Must be called with iint->mutex held.
  *
- * Return 0 to measure. Return 1 if already measured.
+ * Set must_appraise to 1 to appraise measurement.
+ * Set must_measure to 1 to add to measurement list.
+ *
  * For matching a DONT_MEASURE policy, no policy, or other
- * error, return an error code.
+ * error, return an error code, otherwise 0.
 */
-int ima_must_measure(struct integrity_iint_cache *iint, struct inode *inode,
-		     int mask, int function)
+int ima_must_appraise_or_measure(struct integrity_iint_cache *iint,
+				 struct inode *inode, int mask, int function,
+				 int *must_measure, int *must_appraise)
 {
-	int must_measure;
+	int rc;
 
-	if (iint->flags & IMA_MEASURED)
-		return 1;
+	if (must_appraise)
+		*must_appraise = ima_must_appraise(iint, inode, function, mask);
 
-	must_measure = ima_match_policy(inode, function, mask);
-	return must_measure ? 0 : -EACCES;
+	if (iint->flags & IMA_MEASURED) {
+		if (must_measure)
+			*must_measure = 0;
+		return 0;
+	}
+	rc = ima_match_policy(inode, function, mask);
+	if (rc)
+		iint->flags |= IMA_MEASURE;
+	if (must_measure)
+		*must_measure = rc ? 1 : 0;
+	return rc ? 0 : -EACCES;
 }
 
 /*
@@ -135,15 +154,17 @@ int ima_must_measure(struct integrity_iint_cache *iint, struct inode *inode,
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file)
 {
-	int result = -EEXIST;
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
 	return result;
 }
@@ -173,6 +194,9 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
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
index 0000000..0afb1b4
--- /dev/null
+++ b/security/integrity/ima/ima_appraise.c
@@ -0,0 +1,140 @@
+#include <linux/module.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/xattr.h>
+#include <linux/magic.h>
+#include <linux/evm.h>
+
+#include "ima.h"
+
+static int __init default_appraise_setup(char *str)
+{
+	if (strncmp(str, "off", 3) == 0)
+		ima_appraise = 0;
+	else if (strncmp(str, "log", 3) == 0)
+		ima_appraise = IMA_APPRAISE_ENABLED | IMA_APPRAISE_LOG;
+	else if (strncmp(str, "fix", 3) == 0)
+		ima_appraise = IMA_APPRAISE_ENABLED | IMA_APPRAISE_FIX;
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
+int ima_must_appraise(struct integrity_iint_cache *iint, struct inode *inode,
+		      enum ima_hooks func, int mask)
+{
+	return 0;
+}
+
+static void ima_fix_xattr(struct dentry *dentry,
+			  struct integrity_iint_cache *iint)
+{
+	__vfs_setxattr_noperm(dentry, XATTR_NAME_IMA,
+			      iint->digest, IMA_DIGEST_SIZE, 0);
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
+		return iint->hash_status;
+
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_IMA, xattr_value,
+				   IMA_DIGEST_SIZE);
+	if (rc < 0)
+		goto err_out;
+	status = evm_verifyxattr(dentry, XATTR_NAME_IMA, xattr_value, rc);
+	if ((rc > 0)
+	    && ((status == INTEGRITY_PASS) || (status == INTEGRITY_UNKNOWN))) {
+		if (memcmp(xattr_value, iint->digest, IMA_DIGEST_SIZE) != 0) {
+			status = INTEGRITY_FAIL;
+			cause = "invalid-hash";
+			print_hex_dump_bytes("security.ima: ", DUMP_PREFIX_NONE,
+					     xattr_value, IMA_DIGEST_SIZE);
+			print_hex_dump_bytes("collected: ", DUMP_PREFIX_NONE,
+					     iint->digest, IMA_DIGEST_SIZE);
+			if (ima_appraise & IMA_APPRAISE_FIX)
+				ima_fix_xattr(dentry, iint);
+			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
+					    filename, op, cause, 1, 0);
+		} else {
+			status = INTEGRITY_PASS;
+
+			if ((status == INTEGRITY_UNKNOWN)
+			    && (ima_appraise & IMA_APPRAISE_FIX))
+				ima_fix_xattr(dentry, iint);
+		}
+		iint->flags |= IMA_APPRAISED;
+	} else {
+		if (status == INTEGRITY_NOLABEL)
+			cause = "missing-HMAC";
+		else if (status == INTEGRITY_FAIL)
+			cause = "invalid-HMAC";
+
+		if (ima_appraise & IMA_APPRAISE_FIX)
+			ima_fix_xattr(dentry, iint);
+		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
+				    op, cause, 1, 0);
+	}
+	iint->hash_status = status;
+	return status;
+err_out:
+	if (rc == -ENODATA) {
+		if (iint->version == 1)
+			return 0;
+		cause = "missing-hash";
+		if (ima_appraise & IMA_APPRAISE_FIX)
+			ima_fix_xattr(dentry, iint);
+		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
+				    op, cause, 1, 0);
+		iint->hash_status = INTEGRITY_NOLABEL;
+		return iint->hash_status;
+	}
+	printk(KERN_INFO "%s: %d %s\n", __func__, rc, filename);
+	return 0;
+}
+
+/*
+ * ima_update_xattr - update 'security.ima' hash value
+ */
+void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file)
+{
+	struct dentry *dentry = file->f_dentry;
+	int read = 0;
+	int rc = 0;
+
+	if (!(file->f_mode & FMODE_READ)) {
+		file->f_mode |= FMODE_READ;
+		read = 1;
+	}
+	rc = ima_collect_measurement(iint, file);
+	if (read)
+		file->f_mode &= ~FMODE_READ;
+	if (rc < 0)
+		return;
+	__vfs_setxattr_noperm(dentry, XATTR_NAME_IMA,
+			      iint->digest, IMA_DIGEST_SIZE, 0);
+}
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 7eeb76e..635a3be 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -22,11 +22,18 @@
 #include <linux/binfmts.h>
 #include <linux/mount.h>
 #include <linux/mman.h>
+#include <linux/xattr.h>
 
 #include "ima.h"
 
 int ima_initialized;
 
+#ifdef CONFIG_IMA_APPRAISE
+int ima_appraise = IMA_APPRAISE_ENABLED | IMA_APPRAISE_ENFORCE;
+#else
+int ima_appraise;
+#endif
+
 char *ima_hash = "sha1";
 static int __init hash_setup(char *str)
 {
@@ -154,7 +161,8 @@ void ima_counts_get(struct file *file)
 	if (!iint)
 		return;
 	mutex_lock(&iint->mutex);
-	rc = ima_must_measure(iint, inode, MAY_READ, FILE_CHECK);
+	rc = ima_must_appraise_or_measure(iint, inode, MAY_READ, FILE_CHECK,
+					  NULL, NULL);
 	if (rc < 0)
 		goto out;
 
@@ -185,8 +193,12 @@ static void ima_dec_counts(struct integrity_iint_cache *iint,
 	if (mode & FMODE_WRITE) {
 		iint->writecount--;
 		if (iint->writecount == 0) {
-			if (iint->version != inode->i_version)
-				iint->flags &= ~IMA_MEASURED;
+			if (iint->version != inode->i_version) {
+				iint->flags &= ~(IMA_COLLECTED | IMA_APPRAISED
+						 | IMA_MEASURED);
+				if (iint->flags & IMA_APPRAISE)
+					ima_update_xattr(iint, file);
+			}
 		}
 	}
 
@@ -199,6 +211,7 @@ static void ima_dec_counts(struct integrity_iint_cache *iint,
 		       iint->opencount);
 		dump_stack();
 	}
+	return;
 }
 
 /**
@@ -230,7 +243,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct integrity_iint_cache *iint;
-	int rc;
+	int rc, err = 0, must_measure, must_appraise;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return 0;
@@ -239,17 +252,25 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 		return -ENOMEM;
 
 	mutex_lock(&iint->mutex);
-	rc = ima_must_measure(iint, inode, mask, function);
-	if (rc != 0)
+	rc = ima_must_appraise_or_measure(iint, inode, mask, function,
+					  &must_measure, &must_appraise);
+	if (!must_measure && !must_appraise) {
+		if (iint->flags & IMA_APPRAISED)
+			err = iint->hash_status;
 		goto out;
+	}
 
 	rc = ima_collect_measurement(iint, file);
-	if (!rc)
+	if (rc != 0)
+		goto out;
+	if (must_measure)
 		ima_store_measurement(iint, file, filename);
+	if (must_appraise)
+		err = ima_appraise_measurement(iint, file, filename);
 out:
 	mutex_unlock(&iint->mutex);
 	kref_put(&iint->refcount, iint_free);
-	return rc;
+	return (!err) ? 0 : -EACCES;
 }
 
 /**
@@ -265,14 +286,14 @@ out:
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
 
 /**
@@ -294,7 +315,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
 
 	rc = process_measurement(bprm->file, bprm->filename,
 				 MAY_EXEC, BPRM_CHECK);
-	return 0;
+	return (ima_appraise & IMA_APPRAISE_ENFORCE) ? rc : 0;
 }
 
 /**
@@ -314,10 +335,41 @@ int ima_file_check(struct file *file, int mask)
 	rc = process_measurement(file, file->f_dentry->d_name.name,
 				 mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
 				 FILE_CHECK);
-	return 0;
+	return (ima_appraise & IMA_APPRAISE_ENFORCE) ? rc : 0;
 }
 EXPORT_SYMBOL_GPL(ima_file_check);
 
+/**
+ * ima_inode_post_setattr - reflect file metadata changes
+ * @dentry: pointer to the affected dentry
+ *
+ * Changes to a dentry's metadata might result in needing to appraise
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
+	iint = integrity_iint_find_get(inode);
+	if (!iint)
+		return;
+
+	mutex_lock(&iint->mutex);
+	iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED);
+	must_appraise = ima_must_appraise(iint, inode, MAY_ACCESS,
+					  POST_SETATTR);
+	if (!must_appraise)
+		rc = inode->i_op->removexattr(dentry, XATTR_NAME_IMA);
+	mutex_unlock(&iint->mutex);
+	kref_put(&iint->refcount, iint_free);
+	return;
+}
+
 static int __init init_ima(void)
 {
 	int error;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index c83e475..3a9b3de 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -18,13 +18,18 @@
 #define MAX_DIGEST_SIZE SHA1_DIGEST_SIZE
 
 /* iint cache flags */
-#define IMA_MEASURED		1
+#define IMA_MEASURE		1
+#define IMA_MEASURED		2
+#define IMA_APPRAISE		4
+#define IMA_APPRAISED		8
+#define IMA_COLLECTED		16
 
 /* integrity data associated with an inode */
 struct integrity_iint_cache {
 	u64 version;		/* track inode changes */
 	unsigned long flags;
 	u8 digest[MAX_DIGEST_SIZE];
+	enum integrity_status hash_status;
 	struct mutex mutex;	/* protects: version, flags, digest */
 	long readcount;		/* measured files readcount */
 	long writecount;	/* measured files writecount */
-- 
1.6.6.1

