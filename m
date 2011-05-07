Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1EGBXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:23:43 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53745 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1EGBVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:06 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Subject: [PATCH 08/11] rtc: msm6242: Initialize drvdata before registering device
Date: Fri,  6 May 2011 18:20:51 -0700
Message-Id: <1304731254-3238-9-git-send-email-john.stultz@linaro.org>
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
 drivers/rtc/rtc-msm6242.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index 6782062..fcb113c 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -214,6 +214,7 @@ static int __init msm6242_rtc_probe(struct platform_device *dev)
 		error = -ENOMEM;
 		goto out_free_priv;
 	}
+	platform_set_drvdata(dev, priv);
 
 	rtc = rtc_device_register("rtc-msm6242", &dev->dev, &msm6242_rtc_ops,
 				  THIS_MODULE);
@@ -223,10 +224,10 @@ static int __init msm6242_rtc_probe(struct platform_device *dev)
 	}
 
 	priv->rtc = rtc;
-	platform_set_drvdata(dev, priv);
 	return 0;
 
 out_unmap:
+	platform_set_drvdata(dev, NULL);
 	iounmap(priv->regs);
 out_free_priv:
 	kfree(priv);
-- 
1.7.3.2.146.gca209

