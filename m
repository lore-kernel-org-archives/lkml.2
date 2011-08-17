Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1HQPrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 11:47:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:58677 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1HQPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 11:47:52 -0400
Date: Wed, 17 Aug 2011 17:47:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, mingo@kernel.org
Subject: [GIT pull] timer fixes for 3.1
Message-ID: <alpine.LFD.2.02.1108171746570.2807@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (3):
      rtc: Handle errors correctly in rtc_irq_set_state()
      rtc: Fix hrtimer deadlock
      rtc: Limit RTC PIE frequency


 drivers/rtc/interface.c |   55 ++++++++++++++++++++++++++++++++--------------
 include/linux/rtc.h     |    3 ++
 2 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index df68618..44e91e5 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -636,6 +636,29 @@ void rtc_irq_unregister(struct rtc_device *rtc, struct rtc_task *task)
 }
 EXPORT_SYMBOL_GPL(rtc_irq_unregister);
 
+static int rtc_update_hrtimer(struct rtc_device *rtc, int enabled)
+{
+	/*
+	 * We always cancel the timer here first, because otherwise
+	 * we could run into BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
+	 * when we manage to start the timer before the callback
+	 * returns HRTIMER_RESTART.
+	 *
+	 * We cannot use hrtimer_cancel() here as a running callback
+	 * could be blocked on rtc->irq_task_lock and hrtimer_cancel()
+	 * would spin forever.
+	 */
+	if (hrtimer_try_to_cancel(&rtc->pie_timer) < 0)
+		return -1;
+
+	if (enabled) {
+		ktime_t period = ktime_set(0, NSEC_PER_SEC / rtc->irq_freq);
+
+		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
+	}
+	return 0;
+}
+
 /**
  * rtc_irq_set_state - enable/disable 2^N Hz periodic IRQs
  * @rtc: the rtc device
@@ -651,21 +674,21 @@ int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task, int enabled
 	int err = 0;
 	unsigned long flags;
 
+retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
-
-	if (enabled) {
-		ktime_t period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
-		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
-	} else {
-		hrtimer_cancel(&rtc->pie_timer);
+	if (!err) {
+		if (rtc_update_hrtimer(rtc, enabled) < 0) {
+			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
+			cpu_relax();
+			goto retry;
+		}
+		rtc->pie_enabled = enabled;
 	}
-	rtc->pie_enabled = enabled;
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_state);
@@ -685,22 +708,20 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 	int err = 0;
 	unsigned long flags;
 
-	if (freq <= 0)
+	if (freq <= 0 || freq > RTC_MAX_FREQ)
 		return -EINVAL;
-
+retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
-	if (err == 0) {
+	if (!err) {
 		rtc->irq_freq = freq;
-		if (rtc->pie_enabled) {
-			ktime_t period;
-			hrtimer_cancel(&rtc->pie_timer);
-			period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
-			hrtimer_start(&rtc->pie_timer, period,
-					HRTIMER_MODE_REL);
+		if (rtc->pie_enabled && rtc_update_hrtimer(rtc, 1) < 0) {
+			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
+			cpu_relax();
+			goto retry;
 		}
 	}
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index b27ebea..93f4d03 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -97,6 +97,9 @@ struct rtc_pll_info {
 #define RTC_AF 0x20	/* Alarm interrupt */
 #define RTC_UF 0x10	/* Update interrupt for 1Hz RTC */
 
+
+#define RTC_MAX_FREQ	8192
+
 #ifdef __KERNEL__
 
 #include <linux/types.h>
