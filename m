Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1AGIX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:23:59 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:32920 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887Ab1AGIX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:23:58 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG9cJk1R8GAm/2dsb2JhbACkJHS8Rg2CaIJXBA
Date: Fri, 7 Jan 2011 09:23:55 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Mike Waychison <mikew@google.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Priyanka Gupta <priyankag@google.com>
Subject: Re: [PATCH 1/2] watchdog: Add support for sp5100 chipset TCO
Message-ID: <20110107082355.GD3801@infomag.iguana.be>
References: <1288054685-29107-1-git-send-email-mikew@google.com> <AANLkTik=eNbQoGaDLS_-8kZLFojK9P1Ge0QAEFc_cPtG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik=eNbQoGaDLS_-8kZLFojK9P1Ge0QAEFc_cPtG@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> Do you have any interest in picking these patches up?  I'd like to get
> this hardware functionality mainlined as it would allow us to get
> closer to testing upstream kernels on our hardware.

I allready cleaned both drivers up, but I had to send the feedback still.
Basically for both drivers, I did the following:
* Change reboot_notifier by a platform shutdown
* remove CONFIG_WATCHDOG_NOWAYOUT ifdef-ery (since that exists allready in watchdog.h)
* return -ENOTTY as default ioctl err-code
* make watchdog_info a static const struct
* some small cleanups

This gives below code. Could you please review it?

Thanks in advance,
Wim.
---------------------------------------------------------------
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 8a3aa2f..28511b1 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -418,6 +418,17 @@ config F71808E_WDT
 	  You can compile this driver directly into the kernel, or use
 	  it as a module.  The module will be called f71808e_wdt.
 
+config SP5100_TCO
+	tristate "AMD/ATI SP5100 TCO Timer/Watchdog"
+	depends on X86 && PCI
+	---help---
+	  Hardware watchdog driver for the AMD/ATI SP5100 chipset. The TCO
+	  (Total Cost of Ownership) timer is a watchdog timer that will reboot
+	  the machine after its expiration. The expiration time can be
+	  configured with the "heartbeat" parameter.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sp5100_tco.
 
 config GEODE_WDT
 	tristate "AMD Geode CS5535/CS5536 Watchdog"
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 4b0ef38..12e6c1e 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
 obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
 obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
 obj-$(CONFIG_F71808E_WDT) += f71808e_wdt.o
+obj-$(CONFIG_SP5100_TCO) += sp5100_tco.o
 obj-$(CONFIG_GEODE_WDT) += geodewdt.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
 obj-$(CONFIG_SBC_FITPC2_WATCHDOG) += sbc_fitpc2_wdt.o
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
new file mode 100644
index 0000000..33ebdf9
--- /dev/null
+++ b/drivers/watchdog/sp5100_tco.c
@@ -0,0 +1,480 @@
+/*
+ *	sp5100_tco :	TCO timer driver for sp5100 chipsets
+ *
+ *	(c) Copyright 2009 Google Inc., All Rights Reserved.
+ *
+ *	Based on i8xx_tco.c:
+ *	(c) Copyright 2000 kernel concepts <nils@kernelconcepts.de>, All Rights
+ *	Reserved.
+ *				http://www.kernelconcepts.de
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
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
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started"
+		" (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
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
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
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
+				if (get_user(c, data + i))
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
+	static const struct watchdog_info ident = {
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
+	case WDIOC_KEEPALIVE:
+		tco_timer_keepalive();
+		return 0;
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
+		return -ENOTTY;
+	}
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
+	ret = misc_register(&sp5100_tco_miscdev);
+	if (ret != 0) {
+		printk(KERN_ERR PFX "cannot register miscdev on minor="
+		       "%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
+		goto exit;
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

