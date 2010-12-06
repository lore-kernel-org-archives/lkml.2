Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0LFWRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:17:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35686 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab0LFWQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:16:15 -0500
From: David Sin <davidsin@ti.com>
To: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: David Sin <davidsin@ti.com>, Lajos Molnar <molnar@ti.com>
Subject: [PATCH 1/9] TILER-DMM: DMM-PAT driver for TI TILER
Date: Mon,  6 Dec 2010 16:27:18 -0600
Message-Id: <1291674446-10766-2-git-send-email-davidsin@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291674446-10766-1-git-send-email-davidsin@ti.com>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DMM-PAT initialization and programming.

Signed-off-by: David Sin <davidsin@ti.com>
Signed-off-by: Lajos Molnar <molnar@ti.com>
---
 arch/arm/mach-omap2/include/mach/dmm.h |   92 ++++++++++++++++
 drivers/misc/tiler/dmm-main.c          |  187 ++++++++++++++++++++++++++++++++
 2 files changed, 279 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/include/mach/dmm.h
 create mode 100644 drivers/misc/tiler/dmm-main.c

diff --git a/arch/arm/mach-omap2/include/mach/dmm.h b/arch/arm/mach-omap2/include/mach/dmm.h
new file mode 100644
index 0000000..33a1215
--- /dev/null
+++ b/arch/arm/mach-omap2/include/mach/dmm.h
@@ -0,0 +1,92 @@
+/*
+ * Dynamic Memory Manager (DMM) driver support functions for
+ * TI DMM-TILER hardware block.
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef DMM_H
+#define DMM_H
+
+#define DMM_TILER_OR__0       0x220
+#define DMM_TILER_OR__1       0x224
+#define DMM_PAT_VIEW__0       0x420
+#define DMM_PAT_VIEW__1       0x424
+#define DMM_PAT_VIEW_MAP__0   0x440
+#define DMM_PAT_VIEW_MAP_BASE 0x460
+#define DMM_PAT_IRQSTATUS_RAW 0x480
+#define DMM_PAT_IRQSTATUS     0x490
+#define DMM_PAT_STATUS__0     0x4C0
+#define DMM_PAT_DESCR__0      0x500
+#define DMM_PAT_AREA__0       0x504
+#define DMM_PAT_CTRL__0       0x508
+#define DMM_PAT_DATA__0       0x50C
+
+/*
+ * Physical Address Translator (PAT) refill programming mode
+ */
+enum pat_mode {
+	MANUAL,
+	AUTO
+};
+
+/*
+ * Area definition for DMM physical address translator
+ */
+struct pat_area {
+	s8 x0:8;
+	s8 y0:8;
+	s8 x1:8;
+	s8 y1:8;
+};
+
+/*
+ * DMM physical address translator control
+ */
+struct pat_ctrl {
+	s32 start:4;
+	s32 dir:4;
+	s32 lut_id:8;
+	s32 sync:12;
+	s32 ini:4;
+};
+
+/*
+ * Physical Address Translator (PAT) descriptor
+ */
+struct pat {
+	struct pat *next;
+	struct pat_area area;
+	struct pat_ctrl ctrl;
+	u32 data;
+};
+
+/*
+ * DMM device data
+ */
+struct dmm {
+	const char *oh_name;
+	void __iomem *base;
+	int irq;
+};
+
+/*
+ * Create and initialize the physical address translator
+ */
+struct dmm *dmm_pat_init(u32 id);
+
+/*
+ * Program the physical address translator
+ */
+int dmm_pat_refill(struct dmm *dmm, struct pat *desc, enum pat_mode mode);
+
+#endif
diff --git a/drivers/misc/tiler/dmm-main.c b/drivers/misc/tiler/dmm-main.c
new file mode 100644
index 0000000..f337bd9
--- /dev/null
+++ b/drivers/misc/tiler/dmm-main.c
@@ -0,0 +1,187 @@
+/*
+ * DMM driver support functions for TI OMAP processors.
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+
+#include <mach/dmm.h>
+
+#define MASK(msb, lsb) (((1 << ((msb) + 1 - (lsb))) - 1) << (lsb))
+#define SET_FLD(reg, msb, lsb, val) \
+(((reg) & ~MASK((msb), (lsb))) | (((val) << (lsb)) & MASK((msb), (lsb))))
+#define MAX_RETRY_MS	1000
+
+static struct dmm *dmm;
+
+static int dmm_probe(struct platform_device *dev)
+{
+	if (dev)
+		dmm = dev->dev.platform_data;
+
+	if (dmm && dmm->base) {
+		writel(0x88888888, dmm->base + DMM_TILER_OR__0);
+		writel(0x88888888, dmm->base + DMM_TILER_OR__1);
+		return 0;
+	}
+	return -EFAULT;
+}
+
+static int dmm_remove(struct platform_device *dev)
+{
+	return 0;
+}
+
+static struct platform_driver dmm_driver = {
+	.probe = dmm_probe,
+	.remove = dmm_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "dmm",
+	},
+};
+
+int dmm_pat_refill(struct dmm *dmm, struct pat *pd, enum pat_mode mode)
+{
+	void __iomem *r;
+	u32 v, i;
+
+	if (!dmm || !dmm->base || !pd)
+		return -EFAULT;
+
+	/* Only manual refill supported */
+	if (mode != MANUAL)
+		return -EFAULT;
+
+	/* Check that the DMM_PAT_STATUS register has not reported an error */
+	r = dmm->base + DMM_PAT_STATUS__0;
+	v = readl(r);
+	if (WARN(v & 0xFC00, KERN_ERR "dmm_pat_refill() error.\n"))
+		return -EIO;
+
+	/* Set "next" register to NULL */
+	r = dmm->base + DMM_PAT_DESCR__0;
+	v = readl(r);
+	v = SET_FLD(v, 31, 4, (u32) NULL);
+	writel(v, r);
+
+	/* Set area to be refilled */
+	r = dmm->base + DMM_PAT_AREA__0;
+	v = readl(r);
+	v = SET_FLD(v, 30, 24, pd->area.y1);
+	v = SET_FLD(v, 23, 16, pd->area.x1);
+	v = SET_FLD(v, 14, 8, pd->area.y0);
+	v = SET_FLD(v, 7, 0, pd->area.x0);
+	writel(v, r);
+
+	/* First, clear the DMM_PAT_IRQSTATUS register */
+	writel(0xFFFFFFFF, dmm->base + DMM_PAT_IRQSTATUS);
+
+	i = 1000;
+	while (readl(dmm->base + DMM_PAT_IRQSTATUS_RAW) != 0) {
+		if (--i == 0)
+			return -EFAULT;
+		udelay(1);
+	}
+
+	/* Fill data register */
+	v = readl(dmm->base + DMM_PAT_DATA__0);
+
+	v = SET_FLD(v, 31, 4, pd->data >> 4);
+	writel(v, r);
+
+	/* Read back PAT_DATA__0 to see if write was successful */
+	i = 1000;
+	while (readl(r) != pd->data) {
+		if (--i == 0)
+			return -EFAULT;
+		udelay(1);
+	}
+
+	v = readl(dmm->base + DMM_PAT_CTRL__0);
+	v = SET_FLD(v, 31, 28, pd->ctrl.ini);
+	v = SET_FLD(v, 16, 16, pd->ctrl.sync);
+	v = SET_FLD(v, 9, 8, pd->ctrl.lut_id);
+	v = SET_FLD(v, 6, 4, pd->ctrl.dir);
+	v = SET_FLD(v, 0, 0, pd->ctrl.start);
+	writel(v, r);
+
+	/* Check if PAT_IRQSTATUS_RAW is set after the PAT has been refilled */
+	i = 1000;
+	while ((readl(dmm->base + DMM_PAT_IRQSTATUS_RAW) & 0x3) != 0x3) {
+		if (--i == 0)
+			return -EFAULT;
+		udelay(1);
+	}
+
+	/* Again, clear the DMM_PAT_IRQSTATUS register */
+	writel(0xFFFFFFFF, dmm->base + DMM_PAT_IRQSTATUS);
+
+	i = 1000;
+	while (readl(dmm->base + DMM_PAT_IRQSTATUS_RAW) != 0) {
+		if (--i == 0)
+			return -EFAULT;
+		udelay(1);
+	}
+
+	/* Again, set "next" register to NULL to clear any PAT STATUS errors */
+	v = readl(dmm->base + DMM_PAT_DESCR__0);
+	v = SET_FLD(v, 31, 4, (u32) NULL);
+	writel(v, r);
+
+	/*
+	 * Now, check that the DMM_PAT_STATUS register
+	 * has not reported an error before exiting.
+	 */
+	v = readl(dmm->base + DMM_PAT_STATUS__0);
+	if (WARN(v & 0xFC00, KERN_ERR "dmm_pat_refill() error.\n"))
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmm_pat_refill);
+
+struct dmm *dmm_pat_init(u32 id)
+{
+	if (dmm && dmm->base) {
+		writel(0x88888888, dmm->base + DMM_PAT_VIEW__0);
+		writel(0x88888888, dmm->base + DMM_PAT_VIEW__1);
+		writel(0x80808080, dmm->base + DMM_PAT_VIEW_MAP__0);
+		writel(0x80000000, dmm->base + DMM_PAT_VIEW_MAP_BASE);
+	}
+
+	return dmm;
+}
+EXPORT_SYMBOL_GPL(dmm_pat_init);
+
+static s32 __init dmm_init(void)
+{
+	return platform_driver_register(&dmm_driver);
+}
+
+static void __exit dmm_exit(void)
+{
+	platform_driver_unregister(&dmm_driver);
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("David Sin <davidsin@ti.com>");
+MODULE_AUTHOR("Lajos Molnar <molnar@ti.com>");
+module_init(dmm_init);
+module_exit(dmm_exit);
-- 
1.7.0.4

