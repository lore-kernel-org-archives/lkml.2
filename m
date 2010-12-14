Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab0LNMvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:51:51 -0500
Received: from 27.mail-out.ovh.net ([91.121.30.210]:48563 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759009Ab0LNMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:51:49 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Dec 2010 07:51:49 EST
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: [PATCH] base: add sysfs socs info
Date: Tue, 14 Dec 2010 13:40:17 +0100
Message-Id: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
X-Ovh-Tracer-Id: 7407014013661588248
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this provide an easy way to register soc information

arch, family, model, id, revision

as this for at91sam9g20

$ cat /sys/devices/system/soc/soc0/arch
current
$ cat /sys/devices/system/soc/soc0/family
at91
$ cat /sys/devices/system/soc/soc0/id
at91sam9g20
$ cat /sys/devices/system/soc/soc0/model
0x00000000019905a0
$ cat /sys/devices/system/soc/soc0/revision
1.1

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Patrice VILCHEZ <patrice.vilchez@atmel.com>
---
 drivers/base/Makefile |    3 +-
 drivers/base/base.h   |    1 +
 drivers/base/init.c   |    1 +
 drivers/base/soc.c    |  124 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/soc.h   |   27 +++++++++++
 5 files changed, 155 insertions(+), 1 deletions(-)
 create mode 100644 drivers/base/soc.c
 create mode 100644 include/linux/soc.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 5f51c3b..cf3e59f 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -3,7 +3,8 @@
 obj-y			:= core.o sys.o bus.o dd.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
-			   attribute_container.o transport_class.o
+			   attribute_container.o transport_class.o \
+			   soc.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
diff --git a/drivers/base/base.h b/drivers/base/base.h
index 2ca7f5b..e2daaf6 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -107,6 +107,7 @@ static inline int hypervisor_init(void) { return 0; }
 extern int platform_bus_init(void);
 extern int system_bus_init(void);
 extern int cpu_dev_init(void);
+extern int soc_dev_init(void);
 
 extern int bus_add_device(struct device *dev);
 extern void bus_probe_device(struct device *dev);
diff --git a/drivers/base/init.c b/drivers/base/init.c
index c8a934e..f908faa 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -33,5 +33,6 @@ void __init driver_init(void)
 	platform_bus_init();
 	system_bus_init();
 	cpu_dev_init();
+	soc_dev_init();
 	memory_dev_init();
 }
diff --git a/drivers/base/soc.c b/drivers/base/soc.c
new file mode 100644
index 0000000..c24bb41
--- /dev/null
+++ b/drivers/base/soc.c
@@ -0,0 +1,124 @@
+/*
+ * drivers/base/soc.c - basic SOC class support
+ *
+ * Copyright (C) 2010 Jean-Chrisotphe PLAGNIOL-VILLARD * <plagnioj@jcrosoft.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/sysdev.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/soc.h>
+#include <linux/device.h>
+
+#include "base.h"
+
+static int nb_socs;
+
+struct sysdev_class soc_sysdev_class = {
+	.name = "soc",
+};
+EXPORT_SYMBOL_GPL(soc_sysdev_class);
+
+#define print_u64_attr(field)							\
+static ssize_t print_socs_##field(struct sys_device *dev,			\
+				  struct sysdev_attribute *attr, char *buf)	\
+{										\
+	struct soc *soc = container_of(dev, struct soc, sysdev);		\
+										\
+	return sprintf(buf, "0x%016Lx\n", soc->field);				\
+}										\
+static SYSDEV_ATTR(field, 0444, print_socs_##field, NULL);			\
+
+#define print_str_attr(field)							\
+static ssize_t print_socs_##field(struct sys_device *dev,			\
+				  struct sysdev_attribute *attr, char *buf)	\
+{										\
+	struct soc *soc = container_of(dev, struct soc, sysdev);		\
+										\
+	return sprintf(buf, "%s\n", soc->field);				\
+}										\
+static SYSDEV_ATTR(field, 0444, print_socs_##field, NULL);			\
+
+print_u64_attr(id)
+print_str_attr(arch)
+print_str_attr(family)
+print_str_attr(model)
+print_str_attr(revision)
+
+static char *arch_current = "current";
+/*
+ * register_soc - Setup a sysfs device for a SOC.
+ *
+ * Initialize and register the SOC device.
+ */
+int register_soc(struct soc *soc)
+{
+	int err;
+
+	if (!soc)
+		return -EINVAL;
+
+	soc->sysdev.id = nb_socs;
+	soc->sysdev.cls = &soc_sysdev_class;
+
+	if (!soc->arch)
+		soc->arch = arch_current;
+
+	err = sysdev_register(&soc->sysdev);
+
+	if (err)
+		return err;
+
+	err = sysdev_create_file(&soc->sysdev, &attr_arch);
+
+	if (err)
+		goto end;
+
+	err = sysdev_create_file(&soc->sysdev, &attr_family);
+
+	if (err)
+		goto end0;
+
+	err = sysdev_create_file(&soc->sysdev, &attr_model);
+
+	if (err)
+		goto end1;
+
+	err = sysdev_create_file(&soc->sysdev, &attr_id);
+
+	if (err)
+		goto end2;
+
+	err = sysdev_create_file(&soc->sysdev, &attr_revision);
+
+	if (err)
+		goto end3;
+
+	nb_socs++;
+
+	return 0;
+
+end3:
+	sysdev_remove_file(&soc->sysdev, &attr_id);
+end2:
+	sysdev_remove_file(&soc->sysdev, &attr_model);
+end1:
+	sysdev_remove_file(&soc->sysdev, &attr_family);
+end0:
+	sysdev_remove_file(&soc->sysdev, &attr_arch);
+end:
+	sysdev_unregister(&soc->sysdev);
+
+	return err;
+}
+
+int __init soc_dev_init(void)
+{
+	nb_socs = 0;
+
+	return sysdev_class_register(&soc_sysdev_class);
+}
diff --git a/include/linux/soc.h b/include/linux/soc.h
new file mode 100644
index 0000000..55e6ea2
--- /dev/null
+++ b/include/linux/soc.h
@@ -0,0 +1,27 @@
+/*
+ * include/linux/soc.h - generic soc definition
+ *
+ * Copyright (C) 2010 Jean-Chrisotphe PLAGNIOL-VILLARD * <plagnioj@jcrosoft.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _LINUX_SOC_H_
+#define _LINUX_OSC_H_
+
+#include <linux/sysdev.h>
+
+struct soc {
+	u64 id;
+	char *arch;
+	char *family;
+	char *model;
+	char *revision;
+	struct sys_device sysdev;
+};
+
+extern int register_soc(struct soc *soc);
+extern struct sysdev_class soc_sysdev_class;
+
+#endif /* _LINUX_SOC_H_ */
-- 
1.7.2.3

