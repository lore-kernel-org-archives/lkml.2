Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2BQSSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:18:40 -0500
Received: from xes-mad.com ([216.165.139.218]:48763 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab2BQSSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:18:38 -0500
Date: Fri, 17 Feb 2012 12:18:18 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Guenter Roeck <guenter@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
Cc: Peter Tyser <ptyser@xes-inc.com>, Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3 v3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <cd679d99-46c9-4f8a-8f03-474637e013a8@zimbra>
In-Reply-To: <0080ec60-4f91-4642-bf3b-42ab667b3b13@zimbra>
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
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/Kconfig         |    9 +
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/lpc_ich.c       |  513 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/lpc_ich.h |   32 +++
 4 files changed, 555 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/lpc_ich.c
 create mode 100644 include/linux/mfd/lpc_ich.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index cd13e9f..f581e59 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -724,6 +724,15 @@ config LPC_SCH
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
index b953bab..6636c5a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_MFD_DB5500_PRCMU)	+= db5500-prcmu.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
+obj-$(CONFIG_LPC_ICH)		+= lpc_ich.o
 obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
 obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
 obj-$(CONFIG_MFD_JZ4740_ADC)	+= jz4740-adc.o
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
new file mode 100644
index 0000000..b5e054c
--- /dev/null
+++ b/drivers/mfd/lpc_ich.c
@@ -0,0 +1,513 @@
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
+ *
+ *  This driver supports the following I/O Controller hubs:
+ *	(See the intel documentation on http://developer.intel.com.)
+ *	document number 290655-003, 290677-014: 82801AA (ICH), 82801AB (ICHO)
+ *	document number 290687-002, 298242-027: 82801BA (ICH2)
+ *	document number 290733-003, 290739-013: 82801CA (ICH3-S)
+ *	document number 290716-001, 290718-007: 82801CAM (ICH3-M)
+ *	document number 290744-001, 290745-025: 82801DB (ICH4)
+ *	document number 252337-001, 252663-008: 82801DBM (ICH4-M)
+ *	document number 273599-001, 273645-002: 82801E (C-ICH)
+ *	document number 252516-001, 252517-028: 82801EB (ICH5), 82801ER (ICH5R)
+ *	document number 300641-004, 300884-013: 6300ESB
+ *	document number 301473-002, 301474-026: 82801F (ICH6)
+ *	document number 313082-001, 313075-006: 631xESB, 632xESB
+ *	document number 307013-003, 307014-024: 82801G (ICH7)
+ *	document number 322896-001, 322897-001: NM10
+ *	document number 313056-003, 313057-017: 82801H (ICH8)
+ *	document number 316972-004, 316973-012: 82801I (ICH9)
+ *	document number 319973-002, 319974-002: 82801J (ICH10)
+ *	document number 322169-001, 322170-003: 5 Series, 3400 Series (PCH)
+ *	document number 320066-003, 320257-008: EP80597 (IICH)
+ *	document number 324645-001, 324646-001: Cougar Point (CPT)
+ *	document number TBD : Patsburg (PBG)
+ *	document number TBD : DH89xxCC
+ *	document number TBD : Panther Point
+ *	document number TBD : Lynx Point
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
+#define ACPIBASE		0x40
+#define ACPIBASE_GPE_OFF	0x20
+#define ACPIBASE_GPE_END	0x2f
+#define ACPICTRL		0x44
+
+#define GPIOBASE		0x48
+#define GPIOCTRL		0x4C
+#define GPIOBASE_IO_SIZE	0x80
+
+static int lpc_ich_acpi_save = -1;
+static int lpc_ich_gpio_save = -1;
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
+enum lpc_cells {
+	LPC_GPIO = 0,
+};
+
+static struct mfd_cell lpc_ich_cells[] = {
+	[LPC_GPIO] = {
+		.name = "gpio_ich",
+		.num_resources = ARRAY_SIZE(gpio_ich_res),
+		.resources = gpio_ich_res,
+	},
+};
+
+/* chipset related info */
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
+	LPC_CPT,	/* Cougar Point */
+	LPC_CPTD,	/* Cougar Point Desktop */
+	LPC_CPTM,	/* Cougar Point Mobile */
+	LPC_PBG,	/* Patsburg */
+	LPC_DH89XXCC,	/* DH89xxCC */
+	LPC_PPT,	/* Panther Point */
+	LPC_LPT,	/* Lynx Point */
+};
+
+struct lpc_ich_info lpc_chipset_info[] __devinitdata = {
+	[LPC_ICH] = {"ICH",				0},
+	[LPC_ICH0] = {"ICH0",				0},
+	[LPC_ICH2] = {"ICH2",				0},
+	[LPC_ICH2M] = {"ICH2-M",			0},
+	[LPC_ICH3] = {"ICH3-S",				0},
+	[LPC_ICH3M] = {"ICH3-M",			0},
+	[LPC_ICH4] = {"ICH4",				0},
+	[LPC_ICH4M] = {"ICH4-M",			0},
+	[LPC_CICH] = {"C-ICH",				0},
+	[LPC_ICH5] = {"ICH5 or ICH5R",			0},
+	[LPC_6300ESB] = {"6300ESB",			0},
+	[LPC_ICH6] = {"ICH6 or ICH6R",			0x0601},
+	[LPC_ICH6M] = {"ICH6-M",			0x0601},
+	[LPC_ICH6W] = {"ICH6W or ICH6RW",		0x0601},
+	[LPC_631XESB] = {"631xESB/632xESB",		0x0601},
+	[LPC_ICH7] = {"ICH7 or ICH7R",			0x0701},
+	[LPC_ICH7DH] = {"ICH7DH",			0x0701},
+	[LPC_ICH7M] = {"ICH7-M or ICH7-U",		0x0701},
+	[LPC_ICH7MDH] = {"ICH7-M DH",			0x0701},
+	[LPC_NM10] = {"NM10",				0},
+	[LPC_ICH8] = {"ICH8 or ICH8R",			0x0701},
+	[LPC_ICH8DH] = {"ICH8DH",			0x0701},
+	[LPC_ICH8DO] = {"ICH8DO",			0x0701},
+	[LPC_ICH8M] = {"ICH8M",				0x0701},
+	[LPC_ICH8ME] = {"ICH8M-E",			0x0701},
+	[LPC_ICH9] = {"ICH9",				0x0801},
+	[LPC_ICH9R] = {"ICH9R",				0x0801},
+	[LPC_ICH9DH] = {"ICH9DH",			0x0801},
+	[LPC_ICH9DO] = {"ICH9DO",			0x0801},
+	[LPC_ICH9M] = {"ICH9M",				0x0801},
+	[LPC_ICH9ME] = {"ICH9M-E",			0x0801},
+	[LPC_ICH10] = {"ICH10",				0x0a11},
+	[LPC_ICH10R] = {"ICH10R",			0x0a11},
+	[LPC_ICH10D] = {"ICH10D",			0x0a01},
+	[LPC_ICH10DO] = {"ICH10DO",			0x0a01},
+	[LPC_PCH] = {"PCH Desktop Full Featured",	0x0501},
+	[LPC_PCHM] = {"PCH Mobile Full Featured",	0x0501},
+	[LPC_P55] = {"P55",				0x0501},
+	[LPC_PM55] = {"PM55",				0x0501},
+	[LPC_H55] = {"H55",				0x0501},
+	[LPC_QM57] = {"QM57",				0x0501},
+	[LPC_H57] = {"H57",				0x0501},
+	[LPC_HM55] = {"HM55",				0x0501},
+	[LPC_Q57] = {"Q57",				0x0501},
+	[LPC_HM57] = {"HM57",				0x0501},
+	[LPC_PCHMSFF] = {"PCH Mobile SFF Full Featured",0x0501},
+	[LPC_QS57] = {"QS57",				0x0501},
+	[LPC_3400] = {"3400",				0x0501},
+	[LPC_3420] = {"3420",				0x0501},
+	[LPC_3450] = {"3450",				0x0501},
+	[LPC_EP80579] = {"EP80579",			0},
+	[LPC_CPT] = {"Cougar Point",			0x0501},
+	[LPC_CPTD] = {"Cougar Point Desktop",		0x0501},
+	[LPC_CPTM] = {"Cougar Point Mobile",		0x0501},
+	[LPC_PBG] = {"Patsburg",			0},
+	[LPC_DH89XXCC] = {"DH89xxCC",			0},
+	[LPC_PPT] = {"Panther Point",			0},
+	[LPC_LPT] = {"Lynx Point",			0},
+};
+
+/*
+ * This data only exists for exporting the supported PCI ids
+ * via MODULE_DEVICE_TABLE.  We do not actually register a
+ * pci_driver, because the I/O Controller Hub has also other
+ * functions that probably will be registered by other drivers.
+ */
+static DEFINE_PCI_DEVICE_TABLE(lpc_ich_ids) = {
+	{ PCI_VDEVICE(INTEL, 0x2410), LPC_ICH},
+	{ PCI_VDEVICE(INTEL, 0x2420), LPC_ICH0},
+	{ PCI_VDEVICE(INTEL, 0x2440), LPC_ICH2},
+	{ PCI_VDEVICE(INTEL, 0x244c), LPC_ICH2M},
+	{ PCI_VDEVICE(INTEL, 0x2480), LPC_ICH3},
+	{ PCI_VDEVICE(INTEL, 0x248c), LPC_ICH3M},
+	{ PCI_VDEVICE(INTEL, 0x24c0), LPC_ICH4},
+	{ PCI_VDEVICE(INTEL, 0x24cc), LPC_ICH4M},
+	{ PCI_VDEVICE(INTEL, 0x2450), LPC_CICH},
+	{ PCI_VDEVICE(INTEL, 0x24d0), LPC_ICH5},
+	{ PCI_VDEVICE(INTEL, 0x25a1), LPC_6300ESB},
+	{ PCI_VDEVICE(INTEL, 0x2640), LPC_ICH6},
+	{ PCI_VDEVICE(INTEL, 0x2641), LPC_ICH6M},
+	{ PCI_VDEVICE(INTEL, 0x2642), LPC_ICH6W},
+	{ PCI_VDEVICE(INTEL, 0x2670), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2671), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2672), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2673), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2674), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2675), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2676), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2677), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2678), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x2679), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267a), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267b), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267c), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267d), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267e), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x267f), LPC_631XESB},
+	{ PCI_VDEVICE(INTEL, 0x27b8), LPC_ICH7},
+	{ PCI_VDEVICE(INTEL, 0x27b0), LPC_ICH7DH},
+	{ PCI_VDEVICE(INTEL, 0x27b9), LPC_ICH7M},
+	{ PCI_VDEVICE(INTEL, 0x27bd), LPC_ICH7MDH},
+	{ PCI_VDEVICE(INTEL, 0x27bc), LPC_NM10},
+	{ PCI_VDEVICE(INTEL, 0x2810), LPC_ICH8},
+	{ PCI_VDEVICE(INTEL, 0x2812), LPC_ICH8DH},
+	{ PCI_VDEVICE(INTEL, 0x2814), LPC_ICH8DO},
+	{ PCI_VDEVICE(INTEL, 0x2815), LPC_ICH8M},
+	{ PCI_VDEVICE(INTEL, 0x2811), LPC_ICH8ME},
+	{ PCI_VDEVICE(INTEL, 0x2918), LPC_ICH9},
+	{ PCI_VDEVICE(INTEL, 0x2916), LPC_ICH9R},
+	{ PCI_VDEVICE(INTEL, 0x2912), LPC_ICH9DH},
+	{ PCI_VDEVICE(INTEL, 0x2914), LPC_ICH9DO},
+	{ PCI_VDEVICE(INTEL, 0x2919), LPC_ICH9M},
+	{ PCI_VDEVICE(INTEL, 0x2917), LPC_ICH9ME},
+	{ PCI_VDEVICE(INTEL, 0x3a18), LPC_ICH10},
+	{ PCI_VDEVICE(INTEL, 0x3a16), LPC_ICH10R},
+	{ PCI_VDEVICE(INTEL, 0x3a1a), LPC_ICH10D},
+	{ PCI_VDEVICE(INTEL, 0x3a14), LPC_ICH10DO},
+	{ PCI_VDEVICE(INTEL, 0x3b00), LPC_PCH},
+	{ PCI_VDEVICE(INTEL, 0x3b01), LPC_PCHM},
+	{ PCI_VDEVICE(INTEL, 0x3b02), LPC_P55},
+	{ PCI_VDEVICE(INTEL, 0x3b03), LPC_PM55},
+	{ PCI_VDEVICE(INTEL, 0x3b06), LPC_H55},
+	{ PCI_VDEVICE(INTEL, 0x3b07), LPC_QM57},
+	{ PCI_VDEVICE(INTEL, 0x3b08), LPC_H57},
+	{ PCI_VDEVICE(INTEL, 0x3b09), LPC_HM55},
+	{ PCI_VDEVICE(INTEL, 0x3b0a), LPC_Q57},
+	{ PCI_VDEVICE(INTEL, 0x3b0b), LPC_HM57},
+	{ PCI_VDEVICE(INTEL, 0x3b0d), LPC_PCHMSFF},
+	{ PCI_VDEVICE(INTEL, 0x3b0f), LPC_QS57},
+	{ PCI_VDEVICE(INTEL, 0x3b12), LPC_3400},
+	{ PCI_VDEVICE(INTEL, 0x3b14), LPC_3420},
+	{ PCI_VDEVICE(INTEL, 0x3b16), LPC_3450},
+	{ PCI_VDEVICE(INTEL, 0x5031), LPC_EP80579},
+	{ PCI_VDEVICE(INTEL, 0x1c41), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c42), LPC_CPTD},
+	{ PCI_VDEVICE(INTEL, 0x1c43), LPC_CPTM},
+	{ PCI_VDEVICE(INTEL, 0x1c44), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c45), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c46), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c47), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c48), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c49), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4a), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4b), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4c), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4d), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4e), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c4f), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c50), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c51), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c52), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c53), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c54), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c55), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c56), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c57), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c58), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c59), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5a), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5b), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5c), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5d), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5e), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1c5f), LPC_CPT},
+	{ PCI_VDEVICE(INTEL, 0x1d40), LPC_PBG},
+	{ PCI_VDEVICE(INTEL, 0x1d41), LPC_PBG},
+	{ PCI_VDEVICE(INTEL, 0x2310), LPC_DH89XXCC},
+	{ PCI_VDEVICE(INTEL, 0x1e40), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e41), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e42), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e43), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e44), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e45), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e46), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e47), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e48), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e49), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4a), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4b), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4c), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4d), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4e), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e4f), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e50), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e51), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e52), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e53), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e54), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e55), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e56), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e57), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e58), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e59), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5a), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5b), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5c), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5d), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5e), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x1e5f), LPC_PPT},
+	{ PCI_VDEVICE(INTEL, 0x8c40), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c41), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c42), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c43), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c44), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c45), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c46), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c47), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c48), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c49), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4a), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4b), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4c), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4d), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4e), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4f), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c50), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c51), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c52), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c53), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c54), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c55), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c56), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c57), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c58), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c59), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5a), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5b), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5c), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5d), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5e), LPC_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5f), LPC_LPT},
+	{ 0, },			/* End of list */
+};
+MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
+
+static void lpc_ich_finalize_cell(struct mfd_cell *cell,
+					const struct pci_device_id *id)
+{
+	cell->id = id->driver_data;
+	cell->platform_data = &lpc_chipset_info[id->driver_data];
+	cell->pdata_size = sizeof(struct lpc_ich_info);
+}
+
+static int __devinit lpc_ich_probe(struct pci_dev *dev,
+				const struct pci_device_id *id)
+{
+	u32 base_addr_cfg;
+	u32 base_addr;
+	u8 reg_save;
+	int ret;
+	bool cell_added = false;
+	bool acpi_conflict = false;
+
+	/* Setup power management base register */
+	pci_read_config_dword(dev, ACPIBASE, &base_addr_cfg);
+	base_addr = base_addr_cfg & 0x0000ff80;
+	if (!base_addr) {
+		dev_err(&dev->dev, "I/O space for ACPI uninitialized\n");
+		goto pm_done;
+	}
+
+	gpio_ich_res[ICH_RES_GPE0].start = base_addr + ACPIBASE_GPE_OFF;
+	gpio_ich_res[ICH_RES_GPE0].end = base_addr + ACPIBASE_GPE_END;
+	ret = acpi_check_resource_conflict(&gpio_ich_res[ICH_RES_GPE0]);
+	if (ret) {
+		/* this isn't necessarily fatal for the GPIO */
+		gpio_ich_res[ICH_RES_GPE0].start = 0;
+		gpio_ich_res[ICH_RES_GPE0].end = 0;
+		acpi_conflict = true;
+	}
+
+	/* Enable LPC ACPI space */
+	pci_read_config_byte(dev, ACPICTRL, &reg_save);
+	pci_write_config_byte(dev, ACPICTRL, reg_save | 0x10);
+	lpc_ich_acpi_save = reg_save;
+
+pm_done:
+	/* Setup GPIO base register */
+	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
+	base_addr = base_addr_cfg & 0x0000ff80;
+	if (!base_addr) {
+		dev_err(&dev->dev, "I/O space for GPIO uninitialized\n");
+		/* GPIO in power-management space may still be available */
+		goto gpio_reg;
+	}
+
+	gpio_ich_res[ICH_RES_GPIO].start = base_addr;
+	gpio_ich_res[ICH_RES_GPIO].end = base_addr + GPIOBASE_IO_SIZE - 1;
+	ret = acpi_check_resource_conflict(&gpio_ich_res[ICH_RES_GPIO]);
+	if (ret) {
+		/* this isn't necessarily fatal for the GPIO */
+		gpio_ich_res[ICH_RES_GPIO].start = 0;
+		gpio_ich_res[ICH_RES_GPIO].end = 0;
+		acpi_conflict = true;
+		goto gpio_reg;
+	}
+
+	/* Enable LPC GPIO space */
+	pci_read_config_byte(dev, GPIOCTRL, &reg_save);
+	pci_write_config_byte(dev, GPIOCTRL, reg_save | 0x10);
+	lpc_ich_gpio_save = reg_save;
+
+gpio_reg:
+	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_GPIO], id);
+	ret = mfd_add_devices(&dev->dev, 0, &lpc_ich_cells[LPC_GPIO],
+				1, NULL, 0);
+	if (!ret)
+		cell_added = true;
+
+	if (acpi_conflict)
+		dev_info(&dev->dev, "ACPI resource conflicts found; "
+				"consider using acpi_enforce_resources=lax?\n");
+
+	/*
+	 * We only care if at least one or none of the cells registered
+	 * successfully.
+	 */
+	return cell_added ? 0 : -ENODEV;
+}
+
+static void __devexit lpc_ich_remove(struct pci_dev *dev)
+{
+	mfd_remove_devices(&dev->dev);
+
+	if (lpc_ich_gpio_save > 0)
+		pci_write_config_byte(dev, GPIOCTRL, (u8)lpc_ich_gpio_save);
+	if (lpc_ich_acpi_save > 0)
+		pci_write_config_byte(dev, ACPICTRL, (u8)lpc_ich_acpi_save);
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
index 0000000..286c778
--- /dev/null
+++ b/include/linux/mfd/lpc_ich.h
@@ -0,0 +1,32 @@
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
+	char name[32];
+	unsigned int gpio_version;
+};
+
+#endif
-- 
1.7.0.4
