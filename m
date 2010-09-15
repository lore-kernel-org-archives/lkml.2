Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0IOSxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:53:37 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:29398 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281Ab0IOSxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:53:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACezkExQydCd/2dsb2JhbAChbXLGXw2CZIJQBJAL
Date: Wed, 15 Sep 2010 20:53:33 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Sharp <andy.sharp@lsi.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Kevin Wells <wellsk40@gmail.com>
Subject: [WATCHDOG] v2.6.36-rc4 patches
Message-ID: <20100915185333.GX354@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig      |    6 +++---
 drivers/watchdog/sb_wdog.c    |   12 +++++++++---
 drivers/watchdog/ts72xx_wdt.c |    3 +++
 3 files changed, 15 insertions(+), 6 deletions(-)

with these Changes:

Author: Kevin Wells <wellsk40@gmail.com>
Date:   Tue Aug 17 17:45:28 2010 -0700

    watchdog: Enable NXP LPC32XX support in Kconfig (resend)
    
    The NXP LPC32XX processor use the same watchdog as the Philips
    PNX4008 processor.
    
    Signed-off-by: Kevin Wells <wellsk40@gmail.com>
    Tested-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mika Westerberg <mika.westerberg@iki.fi>
Date:   Sun Aug 29 13:53:14 2010 +0300

    watchdog: ts72xx_wdt: disable watchdog at probe
    
    Since it may be already enabled by bootloader or some other utility. This patch
    makes sure that the watchdog is disabled before any userspace daemon opens the
    device. It is also required by the watchdog API.
    
    Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Akinobu Mita <akinobu.mita@gmail.com>
Date:   Sat Aug 21 18:27:50 2010 +0900

    watchdog: sb_wdog: release irq and reboot notifier in error path and module_exit()
    
    irq and reboot notifier are acquired in module_init() but never released.
    They should be released correctly, otherwise reloading the module or error
    during module_init() will cause a problem.
    
    Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
    Cc: Andrew Sharp <andy.sharp@lsi.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b036677..24efd8e 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -213,11 +213,11 @@ config OMAP_WATCHDOG
 	  here to enable the OMAP1610/OMAP1710/OMAP2420/OMAP3430/OMAP4430 watchdog timer.
 
 config PNX4008_WATCHDOG
-	tristate "PNX4008 Watchdog"
-	depends on ARCH_PNX4008
+	tristate "PNX4008 and LPC32XX Watchdog"
+	depends on ARCH_PNX4008 || ARCH_LPC32XX
 	help
 	  Say Y here if to include support for the watchdog timer
-	  in the PNX4008 processor.
+	  in the PNX4008 or LPC32XX processor.
 	  This driver can be built as a module by choosing M. The module
 	  will be called pnx4008_wdt.
 
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index 88c83aa..f31493e 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -305,7 +305,7 @@ static int __init sbwdog_init(void)
 	if (ret) {
 		printk(KERN_ERR "%s: failed to request irq 1 - %d\n",
 						ident.identity, ret);
-		return ret;
+		goto out;
 	}
 
 	ret = misc_register(&sbwdog_miscdev);
@@ -313,14 +313,20 @@ static int __init sbwdog_init(void)
 		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n",
 				ident.identity,
 				timeout / 1000000, (timeout / 100000) % 10);
-	} else
-		free_irq(1, (void *)user_dog);
+		return 0;
+	}
+	free_irq(1, (void *)user_dog);
+out:
+	unregister_reboot_notifier(&sbwdog_notifier);
+
 	return ret;
 }
 
 static void __exit sbwdog_exit(void)
 {
 	misc_deregister(&sbwdog_miscdev);
+	free_irq(1, (void *)user_dog);
+	unregister_reboot_notifier(&sbwdog_notifier);
 }
 
 module_init(sbwdog_init);
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 458c499..18cdeb4 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -449,6 +449,9 @@ static __devinit int ts72xx_wdt_probe(struct platform_device *pdev)
 	wdt->pdev = pdev;
 	mutex_init(&wdt->lock);
 
+	/* make sure that the watchdog is disabled */
+	ts72xx_wdt_stop(wdt);
+
 	error = misc_register(&ts72xx_wdt_miscdev);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register miscdev\n");
