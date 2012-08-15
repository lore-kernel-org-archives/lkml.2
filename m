Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2HOSop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:44:45 -0400
Received: from mga06.intel.com ([134.134.136.21]:24764 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755074Ab2HOSnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:43:31 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@us.ibm.com>
Subject: [RFC v2 3/7] integrity: create and inititialize a keyring with builtin public key
Date: Wed, 15 Aug 2012 21:43:08 +0300
Message-Id: <66e0f332c823b82701a48aba320f589cec27e904.1345055639.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

Create and initialize a keyring with the builtin public key. This could
be an ephemeral key, created and destroyed during module install for
custom built kernels, or a key used to label the entire filesystem for
EVM/IMA-appraisal. Uses .incbin based on David Howell's post.

Load the builtin public key on the specified keyring, creating the
keyring if it doesn't already exist.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 security/integrity/Kconfig         |   10 ++++
 security/integrity/Makefile        |   17 +++++++
 security/integrity/digsig_pubkey.c |   96 ++++++++++++++++++++++++++++++++++++
 security/integrity/integrity.h     |   10 ++++
 4 files changed, 133 insertions(+)
 create mode 100644 security/integrity/digsig_pubkey.c

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index 5bd1cc1..f789018 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -17,5 +17,15 @@ config INTEGRITY_SIGNATURE
 	  This is useful for evm and module keyrings, when keys are
 	  usually only added from initramfs.
 
+config INTEGRITY_PUBKEY
+	boolean "Create a keyring and initialize with builtin public key"
+	depends on INTEGRITY_SIGNATURE
+	default n
+	help
+	  Create and initialize a keyring with the builtin public key. This could
+	  be an ephemeral key, created and destroyed during module install for
+	  custom built kernels, or a key used to label the entire filesystem for
+	  EVM/IMA-appraisal.
+
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index d43799c..cf234f5 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -11,3 +11,20 @@ subdir-$(CONFIG_IMA)			+= ima
 obj-$(CONFIG_IMA)			+= ima/built-in.o
 subdir-$(CONFIG_EVM)			+= evm
 obj-$(CONFIG_EVM)			+= evm/built-in.o
+
+ifeq ($(CONFIG_INTEGRITY_PUBKEY),y)
+
+obj-y += digsig_pubkey.o
+
+pubkeybin = pubkey.bin
+
+$(obj)/digsig_pubkey.o: $(pubkeybin)
+
+$(pubkeybin): FORCE
+	@if [ ! -s $(pubkeybin) ]; then \
+		echo "$(pubkeybin) is missing or empty..."; \
+		if [ ! -f $(pubkeybin) ]; then touch $(pubkeybin); fi; \
+	fi
+
+endif
+
diff --git a/security/integrity/digsig_pubkey.c b/security/integrity/digsig_pubkey.c
new file mode 100644
index 0000000..c714a60
--- /dev/null
+++ b/security/integrity/digsig_pubkey.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (C) 2012 IBM Corporation
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * Author:
+ * Mimi Zohar <zohar@us.ibm.com>
+ * Dmitry Kasatkin <dmitry.kasatkin@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <linux/err.h>
+#include <linux/key-type.h>
+#include <keys/user-type.h>
+
+#include "integrity.h"
+
+static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
+	"_evm",
+	"_module",
+	"_ima",
+};
+
+asm(".section .init.data,\"aw\"\n"
+	"pubkey:\n"
+	".incbin \"pubkey.bin\"\n"
+	"pubkey_end:"
+);
+
+extern __initdata const u8 pubkey[];
+extern __initdata const u8 pubkey_end[];
+
+/*
+ * integrity_init_keyring - create and initialize the specified keryring
+ *
+ * Create and initialize a keyring with the builtin public key. This could
+ * be an ephemeral key, created and destroyed during module install for
+ * custom built kernels, or a key used to label the entire filesystem for
+ * EVM/IMA-appraisal.
+ *
+ * Load the builtin public key on the specified keyring, creating the
+ * keyring if it doesn't already exist.
+ *
+ * Return 0 on success.
+ */
+int integrity_init_keyring(const unsigned int id)
+{
+	const struct cred *cred = current_cred();
+	struct user_struct *user = cred->user;
+	struct key *new_keyring, *key;
+	u8 digest[SHA1_DIGEST_SIZE];
+	char keyid[20];
+	int ret, pubkey_size = pubkey_end - pubkey;
+
+	if (pubkey_size == 0) {
+		pr_info("pubkey is missing, skipping...\n");
+		return 0;
+	}
+
+	new_keyring = keyring_alloc(keyring_name[id], user->uid, (gid_t) -1,
+				    cred, KEY_ALLOC_NOT_IN_QUOTA,
+				    user->uid_keyring);
+	if (IS_ERR(new_keyring)) {
+		ret = PTR_ERR(new_keyring);
+		goto out;
+	}
+
+	ret = integrity_calc_digest("sha1", pubkey, pubkey_size, digest);
+	if (ret < 0)
+		goto out;
+
+	sprintf(keyid, "%llX", __be64_to_cpup((uint64_t *)(digest+12)));
+
+	key = key_alloc(&key_type_user, keyid, 0, 0, current_cred(),
+			(KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			KEY_USR_VIEW | KEY_USR_SEARCH | KEY_USR_READ,
+			KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(key)) {
+		ret = PTR_ERR(key);
+		goto out;
+	}
+
+	ret = key_instantiate_and_link(key, pubkey, pubkey_end - pubkey,
+				       new_keyring, NULL);
+out:
+	pr_info("integrity: loaded public key %s on %s %s\n", keyid,
+		keyring_name[id], !ret ? "succeeded" : "failed");
+	return ret;
+}
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 48ee2d4..1070db8 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -13,6 +13,7 @@
 
 #include <linux/types.h>
 #include <linux/integrity.h>
+#include <linux/rbtree.h>
 #include <crypto/sha.h>
 
 /* iint cache flags */
@@ -76,5 +77,14 @@ static inline int integrity_digsig_verify(const unsigned int id,
 
 #endif /* CONFIG_INTEGRITY_SIGNATURE */
 
+#ifdef CONFIG_INTEGRITY_PUBKEY
+int integrity_init_keyring(const unsigned int id);
+#else
+static inline int integrity_init_keyring(const unsigned int id)
+{
+	return 0;
+}
+#endif /* CONFIG_INTEGRITY_PUBKEY */
+
 /* set during initialization */
 extern int iint_initialized;
-- 
1.7.9.5

