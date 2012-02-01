Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2BAUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:25:28 -0500
Received: from mga12.intel.com ([143.182.124.36]:19546 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755025Ab2BAUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:25:25 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: [RFC][PATCH v1 2/2] integrity: verify module integrity based on signature
Date: Wed,  1 Feb 2012 22:25:04 +0200
Message-Id: <8e8810adf4a10bcc74e0f2c78cf0ba910b7567d1.1328122362.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1328122362.git.dmitry.kasatkin@intel.com>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1328122362.git.dmitry.kasatkin@intel.com>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for verifying module integrity using digital signature.
Module signature is stored in the modules's 'security.ima' extended attribute
or in the file <module>.sig.
Modprobe and insmod pass the signature via init_module system call as the first
module parameter 'ima=' in hexadecimal format. The module hash is calculated and
is verified against the signature.

modprobe and insmod need to know if kernel module signature verification
support is enabled in order to pass 'ima=' module parameter.
securityfs entry is exported to check if digsig verification support is enabled.

Initially module checking is disabled and enabled by writing 1 to
securityfs/module_check.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 Documentation/ABI/testing/securityfs-module-check |   17 ++
 security/integrity/Kconfig                        |   11 +
 security/integrity/Makefile                       |    1 +
 security/integrity/module.c                       |  251 +++++++++++++++++++++
 4 files changed, 280 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/securityfs-module-check
 create mode 100644 security/integrity/module.c

diff --git a/Documentation/ABI/testing/securityfs-module-check b/Documentation/ABI/testing/securityfs-module-check
new file mode 100644
index 0000000..e8f7ab5
--- /dev/null
+++ b/Documentation/ABI/testing/securityfs-module-check
@@ -0,0 +1,17 @@
+What:		securityfs/module_check
+Date:		February 2012
+Contact:	Dmitry Kasatkin <dmitry.kasatkin@intel.com>
+Description:
+		Integrity provides a hook module_check() which is called from
+		load_module() in order to verify module integrity.
+		Often, when system starts, initramfs is used to perform
+		different initialization tasks before mounting root file system.
+		initramfs is usually verified together with kernel by the
+		boot loader. Public keys to verify modules are not loaded
+		at that point, so to allow initial module loading from initramfs,
+		verification is disabled. After loading keys, module verification
+		can be enabled by:
+
+		echo 1 > <securityfs>/module_check
+
+		After enabling, verification cannot be disabled anymore.
diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 5bd1cc1..813c5f6 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -17,5 +17,16 @@ config INTEGRITY_SIGNATURE
 	  This is useful for evm and module keyrings, when keys are
 	  usually only added from initramfs.
 
+config INTEGRITY_MODULES
+	bool "Modules integrity checking"
+	depends on SECURITY
+	select INTEGRITY_SIGNATURE
+	default n
+	help
+	  This option enables modules integrity checking,
+	  using digital signatures
+
+	  If unsure, say N.
+
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index d43799c..019907c 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_INTEGRITY) += integrity.o
 obj-$(CONFIG_INTEGRITY_SIGNATURE) += digsig.o
+obj-$(CONFIG_INTEGRITY_MODULES) += module.o
 
 integrity-y := iint.o
 
diff --git a/security/integrity/module.c b/security/integrity/module.c
new file mode 100644
index 0000000..ae880eb
--- /dev/null
+++ b/security/integrity/module.c
@@ -0,0 +1,251 @@
+/*
+ * Copyright (C) 2011,2012 Intel Corporation
+ *
+ * Authors:
+ * Dmitry Kasatkin <dmitry.kasatkin@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ * File: module.c
+ *	implements the module hooks: module_check.
+ */
+
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/vmalloc.h>
+#include <linux/crypto.h>
+#include <linux/security.h>
+
+#include "integrity.h"
+
+#define MODULE_DIGEST_SIZE	SHA1_DIGEST_SIZE
+
+#define MODULE_CHECK_ENABLE	0x01
+#define MODULE_CHECK_ENABLED	0x02
+#define MODULE_CHECK_ENFORCE	0x04
+
+static int module_check_enable = MODULE_CHECK_ENABLE | MODULE_CHECK_ENFORCE;
+static char *module_hash = "sha1";
+
+static int __init module_check_setup(char *str)
+{
+	if (strncmp(str, "off", 3) == 0)
+		module_check_enable = 0;
+	else if (strncmp(str, "ignore", 3) == 0)
+		module_check_enable &= ~MODULE_CHECK_ENFORCE;
+	return 1;
+}
+__setup("module_check=", module_check_setup);
+
+static int init_desc(struct hash_desc *desc)
+{
+	int rc;
+
+	desc->tfm = crypto_alloc_hash(module_hash, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc->tfm)) {
+		rc = PTR_ERR(desc->tfm);
+		pr_info("MODULE_CHECK: failed to load %s transform: %d\n",
+			module_hash, rc);
+		return rc;
+	}
+	desc->flags = 0;
+	rc = crypto_hash_init(desc);
+	if (rc)
+		crypto_free_hash(desc->tfm);
+	return rc;
+}
+
+/* last page - first page + 1 */
+#define PAGECOUNT(buf, buflen) \
+	((((unsigned long)(buf + buflen - 1) & PAGE_MASK) >> PAGE_SHIFT) - \
+	(((unsigned long) buf               & PAGE_MASK) >> PAGE_SHIFT) + 1)
+
+/* offset of buf in it's first page */
+#define PAGEOFFSET(buf) ((unsigned long)buf & ~PAGE_MASK)
+
+/**
+ * vmalloc_to_sg() - Make scatterlist from vmallocated buffer
+ * @virt: vmallocated buffer
+ * @len:  buffer length
+ *
+ * Asynchronous SHA1 calculation is using scatterlist data. This
+ * function can be used to create scatterlist from vmallocated
+ * data buffer.
+ *
+ * Return pointer to scatterlist or NULL.
+ */
+static struct scatterlist *vmalloc_to_sg(const void *virt, unsigned long len)
+{
+	int nr_pages = PAGECOUNT(virt, len);
+	struct scatterlist *sglist;
+	struct page *pg;
+	int i;
+	int pglen;
+	int pgoff;
+
+	sglist = vmalloc(nr_pages * sizeof(*sglist));
+	if (!sglist)
+		return NULL;
+	memset(sglist, 0, nr_pages * sizeof(*sglist));
+	sg_init_table(sglist, nr_pages);
+	for (i = 0; i < nr_pages; i++, virt += pglen, len -= pglen) {
+		pg = vmalloc_to_page(virt);
+		if (!pg)
+			goto err;
+		pgoff = PAGEOFFSET(virt);
+		pglen = min((PAGE_SIZE - pgoff), len);
+		sg_set_page(&sglist[i], pg, pglen, pgoff);
+	}
+	return sglist;
+err:
+	vfree(sglist);
+	return NULL;
+}
+
+static int calc_module_hash(const void *module, const int module_len,
+				char *digest)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[1], *sgp = sg;
+	int rc = -ENOMEM;
+
+	rc = init_desc(&desc);
+	if (rc != 0)
+		return rc;
+
+	sgp = vmalloc_to_sg(module, module_len);
+	if (!sgp)
+		goto err;
+
+	rc = crypto_hash_update(&desc, sgp, module_len);
+	if (!rc)
+		rc = crypto_hash_final(&desc, digest);
+
+	vfree(sgp);
+err:
+	crypto_free_hash(desc.tfm);
+	return rc;
+}
+
+/**
+ * module_check - check module integrity
+ * @hdr:	module data
+ * @len:	length of the module
+ * @args:	module arguments passed to init_module
+ * @return:	0 on success, error code on failure
+ *
+ * Hook to verify module integrity.
+ *
+ */
+int module_check(const void *hdr, const unsigned long len, char **args)
+{
+	u8 digest[MODULE_DIGEST_SIZE];
+	int rc = -EINVAL, siglen;
+	char *mod_args, *sig, *tmp;
+
+	if (!(module_check_enable & MODULE_CHECK_ENABLED))
+		return 0;
+
+	if (strncmp(*args, "ima=", 4) != 0) {
+		pr_err("IMA: missing 'ima=' option\n");
+		goto err1;
+	}
+
+	/* we need to remove module signature from arg list */
+	mod_args = *args + 4;
+	sig = strsep(&mod_args, " \t");
+	tmp = kstrdup(mod_args ?: "", GFP_KERNEL);
+	if (!tmp) {
+		rc = -ENOMEM;
+		goto err1;
+	}
+
+	siglen = strlen(sig)/2;
+	if (hex2bin((u8 *)sig, sig, siglen) < 0)
+		goto err2;
+
+	rc = calc_module_hash(hdr, len, digest);
+	if (rc < 0)
+		goto err2;
+
+	rc = integrity_digsig_verify(INTEGRITY_KEYRING_MODULE, sig, siglen,
+				     digest, MODULE_DIGEST_SIZE);
+	if (rc) {
+		pr_err("MODULE_CHECK: module verification failed: %d", rc);
+		print_hex_dump(KERN_ERR, "hash: ", DUMP_PREFIX_NONE, 32, 1,
+			       digest, MODULE_DIGEST_SIZE, 0);
+	}
+
+err2:
+	kfree(*args);
+	*args = tmp;
+err1:
+	return (module_check_enable & MODULE_CHECK_ENFORCE) ? rc : 0;
+}
+
+#define TMPBUFLEN 12
+
+static ssize_t show_module_check(struct file *filp, char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char tmpbuf[TMPBUFLEN];
+	ssize_t len;
+
+	len = scnprintf(tmpbuf, TMPBUFLEN, "%d\n", module_check_enable);
+	return simple_read_from_buffer(buf, count, ppos, tmpbuf, len);
+}
+
+static ssize_t store_module_check(struct file *file, const char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	int ret, i;
+
+	if (!(module_check_enable & MODULE_CHECK_ENABLE))
+		return 0;
+
+	if (!capable(CAP_SYS_ADMIN) ||
+	    (module_check_enable & MODULE_CHECK_ENABLED))
+		return -EPERM;
+
+	ret = kstrtoint_from_user(buf, count, 10, &i);
+	if (ret < 0)
+		return ret;
+
+	if (i != 1)
+		return -EINVAL;
+
+	module_check_enable |= MODULE_CHECK_ENABLED;
+
+	return count;
+}
+
+static const struct file_operations module_ops = {
+	.read = show_module_check,
+	.write = store_module_check,
+};
+
+static struct dentry *module_fs;
+
+static int __init module_check_init(void)
+{
+	module_fs = securityfs_create_file("module_check", S_IRUSR, NULL, NULL,
+					   &module_ops);
+	if (IS_ERR(module_fs))
+		return PTR_ERR(module_fs);
+
+	return 0;
+}
+
+static void __exit module_check_cleanup(void)
+{
+	securityfs_remove(module_fs);
+}
+
+module_init(module_check_init);
+module_exit(module_check_cleanup);
+
+MODULE_DESCRIPTION("Module integrity verification");
+MODULE_LICENSE("GPL");
-- 
1.7.5.4

