Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1L0Oht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:37:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48716 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab1L0Ohq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:37:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111227105708.GA29960@upset.ux.pdb.fsc.net>
References: <20111226145841.GA26578@upset.ux.pdb.fsc.net> <20111227105708.GA29960@upset.ux.pdb.fsc.net>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 27 Dec 2011 20:07:05 +0530
X-Google-Sender-Auth: q0M2X2t6e5Jha7GpDS9n-cS34pc
Message-ID: <CAH+eYFBuK+-md-9QPQ8Z4DSNvKbyOEHg0EyRa2-DaVOZFi=hYQ@mail.gmail.com>
Subject: Re: REGRESSION 3.2-rcX: RTC auto poweron after 5 minutes
To: Andreas Friedrich <afrie@gmx.net>
Cc: john.stultz@linaro.org, gregkh@suse.de, torvalds@osdl.org,
        Wolfgang Erig <Wolfgang.Erig@ts.fujitsu.com>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 16:27, Andreas Friedrich <afrie@gmx.net> wrote:
> On Mo, Dez 26, 2011 at 03:58:41 +0100, Andreas Friedrich wrote:
> the 5 minutes auto-poweron problem was caused by the new function
> drivers/rtc/interface.c -> rtc_alarm_disable():
>   ...
>   alarm.time = rtc_ktime_to_tm(ktime_add(rtc_tm_to_ktime(tm),
>                                        ktime_set(300, 0)));
>   alarm.enabled = 0;
>   ...
>
> In this function the RTC alarm shall be disabled. Why do you set up a
> 5 minutes interval just before disabling the alarm?

The 5 minutes is taken from rtc-sysfs.c ("Provide a valid future alarm
time" etc.).  Although perhaps the "future" part is just to get past the
check in __rtc_set_alarm(), which we anyway don't use in
rtc_alarm_disable().

>
> I have changed
>   ktime_set(300, 0)));
> to
>   ktime_set(0, 0)));
> and all worked fine with my notebook.
>
> Please check if this could be a common solution of the problem.

Probably not, because if your hardware really doesn't disable the alarm
then you could get the same problem if someone say changes the RTC time
to a few minutes earlier after a call to rtc_alarm_disable().

Perhaps we can avoid your five-minute problem by just attempting
to disable the irq without setting a new alarm time (not yet tested):

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 3bcc7cf..54a3b5e 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -778,16 +778,10 @@ static int rtc_timer_enqueue(struct rtc_device
*rtc, struct rtc_timer *timer)

 static void rtc_alarm_disable(struct rtc_device *rtc)
 {
-	struct rtc_wkalrm alarm;
-	struct rtc_time tm;
-
-	__rtc_read_time(rtc, &tm);
-
-	alarm.time = rtc_ktime_to_tm(ktime_add(rtc_tm_to_ktime(tm),
-				     ktime_set(300, 0)));
-	alarm.enabled = 0;
+	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
+		return;

-	___rtc_set_alarm(rtc, &alarm);
+	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
 }

btw, if you haven't done so yet, could you please confirm that it's not
something in your userspace which is _asking_ for the alarm to be
enabled?  You could add a printk() of the 'enabled' argument into
cmos_alarm_irq_enable() to do this (and one in cmos_set_alarm()
wouldn't hurt too).
