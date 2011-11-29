Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1K2Pb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:31:29 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:10626 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879Ab1K2Pb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:31:28 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADz41E5R8sT5/2dsb2JhbABDqniBBoFzAQUnExwjEAgRBjIUJQMhE4gHtzsSiiljBJRTkhM
Date: Tue, 29 Nov 2011 16:27:59 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marc Vertes <marc.vertes@sigfox.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: [PATCH v2] watchdog: add nowayout helpers to Watchdog Timer Driver
	Kernel API
Message-ID: <20111129152759.GA11299@infomag.iguana.be>
References: <20111129111430.GA17609@infomag.iguana.be> <20111129114744.GA21542@infomag.iguana.be> <20111129115813.GF5455@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129115813.GF5455@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The patch like it is in the linux-next branch of the watchdog tree since a couple of minutes.

Kind regards,
Wim.

commit 3d17ee59111dd2311e5904294246d5b848342550
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Nov 29 16:24:16 2011 +0100

    watchdog: add nowayout helpers to Watchdog Timer Driver Kernel API
    
    Add two nowayout helpers for the Watchdog Timer Driver Kernel API.
    And apply this to the already converted drivers.
    Note: s3c2410_wdt lost the nowayout feature during the conversion.
    
    Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
    Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 4f7c894..4b93c28 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -1,6 +1,6 @@
 The Linux WatchDog Timer Driver Core kernel API.
 ===============================================
-Last reviewed: 22-Jul-2011
+Last reviewed: 29-Nov-2011
 
 Wim Van Sebroeck <wim@iguana.be>
 
@@ -142,6 +142,14 @@ bit-operations. The status bits that are defined are:
 * WDOG_NO_WAY_OUT: this bit stores the nowayout setting for the watchdog.
   If this bit is set then the watchdog timer will not be able to stop.
 
+  To set the WDOG_NO_WAY_OUT status bit (before registering your watchdog
+  timer device) you can either:
+  * set it statically in your watchdog_device struct with
+	.status = WATCHDOG_NOWAYOUT_INIT_STATUS,
+    (this will set the value the same as CONFIG_WATCHDOG_NOWAYOUT) or
+  * use the following helper function:
+  static inline void watchdog_set_nowayout(struct watchdog_device *wdd, int nowayout)
+
 Note: The WatchDog Timer Driver Core supports the magic close feature and
 the nowayout feature. To use the magic close feature you must set the
 WDIOF_MAGICCLOSE bit in the options field of the watchdog's info structure.
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index a79e384..4bc3744 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -378,6 +378,8 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 							"cannot start\n");
 	}
 
+	watchdog_set_nowayout(&s3c2410_wdd, nowayout);
+
 	ret = watchdog_register_device(&s3c2410_wdd);
 	if (ret) {
 		dev_err(dev, "cannot register watchdog (%d)\n", ret);
diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index beb3ad2..6cd1ba4 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -213,11 +213,9 @@ static int __devinit wm831x_wdt_probe(struct platform_device *pdev)
 
 	wm831x_wdt->info = &wm831x_wdt_info;
 	wm831x_wdt->ops = &wm831x_wdt_ops;
+	watchdog_set_nowayout(wm831x_wdt, nowayout);
 	watchdog_set_drvdata(wm831x_wdt, driver_data);
 
-	if (nowayout)
-		wm831x_wdt->status |= WDOG_NO_WAY_OUT;
-
 	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
 	reg &= WM831X_WDOG_TO_MASK;
 	for (i = 0; i < ARRAY_SIZE(wm831x_wdt_cfgs); i++)
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 111843f..43ba5b3 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -53,11 +53,7 @@ struct watchdog_info {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_WATCHDOG_NOWAYOUT
-#define WATCHDOG_NOWAYOUT	1
-#else
-#define WATCHDOG_NOWAYOUT	0
-#endif
+#include <linux/bitops.h>
 
 struct watchdog_ops;
 struct watchdog_device;
@@ -122,6 +118,21 @@ struct watchdog_device {
 #define WDOG_NO_WAY_OUT		3	/* Is 'nowayout' feature set ? */
 };
 
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
+#define WATCHDOG_NOWAYOUT		1
+#define WATCHDOG_NOWAYOUT_INIT_STATUS	(1 << WDOG_NO_WAY_OUT)
+#else
+#define WATCHDOG_NOWAYOUT		0
+#define WATCHDOG_NOWAYOUT_INIT_STATUS	0
+#endif
+
+/* Use the following function to set the nowayout feature */
+static inline void watchdog_set_nowayout(struct watchdog_device *wdd, int nowayout)
+{
+	if (nowayout)
+		set_bit(WDOG_NO_WAY_OUT, &wdd->status);
+}
+
 /* Use the following functions to manipulate watchdog driver specific data */
 static inline void watchdog_set_drvdata(struct watchdog_device *wdd, void *data)
 {
