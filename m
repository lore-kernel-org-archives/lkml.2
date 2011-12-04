Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1LDJxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 04:53:52 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:56160 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1LDJxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 04:53:47 -0500
X-Auth-Info: P/LTXFo+CHBM2SWpzN2K9pTIoA/WoPYj/A3+vqdvT0k=
From: Heiko Schocher <hs@denx.de>
Cc: Heiko Schocher <hs@denx.de>, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Wolfgang Denk <wd@denx.de>, Stefan Roese <sr@denx.de>
Subject: [PATCH] RFC, watchdog: add generic wdt driver API
Date: Sun,  4 Dec 2011 10:53:43 +0100
Message-Id: <1322992423-21683-1-git-send-email-hs@denx.de>
X-Mailer: git-send-email 1.7.6.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver implements a character device with major number 10 and minor
number 130.  It is a software abstraction of the hardware watchdog
with two different APIs.  While the driver periodically triggers the
hardware watchdog, the software can setup independent timeout periods.

"REGULAR API"
provides a facility to setup a watchdog behaviour shared by all
processes using the driver.  This interface uses read, write and
ioctl calls.

"CHAIN API"
can be used to register configurable "watchdog chains" from
kernel and/or user space. This interface uses ioctl calls only.

more info about this two APIs are found in
Documentation/watchdog/wd-api.txt

Different hardware layers can attached to this driver. As this
is an RFC add in this patch also, as an example for an hardware
layer, support for the arm davinci internal WDT.

Signed-off-by: Heiko Schocher <hs@denx.de>
Cc: linux-watchdog@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: Wolfgang Denk <wd@denx.de>
Cc: Stefan Roese <sr@denx.de>

---
This patch is a port from Linux 2.4 and thought as an RFC, so comments
are greately appreciated. First question is, has this watchdog driver
API a chance to go in mainline? If so, what is the direction to
go to push it ...

 Documentation/devicetree/bindings/watchdog/wd.txt |   18 +
 Documentation/watchdog/wd-api.txt                 |  196 ++++
 arch/arm/mach-davinci/time.c                      |    2 +
 drivers/watchdog/Kconfig                          |   31 +
 drivers/watchdog/Makefile                         |    2 +
 drivers/watchdog/wd.c                             | 1013 +++++++++++++++++++++
 drivers/watchdog/wd_davinci.c                     |  146 +++
 include/linux/wd.h                                |  131 +++
 include/linux/wd_hw.h                             |   55 ++
 9 files changed, 1594 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/watchdog/wd.txt
 create mode 100644 Documentation/watchdog/wd-api.txt
 create mode 100644 drivers/watchdog/wd.c
 create mode 100644 drivers/watchdog/wd_davinci.c
 create mode 100644 include/linux/wd.h
 create mode 100644 include/linux/wd_hw.h

diff --git a/Documentation/devicetree/bindings/watchdog/wd.txt b/Documentation/devicetree/bindings/watchdog/wd.txt
new file mode 100644
index 0000000..75fa966
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/wd.txt
@@ -0,0 +1,18 @@
+* generic WDT interface
+
+driver implements a character device with major number 10 and minor
+number 130.  It is a software abstraction of the hardware watchdog
+with two different APIs.  While the driver periodically triggers the
+hardware watchdog, the software can setup independent timeout periods.
+
+Different hardware layers can attached to this driver. Here a summary
+of existing harware layers and the necessary properites for them:
+
+Davinci WDT:
+
+Required properties:
+- compatible : should be "ti,davinci-wdt"
+- reg : physical base address and length of memory mapped region.
+
+Optional properties
+- period: trigger period for wdt in jiffies
diff --git a/Documentation/watchdog/wd-api.txt b/Documentation/watchdog/wd-api.txt
new file mode 100644
index 0000000..8bb2581
--- /dev/null
+++ b/Documentation/watchdog/wd-api.txt
@@ -0,0 +1,196 @@
+Last Reviewed: 24/11/2011
+
+	WDT Watchdog Timer Interfaces For The Linux Operating System
+		Heiko Schocher <hs@denx.de>
+
+driver implements a character device with major number 10 and minor
+number 130.  It is a software abstraction of the hardware watchdog
+with two different APIs.  While the driver periodically triggers the
+hardware watchdog, the software can setup independent timeout periods.
+
+"REGULAR API"
+The regular API provides a facility to setup a watchdog behaviour
+shared by all processes using the driver.  This interface uses read(2),
+write(2) and the first two ioctl(2) calls listed below.  The
+parameterless ioctl(2) calls select the operational mode of the
+driver, which can be
+	open-only
+or
+	always.
+
+In open-only mode, the watchdog will not expire if the device file is
+not opened by any process, while in always mode the behaviour is
+independent of the device file being opened.
+
+Reading from the device file will return an unsigned integer denoting
+the number of seconds left till the watchdog expires.  Writing an
+unsigned integer to the device file will set the expiration period in
+seconds.  Note that the hardware watchdog will be triggered
+independently with a configurable period.  See the section
+CONFIGURATION for details.
+
+An expiration of the watchdog will trigger a hard-reset of the machine.
+
+"CHAIN API"
+The second API, which is implemented only through calls to ioctl(2),
+can be used to register configurable "watchdog chains" from either
+user or kernel space.  A watchdog chain is identified by an unsigned
+integer and can contain up to three action stages.
+
+A "time interval" in seconds and an "action"
+is associated with each stage.  When the chain is not reset before the
+interval elapses, the associated action is triggered and the chain
+moves on to the next stage.
+
+A chain can request to kill the registering process if the interval
+elapses.  In this case a restarted process can register with the
+driver giving the same identifier and reset the chain.  This is the
+main reason why there is no association between chains and processes
+or open device files.
+
+For a detailed description of the possible chain configurations, see
+the description of the WD_REGISTER ioctl call.
+
+Note that when mixing the two interfaces, the second API takes
+precedence. That is, expiry of the interval set by writing to the
+device file while a chain is registered, will not trigger any actions.
+
+Also note that the default operational mode of the driver,
+i.e. open-only or always can only be configured in the source-code.
+
+IOCTLS
+
+  WD_OPEN_ONLY
+    This parameterless call selects the "open-only"
+    operational mode of the driver as described above.
+
+
+  WD_ALWAYS
+    Also a parameterless call, this sets the driver to the "always"
+    operational mode.
+
+
+  WD_REGISTER
+    This and the two following ioctls constitute the "chain interface"
+    described above.  The parameter given to the call is a pointer to a
+    structure with the following layout:
+
+    struct wd_param {
+      unsigned chainid;
+      unsigned long timer_count[3];
+      int action[3];
+      int signal;
+    } wd_param;
+
+  Each stage is configured with entries in the arrays
+    "timer_count"
+  and
+    "action."
+
+  The timer_count contains the length of the interval in seconds
+  while action contains one of the constants
+
+  WD_ACTION_SIGNAL, WD_ACTION_KILL,
+  WD_ACTION_REBOOT
+  and
+  WD_ACTION_RESET.
+
+  A timer_count of zero signals the end of the chain.
+
+  The ACTION_SIGNAL will send the configurable signal with number
+  "signal" to the registering process, while ACTION_KILL signals SIGKILL which
+  can not be caught by the registered process.
+
+  ACTION_REBOOT tries a soft reboot and ACTION_RESET
+  triggers a hard-reset of the machine.
+
+  When stages of the chain are to be left unused, they should be filled
+  with zero entries.
+
+  Note that internally a hard-reset stage is appended as a stop entry
+  ensuring a chain will never exceed its stages.
+
+
+WD_RESET
+  This call resets the chain denoted by the unsigned integer passed to
+  it.  When reset, a chain will expire beginning with stage zero again.
+
+
+WD_UNREGISTER
+  As closing the device file will not have any effect on chains, a
+  process must unregister a chain if the service is no longer needed.
+  This can be done with this ioctl taking an unsigned integer as a
+  parameter denoting the chain to be unregistered.
+
+
+"IOCTL RESULT VALUES"
+On successful completion, the above calls to ioctl(2) return 0.  When
+invalid parameters are provided or an error occurs, a negative value
+will be returned and "errno" set accordingly.  Specifically
+"EINVAL, EFAULT, ENOMEM"
+can be returned.
+
+
+"KERNEL INTERFACE"
+Modules can also register with the chain API of the watchdog driver.
+This the three functions (wdt_chain_register_mon_chain, wdt_chain_reset_mon_chain
+and wdt_chain_unregister_mon_chain) are exported from the driver. The
+first function takes one argument, namely a pointer to a "wdt_chain_param"
+structure. The other two calls take a pointer to an unsigned integer as a
+parameter, namely the chain id of the chain to be reset or unregistered.
+
+
+CONFIGURATION
+The driver is configurable through parameters passed to the driver
+through the Linux commandline as
+
+"wd=<opts>".
+
+Multiple options can be seperated by commas, as usual.
+
+timeout:<n>
+  will set the expiry period of the regular driver API to <n> seconds.
+
+period:<n>
+  sets the period with which the hardware watchdog is triggered to <n>
+  jiffies.  This usually means 1/100th of a second.
+
+off
+  will disable the software APIs of the driver but still trigger the
+  hardware watchdog as described previously.
+
+
+EXAMPLE
+The following code snippet registers a watchdog chain whose first
+stage will expire after 3 seconds and send the SIGUSR1 signal to the
+process.  When 5 seconds after this the chain is not reset, the
+machine will do a hard-reset.
+
+  struct wd_param param;
+
+  /* Setup signal handling */
+  signal(SIGUSR1, got_signal);
+
+  param.chainid=823;
+  param.timer_count[0]=3;
+  param.action[0]=WD_ACTION_SIGNAL;
+  param.signal=SIGUSR1;
+  param.timer_count[1]=5;
+  param.action[1]=WD_ACTION_RESET;
+
+  /* Register chain */
+  ioctl(fd, WD_REGISTER, &param);
+  ..
+  /* Reset chain    */
+  ioctl(fd, WD_RESET, &param.chainid);
+
+
+FILES
+ /dev/watchdog
+
+SUPPORTED HARDWARE
+  The Hardwaredependent functions are seperated, so that it should be
+  easy to support new Hardware. Actual the following Hardware are supported:
+
+  Hardware		File
+  AM1808		wd_davinci.c
diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index e1969ce..2cba402 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -423,6 +423,7 @@ struct sys_timer davinci_timer = {
 };
 
 
+#if !defined(CONFIG_WD_DAVINCI)
 /* reset board using watchdog timer */
 void davinci_watchdog_reset(struct platform_device *pdev)
 {
@@ -472,3 +473,4 @@ void davinci_watchdog_reset(struct platform_device *pdev)
 	wdtcr = 0x00004000;
 	__raw_writel(wdtcr, base + WDTCR);
 }
+#endif
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79fd606..1dce4ff 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -53,6 +53,37 @@ comment "Watchdog Device Drivers"
 
 # Architecture Independent
 
+config WD
+	bool "Generic watchdog driver"
+	help
+	  This is a generic high-level watchdog driver. It implements
+	  platform independent front end for watchdog devices. If you
+	  say Y here, you most likely should also enable a low-level
+	  watchdog driver characteristic for installed hardware.
+
+if WD
+
+config WD_TIMEOUT
+	int "Set default timeout for generic watchdog driver (in sec.)"
+	default "300"
+	help
+	  This option sets default watchdog timeout. It can be overwritten
+	  by user using kernel command line option or write() function called
+	  on watchdog device.
+
+comment "Low-level watchdog drivers"
+
+config WD_DAVINCI
+	bool "Driver for triggering internal WDT on davinci plattforms"
+	depends on WD
+	default n
+	select ARCH_HAS_NMI_WATCHDOG
+	help
+	  Low level functions for triggering the internal WDT
+	  on davinci plattforms. Tested on an am1808 based board.
+
+endif # WD
+
 config SOFT_WATCHDOG
 	tristate "Software watchdog"
 	help
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index fe893e9..784e2fd 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
 obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
 obj-$(CONFIG_TS72XX_WATCHDOG) += ts72xx_wdt.o
 obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
+obj-$(CONFIG_WD_DAVINCI) += wd_davinci.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
@@ -165,4 +166,5 @@ obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
 obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
 obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
+obj-$(CONFIG_WD) += wd.o
 obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
diff --git a/drivers/watchdog/wd.c b/drivers/watchdog/wd.c
new file mode 100644
index 0000000..b42cb5f
--- /dev/null
+++ b/drivers/watchdog/wd.c
@@ -0,0 +1,1013 @@
+/***********************************************************************
+ *
+ * (C) Copyright 2011
+ * Heiko Schocher, DENX Software Engineering, hs@denx.de.
+ *
+ * (C) Copyright 2004, 2007, 2008
+ * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
+ *
+ * Adapted to Linux 2.6 by Piotr Kruszynski <ppk@semihalf.com>:
+ * - separated generic and hardware dependent functions
+ * - code cleanup
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ ***********************************************************************/
+/*---------------------------- Headerfiles ----------------------------*/
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>			/* for character devices	*/
+#include <linux/miscdevice.h>		/* driver is a misc device	*/
+#include <linux/version.h>
+#include <linux/init.h>			/* for __initfunc		*/
+#include <linux/spinlock.h>		/* for spinlocks		*/
+#include <linux/list.h>			/* for linked-list macros	*/
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/reboot.h>
+#include <linux/syscalls.h>
+#include <linux/watchdog.h>
+#include <linux/wd.h>
+#include <linux/uaccess.h>		/* for put_user			*/
+#include <asm/cacheflush.h>		/* for flush_cache_all		*/
+
+/*----------------- Local vars, datatypes and macros ------------------*/
+#ifdef DEBUG
+#define debugk(fmt, args...) printk(fmt, ##args)
+#else
+#define debugk(fmt, args...)
+#endif
+
+#define WD_VERSION	"1.1.0"
+
+#ifdef CONFIG_WD_TIMEOUT
+#define TIMEOUT_VALUE CONFIG_WD_TIMEOUT		/* configurable timeout */
+#else
+#define TIMEOUT_VALUE 300	/* reset after five minutes = 300 seconds */
+#endif
+
+static int timeout_open_only = !WATCHDOG_NOWAYOUT;
+static int opened;		/* to implement "run while first open" */
+
+static struct list_head mon_list;
+static spinlock_t mon_lock;	/* lock for the monitored chain list */
+static int mon_chains;
+
+struct timer_list wd_timer;	/* structure for timer administration */
+static unsigned long wd_dummy;
+
+/*
+ * Watchdog active? When disabled, it will get re-triggered
+ * automatically without timeout, so it appears to be switched off
+ * although actually it is still running.
+ */
+static int enabled = 1;
+
+static unsigned long timer_count = TIMEOUT_VALUE * HZ;	/* remaining time */
+static unsigned long timer_period;			/* period to trigger */
+
+static int device_open;	/* to implement "run while open" mode */
+
+/*----------------------- Interface prototypes ------------------------*/
+static int wd_init(void);
+static void wd_handler(unsigned long);
+
+/*------------------------- Local prototypes --------------------------*/
+static int wd_open(struct inode *, struct file *);
+static int wd_release(struct inode *, struct file *);
+static ssize_t wd_read(struct file *, char *, size_t, loff_t *);
+static ssize_t wd_write(struct file *, const char *, size_t, loff_t *);
+static long wd_ioctl(struct file *, unsigned int, unsigned long);
+
+static int register_mon_chain(struct wd_param *, int);
+
+/*-------------------- Kernel interface prototypes --------------------*/
+static int wd_register_mon_chain(struct wd_param *);
+static int wd_unregister_mon_chain(unsigned int);
+static int wd_reset_mon_chain(int);
+static int process_mon_chains(void);
+static struct monitored_chain *find_mon_chain_by_chainid(unsigned int);
+static void insert_mon_chain(struct monitored_chain *);
+static void free_mon_list(void);
+
+static const struct file_operations wd_ops = {
+	.owner = THIS_MODULE,
+	.open = wd_open,
+	.release = wd_release,
+	.read = wd_read,
+	.write = wd_write,
+	.unlocked_ioctl = wd_ioctl,
+};
+
+static struct miscdevice wd_miscdev = { /* driver is a misc device */
+	WATCHDOG_MINOR,
+	"watchdog",
+	&wd_ops
+};
+
+/*-------------------- Low-level functions structure ------------------*/
+struct wd_hw_functions wd_hw_functions = {
+	.wd_init = NULL,
+	.wd_kick = NULL,
+	.wd_delete = NULL,
+	.wd_machine_restart = NULL,
+};
+
+void wd_set_hw_func(wd_init_t *wd_init, wd_kick_t *wd_kick,
+	wd_delete_t *wd_delete, wd_machine_restart_t *wd_machine_restart)
+{
+	wd_hw_functions.wd_init = wd_init;
+	wd_hw_functions.wd_kick = wd_kick;
+	wd_hw_functions.wd_delete = wd_delete;
+	wd_hw_functions.wd_machine_restart = wd_machine_restart;
+}
+
+/***********************************************************************
+F* Function:     int __init wd_init(void) P*A*Z*
+ *
+P* Parameters:   none
+P*
+P* Returnvalue:  int
+P*                - 0 success
+ *
+Z* Intention:    Initialize the driver, register the device with the
+Z*               kernel, start the watchdog and setup the internal timer.
+ *
+D* Design:       Haider / wd@denx.de
+C* Coding:       Haider / wd@denx.de
+V* Verification: wd@denx.de / dzu@denx.de
+ ***********************************************************************/
+int __init wd_init(void)
+{
+	unsigned long tp = 0;
+	int rc;
+
+	if ((wd_hw_functions.wd_init == NULL) ||
+			(wd_hw_functions.wd_kick == NULL) ||
+			(wd_hw_functions.wd_delete == NULL) ||
+			(wd_hw_functions.wd_machine_restart == NULL)) {
+		printk(KERN_ERR "%s: watchdog low-level functions not"
+			" defined\n", __func__);
+		return -ENXIO;
+	}
+
+	rc = wd_hw_functions.wd_init(&tp);
+	if (rc < 0) {
+		printk(KERN_ERR "%s: watchdog initialization failed"
+			" with code: %d\n", __func__, rc);
+		return rc;
+	}
+
+	/*
+	 * Set timer period if not defined in kernel command line
+	 */
+	if (timer_period == 0) {
+		if (tp == 0) {
+			printk(KERN_ERR "%s: watchdog initialization failed: "
+				"unknown timer period\n", __func__);
+			wd_hw_functions.wd_delete();
+			return -ENXIO;
+		}
+		timer_period = tp;
+	}
+
+	/* register misc device */
+	rc = misc_register(&wd_miscdev);
+	if (rc < 0) {
+		printk(KERN_ERR "%s: failed with %d\n", __func__, rc);
+		return rc;
+	}
+
+	debugk("WD registered: major=%d minor=%d\n",
+		MISC_MAJOR, WATCHDOG_MINOR);
+
+	INIT_LIST_HEAD(&mon_list);
+	spin_lock_init(&mon_lock);
+
+	debugk("%s: watchdog timer initialized - timer_count = %ld "
+		"period = %ld\n", __func__, timer_count / HZ,
+		HZ / timer_period);
+
+	init_timer(&wd_timer);		/* initialize timer-structure... */
+	wd_timer.function = wd_handler;
+	wd_timer.data = (unsigned long) &wd_dummy;
+	wd_timer.expires = jiffies + timer_period;
+
+	add_timer(&wd_timer);		/* ...and activate timer */
+
+	debugk("%s: timer activated\n", __func__);
+
+	if (enabled)
+		printk(KERN_INFO "WD: Software Watchdog Timer %s " \
+			"timeout %ld sec.\n", WD_VERSION, timer_count / HZ);
+	else
+		printk(KERN_INFO "WD: Software Watchdog Timer %s disabled\n",
+			WD_VERSION);
+
+	return 0;
+}
+
+/***********************************************************************
+F* Function:     int __init wd_setup(char *options) P*A*Z*
+ *
+P* Parameters:   char *options
+P*                - Options to parse
+P*
+P* Returnvalue:  int
+P*                - 0 is always returned
+ *
+Z* Intention:    Parse the options passed on the linux command line
+ *
+D* Design:       Haider / wd@denx.de
+C* Coding:       Haider / wd@denx.de
+V* Verification: wd@denx.de / dzu@denx.de
+ ***********************************************************************/
+int __init wd_setup(char *options)
+{
+	while (options && *options) {
+		if (strncmp(options, "off", 3) == 0) {
+			options += 3;
+			enabled = 0;
+			if (*options != ',')
+				return 0;
+			options++;
+		}
+
+		if (strncmp(options, "timeout:", 8) == 0) {
+			options += 8;
+			if (!*options)
+				return 0;
+			/*
+			 * The external interface is in seconds, but internal
+			 * all calculations is done in jiffies.
+			 */
+			timer_count = HZ * simple_strtoul(options, &options, 0);
+			if (*options != ',')
+				return 0;
+			options++;
+		}
+
+		if (strncmp(options, "period:", 7) == 0) {
+			options += 7;
+			if (!*options)
+				return 0;
+
+			timer_period = simple_strtoul(options, &options, 0);
+			if (*options != ',')
+				return 0;
+			options++;
+		}
+	}
+
+	return 0;
+}
+
+__setup("wd=", wd_setup);
+
+
+/***********************************************************************
+F* Function:     static int wd_open(struct inode *inode,
+F*                                           struct file *filp) P*A*Z*
+ *
+P* Parameters:   struct inode *inode
+P*                - Inode of the device file being opened
+P*               struct file *file
+P*                - Passed by the kernel, but not used
+P*
+P* Returnvalue:  int - 0 success
+P*                    <0 Errorcondition, which can be
+P*                     -ENXIO  Watchdog is not enabled
+ *
+Z* Intention:    This function is called by the kernel when a device file
+Z*               for the driver is opened by open(2).
+ *
+D* Design:       Haider / wd@denx.de
+C* Coding:       Haider / wd@denx.de
+V* Verification: wd@denx.de / dzu@denx.de
+ ***********************************************************************/
+static int wd_open(struct inode *inode, struct file *filp)
+{
+	debugk("ENTER %s (%p, %p)\n", __func__, inode, filp);
+
+	if (!enabled) {			/* user interface disabled */
+		return -ENXIO;
+	}
+	device_open++;			/* increment usage counter */
+	opened = 1;
+	debugk("%s: /dev/watchdog opened\n", __func__);
+	return 0;
+}
+
+/***********************************************************************
+F* Function:     static int wd_release(struct inode *inode,
+F*                                              struct file *filp) P*A*Z*
+ *
+P* Parameters:   struct inode *inode
+P*                - Inode of the device file being closed
+P*               struct file *file
+P*                - Passed by the kernel, but not used
+P*
+P* Returnvalue:  int
+P*                - 0 is always returned
+ *
+Z* Intention:    This function is called by the kernel when a device file
+Z*               of the driver is closed with close(2).
+ *
+D* Design:       Haider / wd@denx.de
+C* Coding:       Haider / wd@denx.de
+V* Verification: wd@denx.de / dzu@denx.de
+ ***********************************************************************/
+static int wd_release(struct inode *inode, struct file *filp)
+{
+	debugk("ENTER %s (%p, %p)\n", __func__, inode, filp);
+
+	device_open--;			/* decrement usage counter */
+	debugk("%s: /dev/watchdog closed\n", __func__);
+
+	return 0;
+}
+
+
+/***********************************************************************
+F* Function:     static ssize_t wd_read(struct file *filp, char *buffer,
+				size_t length, loff_t *offset) P*A*Z*
+ *
+P* Parameters:   struct file *file
+P*                - Passed by the kernel, pointer to the file structure
+P*                  for the device file
+P*               char *buf
+P*                - Pointer to buffer in userspace
+P*               size_t count
+P*                - Number of bytes to read
+P*               loff_t *ppos
+P*                - Offset for the read - ignored.
+P*
+P* Returnvalue:  int
+P*                 - >0 number of bytes read, i.e. 4
+P*                   <0 Errorcondition, which can be
+P*                    -EINVAL  When trying to read fewer bytes than the
+P*                             rest counter occupies, i.e. sizeof(unsigned)
+P*                    -EFAULT  A user-provided pointer is invalid
+ *
+Z* Intention:    Read the rest counter from the device.
+ *
+D* Design:       Haider / wd@denx.de
+C* Coding:       Haider / wd@denx.de
+V* Verification: wd@denx.de / dzu@denx.de
+ ***********************************************************************/
+static ssize_t wd_read(struct file *filp, char *buffer,
+			size_t length, loff_t *offset)
+{
+	unsigned int rest_count = timer_count / HZ;
+	int rc;
+
+	debugk("ENTER %s (%p, %p, %d, %p)\n",
+		__func__, filp, buffer, length,  offset);
+
+	if (length != sizeof(rest_count)) {
+		debugk("%s: invalid argument\n", __func__);
+
+		return -EINVAL;
+	}
+	/* copy value into userspace */
+	rc = put_user(rest_count, (int *) buffer);
+	if (rc != 0)
+		return rc;
+
+	debugk("%s: rest_count=%i\n", __func__, rest_count);
+
+	return sizeof(rest_count);	/* read always exactly 4 bytes */
+}
+
+
+/***********************************************************************
+F* Function:     static ssize_t wd_write(struct file *filp, const char *buffer,
+					size_t length, loff_t *offset) P*A*Z*
+ *
+P* Parameters:   struct file *file
+P*                - Passed by the kernel, pointer to the file structure
+P*                  for the device file
+P*               char *buf
+P*                - Pointer to buffer in userspace
+P*               size_t count
+P*                - Number of bytes to write
+P*               loff_t *ppos
+P*                - Offset for the write - ignored.
+P*
+P* Returnvalue:  int
+P*                 - >0 number of bytes actually written, i.e. 4
+P*                   <0 Errorcondition, which can be
+P*                    -EINVAL  When trying to write more or less than 4
+P*                             bytes, i.e. sizeof(unsigned)
+P*                    -EFAULT  A user-provided pointer is invalid
+ *
+Z* Intention:    Set the rest counter to the value provided by the user
+Z*               process interpreted as a number of seconds.
+ *
+D* Design:       Haider / wd@denx.de
+C* Coding:       Haider / wd@denx.de
+V* Verification: wd@denx.de / dzu@denx.de
+ ***********************************************************************/
+static ssize_t wd_write(struct file *filp, const char *buffer,
+				size_t length, loff_t *offset)
+{
+	int error;
+	unsigned int new_count;
+
+	debugk("ENTER %s (%p, %p, %d, %p)\n",
+		__func__, filp, buffer, length,  offset);
+
+	if (length != sizeof(new_count)) {
+		debugk("%s: invalid length (%d instead of %d)\n",
+			__func__, length, sizeof(new_count));
+
+		return -EINVAL;
+	}
+
+	/* copy count value into kernel space */
+	error = get_user(new_count, (int *) buffer);
+	if (error != 0) {
+		debugk("%s: get_user failed: rc=%d\n",
+			__func__, error);
+
+		return error;
+	}
+
+	/*
+	 * The external interface is in seconds, but internal all calculations
+	 * is done in jiffies.
+	 */
+	timer_count = HZ * new_count;
+
+	return sizeof(new_count);
+}
+
+/***********************************************************************
+F* Function:     static long wd_ioctl(struct inode *node, struct file *filp,
+				unsigned int cmd, unsigned long arg) P*A*Z*
+ *
+P* Parameters:   struct file *file
+P*                - Passed by the kernel, but not used
+P*               unsigned int cmd
+P*                - ioctl command number
+P*               unsigned long arg
+P*                - Pointer to arguments cast to unsigned long.
+P*                  The actual parameter depends on the command, see
+P*                  wd(4).
+P*
+P* Returnvalue:  int
+P*                 - 0 => success
+P*                  <0 Errorcondition, which can be
+P*                  -EINTR  the call was interrupted
+P*                  -EFAULT the pointer passed as arg is invalid
+P*                  -EINVAL a parameter was invalid
+ *
+Z* Intention:    This is the entry point for the ioctl() commands.
+Z*               For a detailed description see the man-page wd(4).
+ *
+D* Design:       Haider / wd@denx.de
+C* Coding:       Haider / wd@denx.de
+V* Verification: wd@denx.de / dzu@denx.de
+ ***********************************************************************/
+static long wd_ioctl(struct file *filp,
+				unsigned int cmd, unsigned long arg)
+{
+	struct wd_param param;
+	int chainid;
+
+	switch (cmd) {
+	case WD_OPEN_ONLY:
+		timeout_open_only = 1;
+		break;
+	case WD_ALWAYS:
+		timeout_open_only = 0;
+		break;
+	case WD_REGISTER:
+		if (copy_from_user(&param, (void *)arg, sizeof(param)))
+			return -EFAULT;
+		return register_mon_chain(&param, 1);
+	case WD_RESET:
+		if (copy_from_user(&chainid, (void *)arg,
+				sizeof(chainid)))
+			return -EFAULT;
+		return wd_reset_mon_chain(chainid);
+	case WD_UNREGISTER:
+		if (copy_from_user(&chainid, (void *)arg,
+				sizeof(chainid)))
+			return -EFAULT;
+		return wd_unregister_mon_chain(chainid);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/***********************************************************************
+F* Function:     void wd_cleanup(void) P*A*Z*
+ *
+P* Parameters:   none
+P*
+P* Returnvalue:  none
+ *
+Z* Intention:    Cleanup and shutdown the driver to allow unloading
+Z*               of the module.
+ *
+D* Design:       Haider / wd@denx.de
+C* Coding:       Haider / wd@denx.de
+V* Verification: wd@denx.de / dzu@denx.de
+ ***********************************************************************/
+void wd_cleanup(void)
+{
+	debugk("%s: cleanup WD\n", __func__);
+
+	misc_deregister(&wd_miscdev);
+	BUG_ON(wd_hw_functions.wd_delete == NULL);
+	wd_hw_functions.wd_delete();
+	del_timer(&wd_timer);
+	free_mon_list();
+}
+
+/***********************************************************************
+F* Function:     void wd_handler(unsigned long ptr) P*A*Z*
+ *
+P* Parameters:   unsigned long ptr
+P*                - Parameter passed in from the timer invocation, ignored
+P*
+P* Returnvalue:  none
+ *
+Z* Intention:    This is the core functionality of the watchdog.  It is
+Z*               called from the timer wd_timer and handles the necessary
+Z*               processing, including resetting the hardware watchdog.
+Z*               When chains are registered, they override the
+Z*               default behaviour and are processed in process_mon_chains().
+ *
+D* Design:       Haider / wd@denx.de
+C* Coding:       Haider / wd@denx.de
+V* Verification: wd@denx.de / dzu@denx.de
+ ***********************************************************************/
+void wd_handler(unsigned long ptr)
+{
+	debugk("%s: timer_count=%ld jiffies\n", __func__, timer_count);
+
+	if ((timer_count == 0) && enabled) {
+		printk(KERN_ERR "WD: Reseting system...\n");
+		BUG_ON(wd_hw_functions.wd_machine_restart == NULL);
+		wd_hw_functions.wd_machine_restart();
+	} else if ((timer_count > 0) || (!enabled)) {
+
+		/* execute WD service sequence */
+		BUG_ON(wd_hw_functions.wd_kick == NULL);
+		wd_hw_functions.wd_kick();
+
+		wd_timer.expires = jiffies + timer_period;
+		add_timer(&wd_timer);	/* ...re-activate timer */
+
+		/*
+		 * process the monitor list
+		 */
+		process_mon_chains();
+
+		/*
+		 * don't timeout if disabled
+		 */
+		if (!enabled)
+			return;
+
+		/* don't timeout if interface was never opened */
+		if (!opened)
+			return;
+		/*
+		 * don't timeout if new interface is used or if device
+		 * is not opened
+		 */
+		if (((timeout_open_only && (!device_open)) || mon_chains))
+			return;
+
+		/* decrement variable for timer-control */
+		if (timer_count > timer_period)
+			timer_count -= timer_period;
+		else
+			timer_count = 0;
+
+		if (timer_count == 0)
+			printk(KERN_INFO "WD: watchdog about to expire\n");
+	}
+
+	return;
+}
+
+/***********************************************************************
+F* Function:     static int register_mon_chain(wd_param_t *param,
+F*                                             int userproc) P*A*Z*
+ *
+P* Parameters:   wd_param_t *param
+P*                - The parameters for the chain to be registered.
+P*                  Unused stages should be cleared with 0's.
+P*               int userproc
+P*                - Flag whether we are called from user or kernel space
+P*
+P* Returnvalue:  int
+P*                - 0  success
+P*                  -EINVAL  invalid parameters
+P*                  -ENOMEM  out of memory
+ *
+Z* Intention:    This is the main interface to register a watchdog chain
+Z*               either from userspace throught ioctl() or from kernel
+Z*               space through the wrapper function
+Z*               wd_register_mon_chain().
+Z*               Re-registering an existing chain is explicitely ok, as
+Z*               a restarted process has to go through this.  This
+Z*               effectively resets the corresponding chain.
+Z*               For a detailed description of the parameters, see the
+Z*               wd(4) manpage.
+ *
+D* Design:       dzu@denx.de
+C* Coding:       dzu@denx.de
+V* Verification: wd@denx.de
+ ***********************************************************************/
+static int register_mon_chain(struct wd_param *param, int userproc)
+{
+	struct monitored_chain *entry;
+	int result = 0, i;
+
+	/* Before kzallocing storage we first check the parameters */
+	for (i = 0; (i < WD_MAX_USR_ACTIONS) && (param->timer_count[i]); i++)
+		if ((param->action[i] < WD_ACTION_SIGNAL) ||
+			(param->action[i] > WD_ACTION_RESET))
+			return -EINVAL;
+
+	debugk("%s: registering WD monitor\n", __func__);
+
+	spin_lock(&mon_lock);
+
+	entry = find_mon_chain_by_chainid(param->chainid);
+	if (entry == NULL) {
+		/* New chain-id so allocate list entry */
+		entry = kzalloc(sizeof(struct monitored_chain),	GFP_KERNEL);
+		if (entry == NULL) {
+			result = -ENOMEM;
+			goto out;
+		}
+
+		/* Copy request data to internal format */
+		if (userproc)
+			entry->pid = current->pid;
+		else
+			entry->pid = 0;
+		entry->chainid = param->chainid;
+		entry->signal = param->signal;
+		for (i = 0; i < WD_MAX_USR_ACTIONS; i++) {
+			if (param->action[i] != 0) {
+				entry->timer_count[i] = param->timer_count[i];
+				entry->action[i] = param->action[i];
+			} else {
+				/* Fill with stop entries */
+				entry->timer_count[i] = 2;
+				entry->action[i] = WD_ACTION_RESET;
+			}
+		}
+
+		/* This is a final stop entry */
+		entry->timer_count[WD_MAX_USR_ACTIONS] = 2;
+		entry->action[WD_MAX_USR_ACTIONS] = WD_ACTION_RESET;
+
+		/* Initialize internal data */
+		entry->escalation = 0;
+		entry->expires = jiffies + HZ * entry->timer_count[0];
+		insert_mon_chain(entry);
+		mon_chains++;
+	} else {
+		/* Re-registering of active monitor */
+		entry->pid = current->pid;
+		entry->escalation = 0;
+		entry->expires = jiffies + HZ * entry->timer_count[0];
+		list_del(&entry->list);
+		insert_mon_chain(entry);
+	}
+ out:
+	spin_unlock(&mon_lock);
+
+	return result;
+}
+
+/*
+ * The next three functions form the external interface for kernel modules
+ */
+
+/***********************************************************************
+F* Function:     int wd_register_mon_chain(wd_param_t *param) P*A*Z*
+ *
+P* Parameters:   wd_param_t *param
+P*
+P* Returnvalue:  int
+P*                - See description of register_mon_chain()
+ *
+Z* Intention:    This is only a wrapper function around register_mon_chain()
+Z*               exported to the kernel name space.  It only augments the
+Z*               parameter with a flag informing register_mon_chain() that
+Z*               it was called through this interface and not from a
+Z*               user space program.
+ *
+D* Design:       dzu@denx.de
+C* Coding:       dzu@denx.de
+V* Verification: wd@denx.de
+ ***********************************************************************/
+int wd_register_mon_chain(struct wd_param *param)
+{
+	return register_mon_chain(param, 0);
+}
+EXPORT_SYMBOL(wd_register_mon_chain);
+
+/***********************************************************************
+F* Function:     int wd_unregister_mon_chain(unsigned int chainid) P*A*Z*
+ *
+P* Parameters:   unsigned int chainid
+P*                - The id of the chain to unregister
+P*
+P* Returnvalue:  int
+P*                - 0 The chain was unregistered successfully
+P*                  -EINVAL  The chainid is unknown
+ *
+Z* Intention:    When the watchdog functionality is no longer needed,
+Z*               chains can be unregistered through this call.
+Z*               The function is called through the ioctl() mechanism
+Z*               or directly from other kernel proper, as it is exported.
+ *
+D* Design:       dzu@denx.de
+C* Coding:       dzu@denx.de
+V* Verification: wd@denx.de
+ ***********************************************************************/
+int wd_unregister_mon_chain(unsigned int chainid)
+{
+	struct monitored_chain *entry;
+
+	entry = find_mon_chain_by_chainid(chainid);
+	if (entry == NULL)
+		return -EINVAL;
+
+	debugk("%s: WD unregistering monitor for id %d\n", __func__,
+		entry->chainid);
+
+	spin_lock(&mon_lock);
+
+	list_del(&entry->list);
+	kfree(entry);
+	mon_chains--;
+
+	spin_unlock(&mon_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(wd_unregister_mon_chain);
+
+/***********************************************************************
+F* Function:     int wd_reset_mon_chain(int chainid) P*A*Z*
+ *
+P* Parameters:   int chainid
+P*                - The id of the chain to reset
+P*
+P* Returnvalue:  int
+P*                - 0 The chain was reset suiccessfully
+P*                 <0 Errorcondition, which can be
+P*                  -EINVAL The supplied id is unknown.
+ *
+Z* Intention:    This function resets a chain to its initial state.
+Z*               The function is called through the ioctl() mechanism
+Z*               to reset or trigger a chain or directly from other
+Z*               kernel proper, as it is exported.
+ *
+D* Design:       dzu@denx.de
+C* Coding:       dzu@denx.de
+V* Verification: wd@denx.de
+ ***********************************************************************/
+int wd_reset_mon_chain(int chainid)
+{
+	struct monitored_chain *entry;
+	int result = 0;
+
+	debugk("%s: WD monitor reset for id %d\n", __func__, chainid);
+
+	spin_lock(&mon_lock);
+
+	entry = find_mon_chain_by_chainid(chainid);
+	if (entry == NULL) {
+		result = -EINVAL;
+		goto out;
+	}
+	entry->escalation = 0;
+	entry->expires = jiffies + HZ * entry->timer_count[0];
+	list_del(&entry->list);
+	insert_mon_chain(entry);
+out:
+	spin_unlock(&mon_lock);
+
+	return result;
+}
+EXPORT_SYMBOL(wd_reset_mon_chain);
+
+/***********************************************************************
+F* Function:     static void free_mon_list(void) P*A*Z*
+ *
+P* Parameters:   none
+P*
+P* Returnvalue:  none
+ *
+Z* Intention:    This function frees the entire kzalloc'ed list of
+Z*               monitored chains in case the module is unloaded.
+ *
+D* Design:       dzu@denx.de
+C* Coding:       dzu@denx.de
+V* Verification: wd@denx.de
+ ***********************************************************************/
+static void free_mon_list(void)
+{
+	struct list_head *ptr, *n;
+	struct monitored_chain *entry;
+
+	debugk("%s: WD freeing monitor list\n", __func__);
+
+	spin_lock(&mon_lock);
+
+	for (ptr = mon_list.next, n = ptr->next; ptr != &mon_list; ptr = n) {
+		entry = list_entry(ptr, struct monitored_chain, list);
+		kfree(entry);
+	}
+
+	spin_unlock(&mon_lock);
+}
+
+/***********************************************************************
+F* Function:     static int process_mon_chains(void) P*A*Z*
+ *
+P* Parameters:   none
+P*
+P* Returnvalue:  int
+P*                - 0 if the function returns at all
+ *
+Z* Intention:    This is the core function of the chain functionality.
+Z*               The list with the monitored chain is processed and
+Z*               expired entries handled appropriately by stepping up
+Z*               the escalation ladder.  The escalation actions are
+Z*               triggered from here.
+ *
+D* Design:       dzu@denx.de
+C* Coding:       dzu@denx.de
+V* Verification: wd@denx.de
+ ***********************************************************************/
+static int process_mon_chains(void)
+{
+	struct list_head *ptr;
+	struct monitored_chain *entry;
+	int sig;
+
+	spin_lock(&mon_lock);
+
+	for (ptr = mon_list.next; ptr != &mon_list; ptr = ptr->next) {
+		entry = list_entry(ptr, struct  monitored_chain, list);
+		if (time_after_eq(jiffies, entry->expires)) {
+			debugk("%s: WD monitor expired for id %d\n",
+				__func__, entry->chainid);
+			switch (entry->action[entry->escalation]) {
+			case WD_ACTION_SIGNAL:
+				debugk("WD: sending user signal for key "
+					"%d...\n", entry->chainid);
+				sig = (entry->signal) ? entry->signal : SIGTERM;
+				if (entry->pid)
+					kill_proc_info(sig, SEND_SIG_PRIV,
+						entry->pid);
+				break;
+			case WD_ACTION_KILL:
+				debugk("WD: sending KILL signal for key "
+					"%d...\n", entry->chainid);
+				if (entry->pid)
+					kill_proc_info(SIGKILL,
+						SEND_SIG_PRIV, entry->pid);
+				break;
+			case WD_ACTION_REBOOT:
+				spin_unlock(&mon_lock);
+				wd_unregister_mon_chain(entry->chainid);
+				printk(KERN_ERR "WD: Rebooting system for key "
+					"%d...\n", entry->chainid);
+				flush_cache_all();
+				/*
+				 * XXX This is not safe to call in interrupt
+				 * context.
+				 */
+				sys_reboot(LINUX_REBOOT_MAGIC1,
+					LINUX_REBOOT_MAGIC2,
+					LINUX_REBOOT_CMD_RESTART,
+					NULL);
+				break;
+			case WD_ACTION_RESET:
+				printk("WD: Resetting system for key "
+					"%d...\n", entry->chainid);
+				BUG_ON(wd_hw_functions.wd_machine_restart
+					== NULL);
+				wd_hw_functions.wd_machine_restart();
+				break;
+
+			default:
+				debugk("WD: undefined action %d\n",
+					entry->action[entry->escalation]);
+				break;
+			}
+			entry->escalation++;
+			entry->expires = jiffies + HZ *
+				entry->timer_count[entry->escalation];
+			list_del(&entry->list);
+			insert_mon_chain(entry);
+		} else
+			/* The list is sorted, so we can stop here */
+			break;
+	}
+
+	spin_unlock(&mon_lock);
+
+	return 0;
+}
+
+/***********************************************************************
+F* Function:     static struct monitored_chain *find_mon_chain_by_chainid(
+				unsigned int id) P*A*Z*
+ *
+P* Parameters:   unsigned int id
+P*                - The ID of the chain to find
+P*
+P* Returnvalue:  struct monitored_chain *
+P*                - The entry for the chain with id id, or NULL if not
+P*                  found
+ *
+Z* Intention:    Find an entry in the list of monitored chains by
+Z*               searching for a specified id.
+ *
+D* Design:       dzu@denx.de
+C* Coding:       dzu@denx.de
+V* Verification: wd@denx.de
+ ***********************************************************************/
+static struct monitored_chain *find_mon_chain_by_chainid(unsigned int id)
+{
+	struct list_head *ptr;
+	struct monitored_chain *entry;
+
+	for (ptr = mon_list.next; ptr != &mon_list; ptr = ptr->next) {
+		entry = list_entry(ptr, struct monitored_chain, list);
+		if (entry->chainid == id)
+			return entry;
+	}
+	return NULL;
+}
+
+/***********************************************************************
+F* Function:     static void insert_mon_chain(struct monitored_chain *new) P*A*Z*
+ *
+P* Parameters:   struct monitored_chain *new
+P*                - The entry to insert into the list
+P*
+P* Returnvalue:  none
+ *
+Z* Intention:    Insert an entry for a monitor chain at the correct
+Z*               position into the module-global list.  Keeping the
+Z*               list sorted with respect to the expiratoin avoids
+Z*               unneccessary processing.
+ *
+D* Design:       dzu@denx.de
+C* Coding:       dzu@denx.de
+V* Verification: wd@denx.de
+ ***********************************************************************/
+static void insert_mon_chain(struct monitored_chain *new)
+{
+	struct list_head *ptr;
+	struct monitored_chain *entry;
+
+	for (ptr = mon_list.next; ptr != &mon_list; ptr = ptr->next) {
+		entry = list_entry(ptr, struct monitored_chain, list);
+		if (time_after_eq(entry->expires, new->expires)) {
+			list_add_tail(&new->list, ptr);
+			return;
+		}
+	}
+	list_add_tail(&new->list, &mon_list);
+}
+
+#if defined(CONFIG_LWMON5)
+/*
+ * Call wd_init very early on LWMON5 platform since it's timeout is very short.
+ */
+subsys_initcall(wd_init);
+#else
+module_init(wd_init);
+#endif
+module_exit(wd_cleanup);
diff --git a/drivers/watchdog/wd_davinci.c b/drivers/watchdog/wd_davinci.c
new file mode 100644
index 0000000..a44dfee
--- /dev/null
+++ b/drivers/watchdog/wd_davinci.c
@@ -0,0 +1,146 @@
+/*
+ * (C) Copyright 2011
+ * Heiko Schocher, DENX Software Engineering, hs@denx.de.
+ *
+ * (C) Copyright 2004, 2007
+ * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
+ *
+ * Adapted to Linux 2.6 by Piotr Kruszynski <ppk@semihalf.com>:
+ * - separated generic and hardware dependent functions
+ * - automatic calculations of gpt prescale value based on IPB
+ * - code cleanup
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/reboot.h>
+#include <linux/wd.h>
+#include <mach/da8xx.h>
+
+/*
+ * This file implements low-level functions to access watchdog timer
+ * on Davinci platform for generic watchdog driver.
+ */
+
+/* trigger period in jiffies, setup from DTS */
+unsigned long	trigger_period;
+
+/* Timer register offsets */
+#define PID12			0x0
+#define TIM12			0x10
+#define TIM34			0x14
+#define PRD12			0x18
+#define PRD34			0x1c
+#define TCR			0x20
+#define TGCR			0x24
+#define WDTCR			0x28
+
+static void __iomem *timer_addr;
+/*
+ * This function performs watchdog timer initialization.
+ * Argument tpp is period for re-trigger (in jiffies).
+ */
+int wd_davinci_init(unsigned long *tpp)
+{
+	*tpp = trigger_period;
+
+	return 0;
+}
+
+/*
+ * This function resets watchdog counter.
+ */
+void wd_davinci_kick(void)
+{
+	writel(0xa5c64000, timer_addr + WDTCR);
+	writel(0xda7e4000, timer_addr + WDTCR);
+}
+
+/*
+ * This function stops watchdog timer
+ */
+void wd_davinci_delete(void)
+{
+}
+
+/*
+ * This function performs emergency reboot.
+ */
+void wd_davinci_machine_restart(void)
+{
+	machine_restart(NULL);
+}
+
+void davinci_watchdog_reset(struct platform_device *pdev)
+{
+	/*
+	 * write an invalid value to the WDKEY field to trigger
+	 * a watchdog reset
+	 */
+	writel(0x00004000, timer_addr + WDTCR);
+}
+
+static const struct of_device_id __devinitconst wd_davinci_match[] = {
+	{
+		.compatible = "ti,davinci-wdt",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, wd_davinci_match);
+
+static int __devinit wd_davinci_probe(struct platform_device *ofdev)
+{
+	struct device_node *np = of_node_get(ofdev->dev.of_node);
+	const u32 *data;
+	int len;
+
+	timer_addr = of_iomap(np, 0);
+	data = of_get_property(np, "period", &len);
+	if (data)
+		trigger_period = be32_to_cpu(readl(data));
+
+	wd_set_hw_func(wd_davinci_init, wd_davinci_kick, wd_davinci_delete,
+		wd_davinci_machine_restart);
+	return 0;
+}
+
+static int __devexit wd_davinci_remove(struct platform_device *ofdev)
+{
+	return 0;
+}
+
+static struct platform_driver wd_davinci_driver = {
+	.driver = {
+		.name = "ti,davinci-wdt",
+		.of_match_table = wd_davinci_match,
+		.owner = THIS_MODULE,
+	},
+	.probe = wd_davinci_probe,
+	.remove = __devexit_p(wd_davinci_remove),
+};
+
+static int __init wd_davinci_init_hwl(void)
+{
+	return platform_driver_register(&wd_davinci_driver);
+}
+subsys_initcall(wd_davinci_init_hwl);
diff --git a/include/linux/wd.h b/include/linux/wd.h
new file mode 100644
index 0000000..c92a341
--- /dev/null
+++ b/include/linux/wd.h
@@ -0,0 +1,131 @@
+/***********************************************************************
+ *
+ * (C) Copyright 2004, 2007
+ * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
+ *
+ * Adapted to Linux 2.6 by Piotr Kruszynski <ppk@semihalf.com>:
+ * - separated generic and hardware dependent functions
+ * - code cleanup
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ ***********************************************************************/
+/*
+ * The purpose of this header file is to provide an interface for the
+ * driver of the watchdog timer wd. In essence this interface
+ * consists of the three macros WD_INIT, WD_SERVICE,
+ * WD_CLOSE, and its functionality is described as follows:
+ *
+ * WD_INIT:     opens the driver and initializes the timer to
+ *                      300 seconds;
+ *
+ * WD_SERVICE:  writes the value defined by the macro
+ *                      WD_DEF_SERVICE_TIME to the variable,
+ *                      which serves as a timer counter;
+ *
+ * WD_CLOSE:    closes the watchdog driver;
+ *
+ * Finally there is a macro called WD_SET_SERVICE_TIME(sec)
+ * for altering the value written to the timer counter to a value,
+ * which is specified by sec.
+ */
+
+#ifndef _LINUX_WD_H
+#define _LINUX_WD_H
+
+#define WD_MAX_USR_ACTIONS 3
+
+struct wd_param {
+	unsigned chainid;
+	unsigned long timer_count[WD_MAX_USR_ACTIONS];
+	int action[WD_MAX_USR_ACTIONS];
+	int signal;
+};
+
+/* Constants for the action[] fields */
+#define WD_ACTION_SIGNAL  1
+#define WD_ACTION_KILL    2
+#define WD_ACTION_REBOOT  3
+#define WD_ACTION_RESET   4
+
+#define WD_IOCTL_BASE	'W'
+
+#define WD_OPEN_ONLY	_IO(WD_IOCTL_BASE, 0)
+#define WD_ALWAYS	_IO(WD_IOCTL_BASE, 1)
+#define WD_REGISTER	_IOW(WD_IOCTL_BASE, 2, struct wd_param)
+#define WD_RESET	_IOW(WD_IOCTL_BASE, 3, int)
+#define WD_UNREGISTER	_IOW(WD_IOCTL_BASE, 4, int)
+
+#ifdef __KERNEL__
+
+/*
+ * wd_init_t - initialization of watchdog driver and activation timer
+ * wd_kick_t - reset watchdog counter
+ * wd_delete_t - stop watchdog timer and free resources
+ * wd_machine_restart_t - emergency restart
+ *
+ * NOTE: Functions wd_kick_t and wd_machine_restart_t can be called from
+ * interrupt context.
+ */
+typedef int (wd_init_t)(unsigned long *);
+typedef void (wd_kick_t)(void);
+typedef void (wd_delete_t)(void);
+typedef void (wd_machine_restart_t)(void);
+
+struct wd_hw_functions {
+	wd_init_t		*wd_init;
+	wd_kick_t		*wd_kick;
+	wd_delete_t		*wd_delete;
+	wd_machine_restart_t	*wd_machine_restart;
+};
+
+struct monitored_chain {
+	struct list_head list;
+	unsigned int chainid;
+	pid_t pid;
+	int escalation;
+	unsigned long expires;
+	unsigned long timer_count[WD_MAX_USR_ACTIONS + 1];
+	int action[WD_MAX_USR_ACTIONS + 1];
+	int signal;
+};
+
+void wd_set_hw_func(wd_init_t *wd_init, wd_kick_t *wd_kick,
+	wd_delete_t *wd_delete, wd_machine_restart_t *wd_machine_restart);
+
+#else /* !__KERNEL__ */
+
+#include <fcntl.h>
+#include <unistd.h>
+#include <linux/ioctl.h>
+
+#define WD_DEVICE "/dev/watchdog"
+#define WD_DEF_SERVICE_TIME 300
+
+int wd_fd;
+int wd_value = WD_DEF_SERVICE_TIME;
+
+#define WD_INIT (wd_fd = open(WD_DEVICE, O_RDWR, 0))
+
+#define WD_SET_SERVICE_TIME(sec) wd_value = (sec);
+
+#define WD_SERVICE write(wd_fd, (char *) &wd_value, sizeof(wd_value))
+
+#define WD_CLOSE close(wd_fd)
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_WD_H */
diff --git a/include/linux/wd_hw.h b/include/linux/wd_hw.h
new file mode 100644
index 0000000..e28b76e
--- /dev/null
+++ b/include/linux/wd_hw.h
@@ -0,0 +1,55 @@
+/***********************************************************************
+ *
+ * (C) Copyright 2007 Semihalf, Piotr Kruszynski <ppk@semihalf.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ ***********************************************************************/
+
+#ifndef _LINUX_WD_HW_H
+#define _LINUX_WD_HW_H
+#ifdef CONFIG_WD
+
+#include <linux/wd.h>
+
+/*
+ * This file provide declaration of functions exported by low-level
+ * watchdog drivers. Pointers to this functions are passed to
+ * wd_hw_functions structure (see include/linux/wd.h) before
+ * generic watchdog driver start.
+ *
+ * Each function set should have following declaration structure:
+ *
+ * #ifdef CONFIG_WD_XXXX
+ * extern wd_init_t		wd_xxxx_init;
+ * extern wd_kick_t		wd_xxxx_kick;
+ * extern wd_delete_t		wd_xxxx_delete;
+ * extern wd_machine_restart_t	wd_xxxx_machine_restart;
+ * #endif /_* CONFIG_WD_XXXX *_/
+ *
+ * Where xxxx and XXXX is low-level driver name and CONFIG_WD_XXXX
+ * is name of option added to drivers/char/watchdog/Kconfig. Additional
+ * informations about wd_*_t functions are in include/linux/wd.h.
+ */
+#ifdef CONFIG_WD_DAVINCI
+extern wd_init_t		wd_davinci_init;
+extern wd_kick_t		wd_davinci_kick;
+extern wd_delete_t		wd_davinci_delete;
+extern wd_machine_restart_t	wd_davinci_machine_restart;
+#endif
+
+#endif /* CONFIG_WD */
+#endif /* !_LINUX_WD_HW_H */
-- 
1.7.6.4

