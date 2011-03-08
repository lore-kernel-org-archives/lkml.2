Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab1CHHOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 02:14:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:24722 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1CHHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 02:14:41 -0500
Date: Tue, 08 Mar 2011 15:58:34 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] RTC: Selectively enable PIE-Hrtimer emulation.
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1299567514-23375-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 08 Mar 2011 06:58:35.0437 (UTC)
 FILETIME=[3E6FCDD0:01CBDD5E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch of John Stultz, "RTC: Rework RTC code to use timerqueue for
events", enables PIE interrupt emulation with hrtimer unconditionally.
However, we do have RTC devices that support PIE and such devices are
not meant to be emulated by hrtimer.

This patch allows not to use the PIE emulation if the rtc device driver
has implemented PIE related features. Currently, rtc-s3c, rtc-cmos,
rtc-davinci, rtc-pl031, rtc-pxa, rtc-sa1100, rtc-sh, and rtc-vt41xx have
them.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/interface.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index cb2f072..f2f1c9c 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -450,16 +450,24 @@ int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task, int enabled
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
+	if (err)
+		goto out;
 
-	if (enabled) {
-		ktime_t period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
-		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
+	if (rtc->ops->irq_set_state) {
+		err = rtc->ops->irq_set_state(rtc->dev.parent, enabled);
 	} else {
-		hrtimer_cancel(&rtc->pie_timer);
+		if (enabled) {
+			ktime_t period = ktime_set(0, NSEC_PER_SEC /
+							rtc->irq_freq);
+			hrtimer_start(&rtc->pie_timer, period,
+					HRTIMER_MODE_REL);
+		} else {
+			hrtimer_cancel(&rtc->pie_timer);
+		}
+		rtc->pie_enabled = enabled;
 	}
-	rtc->pie_enabled = enabled;
+out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_state);
@@ -487,7 +495,14 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
-	if (err == 0) {
+	if (err)
+		goto out;
+
+	if (rtc->ops->irq_set_freq) {
+		err = rtc->ops->irq_set_freq(rtc->dev.parent, freq);
+		if (err == 0)
+			rtc->irq_freq = freq;
+	} else {
 		rtc->irq_freq = freq;
 		if (rtc->pie_enabled) {
 			ktime_t period;
@@ -497,6 +512,7 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 					HRTIMER_MODE_REL);
 		}
 	}
+out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 	return err;
 }
-- 
1.7.1

