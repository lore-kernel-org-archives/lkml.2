Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1KVRa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:30:57 -0500
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:34944 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754459Ab1KVRa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:30:56 -0500
Date: Tue, 22 Nov 2011 18:05:48 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: w.sang@pengutronix.de
Cc: Wim@vger.kernel.org, wim@iguana.be, Welte@vger.kernel.org,
        Van@vger.kernel.org, Sebroeck@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com, Harald@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
In-Reply-To: <20111122112212.GD2734@pengutronix.de>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15450724422772115238
X-Ovh-Remote: 92.103.90.130 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrtddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenuc
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -230
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucculddquddttddmnehlihhnuhigfeigucdlqdeftddmnehvohhiugdpihhnthculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <w.sang@pengutronix.de> wrote:

> On Tue, Nov 22, 2011 at 12:17:13PM +0100, Marc Vertes wrote:
> > Add a new driver for the hardware watchdog timer on VIA chipsets.
> > Tested on a Artigo A1100, VX855 chipset.
> > 
> > Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
>
> New watchdog drivers should use the framework. Have a look at
> Documentation/watchdog/convert_drivers_to_kernel_api.txt for a guide. It
> is mainly removing code, though.
>
Here it is:
---

Add a new driver for the hardware watchdog timer on VIA chipsets.
This driver uses the new watchdog framework.
Tested on a Artigo A1100, VX855 chipset.

Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
---

 Kconfig   |   14 ++++++
 Makefile  |    1 
 via_wdt.c |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+)

--- linux-3.2-rc2/drivers/watchdog/Makefile.orig	2011-11-15 18:02:59.000000000 +0100
+++ linux-3.2-rc2/drivers/watchdog/Makefile	2011-11-18 18:13:36.594534635 +0100
@@ -100,6 +100,7 @@ obj-$(CONFIG_SBC7240_WDT) += sbc7240_wdt
 obj-$(CONFIG_CPU5_WDT) += cpu5wdt.o
 obj-$(CONFIG_SMSC_SCH311X_WDT) += sch311x_wdt.o
 obj-$(CONFIG_SMSC37B787_WDT) += smsc37b787_wdt.o
+obj-$(CONFIG_VIA_WDT) += via_wdt.o
 obj-$(CONFIG_W83627HF_WDT) += w83627hf_wdt.o
 obj-$(CONFIG_W83697HF_WDT) += w83697hf_wdt.o
 obj-$(CONFIG_W83697UG_WDT) += w83697ug_wdt.o
--- linux-3.2-rc2/drivers/watchdog/via_wdt.c.orig	2011-11-18 18:14:45.358174874 +0100
+++ linux-3.2-rc2/drivers/watchdog/via_wdt.c	2011-11-22 17:20:05.531757353 +0100
@@ -0,0 +1,134 @@
+/*
+ * VIA Chipset Watchdog Driver
+ *
+ * Copyright (C) 2011 Sigfox
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Marc Vertes <marc.vertes@sigfox.com>
+ * Based on a preliminary version from Harald Welte <HaraldWelte@viatech.com>
+ *
+ * The only way to activate the watchdog timer or to set its period is
+ * through BIOS setup.
+ */
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/watchdog.h>
+
+#define VIA_WDT_MB_OFFSET	0xe8	/* memory base offset */
+#define VIA_WDT_TRIGGER		0x80	/* start a new countdown */
+#define VIA_WDT_FIRED		0x02	/* set if last restart was caused
+					   by expired watchdog timer */
+
+static int wdt_start(struct watchdog_device *wdev)
+{
+	/* Nothing to do. The watchdog can only be started by the BIOS. */
+	return 0;
+}
+
+static int wdt_stop(struct watchdog_device *wdev)
+{
+	/* Nothing to do. The watchdog can not be stopped. */
+	return 0;
+}
+
+static int wdt_ping(struct watchdog_device *wdev)
+{
+	void __iomem *wdt_mem = watchdog_get_drvdata(wdev);
+	unsigned int res = readl(wdt_mem);	/* get status bits */
+
+	writel(res | VIA_WDT_TRIGGER, wdt_mem);
+	return 0;
+}
+
+static struct watchdog_info wdt_info = {
+	.identity = "VIA watchdog",
+	.options  =  WDIOF_CARDRESET,
+};
+
+static struct watchdog_ops wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = wdt_start,
+	.stop  = wdt_stop,
+	.ping  = wdt_ping,
+};
+
+static struct watchdog_device wdt_dev = {
+	.info = &wdt_info,
+	.ops  = &wdt_ops,
+};
+
+static int __devinit wdt_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *ent)
+{
+	unsigned int mmio = 0;
+	void __iomem *wdt_mem;
+	int ret;
+
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "cannot enable PCI device\n");
+		return -ENODEV;
+	}
+	pci_read_config_dword(pdev, VIA_WDT_MB_OFFSET, &mmio);
+	dev_info(&pdev->dev, "VIA Chipset watchdog MMIO: %x\n", mmio);
+	if (mmio == 0) {
+		dev_err(&pdev->dev, "watchdog timer is not enabled in BIOS\n");
+		return -ENODEV;
+	}
+	wdt_mem = ioremap(mmio, 8);
+	if (wdt_mem == NULL) {
+		dev_err(&pdev->dev, "cannot remap VIA wdt mmio registers\n");
+		return -ENODEV;
+	}
+	ret = watchdog_register_device(&wdt_dev);
+	if (ret)
+		return ret;
+	watchdog_set_drvdata(&wdt_dev, wdt_mem);
+	if (readl(wdt_mem) & VIA_WDT_FIRED) {
+		wdt_dev.bootstatus |= WDIOF_CARDRESET;
+		dev_notice(&pdev->dev, "restarted by expired watchdog\n");
+	}
+	return 0;
+}
+
+static void __devexit wdt_remove(struct pci_dev *dev)
+{
+	void __iomem *wdt_mem = watchdog_get_drvdata(&wdt_dev);
+
+	watchdog_unregister_device(&wdt_dev);
+	iounmap(wdt_mem);
+}
+
+/*
+ * The driver has not been tested yet on CX700 and VX800.
+ */
+DEFINE_PCI_DEVICE_TABLE(wdt_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX800) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
+	{ 0 }
+};
+
+static struct pci_driver wdt_driver = {
+	.name		= "via_wdt",
+	.id_table	= wdt_pci_table,
+	.probe		= wdt_probe,
+	.remove		= __devexit_p(wdt_remove),
+};
+
+static int __init wdt_init(void)
+{
+	return pci_register_driver(&wdt_driver);
+}
+
+static void __exit wdt_exit(void)
+{
+	pci_unregister_driver(&wdt_driver);
+}
+
+module_init(wdt_init);
+module_exit(wdt_exit);
+
+MODULE_AUTHOR("Marc Vertes");
+MODULE_DESCRIPTION("Driver for watchdog timer on VIA chipset");
+MODULE_LICENSE("GPL");
--- linux-3.2-rc2/drivers/watchdog/Kconfig.orig	2011-11-15 18:02:59.000000000 +0100
+++ linux-3.2-rc2/drivers/watchdog/Kconfig	2011-11-22 16:39:38.175325620 +0100
@@ -779,6 +779,20 @@ config SMSC37B787_WDT
 
 	  Most people will say N.
 
+config VIA_WDT
+	tristate "VIA Watchdog Timer"
+	depends on X86
+	select WATCHDOG_CORE
+	---help---
+	This is the driver for the hardware watchdog timer on VIA
+	southbridge chipset CX700, VX800, VX855. Watchdog setup
+	in BIOS is required.
+
+	To compile this driver as a module, choose M here; the module
+	will be called via_wdt.
+
+	Most people will say N.
+
 config W83627HF_WDT
 	tristate "W83627HF/W83627DHG Watchdog Timer"
 	depends on X86
