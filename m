Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1KWVtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:49:32 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:17155 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1KWVta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:49:30 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAH5pzU5tg6zW/2dsb2JhbAA7CapygQaBcgEBBAEnExwjBQsIA0YUJQMhE4gFArRZEocdgzMElEeSDA
Date: Wed, 23 Nov 2011 22:46:14 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: broonie@opensource.wolfsonmicro.com, w.sang@pengutronix.de,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111123214614.GQ23376@infomag.iguana.be>
References: <20111122112212.GD2734@pengutronix.de> <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com> <20111122173227.GK6624@sirena.org.uk> <20111122184051.GA30941@pengutronix.de> <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com> <20111123104926.GB4063@pengutronix.de> <20111123121329.GM23376@infomag.iguana.be> <20111123122018.GA12227@opensource.wolfsonmicro.com> <20111123124037.GN23376@infomag.iguana.be> <4ecd075d.2YyTTCA13zxwZmwT%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ecd075d.2YyTTCA13zxwZmwT%marc.vertes@sigfox.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> The watchdog can not be started and stopped from the driver. This is
> what I investigated first and found impossible (and explains why this
> driver is still missing).
> 
> I do not fully understand yet what has to be done with the timer.

I adapted my example on to your diff and below the result.
Can you test it? Could you also add some comments about the issues
with the datasheet as proposed earlier?

Kind regards,
wim.
-----------------------------------------------------------------------
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79fd606..f602e90 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -772,6 +772,20 @@ config SMSC37B787_WDT
 
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
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index fe893e9..e8f479a 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_SBC7240_WDT) += sbc7240_wdt.o
 obj-$(CONFIG_CPU5_WDT) += cpu5wdt.o
 obj-$(CONFIG_SMSC_SCH311X_WDT) += sch311x_wdt.o
 obj-$(CONFIG_SMSC37B787_WDT) += smsc37b787_wdt.o
+obj-$(CONFIG_VIA_WDT) += via_wdt.o
 obj-$(CONFIG_W83627HF_WDT) += w83627hf_wdt.o
 obj-$(CONFIG_W83697HF_WDT) += w83697hf_wdt.o
 obj-$(CONFIG_W83697UG_WDT) += w83697ug_wdt.o
--- /dev/null	2009-12-15 19:54:05.376338696 +0100
+++ ./drivers/watchdog/via_wdt.c	2011-11-23 22:34:24.000000000 +0100
@@ -0,0 +1,208 @@
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
+#include <linux/jiffies.h>
+#include <linux/timer.h>
+
+#define VIA_WDT_MB_OFFSET	0xe8	/* memory base offset */
+#define VIA_WDT_TRIGGER		0x80	/* start a new countdown */
+#define VIA_WDT_FIRED		0x02	/* set if last restart was caused
+					   by expired watchdog timer */
+
+/* Hardware heartbeat in seconds */
+#define WDT_HW_HEARTBEAT 1
+
+/* Timer heartbeat (500ms) */
+#define WDT_HEARTBEAT	(HZ/2)	/* should be <= ((WDT_HW_HEARTBEAT*HZ)/2) */
+
+/* User space timeout */
+#define WDT_TIMEOUT 15
+static int timeout = WDT_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
+	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
+
+static struct watchdog_device wdt_dev;
+static void wdt_timer_tick(unsigned long data);
+static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
+					/* The timer that pings the watchdog */
+static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
+
+static inline void wdt_reset(void)
+{
+	void __iomem *wdt_mem = watchdog_get_drvdata(&wdt_dev);
+	unsigned int res = readl(wdt_mem);	/* get status bits */
+
+	writel(res | VIA_WDT_TRIGGER, wdt_mem);
+}
+
+/*
+ * Timer tick: the timer will make sure that the watchdog timer hardware
+ * is being reset in time. The conditions to do this are:
+ *  1) the watchog timer has been started and /dev/watchdog is open
+ *     and there is still time left before userspace should send the
+ *     next heartbeat/ping. (note: the internal heartbeat is much smaller
+ *     then the external/userspace heartbeat).
+ *  2) the watchdog timer has been stopped by userspace.
+ */
+static void wdt_timer_tick(unsigned long data)
+{
+	if (time_before(jiffies, next_heartbeat) ||
+	   (!test_bit(WDOG_ACTIVE, &wdt_dev.status))) {
+		wdt_reset();
+		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+	} else
+		pr_crit("I will reboot your machine !\n");
+}
+
+static int wdt_ping(struct watchdog_device *wdev)
+{
+	/* calculate when the next userspace timeout will be */
+	next_heartbeat = jiffies + timeout * HZ;
+	return 0;
+}
+
+static int wdt_start(struct watchdog_device *wdev)
+{
+	/* calculate the next userspace timeout and modify the timer */
+	wdt_ping(wdev);
+	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+	return 0;
+}
+
+static int wdt_stop(struct watchdog_device *wdev)
+{
+	/* The watchdog timer hardware can not be stopped... */
+	return 0;
+}
+
+static int wdt_set_timeout(struct watchdog_device *wdd, unsigned int new_timeout)
+{
+	if (new_timeout < 1)
+		return -EINVAL;
+	return 0;
+}
+
+static const struct watchdog_info wdt_info = {
+	.identity =	"VIA watchdog",
+	.options =	WDIOF_CARDRESET |
+			WDIOF_SETTIMEOUT |
+			WDIOF_MAGICCLOSE |
+			WDIOF_KEEPALIVEPING,
+};
+
+static const struct watchdog_ops wdt_ops = {
+	.owner =	THIS_MODULE,
+	.start =	wdt_start,
+	.stop =		wdt_stop,
+	.ping =		wdt_ping,
+	.set_timeout =	wdt_set_timeout,
+};
+
+static struct watchdog_device wdt_dev = {
+	.info =		&wdt_info,
+	.ops =		&wdt_ops,
+};
+
+static int __devinit wdt_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *ent)
+{
+	unsigned int mmio = 0;
+	void __iomem *wdt_mem;
+	int ret = -ENODEV;
+
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "cannot enable PCI device\n");
+		return -ENODEV;
+	}
+	pci_read_config_dword(pdev, VIA_WDT_MB_OFFSET, &mmio);
+	dev_info(&pdev->dev, "VIA Chipset watchdog MMIO: %x\n", mmio);
+	if (mmio == 0) {
+		dev_err(&pdev->dev, "watchdog timer is not enabled in BIOS\n");
+		goto err_out_disable_device;
+	}
+	wdt_mem = ioremap(mmio, 8);
+	if (wdt_mem == NULL) {
+		dev_err(&pdev->dev, "cannot remap VIA wdt mmio registers\n");
+		goto err_out_disable_device;
+	}
+	wdt_dev.timeout = timeout;
+	set_bit(WDOG_NO_WAY_OUT, &wdt_dev.status);
+	watchdog_set_drvdata(&wdt_dev, wdt_mem);
+	if (readl(wdt_mem) & VIA_WDT_FIRED) {
+		wdt_dev.bootstatus |= WDIOF_CARDRESET;
+		dev_notice(&pdev->dev, "restarted by expired watchdog\n");
+	}
+	ret = watchdog_register_device(&wdt_dev);
+	if (ret)
+		goto err_out_iounmap;
+	/* This watchdog is allready running. Make sure our timer is also running */
+	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+	return 0;
+
+err_out_iounmap:
+	iounmap(wdt_mem);
+err_out_disable_device:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void __devexit wdt_remove(struct pci_dev *pdev)
+{
+	void __iomem *wdt_mem = watchdog_get_drvdata(&wdt_dev);
+
+	watchdog_unregister_device(&wdt_dev);
+	dev_warn(&pdev->dev, "I quit now, hardware will probably reboot!\n");
+	del_timer(&timer);
+	iounmap(wdt_mem);
+	pci_disable_device(pdev);
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
+	if (timeout < 1)
+		timeout = WDT_TIMEOUT;
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
