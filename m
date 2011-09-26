Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1IZTOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:14:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33648 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab1IZTOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:14:11 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: [PATCH 4/6] [RFC] rtc: interface: Add pm_stay_awake/pm_relax chaining rtc workqueue processing
Date: Mon, 26 Sep 2011 12:13:52 -0700
Message-Id: <1317064434-1829-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To ensure suspend events don't trigger between the irq and the
rtc workqueue function running, use pm_stay_awake/pm_relax.

CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: arve@android.com
CC: markgross@thegnar.org
CC: Alan Stern <stern@rowland.harvard.edu>
CC: amit.kucheria@linaro.org
CC: farrowg@sg.ibm.com
CC: Dmitry Fink (Palm GBU) <Dmitry.Fink@palm.com>
CC: linux-pm@lists.linux-foundation.org
CC: khilman@ti.com
CC: Magnus Damm <damm@opensource.se>
CC: mjg@redhat.com 
CC: peterz@infradead.org 
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/interface.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 44e91e5..ba1c437 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -19,6 +19,15 @@
 static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer);
 static void rtc_timer_remove(struct rtc_device *rtc, struct rtc_timer *timer);
 
+static struct wakeup_source *rtc_interface_wakelock;
+static int __init rtc_interface_wakelock_init(void)
+{
+       rtc_interface_wakelock = wakeup_source_register("rtc_interface");
+       return 0;
+}
+core_initcall(rtc_interface_wakelock_init);
+
+
 static int __rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
 {
 	int err;
@@ -563,6 +572,7 @@ enum hrtimer_restart rtc_pie_update_irq(struct hrtimer *timer)
 void rtc_update_irq(struct rtc_device *rtc,
 		unsigned long num, unsigned long events)
 {
+	__pm_stay_awake(rtc_interface_wakelock);
 	schedule_work(&rtc->irqwork);
 }
 EXPORT_SYMBOL_GPL(rtc_update_irq);
@@ -751,9 +761,10 @@ static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 		alarm.time = rtc_ktime_to_tm(timer->node.expires);
 		alarm.enabled = 1;
 		err = __rtc_set_alarm(rtc, &alarm);
-		if (err == -ETIME)
+		if (err == -ETIME) {
+			__pm_stay_awake(rtc_interface_wakelock);
 			schedule_work(&rtc->irqwork);
-		else if (err) {
+		} else if (err) {
 			timerqueue_del(&rtc->timerqueue, &timer->node);
 			timer->enabled = 0;
 			return err;
@@ -849,6 +860,7 @@ again:
 	}
 
 	mutex_unlock(&rtc->ops_lock);
+	__pm_relax(rtc_interface_wakelock);
 }
 
 
-- 
1.7.3.2.146.gca209

