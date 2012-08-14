Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2HNXdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:33:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44513 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab2HNXdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:33:35 -0400
Message-ID: <1344987332.4430.28.camel@footlong>
Subject: [PATCH V3 3/3] drivers/char/tpm: Add securityfs support for event
 log
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, key@linux.vnet.ibm.com, adlai@us.ibm.com,
        adlai@linux.vnet.ibm.com
Date: Tue, 14 Aug 2012 18:35:32 -0500
In-Reply-To: <1344986638.4430.22.camel@footlong>
References: <1344986638.4430.22.camel@footlong>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081423-2356-0000-0000-00000148720D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch retrieves the event log data from the device tree
during file open. The event log data will then displayed through
securityfs.

Signed-off-by: Ashley Lai <adlai@us.ibm.com>
---
 drivers/char/tpm/Makefile       |    5 +++
 drivers/char/tpm/tpm.h          |   12 ------
 drivers/char/tpm/tpm_eventlog.h |   15 ++++++++
 drivers/char/tpm/tpm_of.c       |   73 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+), 12 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_of.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 547509d..9080cc4 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -5,6 +5,11 @@ obj-$(CONFIG_TCG_TPM) += tpm.o
 ifdef CONFIG_ACPI
 	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
 	tpm_bios-objs += tpm_eventlog.o tpm_acpi.o
+else
+ifdef CONFIG_TCG_IBMVTPM
+	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
+	tpm_bios-objs += tpm_eventlog.o tpm_of.o
+endif
 endif
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_TIS_I2C_INFINEON) += tpm_i2c_infineon.o
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 870fde7..f1af738 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -327,15 +327,3 @@ extern int tpm_pm_suspend(struct device *);
 extern int tpm_pm_resume(struct device *);
 extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *);
-#ifdef CONFIG_ACPI
-extern struct dentry ** tpm_bios_log_setup(char *);
-extern void tpm_bios_log_teardown(struct dentry **);
-#else
-static inline struct dentry ** tpm_bios_log_setup(char *name)
-{
-	return NULL;
-}
-static inline void tpm_bios_log_teardown(struct dentry **dir)
-{
-}
-#endif
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 8e23ccd..e7da086 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -68,4 +68,19 @@ enum tcpa_pc_event_ids {
 };
 
 int read_log(struct tpm_bios_log *log);
+
+#if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
+	defined(CONFIG_ACPI)
+extern struct dentry **tpm_bios_log_setup(char *);
+extern void tpm_bios_log_teardown(struct dentry **);
+#else
+static inline struct dentry **tpm_bios_log_setup(char *name)
+{
+	return NULL;
+}
+static inline void tpm_bios_log_teardown(struct dentry **dir)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
new file mode 100644
index 0000000..98ba2bd
--- /dev/null
+++ b/drivers/char/tpm/tpm_of.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright 2012 IBM Corporation
+ *
+ * Author: Ashley Lai <adlai@us.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * Read the event log created by the firmware on PPC64
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/of.h>
+
+#include "tpm.h"
+#include "tpm_eventlog.h"
+
+int read_log(struct tpm_bios_log *log)
+{
+	struct device_node *np;
+	const u32 *sizep;
+	const __be64 *basep;
+
+	if (log->bios_event_log != NULL) {
+		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
+		return -EFAULT;
+	}
+
+	np = of_find_node_by_name(NULL, "ibm,vtpm");
+	if (!np) {
+		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
+		return -ENODEV;
+	}
+
+	sizep = of_get_property(np, "linux,sml-size", NULL);
+	if (sizep == NULL) {
+		pr_err("%s: ERROR - SML size not found\n", __func__);
+		goto cleanup_eio;
+	}
+	if (*sizep == 0) {
+		pr_err("%s: ERROR - event log area empty\n", __func__);
+		goto cleanup_eio;
+	}
+
+	basep = of_get_property(np, "linux,sml-base", NULL);
+	if (basep == NULL) {
+		pr_err(KERN_ERR "%s: ERROR - SML not found\n", __func__);
+		goto cleanup_eio;
+	}
+
+	of_node_put(np);
+	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
+	if (!log->bios_event_log) {
+		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
+		       __func__);
+		return -ENOMEM;
+	}
+
+	log->bios_event_log_end = log->bios_event_log + *sizep;
+
+	memcpy(log->bios_event_log, __va(be64_to_cpup(basep)), *sizep);
+
+	return 0;
+
+cleanup_eio:
+	of_node_put(np);
+	return -EIO;
+}
-- 
1.7.1


