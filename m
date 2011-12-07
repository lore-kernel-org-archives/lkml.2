Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1LGQxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:53:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483Ab1LGQT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:19:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:28 2011
Message-Id: <20111207160828.569083145@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:33 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, John Stultz <john.stultz@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [73/80] rtc: Disable the alarm in the hardware
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin.vincent@stericsson.com>

commit c0afabd3d553c521e003779c127143ffde55a16f upstream.

Currently, the RTC code does not disable the alarm in the hardware.

This means that after a sequence such as the one below (the files are in the
RTC sysfs), the box will boot up after 2 minutes even though we've
asked for the alarm to be turned off.

	# echo $((`cat since_epoch`)+120) > wakealarm
	# echo 0 > wakealarm
	# poweroff

Fix this by disabling the alarm when there are no timers to run.

Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/interface.c |   44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -318,6 +318,20 @@ int rtc_read_alarm(struct rtc_device *rt
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
+static int ___rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+{
+	int err;
+
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (!rtc->ops->set_alarm)
+		err = -EINVAL;
+	else
+		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
+
+	return err;
+}
+
 static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	struct rtc_time tm;
@@ -341,14 +355,7 @@ static int __rtc_set_alarm(struct rtc_de
 	 * over right here, before we set the alarm.
 	 */
 
-	if (!rtc->ops)
-		err = -ENODEV;
-	else if (!rtc->ops->set_alarm)
-		err = -EINVAL;
-	else
-		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
-
-	return err;
+	return ___rtc_set_alarm(rtc, alarm);
 }
 
 int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
@@ -762,6 +769,20 @@ static int rtc_timer_enqueue(struct rtc_
 	return 0;
 }
 
+static void rtc_alarm_disable(struct rtc_device *rtc)
+{
+	struct rtc_wkalrm alarm;
+	struct rtc_time tm;
+
+	__rtc_read_time(rtc, &tm);
+
+	alarm.time = rtc_ktime_to_tm(ktime_add(rtc_tm_to_ktime(tm),
+				     ktime_set(300, 0)));
+	alarm.enabled = 0;
+
+	___rtc_set_alarm(rtc, &alarm);
+}
+
 /**
  * rtc_timer_remove - Removes a rtc_timer from the rtc_device timerqueue
  * @rtc rtc device
@@ -783,8 +804,10 @@ static void rtc_timer_remove(struct rtc_
 		struct rtc_wkalrm alarm;
 		int err;
 		next = timerqueue_getnext(&rtc->timerqueue);
-		if (!next)
+		if (!next) {
+			rtc_alarm_disable(rtc);
 			return;
+		}
 		alarm.time = rtc_ktime_to_tm(next->expires);
 		alarm.enabled = 1;
 		err = __rtc_set_alarm(rtc, &alarm);
@@ -846,7 +869,8 @@ again:
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			goto again;
-	}
+	} else
+		rtc_alarm_disable(rtc);
 
 	mutex_unlock(&rtc->ops_lock);
 }


