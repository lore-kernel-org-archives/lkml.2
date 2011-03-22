Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1CVIJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:09:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49579 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab1CVII5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:08:57 -0400
Date: Tue, 22 Mar 2011 17:08:54 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2] RTC: Selectively enable PIE-Hrtimer emulation.
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1300781334-30308-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 22 Mar 2011 08:08:55.0329 (UTC)
 FILETIME=[6378B910:01CBE868]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch of John Stultz, "RTC: Rework RTC code to use timerqueue for
events", has enabled PIE interrupt emulation with hrtimer unconditionally.
However, we do have RTC devices that support PIE and such devices are
not meant to be emulated by hrtimer. Besides, we sometimes need RTC-PIE
to function while hrtimer does not; e.g., CPU's RTC PIE as a
suspend-to-RAM wakeup source.

This patch allows to selectively use the PIE emulation. If the rtc
driver has implemented PIE related ops (irq_set_state and irq_set_freq),
PIE emulation is not used. Currently, rtc-s3c, rtc-cmos,
rtc-davinci, rtc-pl031, rtc-pxa, rtc-sa1100, rtc-sh, and rtc-vt41xx have
them.

Besides, rtc->pie_enabled is renamed as rtc->pie_emul_enabled. It is
because that variable denotes whether HRTimer-PIE is set or not.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/class.c     |    2 +-
 drivers/rtc/interface.c |   33 +++++++++++++++++++++++++--------
 include/linux/rtc.h     |    2 +-
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index c404b61..102d706 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -164,7 +164,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	/* Init pie timer */
 	hrtimer_init(&rtc->pie_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rtc->pie_timer.function = rtc_pie_update_irq;
-	rtc->pie_enabled = 0;
+	rtc->pie_emul_enabled = 0;
 
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
 	dev_set_name(&rtc->dev, "rtc%d", id);
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index cb2f072..6d5aa3b 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -450,16 +450,25 @@ int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task, int enabled
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
+		rtc->pie_emul_enabled = 0;
 	} else {
-		hrtimer_cancel(&rtc->pie_timer);
+		if (enabled) {
+			ktime_t period = ktime_set(0, NSEC_PER_SEC /
+					rtc->irq_freq);
+			hrtimer_start(&rtc->pie_timer, period,
+					HRTIMER_MODE_REL);
+		} else {
+			hrtimer_cancel(&rtc->pie_timer);
+		}
+		rtc->pie_emul_enabled = enabled;
 	}
-	rtc->pie_enabled = enabled;
+out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_state);
@@ -487,9 +496,16 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
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
-		if (rtc->pie_enabled) {
+		if (rtc->pie_emul_enabled) {
 			ktime_t period;
 			hrtimer_cancel(&rtc->pie_timer);
 			period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
@@ -497,6 +513,7 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 					HRTIMER_MODE_REL);
 		}
 	}
+out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 	return err;
 }
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 89c3e51..b2c0a62 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -201,7 +201,7 @@ struct rtc_device
 	struct rtc_timer aie_timer;
 	struct rtc_timer uie_rtctimer;
 	struct hrtimer pie_timer; /* sub second exp, so needs hrtimer */
-	int pie_enabled;
+	int pie_emul_enabled;
 	struct work_struct irqwork;
 
 
-- 
1.7.1

