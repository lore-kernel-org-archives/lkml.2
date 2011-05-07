Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1EGBVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:21:45 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45175 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab1EGBVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:08 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Subject: [PATCH 09/11] rtc: pcap: Initialize drvdata before registering device
Date: Fri,  6 May 2011 18:20:52 -0700
Message-Id: <1304731254-3238-10-git-send-email-john.stultz@linaro.org>
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
 drivers/rtc/rtc-pcap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index a633abc..cd4f198 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -151,6 +151,8 @@ static int __devinit pcap_rtc_probe(struct platform_device *pdev)
 
 	pcap_rtc->pcap = dev_get_drvdata(pdev->dev.parent);
 
+	platform_set_drvdata(pdev, pcap_rtc);
+
 	pcap_rtc->rtc = rtc_device_register("pcap", &pdev->dev,
 				  &pcap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pcap_rtc->rtc)) {
@@ -158,7 +160,6 @@ static int __devinit pcap_rtc_probe(struct platform_device *pdev)
 		goto fail_rtc;
 	}
 
-	platform_set_drvdata(pdev, pcap_rtc);
 
 	timer_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ);
 	alarm_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA);
@@ -177,6 +178,7 @@ fail_alarm:
 fail_timer:
 	rtc_device_unregister(pcap_rtc->rtc);
 fail_rtc:
+	platform_set_drvdata(pdev, NULL);
 	kfree(pcap_rtc);
 	return err;
 }
-- 
1.7.3.2.146.gca209

