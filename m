Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0JZA61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:58:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0JZA6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:58:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=FSCtZIY89PWb+8+On0xUFN79n8fCFah2pPl438ordroItgdxqEOKI07NLNDJBW65T
	OWh/+Q6MNmjRLDW2mxPSA==
From: Mike Waychison <mikew@google.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>,
        Priyanka Gupta <priyankag@google.com>
Subject: [PATCH 1/2] watchdog: Add support for sp5100 chipset TCO
Date: Mon, 25 Oct 2010 17:58:04 -0700
Message-Id: <1288054685-29107-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds /dev/watchdog support for the AMD sp5100 aka SB7x0 chipsets.

It follows the same conventions found in other /dev/watchdog drivers.

Signed-off-by: Priyanka Gupta <priyankag@google.com>
Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/watchdog/Kconfig      |   12 +
 drivers/watchdog/Makefile     |    1 +
 drivers/watchdog/sp5100_tco.c |  522 +++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/sp5100_tco.h |   41 ++++
 4 files changed, 576 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/sp5100_tco.c
 create mode 100644 drivers/watchdog/sp5100_tco.h

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 24efd8e..a1961c1 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -551,6 +551,18 @@ config ITCO_VENDOR_SUPPORT
 	  devices. At this moment we only have additional support for some
 	  SuperMicro Inc. motherboards.
 
+config SP5100_TCO
+	tristate "SP5100 TCO Timer/Watchdog"
+	depends on X86 && PCI
+	---help---
+	  Hardware watchdog driver for the AMD/ATI SP5100 chipset. The TCO
+	  (Total Cost of Ownership) timer is a watchdog timer that will reboot
+	  the machine after its expiration. The expiration time can be
+	  configured with the "heartbeat" parameter.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sp5100_tco.
+
 config IT8712F_WDT
 	tristate "IT8712F (Smart Guardian) Watchdog Timer"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 8374503..1db244d 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o
 ifeq ($(CONFIG_ITCO_VENDOR_SUPPORT),y)
 obj-$(CONFIG_ITCO_WDT) += iTCO_vendor_support.o
 endif
+obj-$(CONFIG_SP5100_TCO) += sp5100_tco.o
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
 obj-$(CONFIG_IT87_WDT) += it87_wdt.o
 obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
new file mode 100644
index 0000000..33ebdf9
--- /dev/null
+++ b/drivers/watchdog/sp5100_tco.c
@@ -0,0 +1,522 @@
+/*
+ *	sp5100_tco :	TCO timer driver for sp5100 chipsets
+ *
+ *	(c) Copyright 2009 Google Inc., All Rights Reserved.
+ *
+ *	Based on sp5100_tco.c:
+ *	(c) Copyright 2000 kernel concepts <nils@kernelconcepts.de>, All Rights
+ *	Reserved.
+ *				http://www.kernelconcepts.de
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither kernel concepts nor Nils Faerber admit liability nor provide
+ *	warranty for any of this software. This material is provided
+ *	"AS-IS" and at no charge.
+ *
+ *	See AMD Publication 43009 "AMD SB700/710/750 Register Reference Guide"
+ */
+
+/*
+ *	Includes, defines, variables, module parameters, ...
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include "sp5100_tco.h"
+
+/* Module and version information */
+#define TCO_VERSION "0.01"
+#define TCO_MODULE_NAME "SP5100 TCO timer"
+#define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
+#define PFX TCO_MODULE_NAME ": "
+
+/* internal variables */
+static void __iomem *tcobase;
+static unsigned int pm_iobase;
+static DEFINE_SPINLOCK(tco_lock);	/* Guards the hardware */
+static unsigned long timer_alive;
+static char tco_expect_close;
+static struct pci_dev *sp5100_tco_pci;
+
+/* the watchdog platform device */
+static struct platform_device *sp5100_tco_platform_device;
+
+/* module parameters */
+
+#define WATCHDOG_HEARTBEAT 60	/* 60 sec default heartbeat. */
+static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (default="
+		 __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
+static int nowayout = 1;
+#else
+static int nowayout;
+#endif
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started"
+		 " (default=CONFIG_WATCHDOG_NOWAYOUT)");
+
+/*
+ * Some TCO specific functions
+ */
+static void tco_timer_start(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val |= SP5100_WDT_START_STOP_BIT;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static void tco_timer_stop(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val &= ~SP5100_WDT_START_STOP_BIT;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static void tco_timer_keepalive(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val |= SP5100_WDT_TRIGGER_BIT;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static int tco_timer_set_heartbeat(int t)
+{
+	unsigned long flags;
+
+	if (t < 0 || t > 0xffff)
+		return -EINVAL;
+
+	/* Write new heartbeat to watchdog */
+	spin_lock_irqsave(&tco_lock, flags);
+	writel(t, SP5100_WDT_COUNT(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+
+	heartbeat = t;
+	return 0;
+}
+
+/*
+ *	/dev/watchdog handling
+ */
+
+static int sp5100_tco_open(struct inode *inode, struct file *file)
+{
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &timer_alive))
+		return -EBUSY;
+
+	/* Reload and activate timer */
+	tco_timer_start();
+	tco_timer_keepalive();
+	return nonseekable_open(inode, file);
+}
+
+static int sp5100_tco_release(struct inode *inode, struct file *file)
+{
+	/* Shut off the timer. */
+	if (tco_expect_close == 42) {
+		tco_timer_stop();
+	} else {
+		printk(KERN_CRIT PFX "Unexpected close, not stopping"
+		       " watchdog!\n");
+		tco_timer_keepalive();
+	}
+	clear_bit(0, &timer_alive);
+	tco_expect_close = 0;
+	return 0;
+}
+
+static ssize_t sp5100_tco_write(struct file *file, const char __user *data,
+				size_t len, loff_t *ppos)
+{
+	/* See if we got the magic character 'V' and reload the timer */
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/* note: just in case someone wrote the magic character
+			 * five months ago... */
+			tco_expect_close = 0;
+
+			/* scan to see whether or not we got the magic character
+			 */
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data+i))
+					return -EFAULT;
+				if (c == 'V')
+					tco_expect_close = 42;
+			}
+		}
+
+		/* someone wrote to us, we should reload the timer */
+		tco_timer_keepalive();
+	}
+	return len;
+}
+
+static long sp5100_tco_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	int new_options, retval = -EINVAL;
+	int new_heartbeat;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	static struct watchdog_info ident = {
+		.options =		WDIOF_SETTIMEOUT |
+					WDIOF_KEEPALIVEPING |
+					WDIOF_MAGICCLOSE,
+		.firmware_version =	0,
+		.identity =		TCO_MODULE_NAME,
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident,
+			sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		tco_timer_keepalive();
+		return 0;
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			tco_timer_stop();
+			retval = 0;
+		}
+		if (new_options & WDIOS_ENABLECARD) {
+			tco_timer_start();
+			tco_timer_keepalive();
+			retval = 0;
+		}
+		return retval;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+		if (tco_timer_set_heartbeat(new_heartbeat))
+			return -EINVAL;
+		tco_timer_keepalive();
+		/* Fall through */
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+/*
+ *	Notify system
+ */
+
+static int sp5100_tco_notify_sys(struct notifier_block *this,
+				 unsigned long code,
+				 void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT) {
+		/* Turn the WDT off */
+		tco_timer_stop();
+	}
+
+	return NOTIFY_DONE;
+}
+
+/*
+ * Kernel Interfaces
+ */
+
+static const struct file_operations sp5100_tco_fops = {
+	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
+	.write =		sp5100_tco_write,
+	.unlocked_ioctl =	sp5100_tco_ioctl,
+	.open =			sp5100_tco_open,
+	.release =		sp5100_tco_release,
+};
+
+static struct miscdevice sp5100_tco_miscdev = {
+	.minor =	WATCHDOG_MINOR,
+	.name =		"watchdog",
+	.fops =		&sp5100_tco_fops,
+};
+
+static struct notifier_block sp5100_tco_notifier = {
+	.notifier_call = sp5100_tco_notify_sys,
+};
+
+/*
+ * Data for PCI driver interface
+ *
+ * This data only exists for exporting the supported
+ * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
+ * register a pci_driver, because someone else might
+ * want to register another driver on the same PCI id.
+ */
+static struct pci_device_id sp5100_tco_pci_tbl[] = {
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS, PCI_ANY_ID,
+	  PCI_ANY_ID, },
+	{ 0, },			/* End of list */
+};
+MODULE_DEVICE_TABLE(pci, sp5100_tco_pci_tbl);
+
+/*
+ * Init & exit routines
+ */
+
+static unsigned char __devinit sp5100_tco_setupdevice(void)
+{
+	struct pci_dev *dev = NULL;
+	u32 val;
+
+	/* Match the PCI device */
+	for_each_pci_dev(dev) {
+		if (pci_match_id(sp5100_tco_pci_tbl, dev) != NULL) {
+			sp5100_tco_pci = dev;
+			break;
+		}
+	}
+
+	if (!sp5100_tco_pci)
+		return 0;
+
+	/* Request the IO ports used by this driver */
+	pm_iobase = SP5100_IO_PM_INDEX_REG;
+	if (!request_region(pm_iobase, SP5100_PM_IOPORTS_SIZE, "SP5100 TCO")) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+			pm_iobase);
+		goto exit;
+	}
+
+	/* Find the watchdog base address. */
+	outb(SP5100_PM_WATCHDOG_BASE3, SP5100_IO_PM_INDEX_REG);
+	val = inb(SP5100_IO_PM_DATA_REG);
+	outb(SP5100_PM_WATCHDOG_BASE2, SP5100_IO_PM_INDEX_REG);
+	val = val << 8 | inb(SP5100_IO_PM_DATA_REG);
+	outb(SP5100_PM_WATCHDOG_BASE1, SP5100_IO_PM_INDEX_REG);
+	val = val << 8 | inb(SP5100_IO_PM_DATA_REG);
+	outb(SP5100_PM_WATCHDOG_BASE0, SP5100_IO_PM_INDEX_REG);
+	/* Low three bits of BASE0 are reserved. */
+	val = val << 8 | (inb(SP5100_IO_PM_DATA_REG) & 0xf8);
+
+	tcobase = ioremap(val, SP5100_WDT_MEM_MAP_SIZE);
+	if (tcobase == 0) {
+		printk(KERN_ERR PFX "failed to get tcobase address\n");
+		goto unreg_region;
+	}
+
+	/* Enable watchdog decode bit */
+	pci_read_config_dword(sp5100_tco_pci,
+			      SP5100_PCI_WATCHDOG_MISC_REG,
+			      &val);
+
+	val |= SP5100_PCI_WATCHDOG_DECODE_EN;
+
+	pci_write_config_dword(sp5100_tco_pci,
+			       SP5100_PCI_WATCHDOG_MISC_REG,
+			       val);
+
+	/* Enable Watchdog timer and set the resolution to 1 sec. */
+	outb(SP5100_PM_WATCHDOG_CONTROL, SP5100_IO_PM_INDEX_REG);
+	val = inb(SP5100_IO_PM_DATA_REG);
+	val |= SP5100_PM_WATCHDOG_SECOND_RES;
+	val &= ~SP5100_PM_WATCHDOG_DISABLE;
+	outb(val, SP5100_IO_PM_DATA_REG);
+
+	/* Check that the watchdog action is set to reset the system. */
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val &= ~SP5100_PM_WATCHDOG_ACTION_RESET;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+
+	/* Set a reasonable heartbeat before we stop the timer */
+	tco_timer_set_heartbeat(heartbeat);
+
+	/*
+	 * Stop the TCO before we change anything so we don't race with
+	 * a zeroed timer.
+	 */
+	tco_timer_stop();
+
+	/* Done */
+	return 1;
+
+	iounmap(tcobase);
+unreg_region:
+	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
+exit:
+	return 0;
+}
+
+static int __devinit sp5100_tco_init(struct platform_device *dev)
+{
+	int ret;
+	u32 val;
+
+	/* Check whether or not the hardware watchdog is there. If found, then
+	 * set it up.
+	 */
+	if (!sp5100_tco_setupdevice())
+		return -ENODEV;
+
+	/* Check to see if last reboot was due to watchdog timeout */
+	printk(KERN_INFO PFX "Watchdog reboot %sdetected.\n",
+	       readl(SP5100_WDT_CONTROL(tcobase)) & SP5100_PM_WATCHDOG_FIRED ?
+		      "" : "not ");
+
+	/* Clear out the old status */
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val &= ~SP5100_PM_WATCHDOG_FIRED;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+
+	/*
+	 * Check that the heartbeat value is within it's range.
+	 * If not, reset to the default.
+	 */
+	if (tco_timer_set_heartbeat(heartbeat)) {
+		heartbeat = WATCHDOG_HEARTBEAT;
+		tco_timer_set_heartbeat(heartbeat);
+	}
+
+	ret = register_reboot_notifier(&sp5100_tco_notifier);
+	if (ret != 0) {
+		printk(KERN_ERR PFX "cannot register reboot notifier"
+		       " (err=%d)\n",
+			ret);
+		goto exit;
+	}
+
+	ret = misc_register(&sp5100_tco_miscdev);
+	if (ret != 0) {
+		printk(KERN_ERR PFX "cannot register miscdev on minor="
+		       "%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
+		goto unreg_notifier;
+	}
+
+	clear_bit(0, &timer_alive);
+
+	printk(KERN_INFO PFX "initialized (0x%p). heartbeat=%d sec"
+		" (nowayout=%d)\n",
+		tcobase, heartbeat, nowayout);
+
+	return 0;
+
+unreg_notifier:
+	unregister_reboot_notifier(&sp5100_tco_notifier);
+exit:
+	iounmap(tcobase);
+	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
+	return ret;
+}
+
+static void __devexit sp5100_tco_cleanup(void)
+{
+	/* Stop the timer before we leave */
+	if (!nowayout)
+		tco_timer_stop();
+
+	/* Deregister */
+	misc_deregister(&sp5100_tco_miscdev);
+	unregister_reboot_notifier(&sp5100_tco_notifier);
+	iounmap(tcobase);
+	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
+}
+
+static int __devexit sp5100_tco_remove(struct platform_device *dev)
+{
+	if (tcobase)
+		sp5100_tco_cleanup();
+	return 0;
+}
+
+static void sp5100_tco_shutdown(struct platform_device *dev)
+{
+	tco_timer_stop();
+}
+
+static struct platform_driver sp5100_tco_driver = {
+	.probe		= sp5100_tco_init,
+	.remove		= __devexit_p(sp5100_tco_remove),
+	.shutdown	= sp5100_tco_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= TCO_MODULE_NAME,
+	},
+};
+
+static int __init sp5100_tco_init_module(void)
+{
+	int err;
+
+	printk(KERN_INFO PFX "SP5100 TCO WatchDog Timer Driver v%s\n",
+	       TCO_VERSION);
+
+	err = platform_driver_register(&sp5100_tco_driver);
+	if (err)
+		return err;
+
+	sp5100_tco_platform_device = platform_device_register_simple(
+					TCO_MODULE_NAME, -1, NULL, 0);
+	if (IS_ERR(sp5100_tco_platform_device)) {
+		err = PTR_ERR(sp5100_tco_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&sp5100_tco_driver);
+	return err;
+}
+
+static void __exit sp5100_tco_cleanup_module(void)
+{
+	platform_device_unregister(sp5100_tco_platform_device);
+	platform_driver_unregister(&sp5100_tco_driver);
+	printk(KERN_INFO PFX "SP5100 TCO Watchdog Module Unloaded.\n");
+}
+
+module_init(sp5100_tco_init_module);
+module_exit(sp5100_tco_cleanup_module);
+
+MODULE_AUTHOR("Priyanka Gupta");
+MODULE_DESCRIPTION("TCO timer driver for SP5100 chipset");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/sp5100_tco.h b/drivers/watchdog/sp5100_tco.h
new file mode 100644
index 0000000..a5a16cc
--- /dev/null
+++ b/drivers/watchdog/sp5100_tco.h
@@ -0,0 +1,41 @@
+/*
+ *	sp5100_tco:	TCO timer driver for sp5100 chipsets.
+ *
+ *	(c) Copyright 2009 Google Inc., All Rights Reserved.
+ *
+ *	TCO timer driver for sp5100 chipsets
+ */
+
+/*
+ * Some address definitions for the Watchdog
+ */
+
+#define SP5100_WDT_MEM_MAP_SIZE		0x08
+#define SP5100_WDT_CONTROL(base)	((base) + 0x00) /* Watchdog Control */
+#define SP5100_WDT_COUNT(base)		((base) + 0x04) /* Watchdog Count */
+
+#define SP5100_WDT_START_STOP_BIT	1
+#define SP5100_WDT_TRIGGER_BIT		(1 << 7)
+
+#define SP5100_PCI_WATCHDOG_MISC_REG	0x41
+#define SP5100_PCI_WATCHDOG_DECODE_EN	(1 << 3)
+
+#define SP5100_PM_IOPORTS_SIZE		0x02
+
+/* These two IO registers are hardcoded and there doesn't seem to be a way to
+ * read them from a register.
+ */
+#define SP5100_IO_PM_INDEX_REG		0xCD6
+#define SP5100_IO_PM_DATA_REG		0xCD7
+
+#define SP5100_PM_WATCHDOG_CONTROL	0x69
+#define SP5100_PM_WATCHDOG_BASE0	0x6C
+#define SP5100_PM_WATCHDOG_BASE1	0x6D
+#define SP5100_PM_WATCHDOG_BASE2	0x6E
+#define SP5100_PM_WATCHDOG_BASE3	0x6F
+
+#define SP5100_PM_WATCHDOG_FIRED	(1 << 1)
+#define SP5100_PM_WATCHDOG_ACTION_RESET	(1 << 2)
+
+#define SP5100_PM_WATCHDOG_DISABLE	1
+#define SP5100_PM_WATCHDOG_SECOND_RES	(3 << 1)
-- 
1.7.1

