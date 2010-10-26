Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0JZA6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:58:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:48854 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0JZA6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:58:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=bdJxAxteWL6OmP8G6RR1WXhGP8MM5arAD4UFP4VbY2xtqAOaNhrEfMSzHeHPJpijn
	mcNCPoqlQVWvzDs8ifxXg==
From: Mike Waychison <mikew@google.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH 2/2] watchdog: Add TCO support for nVidia chipsets
Date: Mon, 25 Oct 2010 17:58:05 -0700
Message-Id: <1288054685-29107-2-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288054685-29107-1-git-send-email-mikew@google.com>
References: <1288054685-29107-1-git-send-email-mikew@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for /dev/watchdog for boards using either the MCP51 or
MCP55 chipsets.  These are also known as the nForce 430 and nForce 550.  This
driver is likely to work on other chipsets as well, though those are the only
two that have been tested.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/watchdog/Kconfig  |   18 ++
 drivers/watchdog/Makefile |    1 +
 drivers/watchdog/nv_tco.c |  556 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/nv_tco.h |   64 +++++
 4 files changed, 639 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/nv_tco.c
 create mode 100644 drivers/watchdog/nv_tco.h

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index a1961c1..2d41a28 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -551,6 +551,24 @@ config ITCO_VENDOR_SUPPORT
 	  devices. At this moment we only have additional support for some
 	  SuperMicro Inc. motherboards.
 
+config NV_TCO
+	tristate "nVidia TCO Timer/Watchdog"
+	depends on X86 && PCI
+	---help---
+	  Hardware driver for the TCO timer built into the nVidia Hub family
+	  (such as the MCP51).  The TCO (Total Cost of Ownership) timer is a
+	  watchdog timer that will reboot the machine after its second
+	  expiration. The expiration time can be configured with the
+	  "heartbeat" parameter.
+
+	  On some motherboards the driver may fail to reset the chipset's
+	  NO_REBOOT flag which prevents the watchdog from rebooting the
+	  machine. If this is the case you will get a kernel message like
+	  "failed to reset NO_REBOOT flag, reboot disabled by hardware".
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called nv_tco.
+
 config SP5100_TCO
 	tristate "SP5100 TCO Timer/Watchdog"
 	depends on X86 && PCI
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 1db244d..2754d90 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o
 ifeq ($(CONFIG_ITCO_VENDOR_SUPPORT),y)
 obj-$(CONFIG_ITCO_WDT) += iTCO_vendor_support.o
 endif
+obj-$(CONFIG_NV_TCO) += nv_tco.o
 obj-$(CONFIG_SP5100_TCO) += sp5100_tco.o
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
 obj-$(CONFIG_IT87_WDT) += it87_wdt.o
diff --git a/drivers/watchdog/nv_tco.c b/drivers/watchdog/nv_tco.c
new file mode 100644
index 0000000..c5b8ce4
--- /dev/null
+++ b/drivers/watchdog/nv_tco.c
@@ -0,0 +1,556 @@
+/*
+ *	nv_tco 0.01:	TCO timer driver for NV chipsets
+ *
+ *	(c) Copyright 2005 Google Inc., All Rights Reserved.
+ *
+ *	Based off nv_tco.c:
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
+ *	(c) Copyright 2000	kernel concepts <nils@kernelconcepts.de>
+ *				developed for
+ *                              Jentro AG, Haar/Munich (Germany)
+ *
+ *	TCO timer driver for NV chipsets
+ *	based on softdog.c by Alan Cox <alan@redhat.com>
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
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include "nv_tco.h"
+
+/* Module and version information */
+#define TCO_VERSION "0.01"
+#define TCO_MODULE_NAME "NV_TCO"
+#define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
+#define PFX TCO_MODULE_NAME ": "
+
+/* internal variables */
+static unsigned int tcobase;
+static DEFINE_SPINLOCK(tco_lock);	/* Guards the hardware */
+static unsigned long timer_alive;
+static char tco_expect_close;
+static struct pci_dev *tco_pci;
+
+/* the watchdog platform device */
+static struct platform_device *nv_tco_platform_device;
+
+/* module parameters */
+#define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat (2<heartbeat<39) */
+static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<heartbeat<39, "
+			    "default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
+static int nowayout = 1;
+#else
+static int nowayout;
+#endif
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+			   "(default=CONFIG_WATCHDOG_NOWAYOUT)");
+
+/*
+ * Some TCO specific functions
+ */
+static inline unsigned char seconds_to_ticks(int seconds)
+{
+	/* the internal timer is stored as ticks which decrement
+	 * every 0.6 seconds */
+	return (seconds * 10) / 6;
+}
+
+static void tco_timer_start(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = inl(TCO_CNT(tcobase));
+	val &= ~TCO_CNT_TCOHALT;
+	outl(val, TCO_CNT(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static void tco_timer_stop(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = inl(TCO_CNT(tcobase));
+	val |= TCO_CNT_TCOHALT;
+	outl(val, TCO_CNT(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static void tco_timer_keepalive(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	outb(0x01, TCO_RLD(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static int tco_timer_set_heartbeat(int t)
+{
+	int ret = 0;
+	unsigned char tmrval;
+	unsigned long flags;
+	u8 val;
+
+	/*
+	 * note seconds_to_ticks(t) > t, so if t > 0x3f, so is
+	 * tmrval=seconds_to_ticks(t).  Check that the count in seconds isn't
+	 * out of range on it's own (to avoid overflow in tmrval).
+	 */
+	if (t < 0 || t > 0x3f)
+		return -EINVAL;
+	tmrval = seconds_to_ticks(t);
+
+	/* "Values of 0h-3h are ignored and should not be attempted" */
+	if (tmrval > 0x3f || tmrval < 0x04)
+		return -EINVAL;
+
+	/* Write new heartbeat to watchdog */
+	spin_lock_irqsave(&tco_lock, flags);
+	val = inb(TCO_TMR(tcobase));
+	val &= 0xc0;
+	val |= tmrval;
+	outb(val, TCO_TMR(tcobase));
+	val = inb(TCO_TMR(tcobase));
+
+	if ((val & 0x3f) != tmrval)
+		ret = -EINVAL;
+	spin_unlock_irqrestore(&tco_lock, flags);
+
+	if (ret)
+		return ret;
+
+	heartbeat = t;
+	return 0;
+}
+
+/*
+ *	/dev/watchdog handling
+ */
+
+static int nv_tco_open(struct inode *inode, struct file *file)
+{
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &timer_alive))
+		return -EBUSY;
+
+	/* Reload and activate timer */
+	tco_timer_keepalive();
+	tco_timer_start();
+	return nonseekable_open(inode, file);
+}
+
+static int nv_tco_release(struct inode *inode, struct file *file)
+{
+	/* Shut off the timer */
+	if (tco_expect_close == 42) {
+		tco_timer_stop();
+	} else {
+		printk(KERN_CRIT PFX "Unexpected close, not stopping "
+		       "watchdog!\n");
+		tco_timer_keepalive();
+	}
+	clear_bit(0, &timer_alive);
+	tco_expect_close = 0;
+	return 0;
+}
+
+static ssize_t nv_tco_write(struct file *file, const char __user *data,
+			    size_t len, loff_t *ppos)
+{
+	/* See if we got the magic character 'V' and reload the timer */
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/*
+			 * note: just in case someone wrote the magic character
+			 * five months ago...
+			 */
+			tco_expect_close = 0;
+
+			/*
+			 * scan to see whether or not we got the magic
+			 * character
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
+static long nv_tco_ioctl(struct file *file, unsigned int cmd,
+			 unsigned long arg)
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
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
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
+			tco_timer_keepalive();
+			tco_timer_start();
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
+static int nv_tco_notify_sys(struct notifier_block *this, unsigned long code,
+			     void *unused)
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
+ *	Kernel Interfaces
+ */
+
+static const struct file_operations nv_tco_fops = {
+	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
+	.write =		nv_tco_write,
+	.unlocked_ioctl =	nv_tco_ioctl,
+	.open =			nv_tco_open,
+	.release =		nv_tco_release,
+};
+
+static struct miscdevice nv_tco_miscdev = {
+	.minor =	WATCHDOG_MINOR,
+	.name =		"watchdog",
+	.fops =		&nv_tco_fops,
+};
+
+static struct notifier_block nv_tco_notifier = {
+	.notifier_call =	nv_tco_notify_sys,
+};
+
+/*
+ * Data for PCI driver interface
+ *
+ * This data only exists for exporting the supported
+ * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
+ * register a pci_driver, because someone else might one day
+ * want to register another driver on the same PCI id.
+ */
+static struct pci_device_id tco_pci_tbl[] = {
+	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SMBUS,
+	  PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS,
+	  PCI_ANY_ID, PCI_ANY_ID, },
+	{ 0, },			/* End of list */
+};
+MODULE_DEVICE_TABLE(pci, tco_pci_tbl);
+
+/*
+ *	Init & exit routines
+ */
+
+static unsigned char __init nv_tco_getdevice(void)
+{
+	struct pci_dev *dev = NULL;
+	u32 val;
+
+	/* Find the PCI device */
+	for_each_pci_dev(dev) {
+		if (pci_match_id(tco_pci_tbl, dev) != NULL) {
+			tco_pci = dev;
+			break;
+		}
+	}
+
+	if (!tco_pci)
+		return 0;
+
+	/* Find the base io port */
+	pci_read_config_dword(tco_pci, 0x64, &val);
+	val &= 0xffff;
+	if (val == 0x0001 || val == 0x0000) {
+		/* Something is wrong here, bar isn't setup */
+		printk(KERN_ERR PFX "failed to get tcobase address\n");
+		return 0;
+	}
+	val &= 0xff00;
+	tcobase = val + 0x40;
+
+	if (!request_region(tcobase, 0x10, "NV TCO")) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		       tcobase);
+		return 0;
+	}
+
+	/* Set a reasonable heartbeat before we stop the timer */
+	tco_timer_set_heartbeat(30);
+
+	/*
+	 * Stop the TCO before we change anything so we don't race with
+	 * a zeroed timer.
+	 */
+	tco_timer_keepalive();
+	tco_timer_stop();
+
+	/* Disable SMI caused by TCO */
+	if (!request_region(MCP51_SMI_EN(tcobase), 4, "NV TCO")) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		       MCP51_SMI_EN(tcobase));
+		goto out;
+	}
+	val = inl(MCP51_SMI_EN(tcobase));
+	val &= ~MCP51_SMI_EN_TCO;
+	outl(val, MCP51_SMI_EN(tcobase));
+	val = inl(MCP51_SMI_EN(tcobase));
+	release_region(MCP51_SMI_EN(tcobase), 4);
+	if (val & MCP51_SMI_EN_TCO) {
+		printk(KERN_ERR PFX "Could not disable SMI caused by TCO\n");
+		goto out;
+	}
+
+	/* Check chipset's NO_REBOOT bit */
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	val |= MCP51_SMBUS_SETUP_B_TCO_REBOOT;
+	pci_write_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, val);
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	if (!(val & MCP51_SMBUS_SETUP_B_TCO_REBOOT)) {
+		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot "
+		       "disabled by hardware\n");
+		goto out;
+	}
+
+	return 1;
+out:
+	release_region(tcobase, 0x10);
+	return 0;
+}
+
+static int __devinit nv_tco_init(struct platform_device *dev)
+{
+	int ret;
+
+	/* Check whether or not the hardware watchdog is there */
+	if (!nv_tco_getdevice())
+		return -ENODEV;
+
+	/* Check to see if last reboot was due to watchdog timeout */
+	printk(KERN_INFO PFX "Watchdog reboot %sdetected.\n",
+	       inl(TCO_STS(tcobase)) & TCO_STS_TCO2TO_STS ? "" : "not ");
+
+	/* Clear out the old status */
+	outl(TCO_STS_RESET, TCO_STS(tcobase));
+
+	/*
+	 * Check that the heartbeat value is within it's range.
+	 * If not, reset to the default.
+	 */
+	if (tco_timer_set_heartbeat(heartbeat)) {
+		heartbeat = WATCHDOG_HEARTBEAT;
+		tco_timer_set_heartbeat(heartbeat);
+		printk(KERN_INFO PFX "heartbeat value must be 2<heartbeat<39, "
+		       "using %d\n", heartbeat);
+	}
+
+	ret = register_reboot_notifier(&nv_tco_notifier);
+	if (ret != 0) {
+		printk(KERN_ERR PFX "cannot register reboot notifier "
+		       "(err=%d)\n", ret);
+		goto unreg_region;
+	}
+
+	ret = misc_register(&nv_tco_miscdev);
+	if (ret != 0) {
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d "
+		       "(err=%d)\n", WATCHDOG_MINOR, ret);
+		goto unreg_notifier;
+	}
+
+	clear_bit(0, &timer_alive);
+
+	tco_timer_stop();
+
+	printk(KERN_INFO PFX "initialized (0x%04x). heartbeat=%d sec "
+	       "(nowayout=%d)\n", tcobase, heartbeat, nowayout);
+
+	return 0;
+
+unreg_notifier:
+	unregister_reboot_notifier(&nv_tco_notifier);
+unreg_region:
+	release_region(tcobase, 0x10);
+	return ret;
+}
+
+static void __devexit nv_tco_cleanup(void)
+{
+	u32 val;
+
+	/* Stop the timer before we leave */
+	if (!nowayout)
+		tco_timer_stop();
+
+	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	val &= ~MCP51_SMBUS_SETUP_B_TCO_REBOOT;
+	pci_write_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, val);
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	if (val & MCP51_SMBUS_SETUP_B_TCO_REBOOT) {
+		printk(KERN_CRIT PFX "Couldn't unset REBOOT bit.  Machine may "
+		       "soon reset\n");
+	}
+
+	/* Deregister */
+	misc_deregister(&nv_tco_miscdev);
+	unregister_reboot_notifier(&nv_tco_notifier);
+	release_region(tcobase, 0x10);
+}
+
+static int __devexit nv_tco_remove(struct platform_device *dev)
+{
+	if (tcobase)
+		nv_tco_cleanup();
+
+	return 0;
+}
+
+static void nv_tco_shutdown(struct platform_device *dev)
+{
+	tco_timer_stop();
+}
+
+static struct platform_driver nv_tco_driver = {
+	.probe		= nv_tco_init,
+	.remove		= __devexit_p(nv_tco_remove),
+	.shutdown	= nv_tco_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= TCO_MODULE_NAME,
+	},
+};
+
+static int __init nv_tco_init_module(void)
+{
+	int err;
+
+	printk(KERN_INFO PFX "NV TCO WatchDog Timer Driver v%s\n",
+	       TCO_VERSION);
+
+	err = platform_driver_register(&nv_tco_driver);
+	if (err)
+		return err;
+
+	nv_tco_platform_device = platform_device_register_simple(
+					TCO_MODULE_NAME, -1, NULL, 0);
+	if (IS_ERR(nv_tco_platform_device)) {
+		err = PTR_ERR(nv_tco_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&nv_tco_driver);
+	return err;
+}
+
+static void __exit nv_tco_cleanup_module(void)
+{
+	platform_device_unregister(nv_tco_platform_device);
+	platform_driver_unregister(&nv_tco_driver);
+	printk(KERN_INFO PFX "NV TCO Watchdog Module Unloaded.\n");
+}
+
+module_init(nv_tco_init_module);
+module_exit(nv_tco_cleanup_module);
+
+MODULE_AUTHOR("Mike Waychison");
+MODULE_DESCRIPTION("TCO timer driver for NV chipsets");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/nv_tco.h b/drivers/watchdog/nv_tco.h
new file mode 100644
index 0000000..c2d1d04
--- /dev/null
+++ b/drivers/watchdog/nv_tco.h
@@ -0,0 +1,64 @@
+/*
+ *	nv_tco:	TCO timer driver for nVidia chipsets.
+ *
+ *	(c) Copyright 2005 Google Inc., All Rights Reserved.
+ *
+ *	Supported Chipsets:
+ *		- MCP51/MCP55
+ *
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
+ *	(c) Copyright 2000	kernel concepts <nils@kernelconcepts.de>
+ *				developed for
+ *                              Jentro AG, Haar/Munich (Germany)
+ *
+ *	TCO timer driver for NV chipsets
+ *	based on softdog.c by Alan Cox <alan@redhat.com>
+ */
+
+/*
+ * Some address definitions for the TCO
+ */
+
+#define TCO_RLD(base)	((base) + 0x00)	/* TCO Timer Reload and Current Value */
+#define TCO_TMR(base)	((base) + 0x01)	/* TCO Timer Initial Value	*/
+
+#define TCO_STS(base)	((base) + 0x04)	/* TCO Status Register		*/
+/*
+ * TCO Boot Status bit: set on TCO reset, reset by software or standby
+ * power-good (survives reboots), unfortunately this bit is never
+ * set.
+ */
+#  define TCO_STS_BOOT_STS	(1 << 9)
+/*
+ * first and 2nd timeout status bits, these also survive a warm boot,
+ * and they work, so we use them.
+ */
+#  define TCO_STS_TCO_INT_STS	(1 << 1)
+#  define TCO_STS_TCO2TO_STS	(1 << 10)
+#  define TCO_STS_RESET		(TCO_STS_BOOT_STS | TCO_STS_TCO2TO_STS | \
+				 TCO_STS_TCO_INT_STS)
+
+#define TCO_CNT(base)	((base) + 0x08)	/* TCO Control Register	*/
+#  define TCO_CNT_TCOHALT	(1 << 12)
+
+#define MCP51_SMBUS_SETUP_B 0xe8
+#  define MCP51_SMBUS_SETUP_B_TCO_REBOOT (1 << 25)
+
+/*
+ * The SMI_EN register is at the base io address + 0x04,
+ * while TCOBASE is + 0x40.
+ */
+#define MCP51_SMI_EN(base)	((base) - 0x40 + 0x04)
+#  define MCP51_SMI_EN_TCO	((1 << 4) | (1 << 5))
-- 
1.7.1

