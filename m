Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab2CGW3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:29:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39875 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2CGW2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:28:51 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <b32955@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 1/3] drivers: base: add support for stmp-style devices
Date: Wed,  7 Mar 2012 23:28:32 +0100
Message-Id: <1331159314-12022-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
References: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MX23/28 use IP cores which follow a register layout I have first seen on
STMP3xxx SoCs. In this layout, every register actually has four u32:

 1.) to store a value directly
 2.) a SET register where every 1-bit sets the corresponding bit,
     others are unaffected
 3.) same with a CLR register
 4.) same with a TOG (toggle) register

Also, the 2 MSBs in register 0 are always the same and can be used to reset
the IP core.

All this is strictly speaking not mach-specific (but IP core specific) and,
thus, doesn't need to be in mach-mxs/include. At least mx6 also uses IP cores
following this stmp-style. So:

Introduce a stmp-style device, put the code and defines for that in a public
place (drivers/base/), and let drivers for stmp-style devices select that code.
To avoid regressions and ease reviewing, the actual code is simply copied from
mach-mxs. It definately wants updates, but those need a seperate patch series.

Voila, mach dependency gone, reusable code introduced. Note that I didn't
remove the duplicated code from mach-mxs yet, first the drivers have to be
converted.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/base/Kconfig        |    3 ++
 drivers/base/Makefile       |    1 +
 drivers/base/stmp_device.c  |   80 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/stmp_device.h |   19 ++++++++++
 4 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/stmp_device.c
 create mode 100644 include/linux/stmp_device.h

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 7be9f79..bcd3356 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -176,6 +176,9 @@ config GENERIC_CPU_DEVICES
 	bool
 	default n
 
+config STMP_DEVICE
+	bool
+
 source "drivers/base/regmap/Kconfig"
 
 config DMA_SHARED_BUFFER
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 610f999..86e4134 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -18,6 +18,7 @@ ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
 endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
+obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 obj-$(CONFIG_REGMAP)	+= regmap/
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
diff --git a/drivers/base/stmp_device.c b/drivers/base/stmp_device.c
new file mode 100644
index 0000000..8ac9bcc
--- /dev/null
+++ b/drivers/base/stmp_device.c
@@ -0,0 +1,80 @@
+/*
+ * Copyright (C) 1999 ARM Limited
+ * Copyright (C) 2000 Deep Blue Solutions Ltd
+ * Copyright 2006-2007,2010 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008 Juergen Beisert, kernel@pengutronix.de
+ * Copyright 2009 Ilya Yanok, Emcraft Systems Ltd, yanok@emcraft.com
+ * Copyright (C) 2011 Wolfram Sang, Pengutronix e.K.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/stmp_device.h>
+
+#define STMP_MODULE_CLKGATE	(1 << 30)
+#define STMP_MODULE_SFTRST	(1 << 31)
+
+/*
+ * Clear the bit and poll it cleared.  This is usually called with
+ * a reset address and mask being either SFTRST(bit 31) or CLKGATE
+ * (bit 30).
+ */
+static int stmp_clear_poll_bit(void __iomem *addr, u32 mask)
+{
+	int timeout = 0x400;
+
+	writel(mask, addr + STMP_OFFSET_REG_CLR);
+	udelay(1);
+	while ((readl(addr) & mask) && --timeout)
+		/* nothing */;
+
+	return !timeout;
+}
+
+int stmp_reset_block(void __iomem *reset_addr)
+{
+	int ret;
+	int timeout = 0x400;
+
+	/* clear and poll SFTRST */
+	ret = stmp_clear_poll_bit(reset_addr, STMP_MODULE_SFTRST);
+	if (unlikely(ret))
+		goto error;
+
+	/* clear CLKGATE */
+	writel(STMP_MODULE_CLKGATE, reset_addr + STMP_OFFSET_REG_CLR);
+
+	/* set SFTRST to reset the block */
+	writel(STMP_MODULE_SFTRST, reset_addr + STMP_OFFSET_REG_SET);
+	udelay(1);
+
+	/* poll CLKGATE becoming set */
+	while ((!(readl(reset_addr) & STMP_MODULE_CLKGATE)) && --timeout)
+		/* nothing */;
+	if (unlikely(!timeout))
+		goto error;
+
+	/* clear and poll SFTRST */
+	ret = stmp_clear_poll_bit(reset_addr, STMP_MODULE_SFTRST);
+	if (unlikely(ret))
+		goto error;
+
+	/* clear and poll CLKGATE */
+	ret = stmp_clear_poll_bit(reset_addr, STMP_MODULE_CLKGATE);
+	if (unlikely(ret))
+		goto error;
+
+	return 0;
+
+error:
+	pr_err("%s(%p): module reset timeout\n", __func__, reset_addr);
+	return -ETIMEDOUT;
+}
+EXPORT_SYMBOL(stmp_reset_block);
diff --git a/include/linux/stmp_device.h b/include/linux/stmp_device.h
new file mode 100644
index 0000000..d088de2
--- /dev/null
+++ b/include/linux/stmp_device.h
@@ -0,0 +1,19 @@
+/*
+ * basic functions for devices following the "stmp" style register layout
+ *
+ * Copyright (C) 2011 Wolfram Sang, Pengutronix e.K.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#ifndef __STMP_DEVICE_H__
+#define __STMP_DEVICE_H__
+
+#define STMP_OFFSET_REG_SET	0x4
+#define STMP_OFFSET_REG_CLR	0x8
+#define STMP_OFFSET_REG_TOG	0xc
+
+extern int stmp_reset_block(void __iomem *);
+#endif /* __STMP_DEVICE_H__ */
-- 
1.7.9.1

