Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0FXSKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 14:10:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58355 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab0FXSKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:10:48 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 01/15] integrity: move ima inode integrity data management
Date: Thu, 24 Jun 2010 14:10:17 -0400
Message-Id: <1277403031-3080-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the inode integrity data(iint) management up to the
integrity layer in order to share the integrity data area
among the different integrity models.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 include/linux/ima.h               |   12 ---
 include/linux/integrity.h         |   28 +++++++
 security/Kconfig                  |    2 +-
 security/Makefile                 |    4 +-
 security/integrity/Kconfig        |    6 ++
 security/integrity/Makefile       |   10 +++
 security/integrity/iint.c         |  150 +++++++++++++++++++++++++++++++++++++
 security/integrity/ima/Kconfig    |    1 +
 security/integrity/ima/Makefile   |    2 +-
 security/integrity/ima/ima.h      |   34 +++------
 security/integrity/ima/ima_api.c  |    9 +-
 security/integrity/ima/ima_iint.c |  146 ------------------------------------
 security/integrity/ima/ima_main.c |   21 +++---
 security/integrity/integrity.h    |   42 ++++++++++
 security/security.c               |    5 +-
 15 files changed, 270 insertions(+), 202 deletions(-)
 create mode 100644 include/linux/integrity.h
 create mode 100644 security/integrity/Kconfig
 create mode 100644 security/integrity/Makefile
 create mode 100644 security/integrity/iint.c
 delete mode 100644 security/integrity/ima/ima_iint.c
 create mode 100644 security/integrity/integrity.h

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 975837e..4dce900 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -15,8 +15,6 @@ struct linux_binprm;
 
 #ifdef CONFIG_IMA
 extern int ima_bprm_check(struct linux_binprm *bprm);
-extern int ima_inode_alloc(struct inode *inode);
-extern void ima_inode_free(struct inode *inode);
 extern int ima_file_check(struct file *file, int mask);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
@@ -28,16 +26,6 @@ static inline int ima_bprm_check(struct linux_binprm *bprm)
 	return 0;
 }
 
-static inline int ima_inode_alloc(struct inode *inode)
-{
-	return 0;
-}
-
-static inline void ima_inode_free(struct inode *inode)
-{
-	return;
-}
-
 static inline int ima_file_check(struct file *file, int mask)
 {
 	return 0;
diff --git a/include/linux/integrity.h b/include/linux/integrity.h
new file mode 100644
index 0000000..276081f
--- /dev/null
+++ b/include/linux/integrity.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) 2009 IBM Corporation
+ * Author: Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ */
+
+#ifndef _LINUX_INTEGRITY_H
+#define _LINUX_INTEGRITY_H
+
+#ifdef CONFIG_INTEGRITY
+extern int integrity_inode_alloc(struct inode *inode);
+extern void integrity_inode_free(struct inode *inode);
+
+#else
+static inline int integrity_inode_alloc(struct inode *inode)
+{
+	return 0;
+}
+
+static inline void integrity_inode_free(struct inode *inode)
+{
+	return;
+}
+#endif /* CONFIG_INTEGRITY_H */
+#endif /* _LINUX_INTEGRITY_H */
diff --git a/security/Kconfig b/security/Kconfig
index 226b955..4f00287 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -141,7 +141,7 @@ source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
 
-source security/integrity/ima/Kconfig
+source security/integrity/Kconfig
 
 choice
 	prompt "Default security module"
diff --git a/security/Makefile b/security/Makefile
index da20a19..9269caa 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -22,5 +22,5 @@ obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
-subdir-$(CONFIG_IMA)			+= integrity/ima
-obj-$(CONFIG_IMA)			+= integrity/ima/built-in.o
+subdir-$(CONFIG_INTEGRITY)		+= integrity
+obj-$(CONFIG_INTEGRITY)			+= integrity/built-in.o
diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
new file mode 100644
index 0000000..2704691
--- /dev/null
+++ b/security/integrity/Kconfig
@@ -0,0 +1,6 @@
+#
+config INTEGRITY
+	def_bool y
+	depends on IMA
+
+source security/integrity/ima/Kconfig
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
new file mode 100644
index 0000000..6eddd61
--- /dev/null
+++ b/security/integrity/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for caching inode integrity data (iint)
+#
+
+obj-$(CONFIG_INTEGRITY) += integrity.o
+
+integrity-y := iint.o
+
+subdir-$(CONFIG_IMA)			+= ima
+obj-$(CONFIG_IMA)			+= ima/built-in.o
diff --git a/security/integrity/iint.c b/security/integrity/iint.c
new file mode 100644
index 0000000..e2bdd8f
--- /dev/null
+++ b/security/integrity/iint.c
@@ -0,0 +1,150 @@
+/*
+ * Copyright (C) 2008-2010 IBM Corporation
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: iint.c
+ * 	- implements the integrity hooks: integrity_inode_alloc,
+ * 	  integrity_inode_free
+ *	- cache integrity information associated with an inode
+ *	  using a radix tree.
+ */
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/radix-tree.h>
+#include "integrity.h"
+
+RADIX_TREE(integrity_iint_store, GFP_ATOMIC);
+DEFINE_SPINLOCK(integrity_iint_lock);
+
+static struct kmem_cache *iint_cache __read_mostly;
+
+/* integrity_iint_find_get - return the iint associated with an inode
+ *
+ * integrity_iint_find_get gets a reference to the iint. Caller must
+ * remember to put the iint reference.
+ */
+struct integrity_iint_cache *integrity_iint_find_get(struct inode *inode)
+{
+	struct integrity_iint_cache *iint;
+
+	rcu_read_lock();
+	iint = radix_tree_lookup(&integrity_iint_store, (unsigned long)inode);
+	if (!iint)
+		goto out;
+	kref_get(&iint->refcount);
+out:
+	rcu_read_unlock();
+	return iint;
+}
+
+/**
+ * integrity_inode_alloc - allocate an iint associated with an inode
+ * @inode: pointer to the inode
+ */
+int integrity_inode_alloc(struct inode *inode)
+{
+	struct integrity_iint_cache *iint = NULL;
+	int rc = 0;
+
+	iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
+	if (!iint)
+		return -ENOMEM;
+
+	rc = radix_tree_preload(GFP_NOFS);
+	if (rc < 0)
+		goto out;
+
+	spin_lock(&integrity_iint_lock);
+	rc = radix_tree_insert(&integrity_iint_store, (unsigned long)inode,
+			       iint);
+	spin_unlock(&integrity_iint_lock);
+	radix_tree_preload_end();
+out:
+	if (rc < 0)
+		kmem_cache_free(iint_cache, iint);
+
+	return rc;
+}
+
+/* iint_free - called when the iint refcount goes to zero */
+void iint_free(struct kref *kref)
+{
+	struct integrity_iint_cache *iint =
+	    container_of(kref, struct integrity_iint_cache, refcount);
+	iint->version = 0;
+	iint->flags = 0UL;
+	if (iint->readcount != 0) {
+		printk(KERN_INFO "%s: readcount: %ld\n", __func__,
+		       iint->readcount);
+		iint->readcount = 0;
+	}
+	if (iint->writecount != 0) {
+		printk(KERN_INFO "%s: writecount: %ld\n", __func__,
+		       iint->writecount);
+		iint->writecount = 0;
+	}
+	if (iint->opencount != 0) {
+		printk(KERN_INFO "%s: opencount: %ld\n", __func__,
+		       iint->opencount);
+		iint->opencount = 0;
+	}
+	kref_init(&iint->refcount);
+	kmem_cache_free(iint_cache, iint);
+}
+
+void iint_rcu_free(struct rcu_head *rcu_head)
+{
+	struct integrity_iint_cache *iint =
+	    container_of(rcu_head, struct integrity_iint_cache, rcu);
+	kref_put(&iint->refcount, iint_free);
+}
+
+/**
+ * integrity_inode_free - called on security_inode_free
+ * @inode: pointer to the inode
+ *
+ * Free the integrity information(iint) associated with an inode.
+ */
+void integrity_inode_free(struct inode *inode)
+{
+	struct integrity_iint_cache *iint;
+
+	spin_lock(&integrity_iint_lock);
+	iint = radix_tree_delete(&integrity_iint_store, (unsigned long)inode);
+	spin_unlock(&integrity_iint_lock);
+	if (iint)
+		call_rcu(&iint->rcu, iint_rcu_free);
+}
+
+static void init_once(void *foo)
+{
+	struct integrity_iint_cache *iint = foo;
+
+	memset(iint, 0, sizeof *iint);
+	iint->version = 0;
+	iint->flags = 0UL;
+	mutex_init(&iint->mutex);
+	iint->readcount = 0;
+	iint->writecount = 0;
+	iint->opencount = 0;
+	kref_init(&iint->refcount);
+}
+
+static int __init integrity_iintcache_init(void)
+{
+	iint_cache =
+	    kmem_cache_create("iint_cache", sizeof(struct integrity_iint_cache),
+			      0, SLAB_PANIC, init_once);
+	return 0;
+}
+
+security_initcall(integrity_iintcache_init);
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index b6ecfd4..19c053b 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -3,6 +3,7 @@
 config IMA
 	bool "Integrity Measurement Architecture(IMA)"
 	depends on SECURITY
+	select INTEGRITY
 	select SECURITYFS
 	select CRYPTO
 	select CRYPTO_HMAC
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 787c4cb..5690c02 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IMA) += ima.o
 
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
-	 ima_policy.o ima_iint.o ima_audit.o
+	 ima_policy.o ima_audit.o
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 16d100d..a58ac9f 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -24,11 +24,13 @@
 #include <linux/tpm.h>
 #include <linux/audit.h>
 
+#include "../integrity.h"
+
 enum ima_show_type { IMA_SHOW_BINARY, IMA_SHOW_ASCII };
 enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
 
 /* digest size for IMA, fits SHA1 or MD5 */
-#define IMA_DIGEST_SIZE		20
+#define IMA_DIGEST_SIZE		SHA1_DIGEST_SIZE
 #define IMA_EVENT_NAME_LEN_MAX	255
 
 #define IMA_HASH_BITS 9
@@ -94,38 +96,22 @@ static inline unsigned long ima_hash_key(u8 *digest)
 	return hash_long(*digest, IMA_HASH_BITS);
 }
 
-/* iint cache flags */
-#define IMA_MEASURED		1
-
-/* integrity data associated with an inode */
-struct ima_iint_cache {
-	u64 version;		/* track inode changes */
-	unsigned long flags;
-	u8 digest[IMA_DIGEST_SIZE];
-	struct mutex mutex;	/* protects: version, flags, digest */
-	long readcount;		/* measured files readcount */
-	long writecount;	/* measured files writecount */
-	long opencount;		/* opens reference count */
-	struct kref refcount;	/* ima_iint_cache reference count */
-	struct rcu_head rcu;
-};
-
 /* LIM API function definitions */
-int ima_must_measure(struct ima_iint_cache *iint, struct inode *inode,
+int ima_must_measure(struct integrity_iint_cache *iint, struct inode *inode,
 		     int mask, int function);
-int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file);
-void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
+int ima_collect_measurement(struct integrity_iint_cache *iint,
+			    struct file *file);
+void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   const unsigned char *filename);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode);
-void ima_template_show(struct seq_file *m, void *e,
-		       enum ima_show_type show);
+void ima_template_show(struct seq_file *m, void *e, enum ima_show_type show);
 
 /* radix tree calls to lookup, insert, delete
  * integrity data associated with an inode.
  */
-struct ima_iint_cache *ima_iint_insert(struct inode *inode);
-struct ima_iint_cache *ima_iint_find_get(struct inode *inode);
+struct integrity_iint_cache *ima_iint_insert(struct inode *inode);
+struct integrity_iint_cache *ima_iint_find_get(struct inode *inode);
 void iint_free(struct kref *kref);
 void iint_rcu_free(struct rcu_head *rcu);
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 52015d0..42adfd4 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -111,7 +111,7 @@ err_out:
  * For matching a DONT_MEASURE policy, no policy, or other
  * error, return an error code.
 */
-int ima_must_measure(struct ima_iint_cache *iint, struct inode *inode,
+int ima_must_measure(struct integrity_iint_cache *iint, struct inode *inode,
 		     int mask, int function)
 {
 	int must_measure;
@@ -133,7 +133,8 @@ int ima_must_measure(struct ima_iint_cache *iint, struct inode *inode,
  *
  * Return 0 on success, error code otherwise
  */
-int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file)
+int ima_collect_measurement(struct integrity_iint_cache *iint,
+			    struct file *file)
 {
 	int result = -EEXIST;
 
@@ -163,8 +164,8 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file)
  *
  * Must be called with iint->mutex held.
  */
-void ima_store_measurement(struct ima_iint_cache *iint, struct file *file,
-			   const unsigned char *filename)
+void ima_store_measurement(struct integrity_iint_cache *iint,
+			   struct file *file, const unsigned char *filename)
 {
 	const char *op = "add_template_measure";
 	const char *audit_cause = "ENOMEM";
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
deleted file mode 100644
index 7625b85..0000000
--- a/security/integrity/ima/ima_iint.c
+++ /dev/null
@@ -1,146 +0,0 @@
-/*
- * Copyright (C) 2008 IBM Corporation
- *
- * Authors:
- * Mimi Zohar <zohar@us.ibm.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation, version 2 of the
- * License.
- *
- * File: ima_iint.c
- * 	- implements the IMA hooks: ima_inode_alloc, ima_inode_free
- *	- cache integrity information associated with an inode
- *	  using a radix tree.
- */
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/radix-tree.h>
-#include "ima.h"
-
-RADIX_TREE(ima_iint_store, GFP_ATOMIC);
-DEFINE_SPINLOCK(ima_iint_lock);
-
-static struct kmem_cache *iint_cache __read_mostly;
-
-/* ima_iint_find_get - return the iint associated with an inode
- *
- * ima_iint_find_get gets a reference to the iint. Caller must
- * remember to put the iint reference.
- */
-struct ima_iint_cache *ima_iint_find_get(struct inode *inode)
-{
-	struct ima_iint_cache *iint;
-
-	rcu_read_lock();
-	iint = radix_tree_lookup(&ima_iint_store, (unsigned long)inode);
-	if (!iint)
-		goto out;
-	kref_get(&iint->refcount);
-out:
-	rcu_read_unlock();
-	return iint;
-}
-
-/**
- * ima_inode_alloc - allocate an iint associated with an inode
- * @inode: pointer to the inode
- */
-int ima_inode_alloc(struct inode *inode)
-{
-	struct ima_iint_cache *iint = NULL;
-	int rc = 0;
-
-	iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
-	if (!iint)
-		return -ENOMEM;
-
-	rc = radix_tree_preload(GFP_NOFS);
-	if (rc < 0)
-		goto out;
-
-	spin_lock(&ima_iint_lock);
-	rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
-	spin_unlock(&ima_iint_lock);
-	radix_tree_preload_end();
-out:
-	if (rc < 0)
-		kmem_cache_free(iint_cache, iint);
-
-	return rc;
-}
-
-/* iint_free - called when the iint refcount goes to zero */
-void iint_free(struct kref *kref)
-{
-	struct ima_iint_cache *iint = container_of(kref, struct ima_iint_cache,
-						   refcount);
-	iint->version = 0;
-	iint->flags = 0UL;
-	if (iint->readcount != 0) {
-		printk(KERN_INFO "%s: readcount: %ld\n", __func__,
-		       iint->readcount);
-		iint->readcount = 0;
-	}
-	if (iint->writecount != 0) {
-		printk(KERN_INFO "%s: writecount: %ld\n", __func__,
-		       iint->writecount);
-		iint->writecount = 0;
-	}
-	if (iint->opencount != 0) {
-		printk(KERN_INFO "%s: opencount: %ld\n", __func__,
-		       iint->opencount);
-		iint->opencount = 0;
-	}
-	kref_init(&iint->refcount);
-	kmem_cache_free(iint_cache, iint);
-}
-
-void iint_rcu_free(struct rcu_head *rcu_head)
-{
-	struct ima_iint_cache *iint = container_of(rcu_head,
-						   struct ima_iint_cache, rcu);
-	kref_put(&iint->refcount, iint_free);
-}
-
-/**
- * ima_inode_free - called on security_inode_free
- * @inode: pointer to the inode
- *
- * Free the integrity information(iint) associated with an inode.
- */
-void ima_inode_free(struct inode *inode)
-{
-	struct ima_iint_cache *iint;
-
-	spin_lock(&ima_iint_lock);
-	iint = radix_tree_delete(&ima_iint_store, (unsigned long)inode);
-	spin_unlock(&ima_iint_lock);
-	if (iint)
-		call_rcu(&iint->rcu, iint_rcu_free);
-}
-
-static void init_once(void *foo)
-{
-	struct ima_iint_cache *iint = foo;
-
-	memset(iint, 0, sizeof *iint);
-	iint->version = 0;
-	iint->flags = 0UL;
-	mutex_init(&iint->mutex);
-	iint->readcount = 0;
-	iint->writecount = 0;
-	iint->opencount = 0;
-	kref_init(&iint->refcount);
-}
-
-static int __init ima_iintcache_init(void)
-{
-	iint_cache =
-	    kmem_cache_create("iint_cache", sizeof(struct ima_iint_cache), 0,
-			      SLAB_PANIC, init_once);
-	return 0;
-}
-security_initcall(ima_iintcache_init);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index f936413..8c231f3 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -18,6 +18,7 @@
  */
 #include <linux/module.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/binfmts.h>
 #include <linux/mount.h>
 #include <linux/mman.h>
@@ -97,7 +98,7 @@ out:
  */
 enum iint_pcr_error { TOMTOU, OPEN_WRITERS };
 static void ima_read_write_check(enum iint_pcr_error error,
-				 struct ima_iint_cache *iint,
+				 struct integrity_iint_cache *iint,
 				 struct inode *inode,
 				 const unsigned char *filename)
 {
@@ -118,7 +119,7 @@ static void ima_read_write_check(enum iint_pcr_error error,
 /*
  * Update the counts given an fmode_t
  */
-static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
+static void ima_inc_counts(struct integrity_iint_cache *iint, fmode_t mode)
 {
 	BUG_ON(!mutex_is_locked(&iint->mutex));
 
@@ -145,12 +146,12 @@ void ima_counts_get(struct file *file)
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	fmode_t mode = file->f_mode;
-	struct ima_iint_cache *iint;
+	struct integrity_iint_cache *iint;
 	int rc;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return;
-	iint = ima_iint_find_get(inode);
+	iint = integrity_iint_find_get(inode);
 	if (!iint)
 		return;
 	mutex_lock(&iint->mutex);
@@ -173,8 +174,8 @@ out:
 /*
  * Decrement ima counts
  */
-static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
-			   struct file *file)
+static void ima_dec_counts(struct integrity_iint_cache *iint,
+			   struct inode *inode, struct file *file)
 {
 	mode_t mode = file->f_mode;
 	BUG_ON(!mutex_is_locked(&iint->mutex));
@@ -211,11 +212,11 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
 void ima_file_free(struct file *file)
 {
 	struct inode *inode = file->f_dentry->d_inode;
-	struct ima_iint_cache *iint;
+	struct integrity_iint_cache *iint;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return;
-	iint = ima_iint_find_get(inode);
+	iint = integrity_iint_find_get(inode);
 	if (!iint)
 		return;
 
@@ -229,12 +230,12 @@ static int process_measurement(struct file *file, const unsigned char *filename,
 			       int mask, int function)
 {
 	struct inode *inode = file->f_dentry->d_inode;
-	struct ima_iint_cache *iint;
+	struct integrity_iint_cache *iint;
 	int rc;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return 0;
-	iint = ima_iint_find_get(inode);
+	iint = integrity_iint_find_get(inode);
 	if (!iint)
 		return -ENOMEM;
 
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
new file mode 100644
index 0000000..f1013c9
--- /dev/null
+++ b/security/integrity/integrity.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2009-2010 IBM Corporation
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: integrity.h
+ */
+#include <linux/types.h>
+#include <linux/integrity.h>
+#include <crypto/sha.h>
+
+#define MAX_DIGEST_SIZE SHA1_DIGEST_SIZE
+
+/* iint cache flags */
+#define IMA_MEASURED		1
+
+/* integrity data associated with an inode */
+struct integrity_iint_cache {
+	u64 version;		/* track inode changes */
+	unsigned long flags;
+	u8 digest[MAX_DIGEST_SIZE];
+	struct mutex mutex;	/* protects: version, flags, digest */
+	long readcount;		/* measured files readcount */
+	long writecount;	/* measured files writecount */
+	long opencount;		/* opens reference count */
+	struct kref refcount;	/* ima_iint_cache reference count */
+	struct rcu_head rcu;
+};
+
+/* radix tree calls to lookup, insert, delete
+ * integrity data associated with an inode.
+ */
+struct integrity_iint_cache *integrity_iint_insert(struct inode *inode);
+struct integrity_iint_cache *integrity_iint_find_get(struct inode *inode);
+void iint_free(struct kref *kref);
+void iint_rcu_free(struct rcu_head *rcu);
diff --git a/security/security.c b/security/security.c
index e8c87b8..36a0de3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/ima.h>
 
 /* Boot-time LSM user choice */
@@ -339,7 +340,7 @@ int security_inode_alloc(struct inode *inode)
 	ret =  security_ops->inode_alloc_security(inode);
 	if (ret)
 		return ret;
-	ret = ima_inode_alloc(inode);
+	ret = integrity_inode_alloc(inode);
 	if (ret)
 		security_inode_free(inode);
 	return ret;
@@ -347,7 +348,7 @@ int security_inode_alloc(struct inode *inode)
 
 void security_inode_free(struct inode *inode)
 {
-	ima_inode_free(inode);
+	integrity_inode_free(inode);
 	security_ops->inode_free_security(inode);
 }
 
-- 
1.6.6.1

