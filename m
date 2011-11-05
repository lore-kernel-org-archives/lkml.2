Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab1KEUox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 16:44:53 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:41310 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243Ab1KEUov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 16:44:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEFAM+etU5R8iJB/2dsb2JhbAA6Cac1gTeBH4EGghMBDBMcDwQBDxgXRg0YAwoXExsDh2YGs2YShWmCTWMEnl+HLw
Date: Sat, 5 Nov 2011 21:42:07 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Greg Lee <glee@swspec.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Venkat Subbiah <venkat.subbiah@cavium.com>, Sean Young <sean@mess.org>
Subject: [GIT PULL REQUEST] watchdog - v3.2 - Patches for Merge Window.
Message-ID: <20111105204207.GB22171@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This will update the following files:

 Documentation/watchdog/convert_drivers_to_kernel_api.txt |  177 ++++++++
 drivers/watchdog/Kconfig                                 |    2 
 drivers/watchdog/coh901327_wdt.c                         |    2 
 drivers/watchdog/eurotechwdt.c                           |    2 
 drivers/watchdog/iTCO_wdt.c                              |   19 
 drivers/watchdog/mpcore_wdt.c                            |    3 
 drivers/watchdog/octeon-wdt-main.c                       |    2 
 drivers/watchdog/s3c2410_wdt.c                           |  176 +-------
 drivers/watchdog/sb_wdog.c                               |    4 
 drivers/watchdog/sc520_wdt.c                             |    2 
 drivers/watchdog/w83627hf_wdt.c                          |   33 +
 drivers/watchdog/wdt.c                                   |    2 
 drivers/watchdog/wdt_pci.c                               |    2 
 drivers/watchdog/wm831x_wdt.c                            |  318 ++++-----------
 14 files changed, 370 insertions(+), 374 deletions(-)

with these Changes:

commit 00411ee9308e4b5f4b04caaa01685f955e259373
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Tue Oct 4 16:43:40 2011 +0100

    watchdog: Convert wm831x driver to watchdog core
    
    Fairly large code churn but not much doing with that and the overall
    result is a definite win.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 25dc46e3837cd01dc1742eefb73d064f6336850f
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Mon Sep 26 15:40:14 2011 +0200

    watchdog: s3c2410: convert to use the watchdog framework
    
    Make this driver a user of the watchdog framework and remove now
    centrally handled parts. Tested on a mini2440.
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 74cd4c67392c1cee0499ba0977ec843252c7af28
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Mon Sep 26 15:40:13 2011 +0200

    Documentation: watchdog: add guide how to convert drivers to new framework
    
    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Cc: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit deb9197b7031b8f4ed311dc47a14363da4458544
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Oct 19 23:59:26 2011 +0200

    watchdog: iTCO_wdt.c - problems with newer hardware due to SMI clearing
    
    Redhat Bugzilla: Bug 727875 - TCO_EN bit is disabled by TCO driver
    Jiri Slaby: 28d41f53f broke temperature sensors on a ICH10 chipset
    
    The iTCO_wdt driver disables the SMI. This breaks good working of newer hardware.
    The disabling of the SMI by the TCO logic dates back from the i810-tco driver
    from Nils Faerber (around 28 July 2000). The reason for this was that some BIOSes
    install handlers reset or disable the watchdog timer instead of resetting the system.
    The trick to fix this was to disable the SMI (by clearing the SMI_TCO_EN bit of the
    SMI_EN register) to prevent this from happening.
    
    This however has strange effects on newer hardware. So we are in a situation that
    a fix for broken old hardware affects newer hardware.
    
    The correct solution is to make this fix an option (with the new module parameter:
    turn_SMI_watchdog_clear_off) so that the default behaviour is the unfixed version.
    
    the next patch will be to move this in the start and stop functions of the driver
    and to add a new module parameter for the global_smi_en bit and to get rid of the
    vendor_support code.
    
    This fix can have an effect on old (typical ICH & ICH2 chipsets) motherboards that
    have a broken BIOS implementation concerning TCO logic. In these case the module
    parameter turn_SMI_watchdog_clear_off=1 will need to be added.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit c63b6d02be22899a5c8d47b8ee40e0534cd01a43
Author: Greg Lee <glee@swspec.com>
Date:   Mon Sep 12 20:28:46 2011 -0400

    watchdog: Add WDIOC_GETTIMELEFT ioctl support to w83627 watchdog driver
    
    Add WDIOC_GETTIMELEFT ioctl allowing you to check how much time is left
    on the watchdog counter before a reset occurs.
    
    Signed-off-by: Greg Lee <glee [at] swspec.com>
    Signed-off-by: Padraig Brady <P@draigbrady.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@google.com>

commit 86b5912880453532440358b1486410ad49ef7672
Author: Yong Zhang <yong.zhang0@gmail.com>
Date:   Wed Sep 7 16:10:55 2011 +0800

    watchdog: irq: Remove IRQF_DISABLED
    
    This flag is a NOOP and can be removed now.
    
    Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
    Acked-by: Wolfram Sang <w.sang@pengutronix.de>
    Acked-by: Linus Walleij <linus.walleij@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 47bfd058132e6da2a582b85033867ce8b9f5f331
Author: Venkat Subbiah <venkat.subbiah@cavium.com>
Date:   Mon Oct 3 17:22:04 2011 -0700

    watchdog: Octeon: Mark octeon_wdt interrupt as IRQF_NO_THREAD
    
    This is to exclude it from force threading to allow RT patch set to work.
    
    The watchdog timers are per-CPU and the addresses of register that reset
    the timer are calculated based on the current CPU.  Therefore we cannot
    allow it to run on a thread on a different CPU.  Also we only do a
    single register write, which is much faster than scheduling a handler
    thread.
    
    And while on this line remove IRQF_DISABLED as this flag is a NOP.
    
    Signed-off-by: Venkat Subbiah<venkat.subbiah@cavium.com>
    Acked-by: David Daney<david.daney@cavium.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit cef153a8d41195f69314d93d4b2b7395e263a3a1
Author: Sean Young <sean@mess.org>
Date:   Tue Aug 23 22:30:09 2011 +0100

    watchdog: sc520_wdt: Remove unnecessary cast.
    
    Signed-off-by: Sean Young <sean@mess.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/watchdog/convert_drivers_to_kernel_api.txt b/Documentation/watchdog/convert_drivers_to_kernel_api.txt
new file mode 100644
index 0000000..ae1e900
--- /dev/null
+++ b/Documentation/watchdog/convert_drivers_to_kernel_api.txt
@@ -0,0 +1,195 @@
+Converting old watchdog drivers to the watchdog framework
+by Wolfram Sang <w.sang@pengutronix.de>
+=========================================================
+
+Before the watchdog framework came into the kernel, every driver had to
+implement the API on its own. Now, as the framework factored out the common
+components, those drivers can be lightened making it a user of the framework.
+This document shall guide you for this task. The necessary steps are described
+as well as things to look out for.
+
+
+Remove the file_operations struct
+---------------------------------
+
+Old drivers define their own file_operations for actions like open(), write(),
+etc... These are now handled by the framework and just call the driver when
+needed. So, in general, the 'file_operations' struct and assorted functions can
+go. Only very few driver-specific details have to be moved to other functions.
+Here is a overview of the functions and probably needed actions:
+
+- open: Everything dealing with resource management (file-open checks, magic
+  close preparations) can simply go. Device specific stuff needs to go to the
+  driver specific start-function. Note that for some drivers, the start-function
+  also serves as the ping-function. If that is the case and you need start/stop
+  to be balanced (clocks!), you are better off refactoring a separate start-function.
+
+- close: Same hints as for open apply.
+
+- write: Can simply go, all defined behaviour is taken care of by the framework,
+  i.e. ping on write and magic char ('V') handling.
+
+- ioctl: While the driver is allowed to have extensions to the IOCTL interface,
+  the most common ones are handled by the framework, supported by some assistance
+  from the driver:
+
+	WDIOC_GETSUPPORT:
+		Returns the mandatory watchdog_info struct from the driver
+
+	WDIOC_GETSTATUS:
+		Needs the status-callback defined, otherwise returns 0
+
+	WDIOC_GETBOOTSTATUS:
+		Needs the bootstatus member properly set. Make sure it is 0 if you
+		don't have further support!
+
+	WDIOC_SETOPTIONS:
+		No preparations needed
+
+	WDIOC_KEEPALIVE:
+		If wanted, options in watchdog_info need to have WDIOF_KEEPALIVEPING
+		set
+
+	WDIOC_SETTIMEOUT:
+		Options in watchdog_info need to have WDIOF_SETTIMEOUT set
+		and a set_timeout-callback has to be defined. The core will also
+		do limit-checking, if min_timeout and max_timeout in the watchdog
+		device are set. All is optional.
+
+	WDIOC_GETTIMEOUT:
+		No preparations needed
+
+  Other IOCTLs can be served using the ioctl-callback. Note that this is mainly
+  intended for porting old drivers; new drivers should not invent private IOCTLs.
+  Private IOCTLs are processed first. When the callback returns with
+  -ENOIOCTLCMD, the IOCTLs of the framework will be tried, too. Any other error
+  is directly given to the user.
+
+Example conversion:
+
+-static const struct file_operations s3c2410wdt_fops = {
+-       .owner          = THIS_MODULE,
+-       .llseek         = no_llseek,
+-       .write          = s3c2410wdt_write,
+-       .unlocked_ioctl = s3c2410wdt_ioctl,
+-       .open           = s3c2410wdt_open,
+-       .release        = s3c2410wdt_release,
+-};
+
+Check the functions for device-specific stuff and keep it for later
+refactoring. The rest can go.
+
+
+Remove the miscdevice
+---------------------
+
+Since the file_operations are gone now, you can also remove the 'struct
+miscdevice'. The framework will create it on watchdog_dev_register() called by
+watchdog_register_device().
+
+-static struct miscdevice s3c2410wdt_miscdev = {
+-       .minor          = WATCHDOG_MINOR,
+-       .name           = "watchdog",
+-       .fops           = &s3c2410wdt_fops,
+-};
+
+
+Remove obsolete includes and defines
+------------------------------------
+
+Because of the simplifications, a few defines are probably unused now. Remove
+them. Includes can be removed, too. For example:
+
+- #include <linux/fs.h>
+- #include <linux/miscdevice.h> (if MODULE_ALIAS_MISCDEV is not used)
+- #include <linux/uaccess.h> (if no custom IOCTLs are used)
+
+
+Add the watchdog operations
+---------------------------
+
+All possible callbacks are defined in 'struct watchdog_ops'. You can find it
+explained in 'watchdog-kernel-api.txt' in this directory. start(), stop() and
+owner must be set, the rest are optional. You will easily find corresponding
+functions in the old driver. Note that you will now get a pointer to the
+watchdog_device as a parameter to these functions, so you probably have to
+change the function header. Other changes are most likely not needed, because
+here simply happens the direct hardware access. If you have device-specific
+code left from the above steps, it should be refactored into these callbacks.
+
+Here is a simple example:
+
++static struct watchdog_ops s3c2410wdt_ops = {
++       .owner = THIS_MODULE,
++       .start = s3c2410wdt_start,
++       .stop = s3c2410wdt_stop,
++       .ping = s3c2410wdt_keepalive,
++       .set_timeout = s3c2410wdt_set_heartbeat,
++};
+
+A typical function-header change looks like:
+
+-static void s3c2410wdt_keepalive(void)
++static int s3c2410wdt_keepalive(struct watchdog_device *wdd)
+ {
+...
++
++       return 0;
+ }
+
+...
+
+-       s3c2410wdt_keepalive();
++       s3c2410wdt_keepalive(&s3c2410_wdd);
+
+
+Add the watchdog device
+-----------------------
+
+Now we need to create a 'struct watchdog_device' and populate it with the
+necessary information for the framework. The struct is also explained in detail
+in 'watchdog-kernel-api.txt' in this directory. We pass it the mandatory
+watchdog_info struct and the newly created watchdog_ops. Often, old drivers
+have their own record-keeping for things like bootstatus and timeout using
+static variables. Those have to be converted to use the members in
+watchdog_device. Note that the timeout values are unsigned int. Some drivers
+use signed int, so this has to be converted, too.
+
+Here is a simple example for a watchdog device:
+
++static struct watchdog_device s3c2410_wdd = {
++       .info = &s3c2410_wdt_ident,
++       .ops = &s3c2410wdt_ops,
++};
+
+
+Register the watchdog device
+----------------------------
+
+Replace misc_register(&miscdev) with watchdog_register_device(&watchdog_dev).
+Make sure the return value gets checked and the error message, if present,
+still fits. Also convert the unregister case.
+
+-       ret = misc_register(&s3c2410wdt_miscdev);
++       ret = watchdog_register_device(&s3c2410_wdd);
+
+...
+
+-       misc_deregister(&s3c2410wdt_miscdev);
++       watchdog_unregister_device(&s3c2410_wdd);
+
+
+Update the Kconfig-entry
+------------------------
+
+The entry for the driver now needs to select WATCHDOG_CORE:
+
++       select WATCHDOG_CORE
+
+
+Create a patch and send it to upstream
+--------------------------------------
+
+Make sure you understood Documentation/SubmittingPatches and send your patch to
+linux-watchdog@vger.kernel.org. We are looking forward to it :)
+
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 64c6752..6285867 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -66,6 +66,7 @@ config SOFT_WATCHDOG
 config WM831X_WATCHDOG
 	tristate "WM831x watchdog"
 	depends on MFD_WM831X
+	select WATCHDOG_CORE
 	help
 	  Support for the watchdog in the WM831x AudioPlus PMICs.  When
 	  the watchdog triggers the system will be reset.
@@ -170,6 +171,7 @@ config HAVE_S3C2410_WATCHDOG
 config S3C2410_WATCHDOG
 	tristate "S3C2410 Watchdog"
 	depends on ARCH_S3C2410 || HAVE_S3C2410_WATCHDOG
+	select WATCHDOG_CORE
 	help
 	  Watchdog timer block in the Samsung SoCs. This will reboot
 	  the system when the timer expires with the watchdog enabled.
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 9291506..03f449a 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -429,7 +429,7 @@ static int __init coh901327_probe(struct platform_device *pdev)
 	writew(U300_WDOG_SR_RESET_STATUS_RESET, virtbase + U300_WDOG_SR);
 
 	irq = platform_get_irq(pdev, 0);
-	if (request_irq(irq, coh901327_interrupt, IRQF_DISABLED,
+	if (request_irq(irq, coh901327_interrupt, 0,
 			DRV_NAME " Bark", pdev)) {
 		ret = -EIO;
 		goto out_no_irq;
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index f1d1da6..41018d4 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -427,7 +427,7 @@ static int __init eurwdt_init(void)
 {
 	int ret;
 
-	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
+	ret = request_irq(irq, eurwdt_interrupt, 0, "eurwdt", NULL);
 	if (ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
 		goto out;
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 751a591..ba6ad66 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -1,7 +1,7 @@
 /*
  *	intel TCO Watchdog Driver
  *
- *	(c) Copyright 2006-2010 Wim Van Sebroeck <wim@iguana.be>.
+ *	(c) Copyright 2006-2011 Wim Van Sebroeck <wim@iguana.be>.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -44,7 +44,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
-#define DRV_VERSION	"1.06"
+#define DRV_VERSION	"1.07"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -384,6 +384,11 @@ MODULE_PARM_DESC(nowayout,
 	"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+static int turn_SMI_watchdog_clear_off = 0;
+module_param(turn_SMI_watchdog_clear_off, int, 0);
+MODULE_PARM_DESC(turn_SMI_watchdog_clear_off,
+	"Turn off SMI clearing watchdog (default=0)");
+
 /*
  * Some TCO specific functions
  */
@@ -808,10 +813,12 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 		ret = -EIO;
 		goto out_unmap;
 	}
-	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
-	val32 = inl(SMI_EN);
-	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
-	outl(val32, SMI_EN);
+	if (turn_SMI_watchdog_clear_off) {
+		/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
+		val32 = inl(SMI_EN);
+		val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
+		outl(val32, SMI_EN);
+	}
 
 	/* The TCO I/O registers reside in a 32-byte range pointed to
 	   by the TCOBASE value */
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 4dc3102..82ccd36 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -367,8 +367,7 @@ static int __devinit mpcore_wdt_probe(struct platform_device *dev)
 		goto err_misc;
 	}
 
-	ret = request_irq(wdt->irq, mpcore_wdt_fire, IRQF_DISABLED,
-							"mpcore_wdt", wdt);
+	ret = request_irq(wdt->irq, mpcore_wdt_fire, 0, "mpcore_wdt", wdt);
 	if (ret) {
 		dev_printk(KERN_ERR, wdt->dev,
 			"cannot register IRQ%d for watchdog\n", wdt->irq);
diff --git a/drivers/watchdog/octeon-wdt-main.c b/drivers/watchdog/octeon-wdt-main.c
index 945ee83..7c0d863 100644
--- a/drivers/watchdog/octeon-wdt-main.c
+++ b/drivers/watchdog/octeon-wdt-main.c
@@ -402,7 +402,7 @@ static void octeon_wdt_setup_interrupt(int cpu)
 	irq = OCTEON_IRQ_WDOG0 + core;
 
 	if (request_irq(irq, octeon_wdt_poke_irq,
-			IRQF_DISABLED, "octeon_wdt", octeon_wdt_poke_irq))
+			IRQF_NO_THREAD, "octeon_wdt", octeon_wdt_poke_irq))
 		panic("octeon_wdt: Couldn't obtain irq %d", irq);
 
 	cpumask_set_cpu(cpu, &irq_enabled_cpus);
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 30da88f..5de7e4f 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -27,9 +27,8 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/timer.h>
-#include <linux/miscdevice.h>
+#include <linux/miscdevice.h> /* for MODULE_ALIAS_MISCDEV */
 #include <linux/watchdog.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
@@ -38,6 +37,7 @@
 #include <linux/io.h>
 #include <linux/cpufreq.h>
 #include <linux/slab.h>
+#include <linux/err.h>
 
 #include <mach/map.h>
 
@@ -74,14 +74,12 @@ MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, "
 			"0 to reboot (default 0)");
 MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
 
-static unsigned long open_lock;
 static struct device    *wdt_dev;	/* platform device attached to */
 static struct resource	*wdt_mem;
 static struct resource	*wdt_irq;
 static struct clk	*wdt_clock;
 static void __iomem	*wdt_base;
 static unsigned int	 wdt_count;
-static char		 expect_close;
 static DEFINE_SPINLOCK(wdt_lock);
 
 /* watchdog control routines */
@@ -93,11 +91,13 @@ static DEFINE_SPINLOCK(wdt_lock);
 
 /* functions */
 
-static void s3c2410wdt_keepalive(void)
+static int s3c2410wdt_keepalive(struct watchdog_device *wdd)
 {
 	spin_lock(&wdt_lock);
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
 	spin_unlock(&wdt_lock);
+
+	return 0;
 }
 
 static void __s3c2410wdt_stop(void)
@@ -109,14 +109,16 @@ static void __s3c2410wdt_stop(void)
 	writel(wtcon, wdt_base + S3C2410_WTCON);
 }
 
-static void s3c2410wdt_stop(void)
+static int s3c2410wdt_stop(struct watchdog_device *wdd)
 {
 	spin_lock(&wdt_lock);
 	__s3c2410wdt_stop();
 	spin_unlock(&wdt_lock);
+
+	return 0;
 }
 
-static void s3c2410wdt_start(void)
+static int s3c2410wdt_start(struct watchdog_device *wdd)
 {
 	unsigned long wtcon;
 
@@ -142,6 +144,8 @@ static void s3c2410wdt_start(void)
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
 	writel(wtcon, wdt_base + S3C2410_WTCON);
 	spin_unlock(&wdt_lock);
+
+	return 0;
 }
 
 static inline int s3c2410wdt_is_running(void)
@@ -149,7 +153,7 @@ static inline int s3c2410wdt_is_running(void)
 	return readl(wdt_base + S3C2410_WTCON) & S3C2410_WTCON_ENABLE;
 }
 
-static int s3c2410wdt_set_heartbeat(int timeout)
+static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeout)
 {
 	unsigned long freq = clk_get_rate(wdt_clock);
 	unsigned int count;
@@ -182,8 +186,6 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 		}
 	}
 
-	tmr_margin = timeout;
-
 	DBG("%s: timeout=%d, divisor=%d, count=%d (%08x)\n",
 	    __func__, timeout, divisor, count, count/divisor);
 
@@ -201,70 +203,6 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 	return 0;
 }
 
-/*
- *	/dev/watchdog handling
- */
-
-static int s3c2410wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &open_lock))
-		return -EBUSY;
-
-	if (nowayout)
-		__module_get(THIS_MODULE);
-
-	expect_close = 0;
-
-	/* start the timer */
-	s3c2410wdt_start();
-	return nonseekable_open(inode, file);
-}
-
-static int s3c2410wdt_release(struct inode *inode, struct file *file)
-{
-	/*
-	 *	Shut off the timer.
-	 *	Lock it in if it's a module and we set nowayout
-	 */
-
-	if (expect_close == 42)
-		s3c2410wdt_stop();
-	else {
-		dev_err(wdt_dev, "Unexpected close, not stopping watchdog\n");
-		s3c2410wdt_keepalive();
-	}
-	expect_close = 0;
-	clear_bit(0, &open_lock);
-	return 0;
-}
-
-static ssize_t s3c2410wdt_write(struct file *file, const char __user *data,
-				size_t len, loff_t *ppos)
-{
-	/*
-	 *	Refresh the timer.
-	 */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* In case it was set long ago */
-			expect_close = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		s3c2410wdt_keepalive();
-	}
-	return len;
-}
-
 #define OPTIONS (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE)
 
 static const struct watchdog_info s3c2410_wdt_ident = {
@@ -273,53 +211,17 @@ static const struct watchdog_info s3c2410_wdt_ident = {
 	.identity         =	"S3C2410 Watchdog",
 };
 
-
-static long s3c2410wdt_ioctl(struct file *file,	unsigned int cmd,
-							unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_margin;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &s3c2410_wdt_ident,
-			sizeof(s3c2410_wdt_ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		s3c2410wdt_keepalive();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, p))
-			return -EFAULT;
-		if (s3c2410wdt_set_heartbeat(new_margin))
-			return -EINVAL;
-		s3c2410wdt_keepalive();
-		return put_user(tmr_margin, p);
-	case WDIOC_GETTIMEOUT:
-		return put_user(tmr_margin, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-/* kernel interface */
-
-static const struct file_operations s3c2410wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= s3c2410wdt_write,
-	.unlocked_ioctl	= s3c2410wdt_ioctl,
-	.open		= s3c2410wdt_open,
-	.release	= s3c2410wdt_release,
+static struct watchdog_ops s3c2410wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = s3c2410wdt_start,
+	.stop = s3c2410wdt_stop,
+	.ping = s3c2410wdt_keepalive,
+	.set_timeout = s3c2410wdt_set_heartbeat,
 };
 
-static struct miscdevice s3c2410wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &s3c2410wdt_fops,
+static struct watchdog_device s3c2410_wdd = {
+	.info = &s3c2410_wdt_ident,
+	.ops = &s3c2410wdt_ops,
 };
 
 /* interrupt handler code */
@@ -328,7 +230,7 @@ static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 {
 	dev_info(wdt_dev, "watchdog timer expired (irq)\n");
 
-	s3c2410wdt_keepalive();
+	s3c2410wdt_keepalive(&s3c2410_wdd);
 	return IRQ_HANDLED;
 }
 
@@ -349,14 +251,14 @@ static int s3c2410wdt_cpufreq_transition(struct notifier_block *nb,
 		 * the watchdog is running.
 		 */
 
-		s3c2410wdt_keepalive();
+		s3c2410wdt_keepalive(&s3c2410_wdd);
 	} else if (val == CPUFREQ_POSTCHANGE) {
-		s3c2410wdt_stop();
+		s3c2410wdt_stop(&s3c2410_wdd);
 
-		ret = s3c2410wdt_set_heartbeat(tmr_margin);
+		ret = s3c2410wdt_set_heartbeat(&s3c2410_wdd, s3c2410_wdd.timeout);
 
 		if (ret >= 0)
-			s3c2410wdt_start();
+			s3c2410wdt_start(&s3c2410_wdd);
 		else
 			goto err;
 	}
@@ -365,7 +267,8 @@ done:
 	return 0;
 
  err:
-	dev_err(wdt_dev, "cannot set new value for timeout %d\n", tmr_margin);
+	dev_err(wdt_dev, "cannot set new value for timeout %d\n",
+				s3c2410_wdd.timeout);
 	return ret;
 }
 
@@ -396,10 +299,6 @@ static inline void s3c2410wdt_cpufreq_deregister(void)
 }
 #endif
 
-
-
-/* device interface */
-
 static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev;
@@ -466,8 +365,8 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 	/* see if we can actually set the requested timer margin, and if
 	 * not, try the default value */
 
-	if (s3c2410wdt_set_heartbeat(tmr_margin)) {
-		started = s3c2410wdt_set_heartbeat(
+	if (s3c2410wdt_set_heartbeat(&s3c2410_wdd, tmr_margin)) {
+		started = s3c2410wdt_set_heartbeat(&s3c2410_wdd,
 					CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 
 		if (started == 0)
@@ -479,22 +378,21 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 							"cannot start\n");
 	}
 
-	ret = misc_register(&s3c2410wdt_miscdev);
+	ret = watchdog_register_device(&s3c2410_wdd);
 	if (ret) {
-		dev_err(dev, "cannot register miscdev on minor=%d (%d)\n",
-			WATCHDOG_MINOR, ret);
+		dev_err(dev, "cannot register watchdog (%d)\n", ret);
 		goto err_cpufreq;
 	}
 
 	if (tmr_atboot && started == 0) {
 		dev_info(dev, "starting watchdog timer\n");
-		s3c2410wdt_start();
+		s3c2410wdt_start(&s3c2410_wdd);
 	} else if (!tmr_atboot) {
 		/* if we're not enabling the watchdog, then ensure it is
 		 * disabled if it has been left running from the bootloader
 		 * or other source */
 
-		s3c2410wdt_stop();
+		s3c2410wdt_stop(&s3c2410_wdd);
 	}
 
 	/* print out a statement of readiness */
@@ -530,7 +428,7 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 static int __devexit s3c2410wdt_remove(struct platform_device *dev)
 {
-	misc_deregister(&s3c2410wdt_miscdev);
+	watchdog_unregister_device(&s3c2410_wdd);
 
 	s3c2410wdt_cpufreq_deregister();
 
@@ -550,7 +448,7 @@ static int __devexit s3c2410wdt_remove(struct platform_device *dev)
 
 static void s3c2410wdt_shutdown(struct platform_device *dev)
 {
-	s3c2410wdt_stop();
+	s3c2410wdt_stop(&s3c2410_wdd);
 }
 
 #ifdef CONFIG_PM
@@ -565,7 +463,7 @@ static int s3c2410wdt_suspend(struct platform_device *dev, pm_message_t state)
 	wtdat_save = readl(wdt_base + S3C2410_WTDAT);
 
 	/* Note that WTCNT doesn't need to be saved. */
-	s3c2410wdt_stop();
+	s3c2410wdt_stop(&s3c2410_wdd);
 
 	return 0;
 }
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index f31493e..b01a30e 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -300,7 +300,7 @@ static int __init sbwdog_init(void)
 	 * get the resources
 	 */
 
-	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(1, sbwdog_interrupt, IRQF_SHARED,
 		ident.identity, (void *)user_dog);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to request irq 1 - %d\n",
@@ -350,7 +350,7 @@ void platform_wd_setup(void)
 {
 	int ret;
 
-	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(1, sbwdog_interrupt, IRQF_SHARED,
 		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
 	if (ret) {
 		printk(KERN_CRIT
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index 52b63f2..b284040 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -398,7 +398,7 @@ static int __init sc520_wdt_init(void)
 							WATCHDOG_TIMEOUT);
 	}
 
-	wdtmrctl = ioremap((unsigned long)(MMCR_BASE + OFFS_WDTMRCTL), 2);
+	wdtmrctl = ioremap(MMCR_BASE + OFFS_WDTMRCTL, 2);
 	if (!wdtmrctl) {
 		printk(KERN_ERR PFX "Unable to remap memory\n");
 		rc = -ENOMEM;
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index e5c91d4..dd5d675 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -142,7 +142,7 @@ static void w83627hf_init(void)
 	w83627hf_unselect_wd_register();
 }
 
-static void wdt_ctrl(int timeout)
+static void wdt_set_time(int timeout)
 {
 	spin_lock(&io_lock);
 
@@ -158,13 +158,13 @@ static void wdt_ctrl(int timeout)
 
 static int wdt_ping(void)
 {
-	wdt_ctrl(timeout);
+	wdt_set_time(timeout);
 	return 0;
 }
 
 static int wdt_disable(void)
 {
-	wdt_ctrl(0);
+	wdt_set_time(0);
 	return 0;
 }
 
@@ -176,6 +176,24 @@ static int wdt_set_heartbeat(int t)
 	return 0;
 }
 
+static int wdt_get_time(void)
+{
+	int timeleft;
+
+	spin_lock(&io_lock);
+
+	w83627hf_select_wd_register();
+
+	outb_p(0xF6, WDT_EFER);    /* Select CRF6 */
+	timeleft = inb_p(WDT_EFDR); /* Read Timeout counter to CRF6 */
+
+	w83627hf_unselect_wd_register();
+
+	spin_unlock(&io_lock);
+
+	return timeleft;
+}
+
 static ssize_t wdt_write(struct file *file, const char __user *buf,
 						size_t count, loff_t *ppos)
 {
@@ -202,7 +220,7 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	int new_timeout;
+	int timeval;
 	static const struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
 							WDIOF_MAGICCLOSE,
@@ -238,14 +256,17 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		wdt_ping();
 		break;
 	case WDIOC_SETTIMEOUT:
-		if (get_user(new_timeout, p))
+		if (get_user(timeval, p))
 			return -EFAULT;
-		if (wdt_set_heartbeat(new_timeout))
+		if (wdt_set_heartbeat(timeval))
 			return -EINVAL;
 		wdt_ping();
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(timeout, p);
+	case WDIOC_GETTIMELEFT:
+		timeval = wdt_get_time();
+		return put_user(timeval, p);
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index bb03e15..d2ef002 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -612,7 +612,7 @@ static int __init wdt_init(void)
 		goto out;
 	}
 
-	ret = request_irq(irq, wdt_interrupt, IRQF_DISABLED, "wdt501p", NULL);
+	ret = request_irq(irq, wdt_interrupt, 0, "wdt501p", NULL);
 	if (ret) {
 		printk(KERN_ERR "wdt: IRQ %d is not free.\n", irq);
 		goto outreg;
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 172dad6..e0fc3ba 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -643,7 +643,7 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 	irq = dev->irq;
 	io = pci_resource_start(dev, 2);
 
-	if (request_irq(irq, wdtpci_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(irq, wdtpci_interrupt, IRQF_SHARED,
 			 "wdt_pci", &wdtpci_miscdev)) {
 		printk(KERN_ERR PFX "IRQ %d is not free\n", irq);
 		goto out_reg;
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 871caea..7be3855 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -12,8 +12,7 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
 #include <linux/uaccess.h>
@@ -29,19 +28,19 @@ MODULE_PARM_DESC(nowayout,
 		 "Watchdog cannot be stopped once started (default="
 		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-static unsigned long wm831x_wdt_users;
-static struct miscdevice wm831x_wdt_miscdev;
-static int wm831x_wdt_expect_close;
-static DEFINE_MUTEX(wdt_mutex);
-static struct wm831x *wm831x;
-static unsigned int update_gpio;
-static unsigned int update_state;
+struct wm831x_wdt_drvdata {
+	struct watchdog_device wdt;
+	struct wm831x *wm831x;
+	struct mutex lock;
+	int update_gpio;
+	int update_state;
+};
 
 /* We can't use the sub-second values here but they're included
  * for completeness.  */
 static struct {
-	int time;  /* Seconds */
-	u16 val;   /* WDOG_TO value */
+	unsigned int time;  /* Seconds */
+	u16 val;            /* WDOG_TO value */
 } wm831x_wdt_cfgs[] = {
 	{  1, 2 },
 	{  2, 3 },
@@ -52,32 +51,13 @@ static struct {
 	{ 33, 7 },  /* Actually 32.768s so include both, others round down */
 };
 
-static int wm831x_wdt_set_timeout(struct wm831x *wm831x, u16 value)
-{
-	int ret;
-
-	mutex_lock(&wdt_mutex);
-
-	ret = wm831x_reg_unlock(wm831x);
-	if (ret == 0) {
-		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
-				      WM831X_WDOG_TO_MASK, value);
-		wm831x_reg_lock(wm831x);
-	} else {
-		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
-			ret);
-	}
-
-	mutex_unlock(&wdt_mutex);
-
-	return ret;
-}
-
-static int wm831x_wdt_start(struct wm831x *wm831x)
+static int wm831x_wdt_start(struct watchdog_device *wdt_dev)
 {
+	struct wm831x_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct wm831x *wm831x = driver_data->wm831x;
 	int ret;
 
-	mutex_lock(&wdt_mutex);
+	mutex_lock(&driver_data->lock);
 
 	ret = wm831x_reg_unlock(wm831x);
 	if (ret == 0) {
@@ -89,16 +69,18 @@ static int wm831x_wdt_start(struct wm831x *wm831x)
 			ret);
 	}
 
-	mutex_unlock(&wdt_mutex);
+	mutex_unlock(&driver_data->lock);
 
 	return ret;
 }
 
-static int wm831x_wdt_stop(struct wm831x *wm831x)
+static int wm831x_wdt_stop(struct watchdog_device *wdt_dev)
 {
+	struct wm831x_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct wm831x *wm831x = driver_data->wm831x;
 	int ret;
 
-	mutex_lock(&wdt_mutex);
+	mutex_lock(&driver_data->lock);
 
 	ret = wm831x_reg_unlock(wm831x);
 	if (ret == 0) {
@@ -110,26 +92,28 @@ static int wm831x_wdt_stop(struct wm831x *wm831x)
 			ret);
 	}
 
-	mutex_unlock(&wdt_mutex);
+	mutex_unlock(&driver_data->lock);
 
 	return ret;
 }
 
-static int wm831x_wdt_kick(struct wm831x *wm831x)
+static int wm831x_wdt_ping(struct watchdog_device *wdt_dev)
 {
+	struct wm831x_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct wm831x *wm831x = driver_data->wm831x;
 	int ret;
 	u16 reg;
 
-	mutex_lock(&wdt_mutex);
+	mutex_lock(&driver_data->lock);
 
-	if (update_gpio) {
-		gpio_set_value_cansleep(update_gpio, update_state);
-		update_state = !update_state;
+	if (driver_data->update_gpio) {
+		gpio_set_value_cansleep(driver_data->update_gpio,
+					driver_data->update_state);
+		driver_data->update_state = !driver_data->update_state;
 		ret = 0;
 		goto out;
 	}
 
-
 	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
 
 	if (!(reg & WM831X_WDOG_RST_SRC)) {
@@ -150,182 +134,59 @@ static int wm831x_wdt_kick(struct wm831x *wm831x)
 	}
 
 out:
-	mutex_unlock(&wdt_mutex);
+	mutex_unlock(&driver_data->lock);
 
 	return ret;
 }
 
-static int wm831x_wdt_open(struct inode *inode, struct file *file)
+static int wm831x_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				  unsigned int timeout)
 {
-	int ret;
-
-	if (!wm831x)
-		return -ENODEV;
-
-	if (test_and_set_bit(0, &wm831x_wdt_users))
-		return -EBUSY;
+	struct wm831x_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
+	struct wm831x *wm831x = driver_data->wm831x;
+	int ret, i;
 
-	ret = wm831x_wdt_start(wm831x);
-	if (ret != 0)
-		return ret;
-
-	return nonseekable_open(inode, file);
-}
+	for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
+		if (wm831x_wdt_cfgs[i].time == timeout)
+			break;
+	if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
+		ret = -EINVAL;
 
-static int wm831x_wdt_release(struct inode *inode, struct file *file)
-{
-	if (wm831x_wdt_expect_close)
-		wm831x_wdt_stop(wm831x);
-	else {
-		dev_warn(wm831x->dev, "Watchdog device closed uncleanly\n");
-		wm831x_wdt_kick(wm831x);
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret == 0) {
+		ret = wm831x_set_bits(wm831x, WM831X_WATCHDOG,
+				      WM831X_WDOG_TO_MASK,
+				      wm831x_wdt_cfgs[i].val);
+		wm831x_reg_lock(wm831x);
+	} else {
+		dev_err(wm831x->dev, "Failed to unlock security key: %d\n",
+			ret);
 	}
 
-	clear_bit(0, &wm831x_wdt_users);
-
-	return 0;
-}
-
-static ssize_t wm831x_wdt_write(struct file *file,
-				const char __user *data, size_t count,
-				loff_t *ppos)
-{
-	size_t i;
-
-	if (count) {
-		wm831x_wdt_kick(wm831x);
-
-		if (!nowayout) {
-			/* In case it was set long ago */
-			wm831x_wdt_expect_close = 0;
-
-			/* scan to see whether or not we got the magic
-			   character */
-			for (i = 0; i != count; i++) {
-				char c;
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					wm831x_wdt_expect_close = 42;
-			}
-		}
-	}
-	return count;
+	return ret;
 }
 
-static const struct watchdog_info ident = {
+static const struct watchdog_info wm831x_wdt_info = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 	.identity = "WM831x Watchdog",
 };
 
-static long wm831x_wdt_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg)
-{
-	int ret = -ENOTTY, time, i;
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	u16 reg;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, p);
-		break;
-
-	case WDIOC_SETOPTIONS:
-	{
-		int options;
-
-		if (get_user(options, p))
-			return -EFAULT;
-
-		ret = -EINVAL;
-
-		/* Setting both simultaneously means at least one must fail */
-		if (options == WDIOS_DISABLECARD)
-			ret = wm831x_wdt_start(wm831x);
-
-		if (options == WDIOS_ENABLECARD)
-			ret = wm831x_wdt_stop(wm831x);
-		break;
-	}
-
-	case WDIOC_KEEPALIVE:
-		ret = wm831x_wdt_kick(wm831x);
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		ret = get_user(time, p);
-		if (ret)
-			break;
-
-		if (time == 0) {
-			if (nowayout)
-				ret = -EINVAL;
-			else
-				wm831x_wdt_stop(wm831x);
-			break;
-		}
-
-		for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
-			if (wm831x_wdt_cfgs[i].time == time)
-				break;
-		if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
-			ret = -EINVAL;
-		else
-			ret = wm831x_wdt_set_timeout(wm831x,
-						     wm831x_wdt_cfgs[i].val);
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
-		reg &= WM831X_WDOG_TO_MASK;
-		for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
-			if (wm831x_wdt_cfgs[i].val == reg)
-				break;
-		if (i == ARRAY_SIZE(wm831x_wdt_cfgs)) {
-			dev_warn(wm831x->dev,
-				 "Unknown watchdog configuration: %x\n", reg);
-			ret = -EINVAL;
-		} else
-			ret = put_user(wm831x_wdt_cfgs[i].time, p);
-
-	}
-
-	return ret;
-}
-
-static const struct file_operations wm831x_wdt_fops = {
+static const struct watchdog_ops wm831x_wdt_ops = {
 	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = wm831x_wdt_write,
-	.unlocked_ioctl = wm831x_wdt_ioctl,
-	.open = wm831x_wdt_open,
-	.release = wm831x_wdt_release,
-};
-
-static struct miscdevice wm831x_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &wm831x_wdt_fops,
+	.start = wm831x_wdt_start,
+	.stop = wm831x_wdt_stop,
+	.ping = wm831x_wdt_ping,
+	.set_timeout = wm831x_wdt_set_timeout,
 };
 
 static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 {
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_pdata *chip_pdata;
 	struct wm831x_watchdog_pdata *pdata;
-	int reg, ret;
-
-	if (wm831x) {
-		dev_err(&pdev->dev, "wm831x watchdog already registered\n");
-		return -EBUSY;
-	}
-
-	wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_wdt_drvdata *driver_data;
+	struct watchdog_device *wm831x_wdt;
+	int reg, ret, i;
 
 	ret = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
 	if (ret < 0) {
@@ -338,6 +199,36 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 	if (reg & WM831X_WDOG_DEBUG)
 		dev_warn(wm831x->dev, "Watchdog is paused\n");
 
+	driver_data = kzalloc(sizeof(*driver_data), GFP_KERNEL);
+	if (!driver_data) {
+		dev_err(wm831x->dev, "Unable to alloacate watchdog device\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	mutex_init(&driver_data->lock);
+	driver_data->wm831x = wm831x;
+
+	wm831x_wdt = &driver_data->wdt;
+
+	wm831x_wdt->info = &wm831x_wdt_info;
+	wm831x_wdt->ops = &wm831x_wdt_ops;
+	watchdog_set_drvdata(wm831x_wdt, driver_data);
+
+	if (nowayout)
+		wm831x_wdt->status |= WDOG_NO_WAY_OUT;
+
+	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
+	reg &= WM831X_WDOG_TO_MASK;
+	for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
+		if (wm831x_wdt_cfgs[i].val == reg)
+			break;
+	if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
+		dev_warn(wm831x->dev,
+			 "Unknown watchdog timeout: %x\n", reg);
+	else
+		wm831x_wdt->timeout = wm831x_wdt_cfgs[i].time;
+
 	/* Apply any configuration */
 	if (pdev->dev.parent->platform_data) {
 		chip_pdata = pdev->dev.parent->platform_data;
@@ -361,7 +252,7 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 				dev_err(wm831x->dev,
 					"Failed to request update GPIO: %d\n",
 					ret);
-				goto err;
+				goto err_alloc;
 			}
 
 			ret = gpio_direction_output(pdata->update_gpio, 0);
@@ -372,7 +263,7 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 				goto err_gpio;
 			}
 
-			update_gpio = pdata->update_gpio;
+			driver_data->update_gpio = pdata->update_gpio;
 
 			/* Make sure the watchdog takes hardware updates */
 			reg |= WM831X_WDOG_RST_SRC;
@@ -389,33 +280,34 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 		}
 	}
 
-	wm831x_wdt_miscdev.parent = &pdev->dev;
-
-	ret = misc_register(&wm831x_wdt_miscdev);
+	ret = watchdog_register_device(&driver_data->wdt);
 	if (ret != 0) {
-		dev_err(wm831x->dev, "Failed to register miscdev: %d\n", ret);
+		dev_err(wm831x->dev, "watchdog_register_device() failed: %d\n",
+			ret);
 		goto err_gpio;
 	}
 
+	dev_set_drvdata(&pdev->dev, driver_data);
+
 	return 0;
 
 err_gpio:
-	if (update_gpio) {
-		gpio_free(update_gpio);
-		update_gpio = 0;
-	}
+	if (driver_data->update_gpio)
+		gpio_free(driver_data->update_gpio);
+err_alloc:
+	kfree(driver_data);
 err:
 	return ret;
 }
 
 static int __devexit wm831x_wdt_remove(struct platform_device *pdev)
 {
-	if (update_gpio) {
-		gpio_free(update_gpio);
-		update_gpio = 0;
-	}
+	struct wm831x_wdt_drvdata *driver_data = dev_get_drvdata(&pdev->dev);
+
+	watchdog_unregister_device(&driver_data->wdt);
 
-	misc_deregister(&wm831x_wdt_miscdev);
+	if (driver_data->update_gpio)
+		gpio_free(driver_data->update_gpio);
 
 	return 0;
 }
