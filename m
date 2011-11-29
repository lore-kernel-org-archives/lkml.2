Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1K2FyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:54:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39707 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1K2FyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:54:15 -0500
Message-ID: <1322546041.9040.1.camel@phoenix>
Subject: [PATCH 1/2 (resend)] watchdog: Use DEFINE_SPINLOCK() for static
 spinlocks
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Thill <nico@openwrt.org>,
        Heiko Ronsdorf <hero@ihg.uni-duisburg.de>,
        Rodolfo Giometti <giometti@ascensit.com>,
        Andrey Panin <pazke@donpac.ru>, Guido Guenther <agx@sigxcpu.org>,
        Curt E Bruns <curt.e.bruns@intel.com>,
        Deepak Saxena <dsaxena@plexity.net>,
        Andrew Victor <linux@maxim.org.za>,
        "George G. Davis" <gdavis@mvista.com>,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        linux-watchdog@vger.kernel.org
Date: Tue, 29 Nov 2011 13:54:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than just defining static spinlock_t variables and then
initializing them later in init functions, simply define them with
DEFINE_SPINLOCK() and remove the calls to spin_lock_init().

Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Nicolas Thill <nico@openwrt.org>
Cc: Heiko Ronsdorf <hero@ihg.uni-duisburg.de>
Cc: Rodolfo Giometti <giometti@ascensit.com>
Cc: Andrey Panin <pazke@donpac.ru>
Cc: Guido Guenther <agx@sigxcpu.org>
Cc: Curt E Bruns <curt.e.bruns@intel.com>
Cc: Deepak Saxena <dsaxena@plexity.net>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: George G. Davis <gdavis@mvista.com>
Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch was sent on http://www.spinics.net/lists/linux-watchdog/msg00775.html
Here is a resend because next patch depends on this one.
Some module_init functions that only calls spin_lock_init() and
platform_driver_register() can be converted to module_platform_driver macro after
this patch.

Regards,
Axel

 drivers/watchdog/ar7_wdt.c     |    4 +---
 drivers/watchdog/cpu5wdt.c     |    3 +--
 drivers/watchdog/eurotechwdt.c |    4 +---
 drivers/watchdog/ibmasr.c      |    4 +---
 drivers/watchdog/indydog.c     |    4 +---
 drivers/watchdog/iop_wdt.c     |    5 +----
 drivers/watchdog/ixp2000_wdt.c |    3 +--
 drivers/watchdog/ixp4xx_wdt.c  |    1 -
 drivers/watchdog/ks8695_wdt.c  |    3 +--
 drivers/watchdog/omap_wdt.c    |    3 +--
 drivers/watchdog/orion_wdt.c   |    3 +--
 11 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index b292217..b9564c5 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -70,8 +70,8 @@ struct ar7_wdt {
 };
 
 static unsigned long wdt_is_open;
-static spinlock_t wdt_lock;
 static unsigned expect_close;
+static DEFINE_SPINLOCK(wdt_lock);
 
 /* XXX currently fixed, allows max margin ~68.72 secs */
 #define prescale_value 0xffff
@@ -280,8 +280,6 @@ static int __devinit ar7_wdt_probe(struct platform_device *pdev)
 {
 	int rc;
 
-	spin_lock_init(&wdt_lock);
-
 	ar7_regs_wdt =
 		platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
 	if (!ar7_regs_wdt) {
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index edd3475..251c863 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -39,7 +39,7 @@
 static int verbose;
 static int port = 0x91;
 static int ticks = 10000;
-static spinlock_t cpu5wdt_lock;
+static DEFINE_SPINLOCK(cpu5wdt_lock);
 
 #define PFX			"cpu5wdt: "
 
@@ -223,7 +223,6 @@ static int __devinit cpu5wdt_init(void)
 				"port=0x%x, verbose=%i\n", port, verbose);
 
 	init_completion(&cpu5wdt_device.stop);
-	spin_lock_init(&cpu5wdt_lock);
 	cpu5wdt_device.queue = 0;
 	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
 	cpu5wdt_device.default_ticks = ticks;
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 41018d4..3946c51 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -64,7 +64,7 @@
 static unsigned long eurwdt_is_open;
 static int eurwdt_timeout;
 static char eur_expect_close;
-static spinlock_t eurwdt_lock;
+static DEFINE_SPINLOCK(eurwdt_lock);
 
 /*
  * You must set these - there is no sane way to probe for this board.
@@ -446,8 +446,6 @@ static int __init eurwdt_init(void)
 		goto outreg;
 	}
 
-	spin_lock_init(&eurwdt_lock);
-
 	ret = misc_register(&eurwdt_miscdev);
 	if (ret) {
 		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index 195e0f7..c7481ad 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -68,7 +68,7 @@ static char asr_expect_close;
 static unsigned int asr_type, asr_base, asr_length;
 static unsigned int asr_read_addr, asr_write_addr;
 static unsigned char asr_toggle_mask, asr_disable_mask;
-static spinlock_t asr_lock;
+static DEFINE_SPINLOCK(asr_lock);
 
 static void __asr_toggle(void)
 {
@@ -386,8 +386,6 @@ static int __init ibmasr_init(void)
 	if (!asr_type)
 		return -ENODEV;
 
-	spin_lock_init(&asr_lock);
-
 	rc = asr_get_base_address();
 	if (rc)
 		return rc;
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 1cc5609..1475e09 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -28,7 +28,7 @@
 
 #define PFX "indydog: "
 static unsigned long indydog_alive;
-static spinlock_t indydog_lock;
+static DEFINE_SPINLOCK(indydog_lock);
 
 #define WATCHDOG_TIMEOUT 30		/* 30 sec default timeout */
 
@@ -185,8 +185,6 @@ static int __init watchdog_init(void)
 {
 	int ret;
 
-	spin_lock_init(&indydog_lock);
-
 	ret = register_reboot_notifier(&indydog_notifier);
 	if (ret) {
 		printk(KERN_ERR PFX
diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index aef9478..82fa7a9 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -37,7 +37,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned long wdt_status;
 static unsigned long boot_status;
-static spinlock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
@@ -226,9 +226,6 @@ static int __init iop_wdt_init(void)
 {
 	int ret;
 
-	spin_lock_init(&wdt_lock);
-
-
 	/* check if the reset was caused by the watchdog timer */
 	boot_status = (read_rcsr() & IOP_RCSR_WDT) ? WDIOF_CARDRESET : 0;
 
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index e86952a..084f71aa 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -32,7 +32,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
-static spinlock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
@@ -189,7 +189,6 @@ static int __init ixp2000_wdt_init(void)
 		return -EIO;
 	}
 	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
-	spin_lock_init(&wdt_lock);
 	return misc_register(&ixp2000_wdt_miscdev);
 }
 
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index e02c0ec..4fc2e9a 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -181,7 +181,6 @@ static int __init ixp4xx_wdt_init(void)
 
 		return -ENODEV;
 	}
-	spin_lock_init(&wdt_lock);
 	boot_status = (*IXP4XX_OSST & IXP4XX_OSST_TIMER_WARM_RESET) ?
 			WDIOF_CARDRESET : 0;
 	ret = misc_register(&ixp4xx_wdt_miscdev);
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 8114719..51757a5 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -42,7 +42,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 
 
 static unsigned long ks8695wdt_busy;
-static spinlock_t ks8695_lock;
+static DEFINE_SPINLOCK(ks8695_lock);
 
 /* ......................................................................... */
 
@@ -288,7 +288,6 @@ static struct platform_driver ks8695wdt_driver = {
 
 static int __init ks8695_wdt_init(void)
 {
-	spin_lock_init(&ks8695_lock);
 	/* Check that the heartbeat value is within range;
 	   if not reset to the default */
 	if (ks8695_wdt_settimeout(wdt_time)) {
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 2b4acb8..cd269b4 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -55,7 +55,7 @@ module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
 static unsigned int wdt_trgr_pattern = 0x1234;
-static spinlock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 struct omap_wdt_dev {
 	void __iomem    *base;          /* physical */
@@ -439,7 +439,6 @@ static struct platform_driver omap_wdt_driver = {
 
 static int __init omap_wdt_init(void)
 {
-	spin_lock_init(&wdt_lock);
 	return platform_driver_register(&omap_wdt_driver);
 }
 
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 2d9fb96..66bd97f 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -41,7 +41,7 @@ static int heartbeat = -1;		/* module parameter (seconds) */
 static unsigned int wdt_max_duration;	/* (seconds) */
 static unsigned int wdt_tclk;
 static unsigned long wdt_status;
-static spinlock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 static void orion_wdt_ping(void)
 {
@@ -296,7 +296,6 @@ static struct platform_driver orion_wdt_driver = {
 
 static int __init orion_wdt_init(void)
 {
-	spin_lock_init(&wdt_lock);
 	return platform_driver_register(&orion_wdt_driver);
 }
 
-- 
1.7.5.4



