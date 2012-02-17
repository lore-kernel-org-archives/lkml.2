Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2BQX27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:28:59 -0500
Received: from xes-mad.com ([216.165.139.218]:63397 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab2BQX2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:28:55 -0500
Date: Fri, 17 Feb 2012 17:28:40 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <guenter@roeck-us.net>
Cc: Peter Tyser <ptyser@xes-inc.com>, Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3 v4] watchdog: Convert iTCO_wdt driver to mfd model
Message-ID: <ccfb20b4-0bb1-43be-87a3-fafc59bac160@zimbra>
In-Reply-To: <fecb243e-ffa2-4360-a5c1-1bb780e513c3@zimbra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the iTCO_wdt driver to use the multi-function device
driver model. It uses resources discovered by the lpc_ich driver, so that
it no longer does its own PCI scanning.

The driver has also been modernized to use pr_info and the like.

Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/Kconfig                    |    3 +-
 drivers/mfd/lpc_ich.c                  |  193 ++++++++----
 drivers/watchdog/Kconfig               |    1 +
 drivers/watchdog/iTCO_vendor.h         |    6 +-
 drivers/watchdog/iTCO_vendor_support.c |   43 ++--
 drivers/watchdog/iTCO_wdt.c            |  557 +++++++-------------------------
 include/linux/mfd/lpc_ich.h            |    7 +
 7 files changed, 287 insertions(+), 523 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f581e59..428e0a2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -731,7 +731,8 @@ config LPC_ICH
 	help
 	  The LPC bridge function of the Intel ICH provides support for
 	  many functional units. This driver provides needed support for
-	  other drivers to control these functions, currently GPIO.
+	  other drivers to control these functions, currently GPIO and
+	  watchdog.
 
 config MFD_RDC321X
 	tristate "Support for RDC-R321x southbridge"
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 7cfcab4..f4ed57e 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -63,15 +63,43 @@
 #define ACPIBASE		0x40
 #define ACPIBASE_GPE_OFF	0x20
 #define ACPIBASE_GPE_END	0x2f
+#define ACPIBASE_SMI_OFF	0x30
+#define ACPIBASE_SMI_END	0x33
+#define ACPIBASE_TCO_OFF	0x60
+#define ACPIBASE_TCO_END	0x7f
 #define ACPICTRL		0x44
 
+#define ACPIBASE_GCS_OFF	0x3410
+#define ACPIBASE_GCS_END	0x3414
+
 #define GPIOBASE		0x48
 #define GPIOCTRL		0x4C
 #define GPIOBASE_IO_SIZE	0x80
 
+#define RCBABASE		0xf0
+
+#define wdt_io_res(i) wdt_res(0, i)
+#define wdt_mem_res(i) wdt_res(ICH_RES_MEM_OFF, i)
+#define wdt_res(b, i) (&wdt_ich_res[(b) + (i)])
+
 static int lpc_ich_acpi_save = -1;
 static int lpc_ich_gpio_save = -1;
 
+static struct resource wdt_ich_res[] = {
+	/* TCO */
+	{
+		.flags = IORESOURCE_IO,
+	},
+	/* SMI */
+	{
+		.flags = IORESOURCE_IO,
+	},
+	/* GCS */
+	{
+		.flags = IORESOURCE_MEM,
+	},
+};
+
 static struct resource gpio_ich_res[] = {
 	/* BASE */
 	{
@@ -84,10 +112,16 @@ static struct resource gpio_ich_res[] = {
 };
 
 enum lpc_cells {
-	LPC_GPIO = 0,
+	LPC_WDT = 0,
+	LPC_GPIO,
 };
 
 static struct mfd_cell lpc_ich_cells[] = {
+	[LPC_WDT] = {
+		.name = "iTCO_wdt",
+		.num_resources = ARRAY_SIZE(wdt_ich_res),
+		.resources = wdt_ich_res,
+	},
 	[LPC_GPIO] = {
 		.name = "gpio_ich",
 		.num_resources = ARRAY_SIZE(gpio_ich_res),
@@ -158,64 +192,64 @@ enum lpc_chipsets {
 };
 
 struct lpc_ich_info lpc_chipset_info[] __devinitdata = {
-	[LPC_ICH] = {"ICH",				0},
-	[LPC_ICH0] = {"ICH0",				0},
-	[LPC_ICH2] = {"ICH2",				0},
-	[LPC_ICH2M] = {"ICH2-M",			0},
-	[LPC_ICH3] = {"ICH3-S",				0},
-	[LPC_ICH3M] = {"ICH3-M",			0},
-	[LPC_ICH4] = {"ICH4",				0},
-	[LPC_ICH4M] = {"ICH4-M",			0},
-	[LPC_CICH] = {"C-ICH",				0},
-	[LPC_ICH5] = {"ICH5 or ICH5R",			0},
-	[LPC_6300ESB] = {"6300ESB",			0},
-	[LPC_ICH6] = {"ICH6 or ICH6R",			0x0601},
-	[LPC_ICH6M] = {"ICH6-M",			0x0601},
-	[LPC_ICH6W] = {"ICH6W or ICH6RW",		0x0601},
-	[LPC_631XESB] = {"631xESB/632xESB",		0x0601},
-	[LPC_ICH7] = {"ICH7 or ICH7R",			0x0701},
-	[LPC_ICH7DH] = {"ICH7DH",			0x0701},
-	[LPC_ICH7M] = {"ICH7-M or ICH7-U",		0x0701},
-	[LPC_ICH7MDH] = {"ICH7-M DH",			0x0701},
-	[LPC_NM10] = {"NM10",				0},
-	[LPC_ICH8] = {"ICH8 or ICH8R",			0x0701},
-	[LPC_ICH8DH] = {"ICH8DH",			0x0701},
-	[LPC_ICH8DO] = {"ICH8DO",			0x0701},
-	[LPC_ICH8M] = {"ICH8M",				0x0701},
-	[LPC_ICH8ME] = {"ICH8M-E",			0x0701},
-	[LPC_ICH9] = {"ICH9",				0x0801},
-	[LPC_ICH9R] = {"ICH9R",				0x0801},
-	[LPC_ICH9DH] = {"ICH9DH",			0x0801},
-	[LPC_ICH9DO] = {"ICH9DO",			0x0801},
-	[LPC_ICH9M] = {"ICH9M",				0x0801},
-	[LPC_ICH9ME] = {"ICH9M-E",			0x0801},
-	[LPC_ICH10] = {"ICH10",				0x0a11},
-	[LPC_ICH10R] = {"ICH10R",			0x0a11},
-	[LPC_ICH10D] = {"ICH10D",			0x0a01},
-	[LPC_ICH10DO] = {"ICH10DO",			0x0a01},
-	[LPC_PCH] = {"PCH Desktop Full Featured",	0x0501},
-	[LPC_PCHM] = {"PCH Mobile Full Featured",	0x0501},
-	[LPC_P55] = {"P55",				0x0501},
-	[LPC_PM55] = {"PM55",				0x0501},
-	[LPC_H55] = {"H55",				0x0501},
-	[LPC_QM57] = {"QM57",				0x0501},
-	[LPC_H57] = {"H57",				0x0501},
-	[LPC_HM55] = {"HM55",				0x0501},
-	[LPC_Q57] = {"Q57",				0x0501},
-	[LPC_HM57] = {"HM57",				0x0501},
-	[LPC_PCHMSFF] = {"PCH Mobile SFF Full Featured",0x0501},
-	[LPC_QS57] = {"QS57",				0x0501},
-	[LPC_3400] = {"3400",				0x0501},
-	[LPC_3420] = {"3420",				0x0501},
-	[LPC_3450] = {"3450",				0x0501},
-	[LPC_EP80579] = {"EP80579",			0},
-	[LPC_CPT] = {"Cougar Point",			0x0501},
-	[LPC_CPTD] = {"Cougar Point Desktop",		0x0501},
-	[LPC_CPTM] = {"Cougar Point Mobile",		0x0501},
-	[LPC_PBG] = {"Patsburg",			0},
-	[LPC_DH89XXCC] = {"DH89xxCC",			0},
-	[LPC_PPT] = {"Panther Point",			0},
-	[LPC_LPT] = {"Lynx Point",			0},
+	[LPC_ICH] = {"ICH",				1, 0},
+	[LPC_ICH0] = {"ICH0",				1, 0},
+	[LPC_ICH2] = {"ICH2",				1, 0},
+	[LPC_ICH2M] = {"ICH2-M",			1, 0},
+	[LPC_ICH3] = {"ICH3-S",				1, 0},
+	[LPC_ICH3M] = {"ICH3-M",			1, 0},
+	[LPC_ICH4] = {"ICH4",				1, 0},
+	[LPC_ICH4M] = {"ICH4-M",			1, 0},
+	[LPC_CICH] = {"C-ICH",				1, 0},
+	[LPC_ICH5] = {"ICH5 or ICH5R",			1, 0},
+	[LPC_6300ESB] = {"6300ESB",			1, 0},
+	[LPC_ICH6] = {"ICH6 or ICH6R",			2, 0x0601},
+	[LPC_ICH6M] = {"ICH6-M",			2, 0x0601},
+	[LPC_ICH6W] = {"ICH6W or ICH6RW",		2, 0x0601},
+	[LPC_631XESB] = {"631xESB/632xESB",		2, 0x0601},
+	[LPC_ICH7] = {"ICH7 or ICH7R",			2, 0x0701},
+	[LPC_ICH7DH] = {"ICH7DH",			2, 0x0701},
+	[LPC_ICH7M] = {"ICH7-M or ICH7-U",		2, 0x0701},
+	[LPC_ICH7MDH] = {"ICH7-M DH",			2, 0x0701},
+	[LPC_NM10] = {"NM10",				2, 0},
+	[LPC_ICH8] = {"ICH8 or ICH8R",			2, 0x0701},
+	[LPC_ICH8DH] = {"ICH8DH",			2, 0x0701},
+	[LPC_ICH8DO] = {"ICH8DO",			2, 0x0701},
+	[LPC_ICH8M] = {"ICH8M",				2, 0x0701},
+	[LPC_ICH8ME] = {"ICH8M-E",			2, 0x0701},
+	[LPC_ICH9] = {"ICH9",				2, 0x0801},
+	[LPC_ICH9R] = {"ICH9R",				2, 0x0801},
+	[LPC_ICH9DH] = {"ICH9DH",			2, 0x0801},
+	[LPC_ICH9DO] = {"ICH9DO",			2, 0x0801},
+	[LPC_ICH9M] = {"ICH9M",				2, 0x0801},
+	[LPC_ICH9ME] = {"ICH9M-E",			2, 0x0801},
+	[LPC_ICH10] = {"ICH10",				2, 0x0a11},
+	[LPC_ICH10R] = {"ICH10R",			2, 0x0a11},
+	[LPC_ICH10D] = {"ICH10D",			2, 0x0a01},
+	[LPC_ICH10DO] = {"ICH10DO",			2, 0x0a01},
+	[LPC_PCH] = {"PCH Desktop Full Featured",	2, 0x0501},
+	[LPC_PCHM] = {"PCH Mobile Full Featured",	2, 0x0501},
+	[LPC_P55] = {"P55",				2, 0x0501},
+	[LPC_PM55] = {"PM55",				2, 0x0501},
+	[LPC_H55] = {"H55",				2, 0x0501},
+	[LPC_QM57] = {"QM57",				2, 0x0501},
+	[LPC_H57] = {"H57",				2, 0x0501},
+	[LPC_HM55] = {"HM55",				2, 0x0501},
+	[LPC_Q57] = {"Q57",				2, 0x0501},
+	[LPC_HM57] = {"HM57",				2, 0x0501},
+	[LPC_PCHMSFF] = {"PCH Mobile SFF Full Featured",2, 0x0501},
+	[LPC_QS57] = {"QS57",				2, 0x0501},
+	[LPC_3400] = {"3400",				2, 0x0501},
+	[LPC_3420] = {"3420",				2, 0x0501},
+	[LPC_3450] = {"3450",				2, 0x0501},
+	[LPC_EP80579] = {"EP80579",			2, 0},
+	[LPC_CPT] = {"Cougar Point",			2, 0x0501},
+	[LPC_CPTD] = {"Cougar Point Desktop",		2, 0x0501},
+	[LPC_CPTM] = {"Cougar Point Mobile",		2, 0x0501},
+	[LPC_PBG] = {"Patsburg",			2, 0},
+	[LPC_DH89XXCC] = {"DH89xxCC",			2, 0},
+	[LPC_PPT] = {"Panther Point",			2, 0},
+	[LPC_LPT] = {"Lynx Point",			2, 0},
 };
 
 /*
@@ -440,11 +474,52 @@ static int __devinit lpc_ich_probe(struct pci_dev *dev,
 		acpi_conflict = true;
 	}
 
+	wdt_io_res(ICH_RES_IO_TCO)->start = base_addr + ACPIBASE_TCO_OFF;
+	wdt_io_res(ICH_RES_IO_TCO)->end = base_addr + ACPIBASE_TCO_END;
+	ret = acpi_check_resource_conflict(wdt_io_res(ICH_RES_IO_TCO));
+	if (ret) {
+		acpi_conflict = true;
+		goto pm_done;
+	}
+
+	wdt_io_res(ICH_RES_IO_SMI)->start = base_addr + ACPIBASE_SMI_OFF;
+	wdt_io_res(ICH_RES_IO_SMI)->end = base_addr + ACPIBASE_SMI_END;
+	ret = acpi_check_resource_conflict(wdt_io_res(ICH_RES_IO_SMI));
+	if (ret) {
+		acpi_conflict = true;
+		goto pm_done;
+	}
+
 	/* Enable LPC ACPI space */
 	pci_read_config_byte(dev, ACPICTRL, &reg_save);
 	pci_write_config_byte(dev, ACPICTRL, reg_save | 0x10);
 	lpc_ich_acpi_save = reg_save;
 
+	/*
+	 * Get the Memory-Mapped GCS register. To get access to it
+	 * we have to read RCBA from PCI Config space 0xf0 and use
+	 * it as base. GCS = RCBA + ICH6_GCS(0x3410).
+	 */
+	if (lpc_chipset_info[id->driver_data].iTCO_version == 2) {
+		pci_read_config_dword(dev, RCBABASE, &base_addr_cfg);
+		base_addr = base_addr_cfg & 0xffffc000;
+		if (base_addr_cfg & 1) {
+			wdt_mem_res(ICH_RES_MEM_GCS)->start = base_addr +
+				ACPIBASE_GCS_OFF;
+			wdt_mem_res(ICH_RES_MEM_GCS)->end = base_addr +
+				ACPIBASE_GCS_END;
+		} else {
+			pr_err("RCBA is disabled by hardware/BIOS, "
+					"device disabled\n");
+		}
+	}
+
+	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_WDT], id);
+	ret = mfd_add_devices(&dev->dev, 0, &lpc_ich_cells[LPC_WDT],
+				1, NULL, 0);
+	if (!ret)
+		cell_added = true;
+
 pm_done:
 	/* Setup GPIO base register */
 	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 877b107..c3a4d7f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -557,6 +557,7 @@ config INTEL_SCU_WATCHDOG
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
 	depends on (X86 || IA64) && PCI
+	select LPC_ICH
 	---help---
 	  Hardware driver for the intel TCO timer based watchdog devices.
 	  These drivers are included in the Intel 82801 I/O Controller
diff --git a/drivers/watchdog/iTCO_vendor.h b/drivers/watchdog/iTCO_vendor.h
index 9e27e64..3c57b45 100644
--- a/drivers/watchdog/iTCO_vendor.h
+++ b/drivers/watchdog/iTCO_vendor.h
@@ -1,8 +1,8 @@
 /* iTCO Vendor Specific Support hooks */
 #ifdef CONFIG_ITCO_VENDOR_SUPPORT
-extern void iTCO_vendor_pre_start(unsigned long, unsigned int);
-extern void iTCO_vendor_pre_stop(unsigned long);
-extern void iTCO_vendor_pre_keepalive(unsigned long, unsigned int);
+extern void iTCO_vendor_pre_start(struct resource *, unsigned int);
+extern void iTCO_vendor_pre_stop(struct resource *);
+extern void iTCO_vendor_pre_keepalive(struct resource *, unsigned int);
 extern void iTCO_vendor_pre_set_heartbeat(unsigned int);
 extern int iTCO_vendor_check_noreboot_on(void);
 #else
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index 481d1ad..3b80d6f 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -34,11 +34,6 @@
 
 #include "iTCO_vendor.h"
 
-/* iTCO defines */
-#define	SMI_EN		(acpibase + 0x30) /* SMI Control and Enable Register */
-#define	TCOBASE		(acpibase + 0x60) /* TCO base address */
-#define	TCO1_STS	(TCOBASE + 0x04)  /* TCO1 Status Register */
-
 /* List of vendor support modes */
 /* SuperMicro Pentium 3 Era 370SSE+-OEM1/P3TSSE */
 #define SUPERMICRO_OLD_BOARD	1
@@ -81,24 +76,24 @@ MODULE_PARM_DESC(vendorsupport, "iTCO vendor specific support mode, default="
  *	    20.6 seconds.
  */
 
-static void supermicro_old_pre_start(unsigned long acpibase)
+static void supermicro_old_pre_start(struct resource *smires)
 {
 	unsigned long val32;
 
 	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
-	val32 = inl(SMI_EN);
+	val32 = inl(smires->start);
 	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
-	outl(val32, SMI_EN);	/* Needed to activate watchdog */
+	outl(val32, smires->start);	/* Needed to activate watchdog */
 }
 
-static void supermicro_old_pre_stop(unsigned long acpibase)
+static void supermicro_old_pre_stop(struct resource *smires)
 {
 	unsigned long val32;
 
 	/* Bit 13: TCO_EN -> 1 = Enables the TCO logic to generate SMI# */
-	val32 = inl(SMI_EN);
+	val32 = inl(smires->start);
 	val32 |= 0x00002000;	/* Turn on SMI clearing watchdog */
-	outl(val32, SMI_EN);	/* Needed to deactivate watchdog */
+	outl(val32, smires->start);	/* Needed to deactivate watchdog */
 }
 
 /*
@@ -269,66 +264,66 @@ static void supermicro_new_pre_set_heartbeat(unsigned int heartbeat)
  *	Don't use this fix if you don't need to!!!
  */
 
-static void broken_bios_start(unsigned long acpibase)
+static void broken_bios_start(struct resource *smires)
 {
 	unsigned long val32;
 
-	val32 = inl(SMI_EN);
+	val32 = inl(smires->start);
 	/* Bit 13: TCO_EN     -> 0 = Disables TCO logic generating an SMI#
 	   Bit  0: GBL_SMI_EN -> 0 = No SMI# will be generated by ICH. */
 	val32 &= 0xffffdffe;
-	outl(val32, SMI_EN);
+	outl(val32, smires->start);
 }
 
-static void broken_bios_stop(unsigned long acpibase)
+static void broken_bios_stop(struct resource *smires)
 {
 	unsigned long val32;
 
-	val32 = inl(SMI_EN);
+	val32 = inl(smires->start);
 	/* Bit 13: TCO_EN     -> 1 = Enables TCO logic generating an SMI#
 	   Bit  0: GBL_SMI_EN -> 1 = Turn global SMI on again. */
 	val32 |= 0x00002001;
-	outl(val32, SMI_EN);
+	outl(val32, smires->start);
 }
 
 /*
  *	Generic Support Functions
  */
 
-void iTCO_vendor_pre_start(unsigned long acpibase,
+void iTCO_vendor_pre_start(struct resource *smires,
 			   unsigned int heartbeat)
 {
 	switch (vendorsupport) {
 	case SUPERMICRO_OLD_BOARD:
-		supermicro_old_pre_start(acpibase);
+		supermicro_old_pre_start(smires);
 		break;
 	case SUPERMICRO_NEW_BOARD:
 		supermicro_new_pre_start(heartbeat);
 		break;
 	case BROKEN_BIOS:
-		broken_bios_start(acpibase);
+		broken_bios_start(smires);
 		break;
 	}
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_start);
 
-void iTCO_vendor_pre_stop(unsigned long acpibase)
+void iTCO_vendor_pre_stop(struct resource *smires)
 {
 	switch (vendorsupport) {
 	case SUPERMICRO_OLD_BOARD:
-		supermicro_old_pre_stop(acpibase);
+		supermicro_old_pre_stop(smires);
 		break;
 	case SUPERMICRO_NEW_BOARD:
 		supermicro_new_pre_stop();
 		break;
 	case BROKEN_BIOS:
-		broken_bios_stop(acpibase);
+		broken_bios_stop(smires);
 		break;
 	}
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_stop);
 
-void iTCO_vendor_pre_keepalive(unsigned long acpibase, unsigned int heartbeat)
+void iTCO_vendor_pre_keepalive(struct resource *smires, unsigned int heartbeat)
 {
 	if (vendorsupport == SUPERMICRO_NEW_BOARD)
 		supermicro_new_pre_set_heartbeat(heartbeat);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index bdf401b..7bbf432 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -46,7 +46,7 @@
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
 #define DRV_VERSION	"1.07"
-#define PFX		DRV_NAME ": "
+#define pr_fmt(fmt) DRV_NAME ": " fmt
 
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
@@ -65,316 +65,16 @@
 #include <linux/spinlock.h>		/* For spin_lock/spin_unlock/... */
 #include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
 #include <linux/io.h>			/* For inb/outb/... */
+#include <linux/mfd/core.h>
+#include <linux/mfd/lpc_ich.h>
 
 #include "iTCO_vendor.h"
 
-/* TCO related info */
-enum iTCO_chipsets {
-	TCO_ICH = 0,	/* ICH */
-	TCO_ICH0,	/* ICH0 */
-	TCO_ICH2,	/* ICH2 */
-	TCO_ICH2M,	/* ICH2-M */
-	TCO_ICH3,	/* ICH3-S */
-	TCO_ICH3M,	/* ICH3-M */
-	TCO_ICH4,	/* ICH4 */
-	TCO_ICH4M,	/* ICH4-M */
-	TCO_CICH,	/* C-ICH */
-	TCO_ICH5,	/* ICH5 & ICH5R */
-	TCO_6300ESB,	/* 6300ESB */
-	TCO_ICH6,	/* ICH6 & ICH6R */
-	TCO_ICH6M,	/* ICH6-M */
-	TCO_ICH6W,	/* ICH6W & ICH6RW */
-	TCO_631XESB,	/* 631xESB/632xESB */
-	TCO_ICH7,	/* ICH7 & ICH7R */
-	TCO_ICH7DH,	/* ICH7DH */
-	TCO_ICH7M,	/* ICH7-M & ICH7-U */
-	TCO_ICH7MDH,	/* ICH7-M DH */
-	TCO_NM10,	/* NM10 */
-	TCO_ICH8,	/* ICH8 & ICH8R */
-	TCO_ICH8DH,	/* ICH8DH */
-	TCO_ICH8DO,	/* ICH8DO */
-	TCO_ICH8M,	/* ICH8M */
-	TCO_ICH8ME,	/* ICH8M-E */
-	TCO_ICH9,	/* ICH9 */
-	TCO_ICH9R,	/* ICH9R */
-	TCO_ICH9DH,	/* ICH9DH */
-	TCO_ICH9DO,	/* ICH9DO */
-	TCO_ICH9M,	/* ICH9M */
-	TCO_ICH9ME,	/* ICH9M-E */
-	TCO_ICH10,	/* ICH10 */
-	TCO_ICH10R,	/* ICH10R */
-	TCO_ICH10D,	/* ICH10D */
-	TCO_ICH10DO,	/* ICH10DO */
-	TCO_PCH,	/* PCH Desktop Full Featured */
-	TCO_PCHM,	/* PCH Mobile Full Featured */
-	TCO_P55,	/* P55 */
-	TCO_PM55,	/* PM55 */
-	TCO_H55,	/* H55 */
-	TCO_QM57,	/* QM57 */
-	TCO_H57,	/* H57 */
-	TCO_HM55,	/* HM55 */
-	TCO_Q57,	/* Q57 */
-	TCO_HM57,	/* HM57 */
-	TCO_PCHMSFF,	/* PCH Mobile SFF Full Featured */
-	TCO_QS57,	/* QS57 */
-	TCO_3400,	/* 3400 */
-	TCO_3420,	/* 3420 */
-	TCO_3450,	/* 3450 */
-	TCO_EP80579,	/* EP80579 */
-	TCO_CPT,	/* Cougar Point */
-	TCO_CPTD,	/* Cougar Point Desktop */
-	TCO_CPTM,	/* Cougar Point Mobile */
-	TCO_PBG,	/* Patsburg */
-	TCO_DH89XXCC,	/* DH89xxCC */
-	TCO_PPT,	/* Panther Point */
-	TCO_LPT,	/* Lynx Point */
-};
-
-static struct {
-	char *name;
-	unsigned int iTCO_version;
-} iTCO_chipset_info[] __devinitdata = {
-	{"ICH", 1},
-	{"ICH0", 1},
-	{"ICH2", 1},
-	{"ICH2-M", 1},
-	{"ICH3-S", 1},
-	{"ICH3-M", 1},
-	{"ICH4", 1},
-	{"ICH4-M", 1},
-	{"C-ICH", 1},
-	{"ICH5 or ICH5R", 1},
-	{"6300ESB", 1},
-	{"ICH6 or ICH6R", 2},
-	{"ICH6-M", 2},
-	{"ICH6W or ICH6RW", 2},
-	{"631xESB/632xESB", 2},
-	{"ICH7 or ICH7R", 2},
-	{"ICH7DH", 2},
-	{"ICH7-M or ICH7-U", 2},
-	{"ICH7-M DH", 2},
-	{"NM10", 2},
-	{"ICH8 or ICH8R", 2},
-	{"ICH8DH", 2},
-	{"ICH8DO", 2},
-	{"ICH8M", 2},
-	{"ICH8M-E", 2},
-	{"ICH9", 2},
-	{"ICH9R", 2},
-	{"ICH9DH", 2},
-	{"ICH9DO", 2},
-	{"ICH9M", 2},
-	{"ICH9M-E", 2},
-	{"ICH10", 2},
-	{"ICH10R", 2},
-	{"ICH10D", 2},
-	{"ICH10DO", 2},
-	{"PCH Desktop Full Featured", 2},
-	{"PCH Mobile Full Featured", 2},
-	{"P55", 2},
-	{"PM55", 2},
-	{"H55", 2},
-	{"QM57", 2},
-	{"H57", 2},
-	{"HM55", 2},
-	{"Q57", 2},
-	{"HM57", 2},
-	{"PCH Mobile SFF Full Featured", 2},
-	{"QS57", 2},
-	{"3400", 2},
-	{"3420", 2},
-	{"3450", 2},
-	{"EP80579", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point Desktop", 2},
-	{"Cougar Point Mobile", 2},
-	{"Patsburg", 2},
-	{"DH89xxCC", 2},
-	{"Panther Point", 2},
-	{"Lynx Point", 2},
-	{NULL, 0}
-};
-
-/*
- * This data only exists for exporting the supported PCI ids
- * via MODULE_DEVICE_TABLE.  We do not actually register a
- * pci_driver, because the I/O Controller Hub has also other
- * functions that probably will be registered by other drivers.
- */
-static DEFINE_PCI_DEVICE_TABLE(iTCO_wdt_pci_tbl) = {
-	{ PCI_VDEVICE(INTEL, 0x2410), TCO_ICH},
-	{ PCI_VDEVICE(INTEL, 0x2420), TCO_ICH0},
-	{ PCI_VDEVICE(INTEL, 0x2440), TCO_ICH2},
-	{ PCI_VDEVICE(INTEL, 0x244c), TCO_ICH2M},
-	{ PCI_VDEVICE(INTEL, 0x2480), TCO_ICH3},
-	{ PCI_VDEVICE(INTEL, 0x248c), TCO_ICH3M},
-	{ PCI_VDEVICE(INTEL, 0x24c0), TCO_ICH4},
-	{ PCI_VDEVICE(INTEL, 0x24cc), TCO_ICH4M},
-	{ PCI_VDEVICE(INTEL, 0x2450), TCO_CICH},
-	{ PCI_VDEVICE(INTEL, 0x24d0), TCO_ICH5},
-	{ PCI_VDEVICE(INTEL, 0x25a1), TCO_6300ESB},
-	{ PCI_VDEVICE(INTEL, 0x2640), TCO_ICH6},
-	{ PCI_VDEVICE(INTEL, 0x2641), TCO_ICH6M},
-	{ PCI_VDEVICE(INTEL, 0x2642), TCO_ICH6W},
-	{ PCI_VDEVICE(INTEL, 0x2670), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x2671), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x2672), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x2673), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x2674), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x2675), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x2676), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x2677), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x2678), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x2679), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x267a), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x267b), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x267c), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x267d), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x267e), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x267f), TCO_631XESB},
-	{ PCI_VDEVICE(INTEL, 0x27b8), TCO_ICH7},
-	{ PCI_VDEVICE(INTEL, 0x27b0), TCO_ICH7DH},
-	{ PCI_VDEVICE(INTEL, 0x27b9), TCO_ICH7M},
-	{ PCI_VDEVICE(INTEL, 0x27bd), TCO_ICH7MDH},
-	{ PCI_VDEVICE(INTEL, 0x27bc), TCO_NM10},
-	{ PCI_VDEVICE(INTEL, 0x2810), TCO_ICH8},
-	{ PCI_VDEVICE(INTEL, 0x2812), TCO_ICH8DH},
-	{ PCI_VDEVICE(INTEL, 0x2814), TCO_ICH8DO},
-	{ PCI_VDEVICE(INTEL, 0x2815), TCO_ICH8M},
-	{ PCI_VDEVICE(INTEL, 0x2811), TCO_ICH8ME},
-	{ PCI_VDEVICE(INTEL, 0x2918), TCO_ICH9},
-	{ PCI_VDEVICE(INTEL, 0x2916), TCO_ICH9R},
-	{ PCI_VDEVICE(INTEL, 0x2912), TCO_ICH9DH},
-	{ PCI_VDEVICE(INTEL, 0x2914), TCO_ICH9DO},
-	{ PCI_VDEVICE(INTEL, 0x2919), TCO_ICH9M},
-	{ PCI_VDEVICE(INTEL, 0x2917), TCO_ICH9ME},
-	{ PCI_VDEVICE(INTEL, 0x3a18), TCO_ICH10},
-	{ PCI_VDEVICE(INTEL, 0x3a16), TCO_ICH10R},
-	{ PCI_VDEVICE(INTEL, 0x3a1a), TCO_ICH10D},
-	{ PCI_VDEVICE(INTEL, 0x3a14), TCO_ICH10DO},
-	{ PCI_VDEVICE(INTEL, 0x3b00), TCO_PCH},
-	{ PCI_VDEVICE(INTEL, 0x3b01), TCO_PCHM},
-	{ PCI_VDEVICE(INTEL, 0x3b02), TCO_P55},
-	{ PCI_VDEVICE(INTEL, 0x3b03), TCO_PM55},
-	{ PCI_VDEVICE(INTEL, 0x3b06), TCO_H55},
-	{ PCI_VDEVICE(INTEL, 0x3b07), TCO_QM57},
-	{ PCI_VDEVICE(INTEL, 0x3b08), TCO_H57},
-	{ PCI_VDEVICE(INTEL, 0x3b09), TCO_HM55},
-	{ PCI_VDEVICE(INTEL, 0x3b0a), TCO_Q57},
-	{ PCI_VDEVICE(INTEL, 0x3b0b), TCO_HM57},
-	{ PCI_VDEVICE(INTEL, 0x3b0d), TCO_PCHMSFF},
-	{ PCI_VDEVICE(INTEL, 0x3b0f), TCO_QS57},
-	{ PCI_VDEVICE(INTEL, 0x3b12), TCO_3400},
-	{ PCI_VDEVICE(INTEL, 0x3b14), TCO_3420},
-	{ PCI_VDEVICE(INTEL, 0x3b16), TCO_3450},
-	{ PCI_VDEVICE(INTEL, 0x5031), TCO_EP80579},
-	{ PCI_VDEVICE(INTEL, 0x1c41), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c42), TCO_CPTD},
-	{ PCI_VDEVICE(INTEL, 0x1c43), TCO_CPTM},
-	{ PCI_VDEVICE(INTEL, 0x1c44), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c45), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c46), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c47), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c48), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c49), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c4a), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c4b), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c4c), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c4d), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c4e), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c4f), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c50), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c51), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c52), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c53), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c54), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c55), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c56), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c57), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c58), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c59), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c5a), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c5b), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c5c), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c5d), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c5e), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1c5f), TCO_CPT},
-	{ PCI_VDEVICE(INTEL, 0x1d40), TCO_PBG},
-	{ PCI_VDEVICE(INTEL, 0x1d41), TCO_PBG},
-	{ PCI_VDEVICE(INTEL, 0x2310), TCO_DH89XXCC},
-	{ PCI_VDEVICE(INTEL, 0x1e40), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e41), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e42), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e43), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e44), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e45), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e46), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e47), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e48), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e49), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e4a), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e4b), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e4c), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e4d), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e4e), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e4f), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e50), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e51), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e52), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e53), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e54), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e55), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e56), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e57), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e58), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e59), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e5a), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e5b), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e5c), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e5d), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e5e), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x1e5f), TCO_PPT},
-	{ PCI_VDEVICE(INTEL, 0x8c40), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c41), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c42), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c43), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c44), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c45), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c46), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c47), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c48), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c49), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c4a), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c4b), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c4c), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c4d), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c4e), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c4f), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c50), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c51), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c52), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c53), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c54), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c55), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c56), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c57), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c58), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c59), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c5a), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c5b), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c5c), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c5d), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c5e), TCO_LPT},
-	{ PCI_VDEVICE(INTEL, 0x8c5f), TCO_LPT},
-	{ 0, },			/* End of list */
-};
-MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
-
 /* Address definitions for the TCO */
 /* TCO base address */
-#define TCOBASE		(iTCO_wdt_private.ACPIBASE + 0x60)
+#define TCOBASE		(iTCO_wdt_private.tco_res->start)
 /* SMI Control and Enable Register */
-#define SMI_EN		(iTCO_wdt_private.ACPIBASE + 0x30)
+#define SMI_EN		(iTCO_wdt_private.smi_res->start)
 
 #define TCO_RLD		(TCOBASE + 0x00) /* TCO Timer Reload and Curr. Value */
 #define TCOv1_TMR	(TCOBASE + 0x01) /* TCOv1 Timer Initial Value	*/
@@ -392,19 +92,18 @@ static char expect_release;
 static struct {		/* this is private data for the iTCO_wdt device */
 	/* TCO version/generation */
 	unsigned int iTCO_version;
-	/* The device's ACPIBASE address (TCOBASE = ACPIBASE+0x60) */
-	unsigned long ACPIBASE;
+	struct resource *tco_res;
+	struct resource *smi_res;
+	struct resource *gcs_res;
 	/* NO_REBOOT flag is Memory-Mapped GCS register bit 5 (TCO version 2)*/
 	unsigned long __iomem *gcs;
 	/* the lock for io operations */
 	spinlock_t io_lock;
+	struct platform_device *dev;
 	/* the PCI-device */
 	struct pci_dev *pdev;
 } iTCO_wdt_private;
 
-/* the watchdog platform device */
-static struct platform_device *iTCO_wdt_platform_device;
-
 /* module parameters */
 #define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat */
 static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
@@ -484,12 +183,12 @@ static int iTCO_wdt_start(void)
 
 	spin_lock(&iTCO_wdt_private.io_lock);
 
-	iTCO_vendor_pre_start(iTCO_wdt_private.ACPIBASE, heartbeat);
+	iTCO_vendor_pre_start(iTCO_wdt_private.smi_res, heartbeat);
 
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
 		spin_unlock(&iTCO_wdt_private.io_lock);
-		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
+		pr_err("failed to reset NO_REBOOT flag, "
 					"reboot disabled by hardware/BIOS\n");
 		return -EIO;
 	}
@@ -519,7 +218,7 @@ static int iTCO_wdt_stop(void)
 
 	spin_lock(&iTCO_wdt_private.io_lock);
 
-	iTCO_vendor_pre_stop(iTCO_wdt_private.ACPIBASE);
+	iTCO_vendor_pre_stop(iTCO_wdt_private.smi_res);
 
 	/* Bit 11: TCO Timer Halt -> 1 = The TCO timer is disabled */
 	val = inw(TCO1_CNT);
@@ -541,7 +240,7 @@ static int iTCO_wdt_keepalive(void)
 {
 	spin_lock(&iTCO_wdt_private.io_lock);
 
-	iTCO_vendor_pre_keepalive(iTCO_wdt_private.ACPIBASE, heartbeat);
+	iTCO_vendor_pre_keepalive(iTCO_wdt_private.smi_res, heartbeat);
 
 	/* Reload the timer by writing to the TCO Timer Counter register */
 	if (iTCO_wdt_private.iTCO_version == 2)
@@ -661,8 +360,7 @@ static int iTCO_wdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		iTCO_wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		iTCO_wdt_keepalive();
 	}
 	clear_bit(0, &is_active);
@@ -787,88 +485,121 @@ static struct miscdevice iTCO_wdt_miscdev = {
  *	Init & exit routines
  */
 
-static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
-		const struct pci_device_id *ent, struct platform_device *dev)
+static void __devexit iTCO_wdt_cleanup(void)
+{
+	/* Stop the timer before we leave */
+	if (!nowayout)
+		iTCO_wdt_stop();
+
+	/* Deregister */
+	misc_deregister(&iTCO_wdt_miscdev);
+
+	/* release resources */
+	release_region(iTCO_wdt_private.tco_res->start,
+			resource_size(iTCO_wdt_private.tco_res));
+	release_region(iTCO_wdt_private.smi_res->start,
+			resource_size(iTCO_wdt_private.smi_res));
+	if (iTCO_wdt_private.iTCO_version == 2) {
+		iounmap(iTCO_wdt_private.gcs);
+		release_mem_region(iTCO_wdt_private.gcs_res->start,
+				resource_size(iTCO_wdt_private.gcs_res));
+	}
+
+	iTCO_wdt_private.tco_res = NULL;
+	iTCO_wdt_private.smi_res = NULL;
+	iTCO_wdt_private.gcs_res = NULL;
+	iTCO_wdt_private.gcs = NULL;
+}
+
+static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 {
-	int ret;
-	u32 base_address;
-	unsigned long RCBA;
+	int ret = -ENODEV;
 	unsigned long val32;
+	struct lpc_ich_info *ich_info = dev->dev.platform_data;
+
+	if (!ich_info)
+		goto out;
+
+	spin_lock_init(&iTCO_wdt_private.io_lock);
+
+	iTCO_wdt_private.tco_res =
+		platform_get_resource(dev, IORESOURCE_IO, ICH_RES_IO_TCO);
+	if (!iTCO_wdt_private.tco_res)
+		goto out;
+
+	iTCO_wdt_private.smi_res =
+		platform_get_resource(dev, IORESOURCE_IO, ICH_RES_IO_SMI);
+	if (!iTCO_wdt_private.smi_res)
+		goto out;
+
+	iTCO_wdt_private.iTCO_version = ich_info->iTCO_version;
+	iTCO_wdt_private.dev = dev;
+	iTCO_wdt_private.pdev = to_pci_dev(dev->dev.parent);
 
 	/*
-	 *      Find the ACPI/PM base I/O address which is the base
-	 *      for the TCO registers (TCOBASE=ACPIBASE + 0x60)
-	 *      ACPIBASE is bits [15:7] from 0x40-0x43
+	 * Get the Memory-Mapped GCS register, we need it for the
+	 * NO_REBOOT flag (TCO v2).
 	 */
-	pci_read_config_dword(pdev, 0x40, &base_address);
-	base_address &= 0x0000ff80;
-	if (base_address == 0x00000000) {
-		/* Something's wrong here, ACPIBASE has to be set */
-		printk(KERN_ERR PFX "failed to get TCOBASE address, "
-					"device disabled by hardware/BIOS\n");
-		return -ENODEV;
-	}
-	iTCO_wdt_private.iTCO_version =
-			iTCO_chipset_info[ent->driver_data].iTCO_version;
-	iTCO_wdt_private.ACPIBASE = base_address;
-	iTCO_wdt_private.pdev = pdev;
-
-	/* Get the Memory-Mapped GCS register, we need it for the
-	   NO_REBOOT flag (TCO v2). To get access to it you have to
-	   read RCBA from PCI Config space 0xf0 and use it as base.
-	   GCS = RCBA + ICH6_GCS(0x3410). */
 	if (iTCO_wdt_private.iTCO_version == 2) {
-		pci_read_config_dword(pdev, 0xf0, &base_address);
-		if ((base_address & 1) == 0) {
-			printk(KERN_ERR PFX "RCBA is disabled by hardware"
-						"/BIOS, device disabled\n");
-			ret = -ENODEV;
+		iTCO_wdt_private.gcs_res = platform_get_resource(dev,
+							IORESOURCE_MEM,
+							ICH_RES_MEM_GCS);
+
+		if (!iTCO_wdt_private.gcs_res)
+			goto out;
+
+		if (!request_mem_region(iTCO_wdt_private.gcs_res->start,
+			resource_size(iTCO_wdt_private.gcs_res), dev->name)) {
+			ret = -EBUSY;
 			goto out;
 		}
-		RCBA = base_address & 0xffffc000;
-		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410), 4);
+		iTCO_wdt_private.gcs = ioremap(iTCO_wdt_private.gcs_res->start,
+			resource_size(iTCO_wdt_private.gcs_res));
+		if (!iTCO_wdt_private.gcs) {
+			ret = -EIO;
+			goto unreg_gcs;
+		}
 	}
 
 	/* Check chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit() && iTCO_vendor_check_noreboot_on()) {
-		printk(KERN_INFO PFX "unable to reset NO_REBOOT flag, "
+		pr_info("unable to reset NO_REBOOT flag, "
 					"device disabled by hardware/BIOS\n");
 		ret = -ENODEV;	/* Cannot reset NO_REBOOT bit */
-		goto out_unmap;
+		goto unmap_gcs;
 	}
 
 	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
 	iTCO_wdt_set_NO_REBOOT_bit();
 
 	/* The TCO logic uses the TCO_EN bit in the SMI_EN register */
-	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
-		printk(KERN_ERR PFX
-			"I/O address 0x%04lx already in use, "
+	if (!request_region(iTCO_wdt_private.smi_res->start,
+			resource_size(iTCO_wdt_private.smi_res), dev->name)) {
+		pr_err("I/O address 0x%04llx already in use, "
 						"device disabled\n", SMI_EN);
-		ret = -EIO;
-		goto out_unmap;
+		ret = -EBUSY;
+		goto unmap_gcs;
 	}
 	if (turn_SMI_watchdog_clear_off >= iTCO_wdt_private.iTCO_version) {
-		/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
+		/*
+		 * Bit 13: TCO_EN -> 0
+		 * Disables TCO logic generating an SMI#
+		 */
 		val32 = inl(SMI_EN);
 		val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
 		outl(val32, SMI_EN);
 	}
 
-	/* The TCO I/O registers reside in a 32-byte range pointed to
-	   by the TCOBASE value */
-	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
-		printk(KERN_ERR PFX "I/O address 0x%04lx already in use "
-						"device disabled\n", TCOBASE);
-		ret = -EIO;
-		goto unreg_smi_en;
+	if (!request_region(iTCO_wdt_private.tco_res->start,
+			resource_size(iTCO_wdt_private.tco_res), dev->name)) {
+		pr_err("I/O address 0x%04llx already in use device disabled\n",
+				TCOBASE);
+		ret = -EBUSY;
+		goto unreg_smi;
 	}
 
-	printk(KERN_INFO PFX
-		"Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
-			iTCO_chipset_info[ent->driver_data].name,
-			iTCO_chipset_info[ent->driver_data].iTCO_version,
-			TCOBASE);
+	pr_info("Found a %s TCO device (Version=%d, TCOBASE=0x%04llx)\n",
+		ich_info->name, ich_info->iTCO_version, TCOBASE);
 
 	/* Clear out the (probably old) status */
 	outw(0x0008, TCO1_STS);	/* Clear the Time Out Status bit */
@@ -882,79 +613,46 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	   if not reset to the default */
 	if (iTCO_wdt_set_heartbeat(heartbeat)) {
 		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX
-			"timeout value out of range, using %d\n", heartbeat);
+		pr_info("timeout value out of range, using %d\n", heartbeat);
 	}
 
 	ret = misc_register(&iTCO_wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, ret);
-		goto unreg_region;
+		goto unreg_tco;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 							heartbeat, nowayout);
 
 	return 0;
 
-unreg_region:
-	release_region(TCOBASE, 0x20);
-unreg_smi_en:
-	release_region(SMI_EN, 4);
-out_unmap:
+unreg_tco:
+	release_region(iTCO_wdt_private.tco_res->start,
+			resource_size(iTCO_wdt_private.tco_res));
+unreg_smi:
+	release_region(iTCO_wdt_private.smi_res->start,
+			resource_size(iTCO_wdt_private.smi_res));
+unmap_gcs:
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
-out:
-	iTCO_wdt_private.ACPIBASE = 0;
-	return ret;
-}
-
-static void __devexit iTCO_wdt_cleanup(void)
-{
-	/* Stop the timer before we leave */
-	if (!nowayout)
-		iTCO_wdt_stop();
-
-	/* Deregister */
-	misc_deregister(&iTCO_wdt_miscdev);
-	release_region(TCOBASE, 0x20);
-	release_region(SMI_EN, 4);
+unreg_gcs:
 	if (iTCO_wdt_private.iTCO_version == 2)
-		iounmap(iTCO_wdt_private.gcs);
-	pci_dev_put(iTCO_wdt_private.pdev);
-	iTCO_wdt_private.ACPIBASE = 0;
-}
-
-static int __devinit iTCO_wdt_probe(struct platform_device *dev)
-{
-	int ret = -ENODEV;
-	int found = 0;
-	struct pci_dev *pdev = NULL;
-	const struct pci_device_id *ent;
-
-	spin_lock_init(&iTCO_wdt_private.io_lock);
-
-	for_each_pci_dev(pdev) {
-		ent = pci_match_id(iTCO_wdt_pci_tbl, pdev);
-		if (ent) {
-			found++;
-			ret = iTCO_wdt_init(pdev, ent, dev);
-			if (!ret)
-				break;
-		}
-	}
-
-	if (!found)
-		printk(KERN_INFO PFX "No device detected.\n");
+		release_mem_region(iTCO_wdt_private.gcs_res->start,
+				resource_size(iTCO_wdt_private.gcs_res));
+out:
+	iTCO_wdt_private.tco_res = NULL;
+	iTCO_wdt_private.smi_res = NULL;
+	iTCO_wdt_private.gcs_res = NULL;
+	iTCO_wdt_private.gcs = NULL;
 
 	return ret;
 }
 
 static int __devexit iTCO_wdt_remove(struct platform_device *dev)
 {
-	if (iTCO_wdt_private.ACPIBASE)
+	if (iTCO_wdt_private.tco_res || iTCO_wdt_private.smi_res)
 		iTCO_wdt_cleanup();
 
 	return 0;
@@ -979,32 +677,19 @@ static int __init iTCO_wdt_init_module(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "Intel TCO WatchDog Timer Driver v%s\n",
-		DRV_VERSION);
+	pr_info("Intel TCO WatchDog Timer Driver v%s\n", DRV_VERSION);
 
 	err = platform_driver_register(&iTCO_wdt_driver);
 	if (err)
 		return err;
 
-	iTCO_wdt_platform_device = platform_device_register_simple(DRV_NAME,
-								-1, NULL, 0);
-	if (IS_ERR(iTCO_wdt_platform_device)) {
-		err = PTR_ERR(iTCO_wdt_platform_device);
-		goto unreg_platform_driver;
-	}
-
 	return 0;
-
-unreg_platform_driver:
-	platform_driver_unregister(&iTCO_wdt_driver);
-	return err;
 }
 
 static void __exit iTCO_wdt_cleanup_module(void)
 {
-	platform_device_unregister(iTCO_wdt_platform_device);
 	platform_driver_unregister(&iTCO_wdt_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info("Watchdog Module Unloaded.\n");
 }
 
 module_init(iTCO_wdt_init_module);
diff --git a/include/linux/mfd/lpc_ich.h b/include/linux/mfd/lpc_ich.h
index 286c778..47d64e7 100644
--- a/include/linux/mfd/lpc_ich.h
+++ b/include/linux/mfd/lpc_ich.h
@@ -20,12 +20,19 @@
 #ifndef LPC_ICH_H
 #define LPC_ICH_H
 
+/* Watchdog resources */
+#define ICH_RES_IO_TCO	0
+#define ICH_RES_IO_SMI	1
+#define ICH_RES_MEM_OFF	2
+#define ICH_RES_MEM_GCS	0
+
 /* GPIO resources */
 #define ICH_RES_GPIO	0
 #define ICH_RES_GPE0	1
 
 struct lpc_ich_info {
 	char name[32];
+	unsigned int iTCO_version;
 	unsigned int gpio_version;
 };
 
-- 
1.7.0.4
