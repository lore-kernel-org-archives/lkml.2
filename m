Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab0KCSbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:31:42 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35258 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0KCSbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:31:36 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 4/7] [RFC] RTC: Remove UIE emulation
Date: Wed,  3 Nov 2010 11:31:16 -0700
Message-Id: <1288809079-14663-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
References: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we provide UIE interrupts via a rtc_timer, the old
emulation code can be removed.

Note: I assume this is ok, but there may be corner cases I'm missing.

Signed-off-by: John Stultz <john.stultz@linaro.org>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Cochran <richardcochran@gmail.com>
---
 drivers/rtc/rtc-dev.c |  104 -------------------------------------------------
 include/linux/rtc.h   |   12 ------
 2 files changed, 0 insertions(+), 116 deletions(-)

diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 62227cd..212b16e 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -46,105 +46,6 @@ static int rtc_dev_open(struct inode *inode, struct file *file)
 	return err;
 }
 
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-/*
- * Routine to poll RTC seconds field for change as often as possible,
- * after first RTC_UIE use timer to reduce polling
- */
-static void rtc_uie_task(struct work_struct *work)
-{
-	struct rtc_device *rtc =
-		container_of(work, struct rtc_device, uie_task);
-	struct rtc_time tm;
-	int num = 0;
-	int err;
-
-	err = rtc_read_time(rtc, &tm);
-
-	spin_lock_irq(&rtc->irq_lock);
-	if (rtc->stop_uie_polling || err) {
-		rtc->uie_task_active = 0;
-	} else if (rtc->oldsecs != tm.tm_sec) {
-		num = (tm.tm_sec + 60 - rtc->oldsecs) % 60;
-		rtc->oldsecs = tm.tm_sec;
-		rtc->uie_timer.expires = jiffies + HZ - (HZ/10);
-		rtc->uie_timer_active = 1;
-		rtc->uie_task_active = 0;
-		add_timer(&rtc->uie_timer);
-	} else if (schedule_work(&rtc->uie_task) == 0) {
-		rtc->uie_task_active = 0;
-	}
-	spin_unlock_irq(&rtc->irq_lock);
-	if (num)
-		rtc_update_irq(rtc, num, RTC_UF | RTC_IRQF);
-}
-static void rtc_uie_timer(unsigned long data)
-{
-	struct rtc_device *rtc = (struct rtc_device *)data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&rtc->irq_lock, flags);
-	rtc->uie_timer_active = 0;
-	rtc->uie_task_active = 1;
-	if ((schedule_work(&rtc->uie_task) == 0))
-		rtc->uie_task_active = 0;
-	spin_unlock_irqrestore(&rtc->irq_lock, flags);
-}
-
-static int clear_uie(struct rtc_device *rtc)
-{
-	spin_lock_irq(&rtc->irq_lock);
-	if (rtc->uie_irq_active) {
-		rtc->stop_uie_polling = 1;
-		if (rtc->uie_timer_active) {
-			spin_unlock_irq(&rtc->irq_lock);
-			del_timer_sync(&rtc->uie_timer);
-			spin_lock_irq(&rtc->irq_lock);
-			rtc->uie_timer_active = 0;
-		}
-		if (rtc->uie_task_active) {
-			spin_unlock_irq(&rtc->irq_lock);
-			flush_scheduled_work();
-			spin_lock_irq(&rtc->irq_lock);
-		}
-		rtc->uie_irq_active = 0;
-	}
-	spin_unlock_irq(&rtc->irq_lock);
-	return 0;
-}
-
-static int set_uie(struct rtc_device *rtc)
-{
-	struct rtc_time tm;
-	int err;
-
-	err = rtc_read_time(rtc, &tm);
-	if (err)
-		return err;
-	spin_lock_irq(&rtc->irq_lock);
-	if (!rtc->uie_irq_active) {
-		rtc->uie_irq_active = 1;
-		rtc->stop_uie_polling = 0;
-		rtc->oldsecs = tm.tm_sec;
-		rtc->uie_task_active = 1;
-		if (schedule_work(&rtc->uie_task) == 0)
-			rtc->uie_task_active = 0;
-	}
-	rtc->irq_data = 0;
-	spin_unlock_irq(&rtc->irq_lock);
-	return 0;
-}
-
-int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc, unsigned int enabled)
-{
-	if (enabled)
-		return set_uie(rtc);
-	else
-		return clear_uie(rtc);
-}
-EXPORT_SYMBOL(rtc_dev_update_irq_enable_emul);
-
-#endif /* CONFIG_RTC_INTF_DEV_UIE_EMUL */
 
 static ssize_t
 rtc_dev_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
@@ -493,11 +394,6 @@ void rtc_dev_prepare(struct rtc_device *rtc)
 
 	rtc->dev.devt = MKDEV(MAJOR(rtc_devt), rtc->id);
 
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-	INIT_WORK(&rtc->uie_task, rtc_uie_task);
-	setup_timer(&rtc->uie_timer, rtc_uie_timer, (unsigned long)rtc);
-#endif
-
 	cdev_init(&rtc->char_dev, &rtc_dev_fops);
 	rtc->char_dev.owner = rtc->owner;
 }
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c50fae5..7af34ec 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -203,18 +203,6 @@ struct rtc_device
 	struct hrtimer pie_timer; /* sub second exp, so needs hrtimer */
 	int pie_enabled;
 	struct work_struct irqwork;
-
-
-#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
-	struct work_struct uie_task;
-	struct timer_list uie_timer;
-	/* Those fields are protected by rtc->irq_lock */
-	unsigned int oldsecs;
-	unsigned int uie_irq_active:1;
-	unsigned int stop_uie_polling:1;
-	unsigned int uie_task_active:1;
-	unsigned int uie_timer_active:1;
-#endif
 };
 #define to_rtc_device(d) container_of(d, struct rtc_device, dev)
 
-- 
1.7.3.2.146.gca209

