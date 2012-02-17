Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2BQRxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:53:54 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:37109 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2BQRua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:50:30 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] ARM: at91:rtc/rtc-at91sam9: ioremap register bank
Date: Fri, 17 Feb 2012 18:50:04 +0100
Message-Id: <840d899dfcd707cb9fc282d6f04c6645fd3b84fe.1329500622.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
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

