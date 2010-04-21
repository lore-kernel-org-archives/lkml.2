Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0DUVvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:51:11 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50738 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab0DUVu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:50:59 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 04/14] evm: re-release
Date: Wed, 21 Apr 2010 17:49:44 -0400
Message-Id: <1271886594-3719-5-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EVM protects a file's security extended attributes against integrity
attacks. It maintains an HMAC-sha1 value across the extended attributes,
storing the value as the extended attribute 'security.evm'. EVM has gone
through a number of iterations, initially as an LSM module, subsequently
as a LIM integrity provider, and now, when co-located with a security_
hook, embedded directly in the security_ hook, similar to IMA.

This is the first part of a local file integrity verification system.
While this part does authenticate the selected extended attributes, and
cryptographically bind them to the inode, coming extensions will bind
other directory and inode metadata for more complete protection.  The
set of protected security extended attributes is configured at compile.

EVM depends on the Kernel Key Retention System to provide it with the
kernel master key for the HMAC operation.  The kernel master key is
securely loaded onto the root's keyring, typically by 'loadkernkey',
which either uses the TPM sealed secret key, if available, or a
password requested from the console.  To signal EVM, that the key has
been loaded onto the keyring, 'echo 1 > <securityfs>/evm'. This is
normally done in the initrd, which has already been measured as part
of the trusted boot. (Refer to http://linux-ima.sourceforge.net/#EVM.)

EVM adds the following three calls to the existing security hooks,
evm_inode_setxattr(), evm_inode_post_setxattr(), and
evm_inode_removexattr.

To initialize and update the 'security.evm' extended attribute, EVM
defines three calls: evm_inode_post_init(), evm_inode_post_setattr()
and evm_inode_post_removexattr() hooks.

To verify the integrity of an extended attribute, EVM exports
evm_verifyxattr().

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index 276081f..fa9c199 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -10,6 +10,13 @@
 #ifndef _LINUX_INTEGRITY_H
 #define _LINUX_INTEGRITY_H
 
+enum integrity_status {
+	INTEGRITY_PASS = 0,
+	INTEGRITY_FAIL,
+	INTEGRITY_NOLABEL,
+	INTEGRITY_UNKNOWN,
+};
+
 #ifdef CONFIG_INTEGRITY
 extern int integrity_inode_alloc(struct inode *inode);
 extern void integrity_inode_free(struct inode *inode);
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 8698de3..d1afa51 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -34,6 +34,9 @@
 #define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)
 
 /* Security namespace */
+#define XATTR_EVM_SUFFIX "evm"
+#define XATTR_NAME_EVM XATTR_SECURITY_PREFIX XATTR_EVM_SUFFIX
+
 #define XATTR_SELINUX_SUFFIX "selinux"
 #define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
 
diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 2704691..4bf00ac 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -1,6 +1,7 @@
 #
 config INTEGRITY
 	def_bool y
-	depends on IMA
+	depends on IMA || EVM
 
 source security/integrity/ima/Kconfig
+source security/integrity/evm/Kconfig
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index 6eddd61..0ae44ae 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -8,3 +8,5 @@ integrity-y := iint.o
 
 subdir-$(CONFIG_IMA)			+= ima
 obj-$(CONFIG_IMA)			+= ima/built-in.o
+subdir-$(CONFIG_EVM)			+= evm
+obj-$(CONFIG_EVM)			+= evm/built-in.o
diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
new file mode 100644
index 0000000..8a546f7
--- /dev/null
+++ b/security/integrity/evm/Kconfig
@@ -0,0 +1,13 @@
+config EVM
+	boolean "EVM support"
+	depends on SECURITY && KEYS
+	select CRYPTO_HMAC
+	select CRYPTO_MD5
+	select CRYPTO_SHA1
+	default n
+	help
+	  A configurable set of security extended attributes are HMAC
+	  protected against modification using the TPM's kernel root key,
+	  if configured, or with a pass-phrase.
+
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/integrity/evm/Makefile b/security/integrity/evm/Makefile
new file mode 100644
index 0000000..3d38273
--- /dev/null
+++ b/security/integrity/evm/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for building the Extended Verification Module(EVM)
+#
+obj-$(CONFIG_EVM) += evm.o
+
+evm-y := evm_main.o evm_crypto.o evm_secfs.o
+
diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
new file mode 100644
index 0000000..0b6f7b2
--- /dev/null
+++ b/security/integrity/evm/evm.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2005-2010 IBM Corporation
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: evm.h
+ *
+ */
+#include <linux/security.h>
+#include "../integrity.h"
+
+extern int evm_initialized;
+extern char *evm_hmac;
+extern int evm_hmac_size;
+
+/* List of EVM protected security xattrs */
+extern char *evm_config_xattrnames[];
+
+extern int evm_init_tpmkernkey(void);
+extern int evm_update_evmxattr(struct dentry *dentry,
+			       const char *req_xattr_name,
+			       const char *req_xattr_value,
+			       size_t req_xattr_value_len,
+			       struct integrity_iint_cache *iint);
+extern int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
+			 const char *req_xattr_value,
+			 size_t req_xattr_value_len, char *digest);
+extern int evm_init_secfs(void);
+extern void evm_cleanup_secfs(void);
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
new file mode 100644
index 0000000..4f1be71
--- /dev/null
+++ b/security/integrity/evm/evm_crypto.c
@@ -0,0 +1,179 @@
+/*
+ * Copyright (C) 2005-2010 IBM Corporation
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: evm_crypto.c
+ *	 Using root's kernel master key (kmk), calculate the HMAC
+ */
+
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/xattr.h>
+#include <keys/user-type.h>
+#include <linux/scatterlist.h>
+#include "evm.h"
+
+#define TPMKEY "evm_key"
+#define MAX_TPMKEY 128
+static unsigned char tpm_key[MAX_TPMKEY];
+static int tpm_keylen = MAX_TPMKEY;
+
+static int init_desc(struct hash_desc *desc)
+{
+	int rc;
+
+	desc->tfm = crypto_alloc_hash(evm_hmac, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc->tfm)) {
+		pr_info("Can not allocate %s (reason: %ld)\n",
+			evm_hmac, PTR_ERR(desc->tfm));
+		rc = PTR_ERR(desc->tfm);
+		return rc;
+	}
+	desc->flags = 0;
+	crypto_hash_setkey(desc->tfm, tpm_key, tpm_keylen);
+	rc = crypto_hash_init(desc);
+	if (rc)
+		crypto_free_hash(desc->tfm);
+	return rc;
+}
+
+/* Protect against 'cutting & pasting' security.evm xattr, include inode
+ * specific info.
+ *
+ * (Additional directory/file metadata needs to be added for more complete
+ * protection.)
+ */
+static void hmac_add_misc(struct hash_desc *desc, struct inode *inode,
+			  char *digest)
+{
+	struct h_misc {
+		unsigned long ino;
+		__u32 generation;
+		uid_t uid;
+		gid_t gid;
+		umode_t mode;
+	} hmac_misc;
+	struct scatterlist sg[1];
+
+	memset(&hmac_misc, 0, sizeof hmac_misc);
+	hmac_misc.ino = inode->i_ino;
+	hmac_misc.generation = inode->i_generation;
+	hmac_misc.uid = inode->i_uid;
+	hmac_misc.gid = inode->i_gid;
+	hmac_misc.mode = inode->i_mode;
+	sg_init_one(sg, &hmac_misc, sizeof hmac_misc);
+	crypto_hash_update(desc, sg, sizeof hmac_misc);
+	crypto_hash_final(desc, digest);
+}
+
+/*
+ * Calculate the HMAC value across the set of protected security xattrs.
+ *
+ * Instead of retrieving the requested xattr, for performance, calculate
+ * the hmac using the requested xattr value. Don't alloc/free memory for
+ * each xattr, but attempt to re-use the previously allocated memory.
+ */
+int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
+		  const char *req_xattr_value, size_t req_xattr_value_len,
+		  char *digest)
+{
+	struct inode *inode = dentry->d_inode;
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	char **xattrname;
+	size_t xattr_size = 0;
+	char *xattr_value = NULL;
+	int error;
+	int size;
+
+	if (!inode->i_op || !inode->i_op->getxattr)
+		return -EOPNOTSUPP;
+	error = init_desc(&desc);
+	if (error)
+		return error;
+
+	error = -ENODATA;
+	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++) {
+		if ((req_xattr_name && req_xattr_value)
+		    && !strcmp(*xattrname, req_xattr_name)) {
+			error = 0;
+			sg_init_one(sg, req_xattr_value, req_xattr_value_len);
+			crypto_hash_update(&desc, sg, req_xattr_value_len);
+			continue;
+		}
+		size = vfs_getxattr_alloc(dentry, *xattrname,
+					  &xattr_value, xattr_size, GFP_NOFS);
+		if (size == -ENOMEM) {
+			error = -ENOMEM;
+			goto out;
+		}
+		if (size < 0)
+			continue;
+
+		error = 0;
+		xattr_size = size;
+		sg_init_one(sg, xattr_value, xattr_size);
+		crypto_hash_update(&desc, sg, xattr_size);
+	}
+	hmac_add_misc(&desc, inode, digest);
+	kfree(xattr_value);
+out:
+	crypto_free_hash(desc.tfm);
+	return error;
+}
+
+/*
+ * Calculate the hmac and update security.evm xattr
+ */
+int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
+			const char *xattr_value, size_t xattr_value_len,
+			struct integrity_iint_cache *iint)
+{
+	struct inode *inode = dentry->d_inode;
+	int rc = 0;
+
+	memset(iint->hmac, 0, sizeof iint->hmac);
+	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
+			   xattr_value_len, iint->hmac);
+	if (rc == 0)
+		rc = inode->i_op->setxattr(dentry, XATTR_NAME_EVM,
+					   iint->hmac, evm_hmac_size, 0);
+	else if (rc == -ENODATA)
+		rc = inode->i_op->removexattr(dentry, XATTR_NAME_EVM);
+	return rc;
+}
+
+/*
+ * Get the key from the TPM for the SHA1-HMAC
+ */
+int evm_init_tpmkernkey(void)
+{
+	struct key *kmk;
+	struct user_key_payload *ukp;
+	int len;
+
+	kmk = request_key(&key_type_user, TPMKEY, NULL);
+	if (IS_ERR(kmk))
+		return -ENOENT;
+
+	down_read(&kmk->sem);
+	ukp = kmk->payload.data;
+	len = ukp->datalen;
+	if (len > MAX_TPMKEY)
+		len = MAX_TPMKEY;
+	tpm_keylen = len;
+	memcpy(tpm_key, ukp->data, len);
+
+	/* burn the original key contents */
+	memset(ukp->data, 0, len);
+	up_read(&kmk->sem);
+	key_put(kmk);
+	return 0;
+}
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
new file mode 100644
index 0000000..59dc148
--- /dev/null
+++ b/security/integrity/evm/evm_main.c
@@ -0,0 +1,296 @@
+/*
+ * Copyright (C) 2005-2010 IBM Corporation
+ *
+ * Author:
+ * Mimi Zohar <zohar@us.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: evm_main.c
+ *	implements evm_inode_setxattr, evm_inode_post_setxattr,
+ *	evm_inode_removexattr, and evm_verifyxattr
+ */
+
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/xattr.h>
+#include <linux/integrity.h>
+#include "evm.h"
+
+int evm_initialized;
+
+char *evm_hmac = "hmac(sha1)";
+int evm_hmac_size = SHA1_DIGEST_SIZE;
+
+char *evm_config_xattrnames[] = {
+#ifdef CONFIG_SECURITY_SELINUX
+	XATTR_NAME_SELINUX,
+#endif
+#ifdef CONFIG_SECURITY_SMACK
+	XATTR_NAME_SMACK,
+#endif
+	XATTR_NAME_CAPS,
+	NULL
+};
+
+/*
+ * evm_verify_hmac - calculate and compare the HMAC with the EVM xattr
+ *
+ * Compute the HMAC on the dentry's protected set of extended attributes
+ * and compare it against the stored security.evm xattr. (For performance,
+ * use the previoulsy retrieved xattr value and length to calculate the
+ * HMAC.)
+ *
+ * Returns integrity status
+ */
+static enum integrity_status evm_verify_hmac(struct dentry *dentry,
+					     const char *xattr_name,
+					     char *xattr_value,
+					     size_t xattr_value_len,
+					     struct integrity_iint_cache *iint)
+{
+	char hmac_val[MAX_DIGEST_SIZE];
+	int rc;
+
+	if (iint->hmac_status != INTEGRITY_UNKNOWN)
+		return iint->hmac_status;
+
+	memset(hmac_val, 0, sizeof hmac_val);
+	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
+			   xattr_value_len, hmac_val);
+	if (rc < 0)
+		return INTEGRITY_UNKNOWN;
+
+	rc = vfs_xattr_cmp(dentry, XATTR_NAME_EVM, hmac_val, sizeof hmac_val,
+			   GFP_NOFS);
+	if (rc < 0)
+		goto err_out;
+	iint->hmac_status = INTEGRITY_PASS;
+	return iint->hmac_status;
+
+err_out:
+	switch (rc) {
+	case -ENODATA:		/* file not labelled */
+		iint->hmac_status = INTEGRITY_NOLABEL;
+		break;
+	case -EINVAL:
+		iint->hmac_status = INTEGRITY_FAIL;
+		break;
+	default:
+		iint->hmac_status = INTEGRITY_UNKNOWN;
+	}
+	return iint->hmac_status;
+}
+
+static int evm_protected_xattr(const char *req_xattr_name)
+{
+	char **xattrname;
+	int found = 0;
+
+	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++) {
+		if (strncmp(req_xattr_name, *xattrname,
+			    strlen(req_xattr_name)) == 0) {
+			found = 1;
+			break;
+		}
+	}
+	return found;
+}
+
+/**
+ * evm_verifyxattr - verify the integrity of the requested xattr
+ * @dentry: object of the verify xattr
+ * @xattr_name: requested xattr
+ * @xattr_value: requested xattr value
+ * @xattr_value_len: requested xattr value length
+ *
+ * Calculate the HMAC for the given dentry and verify it
+ * against the stored security.evm xattr. For performance,
+ * use the xattr value and length previously retrieved
+ * to calculate the HMAC.
+ *
+ * Returns the xattr integrity status.
+ */
+enum integrity_status evm_verifyxattr(struct dentry *dentry,
+				      const char *xattr_name,
+				      void *xattr_value, size_t xattr_value_len)
+{
+	struct inode *inode = dentry->d_inode;
+	struct integrity_iint_cache *iint;
+	enum integrity_status status;
+
+	if (!evm_initialized || !evm_protected_xattr(xattr_name))
+		return INTEGRITY_UNKNOWN;
+
+	iint = integrity_iint_find_get(inode);
+	if (!iint)
+		return -ENOMEM;
+	mutex_lock(&iint->evm_mutex);
+	status = evm_verify_hmac(dentry, xattr_name, xattr_value,
+				 xattr_value_len, iint);
+	mutex_unlock(&iint->evm_mutex);
+	kref_put(&iint->refcount, iint_free);
+	return status;
+}
+EXPORT_SYMBOL_GPL(evm_verifyxattr);
+
+/*
+ * evm_protect_xattr - protect the EVM extended attribute
+ *
+ * Prevent security.evm from being modified or removed.
+ */
+static int evm_protect_xattr(struct dentry *dentry, const char *xattr_name,
+			     const void *xattr_value, size_t xattr_value_len)
+{
+	if ((!capable(CAP_MAC_ADMIN))
+	    && (strcmp(xattr_name, XATTR_NAME_EVM) == 0))
+		return -EPERM;
+	return 0;
+}
+
+/**
+ * evm_inode_setxattr - protect the EVM extended attribute
+ * @dentry: pointer to the affected dentry
+ * @xattr_name: pointer to the affected extended attribute name
+ * @xattr_value: pointer to the new extended attribute value
+ * @xattr_value_len: pointer to the new extended attribute value length
+ *
+ * Prevent 'security.evm' from being modified
+ */
+int evm_inode_setxattr(struct dentry *dentry, const char *xattr_name,
+		       const void *xattr_value, size_t xattr_value_len)
+{
+	return evm_protect_xattr(dentry, xattr_name, xattr_value,
+				 xattr_value_len);
+}
+
+/**
+ * evm_inode_removexattr - protect the EVM extended attribute
+ * @dentry: pointer to the affected dentry
+ * @xattr_name: pointer to the affected extended attribute name
+ *
+ * Prevent 'security.evm' from being removed.
+ */
+int evm_inode_removexattr(struct dentry *dentry, const char *xattr_name)
+{
+	return evm_protect_xattr(dentry, xattr_name, NULL, 0);
+}
+
+/*
+ * After updating/removing an extended attribute defined in /etc/evm.config,
+ * update the HMAC(security.evm) to reflect the change.
+ */
+static void evm_postxattr(struct dentry *dentry, const char *xattr_name,
+			  const void *xattr_value, size_t xattr_value_len)
+{
+	struct inode *inode = dentry->d_inode;
+	struct integrity_iint_cache *iint;
+	int rc;
+
+	iint = integrity_iint_find_get(inode);
+	if (!iint)
+		return;
+	mutex_lock(&iint->evm_mutex);
+	iint->hmac_status = INTEGRITY_UNKNOWN;
+	rc = evm_update_evmxattr(dentry, xattr_name, xattr_value,
+				 xattr_value_len, iint);
+	if (!rc)
+		iint->hmac_status = INTEGRITY_PASS;
+	mutex_unlock(&iint->evm_mutex);
+	kref_put(&iint->refcount, iint_free);
+}
+
+/**
+ * evm_inode_post_setxattr - update 'security.evm' to reflect the changes
+ * @dentry: pointer to the affected dentry
+ * @xattr_name: pointer to the affected extended attribute name
+ * @xattr_value: pointer to the new extended attribute value
+ * @xattr_value_len: pointer to the new extended attribute value length
+ *
+ * Update the HMAC stored in 'security.evm' to reflect the change.
+ */
+void evm_inode_post_setxattr(struct dentry *dentry, const char *xattr_name,
+			     const void *xattr_value, size_t xattr_value_len)
+{
+	if (!evm_initialized || !evm_protected_xattr(xattr_name))
+		return;
+
+	evm_postxattr(dentry, xattr_name, xattr_value, xattr_value_len);
+	return;
+}
+
+/**
+ * evm_inode_post_removexattr - update 'security.evm' after removing the xattr
+ * @dentry: pointer to the affected dentry
+ * @xattr_name: pointer to the affected extended attribute name
+ *
+ * Update the HMAC stored in 'security.evm' to reflect removal of the xattr.
+ */
+void evm_inode_post_removexattr(struct dentry *dentry, const char *xattr_name)
+{
+	if (!evm_initialized || !evm_protected_xattr(xattr_name))
+		return;
+
+	evm_postxattr(dentry, xattr_name, NULL, 0);
+	return;
+}
+
+/**
+ * evm_inode_post_setattr - update 'security.evm' after modifying metadata
+ * @dentry: pointer to the affected dentry
+ * @ia_valid: for the UID and GID status
+ *
+ * For now, update the HMAC stored in 'security.evm' to reflect UID/GID
+ * changes.
+ */
+void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
+{
+	if (!evm_initialized)
+		return;
+
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
+		evm_postxattr(dentry, NULL, NULL, 0);
+	return;
+}
+
+static struct crypto_hash *tfm_hmac;	/* preload crypto alg */
+static int __init init_evm(void)
+{
+	int error;
+
+	tfm_hmac = crypto_alloc_hash(evm_hmac, 0, CRYPTO_ALG_ASYNC);
+	error = evm_init_secfs();
+	if (error < 0) {
+		printk(KERN_INFO "EVM: Error registering secfs\n");
+		goto err;
+	}
+err:
+	return error;
+}
+
+static void __exit cleanup_evm(void)
+{
+	evm_cleanup_secfs();
+	crypto_free_hash(tfm_hmac);
+}
+
+/*
+ * evm_display_config - list the EVM protected security extended attributes
+ */
+static int __init evm_display_config(void)
+{
+	char **xattrname;
+
+	for (xattrname = evm_config_xattrnames; *xattrname != NULL; xattrname++)
+		printk(KERN_INFO "EVM: %s\n", *xattrname);
+	return 0;
+}
+
+pure_initcall(evm_display_config);
+late_initcall(init_evm);
+
+MODULE_DESCRIPTION("Extended Verification Module");
+MODULE_LICENSE("GPL");
diff --git a/security/integrity/evm/evm_secfs.c b/security/integrity/evm/evm_secfs.c
new file mode 100644
index 0000000..eeb2182
--- /dev/null
+++ b/security/integrity/evm/evm_secfs.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2010 IBM Corporation
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * File: evm_secfs.c
+ * 	- Used to signal when key is on keyring
+ * 	- Get the key and enable EVM
+ */
+
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include "evm.h"
+
+static struct dentry *evm_init_tpm;
+
+/**
+ * evm_read_key - read() for <securityfs>/evm
+ *
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @count: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t evm_read_key(struct file *filp, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	char temp[80];
+	ssize_t rc;
+
+	if (*ppos != 0)
+		return 0;
+
+	sprintf(temp, "%d", evm_initialized);
+	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
+
+	return rc;
+}
+
+/**
+ * evm_write_key - write() for <securityfs>/evm
+ * @file: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Used to signal that key is on the kernel key ring.
+ * - get the integrity hmac key from the kernel key ring
+ * - create list of hmac protected extended attributes
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t evm_write_key(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	char temp[80];
+	int i, error;
+
+	if (!capable(CAP_MAC_ADMIN) || evm_initialized)
+		return -EPERM;
+
+	if (count >= sizeof(temp) || count == 0)
+		return -EINVAL;
+
+	if (copy_from_user(temp, buf, count) != 0)
+		return -EFAULT;
+
+	temp[count] = '\0';
+
+	if ((sscanf(temp, "%d", &i) != 1) || (i != 1))
+		return -EINVAL;
+
+	error = evm_init_tpmkernkey();
+	printk(KERN_INFO "EVM: %s (%d)\n", (error < 0) ?
+	       "tpmkernkey initialization failed" : "tpmkernkey initialized",
+	       i);
+	if (!error)
+		evm_initialized = 1;
+	return count;
+}
+
+static const struct file_operations evm_key_ops = {
+	.read		= evm_read_key,
+	.write		= evm_write_key,
+};
+
+int __init evm_init_secfs(void)
+{
+	int error = 0;
+
+	evm_init_tpm = securityfs_create_file("evm", S_IRUSR | S_IRGRP,
+					      NULL, NULL, &evm_key_ops);
+	if (!evm_init_tpm || IS_ERR(evm_init_tpm))
+		error = -EFAULT;
+	return error;
+}
+
+void __exit evm_cleanup_secfs(void)
+{
+	if (evm_init_tpm)
+		securityfs_remove(evm_init_tpm);
+}
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index e2bdd8f..66013f2 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -133,9 +133,11 @@ static void init_once(void *foo)
 	iint->version = 0;
 	iint->flags = 0UL;
 	mutex_init(&iint->mutex);
+	mutex_init(&iint->evm_mutex);
 	iint->readcount = 0;
 	iint->writecount = 0;
 	iint->opencount = 0;
+	iint->hmac_status = INTEGRITY_UNKNOWN;
 	kref_init(&iint->refcount);
 }
 
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index f1013c9..c83e475 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -31,6 +31,9 @@ struct integrity_iint_cache {
 	long opencount;		/* opens reference count */
 	struct kref refcount;	/* ima_iint_cache reference count */
 	struct rcu_head rcu;
+	struct mutex evm_mutex;	/* protects: hmac_status, hmac */
+	enum integrity_status hmac_status;
+	u8 hmac[MAX_DIGEST_SIZE];
 };
 
 /* radix tree calls to lookup, insert, delete
-- 
1.6.6.1

