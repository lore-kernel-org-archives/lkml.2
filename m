Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2HGUAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:00:49 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56975 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab2HGUAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:00:45 -0400
Message-ID: <1344369479.24990.9.camel@footlong>
Subject: [PATCH 3/3] drivers/char/tpm: Add securityfs support for event log
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, key@linux.vnet.ibm.com, adlai@us.ibm.com,
        adlai@linux.vnet.ibm.com
Date: Tue, 07 Aug 2012 14:57:59 -0500
In-Reply-To: <1344367748.24990.1.camel@footlong>
References: <1344367748.24990.1.camel@footlong>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080720-7182-0000-0000-000002352570
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch retrieves the event log from the device tree and the
event log data will be displayed through securityfs.

Signed-off-by: Ashley Lai <adlai@us.ibm.com>
---
 drivers/char/tpm/Makefile         |    8 ++++-
 drivers/char/tpm/tpm.h            |   12 ------
 drivers/char/tpm/tpm_eventlog.c   |    7 ++++
 drivers/char/tpm/tpm_eventlog.h   |   24 +++++++++++++
 drivers/char/tpm/tpm_noeventlog.c |   21 +++++++++++
 drivers/char/tpm/tpm_of.c         |   68 +++++++++++++++++++++++++++++++++++++
 6 files changed, 127 insertions(+), 13 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_noeventlog.c
 create mode 100644 drivers/char/tpm/tpm_of.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 547509d..b53da57 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,9 +2,15 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
+obj-$(CONFIG_TCG_TPM) += tpm_bios.o
 ifdef CONFIG_ACPI
-	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
 	tpm_bios-objs += tpm_eventlog.o tpm_acpi.o
+else
+ifdef CONFIG_TCG_IBMVTPM
+	tpm_bios-objs += tpm_eventlog.o tpm_of.o
+else
+	tpm_bios-objs += tpm_eventlog.o tpm_noeventlog.o
+endif
 endif
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_TIS_I2C_INFINEON) += tpm_i2c_infineon.o
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index aece857..08f6a07 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -304,15 +304,3 @@ extern int tpm_pm_suspend(struct device *, pm_message_t);
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
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index 84ddc55..814b202 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -24,6 +24,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 
 #include "tpm.h"
 #include "tpm_eventlog.h"
@@ -369,6 +370,9 @@ struct dentry **tpm_bios_log_setup(char *name)
 {
 	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
 
+	if (TPM_NO_EVENT_LOG)
+		return NULL;
+
 	tpm_dir = securityfs_create_dir(name, NULL);
 	if (is_bad(tpm_dir))
 		goto out;
@@ -412,6 +416,9 @@ void tpm_bios_log_teardown(struct dentry **lst)
 {
 	int i;
 
+	if (TPM_NO_EVENT_LOG)
+		return;
+
 	for (i = 0; i < 3; i++)
 		securityfs_remove(lst[i]);
 }
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 8e23ccd..5fbea94 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -68,4 +68,28 @@ enum tcpa_pc_event_ids {
 };
 
 int read_log(struct tpm_bios_log *log);
+
+#if defined(CONFIG_ACPI) || defined(CONFIG_PPC64)
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
+#ifdef CONFIG_PPC64
+#define TPM_NO_EVENT_LOG !of_find_node_by_name(NULL, "ibm,vtpm")
+#else
+#ifdef CONFIG_ACPI
+#define TPM_NO_EVENT_LOG 0
+#else
+#define TPM_NO_EVENT_LOG 1
+#endif
+#endif
+
 #endif
diff --git a/drivers/char/tpm/tpm_noeventlog.c b/drivers/char/tpm/tpm_noeventlog.c
new file mode 100644
index 0000000..f30a2bf
--- /dev/null
+++ b/drivers/char/tpm/tpm_noeventlog.c
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2012 IBM Corporation
+ *
+ * Author: Ashley Lai <adlai@us.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/slab.h>
+#include "tpm_eventlog.h"
+
+int read_log(struct tpm_bios_log *log)
+{
+	return -EINVAL;
+}
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
new file mode 100644
index 0000000..6d44adb
--- /dev/null
+++ b/drivers/char/tpm/tpm_of.c
@@ -0,0 +1,68 @@
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
+		return -EIO;
+	}
+	if (*sizep == 0) {
+		pr_err("%s: ERROR - event log area empty\n", __func__);
+		return -EIO;
+	}
+
+	basep = of_get_property(np, "linux,sml-base", NULL);
+	if (basep == NULL) {
+		pr_err(KERN_ERR "%s: ERROR - SML not found\n", __func__);
+		return -EIO;
+	}
+
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
+}
-- 
1.7.1


