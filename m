Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab0FQKBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 06:01:17 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:21399 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932858Ab0FQKBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 06:01:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMKPGUxR9cRp/2dsb2JhbACed3K/bA6FDAQ
Date: Thu, 17 Jun 2010 12:01:13 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Baruch Siach <baruch@tkos.co.il>,
       Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: [WATCHDOG] 2.6.35-rc4 patches
Message-ID: <20100617100113.GB3788@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

 drivers/watchdog/at32ap700x_wdt.c |   16 ++++++++++------
 drivers/watchdog/imx2_wdt.c       |    1 -
 2 files changed, 10 insertions(+), 7 deletions(-)

with these Changes:

Author: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Date:   Tue Jun 8 08:44:32 2010 +0200

    watchdog: at32ap700x_wdt: register misc device last in probe() function
    
    This patch reworks the probe() function in the at32ap700x_wdt driver, this to
    make sure the miscdev is properly initialized and the driver is ready to be
    accessed.
    
    Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
    Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
    Signed-off-by: Wim Van sebroeck <wim@iguana.be>

Author: Baruch Siach <baruch@tkos.co.il>
Date:   Wed Jun 9 14:07:02 2010 +0300

    watchdog: [PATCH 3/3] imx2_wdt: fix section mismatch
    
    Signed-off-by: Baruch Siach <baruch@tkos.co.il>
    Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 1cddf92..750bc52 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -346,9 +346,13 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 	} else {
 		wdt->users = 0;
 	}
-	wdt->miscdev.minor = WATCHDOG_MINOR;
-	wdt->miscdev.name = "watchdog";
-	wdt->miscdev.fops = &at32_wdt_fops;
+
+	wdt->miscdev.minor	= WATCHDOG_MINOR;
+	wdt->miscdev.name	= "watchdog";
+	wdt->miscdev.fops	= &at32_wdt_fops;
+	wdt->miscdev.parent	= &pdev->dev;
+
+	platform_set_drvdata(pdev, wdt);
 
 	if (at32_wdt_settimeout(timeout)) {
 		at32_wdt_settimeout(TIMEOUT_DEFAULT);
@@ -360,17 +364,17 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 	ret = misc_register(&wdt->miscdev);
 	if (ret) {
 		dev_dbg(&pdev->dev, "failed to register wdt miscdev\n");
-		goto err_iounmap;
+		goto err_register;
 	}
 
-	platform_set_drvdata(pdev, wdt);
-	wdt->miscdev.parent = &pdev->dev;
 	dev_info(&pdev->dev,
 		"AT32AP700X WDT at 0x%p, timeout %d sec (nowayout=%d)\n",
 		wdt->regs, wdt->timeout, nowayout);
 
 	return 0;
 
+err_register:
+	platform_set_drvdata(pdev, NULL);
 err_iounmap:
 	iounmap(wdt->regs);
 err_free:
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index ea25885..2ee7dac 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -330,7 +330,6 @@ static void imx2_wdt_shutdown(struct platform_device *pdev)
 }
 
 static struct platform_driver imx2_wdt_driver = {
-	.probe		= imx2_wdt_probe,
 	.remove		= __exit_p(imx2_wdt_remove),
 	.shutdown	= imx2_wdt_shutdown,
 	.driver		= {
