Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab0I0QGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:06:25 -0400
Received: from mail.logicpd.com ([66.162.60.3]:29868 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759755Ab0I0QFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:05:50 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH v4 3/4] ARM: OMAP3: Add generic smsc911x support when connected to GPMC
Date: Mon, 27 Sep 2010 11:05:49 -0500
Message-Id: <1285603550-6382-4-git-send-email-tim.nordell@logicpd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com>
References: <1285603550-6382-1-git-send-email-tim.nordell@logicpd.com>
X-OriginalArrivalTime: 27 Sep 2010 16:05:47.0398 (UTC) FILETIME=[D8E3FA60:01CB5E5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce of a generic way to setup smsc911x based Ethernet
controller connected to GPMC similar to gpmc-smc91x but without
timing setup.

Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
---
 arch/arm/mach-omap2/Makefile                    |    3 +
 arch/arm/mach-omap2/gpmc-smsc911x.c             |  113 +++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h |   35 +++++++
 3 files changed, 151 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/gpmc-smsc911x.c
 create mode 100644 arch/arm/plat-omap/include/plat/gpmc-smsc911x.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 9feadd8..f7ec388 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -178,3 +178,6 @@ obj-y					+= $(nand-m) $(nand-y)
 
 smc91x-$(CONFIG_SMC91X)			:= gpmc-smc91x.o
 obj-y					+= $(smc91x-m) $(smc91x-y)
+
+smsc911x-$(CONFIG_SMSC911X)		:= gpmc-smsc911x.o
+obj-y					+= $(smsc911x-m) $(smsc911x-y)
diff --git a/arch/arm/mach-omap2/gpmc-smsc911x.c b/arch/arm/mach-omap2/gpmc-smsc911x.c
new file mode 100644
index 0000000..703f150
--- /dev/null
+++ b/arch/arm/mach-omap2/gpmc-smsc911x.c
@@ -0,0 +1,113 @@
+/*
+ * linux/arch/arm/mach-omap2/gpmc-smsc911x.c
+ *
+ * Copyright (C) 2009 Li-Pro.Net
+ * Stephan Linz <linz@li-pro.net>
+ *
+ * Modified from linux/arch/arm/mach-omap2/gpmc-smc91x.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/smsc911x.h>
+
+#include <plat/board.h>
+#include <plat/gpmc.h>
+#include <plat/gpmc-smsc911x.h>
+
+static struct omap_smsc911x_platform_data *gpmc_cfg;
+
+static struct resource gpmc_smsc911x_resources[] = {
+	[0] = {
+		.flags		= IORESOURCE_MEM,
+	},
+	[1] = {
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct smsc911x_platform_config gpmc_smsc911x_config = {
+	.phy_interface	= PHY_INTERFACE_MODE_MII,
+	.irq_polarity	= SMSC911X_IRQ_POLARITY_ACTIVE_LOW,
+	.irq_type	= SMSC911X_IRQ_TYPE_OPEN_DRAIN,
+	.flags		= SMSC911X_USE_16BIT,
+};
+
+static struct platform_device gpmc_smsc911x_device = {
+	.name		= "smsc911x",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(gpmc_smsc911x_resources),
+	.resource	= gpmc_smsc911x_resources,
+	.dev		= {
+		.platform_data = &gpmc_smsc911x_config,
+	},
+};
+
+/*
+ * Initialize smsc911x device connected to the GPMC. Note that we
+ * assume that pin multiplexing is done in the board-*.c file,
+ * or in the bootloader.
+ */
+void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *board_data)
+{
+	unsigned long cs_mem_base;
+	int ret;
+
+	gpmc_cfg = board_data;
+
+	if (gpmc_cs_request(gpmc_cfg->cs, SZ_16M, &cs_mem_base) < 0) {
+		printk(KERN_ERR "Failed to request GPMC mem for smsc911x\n");
+		return;
+	}
+
+	gpmc_smsc911x_resources[0].start = cs_mem_base + 0x0;
+	gpmc_smsc911x_resources[0].end = cs_mem_base + 0xff;
+
+	if (gpio_request(gpmc_cfg->gpio_irq, "smsc911x irq") < 0) {
+		printk(KERN_ERR "Failed to request GPIO%d for smsc911x IRQ\n",
+				gpmc_cfg->gpio_irq);
+		goto free1;
+	}
+
+	gpio_direction_input(gpmc_cfg->gpio_irq);
+	gpmc_smsc911x_resources[1].start = gpio_to_irq(gpmc_cfg->gpio_irq);
+	gpmc_smsc911x_resources[1].flags |=
+					(gpmc_cfg->flags & IRQF_TRIGGER_MASK);
+
+	if (gpio_is_valid(gpmc_cfg->gpio_reset)) {
+		ret = gpio_request(gpmc_cfg->gpio_reset, "smsc911x reset");
+		if (ret) {
+			printk(KERN_ERR "Failed to request GPIO%d for smsc911x reset\n",
+					gpmc_cfg->gpio_reset);
+			goto free2;
+		}
+
+		gpio_direction_output(gpmc_cfg->gpio_reset, 1);
+		gpio_set_value(gpmc_cfg->gpio_reset, 0);
+		msleep(100);
+		gpio_set_value(gpmc_cfg->gpio_reset, 1);
+	}
+
+	if (platform_device_register(&gpmc_smsc911x_device) < 0) {
+		printk(KERN_ERR "Unable to register smsc911x device\n");
+		gpio_free(gpmc_cfg->gpio_reset);
+		goto free2;
+	}
+
+	return;
+
+free2:
+	gpio_free(gpmc_cfg->gpio_irq);
+free1:
+	gpmc_cs_free(gpmc_cfg->cs);
+
+	printk(KERN_ERR "Could not initialize smsc911x\n");
+}
diff --git a/arch/arm/plat-omap/include/plat/gpmc-smsc911x.h b/arch/arm/plat-omap/include/plat/gpmc-smsc911x.h
new file mode 100644
index 0000000..e5f3a48
--- /dev/null
+++ b/arch/arm/plat-omap/include/plat/gpmc-smsc911x.h
@@ -0,0 +1,35 @@
+/*
+ * arch/arm/plat-omap/include/mach/gpmc-smsc911x.h
+ *
+ * Copyright (C) 2009 Li-Pro.Net
+ * Stephan Linz <linz@li-pro.net>
+ *
+ * Modified from arch/arm/plat-omap/include/mach/gpmc-smc91x.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARCH_OMAP_GPMC_SMSC911X_H__
+
+struct omap_smsc911x_platform_data {
+	int	cs;
+	int	gpio_irq;
+	int	gpio_reset;
+	u32	flags;
+};
+
+#if defined(CONFIG_SMSC911X) || \
+	defined(CONFIG_SMSC911X_MODULE)
+
+extern void gpmc_smsc911x_init(struct omap_smsc911x_platform_data *d);
+
+#else
+
+static inline void gpmc_smsc911x_init(struct omap_smsc911x_platform_data *d)
+{
+}
+
+#endif
+#endif
-- 
1.7.1

