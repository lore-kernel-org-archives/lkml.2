Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2BWOSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:18:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53370 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2BWOSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:18:36 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, <linux@arm.linux.org.uk>, <dwmw2@infradead.org>,
        <sameo@linux.intel.com>, "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH v5 2/3] arm:davinci: move emif driver to mfd framework
Date: Thu, 23 Feb 2012 19:28:23 +0530
Message-ID: <1330005504-25321-3-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move emif handling code from platform folder to multi functional
devices frame work. emif MFD driver adds "davinci_nand" and
"physmap-flash" as slave devices.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
Since v4:
Fix updating NAND/NOR platfrom data.
Since v3:
No change. Resending as 3/3 in patch changed.
Since v2:
Modified emif MFD driver to load multiple instance of NAND/NOR devices.
Since v1:
Patch generated using -M option.
 arch/arm/Kconfig                  |    1 +
 arch/arm/mach-davinci/Makefile    |    2 +-
 arch/arm/mach-davinci/aemif.c     |  133 ------------------------
 drivers/mfd/Makefile              |    1 +
 drivers/mfd/davinci_aemif.c       |  206 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/davinci_aemif.h |   14 +++
 6 files changed, 223 insertions(+), 134 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/aemif.c
 create mode 100644 drivers/mfd/davinci_aemif.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a48aecc..09dcb94 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -934,6 +934,7 @@ config ARCH_DAVINCI
 	select GENERIC_ALLOCATOR
 	select GENERIC_IRQ_CHIP
 	select ARCH_HAS_HOLES_MEMORYMODEL
+	select MFD_CORE
 	help
 	  Support for TI's DaVinci platform.
 
diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 2db78bd..8bab47c 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -5,7 +5,7 @@
 
 # Common objects
 obj-y 			:= time.o clock.o serial.o psc.o \
-			   dma.o usb.o common.o sram.o aemif.o
+			   dma.o usb.o common.o sram.o
 
 obj-$(CONFIG_DAVINCI_MUX)		+= mux.o
 
diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
deleted file mode 100644
index b67c115..0000000
--- a/arch/arm/mach-davinci/aemif.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
- * AEMIF support for DaVinci SoCs
- *
- * Copyright (C) 2010 Texas Instruments Incorporated. http://www.ti.com/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/err.h>
-#include <linux/clk.h>
-#include <linux/module.h>
-#include <linux/time.h>
-
-#include <linux/mfd/davinci_aemif.h>
-
-/* Timing value configuration */
-
-#define TA(x)		((x) << 2)
-#define RHOLD(x)	((x) << 4)
-#define RSTROBE(x)	((x) << 7)
-#define RSETUP(x)	((x) << 13)
-#define WHOLD(x)	((x) << 17)
-#define WSTROBE(x)	((x) << 20)
-#define WSETUP(x)	((x) << 26)
-
-#define TA_MAX		0x3
-#define RHOLD_MAX	0x7
-#define RSTROBE_MAX	0x3f
-#define RSETUP_MAX	0xf
-#define WHOLD_MAX	0x7
-#define WSTROBE_MAX	0x3f
-#define WSETUP_MAX	0xf
-
-#define TIMING_MASK	(TA(TA_MAX) | \
-				RHOLD(RHOLD_MAX) | \
-				RSTROBE(RSTROBE_MAX) |	\
-				RSETUP(RSETUP_MAX) | \
-				WHOLD(WHOLD_MAX) | \
-				WSTROBE(WSTROBE_MAX) | \
-				WSETUP(WSETUP_MAX))
-
-/*
- * aemif_calc_rate - calculate timing data.
- * @wanted: The cycle time needed in nanoseconds.
- * @clk: The input clock rate in kHz.
- * @max: The maximum divider value that can be programmed.
- *
- * On success, returns the calculated timing value minus 1 for easy
- * programming into AEMIF timing registers, else negative errno.
- */
-static int aemif_calc_rate(int wanted, unsigned long clk, int max)
-{
-	int result;
-
-	result = DIV_ROUND_UP((wanted * clk), NSEC_PER_MSEC) - 1;
-
-	pr_debug("%s: result %d from %ld, %d\n", __func__, result, clk, wanted);
-
-	/* It is generally OK to have a more relaxed timing than requested... */
-	if (result < 0)
-		result = 0;
-
-	/* ... But configuring tighter timings is not an option. */
-	else if (result > max)
-		result = -EINVAL;
-
-	return result;
-}
-
-/**
- * davinci_aemif_setup_timing - setup timing values for a given AEMIF interface
- * @t: timing values to be progammed
- * @base: The virtual base address of the AEMIF interface
- * @cs: chip-select to program the timing values for
- *
- * This function programs the given timing values (in real clock) into the
- * AEMIF registers taking the AEMIF clock into account.
- *
- * This function does not use any locking while programming the AEMIF
- * because it is expected that there is only one user of a given
- * chip-select.
- *
- * Returns 0 on success, else negative errno.
- */
-int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
-					void __iomem *base, unsigned cs)
-{
-	unsigned set, val;
-	int ta, rhold, rstrobe, rsetup, whold, wstrobe, wsetup;
-	unsigned offset = A1CR_OFFSET + cs * 4;
-	struct clk *aemif_clk;
-	unsigned long clkrate;
-
-	if (!t)
-		return 0;	/* Nothing to do */
-
-	aemif_clk = clk_get(NULL, "aemif");
-	if (IS_ERR(aemif_clk))
-		return PTR_ERR(aemif_clk);
-
-	clkrate = clk_get_rate(aemif_clk);
-
-	clkrate /= 1000;	/* turn clock into kHz for ease of use */
-
-	ta	= aemif_calc_rate(t->ta, clkrate, TA_MAX);
-	rhold	= aemif_calc_rate(t->rhold, clkrate, RHOLD_MAX);
-	rstrobe	= aemif_calc_rate(t->rstrobe, clkrate, RSTROBE_MAX);
-	rsetup	= aemif_calc_rate(t->rsetup, clkrate, RSETUP_MAX);
-	whold	= aemif_calc_rate(t->whold, clkrate, WHOLD_MAX);
-	wstrobe	= aemif_calc_rate(t->wstrobe, clkrate, WSTROBE_MAX);
-	wsetup	= aemif_calc_rate(t->wsetup, clkrate, WSETUP_MAX);
-
-	if (ta < 0 || rhold < 0 || rstrobe < 0 || rsetup < 0 ||
-			whold < 0 || wstrobe < 0 || wsetup < 0) {
-		pr_err("%s: cannot get suitable timings\n", __func__);
-		return -EINVAL;
-	}
-
-	set = TA(ta) | RHOLD(rhold) | RSTROBE(rstrobe) | RSETUP(rsetup) |
-		WHOLD(whold) | WSTROBE(wstrobe) | WSETUP(wsetup);
-
-	val = __raw_readl(base + offset);
-	val &= ~TIMING_MASK;
-	val |= set;
-	__raw_writel(val, base + offset);
-
-	return 0;
-}
-EXPORT_SYMBOL(davinci_aemif_setup_timing);
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b953bab..54fc267 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
 obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
 obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
 
+obj-${CONFIG_ARCH_DAVINCI}	+= davinci_aemif.o
 obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 obj-$(CONFIG_MFD_TI_SSP)	+= ti-ssp.o
diff --git a/drivers/mfd/davinci_aemif.c b/drivers/mfd/davinci_aemif.c
new file mode 100644
index 0000000..54d3561
--- /dev/null
+++ b/drivers/mfd/davinci_aemif.c
@@ -0,0 +1,206 @@
+/*
+ * AEMIF support for DaVinci SoCs
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated. http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/time.h>
+#include <linux/mfd/davinci_aemif.h>
+#include <linux/mtd/physmap.h>
+#include <linux/slab.h>
+#include <mach/nand.h>
+
+/* Timing value configuration */
+
+#define TA(x)		((x) << 2)
+#define RHOLD(x)	((x) << 4)
+#define RSTROBE(x)	((x) << 7)
+#define RSETUP(x)	((x) << 13)
+#define WHOLD(x)	((x) << 17)
+#define WSTROBE(x)	((x) << 20)
+#define WSETUP(x)	((x) << 26)
+
+#define TA_MAX		0x3
+#define RHOLD_MAX	0x7
+#define RSTROBE_MAX	0x3f
+#define RSETUP_MAX	0xf
+#define WHOLD_MAX	0x7
+#define WSTROBE_MAX	0x3f
+#define WSETUP_MAX	0xf
+
+#define TIMING_MASK	(TA(TA_MAX) | \
+				RHOLD(RHOLD_MAX) | \
+				RSTROBE(RSTROBE_MAX) |	\
+				RSETUP(RSETUP_MAX) | \
+				WHOLD(WHOLD_MAX) | \
+				WSTROBE(WSTROBE_MAX) | \
+				WSETUP(WSETUP_MAX))
+
+/*
+ * aemif_calc_rate - calculate timing data.
+ * @wanted: The cycle time needed in nanoseconds.
+ * @clk: The input clock rate in kHz.
+ * @max: The maximum divider value that can be programmed.
+ *
+ * On success, returns the calculated timing value minus 1 for easy
+ * programming into AEMIF timing registers, else negative errno.
+ */
+static int aemif_calc_rate(int wanted, unsigned long clk, int max)
+{
+	int result;
+
+	result = DIV_ROUND_UP((wanted * clk), NSEC_PER_MSEC) - 1;
+
+	pr_debug("%s: result %d from %ld, %d\n", __func__, result, clk, wanted);
+
+	/* It is generally OK to have a more relaxed timing than requested... */
+	if (result < 0)
+		result = 0;
+
+	/* ... But configuring tighter timings is not an option. */
+	else if (result > max)
+		result = -EINVAL;
+
+	return result;
+}
+
+/**
+ * davinci_aemif_setup_timing - setup timing values for a given AEMIF interface
+ * @t: timing values to be progammed
+ * @base: The virtual base address of the AEMIF interface
+ * @cs: chip-select to program the timing values for
+ *
+ * This function programs the given timing values (in real clock) into the
+ * AEMIF registers taking the AEMIF clock into account.
+ *
+ * This function does not use any locking while programming the AEMIF
+ * because it is expected that there is only one user of a given
+ * chip-select.
+ *
+ * Returns 0 on success, else negative errno.
+ */
+int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
+					void __iomem *base, unsigned cs)
+{
+	unsigned set, val;
+	int ta, rhold, rstrobe, rsetup, whold, wstrobe, wsetup;
+	unsigned offset = A1CR_OFFSET + cs * 4;
+	struct clk *aemif_clk;
+	unsigned long clkrate;
+
+	if (!t)
+		return 0;	/* Nothing to do */
+
+	aemif_clk = clk_get(NULL, "aemif");
+	if (IS_ERR(aemif_clk))
+		return PTR_ERR(aemif_clk);
+
+	clkrate = clk_get_rate(aemif_clk);
+
+	clkrate /= 1000;	/* turn clock into kHz for ease of use */
+
+	ta	= aemif_calc_rate(t->ta, clkrate, TA_MAX);
+	rhold	= aemif_calc_rate(t->rhold, clkrate, RHOLD_MAX);
+	rstrobe	= aemif_calc_rate(t->rstrobe, clkrate, RSTROBE_MAX);
+	rsetup	= aemif_calc_rate(t->rsetup, clkrate, RSETUP_MAX);
+	whold	= aemif_calc_rate(t->whold, clkrate, WHOLD_MAX);
+	wstrobe	= aemif_calc_rate(t->wstrobe, clkrate, WSTROBE_MAX);
+	wsetup	= aemif_calc_rate(t->wsetup, clkrate, WSETUP_MAX);
+
+	if (ta < 0 || rhold < 0 || rstrobe < 0 || rsetup < 0 ||
+			whold < 0 || wstrobe < 0 || wsetup < 0) {
+		pr_err("%s: cannot get suitable timings\n", __func__);
+		return -EINVAL;
+	}
+
+	set = TA(ta) | RHOLD(rhold) | RSTROBE(rstrobe) | RSETUP(rsetup) |
+		WHOLD(whold) | WSTROBE(wstrobe) | WSETUP(wsetup);
+
+	val = __raw_readl(base + offset);
+	val &= ~TIMING_MASK;
+	val |= set;
+	__raw_writel(val, base + offset);
+
+	return 0;
+}
+EXPORT_SYMBOL(davinci_aemif_setup_timing);
+
+static int __init davinci_aemif_probe(struct platform_device *pdev)
+{
+	struct davinci_aemif_devices *davinci_aemif_devices =
+		pdev->dev.platform_data;
+	struct platform_device *devices;
+	struct mfd_cell *cells;
+	int i, ret, count;
+
+	devices = davinci_aemif_devices->devices;
+
+	cells = kzalloc(sizeof(struct mfd_cell) *
+			davinci_aemif_devices->num_devices, GFP_KERNEL);
+
+	for (i = 0, count = 0; i < davinci_aemif_devices->num_devices; i++) {
+		if (!strcmp(devices[i].name, "davinci_nand")) {
+			cells[count].pdata_size =
+				sizeof(struct davinci_nand_pdata);
+		} else if (!strcmp(devices[i].name, "physmap-flash")) {
+			cells[count].pdata_size =
+				sizeof(struct physmap_flash_data);
+		} else
+			continue;
+
+		cells[count].name = devices[i].name;
+		cells[count].platform_data =
+			devices[i].dev.platform_data;
+		cells[count].id = devices[i].id;
+		cells[count].resources = devices[i].resource;
+		cells[count].num_resources = devices[i].num_resources;
+		count++;
+	}
+
+	ret = mfd_add_devices(&pdev->dev, 0, cells,
+			      count, NULL, 0);
+	if (ret != 0)
+		dev_err(&pdev->dev, "fail to register client devices\n");
+
+	return 0;
+}
+
+static int __devexit davinci_aemif_remove(struct platform_device *pdev)
+{
+	mfd_remove_devices(&pdev->dev);
+	return 0;
+}
+
+static struct platform_driver davinci_aemif_driver = {
+	.driver	= {
+		.name = "davinci_aemif",
+		.owner = THIS_MODULE,
+	},
+	.remove	= __devexit_p(davinci_aemif_remove),
+};
+
+static int __init davinci_aemif_init(void)
+{
+	return platform_driver_probe(&davinci_aemif_driver,
+			davinci_aemif_probe);
+}
+module_init(davinci_aemif_init);
+
+static void __exit davinci_aemif_exit(void)
+{
+	platform_driver_unregister(&davinci_aemif_driver);
+}
+module_exit(davinci_aemif_exit);
+
+MODULE_AUTHOR("Prakash Manjunathappa");
+MODULE_DESCRIPTION("Texas Instruments AEMIF Interface");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/davinci_aemif.h b/include/linux/mfd/davinci_aemif.h
index 05b2934..18650c3 100644
--- a/include/linux/mfd/davinci_aemif.h
+++ b/include/linux/mfd/davinci_aemif.h
@@ -10,6 +10,10 @@
 #ifndef _MACH_DAVINCI_AEMIF_H
 #define _MACH_DAVINCI_AEMIF_H
 
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+
 #define NRCSR_OFFSET		0x00
 #define AWCCR_OFFSET		0x04
 #define A1CR_OFFSET		0x10
@@ -18,6 +22,16 @@
 #define ACR_EW_MASK		BIT(30)
 #define ACR_SS_MASK		BIT(31)
 
+enum davinci_emif_cells {
+	DAVINCI_NAND_DEVICE_CELL,
+	DAVINCI_NOR_FLASH_CELL,
+};
+
+struct davinci_aemif_devices {
+	struct platform_device *devices;
+	unsigned int num_devices;
+};
+
 /* All timings in nanoseconds */
 struct davinci_aemif_timing {
 	u8	wsetup;
-- 
1.7.1

