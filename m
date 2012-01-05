Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab2AEWgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:36:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378Ab2AEWgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:36:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jan  5 14:29:59 2012
Message-Id: <20120105222959.255610761@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Thu, 05 Jan 2012 14:30:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Nieder <jrnieder@gmail.com>
Subject: [77/80] Revert "rtc: Disable the alarm in the hardware"
In-Reply-To: <20120105223610.GA9914@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 3184
Lines: 115

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 157e8bf8b4823bfcdefa6c1548002374b61f61df upstream.

This reverts commit c0afabd3d553c521e003779c127143ffde55a16f.

It causes failures on Toshiba laptops - instead of disabling the alarm,
it actually seems to enable it on the affected laptops, resulting in
(for example) the laptop powering on automatically five minutes after
shutdown.

There's a patch for it that appears to work for at least some people,
but it's too late to play around with this, so revert for now and try
again in the next merge window.

See for example

	http://bugs.debian.org/652869

Reported-and-bisected-by: Andreas Friedrich <afrie@gmx.net> (Toshiba Tecra)
Reported-by: Antonio-M. Corbi Bellot <antonio.corbi@ua.es> (Toshiba Portege R500)
Reported-by: Marco Santos <marco.santos@waynext.com> (Toshiba Portege Z830)
Reported-by: Christophe Vu-Brugier <cvubrugier@yahoo.fr>  (Toshiba Portege R830)
Cc: Jonathan Nieder <jrnieder@gmail.com>
Requested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/interface.c |   44 ++++++++++----------------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -318,20 +318,6 @@ int rtc_read_alarm(struct rtc_device *rt
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
-static int ___rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
-{
-	int err;
-
-	if (!rtc->ops)
-		err = -ENODEV;
-	else if (!rtc->ops->set_alarm)
-		err = -EINVAL;
-	else
-		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
-
-	return err;
-}
-
 static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	struct rtc_time tm;
@@ -355,7 +341,14 @@ static int __rtc_set_alarm(struct rtc_de
 	 * over right here, before we set the alarm.
 	 */
 
-	return ___rtc_set_alarm(rtc, alarm);
+	if (!rtc->ops)
+		err = -ENODEV;
+	else if (!rtc->ops->set_alarm)
+		err = -EINVAL;
+	else
+		err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
+
+	return err;
 }
 
 int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
@@ -769,20 +762,6 @@ static int rtc_timer_enqueue(struct rtc_
 	return 0;
 }
 
-static void rtc_alarm_disable(struct rtc_device *rtc)
-{
-	struct rtc_wkalrm alarm;
-	struct rtc_time tm;
-
-	__rtc_read_time(rtc, &tm);
-
-	alarm.time = rtc_ktime_to_tm(ktime_add(rtc_tm_to_ktime(tm),
-				     ktime_set(300, 0)));
-	alarm.enabled = 0;
-
-	___rtc_set_alarm(rtc, &alarm);
-}
-
 /**
  * rtc_timer_remove - Removes a rtc_timer from the rtc_device timerqueue
  * @rtc rtc device
@@ -804,10 +783,8 @@ static void rtc_timer_remove(struct rtc_
 		struct rtc_wkalrm alarm;
 		int err;
 		next = timerqueue_getnext(&rtc->timerqueue);
-		if (!next) {
-			rtc_alarm_disable(rtc);
+		if (!next)
 			return;
-		}
 		alarm.time = rtc_ktime_to_tm(next->expires);
 		alarm.enabled = 1;
 		err = __rtc_set_alarm(rtc, &alarm);
@@ -869,8 +846,7 @@ again:
 		err = __rtc_set_alarm(rtc, &alarm);
 		if (err == -ETIME)
 			goto again;
-	} else
-		rtc_alarm_disable(rtc);
+	}
 
 	mutex_unlock(&rtc->ops_lock);
 }


