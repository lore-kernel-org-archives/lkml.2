Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab2BBXwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:52:24 -0500
Received: from xes-mad.com ([216.165.139.218]:47157 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757736Ab2BBXv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:51:57 -0500
X-Greylist: delayed 1584 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Feb 2012 18:51:54 EST
Date: Thu, 02 Feb 2012 17:25:14 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: guenter roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: [PATCH 1/3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <484bd1ed-f456-40b5-b5c2-c0e50f2787d5@zimbra>
In-Reply-To: <1328220172.2261.162.camel@groeck-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver currently creates resources for use by a forthcoming ICH
chipset GPIO driver. It could be expanded to created the resources for
converting the esb2rom (mtd) and iTCO_wdt (wdt), and potentially more,
drivers to use the mfd model.

Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
---
 drivers/mfd/Kconfig         |    9 +
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/lpc_ich.c       |  531 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/lpc_ich.h |   33 +++
 4 files changed, 574 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/lpc_ich.c
 create mode 100644 include/linux/mfd/lpc_ich.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6ca938a..18eca82 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -636,6 +636,15 @@ config LPC_SCH
 	  LPC bridge function of the Intel SCH provides support for
 	  System Management Bus and General Purpose I/O.
 
+config LPC_ICH
+	tristate "Intel ICH LPC"
+	depends on PCI
+	select MFD_CORE
+	help
+	  The LPC bridge function of the Intel ICH provides support for
+	  many functional units. This driver provides needed support for
+	  other drivers to control these functions, currently GPIO.
+
 config MFD_RDC321X
 	tristate "Support for RDC-R321x southbridge"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index d7d47d2..d479882 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_MFD_DB5500_PRCMU)	+= db5500-prcmu.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
+obj-$(CONFIG_LPC_ICH)		+= lpc_ich.o
 obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
 obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
 obj-$(CONFIG_MFD_JZ4740_ADC)	+= jz4740-adc.o
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
new file mode 100644
index 0000000..a288c74
--- /dev/null
+++ b/drivers/mfd/lpc_ich.c
@@ -0,0 +1,531 @@
+/*
+ *  lpc_ich.c - LPC interface for Intel ICH
+ *
+ *  LPC bridge function of the Intel ICH contains many other
+ *  functional units, such as Interrupt controllers, Timers,
+ *  Power Management, System Management, GPIO, RTC, and LPC
+ *  Configuration Registers.
+ *
+ *  This driver is derived from lpc_sch.
+
+ *  Copyright (c) 2011 Extreme Engineering Solution, Inc.
+ *  Author: Aaron Sierra <asierra@xes-inc.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/acpi.h>
+#include <linux/pci.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/lpc_ich.h>
+
+/* Convenient wrapper to make our PCI ID table */
+#define ICHX_PDEV(dev, idx) \
+	.vendor = PCI_VENDOR_ID_INTEL,	\
+	.device = dev,			\
+	.subvendor = PCI_ANY_ID,	\
+	.subdevice = PCI_ANY_ID,	\
+	.class = 0,			\
+	.class_mask = 0,		\
+	.driver_data = idx
+
+#define ACPIBASE		0x40
+#define ACPIBASE_GPE_OFF	0x20
+#define ACPIBASE_GPE_END	0x2f
+#define ACPICTRL		0x44
+
+#define GPIOBASE		0x48
+#define GPIOCTRL		0x4C
+#define GPIOBASE_IO_SIZE	0x80
+
+static u8 lpc_ich_acpi_save, lpc_ich_gpio_save;
+
+static struct resource gpio_ich_res[] = {
+	/* BASE */
+	{
+		.flags = IORESOURCE_IO,
+	},
+	/* ACPI */
+	{
+		.flags = IORESOURCE_IO,
+	},
+};
+
+static struct mfd_cell lpc_ich_cells[] = {
+	{
+		.name = "ich_gpio",
+		.num_resources = ARRAY_SIZE(gpio_ich_res),
+		.resources = gpio_ich_res,
+	},
+};
+
+/* TCO related info */
+enum lpc_chipsets {
+	LPC_ICH = 0,	/* ICH */
+	LPC_ICH0,	/* ICH0 */
+	LPC_ICH2,	/* ICH2 */
+	LPC_ICH2M,	/* ICH2-M */
+	LPC_ICH3,	/* ICH3-S */
+	LPC_ICH3M,	/* ICH3-M */
+	LPC_ICH4,	/* ICH4 */
+	LPC_ICH4M,	/* ICH4-M */
+	LPC_CICH,	/* C-ICH */
+	LPC_ICH5,	/* ICH5 & ICH5R */
+	LPC_6300ESB,	/* 6300ESB */
+	LPC_ICH6,	/* ICH6 & ICH6R */
+	LPC_ICH6M,	/* ICH6-M */
+	LPC_ICH6W,	/* ICH6W & ICH6RW */
+	LPC_631XESB,	/* 631xESB/632xESB */
+	LPC_ICH7,	/* ICH7 & ICH7R */
+	LPC_ICH7DH,	/* ICH7DH */
+	LPC_ICH7M,	/* ICH7-M & ICH7-U */
+	LPC_ICH7MDH,	/* ICH7-M DH */
+	LPC_NM10,	/* NM10 */
+	LPC_ICH8,	/* ICH8 & ICH8R */
+	LPC_ICH8DH,	/* ICH8DH */
+	LPC_ICH8DO,	/* ICH8DO */
+	LPC_ICH8M,	/* ICH8M */
+	LPC_ICH8ME,	/* ICH8M-E */
+	LPC_ICH9,	/* ICH9 */
+	LPC_ICH9R,	/* ICH9R */
+	LPC_ICH9DH,	/* ICH9DH */
+	LPC_ICH9DO,	/* ICH9DO */
+	LPC_ICH9M,	/* ICH9M */
+	LPC_ICH9ME,	/* ICH9M-E */
+	LPC_ICH10,	/* ICH10 */
+	LPC_ICH10R,	/* ICH10R */
+	LPC_ICH10D,	/* ICH10D */
+	LPC_ICH10DO,	/* ICH10DO */
+	LPC_PCH,	/* PCH Desktop Full Featured */
+	LPC_PCHM,	/* PCH Mobile Full Featured */
+	LPC_P55,	/* P55 */
+	LPC_PM55,	/* PM55 */
+	LPC_H55,	/* H55 */
+	LPC_QM57,	/* QM57 */
+	LPC_H57,	/* H57 */
+	LPC_HM55,	/* HM55 */
+	LPC_Q57,	/* Q57 */
+	LPC_HM57,	/* HM57 */
+	LPC_PCHMSFF,	/* PCH Mobile SFF Full Featured */
+	LPC_QS57,	/* QS57 */
+	LPC_3400,	/* 3400 */
+	LPC_3420,	/* 3420 */
+	LPC_3450,	/* 3450 */
+	LPC_EP80579,	/* EP80579 */
+	LPC_CPT1,	/* Cougar Point */
+	LPC_CPT2,	/* Cougar Point Desktop */
+	LPC_CPT3,	/* Cougar Point Mobile */
+	LPC_CPT4,	/* Cougar Point */
+	LPC_CPT5,	/* Cougar Point */
+	LPC_CPT6,	/* Cougar Point */
+	LPC_CPT7,	/* Cougar Point */
+	LPC_CPT8,	/* Cougar Point */
+	LPC_CPT9,	/* Cougar Point */
+	LPC_CPT10,	/* Cougar Point */
+	LPC_CPT11,	/* Cougar Point */
+	LPC_CPT12,	/* Cougar Point */
+	LPC_CPT13,	/* Cougar Point */
+	LPC_CPT14,	/* Cougar Point */
+	LPC_CPT15,	/* Cougar Point */
+	LPC_CPT16,	/* Cougar Point */
+	LPC_CPT17,	/* Cougar Point */
+	LPC_CPT18,	/* Cougar Point */
+	LPC_CPT19,	/* Cougar Point */
+	LPC_CPT20,	/* Cougar Point */
+	LPC_CPT21,	/* Cougar Point */
+	LPC_CPT22,	/* Cougar Point */
+	LPC_CPT23,	/* Cougar Point */
+	LPC_CPT24,	/* Cougar Point */
+	LPC_CPT25,	/* Cougar Point */
+	LPC_CPT26,	/* Cougar Point */
+	LPC_CPT27,	/* Cougar Point */
+	LPC_CPT28,	/* Cougar Point */
+	LPC_CPT29,	/* Cougar Point */
+	LPC_CPT30,	/* Cougar Point */
+	LPC_CPT31,	/* Cougar Point */
+	LPC_PBG1,	/* Patsburg */
+	LPC_PBG2,	/* Patsburg */
+	LPC_DH89XXCC,	/* DH89xxCC */
+	LPC_PPT0,	/* Panther Point */
+	LPC_PPT1,	/* Panther Point */
+	LPC_PPT2,	/* Panther Point */
+	LPC_PPT3,	/* Panther Point */
+	LPC_PPT4,	/* Panther Point */
+	LPC_PPT5,	/* Panther Point */
+	LPC_PPT6,	/* Panther Point */
+	LPC_PPT7,	/* Panther Point */
+	LPC_PPT8,	/* Panther Point */
+	LPC_PPT9,	/* Panther Point */
+	LPC_PPT10,	/* Panther Point */
+	LPC_PPT11,	/* Panther Point */
+	LPC_PPT12,	/* Panther Point */
+	LPC_PPT13,	/* Panther Point */
+	LPC_PPT14,	/* Panther Point */
+	LPC_PPT15,	/* Panther Point */
+	LPC_PPT16,	/* Panther Point */
+	LPC_PPT17,	/* Panther Point */
+	LPC_PPT18,	/* Panther Point */
+	LPC_PPT19,	/* Panther Point */
+	LPC_PPT20,	/* Panther Point */
+	LPC_PPT21,	/* Panther Point */
+	LPC_PPT22,	/* Panther Point */
+	LPC_PPT23,	/* Panther Point */
+	LPC_PPT24,	/* Panther Point */
+	LPC_PPT25,	/* Panther Point */
+	LPC_PPT26,	/* Panther Point */
+	LPC_PPT27,	/* Panther Point */
+	LPC_PPT28,	/* Panther Point */
+	LPC_PPT29,	/* Panther Point */
+	LPC_PPT30,	/* Panther Point */
+	LPC_PPT31,	/* Panther Point */
+};
+
+struct lpc_ich_info lpc_chipset_info[] __devinitdata = {
+	{"ICH",					0},
+	{"ICH0",				0},
+	{"ICH2",				0},
+	{"ICH2-M",				0},
+	{"ICH3-S",				0},
+	{"ICH3-M",				0},
+	{"ICH4",				0},
+	{"ICH4-M",				0},
+	{"C-ICH",				0},
+	{"ICH5 or ICH5R",			0},
+	{"6300ESB",				0},
+	{"ICH6 or ICH6R",			0x0601},
+	{"ICH6-M",				0x0601},
+	{"ICH6W or ICH6RW",			0x0601},
+	{"631xESB/632xESB",			0x0601},
+	{"ICH7 or ICH7R",			0x0701},
+	{"ICH7DH",				0x0701},
+	{"ICH7-M or ICH7-U",			0x0701},
+	{"ICH7-M DH",				0x0701},
+	{"NM10",				0},
+	{"ICH8 or ICH8R",			0x0701},
+	{"ICH8DH",				0x0701},
+	{"ICH8DO",				0x0701},
+	{"ICH8M",				0x0701},
+	{"ICH8M-E",				0x0701},
+	{"ICH9",				0x0801},
+	{"ICH9R",				0x0801},
+	{"ICH9DH",				0x0801},
+	{"ICH9DO",				0x0801},
+	{"ICH9M",				0x0801},
+	{"ICH9M-E",				0x0801},
+	{"ICH10",				0x0a11},
+	{"ICH10R",				0x0a11},
+	{"ICH10D",				0x0a01},
+	{"ICH10DO",				0x0a01},
+	{"PCH Desktop Full Featured",		0x0501},
+	{"PCH Mobile Full Featured",		0x0501},
+	{"P55",					0x0501},
+	{"PM55",				0x0501},
+	{"H55",					0x0501},
+	{"QM57",				0x0501},
+	{"H57",					0x0501},
+	{"HM55",				0x0501},
+	{"Q57",					0x0501},
+	{"HM57",				0x0501},
+	{"PCH Mobile SFF Full Featured",	0x0501},
+	{"QS57",				0x0501},
+	{"3400",				0x0501},
+	{"3420",				0x0501},
+	{"3450",				0x0501},
+	{"EP80579",				0},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Cougar Point",			0x0501},
+	{"Patsburg",				0},
+	{"Patsburg",				0},
+	{"DH89xxCC",				0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{"Panther Point",			0},
+	{NULL, 0}
+};
+EXPORT_SYMBOL(lpc_chipset_info);
+
+static DEFINE_PCI_DEVICE_TABLE(lpc_ich_ids) = {
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801AA_0,	LPC_ICH)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801AB_0,	LPC_ICH0)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801BA_0,	LPC_ICH2)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801BA_10,	LPC_ICH2M)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801CA_0,	LPC_ICH3)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801CA_12,	LPC_ICH3M)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801DB_0,	LPC_ICH4)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801DB_12,	LPC_ICH4M)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801E_0,	LPC_CICH)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_82801EB_0,	LPC_ICH5)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ESB_1,		LPC_6300ESB)},
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH6_0,		LPC_ICH6) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH6_1,		LPC_ICH6M) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH6_2,		LPC_ICH6W) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ESB2_0,		LPC_631XESB) },
+	{ ICHX_PDEV(0x2671, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x2672, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x2673, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x2674, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x2675, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x2676, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x2677, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x2678, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x2679, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x267a, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x267b, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x267c, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x267d, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x267e, 				LPC_631XESB) },
+	{ ICHX_PDEV(0x267f, 				LPC_631XESB) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH7_0,		LPC_ICH7) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH7_30,	LPC_ICH7DH) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH7_1,		LPC_ICH7M) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH7_31,	LPC_ICH7MDH) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_TGP_LPC,	LPC_NM10) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH8_0,		LPC_ICH8) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH8_2,		LPC_ICH8DH) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH8_3,		LPC_ICH8DO) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH8_4,		LPC_ICH8M) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH8_1,		LPC_ICH8ME) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH9_8,		LPC_ICH9) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH9_7,		LPC_ICH9R) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH9_2,		LPC_ICH9DH) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH9_4,		LPC_ICH9DO) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH9_5,		LPC_ICH9M) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH9_1,		LPC_ICH9ME) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH10_2,	LPC_ICH10) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH10_1,	LPC_ICH10R) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH10_3,	LPC_ICH10D) },
+	{ ICHX_PDEV(PCI_DEVICE_ID_INTEL_ICH10_0,	LPC_ICH10DO) },
+	{ ICHX_PDEV(0x3b00, 				LPC_PCH) },
+	{ ICHX_PDEV(0x3b01,				LPC_PCHM) },
+	{ ICHX_PDEV(0x3b02,				LPC_P55) },
+	{ ICHX_PDEV(0x3b03,				LPC_PM55) },
+	{ ICHX_PDEV(0x3b06,				LPC_H55) },
+	{ ICHX_PDEV(0x3b07,				LPC_QM57) },
+	{ ICHX_PDEV(0x3b08,				LPC_H57) },
+	{ ICHX_PDEV(0x3b09,				LPC_HM55) },
+	{ ICHX_PDEV(0x3b0a,				LPC_Q57) },
+	{ ICHX_PDEV(0x3b0b,				LPC_HM57) },
+	{ ICHX_PDEV(0x3b0d,				LPC_PCHMSFF) },
+	{ ICHX_PDEV(0x3b0f,				LPC_QS57) },
+	{ ICHX_PDEV(0x3b12,				LPC_3400) },
+	{ ICHX_PDEV(0x3b14,				LPC_3420) },
+	{ ICHX_PDEV(0x3b16,				LPC_3450) },
+	{ ICHX_PDEV(0x5031,				LPC_EP80579) },
+	{ ICHX_PDEV(0x1c41,				LPC_CPT1) },
+	{ ICHX_PDEV(0x1c42,				LPC_CPT2) },
+	{ ICHX_PDEV(0x1c43,				LPC_CPT3) },
+	{ ICHX_PDEV(0x1c44,				LPC_CPT4) },
+	{ ICHX_PDEV(0x1c45,				LPC_CPT5) },
+	{ ICHX_PDEV(0x1c46,				LPC_CPT6) },
+	{ ICHX_PDEV(0x1c47,				LPC_CPT7) },
+	{ ICHX_PDEV(0x1c48,				LPC_CPT8) },
+	{ ICHX_PDEV(0x1c49,				LPC_CPT9) },
+	{ ICHX_PDEV(0x1c4a,				LPC_CPT10) },
+	{ ICHX_PDEV(0x1c4b,				LPC_CPT11) },
+	{ ICHX_PDEV(0x1c4c,				LPC_CPT12) },
+	{ ICHX_PDEV(0x1c4d,				LPC_CPT13) },
+	{ ICHX_PDEV(0x1c4e,				LPC_CPT14) },
+	{ ICHX_PDEV(0x1c4f,				LPC_CPT15) },
+	{ ICHX_PDEV(0x1c50,				LPC_CPT16) },
+	{ ICHX_PDEV(0x1c51,				LPC_CPT17) },
+	{ ICHX_PDEV(0x1c52,				LPC_CPT18) },
+	{ ICHX_PDEV(0x1c53,				LPC_CPT19) },
+	{ ICHX_PDEV(0x1c54,				LPC_CPT20) },
+	{ ICHX_PDEV(0x1c55,				LPC_CPT21) },
+	{ ICHX_PDEV(0x1c56,				LPC_CPT22) },
+	{ ICHX_PDEV(0x1c57,				LPC_CPT23) },
+	{ ICHX_PDEV(0x1c58,				LPC_CPT24) },
+	{ ICHX_PDEV(0x1c59,				LPC_CPT25) },
+	{ ICHX_PDEV(0x1c5a,				LPC_CPT26) },
+	{ ICHX_PDEV(0x1c5b,				LPC_CPT27) },
+	{ ICHX_PDEV(0x1c5c,				LPC_CPT28) },
+	{ ICHX_PDEV(0x1c5d,				LPC_CPT29) },
+	{ ICHX_PDEV(0x1c5e,				LPC_CPT30) },
+	{ ICHX_PDEV(0x1c5f,				LPC_CPT31) },
+	{ ICHX_PDEV(0x1d40,				LPC_PBG1) },
+	{ ICHX_PDEV(0x1d41,				LPC_PBG2) },
+	{ ICHX_PDEV(0x2310,				LPC_DH89XXCC) },
+	{ ICHX_PDEV(0x1e40,				LPC_PPT0) },
+	{ ICHX_PDEV(0x1e41,				LPC_PPT1) },
+	{ ICHX_PDEV(0x1e42,				LPC_PPT2) },
+	{ ICHX_PDEV(0x1e43,				LPC_PPT3) },
+	{ ICHX_PDEV(0x1e44,				LPC_PPT4) },
+	{ ICHX_PDEV(0x1e45,				LPC_PPT5) },
+	{ ICHX_PDEV(0x1e46,				LPC_PPT6) },
+	{ ICHX_PDEV(0x1e47,				LPC_PPT7) },
+	{ ICHX_PDEV(0x1e48,				LPC_PPT8) },
+	{ ICHX_PDEV(0x1e49,				LPC_PPT9) },
+	{ ICHX_PDEV(0x1e4a,				LPC_PPT10) },
+	{ ICHX_PDEV(0x1e4b,				LPC_PPT11) },
+	{ ICHX_PDEV(0x1e4c,				LPC_PPT12) },
+	{ ICHX_PDEV(0x1e4d,				LPC_PPT13) },
+	{ ICHX_PDEV(0x1e4e,				LPC_PPT14) },
+	{ ICHX_PDEV(0x1e4f,				LPC_PPT15) },
+	{ ICHX_PDEV(0x1e50,				LPC_PPT16) },
+	{ ICHX_PDEV(0x1e51,				LPC_PPT17) },
+	{ ICHX_PDEV(0x1e52,				LPC_PPT18) },
+	{ ICHX_PDEV(0x1e53,				LPC_PPT19) },
+	{ ICHX_PDEV(0x1e54,				LPC_PPT20) },
+	{ ICHX_PDEV(0x1e55,				LPC_PPT21) },
+	{ ICHX_PDEV(0x1e56,				LPC_PPT22) },
+	{ ICHX_PDEV(0x1e57,				LPC_PPT23) },
+	{ ICHX_PDEV(0x1e58,				LPC_PPT24) },
+	{ ICHX_PDEV(0x1e59,				LPC_PPT25) },
+	{ ICHX_PDEV(0x1e5a,				LPC_PPT26) },
+	{ ICHX_PDEV(0x1e5b,				LPC_PPT27) },
+	{ ICHX_PDEV(0x1e5c,				LPC_PPT28) },
+	{ ICHX_PDEV(0x1e5d,				LPC_PPT29) },
+	{ ICHX_PDEV(0x1e5e,				LPC_PPT30) },
+	{ ICHX_PDEV(0x1e5f,				LPC_PPT31) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
+
+static int __devinit lpc_ich_probe(struct pci_dev *dev,
+				const struct pci_device_id *id)
+{
+	u32 base_addr_cfg;
+	u32 base_addr;
+	int i;
+
+	/* Setup power management base register */
+	pci_read_config_dword(dev, ACPIBASE, &base_addr_cfg);
+	base_addr = base_addr_cfg & 0x0000ff80;
+	if (!base_addr) {
+		dev_err(&dev->dev, "I/O space for ACPI uninitialized\n");
+		return -ENODEV;
+	}
+
+	gpio_ich_res[ICH_RES_GPE0].start = base_addr + ACPIBASE_GPE_OFF;
+	gpio_ich_res[ICH_RES_GPE0].end = base_addr + ACPIBASE_GPE_END;
+
+	/* Enable LPC ACPI space */
+	pci_read_config_byte(dev, ACPICTRL, &lpc_ich_acpi_save);
+	pci_write_config_byte(dev, ACPICTRL, lpc_ich_acpi_save | 0x10);
+
+	/* Setup GPIO base register */
+	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
+	base_addr = base_addr_cfg & 0x0000ff80;
+	if (!base_addr) {
+		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
+		return -ENODEV;
+	}
+
+	gpio_ich_res[ICH_RES_GPIO].start = base_addr;
+	gpio_ich_res[ICH_RES_GPIO].end = base_addr + GPIOBASE_IO_SIZE - 1;
+
+	/* Enable LPC GPIO space */
+	pci_read_config_byte(dev, GPIOCTRL, &lpc_ich_gpio_save);
+	pci_write_config_byte(dev, GPIOCTRL, lpc_ich_gpio_save | 0x10);
+
+	for (i=0; i < ARRAY_SIZE(lpc_ich_cells); i++)
+		lpc_ich_cells[i].id = id->driver_data;
+
+	return mfd_add_devices(&dev->dev, 0,
+			lpc_ich_cells, ARRAY_SIZE(lpc_ich_cells), NULL, 0);
+}
+
+static void __devexit lpc_ich_remove(struct pci_dev *dev)
+{
+	mfd_remove_devices(&dev->dev);
+
+	pci_write_config_byte(dev, GPIOCTRL, lpc_ich_gpio_save);
+	pci_write_config_byte(dev, ACPICTRL, lpc_ich_acpi_save);
+}
+
+static struct pci_driver lpc_ich_driver = {
+	.name		= "lpc_ich",
+	.id_table	= lpc_ich_ids,
+	.probe		= lpc_ich_probe,
+	.remove		= __devexit_p(lpc_ich_remove),
+};
+
+static int __init lpc_ich_init(void)
+{
+	return pci_register_driver(&lpc_ich_driver);
+}
+
+static void __exit lpc_ich_exit(void)
+{
+	pci_unregister_driver(&lpc_ich_driver);
+}
+
+module_init(lpc_ich_init);
+module_exit(lpc_ich_exit);
+
+MODULE_AUTHOR("Aaron Sierra <asierra@xes-inc.com>");
+MODULE_DESCRIPTION("LPC interface for Intel ICH");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/lpc_ich.h b/include/linux/mfd/lpc_ich.h
new file mode 100644
index 0000000..27a1c32
--- /dev/null
+++ b/include/linux/mfd/lpc_ich.h
@@ -0,0 +1,33 @@
+/*
+ *  linux/drivers/mfd/lpc_ich.h
+ *
+ *  Copyright (c) 2012 Extreme Engineering Solution, Inc.
+ *  Author: Aaron Sierra <asierra@xes-inc.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef LPC_ICH_H
+#define LPC_ICH_H
+
+/* GPIO resources */
+#define ICH_RES_GPIO	0
+#define ICH_RES_GPE0	1
+
+struct lpc_ich_info {
+	char *name;
+	unsigned int gpio_version;
+};
+
+extern struct lpc_ich_info lpc_chipset_info[];
+#endif
-- 
1.7.0.4
