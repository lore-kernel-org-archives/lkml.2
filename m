Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2GWLDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:03:38 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:36864 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751979Ab2GWLDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:03:35 -0400
Date: Mon, 23 Jul 2012 13:03:31 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>, Dave Mueller <d.mueller@elsoft.ch>,
        Florian Fainelli <florian@openwrt.org>,
        Gerard Snitselaar <dev@snitselaar.org>,
        Justin Wheeler <jwheeler@datademons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Michal Simek <monstr@monstr.eu>,
        Oskar Schirmer <oskar@scara.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [GIT PULL REQUEST] watchdog - v3.6 merge window
Message-ID: <20120723110330.GM735@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This merge set contains:
* conversion of iTCO_wdt and orion_wdt to the generic watchdog API
* uses module_platform_driver() for s3c2410_wdt
* Adds support for Jetway JNF99 Motherboard
* various fixes

This will update the following files:

 char/ipmi/ipmi_watchdog.c |   13 --
 watchdog/Kconfig          |    2 
 watchdog/bcm63xx_wdt.c    |    4 
 watchdog/coh901327_wdt.c  |    7 -
 watchdog/f71808e_wdt.c    |    4 
 watchdog/iTCO_wdt.c       |  213 ++++++++++------------------------------------
 watchdog/ie6xx_wdt.c      |    4 
 watchdog/of_xilinx_wdt.c  |    2 
 watchdog/omap_wdt.c       |   17 ---
 watchdog/orion_wdt.c      |  203 ++++++++++---------------------------------
 watchdog/s3c2410_wdt.c    |   16 ---
 watchdog/sch311x_wdt.c    |   10 +-
 12 files changed, 121 insertions(+), 374 deletions(-)

with these Changes:

commit 0dd6e4847ed8a42e81df6ffaa71129245a6d9d72
Author: Axel Lin <axel.lin@gmail.com>
Date:   Mon Mar 26 11:14:29 2012 +0800

    watchdog: orion_wdt: Convert driver to watchdog core
    
    Convert orion_wdt driver to use watchdog framework API.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Tested-by: Andrew Lunn <andrew@lunn.ch>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 6b761b2902c56b468370e0ee1691c37e0dae042a
Author: Sachin Kamat <sachin.kamat@linaro.org>
Date:   Thu Jul 12 17:17:40 2012 +0530

    watchdog: s3c2410_wdt: Use module_platform_driver()
    
    module_platform_driver() replaces module_init() and module_exit()
    and makes the code simpler.
    
    Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 7732c6b96f127bb5d9474715149b4e94e369412c
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jul 8 14:57:09 2012 +0200

    watchdog: sch311x_wdt: Fix Polarity when starting watchdog
    
    Some motherboards like the Advantech ARK3400 documentation
    use a non-inverted GPIO pin. We fix this by assuming that
    the BIOS will set the Polarity bit for the GPIO correctly
    at startup and we keep the Bit-setting intact when we start
    and stop the watchdog.
    
    Reported-by: Jean-François Deverge <jf.deverge@gmail.com>
    Signed-off-by: Dave Mueller <d.mueller@elsoft.ch>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 41814eed414ab3cef3d2b857ae3690a2b4888291
Author: Lokesh Vutla <lokeshvutla@ti.com>
Date:   Mon Jun 18 10:53:16 2012 +0530

    Watchdog: OMAP: Fix the runtime pm code to avoid module getting stuck intransition state.
    
    OMAP watchdog driver is adapted to runtime PM like a general device
    driver but it is not appropriate. It is causing couple of functional
    issues.
    
    1. On OMAP4 SYSCLK can't be gated, because of issue with WDTIMER2 module,
    which constantly stays in "in transition" state. Value of register
    CM_WKUP_WDTIMER2_CLKCTRL is always 0x00010000 in this case.
    Issue occurs immediately after first idle, when hwmod framework tries
    to disable WDTIMER2 functional clock - "wd_timer2_fck". After this
    module falls to "in transition" state, and SYSCLK gating is blocked.
    
    2. Due to runtime PM, watchdog timer may be completely disabled.
    In current code base watchdog timer is not disabled only because of
    issue 1. Otherwise state of WDTIMER2 module will be "Disabled", and there
    will be no interrupts from omap_wdt. In other words watchdog will not
    work at all.
    
    Watchdong is a special IP and it should not be disabled otherwise
    purpose of it itself is defeated. Watchdog functional clock should
    never be disabled. This patch updates the runtime PM handling in
    driver so that runtime PM is limited only during probe/shutdown
    and suspend/resume.
    
    The patch fixes issue 1 and 2
    
    Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 0402450f45673d3c03340cb1e679bf2a1fc0abee
Author: Gerard Snitselaar <dev@snitselaar.org>
Date:   Wed Jul 4 09:32:11 2012 -0700

    watchdog: ie6xx_wdt: section mismatch in ie6xx_wdt_probe()
    
    ie6xx_wdt_probe() calls ie6xx_wdt_debugfs_exit() as part of
    it's error cleanup path, and ie6xx_wdt_debugfs_exit() is
    currently annotated __devexit.
    
    Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5a135f3c72c5bc738a29629d81a99c981b17a736
Author: Florian Fainelli <florian@openwrt.org>
Date:   Fri Jun 29 11:14:44 2012 +0200

    watchdog: bcm63xx_wdt: fix driver section mismatch
    
    bcm63xx_wdt was used as a platform_driver but was not suffixed with
    _driver, thus causing section mismatches, fix that.
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit bff23431fe7e2eba939fe4cdaa78d94a4d9497f7
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sat Jun 9 14:10:28 2012 +0200

    watchdog: iTCO_wdt.c: convert to watchdog core
    
    This patch converts the iTCO_wdt watchdog driver to use the
    generic watchdog framework.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 18cb2ae55f98648caf0d52ef075f38b16aae7ec6
Author: Oskar Schirmer <oskar@scara.com>
Date:   Thu May 31 09:28:43 2012 +0000

    char/ipmi: remove local ioctl defines replaced by generic ones
    
    This watchdog driver had ioctl defines introduced locally
    for pre timeout handling, marked to be removed as soon as
    a generic replacement would become available.
    
    The latter has actually occurred in 2006, at e05b59fe.
    
    Remove the local duplicates for pre timeout handling.
    
    Signed-off-by: Oskar Schirmer <oskar@scara.com>
    Acked-by: Corey Minyard <cminyard@mvista.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

commit 90fe6c608f8d46e5bb3f31c2d5e1c90475253f79
Author: Michal Simek <monstr@monstr.eu>
Date:   Thu Jun 21 08:45:40 2012 +0200

    watchdog: xilinx: Read clock frequency directly from DT node
    
    Do not use clock-frequency property from parent node.
    Use it from watchdog node.
    
    Signed-off-by: Michal Simek <monstr@monstr.eu>
    Acked-By: Alejandro Cabrera <acabrera@udio.cujae.edu.cu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit c362cb597b5c30a32f4228136e0dfd9bf4c5d65b
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Tue Jun 12 19:19:01 2012 +0200

    watchdog: coh901327_wdt: use clk_prepare/unprepare
    
    Make sure we prepare/unprepare the COH901327 watchdog timer
    as is required by the clk API especially if you use common
    clock.
    
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
    Reviewed-by : Pankaj Jangra <jangra.pankaj9@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 3017020dc73a3ae222db2cda9b5952f0e4cf7a09
Author: Justin Wheeler <jwheeler@datademons.com>
Date:   Mon Jun 11 01:07:58 2012 -0400

    watchdog: f71808e_wdt: Add support for Jetway JNF99 motherboard
    
    The Jetway JNF99 motherboard features a F71869 SuperIO chip, but its
    watchdog chipset ID appears to be 1007 (as opposed to 0814).  Some testing
    confirmed it behaves the exact same as 0814. So add this chipset ID to the
    module's ID list so that the Fintek watchdog driver can correctly identify
    and access it.
    
    Signed-off-by: Justin Wheeler <jwheeler@datademons.com>
    Acked-by: Giel van Schijndel <me@mortis.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 7ed356e..37b8be7 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -141,17 +141,6 @@
 
 #define IPMI_WDOG_TIMER_NOT_INIT_RESP	0x80
 
-/* These are here until the real ones get into the watchdog.h interface. */
-#ifndef WDIOC_GETTIMEOUT
-#define	WDIOC_GETTIMEOUT        _IOW(WATCHDOG_IOCTL_BASE, 20, int)
-#endif
-#ifndef WDIOC_SET_PRETIMEOUT
-#define	WDIOC_SET_PRETIMEOUT     _IOW(WATCHDOG_IOCTL_BASE, 21, int)
-#endif
-#ifndef WDIOC_GET_PRETIMEOUT
-#define	WDIOC_GET_PRETIMEOUT     _IOW(WATCHDOG_IOCTL_BASE, 22, int)
-#endif
-
 static DEFINE_MUTEX(ipmi_watchdog_mutex);
 static bool nowayout = WATCHDOG_NOWAYOUT;
 
@@ -732,7 +721,6 @@ static int ipmi_ioctl(struct file *file,
 			return -EFAULT;
 		return 0;
 
-	case WDIOC_SET_PRETIMEOUT:
 	case WDIOC_SETPRETIMEOUT:
 		i = copy_from_user(&val, argp, sizeof(int));
 		if (i)
@@ -740,7 +728,6 @@ static int ipmi_ioctl(struct file *file,
 		pretimeout = val;
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 
-	case WDIOC_GET_PRETIMEOUT:
 	case WDIOC_GETPRETIMEOUT:
 		i = copy_to_user(argp, &pretimeout, sizeof(pretimeout));
 		if (i)
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index fe819b7..46e258c 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -279,6 +279,7 @@ config DAVINCI_WATCHDOG
 config ORION_WATCHDOG
 	tristate "Orion watchdog"
 	depends on ARCH_ORION5X || ARCH_KIRKWOOD
+	select WATCHDOG_CORE
 	help
 	  Say Y here if to include support for the watchdog timer
 	  in the Marvell Orion5x and Kirkwood ARM SoCs.
@@ -578,6 +579,7 @@ config INTEL_SCU_WATCHDOG
 config ITCO_WDT
 	tristate "Intel TCO Timer/Watchdog"
 	depends on (X86 || IA64) && PCI
+	select WATCHDOG_CORE
 	select LPC_ICH
 	---help---
 	  Hardware driver for the intel TCO timer based watchdog devices.
diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index 8379dc3..551880b 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -302,7 +302,7 @@ static void bcm63xx_wdt_shutdown(struct platform_device *pdev)
 	bcm63xx_wdt_pause();
 }
 
-static struct platform_driver bcm63xx_wdt = {
+static struct platform_driver bcm63xx_wdt_driver = {
 	.probe	= bcm63xx_wdt_probe,
 	.remove = __devexit_p(bcm63xx_wdt_remove),
 	.shutdown = bcm63xx_wdt_shutdown,
@@ -312,7 +312,7 @@ static struct platform_driver bcm63xx_wdt = {
 	}
 };
 
-module_platform_driver(bcm63xx_wdt);
+module_platform_driver(bcm63xx_wdt_driver);
 
 MODULE_AUTHOR("Miguel Gaio <miguel.gaio@efixo.com>");
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 6876430..cb5da5c 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -263,6 +263,7 @@ static int __exit coh901327_remove(struct platform_device *pdev)
 	watchdog_unregister_device(&coh901327_wdt);
 	coh901327_disable();
 	free_irq(irq, pdev);
+	clk_unprepare(clk);
 	clk_put(clk);
 	iounmap(virtbase);
 	release_mem_region(phybase, physize);
@@ -300,9 +301,9 @@ static int __init coh901327_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "could not get clock\n");
 		goto out_no_clk;
 	}
-	ret = clk_enable(clk);
+	ret = clk_prepare_enable(clk);
 	if (ret) {
-		dev_err(&pdev->dev, "could not enable clock\n");
+		dev_err(&pdev->dev, "could not prepare and enable clock\n");
 		goto out_no_clk_enable;
 	}
 
@@ -369,7 +370,7 @@ static int __init coh901327_probe(struct platform_device *pdev)
 out_no_wdog:
 	free_irq(irq, pdev);
 out_no_irq:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 out_no_clk_enable:
 	clk_put(clk);
 out_no_clk:
diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index c65b0a5..016bd93 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -56,6 +56,7 @@
 #define SIO_F71858_ID		0x0507	/* Chipset ID */
 #define SIO_F71862_ID		0x0601	/* Chipset ID */
 #define SIO_F71869_ID		0x0814	/* Chipset ID */
+#define SIO_F71869A_ID		0x1007	/* Chipset ID */
 #define SIO_F71882_ID		0x0541	/* Chipset ID */
 #define SIO_F71889_ID		0x0723	/* Chipset ID */
 
@@ -195,7 +196,7 @@ static inline int superio_enter(int base)
 		return -EBUSY;
 	}
 
-	/* according to the datasheet the key must be send twice! */
+	/* according to the datasheet the key must be sent twice! */
 	outb(SIO_UNLOCK_KEY, base);
 	outb(SIO_UNLOCK_KEY, base);
 
@@ -756,6 +757,7 @@ static int __init f71808e_find(int sioaddr)
 		err = f71862fg_pin_configure(0); /* validate module parameter */
 		break;
 	case SIO_F71869_ID:
+	case SIO_F71869A_ID:
 		watchdog.type = f71869;
 		break;
 	case SIO_F71882_ID:
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 9c2c27c..ceed39f 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -47,7 +47,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
-#define DRV_VERSION	"1.07"
+#define DRV_VERSION	"1.10"
 
 /* Includes */
 #include <linux/module.h>		/* For module specific items */
@@ -88,8 +88,6 @@
 #define TCOv2_TMR	(TCOBASE + 0x12) /* TCOv2 Timer Initial Value	*/
 
 /* internal variables */
-static unsigned long is_active;
-static char expect_release;
 static struct {		/* this is private data for the iTCO_wdt device */
 	/* TCO version/generation */
 	unsigned int iTCO_version;
@@ -106,12 +104,12 @@ static struct {		/* this is private data for the iTCO_wdt device */
 } iTCO_wdt_private;
 
 /* module parameters */
-#define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat */
-static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
+#define WATCHDOG_TIMEOUT 30	/* 30 sec default heartbeat */
+static int heartbeat = WATCHDOG_TIMEOUT;  /* in seconds */
 module_param(heartbeat, int, 0);
 MODULE_PARM_DESC(heartbeat, "Watchdog timeout in seconds. "
 	"5..76 (TCO v1) or 3..614 (TCO v2), default="
-				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
@@ -178,13 +176,13 @@ static int iTCO_wdt_unset_NO_REBOOT_bit(void)
 	return ret; /* returns: 0 = OK, -EIO = Error */
 }
 
-static int iTCO_wdt_start(void)
+static int iTCO_wdt_start(struct watchdog_device *wd_dev)
 {
 	unsigned int val;
 
 	spin_lock(&iTCO_wdt_private.io_lock);
 
-	iTCO_vendor_pre_start(iTCO_wdt_private.smi_res, heartbeat);
+	iTCO_vendor_pre_start(iTCO_wdt_private.smi_res, wd_dev->timeout);
 
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
@@ -212,7 +210,7 @@ static int iTCO_wdt_start(void)
 	return 0;
 }
 
-static int iTCO_wdt_stop(void)
+static int iTCO_wdt_stop(struct watchdog_device *wd_dev)
 {
 	unsigned int val;
 
@@ -236,11 +234,11 @@ static int iTCO_wdt_stop(void)
 	return 0;
 }
 
-static int iTCO_wdt_keepalive(void)
+static int iTCO_wdt_ping(struct watchdog_device *wd_dev)
 {
 	spin_lock(&iTCO_wdt_private.io_lock);
 
-	iTCO_vendor_pre_keepalive(iTCO_wdt_private.smi_res, heartbeat);
+	iTCO_vendor_pre_keepalive(iTCO_wdt_private.smi_res, wd_dev->timeout);
 
 	/* Reload the timer by writing to the TCO Timer Counter register */
 	if (iTCO_wdt_private.iTCO_version == 2)
@@ -257,7 +255,7 @@ static int iTCO_wdt_keepalive(void)
 	return 0;
 }
 
-static int iTCO_wdt_set_heartbeat(int t)
+static int iTCO_wdt_set_timeout(struct watchdog_device *wd_dev, unsigned int t)
 {
 	unsigned int val16;
 	unsigned char val8;
@@ -304,14 +302,15 @@ static int iTCO_wdt_set_heartbeat(int t)
 			return -EINVAL;
 	}
 
-	heartbeat = t;
+	wd_dev->timeout = t;
 	return 0;
 }
 
-static int iTCO_wdt_get_timeleft(int *time_left)
+static unsigned int iTCO_wdt_get_timeleft(struct watchdog_device *wd_dev)
 {
 	unsigned int val16;
 	unsigned char val8;
+	unsigned int time_left = 0;
 
 	/* read the TCO Timer */
 	if (iTCO_wdt_private.iTCO_version == 2) {
@@ -320,7 +319,7 @@ static int iTCO_wdt_get_timeleft(int *time_left)
 		val16 &= 0x3ff;
 		spin_unlock(&iTCO_wdt_private.io_lock);
 
-		*time_left = (val16 * 6) / 10;
+		time_left = (val16 * 6) / 10;
 	} else if (iTCO_wdt_private.iTCO_version == 1) {
 		spin_lock(&iTCO_wdt_private.io_lock);
 		val8 = inb(TCO_RLD);
@@ -329,156 +328,35 @@ static int iTCO_wdt_get_timeleft(int *time_left)
 			val8 += (inb(TCOv1_TMR) & 0x3f);
 		spin_unlock(&iTCO_wdt_private.io_lock);
 
-		*time_left = (val8 * 6) / 10;
-	} else
-		return -EINVAL;
-	return 0;
-}
-
-/*
- *	/dev/watchdog handling
- */
-
-static int iTCO_wdt_open(struct inode *inode, struct file *file)
-{
-	/* /dev/watchdog can only be opened once */
-	if (test_and_set_bit(0, &is_active))
-		return -EBUSY;
-
-	/*
-	 *      Reload and activate timer
-	 */
-	iTCO_wdt_start();
-	return nonseekable_open(inode, file);
-}
-
-static int iTCO_wdt_release(struct inode *inode, struct file *file)
-{
-	/*
-	 *      Shut off the timer.
-	 */
-	if (expect_release == 42) {
-		iTCO_wdt_stop();
-	} else {
-		pr_crit("Unexpected close, not stopping watchdog!\n");
-		iTCO_wdt_keepalive();
-	}
-	clear_bit(0, &is_active);
-	expect_release = 0;
-	return 0;
-}
-
-static ssize_t iTCO_wdt_write(struct file *file, const char __user *data,
-			      size_t len, loff_t *ppos)
-{
-	/* See if we got the magic character 'V' and reload the timer */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* note: just in case someone wrote the magic
-			   character five months ago... */
-			expect_release = 0;
-
-			/* scan to see whether or not we got the
-			   magic character */
-			for (i = 0; i != len; i++) {
-				char c;
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_release = 42;
-			}
-		}
-
-		/* someone wrote to us, we should reload the timer */
-		iTCO_wdt_keepalive();
-	}
-	return len;
-}
-
-static long iTCO_wdt_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	int new_options, retval = -EINVAL;
-	int new_heartbeat;
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static const struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		DRV_NAME,
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-
-	case WDIOC_SETOPTIONS:
-	{
-		if (get_user(new_options, p))
-			return -EFAULT;
-
-		if (new_options & WDIOS_DISABLECARD) {
-			iTCO_wdt_stop();
-			retval = 0;
-		}
-		if (new_options & WDIOS_ENABLECARD) {
-			iTCO_wdt_keepalive();
-			iTCO_wdt_start();
-			retval = 0;
-		}
-		return retval;
-	}
-	case WDIOC_KEEPALIVE:
-		iTCO_wdt_keepalive();
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-	{
-		if (get_user(new_heartbeat, p))
-			return -EFAULT;
-		if (iTCO_wdt_set_heartbeat(new_heartbeat))
-			return -EINVAL;
-		iTCO_wdt_keepalive();
-		/* Fall */
-	}
-	case WDIOC_GETTIMEOUT:
-		return put_user(heartbeat, p);
-	case WDIOC_GETTIMELEFT:
-	{
-		int time_left;
-		if (iTCO_wdt_get_timeleft(&time_left))
-			return -EINVAL;
-		return put_user(time_left, p);
-	}
-	default:
-		return -ENOTTY;
+		time_left = (val8 * 6) / 10;
 	}
+	return time_left;
 }
 
 /*
  *	Kernel Interfaces
  */
 
-static const struct file_operations iTCO_wdt_fops = {
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+	.firmware_version =	0,
+	.identity =		DRV_NAME,
+};
+
+static const struct watchdog_ops iTCO_wdt_ops = {
 	.owner =		THIS_MODULE,
-	.llseek =		no_llseek,
-	.write =		iTCO_wdt_write,
-	.unlocked_ioctl =	iTCO_wdt_ioctl,
-	.open =			iTCO_wdt_open,
-	.release =		iTCO_wdt_release,
+	.start =		iTCO_wdt_start,
+	.stop = 		iTCO_wdt_stop,
+	.ping = 		iTCO_wdt_ping,
+	.set_timeout =		iTCO_wdt_set_timeout,
+	.get_timeleft =		iTCO_wdt_get_timeleft,
 };
 
-static struct miscdevice iTCO_wdt_miscdev = {
-	.minor =	WATCHDOG_MINOR,
-	.name =		"watchdog",
-	.fops =		&iTCO_wdt_fops,
+static struct watchdog_device iTCO_wdt_watchdog_dev = {
+	.info =		&ident,
+	.ops = 		&iTCO_wdt_ops,
 };
 
 /*
@@ -489,10 +367,10 @@ static void __devexit iTCO_wdt_cleanup(void)
 {
 	/* Stop the timer before we leave */
 	if (!nowayout)
-		iTCO_wdt_stop();
+		iTCO_wdt_stop(&iTCO_wdt_watchdog_dev);
 
 	/* Deregister */
-	misc_deregister(&iTCO_wdt_miscdev);
+	watchdog_unregister_device(&iTCO_wdt_watchdog_dev);
 
 	/* release resources */
 	release_region(iTCO_wdt_private.tco_res->start,
@@ -605,20 +483,25 @@ static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 	outw(0x0002, TCO2_STS);	/* Clear SECOND_TO_STS bit */
 	outw(0x0004, TCO2_STS);	/* Clear BOOT_STS bit */
 
+	iTCO_wdt_watchdog_dev.bootstatus = 0;
+	iTCO_wdt_watchdog_dev.timeout = WATCHDOG_TIMEOUT;
+	watchdog_set_nowayout(&iTCO_wdt_watchdog_dev, nowayout);
+	iTCO_wdt_watchdog_dev.parent = dev->dev.parent;
+
 	/* Make sure the watchdog is not running */
-	iTCO_wdt_stop();
+	iTCO_wdt_stop(&iTCO_wdt_watchdog_dev);
 
 	/* Check that the heartbeat value is within it's range;
 	   if not reset to the default */
-	if (iTCO_wdt_set_heartbeat(heartbeat)) {
-		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
-		pr_info("timeout value out of range, using %d\n", heartbeat);
+	if (iTCO_wdt_set_timeout(&iTCO_wdt_watchdog_dev, heartbeat)) {
+		iTCO_wdt_set_timeout(&iTCO_wdt_watchdog_dev, WATCHDOG_TIMEOUT);
+		pr_info("timeout value out of range, using %d\n",
+			WATCHDOG_TIMEOUT);
 	}
 
-	ret = misc_register(&iTCO_wdt_miscdev);
+	ret = watchdog_register_device(&iTCO_wdt_watchdog_dev);
 	if (ret != 0) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
+		pr_err("cannot register watchdog device (err=%d)\n", ret);
 		goto unreg_tco;
 	}
 
@@ -659,7 +542,7 @@ static int __devexit iTCO_wdt_remove(struct platform_device *dev)
 
 static void iTCO_wdt_shutdown(struct platform_device *dev)
 {
-	iTCO_wdt_stop();
+	iTCO_wdt_stop(NULL);
 }
 
 static struct platform_driver iTCO_wdt_driver = {
diff --git a/drivers/watchdog/ie6xx_wdt.c b/drivers/watchdog/ie6xx_wdt.c
index 5f0d776..8f541b9 100644
--- a/drivers/watchdog/ie6xx_wdt.c
+++ b/drivers/watchdog/ie6xx_wdt.c
@@ -232,7 +232,7 @@ static void __devinit ie6xx_wdt_debugfs_init(void)
 		S_IFREG | S_IRUGO, NULL, NULL, &ie6xx_wdt_dbg_operations);
 }
 
-static void __devexit ie6xx_wdt_debugfs_exit(void)
+static void ie6xx_wdt_debugfs_exit(void)
 {
 	debugfs_remove(ie6xx_wdt_data.debugfs);
 }
@@ -242,7 +242,7 @@ static void __devinit ie6xx_wdt_debugfs_init(void)
 {
 }
 
-static void __devexit ie6xx_wdt_debugfs_exit(void)
+static void ie6xx_wdt_debugfs_exit(void)
 {
 }
 #endif
diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 55d2f66..294fb4e 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -297,7 +297,7 @@ static int __devinit xwdt_probe(struct platform_device *pdev)
 
 	no_timeout = 0;
 
-	pfreq = (u32 *)of_get_property(pdev->dev.of_node->parent,
+	pfreq = (u32 *)of_get_property(pdev->dev.of_node,
 					"clock-frequency", NULL);
 
 	if (pfreq == NULL) {
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 8285d65..27ab8db 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -126,8 +126,6 @@ static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
 	u32 pre_margin = GET_WLDR_VAL(timer_margin);
 	void __iomem *base = wdev->base;
 
-	pm_runtime_get_sync(wdev->dev);
-
 	/* just count up at 32 KHz */
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
@@ -135,8 +133,6 @@ static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
 	__raw_writel(pre_margin, base + OMAP_WATCHDOG_LDR);
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
-
-	pm_runtime_put_sync(wdev->dev);
 }
 
 /*
@@ -166,8 +162,6 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 	omap_wdt_ping(wdev); /* trigger loading of new timeout value */
 	omap_wdt_enable(wdev);
 
-	pm_runtime_put_sync(wdev->dev);
-
 	return nonseekable_open(inode, file);
 }
 
@@ -179,8 +173,6 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 	 *      Shut off the timer unless NOWAYOUT is defined.
 	 */
 #ifndef CONFIG_WATCHDOG_NOWAYOUT
-	pm_runtime_get_sync(wdev->dev);
-
 	omap_wdt_disable(wdev);
 
 	pm_runtime_put_sync(wdev->dev);
@@ -199,11 +191,9 @@ static ssize_t omap_wdt_write(struct file *file, const char __user *data,
 
 	/* Refresh LOAD_TIME. */
 	if (len) {
-		pm_runtime_get_sync(wdev->dev);
 		spin_lock(&wdt_lock);
 		omap_wdt_ping(wdev);
 		spin_unlock(&wdt_lock);
-		pm_runtime_put_sync(wdev->dev);
 	}
 	return len;
 }
@@ -236,18 +226,15 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 					(int __user *)arg);
 		return put_user(0, (int __user *)arg);
 	case WDIOC_KEEPALIVE:
-		pm_runtime_get_sync(wdev->dev);
 		spin_lock(&wdt_lock);
 		omap_wdt_ping(wdev);
 		spin_unlock(&wdt_lock);
-		pm_runtime_put_sync(wdev->dev);
 		return 0;
 	case WDIOC_SETTIMEOUT:
 		if (get_user(new_margin, (int __user *)arg))
 			return -EFAULT;
 		omap_wdt_adjust_timeout(new_margin);
 
-		pm_runtime_get_sync(wdev->dev);
 		spin_lock(&wdt_lock);
 		omap_wdt_disable(wdev);
 		omap_wdt_set_timeout(wdev);
@@ -255,7 +242,6 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 
 		omap_wdt_ping(wdev);
 		spin_unlock(&wdt_lock);
-		pm_runtime_put_sync(wdev->dev);
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(timer_margin, (int __user *)arg);
@@ -363,7 +349,6 @@ static void omap_wdt_shutdown(struct platform_device *pdev)
 	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
 
 	if (wdev->omap_wdt_users) {
-		pm_runtime_get_sync(wdev->dev);
 		omap_wdt_disable(wdev);
 		pm_runtime_put_sync(wdev->dev);
 	}
@@ -403,7 +388,6 @@ static int omap_wdt_suspend(struct platform_device *pdev, pm_message_t state)
 	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
 
 	if (wdev->omap_wdt_users) {
-		pm_runtime_get_sync(wdev->dev);
 		omap_wdt_disable(wdev);
 		pm_runtime_put_sync(wdev->dev);
 	}
@@ -419,7 +403,6 @@ static int omap_wdt_resume(struct platform_device *pdev)
 		pm_runtime_get_sync(wdev->dev);
 		omap_wdt_enable(wdev);
 		omap_wdt_ping(wdev);
-		pm_runtime_put_sync(wdev->dev);
 	}
 
 	return 0;
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 0f57369..a73bea4 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -16,22 +16,21 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
-#include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <mach/bridge-regs.h>
 
 /*
  * Watchdog timer block registers.
  */
 #define TIMER_CTRL		0x0000
-#define  WDT_EN			0x0010
+#define WDT_EN			0x0010
 #define WDT_VAL			0x0024
 
 #define WDT_MAX_CYCLE_COUNT	0xffffffff
@@ -44,27 +43,27 @@ static unsigned int wdt_max_duration;	/* (seconds) */
 static struct clk *clk;
 static unsigned int wdt_tclk;
 static void __iomem *wdt_reg;
-static unsigned long wdt_status;
 static DEFINE_SPINLOCK(wdt_lock);
 
-static void orion_wdt_ping(void)
+static int orion_wdt_ping(struct watchdog_device *wdt_dev)
 {
 	spin_lock(&wdt_lock);
 
 	/* Reload watchdog duration */
-	writel(wdt_tclk * heartbeat, wdt_reg + WDT_VAL);
+	writel(wdt_tclk * wdt_dev->timeout, wdt_reg + WDT_VAL);
 
 	spin_unlock(&wdt_lock);
+	return 0;
 }
 
-static void orion_wdt_enable(void)
+static int orion_wdt_start(struct watchdog_device *wdt_dev)
 {
 	u32 reg;
 
 	spin_lock(&wdt_lock);
 
 	/* Set watchdog duration */
-	writel(wdt_tclk * heartbeat, wdt_reg + WDT_VAL);
+	writel(wdt_tclk * wdt_dev->timeout, wdt_reg + WDT_VAL);
 
 	/* Clear watchdog timer interrupt */
 	reg = readl(BRIDGE_CAUSE);
@@ -82,9 +81,10 @@ static void orion_wdt_enable(void)
 	writel(reg, RSTOUTn_MASK);
 
 	spin_unlock(&wdt_lock);
+	return 0;
 }
 
-static void orion_wdt_disable(void)
+static int orion_wdt_stop(struct watchdog_device *wdt_dev)
 {
 	u32 reg;
 
@@ -101,139 +101,44 @@ static void orion_wdt_disable(void)
 	writel(reg, wdt_reg + TIMER_CTRL);
 
 	spin_unlock(&wdt_lock);
+	return 0;
 }
 
-static int orion_wdt_get_timeleft(int *time_left)
+static unsigned int orion_wdt_get_timeleft(struct watchdog_device *wdt_dev)
 {
+	unsigned int time_left;
+
 	spin_lock(&wdt_lock);
-	*time_left = readl(wdt_reg + WDT_VAL) / wdt_tclk;
+	time_left = readl(wdt_reg + WDT_VAL) / wdt_tclk;
 	spin_unlock(&wdt_lock);
-	return 0;
-}
 
-static int orion_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
-		return -EBUSY;
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-	orion_wdt_enable();
-	return nonseekable_open(inode, file);
+	return time_left;
 }
 
-static ssize_t orion_wdt_write(struct file *file, const char *data,
-					size_t len, loff_t *ppos)
+static int orion_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				 unsigned int timeout)
 {
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
-			}
-		}
-		orion_wdt_ping();
-	}
-	return len;
-}
-
-static int orion_wdt_settimeout(int new_time)
-{
-	if ((new_time <= 0) || (new_time > wdt_max_duration))
-		return -EINVAL;
-
-	/* Set new watchdog time to be used when
-	 * orion_wdt_enable() or orion_wdt_ping() is called. */
-	heartbeat = new_time;
+	wdt_dev->timeout = timeout;
 	return 0;
 }
 
-static const struct watchdog_info ident = {
-	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
-			  WDIOF_KEEPALIVEPING,
-	.identity	= "Orion Watchdog",
+static const struct watchdog_info orion_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "Orion Watchdog",
 };
 
-static long orion_wdt_ioctl(struct file *file, unsigned int cmd,
-				unsigned long arg)
-{
-	int ret = -ENOTTY;
-	int time;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		ret = copy_to_user((struct watchdog_info *)arg, &ident,
-				   sizeof(ident)) ? -EFAULT : 0;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0, (int *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		orion_wdt_ping();
-		ret = 0;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		ret = get_user(time, (int *)arg);
-		if (ret)
-			break;
-
-		if (orion_wdt_settimeout(time)) {
-			ret = -EINVAL;
-			break;
-		}
-		orion_wdt_ping();
-		/* Fall through */
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, (int *)arg);
-		break;
-
-	case WDIOC_GETTIMELEFT:
-		if (orion_wdt_get_timeleft(&time)) {
-			ret = -EINVAL;
-			break;
-		}
-		ret = put_user(time, (int *)arg);
-		break;
-	}
-	return ret;
-}
-
-static int orion_wdt_release(struct inode *inode, struct file *file)
-{
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		orion_wdt_disable();
-	else
-		pr_crit("Device closed unexpectedly - timer will not stop\n");
-	clear_bit(WDT_IN_USE, &wdt_status);
-	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
-	return 0;
-}
-
-
-static const struct file_operations orion_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= orion_wdt_write,
-	.unlocked_ioctl	= orion_wdt_ioctl,
-	.open		= orion_wdt_open,
-	.release	= orion_wdt_release,
+static const struct watchdog_ops orion_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = orion_wdt_start,
+	.stop = orion_wdt_stop,
+	.ping = orion_wdt_ping,
+	.set_timeout = orion_wdt_set_timeout,
+	.get_timeleft = orion_wdt_get_timeleft,
 };
 
-static struct miscdevice orion_wdt_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &orion_wdt_fops,
+static struct watchdog_device orion_wdt = {
+	.info = &orion_wdt_info,
+	.ops = &orion_wdt_ops,
 };
 
 static int __devinit orion_wdt_probe(struct platform_device *pdev)
@@ -241,29 +146,34 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	clk = clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
-		printk(KERN_ERR "Orion Watchdog missing clock\n");
+		dev_err(&pdev->dev, "Orion Watchdog missing clock\n");
 		return -ENODEV;
 	}
 	clk_prepare_enable(clk);
 	wdt_tclk = clk_get_rate(clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	wdt_reg = ioremap(res->start, resource_size(res));
-
-	if (orion_wdt_miscdev.parent)
-		return -EBUSY;
-	orion_wdt_miscdev.parent = &pdev->dev;
+	wdt_reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!wdt_reg)
+		return -ENOMEM;
 
 	wdt_max_duration = WDT_MAX_CYCLE_COUNT / wdt_tclk;
-	if (orion_wdt_settimeout(heartbeat))
+
+	if ((heartbeat < 1) || (heartbeat > wdt_max_duration))
 		heartbeat = wdt_max_duration;
 
-	ret = misc_register(&orion_wdt_miscdev);
-	if (ret)
+	orion_wdt.timeout = heartbeat;
+	orion_wdt.min_timeout = 1;
+	orion_wdt.max_timeout = wdt_max_duration;
+
+	watchdog_set_nowayout(&orion_wdt, nowayout);
+	ret = watchdog_register_device(&orion_wdt);
+	if (ret) {
+		clk_disable_unprepare(clk);
 		return ret;
+	}
 
 	pr_info("Initial timeout %d sec%s\n",
 		heartbeat, nowayout ? ", nowayout" : "");
@@ -272,27 +182,14 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 
 static int __devexit orion_wdt_remove(struct platform_device *pdev)
 {
-	int ret;
-
-	if (test_bit(WDT_IN_USE, &wdt_status)) {
-		orion_wdt_disable();
-		clear_bit(WDT_IN_USE, &wdt_status);
-	}
-
-	ret = misc_deregister(&orion_wdt_miscdev);
-	if (!ret)
-		orion_wdt_miscdev.parent = NULL;
-
+	watchdog_unregister_device(&orion_wdt);
 	clk_disable_unprepare(clk);
-	clk_put(clk);
-
-	return ret;
+	return 0;
 }
 
 static void orion_wdt_shutdown(struct platform_device *pdev)
 {
-	if (test_bit(WDT_IN_USE, &wdt_status))
-		orion_wdt_disable();
+	orion_wdt_stop(&orion_wdt);
 }
 
 static struct platform_driver orion_wdt_driver = {
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 200ece5..9245b4d 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -519,21 +519,7 @@ static struct platform_driver s3c2410wdt_driver = {
 	},
 };
 
-
-static int __init watchdog_init(void)
-{
-	pr_info("S3C2410 Watchdog Timer, (c) 2004 Simtec Electronics\n");
-
-	return platform_driver_register(&s3c2410wdt_driver);
-}
-
-static void __exit watchdog_exit(void)
-{
-	platform_driver_unregister(&s3c2410wdt_driver);
-}
-
-module_init(watchdog_init);
-module_exit(watchdog_exit);
+module_platform_driver(s3c2410wdt_driver);
 
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>, "
 	      "Dimitry Andric <dimitry.andric@tomtom.com>");
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index f847700..9681ada 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -136,6 +136,8 @@ static void sch311x_wdt_set_timeout(int t)
 
 static void sch311x_wdt_start(void)
 {
+	unsigned char t;
+
 	spin_lock(&sch311x_wdt_data.io_lock);
 
 	/* set watchdog's timeout */
@@ -149,7 +151,8 @@ static void sch311x_wdt_start(void)
 	 * Bit 4-6  (Reserved)
 	 * Bit 7,   Output Type: 0 = Push Pull Bit, 1 = Open Drain
 	 */
-	outb(0x0e, sch311x_wdt_data.runtime_reg + GP60);
+	t = inb(sch311x_wdt_data.runtime_reg + GP60);
+	outb((t & ~0x0d) | 0x0c, sch311x_wdt_data.runtime_reg + GP60);
 
 	spin_unlock(&sch311x_wdt_data.io_lock);
 
@@ -157,10 +160,13 @@ static void sch311x_wdt_start(void)
 
 static void sch311x_wdt_stop(void)
 {
+	unsigned char t;
+
 	spin_lock(&sch311x_wdt_data.io_lock);
 
 	/* stop the watchdog */
-	outb(0x01, sch311x_wdt_data.runtime_reg + GP60);
+	t = inb(sch311x_wdt_data.runtime_reg + GP60);
+	outb((t & ~0x0d) | 0x01, sch311x_wdt_data.runtime_reg + GP60);
 	/* disable timeout by setting it to 0 */
 	sch311x_wdt_set_timeout(0);
 
