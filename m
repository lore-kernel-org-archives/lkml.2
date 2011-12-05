Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab1LEUO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:14:29 -0500
Received: from 9.mo4.mail-out.ovh.net ([46.105.40.176]:43413 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756295Ab1LEUO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:14:28 -0500
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Dec 2011 15:14:27 EST
Date: Mon, 05 Dec 2011 17:00:23 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH V2] watchdog: new driver for VIA chipsets
Message-ID: <4edcea97.DkJEuLQJGuzahhwo%marc.vertes@sigfox.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16904261201505470232
X-Ovh-Remote: 92.103.90.130 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedruddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfgggtgfgsehtjeertddtredvnecuhfhrohhmpeforghrtgcugggvrhhtvghsuceomhgrrhgtrdhvvghrthgvshesshhighhfohigrdgtohhmqeenucffohhmrghinhepuggvvhdrihhnfhhone
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedruddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfgggtgfgsehtjeertddtredvnecuhfhrohhmpeforghrtgcugggvrhhtvghsuceomhgrrhgtrdhvvghrthgvshesshhighhfohigrdgtohhmqeenucffohhmrghinhepuggvvhdrihhnfhhone
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New driver for the hardware watchdog timer on VIA chipsets.
This driver uses the new watchdog framework.
PnP must be enabled in BIOS to get full control of watchdog registers.
The timer code has been added by Wim Van Sebroeck.
Tested on a Artigo A1100, VX855 chipset.

Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
---
 Kconfig   |   13 +++
 Makefile  |    1 
 via_wdt.c |  266 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 280 insertions(+)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79fd606..877b107 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -772,6 +772,19 @@ config SMSC37B787_WDT
 
 	  Most people will say N.
 
+config VIA_WDT
+	tristate "VIA Watchdog Timer"
+	depends on X86
+	select WATCHDOG_CORE
+	---help---
+	This is the driver for the hardware watchdog timer on VIA
+	southbridge chipset CX700, VX800/VX820 or VX855/VX875.
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
diff --git a/drivers/watchdog/via_wdt.c b/drivers/watchdog/via_wdt.c
new file mode 100644
index 0000000..3bc4399
--- /dev/null
+++ b/drivers/watchdog/via_wdt.c
@@ -0,0 +1,266 @@
+/*
+ * VIA Chipset Watchdog Driver
+ *
+ * Copyright (C) 2011 Sigfox
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Marc Vertes <marc.vertes@sigfox.com>
+ * Based on a preliminary version from Harald Welte <HaraldWelte@viatech.com>
+ * Timer code by Wim Van Sebroeck <wim@iguana.be>
+ *
+ * Caveat: PnP must be enabled in BIOS to allow full access to watchdog
+ * control registers. If not, the watchdog must be configured in BIOS manually.
+ */
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/timer.h>
+#include <linux/watchdog.h>
+
+/* Configuration registers relative to the pci device */
+#define VIA_WDT_MMIO_BASE	0xe8	/* MMIO region base address */
+#define VIA_WDT_CONF		0xec	/* watchdog enable state */
+
+/* Relevant bits for the VIA_WDT_CONF register */
+#define VIA_WDT_CONF_ENABLE	0x01	/* 1: enable watchdog */
+#define VIA_WDT_CONF_MMIO	0x02	/* 1: enable watchdog MMIO */
+
+/*
+ * The MMIO region contains the watchog control register and the
+ * hardware timer counter.
+ */
+#define VIA_WDT_MMIO_LEN	8	/* MMIO region length in bytes */
+#define VIA_WDT_CTL		0	/* MMIO addr+0: state/control reg. */
+#define VIA_WDT_COUNT		4	/* MMIO addr+4: timer counter reg. */
+
+/* Bits for the VIA_WDT_CTL register */
+#define VIA_WDT_RUNNING		0x01	/* 0: stop, 1: running */
+#define VIA_WDT_FIRED		0x02	/* 1: restarted by expired watchdog */
+#define VIA_WDT_PWROFF		0x04	/* 0: reset, 1: poweroff */
+#define VIA_WDT_DISABLED	0x08	/* 1: timer is disabled */
+#define VIA_WDT_TRIGGER		0x80	/* 1: start a new countdown */
+
+/* Hardware heartbeat in seconds */
+#define WDT_HW_HEARTBEAT 1
+
+/* Timer heartbeat (500ms) */
+#define WDT_HEARTBEAT	(HZ/2)	/* should be <= ((WDT_HW_HEARTBEAT*HZ)/2) */
+
+/* User space timeout in seconds */
+#define WDT_TIMEOUT_MAX	1023	/* approx. 17 min. */
+#define WDT_TIMEOUT	60
+static int timeout = WDT_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds, between 1 and 1023 "
+	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default = " __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static struct watchdog_device wdt_dev;
+static struct resource wdt_res;
+static void __iomem *wdt_mem;
+static unsigned int mmio;
+static void wdt_timer_tick(unsigned long data);
+static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
+					/* The timer that pings the watchdog */
+static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
+
+static inline void wdt_reset(void)
+{
+	unsigned int ctl = readl(wdt_mem);
+
+	writel(ctl | VIA_WDT_TRIGGER, wdt_mem);
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
+static int wdt_ping(struct watchdog_device *wdd)
+{
+	/* calculate when the next userspace timeout will be */
+	next_heartbeat = jiffies + timeout * HZ;
+	return 0;
+}
+
+static int wdt_start(struct watchdog_device *wdd)
+{
+	unsigned int ctl = readl(wdt_mem);
+
+	writel(timeout, wdt_mem + VIA_WDT_COUNT);
+	writel(ctl | VIA_WDT_RUNNING | VIA_WDT_TRIGGER, wdt_mem);
+	wdt_ping(wdd);
+	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+	return 0;
+}
+
+static int wdt_stop(struct watchdog_device *wdd)
+{
+	unsigned int ctl = readl(wdt_mem);
+
+	writel(ctl & ~VIA_WDT_RUNNING, wdt_mem);
+	return 0;
+}
+
+static int wdt_set_timeout(struct watchdog_device *wdd,
+			   unsigned int new_timeout)
+{
+	if (new_timeout < 1 || new_timeout > WDT_TIMEOUT_MAX)
+		return -EINVAL;
+	writel(new_timeout, wdt_mem + VIA_WDT_COUNT);
+	timeout = new_timeout;
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
+	unsigned char conf;
+	int ret = -ENODEV;
+
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "cannot enable PCI device\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Allocate a MMIO region which contains watchdog control register
+	 * and counter, then configure the watchdog to use this region.
+	 * This is possible only if PnP is properly enabled in BIOS.
+	 * If not, the watchdog must be configured in BIOS manually.
+	 */
+	if (allocate_resource(&iomem_resource, &wdt_res, VIA_WDT_MMIO_LEN,
+			      0xf0000000, 0xffffff00, 0xff, NULL, NULL)) {
+		dev_err(&pdev->dev, "MMIO allocation failed\n");
+		goto err_out_disable_device;
+	}
+
+	pci_write_config_dword(pdev, VIA_WDT_MMIO_BASE, wdt_res.start);
+	pci_read_config_byte(pdev, VIA_WDT_CONF, &conf);
+	conf |= VIA_WDT_CONF_ENABLE | VIA_WDT_CONF_MMIO;
+	pci_write_config_byte(pdev, VIA_WDT_CONF, conf);
+
+	pci_read_config_dword(pdev, VIA_WDT_MMIO_BASE, &mmio);
+	if (mmio) {
+		dev_info(&pdev->dev, "VIA Chipset watchdog MMIO: %x\n", mmio);
+	} else {
+		dev_err(&pdev->dev, "MMIO setting failed. Check BIOS.\n");
+		goto err_out_resource;
+	}
+
+	if (!request_mem_region(mmio, VIA_WDT_MMIO_LEN, "via_wdt")) {
+		dev_err(&pdev->dev, "MMIO region busy\n");
+		goto err_out_resource;
+	}
+
+	wdt_mem = ioremap(mmio, VIA_WDT_MMIO_LEN);
+	if (wdt_mem == NULL) {
+		dev_err(&pdev->dev, "cannot remap VIA wdt MMIO registers\n");
+		goto err_out_release;
+	}
+
+	wdt_dev.timeout = timeout;
+	watchdog_set_nowayout(&wdt_dev, nowayout);
+	if (readl(wdt_mem) & VIA_WDT_FIRED)
+		wdt_dev.bootstatus |= WDIOF_CARDRESET;
+
+	ret = watchdog_register_device(&wdt_dev);
+	if (ret)
+		goto err_out_iounmap;
+
+	/* start triggering, in case of watchdog already enabled by BIOS */
+	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
+	return 0;
+
+err_out_iounmap:
+	iounmap(wdt_mem);
+err_out_release:
+	release_mem_region(mmio, VIA_WDT_MMIO_LEN);
+err_out_resource:
+	release_resource(&wdt_res);
+err_out_disable_device:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void __devexit wdt_remove(struct pci_dev *pdev)
+{
+	watchdog_unregister_device(&wdt_dev);
+	del_timer(&timer);
+	iounmap(wdt_mem);
+	release_mem_region(mmio, VIA_WDT_MMIO_LEN);
+	release_resource(&wdt_res);
+	pci_disable_device(pdev);
+}
+
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
+	if (timeout < 1 || timeout > WDT_TIMEOUT_MAX)
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
