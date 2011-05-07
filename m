Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1EGBVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:21:54 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36718 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab1EGBVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:07 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Subject: [PATCH 06/11] rtc: max8925: Initialize drvdata before registering device
Date: Fri,  6 May 2011 18:20:49 -0700
Message-Id: <1304731254-3238-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
References: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f44f7f96a20 ("RTC: Initialize kernel state from RTC") uncovered
an issue in a number of RTC drivers, where the drivers call
rtc_device_register before initializing the device or platform drvdata.

This frequently results in null pointer dereferences when the
rtc_device_register immediately makes use of the rtc device, calling
rtc_read_alarm.

The solution is to ensure the drvdata is initialized prior to registering
the rtc device.

CC: Wolfram Sang <w.sang@pengutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: rtc-linux@googlegroups.com
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-max8925.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 20494b5..3bc046f 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -258,6 +258,8 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 	}
 
 	dev_set_drvdata(&pdev->dev, info);
+	/* XXX - isn't this redundant? */
+	platform_set_drvdata(pdev, info);
 
 	info->rtc_dev = rtc_device_register("max8925-rtc", &pdev->dev,
 					&max8925_rtc_ops, THIS_MODULE);
@@ -267,10 +269,9 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 		goto out_rtc;
 	}
 
-	platform_set_drvdata(pdev, info);
-
 	return 0;
 out_rtc:
+	platform_set_drvdata(pdev, NULL);
 	free_irq(chip->irq_base + MAX8925_IRQ_RTC_ALARM0, info);
 out_irq:
 	kfree(info);
-- 
1.7.3.2.146.gca209

