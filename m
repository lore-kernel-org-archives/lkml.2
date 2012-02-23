Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab2BWO0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:26:46 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:49495 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab2BWO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:26:43 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, rmallon@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de
Subject: [PATCH v3 14/21] ARM: at91:rtc/rtc-at91sam9: ioremap register bank
Date: Thu, 23 Feb 2012 15:25:58 +0100
Message-Id: <4e9267f1b42b4f7b66214161b55f1f73365692cd.1330006537.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1330006537.git.nicolas.ferre@atmel.com>
References: <cover.1330006537.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Instead of computing virtual address with AT91_VA_BASE_SYS, use the
appropriate ioremap() call on the driver "memory" resource.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/rtc/rtc-at91sam9.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 65896a3..08b69fd 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -307,8 +307,12 @@ static int __devinit at91_rtc_probe(struct platform_device *pdev)
 		device_init_wakeup(&pdev->dev, 1);
 
 	platform_set_drvdata(pdev, rtc);
-	rtc->rtt = (void __force __iomem *) (AT91_VA_BASE_SYS - AT91_BASE_SYS);
-	rtc->rtt += r->start;
+	rtc->rtt = ioremap(r->start, resource_size(r));
+	if (!rtc->rtt) {
+		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
 
 	mr = rtt_readl(rtc, MR);
 
@@ -326,7 +330,7 @@ static int __devinit at91_rtc_probe(struct platform_device *pdev)
 				&at91_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtcdev)) {
 		ret = PTR_ERR(rtc->rtcdev);
-		goto fail;
+		goto fail_register;
 	}
 
 	/* register irq handler after we know what name we'll use */
@@ -351,6 +355,8 @@ static int __devinit at91_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
+fail_register:
+	iounmap(rtc->rtt);
 fail:
 	platform_set_drvdata(pdev, NULL);
 	kfree(rtc);
@@ -371,6 +377,7 @@ static int __devexit at91_rtc_remove(struct platform_device *pdev)
 
 	rtc_device_unregister(rtc->rtcdev);
 
+	iounmap(rtc->rtt);
 	platform_set_drvdata(pdev, NULL);
 	kfree(rtc);
 	return 0;
-- 
1.7.9

