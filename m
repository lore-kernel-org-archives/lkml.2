Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1EGBVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:21:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41421 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1EGBVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:04 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 11/11] rtc: mc13xxx: Don't call rtc_device_register while holding lock
Date: Fri,  6 May 2011 18:20:54 -0700
Message-Id: <1304731254-3238-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
References: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Since commit f44f7f9 (RTC: Initialize kernel state from RTC)
rtc_device_register reads the programmed alarm. As reading the alarm
needs to take the mc13xxx lock, release it before calling
rtc_device_register.

This fixes a deadlock during boot:

	INFO: task swapper:1 blocked for more than 120 seconds.
	"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
	swapper         D c02b175c     0     1      0 0x00000000
	[<c02b175c>] (schedule+0x304/0x4f4) from [<c02b25a8>] (__mutex_lock_slowpath+0x7c/0x110)
	[<c02b25a8>] (__mutex_lock_slowpath+0x7c/0x110) from [<c020b4cc>] (mc13xxx_rtc_read_time+0x1c/0x118)
	[<c020b4cc>] (mc13xxx_rtc_read_time+0x1c/0x118) from [<c0208f04>] (__rtc_read_time+0x58/0x5c)
	[<c0208f04>] (__rtc_read_time+0x58/0x5c) from [<c0209508>] (rtc_read_time+0x30/0x48)
	[<c0209508>] (rtc_read_time+0x30/0x48) from [<c0209dd4>] (__rtc_read_alarm+0x1c/0x290)
	[<c0209dd4>] (__rtc_read_alarm+0x1c/0x290) from [<c0208d58>] (rtc_device_register+0x150/0x27c)
	[<c0208d58>] (rtc_device_register+0x150/0x27c) from [<c02b0b74>] (mc13xxx_rtc_probe+0x128/0x17c)
	[<c02b0b74>] (mc13xxx_rtc_probe+0x128/0x17c) from [<c01d5280>] (platform_drv_probe+0x1c/0x24)
	[<c01d5280>] (platform_drv_probe+0x1c/0x24) from [<c01d3e58>] (driver_probe_device+0x80/0x1a8)
	[<c01d3e58>] (driver_probe_device+0x80/0x1a8) from [<c01d400c>] (__driver_attach+0x8c/0x90)
	[<c01d400c>] (__driver_attach+0x8c/0x90) from [<c01d3654>] (bus_for_each_dev+0x60/0x8c)
	[<c01d3654>] (bus_for_each_dev+0x60/0x8c) from [<c01d2f6c>] (bus_add_driver+0x180/0x248)
	[<c01d2f6c>] (bus_add_driver+0x180/0x248) from [<c01d4664>] (driver_register+0x70/0x15c)
	[<c01d4664>] (driver_register+0x70/0x15c) from [<c01d5700>] (platform_driver_probe+0x18/0x98)
	[<c01d5700>] (platform_driver_probe+0x18/0x98) from [<c00273a8>] (do_one_initcall+0x2c/0x168)
	[<c00273a8>] (do_one_initcall+0x2c/0x168) from [<c00083ac>] (kernel_init+0xa0/0x150)
	[<c00083ac>] (kernel_init+0xa0/0x150) from [<c0033ff8>] (kernel_thread_exit+0x0/0x8)

Reported-by: Vagrant Cascadian <vagrant@debian.org>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Closes: http://bugs.debian.org/625804
[Tweaked commit log -jstultz]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-mc13xxx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index c5ac037..a1a278b 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -349,11 +349,15 @@ static int __devinit mc13xxx_rtc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_alarm_irq_request;
 
+	mc13xxx_unlock(mc13xxx);
+
 	priv->rtc = rtc_device_register(pdev->name,
 			&pdev->dev, &mc13xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(priv->rtc)) {
 		ret = PTR_ERR(priv->rtc);
 
+		mc13xxx_lock(mc13xxx);
+
 		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_TODA, priv);
 err_alarm_irq_request:
 
@@ -365,12 +369,12 @@ err_reset_irq_status:
 		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_RTCRST, priv);
 err_reset_irq_request:
 
+		mc13xxx_unlock(mc13xxx);
+
 		platform_set_drvdata(pdev, NULL);
 		kfree(priv);
 	}
 
-	mc13xxx_unlock(mc13xxx);
-
 	return ret;
 }
 
-- 
1.7.3.2.146.gca209

