Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695Ab2KBDcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 23:32:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:13675 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759944Ab2KBDca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:32:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,696,1344236400"; 
   d="scan'208";a="236081634"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Oliver Neukum <oneukum@suse.de>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH 1/3] alarmtimer: Replace the spinlock rtcdev_lock with
 mutex
Thread-Topic: [PATCH 1/3] alarmtimer: Replace the spinlock rtcdev_lock with
 mutex
Thread-Index: AQHNuIJM//Vwn1y2bEe6qFcishy795fV4XFQ
Date: Fri, 2 Nov 2012 03:32:26 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1BAAC8@SHSMSX101.ccr.corp.intel.com>
References: <1351700455.15558.1571.camel@cliu38-desktop-build>
 <2035297.QqCM5sVoD5@linux-lqwf.site>
 <27240C0AC20F114CBF8149A2696CBE4A1B9C8A@SHSMSX101.ccr.corp.intel.com>
 <alpine.LFD.2.02.1211012306240.2756@ionos>
In-Reply-To: <alpine.LFD.2.02.1211012306240.2756@ionos>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's safe to do in any code path which wants to use rtcdev:
> 
>      if (!rtcdev)
>      	return -ENODEV:
>      do_something(rtcdev);
> 
Really thanks your analysis and sharing, learn something.
And preparing a new patch with your comments for this point.

Subject: [PATCH] alarmtimer: Removing lock at alarmtimer_get_rtcdev()

[From Thomas comments]
"Protecting" the dereferencing of rtcdev with any kind of lock does
not provide any useful protection at all.

Moreover, alarmtimer_rtc_add_device just set the rtc device ONCE,
and the device will never go away and is never going to change, it's
completely pointless to have a lock in alarmtimer_get_rtcdev() at all.

So this patch remove the lock/unlock actions in alarmtimer_get_rtcdev().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/time/alarmtimer.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index f11d83b..eed3b26 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -62,14 +62,7 @@ static DEFINE_SPINLOCK(rtcdev_lock);
  */
 struct rtc_device *alarmtimer_get_rtcdev(void)
 {
-       unsigned long flags;
-       struct rtc_device *ret;
-
-       spin_lock_irqsave(&rtcdev_lock, flags);
-       ret = rtcdev;
-       spin_unlock_irqrestore(&rtcdev_lock, flags);
-
-       return ret;
+       return rtcdev;
 }
 
 
@@ -224,10 +217,10 @@ static int alarmtimer_suspend(struct device *dev)
        freezer_delta = ktime_set(0, 0);
        spin_unlock_irqrestore(&freezer_delta_lock, flags);
 
-       rtc = alarmtimer_get_rtcdev();
        /* If we have no rtcdev, just return */
-       if (!rtc)
+       if (!rtcdev)
                return 0;
+       rtc = rtcdev;
 
        /* Find the soonest timer to expire*/
        for (i = 0; i < ALARM_NUMTYPE; i++) {
@@ -444,7 +437,7 @@ static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
        clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
-       if (!alarmtimer_get_rtcdev())
+       if (!rtcdev)
                return -ENOTSUPP;
 
        return hrtimer_get_res(baseid, tp);
@@ -461,7 +454,7 @@ static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
 {
        struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
-       if (!alarmtimer_get_rtcdev())
+       if (!rtcdev)
                return -ENOTSUPP;
 
        *tp = ktime_to_timespec(base->gettime());
@@ -479,7 +472,7 @@ static int alarm_timer_create(struct k_itimer *new_timer)
        enum  alarmtimer_type type;
        struct alarm_base *base;
 
-       if (!alarmtimer_get_rtcdev())
+       if (!rtcdev)
                return -ENOTSUPP;
 
        if (!capable(CAP_WAKE_ALARM))
@@ -682,7 +675,7 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
        int ret = 0;
        struct restart_block *restart;
 
-       if (!alarmtimer_get_rtcdev())
+       if (!rtcdev)
                return -ENOTSUPP;
 
        if (!capable(CAP_WAKE_ALARM))
-- 
1.7.0.4
