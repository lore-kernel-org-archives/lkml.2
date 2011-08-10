Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1HJMqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:46:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33745 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1HJMqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:46:20 -0400
From: Tommy Lin <tommy.lin.1101@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <avorontsov@mvista.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tommy Lin <tommy.lin.1101@gmail.com>
Subject: [PATCH 1/2] gpio: Add CNS3xxx mmio gpio support
Date: Thu, 11 Aug 2011 04:12:47 +0800
Message-Id: <1313007167-16183-1-git-send-email-tommy.lin.1101@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CNS3XXX generic memory mapped GPIO controller support. Also
implement cascaded GPIO interrupts for all 64 GPIOs.

Signed-off-by: Tommy Lin <tommy.lin.1101@gmail.com>
---
 arch/arm/Kconfig                             |    3 +
 arch/arm/configs/cns3420vb_defconfig         |    1 +
 arch/arm/mach-cns3xxx/cns3420vb.c            |  120 ++++++
 arch/arm/mach-cns3xxx/core.c                 |   10 -
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h |    8 +-
 arch/arm/mach-cns3xxx/include/mach/gpio.h    |   64 ++++
 drivers/gpio/Kconfig                         |    6 +
 drivers/gpio/Makefile                        |    1 +
 drivers/gpio/gpio-cns3xxx.c                  |  516 ++++++++++++++++++++++++++
 9 files changed, 717 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm/mach-cns3xxx/include/mach/gpio.h
 create mode 100644 drivers/gpio/gpio-cns3xxx.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c71a8f..32705e5 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -333,6 +333,9 @@ config ARCH_CNS3XXX
 	select ARM_GIC
 	select MIGHT_HAVE_PCI
 	select PCI_DOMAINS if PCI
+	select ARCH_REQUIRE_GPIOLIB
+	select GPIO_GENERIC_PLATFORM
+	select GENERIC_IRQ_CHIP
 	help
 	  Support for Cavium Networks CNS3XXX platform.
 
diff --git a/arch/arm/configs/cns3420vb_defconfig b/arch/arm/configs/cns3420vb_defconfig
index 313627a..c83d14c 100644
--- a/arch/arm/configs/cns3420vb_defconfig
+++ b/arch/arm/configs/cns3420vb_defconfig
@@ -52,6 +52,7 @@ CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_LEGACY_PTY_COUNT=16
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
+CONFIG_GPIO_SYSFS=y
 # CONFIG_VGA_CONSOLE is not set
 # CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
diff --git a/arch/arm/mach-cns3xxx/cns3420vb.c b/arch/arm/mach-cns3xxx/cns3420vb.c
index 3e7d149..b414564 100644
--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -24,6 +24,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/partitions.h>
+#include <linux/basic_mmio_gpio.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -158,10 +159,129 @@ static struct platform_device cns3xxx_usb_ohci_device = {
 	},
 };
 
+/* GPIO */
+static struct resource cns3xxx_gpio_resources[] = {
+	[0] = {
+		.start = IRQ_CNS3XXX_GPIOA,
+		.flags = IORESOURCE_IRQ,
+		.name  = "GPIOA"
+	},
+	[1] = {
+		.start = CNS3XXX_GPIOA_BASE + GPIO_INTR_ENABLE_OFFSET,
+		.end   = CNS3XXX_GPIOA_BASE + GPIO_BOUNCE_PRESCALE_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "GPIOA",
+	},
+	[2] = {
+		.start = IRQ_CNS3XXX_GPIOB,
+		.flags = IORESOURCE_IRQ,
+		.name  = "GPIOB"
+	},
+	[3] = {
+		.start = CNS3XXX_GPIOB_BASE + GPIO_INTR_ENABLE_OFFSET,
+		.end   = CNS3XXX_GPIOB_BASE + GPIO_BOUNCE_PRESCALE_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "GPIOB",
+	},
+	[4] = {
+		.start = CNS3XXX_MISC_BASE,
+		.end   = CNS3XXX_MISC_BASE + 0x800,
+		.flags = IORESOURCE_MEM,
+		.name  = "MISC"
+	},
+};
+
+static struct platform_device cns3xxx_gpio_device = {
+	.name		= "cns3xxx-gpio",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(cns3xxx_gpio_resources),
+	.resource	= cns3xxx_gpio_resources,
+};
+
+/* Basic memory-mapped GPIO */
+static struct resource cns3xxx_mmgpio_resources_a[] = {
+	[0] = {
+		.start = CNS3XXX_GPIOA_BASE + GPIO_INPUT_OFFSET,
+		.end   = CNS3XXX_GPIOA_BASE + GPIO_INPUT_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "dat",
+	},
+	[1] = {
+		.start = CNS3XXX_GPIOA_BASE + GPIO_BIT_SET_OFFSET,
+		.end   = CNS3XXX_GPIOA_BASE + GPIO_BIT_SET_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "set",
+	},
+	[2] = {
+		.start = CNS3XXX_GPIOA_BASE + GPIO_BIT_CLEAR_OFFSET,
+		.end   = CNS3XXX_GPIOA_BASE + GPIO_BIT_CLEAR_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "clr",
+	},
+	[3] = {
+		.start = CNS3XXX_GPIOA_BASE + GPIO_DIR_OFFSET,
+		.end   = CNS3XXX_GPIOA_BASE + GPIO_DIR_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "dirout",
+	},
+};
+
+static struct platform_device cns3xxx_mmgpio_device_a = {
+	.name		= "basic-mmio-gpio",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(cns3xxx_mmgpio_resources_a),
+	.resource	= cns3xxx_mmgpio_resources_a,
+	.dev.platform_data = &(struct bgpio_pdata) {
+		.base	= 0,
+		.ngpio	= MAX_GPIOA_NO,
+	},
+};
+
+static struct resource cns3xxx_mmgpio_resources_b[] = {
+	[0] = {
+		.start = CNS3XXX_GPIOB_BASE + GPIO_INPUT_OFFSET,
+		.end   = CNS3XXX_GPIOB_BASE + GPIO_INPUT_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "dat",
+	},
+	[1] = {
+		.start = CNS3XXX_GPIOB_BASE + GPIO_BIT_SET_OFFSET,
+		.end   = CNS3XXX_GPIOB_BASE + GPIO_BIT_SET_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "set",
+	},
+	[2] = {
+		.start = CNS3XXX_GPIOB_BASE + GPIO_BIT_CLEAR_OFFSET,
+		.end   = CNS3XXX_GPIOB_BASE + GPIO_BIT_CLEAR_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "clr",
+	},
+	[3] = {
+		.start = CNS3XXX_GPIOB_BASE + GPIO_DIR_OFFSET,
+		.end   = CNS3XXX_GPIOB_BASE + GPIO_DIR_OFFSET + 3,
+		.flags = IORESOURCE_MEM,
+		.name  = "dirout",
+	},
+};
+
+static struct platform_device cns3xxx_mmgpio_device_b = {
+	.name		= "basic-mmio-gpio",
+	.id		= 1,
+	.num_resources	= ARRAY_SIZE(cns3xxx_mmgpio_resources_b),
+	.resource	= cns3xxx_mmgpio_resources_b,
+	.dev.platform_data = &(struct bgpio_pdata) {
+		.base	= MAX_GPIOA_NO,
+		.ngpio	= MAX_GPIOB_NO,
+	},
+};
+
 /*
  * Initialization
  */
 static struct platform_device *cns3420_pdevs[] __initdata = {
+	&cns3xxx_gpio_device,
+	&cns3xxx_mmgpio_device_a,
+	&cns3xxx_mmgpio_device_b,
 	&cns3420_nor_pdev,
 	&cns3xxx_usb_ehci_device,
 	&cns3xxx_usb_ohci_device,
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index 941a308..59ed13f 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -42,16 +42,6 @@ static struct map_desc cns3xxx_io_desc[] __initdata = {
 		.length		= SZ_4K,
 		.type		= MT_DEVICE,
 	}, {
-		.virtual	= CNS3XXX_GPIOA_BASE_VIRT,
-		.pfn		= __phys_to_pfn(CNS3XXX_GPIOA_BASE),
-		.length		= SZ_4K,
-		.type		= MT_DEVICE,
-	}, {
-		.virtual	= CNS3XXX_GPIOB_BASE_VIRT,
-		.pfn		= __phys_to_pfn(CNS3XXX_GPIOB_BASE),
-		.length		= SZ_4K,
-		.type		= MT_DEVICE,
-	}, {
 		.virtual	= CNS3XXX_MISC_BASE_VIRT,
 		.pfn		= __phys_to_pfn(CNS3XXX_MISC_BASE),
 		.length		= SZ_4K,
diff --git a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
index 191c8e5..6559d24 100644
--- a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
+++ b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
@@ -624,9 +624,13 @@ int cns3xxx_cpu_clock(void);
 
 #define NR_IRQS_CNS3XXX			(IRQ_TC11MP_GIC_START + 64)
 
-#if !defined(NR_IRQS) || (NR_IRQS < NR_IRQS_CNS3XXX)
+#define MAX_GPIOA_NO			32
+#define MAX_GPIOB_NO			32
+#define MAX_GPIO_NO			(MAX_GPIOA_NO + MAX_GPIOB_NO)
+
+#if !defined(NR_IRQS) || (NR_IRQS < (NR_IRQS_CNS3XXX + MAX_GPIO_NO))
 #undef NR_IRQS
-#define NR_IRQS				NR_IRQS_CNS3XXX
+#define NR_IRQS				(NR_IRQS_CNS3XXX + MAX_GPIO_NO)
 #endif
 
 #endif	/* __MACH_BOARD_CNS3XXX_H */
diff --git a/arch/arm/mach-cns3xxx/include/mach/gpio.h b/arch/arm/mach-cns3xxx/include/mach/gpio.h
new file mode 100644
index 0000000..7b68acf
--- /dev/null
+++ b/arch/arm/mach-cns3xxx/include/mach/gpio.h
@@ -0,0 +1,64 @@
+/*******************************************************************************
+ *
+ *  Copyright (c) 2011 Cavium
+ *
+ *  This file is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License, Version 2, as
+ *  published by the Free Software Foundation.
+ *
+ *  This file is distributed in the hope that it will be useful,
+ *  but AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
+ *  NONINFRINGEMENT.  See the GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this file; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA or
+ *  visit http://www.gnu.org/licenses/.
+ *
+ *  This file may also be available under a different license from Cavium.
+ *  Contact Cavium for more information
+ *
+ ******************************************************************************/
+
+#ifndef	_CNS3XXX_GPIO_H_
+#define	_CNS3XXX_GPIO_H_
+
+#include <mach/cns3xxx.h>
+
+#define ARCH_NR_GPIOS				MAX_GPIO_NO
+
+#include <asm-generic/gpio.h>
+
+#define GPIO_OUTPUT_OFFSET			0x00
+#define GPIO_INPUT_OFFSET			0x04
+#define GPIO_DIR_OFFSET				0x08
+#define GPIO_BIT_SET_OFFSET			0x10
+#define GPIO_BIT_CLEAR_OFFSET			0x14
+#define GPIO_INTR_ENABLE_OFFSET			0x20
+#define GPIO_INTR_RAW_STATUS_OFFSET		0x24
+#define GPIO_INTR_MASKED_STATUS_OFFSET		0x28
+#define GPIO_INTR_MASK_OFFSET			0x2C
+#define GPIO_INTR_CLEAR_OFFSET			0x30
+#define GPIO_INTR_TRIGGER_METHOD_OFFSET		0x34
+#define GPIO_INTR_TRIGGER_BOTH_EDGES_OFFSET	0x38
+#define GPIO_INTR_TRIGGER_POL_OFFSET		0x3C
+#define GPIO_BOUNCE_ENABLE_OFFSET		0x40
+#define GPIO_BOUNCE_PRESCALE_OFFSET		0x44
+
+
+#define gpio_get_value			__gpio_get_value
+#define gpio_set_value			__gpio_set_value
+#define gpio_cansleep			__gpio_cansleep
+#define gpio_to_irq			cns3xxx_gpio_to_irq
+
+#define GPIOA(n)			n
+#define GPIOB(n)			(MAX_GPIOA_NO + n)
+
+/* Function prototype */
+int  cns3xxx_sharepin_request(unsigned gpio, const char *label);
+void cns3xxx_sharepin_free(unsigned gpio);
+inline int cns3xxx_gpio_to_irq(unsigned gpio);
+
+#endif
+
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d539efd..368cd67 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -90,6 +90,12 @@ config GPIO_IT8761E
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
+config GPIO_CNS3XXX
+	bool "CNS3XXX GPIO"
+	depends on ARCH_CNS3XXX
+	help
+	  Say yes here to support the Cavium CNS3XXX GPIO interrupts.
+
 config GPIO_EP93XX
 	def_bool y
 	depends on ARCH_EP93XX
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 9588948..7f472ec 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_GPIO_AB8500)	+= gpio-ab8500.o
 obj-$(CONFIG_GPIO_ADP5520)	+= gpio-adp5520.o
 obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
 obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
+obj-$(CONFIG_GPIO_CNS3XXX)	+= gpio-cns3xxx.o
 obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
diff --git a/drivers/gpio/gpio-cns3xxx.c b/drivers/gpio/gpio-cns3xxx.c
new file mode 100644
index 0000000..f60d8dd
--- /dev/null
+++ b/drivers/gpio/gpio-cns3xxx.c
@@ -0,0 +1,516 @@
+/*******************************************************************************
+ *
+ *  drivers/gpio/gpio-cns3xxx.c
+ *
+ *  GPIO driver for the CNS3XXX SOCs
+ *
+ *  Copyright (c) 2011 Cavium
+ *
+ *  This file is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License, Version 2, as
+ *  published by the Free Software Foundation.
+ *
+ *  This file is distributed in the hope that it will be useful,
+ *  but AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
+ *  NONINFRINGEMENT.  See the GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this file; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA or
+ *  visit http://www.gnu.org/licenses/.
+ *
+ *  This file may also be available under a different license from Cavium.
+ *  Contact Cavium for more information
+ *
+ ******************************************************************************/
+
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+#include <asm/mach/irq.h>
+
+
+struct chog_gpio_chip {
+	char				*name;
+	int				base;
+	u16				ngpio;
+	int				irq;
+	struct irq_chip_generic		*gc;
+	void __iomem			*reg_base;
+	void __iomem			*reg_gpio_dis;
+};
+
+/* GPIO information that matches basic-mmio-gpio declaration in
+ * arch/arm/mach-cns3xxx/cns3420vb.c
+ */
+static struct chog_gpio_chip gc_info[] = {
+	/*name		base		ngpio*/
+	{"GPIOA",	0x00,		MAX_GPIOA_NO},
+	{"GPIOB",	MAX_GPIOA_NO,	MAX_GPIOB_NO},
+};
+#define nr_banks			ARRAY_SIZE(gc_info)
+
+/* The CNS3XXX GPIO pins are shard with special functions which is described in
+ * the following table. "none" in this table represent the corresponding pins
+ * are dedicate GPIO.
+ */
+static char *sharepin_desc[] = {
+	/* GPIOA group */
+/*  0 */ "none",	"none",		"SD_PWR_ON",	"OTG_DRV_VBUS",
+/*  4 */ "Don't use",	"none",		"none",		"none",
+/*  8 */ "CIM_nOE",	"LCD_Power",	"SMI_nCS3",	"SMI_nCS2",
+/* 12 */ "SMI_Clk",	"SMI_nADV",	"SMI_CRE",	"SMI_Addr[26]",
+/* 16 */ "SD_nCD",	"SD_nWP",	"SD_CLK",	"SD_CMD",
+/* 20 */ "SD_DT[7]",	"SD_DT[6]",	"SD_DT[5]",	"SD_DT[4]",
+/* 24 */ "SD_DT[3]",	"SD_DT[2]",	"SD_DT[1]",	"SD_DT[0]",
+/* 28 */ "SD_LED",	"UR_RXD1",	"UR_TXD1",	"UR_RTS2",
+	/* GPIOB group */
+/*  0 */ "UR_CTS2",	"UR_RXD2",	"UR_TXD2",	"PCMCLK",
+/*  4 */ "PCMFS",	"PCMDT",	"PCMDR",	"SPInCS1",
+/*  8 */ "SPInCS2",	"SPICLK",	"SPIDT",	"SPIDR",
+/* 12 */ "SCL",		"SDA",		"GMII2_CRS",	"GMII2_COL",
+/* 16 */ "RGMII1_CRS",	"RGMII1_COL",	"RGMII0_CRS",	"RGMII0_COL",
+/* 20 */ "MDC",		"MDIO",		"I2SCLK",	"I2SFS",
+/* 24 */ "I2SDT",	"I2SDR",	"ClkOut",	"Ext_Intr2",
+/* 28 */ "Ext_Intr1",	"Ext_Intr0",	"SATA_LED1",	"SATA_LED0",
+};
+
+struct cns3xxx_regs {
+	char		*name;
+	void __iomem	*addr;
+	u32		offset;
+};
+
+/* gc_info[x].gc->regs offsets are count from GPIO_INTR_ENABLE_OFFSET. */
+#define get_offset(n)			(n - GPIO_INTR_ENABLE_OFFSET)
+static struct cns3xxx_regs gpio_regs[] =  {
+	{"Interrupt Enable",		0, GPIO_INTR_ENABLE_OFFSET},
+	{"Interrupt Raw Status",	0, GPIO_INTR_RAW_STATUS_OFFSET},
+	{"Interrupt Masked Status",	0, GPIO_INTR_MASKED_STATUS_OFFSET},
+	{"Interrupt Level Trigger",	0, GPIO_INTR_TRIGGER_METHOD_OFFSET},
+	{"Interrupt Both Edge",		0, GPIO_INTR_TRIGGER_BOTH_EDGES_OFFSET},
+	{"Interrupt Falling Edge",	0, GPIO_INTR_TRIGGER_POL_OFFSET},
+	{"Interrupt MASKED",		0, GPIO_INTR_MASK_OFFSET},
+	{"GPIO Bounce Enable",		0, GPIO_BOUNCE_ENABLE_OFFSET},
+	{"GPIO Bounce Prescale",	0, GPIO_BOUNCE_PRESCALE_OFFSET},
+};
+
+static struct cns3xxx_regs misc_regs[] =  {
+	{"Drive Strength Register A",	MISC_IO_PAD_DRIVE_STRENGTH_CTRL_A},
+	{"Drive Strength Register B",	MISC_IO_PAD_DRIVE_STRENGTH_CTRL_B},
+	{"Pull Up/Down Ctrl A[15:0]",	MISC_GPIOA_15_0_PULL_CTRL_REG},
+	{"Pull Up/Down Ctrl A[31:16]",	MISC_GPIOA_16_31_PULL_CTRL_REG},
+	{"Pull Up/Down Ctrl B[15:0]",	MISC_GPIOB_15_0_PULL_CTRL_REG},
+	{"Pull Up/Down Ctrl B[31:16]",	MISC_GPIOB_16_31_PULL_CTRL_REG},
+};
+
+static DEFINE_SPINLOCK(gpio_lock);
+
+/*
+ * Turn on corresponding shared pin function.
+ * Turn on shared pin function will also disable GPIO function. Related GPIO
+ * control registers are still accessable but not reflect to pin.
+ */
+int cns3xxx_sharepin_request(unsigned gpio, const char *label)
+{
+	int i, val, ret, offset = gpio;
+
+	if (!label)
+		label = sharepin_desc[gpio];
+
+	ret = gpio_request(gpio, label);
+	if (ret) {
+		printk(KERN_INFO "gpio-%d already in use! Err=%d\n", gpio, ret);
+		return ret;
+	}
+
+	for (i = 0; i < nr_banks; i++) {
+		if (offset >= gc_info[i].ngpio) {
+			offset -= gc_info[i].ngpio;
+			continue;
+		}
+		spin_lock(&gpio_lock);
+		val = readl(gc_info[i].reg_gpio_dis);
+		val |= (1 << offset);
+		writel(val, gc_info[i].reg_gpio_dis);
+		spin_unlock(&gpio_lock);
+		printk(KERN_INFO "%s[%d] is used by %s function!\n",
+				gc_info[i].name, offset, sharepin_desc[gpio]);
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(cns3xxx_sharepin_request);
+
+/*
+ * Turn off corresponding share pin function.
+ */
+void cns3xxx_sharepin_free(unsigned gpio)
+{
+	int i, val, offset = gpio;
+
+	gpio_free(gpio);
+
+	for (i = 0; i < nr_banks; i++) {
+		if (offset >= gc_info[i].ngpio) {
+			offset -= gc_info[i].ngpio;
+			continue;
+		}
+		spin_lock(&gpio_lock);
+		val = readl(gc_info[i].reg_gpio_dis);
+		val &= ~(1 << offset);
+		writel(val, gc_info[i].reg_gpio_dis);
+		spin_unlock(&gpio_lock);
+		printk(KERN_INFO "%s[%d] share pin function (%s) disabled!\n",
+				gc_info[i].name, offset, sharepin_desc[gpio]);
+		break;
+	}
+}
+EXPORT_SYMBOL(cns3xxx_sharepin_free);
+
+inline int cns3xxx_gpio_to_irq(unsigned gpio)
+{
+	return NR_IRQS_CNS3XXX + gpio;
+}
+EXPORT_SYMBOL(gpio_to_irq);
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+static int cns3xxx_dbg_gpio_show_reg(struct seq_file *s, void *unused)
+{
+	int i, offset;
+	seq_printf(s,	"Register Description        GPIOA     GPIOB\n"
+			"====================        =====     =====\n");
+	seq_printf(s,	"%-26.26s: %08x  %08x\n", "GPIO Disable",
+			readl(gc_info[0].reg_gpio_dis),
+			readl(gc_info[1].reg_gpio_dis));
+	for (i = 0; i < ARRAY_SIZE(gpio_regs); i++) {
+		offset = get_offset(gpio_regs[i].offset);
+		seq_printf(s, "%-26.26s: %08x  %08x\n",
+			gpio_regs[i].name,
+			readl(gc_info[0].reg_base + offset),
+			readl(gc_info[1].reg_base + offset));
+	}
+
+	seq_printf(s,	"\n"
+			"Register Description        Value\n"
+			"====================        =====\n");
+	for (i = 0; i < ARRAY_SIZE(misc_regs); i++) {
+		seq_printf(s, "%-26.26s: %08x\n",
+			misc_regs[i].name, readl(misc_regs[i].addr));
+	}
+	return 0;
+}
+
+static int dbg_gpio_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cns3xxx_dbg_gpio_show_reg, &inode->i_private);
+}
+
+static const struct file_operations debug_fops = {
+	.open		= dbg_gpio_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init cns3xxx_gpio_debuginit(void)
+{
+	debugfs_create_file("gpio-regs", S_IRUGO, NULL, NULL, &debug_fops);
+	return 0;
+}
+late_initcall(cns3xxx_gpio_debuginit);
+
+#endif /* CONFIG_DEBUG_FS */
+
+/*
+ * GPIO interrtups are remapped to unused irq number.
+ * The remapped GPIO IRQ number start from NR_IRQS_CNS3XXX (96). Here is the
+ * table of GPIO to irq mapping table.
+ *
+ *	GPIOA	GPIOB	|	GPIOA	GPIOB
+ * No.	IRQ	IRQ	|  No.	IRQ	IRQ
+ *  0	 96	128	|  16	112	144
+ *  1	 97	129	|  17	113	145
+ *  2	 98	130	|  18	114	146
+ *  3	 99	131	|  19	115	147
+ *  4	100	132	|  20	116	148
+ *  5	101	133	|  21	117	149
+ *  6	102	134	|  22	118	150
+ *  7	103	135	|  23	119	151
+ *  8	104	136	|  24	120	152
+ *  9	105	137	|  25	121	153
+ * 10	106	138	|  26	122	154
+ * 11	107	139	|  27	123	155
+ * 12	108	140	|  28	124	156
+ * 13	109	141	|  29	125	157
+ * 14	110	142	|  30	126	158
+ * 15	111	143	|  31	127	159
+ */
+
+static inline struct irq_chip_regs *cur_regs(struct irq_data *d)
+{
+	return &container_of(d->chip, struct irq_chip_type, chip)->regs;
+}
+
+/*
+ * Set trigger type
+ *
+ * Trigger setting for corresponding bits.
+ *
+ *				Level	Both	Poln
+ * IRQ_TYPE_EDGE_RISING		0	0	0
+ * IRQ_TYPE_EDGE_FALLING	0	0	1
+ * IRQ_TYPE_EDGE_BOTH		0	1	X
+ * IRQ_TYPE_LEVEL_HIGH		1	X	0
+ * IRQ_TYPE_LEVEL_LOW		1	X	1
+ *
+ * The both edge register offset is not defined in the irq_chip_regs. Here take
+ * the advantage of "type" register offset, which is 4 byte prior to both edge
+ * register.
+ */
+int cns3xxx_gpio_set_irq_type(struct irq_data *d, unsigned int type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	u32 mask = 1 << (d->irq - gc->irq_base);
+	u32 reg_lvl, reg_both, reg_poln;
+
+	irq_gc_lock(gc);
+
+	reg_lvl  = irq_reg_readl(gc->reg_base + cur_regs(d)->type);
+	reg_both = irq_reg_readl(gc->reg_base + cur_regs(d)->type + 4);
+	reg_poln = irq_reg_readl(gc->reg_base + cur_regs(d)->polarity);
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_RISING:
+		reg_lvl  &= ~mask;
+		reg_both &= ~mask;
+		reg_poln &= ~mask;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		reg_lvl  &= ~mask;
+		reg_both &= ~mask;
+		reg_poln |= mask;
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		reg_lvl  &= ~mask;
+		reg_both |= mask;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		reg_lvl  |= mask;
+		reg_poln &= ~mask;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		reg_lvl  |= mask;
+		reg_poln |= mask;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	irq_reg_writel(reg_lvl,  gc->reg_base + cur_regs(d)->type);
+	irq_reg_writel(reg_both, gc->reg_base + cur_regs(d)->type + 4);
+	irq_reg_writel(reg_poln, gc->reg_base + cur_regs(d)->polarity);
+
+	irq_gc_unlock(gc);
+	return 0;
+}
+
+static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct chog_gpio_chip *cgc = irq_get_handler_data(irq);
+	struct irq_chip *ic = irq_desc_get_chip(desc);
+	unsigned i;
+	int target_irq;
+	u32 status;
+
+	chained_irq_enter(ic, desc);
+
+	status = readl(cgc->reg_base +
+			get_offset(GPIO_INTR_MASKED_STATUS_OFFSET));
+	pr_debug("%s interrupt status=0x%08x\n", __func__, status);
+
+	for (i = 0; i < cgc->ngpio; i++) {
+		if (status & (1 << i)) {
+			target_irq = i + NR_IRQS_CNS3XXX + cgc->base;
+			pr_debug("Invoke cascaded irq %d from irq %d\n",
+					target_irq, cgc->irq);
+			generic_handle_irq(target_irq);
+		}
+	}
+
+	chained_irq_exit(ic, desc);
+}
+
+static void __iomem *gpio_map(struct platform_device *pdev,
+		const char *name, int *err)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *r;
+	resource_size_t start;
+	resource_size_t sz;
+	void __iomem *ret;
+
+	*err = 0;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
+	if (!r)
+		return NULL;
+
+	sz = resource_size(r);
+	start = r->start;
+
+	if (!devm_request_mem_region(dev, start, sz, r->name)) {
+		*err = -EBUSY;
+		return NULL;
+	}
+
+	ret = devm_ioremap(dev, start, sz);
+	if (!ret) {
+		*err = -ENOMEM;
+		return NULL;
+	}
+
+	return ret;
+}
+
+static int __devinit gpio_probe(struct platform_device *pdev)
+{
+	int i, nr_gpios = 0, err = 0;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	void __iomem *misc_reg;
+	struct irq_chip_type *ct;
+
+	/* TODO Once the clk framework (clk_get() + clk_enable()) is
+	 * implemented. Use clok framework APIs instead of these APIs.
+	 */
+	cns3xxx_pwr_clk_en(0x1 << PM_CLK_GATE_REG_OFFSET_GPIO);
+	cns3xxx_pwr_soft_rst(0x1 << PM_CLK_GATE_REG_OFFSET_GPIO);
+
+
+	misc_reg = gpio_map(pdev, "MISC", &err);
+	if (!misc_reg) {
+		dev_dbg(dev, "%s gpio_map \"MISC\" failure! err=%d\n",
+				__func__, err);
+		return err;
+	}
+
+	/* Scan and match GPIO resources */
+	for (i = 0; i < nr_banks; i++) {
+		/* Fetech GPIO interrupt control register base address */
+		gc_info[i].reg_base = gpio_map(pdev, gc_info[i].name, &err);
+		if (!gc_info[i].reg_base) {
+			dev_dbg(dev, "%s gpio_map %s failure! err=%d\n",
+					__func__, gc_info[i].name, err);
+			goto err1;
+		}
+
+		/* Fetech GPIO interrupt ID number */
+		res = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
+				gc_info[i].name);
+		if (!res) {
+			dev_dbg(dev, "%s platform_get_resource_byname (%s)"
+					"failed!\n", gc_info[i].name, __func__);
+			err = -ENODEV;
+			goto err2;
+		}
+		gc_info[i].irq = res->start;
+		gc_info[i].reg_gpio_dis	= misc_reg + 0x14 + i * 4;
+
+		gc_info[i].gc = irq_alloc_generic_chip("GPIO", 1,
+				NR_IRQS_CNS3XXX + gc_info[i].base,
+				gc_info[i].reg_base, handle_level_irq);
+		if (!gc_info[i].gc) {
+			dev_dbg(dev, "%s irq_alloc_generic_chip failed!\n",
+					__func__);
+			err = -ENOMEM;
+			goto err2;
+		}
+		gc_info[i].gc->private = &gc_info[i];
+
+		ct = gc_info[i].gc->chip_types;
+		ct->regs.mask = get_offset(GPIO_INTR_ENABLE_OFFSET);
+		ct->regs.ack = get_offset(GPIO_INTR_CLEAR_OFFSET);
+		ct->regs.type = get_offset(GPIO_INTR_TRIGGER_METHOD_OFFSET);
+		ct->regs.polarity = get_offset(GPIO_INTR_TRIGGER_POL_OFFSET);
+		ct->type = IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW;
+		ct->chip.irq_ack = irq_gc_ack_set_bit;
+		ct->chip.irq_mask = irq_gc_mask_clr_bit;
+		ct->chip.irq_unmask = irq_gc_mask_set_bit;
+		ct->chip.irq_set_type = cns3xxx_gpio_set_irq_type;
+
+		irq_setup_generic_chip(gc_info[i].gc, IRQ_MSK(gc_info[i].ngpio),
+			IRQ_GC_INIT_MASK_CACHE | IRQ_GC_INIT_NESTED_LOCK,
+			IRQ_NOREQUEST, IRQ_LEVEL | IRQ_NOPROBE);
+
+		irq_set_chained_handler(gc_info[i].irq, gpio_irq_handler);
+		err = irq_set_handler_data(gc_info[i].irq, &gc_info[i]);
+		if (err) {
+			dev_dbg(dev, "%s irq_set_handler_data fail!\n",
+					__func__);
+			goto err2;
+		}
+
+		nr_gpios += gc_info[i].ngpio;
+		if (nr_gpios >= MAX_GPIO_NO)
+			break;
+	}
+
+	return 0;
+
+err2:
+	if (gc_info[1].reg_base)
+		devm_iounmap(dev, gc_info[0].reg_base);
+
+err1:
+	if (gc_info[0].reg_base)
+		devm_iounmap(dev, gc_info[0].reg_base);
+
+	devm_iounmap(dev, misc_reg);
+
+	return err;
+}
+
+static int gpio_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < nr_banks; i++)
+		irq_remove_generic_chip(gc_info[i].gc,
+				IRQ_MSK(gc_info[i].ngpio),
+				IRQ_NOREQUEST, IRQ_LEVEL | IRQ_NOPROBE);
+
+	return 0;
+}
+
+static struct platform_driver cns3xxx_gpio_driver = {
+	.probe		= gpio_probe,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "cns3xxx-gpio",
+	},
+	.remove		= gpio_remove,
+};
+
+int __init cns3xxx_gpio_init(void)
+{
+	return platform_driver_register(&cns3xxx_gpio_driver);
+}
+
+void __exit cns3xxx_gpio_exit(void)
+{
+	platform_driver_unregister(&cns3xxx_gpio_driver);
+}
+
+module_init(cns3xxx_gpio_init);
+module_exit(cns3xxx_gpio_exit);
+
+MODULE_LICENSE("GPL");
+
-- 
1.7.6

