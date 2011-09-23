Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1IWMsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:48:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52644 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab1IWMsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:48:07 -0400
thread-index: Acx57wasUQq65QswTM6O0j2ayskqsQ==
Content-Transfer-Encoding: 8BIT
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
From: Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Paul Walmsley" <paul@pwsan.com>, "Kevin Hilman" <khilman@ti.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>
Subject: [PATCHv9 05/18] mfd: omap-prm: add driver skeleton
Date: Fri, 23 Sep 2011 15:46:13 +0300
Message-ID: <1316781986-30642-6-git-send-email-t-kristo@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver will eventually support OMAP soc PRM module features, e.g. PRCM
chain interrupts and voltage processor / controller. This patch only adds
basic skeleton for the driver that can be probed for omap3 and omap4.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/Kconfig           |    7 +++++
 drivers/mfd/Makefile          |    2 +
 drivers/mfd/omap-prm-common.c |   24 ++++++++++++++++
 drivers/mfd/omap3xxx-prm.c    |   60 +++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/omap4xxx-prm.c    |   60 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/omap-prm.h  |   24 ++++++++++++++++
 6 files changed, 177 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/omap-prm-common.c
 create mode 100644 drivers/mfd/omap3xxx-prm.c
 create mode 100644 drivers/mfd/omap4xxx-prm.c
 create mode 100644 include/linux/mfd/omap-prm.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 21574bd..1ae2571 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -770,6 +770,13 @@ config MFD_AAT2870_CORE
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+config OMAP_PRM
+	bool "OMAP Power and Reset Management driver"
+	depends on (ARCH_OMAP) && PM
+	help
+	  Say Y to enable support for the OMAP Power and Reset Management
+	  driver.
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index c580203..503d85d 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -102,3 +102,5 @@ obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
 obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
+obj-$(CONFIG_OMAP_PRM)		+= omap-prm-common.o omap3xxx-prm.o \
+				   omap4xxx-prm.o
diff --git a/drivers/mfd/omap-prm-common.c b/drivers/mfd/omap-prm-common.c
new file mode 100644
index 0000000..39b199c8
--- /dev/null
+++ b/drivers/mfd/omap-prm-common.c
@@ -0,0 +1,24 @@
+/*
+ * OMAP Power and Reset Management (PRM) driver common functionality
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * Author: Tero Kristo <t-kristo@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/err.h>
+
+MODULE_AUTHOR("Tero Kristo <t-kristo@ti.com>");
+MODULE_DESCRIPTION("OMAP PRM core driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/omap3xxx-prm.c b/drivers/mfd/omap3xxx-prm.c
new file mode 100644
index 0000000..177aced
--- /dev/null
+++ b/drivers/mfd/omap3xxx-prm.c
@@ -0,0 +1,60 @@
+/*
+ * OMAP Power and Reset Management (PRM) driver for OMAP3xxx
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * Author: Tero Kristo <t-kristo@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/omap-prm.h>
+
+#define DRIVER_NAME "prm3xxx"
+
+static int __devinit omap3xxx_prm_probe(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int __devexit omap3xxx_prm_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver omap3xxx_prm_driver = {
+	.probe		= omap3xxx_prm_probe,
+	.remove		= __devexit_p(omap3xxx_prm_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRIVER_NAME,
+	},
+};
+
+static int __init omap3xxx_prm_init(void)
+{
+	return platform_driver_register(&omap3xxx_prm_driver);
+}
+module_init(omap3xxx_prm_init);
+
+static void __exit omap3xxx_prm_exit(void)
+{
+	platform_driver_unregister(&omap3xxx_prm_driver);
+}
+module_exit(omap3xxx_prm_exit);
+
+MODULE_ALIAS("platform:"DRIVER_NAME);
+MODULE_AUTHOR("Tero Kristo <t-kristo@ti.com>");
+MODULE_DESCRIPTION("OMAP3xxx PRM driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/omap4xxx-prm.c b/drivers/mfd/omap4xxx-prm.c
new file mode 100644
index 0000000..9de8f3e
--- /dev/null
+++ b/drivers/mfd/omap4xxx-prm.c
@@ -0,0 +1,60 @@
+/*
+ * OMAP Power and Reset Management (PRM) driver for OMAP4xxx
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * Author: Tero Kristo <t-kristo@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/omap-prm.h>
+
+#define DRIVER_NAME "prm4xxx"
+
+static int __devinit omap4xxx_prm_probe(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int __devexit omap4xxx_prm_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver omap4xxx_prm_driver = {
+	.probe		= omap4xxx_prm_probe,
+	.remove		= __devexit_p(omap4xxx_prm_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRIVER_NAME,
+	},
+};
+
+static int __init omap4xxx_prm_init(void)
+{
+	return platform_driver_register(&omap4xxx_prm_driver);
+}
+module_init(omap4xxx_prm_init);
+
+static void __exit omap4xxx_prm_exit(void)
+{
+	platform_driver_unregister(&omap4xxx_prm_driver);
+}
+module_exit(omap4xxx_prm_exit);
+
+MODULE_ALIAS("platform:"DRIVER_NAME);
+MODULE_AUTHOR("Tero Kristo <t-kristo@ti.com>");
+MODULE_DESCRIPTION("OMAP4xxx PRM driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/omap-prm.h b/include/linux/mfd/omap-prm.h
new file mode 100644
index 0000000..ddc814e
--- /dev/null
+++ b/include/linux/mfd/omap-prm.h
@@ -0,0 +1,28 @@
+/*
+ * OMAP Power and Reset Management (PRM) driver
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * Author: Tero Kristo <t-kristo@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __LINUX_MFD_OMAP_PRM_H__
+#define __LINUX_MFD_OMAP_PRM_H__
+
+#ifdef CONFIG_OMAP_PRM
+int omap_prcm_event_to_irq(const char *name);
+#else
+static inline int omap_prcm_event_to_irq(const char *name) { return -ENOENT; }
+#endif
+
+struct omap_prm_platform_config {
+	int irq;
+	void __iomem *base;
+};
+
+#endif
-- 
1.7.4.1


Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

