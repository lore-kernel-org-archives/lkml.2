Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1FPLGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:06:08 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:48366 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1FPLFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:05:55 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH 2/2] Add watchdog driver for Intel TunnelCreek
Date: Thu, 16 Jun 2011 13:05:50 +0200
Message-Id: <1308222350-21634-2-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308222350-21634-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1308222350-21634-1-git-send-email-alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/watchdog/Kconfig                      |   12 +
 drivers/watchdog/Makefile                     |    1 +
 drivers/watchdog/intel_tunnelcreek_watchdog.c |  446 +++++++++++++++++++++++++
 3 files changed, 459 insertions(+), 0 deletions(-)
 create mode 100644 drivers/watchdog/intel_tunnelcreek_watchdog.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 022f9eb..cfba3b7 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -543,6 +543,18 @@ config INTEL_SCU_WATCHDOG
 
 	  To compile this driver as a module, choose M here.
 
+config INTEL_TUNNELCREEK_WATCHDOG
+	tristate "Intel TunnelCreek watchdog"
+	depends on WATCHDOG && PCI && X86
+	select MFD_CORE
+	select LPC_SCH
+	---help---
+	  Hardware driver for the watchdog timer built into the Intel
+	  Tunnel Creek processor.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tunnelcreek_wdt.
+
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
 	depends on (X86 || IA64) && PCI
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index ed26f70..88c20bf 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_W83977F_WDT) += w83977f_wdt.o
 obj-$(CONFIG_MACHZ_WDT) += machzwd.o
 obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 obj-$(CONFIG_INTEL_SCU_WATCHDOG) += intel_scu_watchdog.o
+obj-$(CONFIG_INTEL_TUNNELCREEK_WATCHDOG) += intel_tunnelcreek_watchdog.o
 
 # M32R Architecture
 
diff --git a/drivers/watchdog/intel_tunnelcreek_watchdog.c b/drivers/watchdog/intel_tunnelcreek_watchdog.c
new file mode 100644
index 0000000..3a31ad7
--- /dev/null
+++ b/drivers/watchdog/intel_tunnelcreek_watchdog.c
@@ -0,0 +1,446 @@
+/*
+ *      Intel Tunnelcreek Watchdog driver
+ *
+ *      Copyright (C) 2011 Alexander Stein <alexander.stein@systec-electronic.com>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of version 2 of the GNU General
+ *      Public License as published by the Free Software Foundation.
+ *
+ *      This program is distributed in the hope that it will be
+ *      useful, but WITHOUT ANY WARRANTY; without even the implied
+ *      warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *      PURPOSE.  See the GNU General Public License for more details.
+ *      You should have received a copy of the GNU General Public
+ *      License along with this program; if not, write to the Free
+ *      Software Foundation, Inc., 59 Temple Place - Suite 330,
+ *      Boston, MA  02111-1307, USA.
+ *      The full GNU General Public License is included in this
+ *      distribution in the file called COPYING.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/watchdog.h>
+
+#define DRIVER_NAME "tunnelcreek_wdt"
+
+#define PV1	0x00
+#define PV2	0x04
+
+#define RR0	0x0c
+#define RR1	0x0d
+#define WDT_RELOAD	0x01
+#define WDT_TOUT	0x02
+
+#define WDTCR		0x10
+#define WDT_PRE_SEL	0x04
+#define WDT_RESET_SEL	0x08
+#define WDT_RESET_EN	0x10
+#define WDT_TOUT_EN	0x20
+
+#define DCR	0x14
+
+#define WDTLR		0x18
+#define WDT_LOCK	0x01
+#define WDT_ENABLE	0x02
+#define WDT_TOUT_CNF	0x03
+
+#define INTEL_TUNNELCREEK_STATUS_OPEN	0
+
+#define MIN_TIME	1
+#define MAX_TIME	(10 * 60) /* 10 minutes */
+
+#define DEFAULT_TIME	60
+
+static int timer_set = DEFAULT_TIME;
+module_param(timer_set, int, 0);
+MODULE_PARM_DESC(timer_set,
+		"Default Watchdog timer setting (" __stringify(DEFAULT_TIME) "s)."
+		"The range is from 1 to 600");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static int resetmode = WATCHDOG_NOWAYOUT;
+module_param(resetmode, int, 0);
+MODULE_PARM_DESC(resetmode,
+	"Resetmode bits: 0x08 warm reset (cold reset otherwise), 0x10 reset enable, 0x20 disable toggle GPIO[4] (default=0)");
+
+struct intel_tunnelcreek_watchdog_dev {
+	ulong driver_open;
+	u32 timer_started;
+	u32 timer_set;
+	struct miscdevice miscdev;
+	unsigned short sch_wdtba;
+	int status;
+	struct spinlock unlock_sequence;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs;
+#endif
+};
+
+static struct intel_tunnelcreek_watchdog_dev watchdog_device;
+
+static int check_timer_margin(int new_timeout)
+{
+	if ((new_timeout < MIN_TIME) ||
+	    (new_timeout > MAX_TIME)) {
+		pr_debug("Watchdog timer: value of new_timeout %d is out of the range %d to %d\n",
+			  new_timeout, MIN_TIME, MAX_TIME);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int check_locked(void)
+{
+	return inb(watchdog_device.sch_wdtba + WDTLR) & WDT_LOCK;
+}
+
+static int stop_timer(void)
+{
+	if (check_locked())
+		return 1;
+
+	/* Disable the watchdog timer */
+	outb(0, watchdog_device.sch_wdtba + WDTLR);
+
+	return 0;
+}
+
+/*
+ * This is needed to write to preload and reload registers
+ * struct intel_tunnelcreek_watchdog_dev.unlock_sequence must be used
+ * to prevent sequence interrupts
+ */
+static void unlock_registers(void)
+{
+	outb(0x80, watchdog_device.sch_wdtba + RR0);
+	outb(0x86, watchdog_device.sch_wdtba + RR0);
+}
+
+static void intel_tunnelcreek_keepalive(void)
+{
+	spin_lock(&watchdog_device.unlock_sequence);
+	unlock_registers();
+	outb(WDT_RELOAD, watchdog_device.sch_wdtba + RR1);
+	spin_unlock(&watchdog_device.unlock_sequence);
+}
+
+static int intel_tunnelcreek_set_heartbeat(u32 t)
+{
+	u32 preload;
+	u64 clock;
+	u16 wdtcr;
+	u8  wdtlr;
+
+	/* Watchdog clock is PCI Clock (33MHz) */
+	clock = 33000000;
+	/* and the preload value is loaded into [34:15] of the down counter */
+	preload = (t * clock) >> 15;
+	/*
+	 * Manual states preload must be one less.
+	 * Does not wrap as t is at least 1
+	 */
+	preload -= 1;
+
+	wdtcr = resetmode & 0x38;
+	/* Enable prescaler for range 10ms to 10 min */
+	outb(wdtcr, watchdog_device.sch_wdtba + WDTCR);
+
+	spin_lock(&watchdog_device.unlock_sequence);
+
+	unlock_registers();
+	outl(0, watchdog_device.sch_wdtba + PV1);
+
+	unlock_registers();
+	outl(preload, watchdog_device.sch_wdtba + PV2);
+
+	unlock_registers();
+	outb(WDT_RELOAD | WDT_TOUT, watchdog_device.sch_wdtba + RR1);
+
+	spin_unlock(&watchdog_device.unlock_sequence);
+
+	/* Enable the watchdog timer */
+	wdtlr = nowayout ? WDT_LOCK : 0;
+	wdtlr |= WDT_ENABLE;
+	outb(wdtlr, watchdog_device.sch_wdtba + WDTLR);
+
+	watchdog_device.timer_started = 1;
+
+	return 0;
+}
+
+/*
+ * /dev/watchdog handling
+ */
+
+static ssize_t intel_tunnelcreek_write(struct file *file,
+			      char const *data,
+			      size_t len,
+			      loff_t *ppos)
+{
+
+	if (watchdog_device.timer_started)
+		/* Watchdog already started, keep it alive */
+		intel_tunnelcreek_keepalive();
+	else
+		/* Start watchdog with timer value set by init */
+		intel_tunnelcreek_set_heartbeat(watchdog_device.timer_set);
+
+	return len;
+}
+
+static long intel_tunnelcreek_ioctl(struct file *file,
+			   unsigned int cmd,
+			   unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	u32 __user *p = argp;
+	u32 new_timeout;
+
+
+	static const struct watchdog_info ident = {
+		.options =          WDIOF_SETTIMEOUT
+				    | WDIOF_KEEPALIVEPING,
+		.identity =         "Intel TunnelCreek Watchdog",
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp,
+				    &ident,
+				    sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		if (put_user(watchdog_device.status, (int __user *)argp))
+			return -EFAULT;
+		watchdog_device.status &= ~WDIOF_KEEPALIVEPING;
+		return 0;
+	case WDIOC_KEEPALIVE:
+		intel_tunnelcreek_keepalive();
+		watchdog_device.status |= WDIOF_KEEPALIVEPING;
+
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+
+		if (check_timer_margin(new_timeout))
+			return -EINVAL;
+
+		if (intel_tunnelcreek_set_heartbeat(new_timeout))
+			return -EINVAL;
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(watchdog_device.timer_set, p);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int intel_tunnelcreek_open(struct inode *inode, struct file *file)
+{
+	/* Set flag to indicate that watchdog device is open */
+	if (test_and_set_bit(INTEL_TUNNELCREEK_STATUS_OPEN, &watchdog_device.driver_open))
+		return -EBUSY;
+
+	return nonseekable_open(inode, file);
+}
+
+static int intel_tunnelcreek_close(struct inode *inode, struct file *file)
+{
+	/*
+	 * This watchdog should not be closed, after the timer
+	 * is started with the WDIPC_SETTIMEOUT ioctl
+	 */
+
+	if (!test_and_clear_bit(0, &watchdog_device.driver_open)) {
+		pr_debug("Watchdog timer: %s, without open\n", __func__);
+		return -ENOTTY;
+	}
+
+	if (!watchdog_device.timer_started) {
+		/* Just close, since timer has not been started */
+		pr_debug("Watchdog timer: closed, without starting timer\n");
+		return 0;
+	}
+
+	/* Refresh the timer for one more interval */
+	intel_tunnelcreek_keepalive();
+
+	return 0;
+}
+
+static const struct file_operations intel_tunnelcreek_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.unlocked_ioctl = intel_tunnelcreek_ioctl,
+	.open = intel_tunnelcreek_open,
+	.release = intel_tunnelcreek_close,
+	.write = intel_tunnelcreek_write,
+};
+
+#ifdef CONFIG_DEBUG_FS
+
+static int intel_tunnelcreek_dbg_show(struct seq_file *s, void *unused)
+{
+	seq_printf(s, "PV1   = 0x%08x\n", inl(watchdog_device.sch_wdtba + PV1));
+	seq_printf(s, "PV2   = 0x%08x\n", inl(watchdog_device.sch_wdtba + PV2));
+	seq_printf(s, "RR    = 0x%08x\n", inw(watchdog_device.sch_wdtba + RR0));
+	seq_printf(s, "WDTCR = 0x%08x\n", inw(watchdog_device.sch_wdtba + WDTCR));
+	seq_printf(s, "DCR   = 0x%08x\n", inl(watchdog_device.sch_wdtba + DCR));
+	seq_printf(s, "WDTLR = 0x%08x\n", inw(watchdog_device.sch_wdtba + WDTLR));
+
+	seq_printf(s, "\n");
+	return 0;
+}
+
+static int intel_tunnelcreek_dbg_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, intel_tunnelcreek_dbg_show, NULL);
+}
+
+static const struct file_operations intel_tunnelcreek_dbg_operations = {
+	.open		= intel_tunnelcreek_dbg_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void __devinit intel_tunnelcreek_debugfs_init(void)
+{
+	/* /sys/kernel/debug/intel_tunnelcreek_wdt */
+	watchdog_device.debugfs = debugfs_create_file("intel_tunnelcreek_wdt",
+		S_IFREG | S_IRUGO, NULL, NULL,
+		&intel_tunnelcreek_dbg_operations);
+}
+
+static void __devexit intel_tunnelcreek_debugfs_exit(void)
+{
+	debugfs_remove(watchdog_device.debugfs);
+}
+
+#else
+static void __devinit intel_tunnelcreek_debugfs_init(void)
+{
+}
+
+static void __devexit intel_tunnelcreek_debugfs_exit(void)
+{
+}
+#endif
+
+static int __devinit intel_tunnelcreek_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res)
+		return -EBUSY;
+
+	if (!request_region(res->start, resource_size(res), pdev->name)) {
+		dev_err(&pdev->dev, "Watchdog region 0x%x already in use!\n",
+			watchdog_device.sch_wdtba);
+		return -EBUSY;
+	}
+
+	watchdog_device.sch_wdtba = res->start;
+
+	/* Set the default time values in device structure */
+	watchdog_device.timer_set = timer_set;
+
+	dev_dbg(&pdev->dev, "WDT = 0x%X\n", watchdog_device.sch_wdtba);
+
+	watchdog_device.miscdev.minor = WATCHDOG_MINOR;
+	watchdog_device.miscdev.name = "watchdog";
+	watchdog_device.miscdev.fops = &intel_tunnelcreek_fops;
+
+	ret = misc_register(&watchdog_device.miscdev);
+	if (ret) {
+		pr_err("Watchdog timer: cannot register miscdev %d err =%d\n",
+							WATCHDOG_MINOR, ret);
+		goto misc_register_error;
+	}
+
+	spin_lock_init(&watchdog_device.unlock_sequence);
+
+	intel_tunnelcreek_debugfs_init();
+
+	return 0;
+
+misc_register_error:
+	release_region(res->start, resource_size(res));
+	watchdog_device.sch_wdtba = 0;
+	return ret;
+}
+
+static int __devexit intel_tunnelcreek_remove(struct platform_device *pdev)
+{
+	struct resource *res;
+
+	intel_tunnelcreek_debugfs_exit();
+
+	if (watchdog_device.sch_wdtba) {
+		stop_timer();
+		misc_deregister(&watchdog_device.miscdev);
+		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+		release_region(res->start, resource_size(res));
+		watchdog_device.sch_wdtba = 0;
+	}
+
+	return 0;
+}
+
+static struct platform_driver smbus_sch_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe		= intel_tunnelcreek_probe,
+	.remove		= __devexit_p(intel_tunnelcreek_remove),
+};
+
+static int __init intel_tunnelcreek_watchdog_init(void)
+{
+	/* Check boot parameters to verify that their initial values */
+	/* are in range. */
+	if ((timer_set < MIN_TIME) ||
+	    (timer_set > MAX_TIME)) {
+		pr_err("Watchdog timer: value of timer_set %d (dec) "
+		  "is out of range from %d to %d (dec)\n",
+		  timer_set, MIN_TIME, MAX_TIME);
+		return -EINVAL;
+	}
+
+	return platform_driver_register(&smbus_sch_driver);
+}
+
+static void __exit intel_tunnelcreek_watchdog_exit(void)
+{
+	platform_driver_unregister(&smbus_sch_driver);
+}
+
+late_initcall(intel_tunnelcreek_watchdog_init);
+module_exit(intel_tunnelcreek_watchdog_exit);
+
+MODULE_AUTHOR("Alexander Stein <alexander.stein@systec-electronic.com>");
+MODULE_DESCRIPTION("Intel Tunnelcreek Watchdog Device Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
1.7.3.4

