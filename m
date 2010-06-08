Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0FHHJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 03:09:33 -0400
Received: from relay.atmel.no ([80.232.32.139]:59457 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab0FHHJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 03:09:31 -0400
X-Greylist: delayed 1374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2010 03:09:31 EDT
Date: Tue, 8 Jun 2010 08:46:28 +0200
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: setting miscdevice.parent after misc_register()
Message-ID: <20100608084628.282f73ad@hcegtvedt.norway.atmel.com>
In-Reply-To: <AANLkTilDZdke5V6TYtDheK9rCaxTDHqtoPR7I_tEvFR2@mail.gmail.com>
References: <AANLkTilDZdke5V6TYtDheK9rCaxTDHqtoPR7I_tEvFR2@mail.gmail.com>
Organization: Atmel Corporation
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010 12:11:44 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> In drivers/watchdog/at32ap700x_wdt.c, and drivers/watchdog/sch311x_wdt.c
> miscdevice.parent is set after misc_register().
> 
> drivers/watchdog/at32ap700x_wdt.c:
> 
> 	ret = misc_register(&wdt->miscdev);
> 	...
> 	wdt->miscdev.parent = &pdev->dev;
> 
> But it does nothing. (the miscdevice will not be a child of that parent
> device in sysfs)
> 
> So should it be set before misc_register() or just keep it as-is?

AFAICT I think it is unsafe to have misc_register() before the last
parts of the probe function. The misc_register() should be the last
call in _probe().

Something ala the following...

>From 8439126716c3cf887c6453c9543cca5b58ac9c81 Mon Sep 17 00:00:00 2001
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Date: Tue, 8 Jun 2010 08:44:32 +0200
Subject: [PATCH] at32ap700x_wdt: register misc device last in probe() function

This patch reworks the probe() function in the at32ap700x_wdt driver, this to
make sure the miscdev is properly initialized and the driver is ready to be
accessed.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 drivers/watchdog/at32ap700x_wdt.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

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
-- 
1.6.3.3

-- 
Best regards,
Hans-Christian Egtvedt
