Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1GVJM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:12:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:46113 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1GVJMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:12:52 -0400
Message-Id: <20110722091045.476900421@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jul 2011 09:12:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Ben Greear <greearb@candelatech.com>, stable@kernel.org
Subject: [patch 2/3] rtc: Fix hrtimer deadlock
References: <20110722091011.717194327@linutronix.de>
Content-Disposition: inline; filename=rtc-fix-hrtimer-deadlock.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben reported a lockup related to rtc. The lockup happens due to:

CPU0                                        CPU1

rtc_irq_set_state()			    __run_hrtimer()	
  spin_lock_irqsave(&rtc->irq_task_lock)    rtc_handle_legacy_irq();
					      spin_lock(&rtc->irq_task_lock);
  hrtimer_cancel()
    while (callback_running);

So the running callback never finishes as it's blocked on
rtc->irq_task_lock.  

Use hrtimer_try_to_cancel() instead and drop rtc->irq_task_lock while
waiting for the callback. Fix this for both rtc_irq_set_state() and
rtc_irq_set_freq().

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
---
 drivers/rtc/interface.c |   56 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/rtc/interface.c
===================================================================
--- linux-2.6.orig/drivers/rtc/interface.c
+++ linux-2.6/drivers/rtc/interface.c
@@ -636,6 +636,29 @@ void rtc_irq_unregister(struct rtc_devic
 }
 EXPORT_SYMBOL_GPL(rtc_irq_unregister);
 
+static int rtc_update_hrtimer(struct rtc_device *rtc, int enabled)
+{
+	/*
+	 * We unconditionally cancel the timer here, because otherwise
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
@@ -651,24 +674,21 @@ int rtc_irq_set_state(struct rtc_device 
 	int err = 0;
 	unsigned long flags;
 
+retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
-	if (err)
-		goto out;
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
-out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_state);
@@ -690,20 +710,18 @@ int rtc_irq_set_freq(struct rtc_device *
 
 	if (freq <= 0)
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


