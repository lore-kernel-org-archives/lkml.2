Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2I1ClE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:41:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:35212 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2I1ClA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:41:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="150101481"
From: Lv Zheng <lv.zheng@intel.com>
To: Len Brown <len.brown@intel.com>
Cc: <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH v4 2/2] ACPI: Add Intel MID SPI early console support.
Date: Fri, 28 Sep 2012 10:40:35 +0800
Message-Id: <387a9f8c290f142c38c10370688289844b12462a.1348652044.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1348652044.git.lv.zheng@intel.com>
References: <cover.1347453194.git.zetalog@gmail.com> <cover.1348652044.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DesignWare SPI UART is used as one of the debug ports on Low Power Intel
Architecture (LPIA) platforms.  This patch is introduced to support this
debugging console reported by ACPI DBGP/DBG2.  The original MID SPI
early console stuff is also refined to co-exist with the new ACPI usage
model.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 Documentation/kernel-parameters.txt        |    1 +
 arch/x86/Kconfig.debug                     |   23 +++
 arch/x86/include/asm/mrst.h                |    2 +-
 arch/x86/kernel/early_printk.c             |   12 +-
 arch/x86/platform/mrst/early_printk_mrst.c |  186 +----------------------
 drivers/platform/x86/Makefile              |    2 +
 drivers/platform/x86/early/Makefile        |    5 +
 drivers/platform/x86/early/intel_mid_spi.c |  220 ++++++++++++++++++++++++++++
 include/acpi/actbl2.h                      |    1 +
 include/linux/intel_mid_early.h            |   12 ++
 10 files changed, 283 insertions(+), 181 deletions(-)
 create mode 100644 drivers/platform/x86/early/Makefile
 create mode 100644 drivers/platform/x86/early/intel_mid_spi.c
 create mode 100644 include/linux/intel_mid_early.h

Index: linux-acpi/arch/x86/Kconfig.debug
===================================================================
--- linux-acpi.orig/arch/x86/Kconfig.debug	2012-09-27 22:35:13.000000000 +0800
+++ linux-acpi/arch/x86/Kconfig.debug	2012-09-27 22:35:14.000000000 +0800
@@ -43,9 +43,32 @@
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
+config EARLY_PRINTK_INTEL_MID_SPI
+	bool "Early printk for Intel MID SPI UART port"
+	depends on EARLY_PRINTK
+	---help---
+	  Write kernel log output directly into the MID SPI UART debug port.
+
+	  Intel MID platforms are using DesignWare SPI UART as its debug
+	  console.  This option does not introduce actual early console into
+	  the kernel binary, but is required by a real early console
+	  implementation (EARLY_PRINTK_INTEL_MID or EARLY_PRINTK_ACPI).
+	  You should normally N here unless you need to do kernel booting
+	  development.
+
 config EARLY_PRINTK_INTEL_MID
 	bool "Early printk for Intel MID platform support"
 	depends on EARLY_PRINTK && X86_INTEL_MID
+	select EARLY_PRINTK_INTEL_MID_SPI
+	---help---
+	  Write kernel log output directly into the MID SPI UART debug port.
+
+	  Intel MID platforms are always equipped with SPI debug ports and
+	  USB OTG debug ports. To enable these debugging facilities, you
+	  need to pass "earlyprintk=mrst" parameter to the kernel through
+	  boot loaders.  Please see "Documentation/kernel-parameter.txt" for
+	  details.  You should normally N here unless you need to do kernel
+	  booting development.
 
 config EARLY_PRINTK_DBGP
 	bool "Early printk via EHCI debug port"
Index: linux-acpi/arch/x86/include/asm/mrst.h
===================================================================
--- linux-acpi.orig/arch/x86/include/asm/mrst.h	2012-09-27 22:35:05.000000000 +0800
+++ linux-acpi/arch/x86/include/asm/mrst.h	2012-09-27 22:35:41.000000000 +0800
@@ -12,6 +12,7 @@
 #define _ASM_X86_MRST_H
 
 #include <linux/sfi.h>
+#include <linux/intel_mid_early.h>
 
 extern int pci_mrst_init(void);
 extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
@@ -63,7 +64,6 @@
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
 
-extern struct console early_mrst_console;
 extern void mrst_early_console_init(void);
 
 extern struct console early_hsu_console;
Index: linux-acpi/arch/x86/kernel/early_printk.c
===================================================================
--- linux-acpi.orig/arch/x86/kernel/early_printk.c	2012-09-27 22:35:13.000000000 +0800
+++ linux-acpi/arch/x86/kernel/early_printk.c	2012-09-27 22:35:42.000000000 +0800
@@ -205,6 +205,16 @@
 
 int __init acpi_early_console_setup(struct acpi_debug_port *info)
 {
+#ifdef CONFIG_EARLY_PRINTK_INTEL_MID_SPI
+	if (info->port_type == ACPI_DBG2_SERIAL_PORT
+	    && info->port_subtype == ACPI_DBG2_INTEL_MID_SPI
+	    && info->register_count > 0) {
+		mid_spi_early_console_init((u32)(info->registers[0].address));
+		early_console_register(&mid_spi_early_console,
+				       acpi_early_console_keep());
+	}
+#endif
+
 	return 0;
 }
 #endif
@@ -256,7 +266,7 @@
 #ifdef CONFIG_EARLY_PRINTK_INTEL_MID
 		if (!strncmp(buf, "mrst", 4)) {
 			mrst_early_console_init();
-			early_console_register(&early_mrst_console, keep);
+			early_console_register(&mid_spi_early_console, keep);
 		}
 
 		if (!strncmp(buf, "hsu", 3)) {
Index: linux-acpi/arch/x86/platform/mrst/early_printk_mrst.c
===================================================================
--- linux-acpi.orig/arch/x86/platform/mrst/early_printk_mrst.c	2012-09-27 22:35:05.000000000 +0800
+++ linux-acpi/arch/x86/platform/mrst/early_printk_mrst.c	2012-09-27 22:35:14.000000000 +0800
@@ -29,82 +29,8 @@
 #include <asm/pgtable.h>
 #include <asm/mrst.h>
 
-#define MRST_SPI_TIMEOUT		0x200000
 #define MRST_REGBASE_SPI0		0xff128000
 #define MRST_REGBASE_SPI1		0xff128400
-#define MRST_CLK_SPI0_REG		0xff11d86c
-
-/* Bit fields in CTRLR0 */
-#define SPI_DFS_OFFSET			0
-
-#define SPI_FRF_OFFSET			4
-#define SPI_FRF_SPI			0x0
-#define SPI_FRF_SSP			0x1
-#define SPI_FRF_MICROWIRE		0x2
-#define SPI_FRF_RESV			0x3
-
-#define SPI_MODE_OFFSET			6
-#define SPI_SCPH_OFFSET			6
-#define SPI_SCOL_OFFSET			7
-#define SPI_TMOD_OFFSET			8
-#define	SPI_TMOD_TR			0x0		/* xmit & recv */
-#define SPI_TMOD_TO			0x1		/* xmit only */
-#define SPI_TMOD_RO			0x2		/* recv only */
-#define SPI_TMOD_EPROMREAD		0x3		/* eeprom read mode */
-
-#define SPI_SLVOE_OFFSET		10
-#define SPI_SRL_OFFSET			11
-#define SPI_CFS_OFFSET			12
-
-/* Bit fields in SR, 7 bits */
-#define SR_MASK				0x7f		/* cover 7 bits */
-#define SR_BUSY				(1 << 0)
-#define SR_TF_NOT_FULL			(1 << 1)
-#define SR_TF_EMPT			(1 << 2)
-#define SR_RF_NOT_EMPT			(1 << 3)
-#define SR_RF_FULL			(1 << 4)
-#define SR_TX_ERR			(1 << 5)
-#define SR_DCOL				(1 << 6)
-
-struct dw_spi_reg {
-	u32	ctrl0;
-	u32	ctrl1;
-	u32	ssienr;
-	u32	mwcr;
-	u32	ser;
-	u32	baudr;
-	u32	txfltr;
-	u32	rxfltr;
-	u32	txflr;
-	u32	rxflr;
-	u32	sr;
-	u32	imr;
-	u32	isr;
-	u32	risr;
-	u32	txoicr;
-	u32	rxoicr;
-	u32	rxuicr;
-	u32	msticr;
-	u32	icr;
-	u32	dmacr;
-	u32	dmatdlr;
-	u32	dmardlr;
-	u32	idr;
-	u32	version;
-
-	/* Currently operates as 32 bits, though only the low 16 bits matter */
-	u32	dr;
-} __packed;
-
-#define dw_readl(dw, name)		__raw_readl(&(dw)->name)
-#define dw_writel(dw, name, val)	__raw_writel((val), &(dw)->name)
-
-/* Default use SPI0 register for mrst, we will detect Penwell and use SPI1 */
-static unsigned long mrst_spi_paddr = MRST_REGBASE_SPI0;
-
-static u32 *pclk_spi0;
-/* Always contains an accessible address, start with 0 */
-static struct dw_spi_reg *pspi;
 
 static struct kmsg_dumper dw_dumper;
 static int dumper_registered;
@@ -116,77 +42,21 @@
 	size_t len;
 
 	/* When run to this, we'd better re-init the HW */
-	mrst_early_console_init();
+	mid_spi_early_console_reset();
 
 	while (kmsg_dump_get_line(dumper, true, line, sizeof(line), &len))
-		early_mrst_console.write(&early_mrst_console, line, len);
-}
-
-/* Set the ratio rate to 115200, 8n1, IRQ disabled */
-static void max3110_write_config(void)
-{
-	u16 config;
-
-	config = 0xc001;
-	dw_writel(pspi, dr, config);
-}
-
-/* Translate char to a eligible word and send to max3110 */
-static void max3110_write_data(char c)
-{
-	u16 data;
-
-	data = 0x8000 | c;
-	dw_writel(pspi, dr, data);
+		mid_spi_early_console.write(&mid_spi_early_console, line, len);
 }
 
 void mrst_early_console_init(void)
 {
-	u32 ctrlr0 = 0;
-	u32 spi0_cdiv;
-	u32 freq; /* Freqency info only need be searched once */
-
-	/* Base clk is 100 MHz, the actual clk = 100M / (clk_divider + 1) */
-	pclk_spi0 = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
-							MRST_CLK_SPI0_REG);
-	spi0_cdiv = ((*pclk_spi0) & 0xe00) >> 9;
-	freq = 100000000 / (spi0_cdiv + 1);
+	/* Default use SPI0 register for mrst */
+	unsigned long spi_paddr = MRST_REGBASE_SPI0;
 
+	/* Detect Penwell and use SPI1 */
 	if (mrst_identify_cpu() == MRST_CPU_CHIP_PENWELL)
-		mrst_spi_paddr = MRST_REGBASE_SPI1;
-
-	pspi = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
-						mrst_spi_paddr);
-
-	/* Disable SPI controller */
-	dw_writel(pspi, ssienr, 0);
-
-	/* Set control param, 8 bits, transmit only mode */
-	ctrlr0 = dw_readl(pspi, ctrl0);
-
-	ctrlr0 &= 0xfcc0;
-	ctrlr0 |= 0xf | (SPI_FRF_SPI << SPI_FRF_OFFSET)
-		      | (SPI_TMOD_TO << SPI_TMOD_OFFSET);
-	dw_writel(pspi, ctrl0, ctrlr0);
-
-	/*
-	 * Change the spi0 clk to comply with 115200 bps, use 100000 to
-	 * calculate the clk dividor to make the clock a little slower
-	 * than real baud rate.
-	 */
-	dw_writel(pspi, baudr, freq/100000);
-
-	/* Disable all INT for early phase */
-	dw_writel(pspi, imr, 0x0);
-
-	/* Set the cs to spi-uart */
-	dw_writel(pspi, ser, 0x2);
-
-	/* Enable the HW, the last step for HW init */
-	dw_writel(pspi, ssienr, 0x1);
-
-	/* Set the default configuration */
-	max3110_write_config();
+		spi_paddr = MRST_REGBASE_SPI1;
+	mid_spi_early_console_init(spi_paddr);
 
 	/* Register the kmsg dumper */
 	if (!dumper_registered) {
@@ -196,48 +66,6 @@
 	}
 }
 
-/* Slave select should be called in the read/write function */
-static void early_mrst_spi_putc(char c)
-{
-	unsigned int timeout;
-	u32 sr;
-
-	timeout = MRST_SPI_TIMEOUT;
-	/* Early putc needs to make sure the TX FIFO is not full */
-	while (--timeout) {
-		sr = dw_readl(pspi, sr);
-		if (!(sr & SR_TF_NOT_FULL))
-			cpu_relax();
-		else
-			break;
-	}
-
-	if (!timeout)
-		pr_warning("MRST earlycon: timed out\n");
-	else
-		max3110_write_data(c);
-}
-
-/* Early SPI only uses polling mode */
-static void early_mrst_spi_write(struct console *con, const char *str, unsigned n)
-{
-	int i;
-
-	for (i = 0; i < n && *str; i++) {
-		if (*str == '\n')
-			early_mrst_spi_putc('\r');
-		early_mrst_spi_putc(*str);
-		str++;
-	}
-}
-
-struct console early_mrst_console = {
-	.name =		"earlymrst",
-	.write =	early_mrst_spi_write,
-	.flags =	CON_PRINTBUFFER,
-	.index =	-1,
-};
-
 /*
  * Following is the early console based on Medfield HSU (High
  * Speed UART) device.
Index: linux-acpi/drivers/platform/x86/Makefile
===================================================================
--- linux-acpi.orig/drivers/platform/x86/Makefile	2012-09-27 22:35:05.000000000 +0800
+++ linux-acpi/drivers/platform/x86/Makefile	2012-09-27 22:35:14.000000000 +0800
@@ -50,3 +50,5 @@
 obj-$(CONFIG_INTEL_OAKTRAIL)	+= intel_oaktrail.o
 obj-$(CONFIG_SAMSUNG_Q10)	+= samsung-q10.o
 obj-$(CONFIG_APPLE_GMUX)	+= apple-gmux.o
+
+obj-$(CONFIG_EARLY_PRINTK)	+= early/
Index: linux-acpi/drivers/platform/x86/early/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-acpi/drivers/platform/x86/early/Makefile	2012-09-27 22:35:14.000000000 +0800
@@ -0,0 +1,5 @@
+#
+# Makefile for linux/drivers/platform/x86/early
+# x86 Platform-Specific Early Printk Support
+#
+obj-$(CONFIG_EARLY_PRINTK_INTEL_MID_SPI)	+= intel_mid_spi.o
Index: linux-acpi/drivers/platform/x86/early/intel_mid_spi.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-acpi/drivers/platform/x86/early/intel_mid_spi.c	2012-09-27 22:35:14.000000000 +0800
@@ -0,0 +1,220 @@
+/*
+ * intel_mid_spi.c - SPI UART early consoles for Intel MID platforms
+ *
+ * Copyright (c) 2008-2012, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+/*
+ * This file implements early console named intel_pmic.
+ * intel_pmic is based on Maxim3110 spi-uart device, it exists in
+ * Low Power Intel Architecture (LPIA) platforms.
+ */
+
+#include <linux/serial_reg.h>
+#include <linux/serial_mfd.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/io.h>
+#include <linux/intel_mid_early.h>
+#include <asm/fixmap.h>
+
+#define DW_SPI_TIMEOUT			0x200000
+#define DW_SPI0_CLK_REG			0xff11d86c
+
+/* Bit fields in CTRLR0 */
+#define SPI_DFS_OFFSET			0
+
+#define SPI_FRF_OFFSET			4
+#define SPI_FRF_SPI			0x0
+#define SPI_FRF_SSP			0x1
+#define SPI_FRF_MICROWIRE		0x2
+#define SPI_FRF_RESV			0x3
+
+#define SPI_MODE_OFFSET			6
+#define SPI_SCPH_OFFSET			6
+#define SPI_SCOL_OFFSET			7
+#define SPI_TMOD_OFFSET			8
+#define	SPI_TMOD_TR			0x0		/* xmit & recv */
+#define SPI_TMOD_TO			0x1		/* xmit only */
+#define SPI_TMOD_RO			0x2		/* recv only */
+#define SPI_TMOD_EPROMREAD		0x3		/* eeprom read mode */
+
+#define SPI_SLVOE_OFFSET		10
+#define SPI_SRL_OFFSET			11
+#define SPI_CFS_OFFSET			12
+
+/* Bit fields in SR, 7 bits */
+#define SR_MASK				0x7f		/* cover 7 bits */
+#define SR_BUSY				(1 << 0)
+#define SR_TF_NOT_FULL			(1 << 1)
+#define SR_TF_EMPT			(1 << 2)
+#define SR_RF_NOT_EMPT			(1 << 3)
+#define SR_RF_FULL			(1 << 4)
+#define SR_TX_ERR			(1 << 5)
+#define SR_DCOL				(1 << 6)
+
+struct dw_spi_reg {
+	u32	ctrl0;
+	u32	ctrl1;
+	u32	ssienr;
+	u32	mwcr;
+	u32	ser;
+	u32	baudr;
+	u32	txfltr;
+	u32	rxfltr;
+	u32	txflr;
+	u32	rxflr;
+	u32	sr;
+	u32	imr;
+	u32	isr;
+	u32	risr;
+	u32	txoicr;
+	u32	rxoicr;
+	u32	rxuicr;
+	u32	msticr;
+	u32	icr;
+	u32	dmacr;
+	u32	dmatdlr;
+	u32	dmardlr;
+	u32	idr;
+	u32	version;
+
+	/* Currently operates as 32 bits, though only the low 16 bits matter */
+	u32	dr;
+} __packed;
+
+#define dw_readl(dw, name)		__raw_readl(&(dw)->name)
+#define dw_writel(dw, name, val)	__raw_writel((val), &(dw)->name)
+
+static u32 *pclk_spi0;
+/* Always contains an accessible address, start with 0 */
+static struct dw_spi_reg *pspi;
+static int dw_spi_initialized;
+static u32 dw_spi_regbase;
+
+/* Translate char to a eligible word and send to max3110 */
+static void max3110_write_data(char c)
+{
+	u16 data;
+
+	data = 0x8000 | c;
+	dw_writel(pspi, dr, data);
+}
+
+/* Set the ratio rate to 115200, 8n1, IRQ disabled */
+static void max3110_write_config(void)
+{
+	u16 config;
+
+	config = 0xc001;
+	dw_writel(pspi, dr, config);
+}
+
+int mid_spi_early_console_reset(void)
+{
+	u32 ctrlr0 = 0;
+	u32 spi0_cdiv;
+	u32 freq; /* Freqency info only need be searched once */
+
+	/* Base clk is 100 MHz, the actual clk = 100M / (clk_divider + 1) */
+	pclk_spi0 = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
+						      DW_SPI0_CLK_REG);
+	spi0_cdiv = ((*pclk_spi0) & 0xe00) >> 9;
+	freq = 100000000 / (spi0_cdiv + 1);
+
+	pspi = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
+						 dw_spi_regbase);
+
+	/* Disable SPI controller */
+	dw_writel(pspi, ssienr, 0);
+
+	/* Set control param, 8 bits, transmit only mode */
+	ctrlr0 = dw_readl(pspi, ctrl0);
+
+	ctrlr0 &= 0xfcc0;
+	ctrlr0 |= 0xf | (SPI_FRF_SPI << SPI_FRF_OFFSET)
+		      | (SPI_TMOD_TO << SPI_TMOD_OFFSET);
+	dw_writel(pspi, ctrl0, ctrlr0);
+
+	/*
+	 * Change the spi0 clk to comply with 115200 bps, use 100000 to
+	 * calculate the clk dividor to make the clock a little slower
+	 * than real baud rate.
+	 */
+	dw_writel(pspi, baudr, freq/100000);
+
+	/* Disable all INT for early phase */
+	dw_writel(pspi, imr, 0x0);
+
+	/* Set the cs to spi-uart */
+	dw_writel(pspi, ser, 0x2);
+
+	/* Enable the HW, the last step for HW init */
+	dw_writel(pspi, ssienr, 0x1);
+
+	/* Set the default configuration */
+	max3110_write_config();
+
+	return 0;
+}
+EXPORT_SYMBOL(mid_spi_early_console_reset);
+
+/* Slave select should be called in the read/write function */
+static void dw_early_spi_putc(char c)
+{
+	unsigned int timeout;
+	u32 sr;
+
+	timeout = DW_SPI_TIMEOUT;
+	/* Early putc needs to make sure the TX FIFO is not full */
+	while (--timeout) {
+		sr = dw_readl(pspi, sr);
+		if (!(sr & SR_TF_NOT_FULL))
+			cpu_relax();
+		else
+			break;
+	}
+
+	if (!timeout)
+		pr_warn("mid-spi-early: timed out\n");
+	else
+		max3110_write_data(c);
+}
+
+/* Early SPI only uses polling mode */
+static void dw_early_spi_write(struct console *con,
+			       const char *str, unsigned n)
+{
+	int i;
+
+	for (i = 0; i < n && *str; i++) {
+		if (*str == '\n')
+			dw_early_spi_putc('\r');
+		dw_early_spi_putc(*str);
+		str++;
+	}
+}
+
+struct console mid_spi_early_console = {
+	.name =		"earlymidspi",
+	.write =	dw_early_spi_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
+
+void __init mid_spi_early_console_init(u32 spi_paddr)
+{
+	if (dw_spi_initialized)
+		return;
+	dw_spi_regbase = spi_paddr;
+	mid_spi_early_console_reset();
+	dw_spi_initialized = 1;
+}
+
Index: linux-acpi/include/acpi/actbl2.h
===================================================================
--- linux-acpi.orig/include/acpi/actbl2.h	2012-09-27 22:35:05.000000000 +0800
+++ linux-acpi/include/acpi/actbl2.h	2012-09-27 22:35:42.000000000 +0800
@@ -341,6 +341,7 @@
 
 #define ACPI_DBG2_16550_COMPATIBLE  0x0000
 #define ACPI_DBG2_16550_SUBSET      0x0001
+#define ACPI_DBG2_INTEL_MID_SPI     0x0002
 
 #define ACPI_DBG2_1394_STANDARD     0x0000
 
Index: linux-acpi/include/linux/intel_mid_early.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-acpi/include/linux/intel_mid_early.h	2012-09-27 22:35:14.000000000 +0800
@@ -0,0 +1,12 @@
+#ifndef LINUX_INTEL_MID_EARLY_H
+#define LINUX_INTEL_MID_EARLY_H
+
+#include <linux/console.h>
+
+extern struct console mid_spi_early_console;
+
+extern void mid_spi_early_console_init(u32 spi_paddr);
+extern int mid_spi_early_console_reset(void);
+
+#endif /* LINUX_INTEL_MID_EARLY_H */
+
Index: linux-acpi/Documentation/kernel-parameters.txt
===================================================================
--- linux-acpi.orig/Documentation/kernel-parameters.txt	2012-09-27 22:35:13.000000000 +0800
+++ linux-acpi/Documentation/kernel-parameters.txt	2012-09-27 22:35:14.000000000 +0800
@@ -762,6 +762,7 @@
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
+			earlyprintk=mrst
 			earlyprintk=dbgp[debugController#]
 			earlyprintk=acpi[debugController#]
 
