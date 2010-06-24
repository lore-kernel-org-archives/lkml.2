Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0FXJAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:00:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35940 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0FXJAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=mrqSbpW4e48OotleRjuiXRGOr2s8N57ysv/FJsbCLLZaXIoBGJt7JAaf4JVKpNxtb9
         AskuUVYMMGOVsUT+rgpwk29+BHzy32Hk/fnfVWj66xhzxXqaSMRWJH+xJ1FXzl7/ASBb
         8uty60bJNi7NGR2gx5cBW5+1trjbL3LaZZaew=
Message-ID: <4C231EA3.8080107@gmail.com>
Date: Thu, 24 Jun 2010 17:00:19 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rtc-linux <rtc-linux@googlegroups.com>
Subject: [PATCH 2/3] RTC/nuc900:  patch for modifying enable/disable IRQs
 and driver data setting location
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does two modifications:

(1) Adjust enable/disable IRQs location,enable it after rtc registration
and disable it prior to unregistration.
(2) Put 'platform_set_drvdata(pdev, nuc900_rtc)' in front of rtc registration still
be safety, though there is no need to do this, when I move enable irq after
rtc registration, I think still put 'platform_set_drvdata' before rtc registration
that would be a good habit.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/rtc/rtc-nuc900.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 84336d1..0267ea3 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -269,29 +269,30 @@ static int __devinit nuc900_rtc_probe(struct platform_device *pdev)
 		goto fail2;
 	}

-	nuc900_rtc->irq_num = platform_get_irq(pdev, 0);
-	if (request_irq(nuc900_rtc->irq_num, nuc900_rtc_interrupt,
-				IRQF_DISABLED, "nuc900rtc", nuc900_rtc)) {
-		dev_err(&pdev->dev, "NUC900 RTC request irq failed\n");
-		err = -EBUSY;
-		goto fail3;
-	}
+	platform_set_drvdata(pdev, nuc900_rtc);

 	nuc900_rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
 						&nuc900_rtc_ops, THIS_MODULE);
 	if (IS_ERR(nuc900_rtc->rtcdev)) {
 		dev_err(&pdev->dev, "rtc device register faild\n");
 		err = PTR_ERR(nuc900_rtc->rtcdev);
-		goto fail4;
+		goto fail3;
 	}

-	platform_set_drvdata(pdev, nuc900_rtc);
 	__raw_writel(__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_TSSR) | MODE24,
 					nuc900_rtc->rtc_reg + REG_RTC_TSSR);

+	nuc900_rtc->irq_num = platform_get_irq(pdev, 0);
+	if (request_irq(nuc900_rtc->irq_num, nuc900_rtc_interrupt,
+				IRQF_DISABLED, "nuc900rtc", nuc900_rtc)) {
+		dev_err(&pdev->dev, "NUC900 RTC request irq failed\n");
+		err = -EBUSY;
+		goto fail4;
+	}
+
 	return 0;

-fail4:	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
+fail4:	rtc_device_unregister(nuc900_rtc->rtcdev);
 fail3:	iounmap(nuc900_rtc->rtc_reg);
 fail2:	release_mem_region(res->start, resource_size(res));
 fail1:	kfree(nuc900_rtc);
@@ -303,8 +304,8 @@ static int __devexit nuc900_rtc_remove(struct platform_device *pdev)
 	struct nuc900_rtc *nuc900_rtc = platform_get_drvdata(pdev);
 	struct resource *res;

-	rtc_device_unregister(nuc900_rtc->rtcdev);
 	free_irq(nuc900_rtc->irq_num, nuc900_rtc);
+	rtc_device_unregister(nuc900_rtc->rtcdev);
 	iounmap(nuc900_rtc->rtc_reg);

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.6.3.3
