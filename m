Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab2BBXwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:52:03 -0500
Received: from xes-mad.com ([216.165.139.218]:47157 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab2BBXv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:51:59 -0500
X-Greylist: delayed 1584 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Feb 2012 18:51:54 EST
Date: Thu, 02 Feb 2012 17:29:26 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: guenter roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: [PATCH 3/3] watchdog: Convert iTCO_wdt driver to mfd model
Message-ID: <6a40ff07-658a-4581-8415-94744f899ce6@zimbra>
In-Reply-To: <1328220172.2261.162.camel@groeck-laptop>
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
---
 drivers/mfd/Kconfig                    |    3 +-
 drivers/mfd/lpc_ich.c                  |  297 ++++++++++-------
 drivers/watchdog/Kconfig               |    1 +
 drivers/watchdog/iTCO_vendor.h         |    6 +-
 drivers/watchdog/iTCO_vendor_support.c |   43 +--
 drivers/watchdog/iTCO_wdt.c            |  596 +++++---------------------------
 include/linux/mfd/lpc_ich.h            |    7 +
 7 files changed, 295 insertions(+), 658 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 18eca82..af42bb8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -643,7 +643,8 @@ config LPC_ICH
 	help
 	  The LPC bridge function of the Intel ICH provides support for
 	  many functional units. This driver provides needed support for
-	  other drivers to control these functions, currently GPIO.
+	  other drivers to control these functions, currently GPIO and
+	  watchdog.
 
 config MFD_RDC321X
 	tristate "Support for RDC-R321x southbridge"
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index a288c74..b45c0e1 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -47,14 +47,42 @@
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
 static u8 lpc_ich_acpi_save, lpc_ich_gpio_save;
 
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
@@ -68,6 +96,11 @@ static struct resource gpio_ich_res[] = {
 
 static struct mfd_cell lpc_ich_cells[] = {
 	{
+		.name = "iTCO_wdt",
+		.num_resources = ARRAY_SIZE(wdt_ich_res),
+		.resources = wdt_ich_res,
+	},
+	{
 		.name = "ich_gpio",
 		.num_resources = ARRAY_SIZE(gpio_ich_res),
 		.resources = gpio_ich_res,
@@ -196,123 +229,123 @@ enum lpc_chipsets {
 };
 
 struct lpc_ich_info lpc_chipset_info[] __devinitdata = {
-	{"ICH",					0},
-	{"ICH0",				0},
-	{"ICH2",				0},
-	{"ICH2-M",				0},
-	{"ICH3-S",				0},
-	{"ICH3-M",				0},
-	{"ICH4",				0},
-	{"ICH4-M",				0},
-	{"C-ICH",				0},
-	{"ICH5 or ICH5R",			0},
-	{"6300ESB",				0},
-	{"ICH6 or ICH6R",			0x0601},
-	{"ICH6-M",				0x0601},
-	{"ICH6W or ICH6RW",			0x0601},
-	{"631xESB/632xESB",			0x0601},
-	{"ICH7 or ICH7R",			0x0701},
-	{"ICH7DH",				0x0701},
-	{"ICH7-M or ICH7-U",			0x0701},
-	{"ICH7-M DH",				0x0701},
-	{"NM10",				0},
-	{"ICH8 or ICH8R",			0x0701},
-	{"ICH8DH",				0x0701},
-	{"ICH8DO",				0x0701},
-	{"ICH8M",				0x0701},
-	{"ICH8M-E",				0x0701},
-	{"ICH9",				0x0801},
-	{"ICH9R",				0x0801},
-	{"ICH9DH",				0x0801},
-	{"ICH9DO",				0x0801},
-	{"ICH9M",				0x0801},
-	{"ICH9M-E",				0x0801},
-	{"ICH10",				0x0a11},
-	{"ICH10R",				0x0a11},
-	{"ICH10D",				0x0a01},
-	{"ICH10DO",				0x0a01},
-	{"PCH Desktop Full Featured",		0x0501},
-	{"PCH Mobile Full Featured",		0x0501},
-	{"P55",					0x0501},
-	{"PM55",				0x0501},
-	{"H55",					0x0501},
-	{"QM57",				0x0501},
-	{"H57",					0x0501},
-	{"HM55",				0x0501},
-	{"Q57",					0x0501},
-	{"HM57",				0x0501},
-	{"PCH Mobile SFF Full Featured",	0x0501},
-	{"QS57",				0x0501},
-	{"3400",				0x0501},
-	{"3420",				0x0501},
-	{"3450",				0x0501},
-	{"EP80579",				0},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Cougar Point",			0x0501},
-	{"Patsburg",				0},
-	{"Patsburg",				0},
-	{"DH89xxCC",				0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
-	{"Panther Point",			0},
+	{"ICH",					1, 0},
+	{"ICH0",				1, 0},
+	{"ICH2",				1, 0},
+	{"ICH2-M",				1, 0},
+	{"ICH3-S",				1, 0},
+	{"ICH3-M",				1, 0},
+	{"ICH4",				1, 0},
+	{"ICH4-M",				1, 0},
+	{"C-ICH",				1, 0},
+	{"ICH5 or ICH5R",			1, 0},
+	{"6300ESB",				1, 0},
+	{"ICH6 or ICH6R",			2, 0x0601},
+	{"ICH6-M",				2, 0x0601},
+	{"ICH6W or ICH6RW",			2, 0x0601},
+	{"631xESB/632xESB",			2, 0x0601},
+	{"ICH7 or ICH7R",			2, 0x0701},
+	{"ICH7DH",				2, 0x0701},
+	{"ICH7-M or ICH7-U",			2, 0x0701},
+	{"ICH7-M DH",				2, 0x0701},
+	{"NM10",				2, 0},
+	{"ICH8 or ICH8R",			2, 0x0701},
+	{"ICH8DH",				2, 0x0701},
+	{"ICH8DO",				2, 0x0701},
+	{"ICH8M",				2, 0x0701},
+	{"ICH8M-E",				2, 0x0701},
+	{"ICH9",				2, 0x0801},
+	{"ICH9R",				2, 0x0801},
+	{"ICH9DH",				2, 0x0801},
+	{"ICH9DO",				2, 0x0801},
+	{"ICH9M",				2, 0x0801},
+	{"ICH9M-E",				2, 0x0801},
+	{"ICH10",				2, 0x0a11},
+	{"ICH10R",				2, 0x0a11},
+	{"ICH10D",				2, 0x0a01},
+	{"ICH10DO",				2, 0x0a01},
+	{"PCH Desktop Full Featured",		2, 0x0501},
+	{"PCH Mobile Full Featured",		2, 0x0501},
+	{"P55",					2, 0x0501},
+	{"PM55",				2, 0x0501},
+	{"H55",					2, 0x0501},
+	{"QM57",				2, 0x0501},
+	{"H57",					2, 0x0501},
+	{"HM55",				2, 0x0501},
+	{"Q57",					2, 0x0501},
+	{"HM57",				2, 0x0501},
+	{"PCH Mobile SFF Full Featured",	2, 0x0501},
+	{"QS57",				2, 0x0501},
+	{"3400",				2, 0x0501},
+	{"3420",				2, 0x0501},
+	{"3450",				2, 0x0501},
+	{"EP80579",				2, 0},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Cougar Point",			2, 0x0501},
+	{"Patsburg",				2, 0},
+	{"Patsburg",				2, 0},
+	{"DH89xxCC",				2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
+	{"Panther Point",			2, 0},
 	{NULL, 0}
 };
 EXPORT_SYMBOL(lpc_chipset_info);
@@ -469,6 +502,12 @@ static int __devinit lpc_ich_probe(struct pci_dev *dev,
 		return -ENODEV;
 	}
 
+	wdt_io_res(ICH_RES_IO_TCO)->start = base_addr + ACPIBASE_TCO_OFF;
+	wdt_io_res(ICH_RES_IO_TCO)->end = base_addr + ACPIBASE_TCO_END;
+
+	wdt_io_res(ICH_RES_IO_SMI)->start = base_addr + ACPIBASE_SMI_OFF;
+	wdt_io_res(ICH_RES_IO_SMI)->end = base_addr + ACPIBASE_SMI_END;
+
 	gpio_ich_res[ICH_RES_GPE0].start = base_addr + ACPIBASE_GPE_OFF;
 	gpio_ich_res[ICH_RES_GPE0].end = base_addr + ACPIBASE_GPE_END;
 
@@ -476,6 +515,25 @@ static int __devinit lpc_ich_probe(struct pci_dev *dev,
 	pci_read_config_byte(dev, ACPICTRL, &lpc_ich_acpi_save);
 	pci_write_config_byte(dev, ACPICTRL, lpc_ich_acpi_save | 0x10);
 
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
 	/* Setup GPIO base register */
 	pci_read_config_dword(dev, GPIOBASE, &base_addr_cfg);
 	base_addr = base_addr_cfg & 0x0000ff80;
@@ -491,8 +549,11 @@ static int __devinit lpc_ich_probe(struct pci_dev *dev,
 	pci_read_config_byte(dev, GPIOCTRL, &lpc_ich_gpio_save);
 	pci_write_config_byte(dev, GPIOCTRL, lpc_ich_gpio_save | 0x10);
 
-	for (i=0; i < ARRAY_SIZE(lpc_ich_cells); i++)
+	for (i=0; i < ARRAY_SIZE(lpc_ich_cells); i++) {
 		lpc_ich_cells[i].id = id->driver_data;
+		lpc_ich_cells[i].platform_data = dev;
+		lpc_ich_cells[i].pdata_size = sizeof(struct pci_dev);
+	}
 
 	return mfd_add_devices(&dev->dev, 0,
 			lpc_ich_cells, ARRAY_SIZE(lpc_ich_cells), NULL, 0);
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 21d816e..8ba1c65 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -545,6 +545,7 @@ config INTEL_SCU_WATCHDOG
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
index 5fd020d..86a790c 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -44,8 +44,8 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
-#define DRV_VERSION	"1.06"
-#define PFX		DRV_NAME ": "
+#define DRV_VERSION	"1.07"
+#define pr_fmt(fmt) DRV_NAME ": " fmt
 
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
@@ -64,254 +64,11 @@
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
-	TCO_CPT1,	/* Cougar Point */
-	TCO_CPT2,	/* Cougar Point Desktop */
-	TCO_CPT3,	/* Cougar Point Mobile */
-	TCO_CPT4,	/* Cougar Point */
-	TCO_CPT5,	/* Cougar Point */
-	TCO_CPT6,	/* Cougar Point */
-	TCO_CPT7,	/* Cougar Point */
-	TCO_CPT8,	/* Cougar Point */
-	TCO_CPT9,	/* Cougar Point */
-	TCO_CPT10,	/* Cougar Point */
-	TCO_CPT11,	/* Cougar Point */
-	TCO_CPT12,	/* Cougar Point */
-	TCO_CPT13,	/* Cougar Point */
-	TCO_CPT14,	/* Cougar Point */
-	TCO_CPT15,	/* Cougar Point */
-	TCO_CPT16,	/* Cougar Point */
-	TCO_CPT17,	/* Cougar Point */
-	TCO_CPT18,	/* Cougar Point */
-	TCO_CPT19,	/* Cougar Point */
-	TCO_CPT20,	/* Cougar Point */
-	TCO_CPT21,	/* Cougar Point */
-	TCO_CPT22,	/* Cougar Point */
-	TCO_CPT23,	/* Cougar Point */
-	TCO_CPT24,	/* Cougar Point */
-	TCO_CPT25,	/* Cougar Point */
-	TCO_CPT26,	/* Cougar Point */
-	TCO_CPT27,	/* Cougar Point */
-	TCO_CPT28,	/* Cougar Point */
-	TCO_CPT29,	/* Cougar Point */
-	TCO_CPT30,	/* Cougar Point */
-	TCO_CPT31,	/* Cougar Point */
-	TCO_PBG1,	/* Patsburg */
-	TCO_PBG2,	/* Patsburg */
-	TCO_DH89XXCC,	/* DH89xxCC */
-	TCO_PPT0,	/* Panther Point */
-	TCO_PPT1,	/* Panther Point */
-	TCO_PPT2,	/* Panther Point */
-	TCO_PPT3,	/* Panther Point */
-	TCO_PPT4,	/* Panther Point */
-	TCO_PPT5,	/* Panther Point */
-	TCO_PPT6,	/* Panther Point */
-	TCO_PPT7,	/* Panther Point */
-	TCO_PPT8,	/* Panther Point */
-	TCO_PPT9,	/* Panther Point */
-	TCO_PPT10,	/* Panther Point */
-	TCO_PPT11,	/* Panther Point */
-	TCO_PPT12,	/* Panther Point */
-	TCO_PPT13,	/* Panther Point */
-	TCO_PPT14,	/* Panther Point */
-	TCO_PPT15,	/* Panther Point */
-	TCO_PPT16,	/* Panther Point */
-	TCO_PPT17,	/* Panther Point */
-	TCO_PPT18,	/* Panther Point */
-	TCO_PPT19,	/* Panther Point */
-	TCO_PPT20,	/* Panther Point */
-	TCO_PPT21,	/* Panther Point */
-	TCO_PPT22,	/* Panther Point */
-	TCO_PPT23,	/* Panther Point */
-	TCO_PPT24,	/* Panther Point */
-	TCO_PPT25,	/* Panther Point */
-	TCO_PPT26,	/* Panther Point */
-	TCO_PPT27,	/* Panther Point */
-	TCO_PPT28,	/* Panther Point */
-	TCO_PPT29,	/* Panther Point */
-	TCO_PPT30,	/* Panther Point */
-	TCO_PPT31,	/* Panther Point */
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
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Cougar Point", 2},
-	{"Patsburg", 2},
-	{"Patsburg", 2},
-	{"DH89xxCC", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{"Panther Point", 2},
-	{NULL, 0}
-};
-
 #define ITCO_PCI_DEVICE(dev, data) \
 	.vendor = PCI_VENDOR_ID_INTEL,	\
 	.device = dev,			\
@@ -321,154 +78,11 @@ static struct {
 	.class_mask = 0,		\
 	.driver_data = data
 
-/*
- * This data only exists for exporting the supported PCI ids
- * via MODULE_DEVICE_TABLE.  We do not actually register a
- * pci_driver, because the I/O Controller Hub has also other
- * functions that probably will be registered by other drivers.
- */
-static DEFINE_PCI_DEVICE_TABLE(iTCO_wdt_pci_tbl) = {
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AA_0,	TCO_ICH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AB_0,	TCO_ICH0)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_0,	TCO_ICH2)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_10,	TCO_ICH2M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_0,	TCO_ICH3)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_12,	TCO_ICH3M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_0,	TCO_ICH4)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_12,	TCO_ICH4M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801E_0,		TCO_CICH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801EB_0,	TCO_ICH5)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB_1,		TCO_6300ESB)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0,		TCO_ICH6)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1,		TCO_ICH6M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2,		TCO_ICH6W)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2673,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2674,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2675,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2676,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2677,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2678,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x2679,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267a,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267b,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267c,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267d,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267e,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(0x267f,				TCO_631XESB)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_30,		TCO_ICH7DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31,		TCO_ICH7MDH)},
-	{ ITCO_PCI_DEVICE(0x27bc,				TCO_NM10)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME)},
-	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9)},
-	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,		TCO_ICH9DO)},
-	{ ITCO_PCI_DEVICE(0x2919,				TCO_ICH9M)},
-	{ ITCO_PCI_DEVICE(0x2917,				TCO_ICH9ME)},
-	{ ITCO_PCI_DEVICE(0x3a18,				TCO_ICH10)},
-	{ ITCO_PCI_DEVICE(0x3a16,				TCO_ICH10R)},
-	{ ITCO_PCI_DEVICE(0x3a1a,				TCO_ICH10D)},
-	{ ITCO_PCI_DEVICE(0x3a14,				TCO_ICH10DO)},
-	{ ITCO_PCI_DEVICE(0x3b00,				TCO_PCH)},
-	{ ITCO_PCI_DEVICE(0x3b01,				TCO_PCHM)},
-	{ ITCO_PCI_DEVICE(0x3b02,				TCO_P55)},
-	{ ITCO_PCI_DEVICE(0x3b03,				TCO_PM55)},
-	{ ITCO_PCI_DEVICE(0x3b06,				TCO_H55)},
-	{ ITCO_PCI_DEVICE(0x3b07,				TCO_QM57)},
-	{ ITCO_PCI_DEVICE(0x3b08,				TCO_H57)},
-	{ ITCO_PCI_DEVICE(0x3b09,				TCO_HM55)},
-	{ ITCO_PCI_DEVICE(0x3b0a,				TCO_Q57)},
-	{ ITCO_PCI_DEVICE(0x3b0b,				TCO_HM57)},
-	{ ITCO_PCI_DEVICE(0x3b0d,				TCO_PCHMSFF)},
-	{ ITCO_PCI_DEVICE(0x3b0f,				TCO_QS57)},
-	{ ITCO_PCI_DEVICE(0x3b12,				TCO_3400)},
-	{ ITCO_PCI_DEVICE(0x3b14,				TCO_3420)},
-	{ ITCO_PCI_DEVICE(0x3b16,				TCO_3450)},
-	{ ITCO_PCI_DEVICE(0x5031,				TCO_EP80579)},
-	{ ITCO_PCI_DEVICE(0x1c41,				TCO_CPT1)},
-	{ ITCO_PCI_DEVICE(0x1c42,				TCO_CPT2)},
-	{ ITCO_PCI_DEVICE(0x1c43,				TCO_CPT3)},
-	{ ITCO_PCI_DEVICE(0x1c44,				TCO_CPT4)},
-	{ ITCO_PCI_DEVICE(0x1c45,				TCO_CPT5)},
-	{ ITCO_PCI_DEVICE(0x1c46,				TCO_CPT6)},
-	{ ITCO_PCI_DEVICE(0x1c47,				TCO_CPT7)},
-	{ ITCO_PCI_DEVICE(0x1c48,				TCO_CPT8)},
-	{ ITCO_PCI_DEVICE(0x1c49,				TCO_CPT9)},
-	{ ITCO_PCI_DEVICE(0x1c4a,				TCO_CPT10)},
-	{ ITCO_PCI_DEVICE(0x1c4b,				TCO_CPT11)},
-	{ ITCO_PCI_DEVICE(0x1c4c,				TCO_CPT12)},
-	{ ITCO_PCI_DEVICE(0x1c4d,				TCO_CPT13)},
-	{ ITCO_PCI_DEVICE(0x1c4e,				TCO_CPT14)},
-	{ ITCO_PCI_DEVICE(0x1c4f,				TCO_CPT15)},
-	{ ITCO_PCI_DEVICE(0x1c50,				TCO_CPT16)},
-	{ ITCO_PCI_DEVICE(0x1c51,				TCO_CPT17)},
-	{ ITCO_PCI_DEVICE(0x1c52,				TCO_CPT18)},
-	{ ITCO_PCI_DEVICE(0x1c53,				TCO_CPT19)},
-	{ ITCO_PCI_DEVICE(0x1c54,				TCO_CPT20)},
-	{ ITCO_PCI_DEVICE(0x1c55,				TCO_CPT21)},
-	{ ITCO_PCI_DEVICE(0x1c56,				TCO_CPT22)},
-	{ ITCO_PCI_DEVICE(0x1c57,				TCO_CPT23)},
-	{ ITCO_PCI_DEVICE(0x1c58,				TCO_CPT24)},
-	{ ITCO_PCI_DEVICE(0x1c59,				TCO_CPT25)},
-	{ ITCO_PCI_DEVICE(0x1c5a,				TCO_CPT26)},
-	{ ITCO_PCI_DEVICE(0x1c5b,				TCO_CPT27)},
-	{ ITCO_PCI_DEVICE(0x1c5c,				TCO_CPT28)},
-	{ ITCO_PCI_DEVICE(0x1c5d,				TCO_CPT29)},
-	{ ITCO_PCI_DEVICE(0x1c5e,				TCO_CPT30)},
-	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
-	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG1)},
-	{ ITCO_PCI_DEVICE(0x1d41,				TCO_PBG2)},
-	{ ITCO_PCI_DEVICE(0x2310,				TCO_DH89XXCC)},
-	{ ITCO_PCI_DEVICE(0x1e40,				TCO_PPT0)},
-	{ ITCO_PCI_DEVICE(0x1e41,				TCO_PPT1)},
-	{ ITCO_PCI_DEVICE(0x1e42,				TCO_PPT2)},
-	{ ITCO_PCI_DEVICE(0x1e43,				TCO_PPT3)},
-	{ ITCO_PCI_DEVICE(0x1e44,				TCO_PPT4)},
-	{ ITCO_PCI_DEVICE(0x1e45,				TCO_PPT5)},
-	{ ITCO_PCI_DEVICE(0x1e46,				TCO_PPT6)},
-	{ ITCO_PCI_DEVICE(0x1e47,				TCO_PPT7)},
-	{ ITCO_PCI_DEVICE(0x1e48,				TCO_PPT8)},
-	{ ITCO_PCI_DEVICE(0x1e49,				TCO_PPT9)},
-	{ ITCO_PCI_DEVICE(0x1e4a,				TCO_PPT10)},
-	{ ITCO_PCI_DEVICE(0x1e4b,				TCO_PPT11)},
-	{ ITCO_PCI_DEVICE(0x1e4c,				TCO_PPT12)},
-	{ ITCO_PCI_DEVICE(0x1e4d,				TCO_PPT13)},
-	{ ITCO_PCI_DEVICE(0x1e4e,				TCO_PPT14)},
-	{ ITCO_PCI_DEVICE(0x1e4f,				TCO_PPT15)},
-	{ ITCO_PCI_DEVICE(0x1e50,				TCO_PPT16)},
-	{ ITCO_PCI_DEVICE(0x1e51,				TCO_PPT17)},
-	{ ITCO_PCI_DEVICE(0x1e52,				TCO_PPT18)},
-	{ ITCO_PCI_DEVICE(0x1e53,				TCO_PPT19)},
-	{ ITCO_PCI_DEVICE(0x1e54,				TCO_PPT20)},
-	{ ITCO_PCI_DEVICE(0x1e55,				TCO_PPT21)},
-	{ ITCO_PCI_DEVICE(0x1e56,				TCO_PPT22)},
-	{ ITCO_PCI_DEVICE(0x1e57,				TCO_PPT23)},
-	{ ITCO_PCI_DEVICE(0x1e58,				TCO_PPT24)},
-	{ ITCO_PCI_DEVICE(0x1e59,				TCO_PPT25)},
-	{ ITCO_PCI_DEVICE(0x1e5a,				TCO_PPT26)},
-	{ ITCO_PCI_DEVICE(0x1e5b,				TCO_PPT27)},
-	{ ITCO_PCI_DEVICE(0x1e5c,				TCO_PPT28)},
-	{ ITCO_PCI_DEVICE(0x1e5d,				TCO_PPT29)},
-	{ ITCO_PCI_DEVICE(0x1e5e,				TCO_PPT30)},
-	{ ITCO_PCI_DEVICE(0x1e5f,				TCO_PPT31)},
-	{ 0, },			/* End of list */
-};
-MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
-
 /* Address definitions for the TCO */
 /* TCO base address */
-#define TCOBASE		(iTCO_wdt_private.ACPIBASE + 0x60)
+#define TCOBASE		iTCO_wdt_private.tco_res->start
 /* SMI Control and Enable Register */
-#define SMI_EN		(iTCO_wdt_private.ACPIBASE + 0x30)
+#define SMI_EN		iTCO_wdt_private.smi_res->start
 
 #define TCO_RLD		(TCOBASE + 0x00) /* TCO Timer Reload and Curr. Value */
 #define TCOv1_TMR	(TCOBASE + 0x01) /* TCOv1 Timer Initial Value	*/
@@ -486,19 +100,18 @@ static char expect_release;
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
@@ -573,12 +186,12 @@ static int iTCO_wdt_start(void)
 
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
@@ -608,7 +221,7 @@ static int iTCO_wdt_stop(void)
 
 	spin_lock(&iTCO_wdt_private.io_lock);
 
-	iTCO_vendor_pre_stop(iTCO_wdt_private.ACPIBASE);
+	iTCO_vendor_pre_stop(iTCO_wdt_private.smi_res);
 
 	/* Bit 11: TCO Timer Halt -> 1 = The TCO timer is disabled */
 	val = inw(TCO1_CNT);
@@ -630,7 +243,7 @@ static int iTCO_wdt_keepalive(void)
 {
 	spin_lock(&iTCO_wdt_private.io_lock);
 
-	iTCO_vendor_pre_keepalive(iTCO_wdt_private.ACPIBASE, heartbeat);
+	iTCO_vendor_pre_keepalive(iTCO_wdt_private.smi_res, heartbeat);
 
 	/* Reload the timer by writing to the TCO Timer Counter register */
 	if (iTCO_wdt_private.iTCO_version == 2)
@@ -750,8 +363,7 @@ static int iTCO_wdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		iTCO_wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
+		pr_crit("Unexpected close, not stopping watchdog!\n");
 		iTCO_wdt_keepalive();
 	}
 	clear_bit(0, &is_active);
@@ -876,51 +488,67 @@ static struct miscdevice iTCO_wdt_miscdev = {
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
+	release_resource(iTCO_wdt_private.tco_res);
+	release_resource(iTCO_wdt_private.smi_res);
+	release_resource(iTCO_wdt_private.gcs_res);
+	if (iTCO_wdt_private.iTCO_version == 2)
+		iounmap(iTCO_wdt_private.gcs);
+	iTCO_wdt_private.tco_res = NULL;
+	iTCO_wdt_private.smi_res = NULL;
+	iTCO_wdt_private.gcs_res = NULL;
+}
+
+static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 {
-	int ret;
-	u32 base_address;
-	unsigned long RCBA;
+	int ret = -ENODEV;
 	unsigned long val32;
 
-	/*
-	 *      Find the ACPI/PM base I/O address which is the base
-	 *      for the TCO registers (TCOBASE=ACPIBASE + 0x60)
-	 *      ACPIBASE is bits [15:7] from 0x40-0x43
-	 */
-	pci_read_config_dword(pdev, 0x40, &base_address);
-	base_address &= 0x0000ff80;
-	if (base_address == 0x00000000) {
-		/* Something's wrong here, ACPIBASE has to be set */
-		printk(KERN_ERR PFX "failed to get TCOBASE address, "
-					"device disabled by hardware/BIOS\n");
-		return -ENODEV;
+	spin_lock_init(&iTCO_wdt_private.io_lock);
+
+	iTCO_wdt_private.tco_res =
+		platform_get_resource(dev, IORESOURCE_IO, ICH_RES_IO_TCO);
+
+	iTCO_wdt_private.smi_res =
+		platform_get_resource(dev, IORESOURCE_IO, ICH_RES_IO_SMI);
+
+	iTCO_wdt_private.gcs_res =
+		platform_get_resource(dev, IORESOURCE_MEM, ICH_RES_MEM_GCS);
+
+	if (!iTCO_wdt_private.tco_res || !iTCO_wdt_private.smi_res ||
+			!iTCO_wdt_private.gcs_res) {
+		pr_info("No device detected.\n");
+		return ret;
 	}
+
 	iTCO_wdt_private.iTCO_version =
-			iTCO_chipset_info[ent->driver_data].iTCO_version;
-	iTCO_wdt_private.ACPIBASE = base_address;
-	iTCO_wdt_private.pdev = pdev;
-
-	/* Get the Memory-Mapped GCS register, we need it for the
-	   NO_REBOOT flag (TCO v2). To get access to it you have to
-	   read RCBA from PCI Config space 0xf0 and use it as base.
-	   GCS = RCBA + ICH6_GCS(0x3410). */
+			lpc_chipset_info[dev->id].iTCO_version;
+	iTCO_wdt_private.dev = dev;
+	iTCO_wdt_private.pdev = dev->mfd_cell->platform_data;
+
+	/*
+	 * Get the Memory-Mapped GCS register, we need it for the
+	 * NO_REBOOT flag (TCO v2).
+	 */
 	if (iTCO_wdt_private.iTCO_version == 2) {
-		pci_read_config_dword(pdev, 0xf0, &base_address);
-		if ((base_address & 1) == 0) {
-			printk(KERN_ERR PFX "RCBA is disabled by hardware"
-						"/BIOS, device disabled\n");
-			ret = -ENODEV;
+		if (!request_mem_region(iTCO_wdt_private.gcs_res->start,
+			resource_size(iTCO_wdt_private.gcs_res), dev->name)) {
 			goto out;
 		}
-		RCBA = base_address & 0xffffc000;
-		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410), 4);
+		iTCO_wdt_private.gcs = ioremap(iTCO_wdt_private.gcs_res->start,
+			resource_size(iTCO_wdt_private.gcs_res));
 	}
 
 	/* Check chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit() && iTCO_vendor_check_noreboot_on()) {
-		printk(KERN_INFO PFX "unable to reset NO_REBOOT flag, "
+		pr_info("unable to reset NO_REBOOT flag, "
 					"device disabled by hardware/BIOS\n");
 		ret = -ENODEV;	/* Cannot reset NO_REBOOT bit */
 		goto out_unmap;
@@ -930,9 +558,9 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	iTCO_wdt_set_NO_REBOOT_bit();
 
 	/* The TCO logic uses the TCO_EN bit in the SMI_EN register */
-	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
-		printk(KERN_ERR PFX
-			"I/O address 0x%04lx already in use, "
+	if (!request_region(iTCO_wdt_private.smi_res->start,
+			resource_size(iTCO_wdt_private.smi_res), dev->name)) {
+		pr_err("I/O address 0x%04llx already in use, "
 						"device disabled\n", SMI_EN);
 		ret = -EIO;
 		goto out_unmap;
@@ -942,19 +570,17 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
 	outl(val32, SMI_EN);
 
-	/* The TCO I/O registers reside in a 32-byte range pointed to
-	   by the TCOBASE value */
-	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
-		printk(KERN_ERR PFX "I/O address 0x%04lx already in use "
-						"device disabled\n", TCOBASE);
+	if (!request_region(iTCO_wdt_private.tco_res->start,
+			resource_size(iTCO_wdt_private.tco_res), dev->name)) {
+		pr_err("I/O address 0x%04llx already in use device disabled\n",
+				TCOBASE);
 		ret = -EIO;
 		goto unreg_smi_en;
 	}
 
-	printk(KERN_INFO PFX
-		"Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
-			iTCO_chipset_info[ent->driver_data].name,
-			iTCO_chipset_info[ent->driver_data].iTCO_version,
+	pr_info("Found a %s TCO device (Version=%d, TCOBASE=0x%04llx)\n",
+			lpc_chipset_info[dev->id].name,
+			lpc_chipset_info[dev->id].iTCO_version,
 			TCOBASE);
 
 	/* Clear out the (probably old) status */
@@ -969,79 +595,38 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
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
 		goto unreg_region;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info("initialized. heartbeat=%d sec (nowayout=%d)\n",
 							heartbeat, nowayout);
 
 	return 0;
 
 unreg_region:
-	release_region(TCOBASE, 0x20);
+	release_resource(iTCO_wdt_private.tco_res);
 unreg_smi_en:
-	release_region(SMI_EN, 4);
+	release_resource(iTCO_wdt_private.tco_res);
 out_unmap:
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
 out:
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
-	if (iTCO_wdt_private.iTCO_version == 2)
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
+	iTCO_wdt_private.tco_res = NULL;
+	iTCO_wdt_private.smi_res = NULL;
 
 	return ret;
 }
 
 static int __devexit iTCO_wdt_remove(struct platform_device *dev)
 {
-	if (iTCO_wdt_private.ACPIBASE)
+	if (iTCO_wdt_private.tco_res || iTCO_wdt_private.smi_res)
 		iTCO_wdt_cleanup();
 
 	return 0;
@@ -1071,32 +656,19 @@ static int __init iTCO_wdt_init_module(void)
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
index 27a1c32..b6a3e82 100644
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
 	char *name;
+	unsigned int iTCO_version;
 	unsigned int gpio_version;
 };
 
-- 
1.7.0.4
