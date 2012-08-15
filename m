Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2HOSoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:44:15 -0400
Received: from mga05.intel.com ([192.55.52.89]:48176 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755194Ab2HOSne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:43:34 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC v2 5/7] modsig: verify module integrity based on signature
Date: Wed, 15 Aug 2012 21:43:10 +0300
Message-Id: <35332d9a474e268a41ed04164b8e4bbd8aba38f2.1345055639.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1345055638.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for verifying module integrity using the upstreamed
digital signature support. Signatures are appended to the kernel module
binary, as suggested by Rusty Russell. Using of this functionality does not
require changes to insmod and modprobe. The module hash is calculated and
verified against the signature. Public key and signature format can found
in Documentation/digsig.txt

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 security/integrity/Kconfig  |   11 ++++++
 security/integrity/Makefile |    1 +
 security/integrity/module.c |   91 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 103 insertions(+)
 create mode 100644 security/integrity/module.c

diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index f789018..fbc7c78 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -27,5 +27,16 @@ config INTEGRITY_PUBKEY
 	  custom built kernels, or a key used to label the entire filesystem for
 	  EVM/IMA-appraisal.
 
+config INTEGRITY_MODULES
+	bool "Module integrity checking"
+	depends on SECURITY
+	select INTEGRITY_SIGNATURE
+	default n
+	help
+	  This option enables module integrity checking,
+	  using digital signatures
+
+	  If unsure, say N.
+
 source security/integrity/ima/Kconfig
 source security/integrity/evm/Kconfig
diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index cf234f5..226634c 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_INTEGRITY) += integrity.o
 obj-$(CONFIG_INTEGRITY_SIGNATURE) += digsig.o
+obj-$(CONFIG_INTEGRITY_MODULES) += module.o
 
 integrity-y := iint.o
 
diff --git a/security/integrity/module.c b/security/integrity/module.c
new file mode 100644
index 0000000..b0e9ba2
--- /dev/null
+++ b/security/integrity/module.c
@@ -0,0 +1,91 @@
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
+ *	implements the module hooks: integrity_module_check
+ */
+
+#include <linux/module.h>
+#include <linux/security.h>
+
+#include "integrity.h"
+
+static const char sig_magic[] = "This Is A Crypto Signed Module";
+static const char sig_magic_len = sizeof(sig_magic) - 1;
+
+/**
+ * integrity_module_check - check module integrity
+ * @hdr:	module data
+ * @len:	length of the module
+ * @return:	length without signature, error code on failure
+ *
+ * Hook to verify module integrity.
+ *
+ */
+int integrity_module_check(const void *hdr, unsigned long len)
+{
+	u8 digest[SHA1_DIGEST_SIZE];
+	int rc = -EINVAL, siglen;
+	char *tmp;
+
+	if (len < sig_magic_len + 2) {
+		pr_err("MODSIG: signature magic is missing\n");
+		goto err1;
+	}
+
+	tmp = (char *)hdr + len;
+
+	len -= sig_magic_len;
+	tmp -= sig_magic_len;
+	if (memcmp(tmp, sig_magic, sig_magic_len)) {
+		pr_err("MODSIG: wrong signature magic\n");
+		goto err1;
+	}
+
+	/* set to lenth */
+	len -= 2;
+	tmp -= 2;
+	siglen = __be16_to_cpup((u16 *)tmp);
+
+	if (len < siglen) {
+		pr_err("MODSIG: wrong signature\n");
+		goto err1;
+	}
+
+	len -= siglen;
+	tmp -= siglen;
+
+	rc = integrity_calc_digest("sha1", hdr, len, digest);
+	if (rc < 0)
+		goto err1;
+
+	rc = integrity_digsig_verify(INTEGRITY_KEYRING_MODULE, tmp, siglen,
+				     digest, sizeof(digest));
+	if (rc) {
+		pr_err("MODSIG: module verification failed: %d", rc);
+		print_hex_dump(KERN_ERR, "hash: ", DUMP_PREFIX_NONE, 32, 1,
+			       digest, sizeof(digest), 0);
+		goto err1;
+	}
+	rc = len;
+err1:
+	return rc;
+}
+
+static int __init module_check_init(void)
+{
+	return 0;
+}
+
+late_initcall(module_check_init);
+
+MODULE_DESCRIPTION("Module integrity verification");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

