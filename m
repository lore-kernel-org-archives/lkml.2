Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab1KVLZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:25:50 -0500
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:53243 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751595Ab1KVLZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:25:49 -0500
Date: Tue, 22 Nov 2011 12:17:13 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: <wim@iguana.be>, Sebroeck@vger.kernel.org, Van@vger.kernel.org,
        Wim@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        <HaraldWelte@viatech.com>, Welte@vger.kernel.org,
        Harald@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 9563956760500488045
X-Ovh-Remote: 92.103.90.130 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrtddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenuc
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -230
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenuchlihhnuhigfeigucdlqdeftddmnehvohhiugdptghhrghrucdlqddutddtmdenvhhoihgupdhinhhtucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new driver for the hardware watchdog timer on VIA chipsets.
Tested on a Artigo A1100, VX855 chipset.

Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
---

 Kconfig   |   13 ++++
 Makefile  |    1 
 via_wdt.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+)

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
+++ linux-3.2-rc2/drivers/watchdog/via_wdt.c	2011-11-22 11:49:33.169408728 +0100
@@ -0,0 +1,176 @@
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
+#include <linux/fs.h>
+#include <linux/io.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+
+#define VIA_WDT_MB_OFFSET	0xe8	/* memory base offset */
+#define VIA_WDT_TRIGGER		0x80	/* start a new countdown */
+#define VIA_WDT_FIRED		0x02	/* set if last restart was caused
+					   by expired watchdog timer */
+
+static void *wdt_mem;			/* watchdog memory region address */
+static unsigned long open_lock;
+
+static unsigned int wdt_ping(void)
+{
+	unsigned int res = readl(wdt_mem);	/* get status bits */
+	writel(res | VIA_WDT_TRIGGER, wdt_mem);
+	return res;
+}
+
+static ssize_t wdt_write(struct file *file, const char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	if (count <= 0)
+		return 0;
+	wdt_ping();
+	return 1;
+}
+
+static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+	static struct watchdog_info ident = {
+		.options	= WDIOF_CARDRESET,
+		.identity	= "VIA Southbridge WDT",
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				   sizeof(ident)) ? -EFAULT : 0;
+		break;
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, (int __user *)arg);
+		break;
+	case WDIOC_GETBOOTSTATUS:
+		if (wdt_ping() & VIA_WDT_FIRED)
+			ret = put_user(WDIOF_CARDRESET, (int __user *)arg);
+		else
+			ret = put_user(0, (int __user *)arg);
+		break;
+	case WDIOC_KEEPALIVE:
+		wdt_ping();
+		ret = 0;
+		break;
+	default:
+		ret = -ENOTTY;
+	}
+	return ret;
+}
+
+static int wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &open_lock))
+		return -EBUSY;
+	return nonseekable_open(inode, file);
+}
+
+static int wdt_release(struct inode *inode, struct file *file)
+{
+	clear_bit(0, &open_lock);
+	return 0;
+}
+
+static const struct file_operations wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= wdt_open,
+	.release	= wdt_release,
+	.unlocked_ioctl	= wdt_ioctl,
+	.write		= wdt_write,
+};
+
+static struct miscdevice wdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &wdt_fops,
+};
+
+static int __devinit wdt_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *ent)
+{
+	unsigned int mmio = 0;
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
+	if (misc_register(&wdt_miscdev)) {
+		dev_err(&pdev->dev, "cannot register misc device\n");
+		iounmap(wdt_mem);
+		return -EIO;
+	}
+	if (wdt_ping() & VIA_WDT_FIRED)
+		dev_info(&pdev->dev "restarted by expired watchdog timer\n");
+	return 0;
+}
+
+static void __devexit wdt_remove(struct pci_dev *dev)
+{
+	misc_deregister(&wdt_miscdev);
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
+	if (pci_register_driver(&wdt_driver) || wdt_mem == NULL)
+		return -ENODEV;
+	return 0;
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
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_LICENSE("GPL");
--- linux-3.2-rc2/drivers/watchdog/Kconfig.orig	2011-11-15 18:02:59.000000000 +0100
+++ linux-3.2-rc2/drivers/watchdog/Kconfig	2011-11-18 18:13:36.595534599 +0100
@@ -779,6 +779,19 @@ config SMSC37B787_WDT
 
 	  Most people will say N.
 
+config VIA_WDT
+	tristate "VIA Watchdog Timer"
+	depends on X86
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
