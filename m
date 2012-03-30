Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965928Ab2C3Vvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:51:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965849Ab2C3VTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:49 -0400
Message-Id: <20120330194834.785494421@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, John Stultz <john.stultz@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [ 055/175] rtc: Disable the alarm in the hardware (v2)
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin.vincent@stericsson.com>

commit 41c7f7424259ff11009449f87c95656f69f9b186 upstream.

Currently, the RTC code does not disable the alarm in the hardware.

This means that after a sequence such as the one below (the files are in the
RTC sysfs), the box will boot up after 2 minutes even though we've
asked for the alarm to be turned off.

	# echo $((`cat since_epoch`)+120) > wakealarm
	# echo 0 > wakealarm
	# poweroff

Fix this by disabling the alarm when there are no timers to run.

The original version of this patch was reverted. This version
disables the irq directly instead of setting a disabled timer
in the future.

Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
[Merged in the second revision from Rabin]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/interface.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -763,6 +763,14 @@ static int rtc_timer_enqueue(struct rtc_
 	return 0;
 }
 
+static void rtc_alarm_disable(struct rtc_device *rtc)
+{
+	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
+		return;
+
+	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
+}
+
 /**
  * rtc_timer_remove - Removes a rtc_timer from the rtc_device timerqueue
  * @rtc rtc device
@@ -784,8 +792,10 @@ static void rtc_timer_remove(struct rtc_
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
@@ -847,7 +857,8 @@ again:
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			goto again;
-	}
+	} else
+		rtc_alarm_disable(rtc);
 
 	mutex_unlock(&rtc->ops_lock);
 }


