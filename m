Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab0LCDSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 22:18:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:23885 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab0LCDSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 22:18:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,291,1288594800"; 
   d="scan'208";a="632637004"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: mingo@elte.com, hpa@zytor.com, alan@linux.intel.com,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/2] x86, earlyprintk: move mrst early console to platform/ and fix a typo
Date: Fri,  3 Dec 2010 11:51:37 +0800
Message-Id: <1291348298-21263-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code to arch/x86/platform/mrst/. Also fix a typo to use
the correct config option: ONFIG_EARLY_PRINTK_MRST

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/Makefile                   |    1 -
 arch/x86/kernel/early_printk.c             |    3 +-
 arch/x86/kernel/early_printk_mrst.c        |  319 ----------------------------
 arch/x86/platform/mrst/Makefile            |    1 +
 arch/x86/platform/mrst/early_printk_mrst.c |  319 ++++++++++++++++++++++++++++
 5 files changed, 321 insertions(+), 322 deletions(-)
 delete mode 100644 arch/x86/kernel/early_printk_mrst.c
 create mode 100644 arch/x86/platform/mrst/early_printk_mrst.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9e13763..f60153d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -84,7 +84,6 @@ obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
-obj-$(CONFIG_EARLY_PRINTK_MRST)	+= early_printk_mrst.o
 
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 4572f25..cd28a35 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -240,7 +240,7 @@ static int __init setup_early_printk(char *buf)
 		if (!strncmp(buf, "xen", 3))
 			early_console_register(&xenboot_console, keep);
 #endif
-#ifdef CONFIG_X86_MRST_EARLY_PRINTK
+#ifdef CONFIG_EARLY_PRINTK_MRST
 		if (!strncmp(buf, "mrst", 4)) {
 			mrst_early_console_init();
 			early_console_register(&early_mrst_console, keep);
@@ -250,7 +250,6 @@ static int __init setup_early_printk(char *buf)
 			hsu_early_console_init();
 			early_console_register(&early_hsu_console, keep);
 		}
-
 #endif
 		buf++;
 	}
diff --git a/arch/x86/kernel/early_printk_mrst.c b/arch/x86/kernel/early_printk_mrst.c
deleted file mode 100644
index 65df603..0000000
--- a/arch/x86/kernel/early_printk_mrst.c
+++ /dev/null
@@ -1,319 +0,0 @@
-/*
- * early_printk_mrst.c - early consoles for Intel MID platforms
- *
- * Copyright (c) 2008-2010, Intel Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; version 2
- * of the License.
- */
-
-/*
- * This file implements two early consoles named mrst and hsu.
- * mrst is based on Maxim3110 spi-uart device, it exists in both
- * Moorestown and Medfield platforms, while hsu is based on a High
- * Speed UART device which only exists in the Medfield platform
- */
-
-#include <linux/serial_reg.h>
-#include <linux/serial_mfd.h>
-#include <linux/kmsg_dump.h>
-#include <linux/console.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/io.h>
-
-#include <asm/fixmap.h>
-#include <asm/pgtable.h>
-#include <asm/mrst.h>
-
-#define MRST_SPI_TIMEOUT		0x200000
-#define MRST_REGBASE_SPI0		0xff128000
-#define MRST_REGBASE_SPI1		0xff128400
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
-/* Always contains an accessable address, start with 0 */
-static struct dw_spi_reg *pspi;
-
-static struct kmsg_dumper dw_dumper;
-static int dumper_registered;
-
-static void dw_kmsg_dump(struct kmsg_dumper *dumper,
-			enum kmsg_dump_reason reason,
-			const char *s1, unsigned long l1,
-			const char *s2, unsigned long l2)
-{
-	int i;
-
-	/* When run to this, we'd better re-init the HW */
-	mrst_early_console_init();
-
-	for (i = 0; i < l1; i++)
-		early_mrst_console.write(&early_mrst_console, s1 + i, 1);
-	for (i = 0; i < l2; i++)
-		early_mrst_console.write(&early_mrst_console, s2 + i, 1);
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
-}
-
-void mrst_early_console_init(void)
-{
-	u32 ctrlr0 = 0;
-	u32 spi0_cdiv;
-	u32 freq; /* Freqency info only need be searched once */
-
-	/* Base clk is 100 MHz, the actual clk = 100M / (clk_divider + 1) */
-	pclk_spi0 = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
-							MRST_CLK_SPI0_REG);
-	spi0_cdiv = ((*pclk_spi0) & 0xe00) >> 9;
-	freq = 100000000 / (spi0_cdiv + 1);
-
-	if (mrst_identify_cpu() == MRST_CPU_CHIP_PENWELL)
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
-
-	/* Register the kmsg dumper */
-	if (!dumper_registered) {
-		dw_dumper.dump = dw_kmsg_dump;
-		kmsg_dump_register(&dw_dumper);
-		dumper_registered = 1;
-	}
-}
-
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
-/*
- * Following is the early console based on Medfield HSU (High
- * Speed UART) device.
- */
-#define HSU_PORT2_PADDR		0xffa28180
-
-static void __iomem *phsu;
-
-void hsu_early_console_init(void)
-{
-	u8 lcr;
-
-	phsu = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
-							HSU_PORT2_PADDR);
-
-	/* Disable FIFO */
-	writeb(0x0, phsu + UART_FCR);
-
-	/* Set to default 115200 bps, 8n1 */
-	lcr = readb(phsu + UART_LCR);
-	writeb((0x80 | lcr), phsu + UART_LCR);
-	writeb(0x18, phsu + UART_DLL);
-	writeb(lcr,  phsu + UART_LCR);
-	writel(0x3600, phsu + UART_MUL*4);
-
-	writeb(0x8, phsu + UART_MCR);
-	writeb(0x7, phsu + UART_FCR);
-	writeb(0x3, phsu + UART_LCR);
-
-	/* Clear IRQ status */
-	readb(phsu + UART_LSR);
-	readb(phsu + UART_RX);
-	readb(phsu + UART_IIR);
-	readb(phsu + UART_MSR);
-
-	/* Enable FIFO */
-	writeb(0x7, phsu + UART_FCR);
-}
-
-#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
-
-static void early_hsu_putc(char ch)
-{
-	unsigned int timeout = 10000; /* 10ms */
-	u8 status;
-
-	while (--timeout) {
-		status = readb(phsu + UART_LSR);
-		if (status & BOTH_EMPTY)
-			break;
-		udelay(1);
-	}
-
-	/* Only write the char when there was no timeout */
-	if (timeout)
-		writeb(ch, phsu + UART_TX);
-}
-
-static void early_hsu_write(struct console *con, const char *str, unsigned n)
-{
-	int i;
-
-	for (i = 0; i < n && *str; i++) {
-		if (*str == '\n')
-			early_hsu_putc('\r');
-		early_hsu_putc(*str);
-		str++;
-	}
-}
-
-struct console early_hsu_console = {
-	.name =		"earlyhsu",
-	.write =	early_hsu_write,
-	.flags =	CON_PRINTBUFFER,
-	.index =	-1,
-};
diff --git a/arch/x86/platform/mrst/Makefile b/arch/x86/platform/mrst/Makefile
index efbbc55..5621178 100644
--- a/arch/x86/platform/mrst/Makefile
+++ b/arch/x86/platform/mrst/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_X86_MRST)		+= mrst.o
+obj-$(CONFIG_EARLY_PRINTK_MRST)	+= early_printk_mrst.o
diff --git a/arch/x86/platform/mrst/early_printk_mrst.c b/arch/x86/platform/mrst/early_printk_mrst.c
new file mode 100644
index 0000000..65df603
--- /dev/null
+++ b/arch/x86/platform/mrst/early_printk_mrst.c
@@ -0,0 +1,319 @@
+/*
+ * early_printk_mrst.c - early consoles for Intel MID platforms
+ *
+ * Copyright (c) 2008-2010, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+/*
+ * This file implements two early consoles named mrst and hsu.
+ * mrst is based on Maxim3110 spi-uart device, it exists in both
+ * Moorestown and Medfield platforms, while hsu is based on a High
+ * Speed UART device which only exists in the Medfield platform
+ */
+
+#include <linux/serial_reg.h>
+#include <linux/serial_mfd.h>
+#include <linux/kmsg_dump.h>
+#include <linux/console.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
+
+#include <asm/fixmap.h>
+#include <asm/pgtable.h>
+#include <asm/mrst.h>
+
+#define MRST_SPI_TIMEOUT		0x200000
+#define MRST_REGBASE_SPI0		0xff128000
+#define MRST_REGBASE_SPI1		0xff128400
+#define MRST_CLK_SPI0_REG		0xff11d86c
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
+/* Default use SPI0 register for mrst, we will detect Penwell and use SPI1 */
+static unsigned long mrst_spi_paddr = MRST_REGBASE_SPI0;
+
+static u32 *pclk_spi0;
+/* Always contains an accessable address, start with 0 */
+static struct dw_spi_reg *pspi;
+
+static struct kmsg_dumper dw_dumper;
+static int dumper_registered;
+
+static void dw_kmsg_dump(struct kmsg_dumper *dumper,
+			enum kmsg_dump_reason reason,
+			const char *s1, unsigned long l1,
+			const char *s2, unsigned long l2)
+{
+	int i;
+
+	/* When run to this, we'd better re-init the HW */
+	mrst_early_console_init();
+
+	for (i = 0; i < l1; i++)
+		early_mrst_console.write(&early_mrst_console, s1 + i, 1);
+	for (i = 0; i < l2; i++)
+		early_mrst_console.write(&early_mrst_console, s2 + i, 1);
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
+/* Translate char to a eligible word and send to max3110 */
+static void max3110_write_data(char c)
+{
+	u16 data;
+
+	data = 0x8000 | c;
+	dw_writel(pspi, dr, data);
+}
+
+void mrst_early_console_init(void)
+{
+	u32 ctrlr0 = 0;
+	u32 spi0_cdiv;
+	u32 freq; /* Freqency info only need be searched once */
+
+	/* Base clk is 100 MHz, the actual clk = 100M / (clk_divider + 1) */
+	pclk_spi0 = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
+							MRST_CLK_SPI0_REG);
+	spi0_cdiv = ((*pclk_spi0) & 0xe00) >> 9;
+	freq = 100000000 / (spi0_cdiv + 1);
+
+	if (mrst_identify_cpu() == MRST_CPU_CHIP_PENWELL)
+		mrst_spi_paddr = MRST_REGBASE_SPI1;
+
+	pspi = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
+						mrst_spi_paddr);
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
+	/* Register the kmsg dumper */
+	if (!dumper_registered) {
+		dw_dumper.dump = dw_kmsg_dump;
+		kmsg_dump_register(&dw_dumper);
+		dumper_registered = 1;
+	}
+}
+
+/* Slave select should be called in the read/write function */
+static void early_mrst_spi_putc(char c)
+{
+	unsigned int timeout;
+	u32 sr;
+
+	timeout = MRST_SPI_TIMEOUT;
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
+		pr_warning("MRST earlycon: timed out\n");
+	else
+		max3110_write_data(c);
+}
+
+/* Early SPI only uses polling mode */
+static void early_mrst_spi_write(struct console *con, const char *str, unsigned n)
+{
+	int i;
+
+	for (i = 0; i < n && *str; i++) {
+		if (*str == '\n')
+			early_mrst_spi_putc('\r');
+		early_mrst_spi_putc(*str);
+		str++;
+	}
+}
+
+struct console early_mrst_console = {
+	.name =		"earlymrst",
+	.write =	early_mrst_spi_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
+
+/*
+ * Following is the early console based on Medfield HSU (High
+ * Speed UART) device.
+ */
+#define HSU_PORT2_PADDR		0xffa28180
+
+static void __iomem *phsu;
+
+void hsu_early_console_init(void)
+{
+	u8 lcr;
+
+	phsu = (void *)set_fixmap_offset_nocache(FIX_EARLYCON_MEM_BASE,
+							HSU_PORT2_PADDR);
+
+	/* Disable FIFO */
+	writeb(0x0, phsu + UART_FCR);
+
+	/* Set to default 115200 bps, 8n1 */
+	lcr = readb(phsu + UART_LCR);
+	writeb((0x80 | lcr), phsu + UART_LCR);
+	writeb(0x18, phsu + UART_DLL);
+	writeb(lcr,  phsu + UART_LCR);
+	writel(0x3600, phsu + UART_MUL*4);
+
+	writeb(0x8, phsu + UART_MCR);
+	writeb(0x7, phsu + UART_FCR);
+	writeb(0x3, phsu + UART_LCR);
+
+	/* Clear IRQ status */
+	readb(phsu + UART_LSR);
+	readb(phsu + UART_RX);
+	readb(phsu + UART_IIR);
+	readb(phsu + UART_MSR);
+
+	/* Enable FIFO */
+	writeb(0x7, phsu + UART_FCR);
+}
+
+#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
+
+static void early_hsu_putc(char ch)
+{
+	unsigned int timeout = 10000; /* 10ms */
+	u8 status;
+
+	while (--timeout) {
+		status = readb(phsu + UART_LSR);
+		if (status & BOTH_EMPTY)
+			break;
+		udelay(1);
+	}
+
+	/* Only write the char when there was no timeout */
+	if (timeout)
+		writeb(ch, phsu + UART_TX);
+}
+
+static void early_hsu_write(struct console *con, const char *str, unsigned n)
+{
+	int i;
+
+	for (i = 0; i < n && *str; i++) {
+		if (*str == '\n')
+			early_hsu_putc('\r');
+		early_hsu_putc(*str);
+		str++;
+	}
+}
+
+struct console early_hsu_console = {
+	.name =		"earlyhsu",
+	.write =	early_hsu_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
-- 
1.7.0.4

