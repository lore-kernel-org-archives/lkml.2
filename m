Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2KBGLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 02:11:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:7201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab2KBGLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 02:11:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,696,1344236400"; 
   d="scan'208";a="212569279"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] alarmtimer: Using the alarmtimer_get_rtcdev for all
 posix clock interface
Thread-Topic: [PATCH 2/3] alarmtimer: Using the alarmtimer_get_rtcdev for
 all posix clock interface
Thread-Index: AQHNuIQC5CVh2ojgZ0i28n1otBAKtpfWDTLA
Date: Fri, 2 Nov 2012 06:10:45 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1BAC19@SHSMSX101.ccr.corp.intel.com>
References: <1351700455.15558.1571.camel@cliu38-desktop-build>
 <1351700583.15558.1573.camel@cliu38-desktop-build>
 <alpine.LFD.2.02.1211012343120.2756@ionos>
In-Reply-To: <alpine.LFD.2.02.1211012343120.2756@ionos>
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

> rtcdev = NULL
> 
> CPU0				CPU 1
> 
> alarmtimer_rtc_add_device(A)
> 	if (rtcdev)		alarmtimer_rtc_add_device(B)
> 	     return -EBUSY;		if (rtcdev)
> 	mutex_lock();				return -EBUSY;
> 	rtcdev = A;			mutex_lock();
> 	mutex_unlock;
> 
> bla = alarmtimer_rtc_get_device()
> 
> So bla = A
>       				  	mutex_lock() returns
>       				  	rtcdev = B;
> 					mutex_unlock();
> 
> The next call to alarmtimer_rtc_get_device() will return B. Not what
> you want. Maybe you want that, but then your patch is missing an
> explanation why you want that and why this would be a desired
> behaviour.
> 

Based on current implementation alarmtimer_rtc_add_device() will just
be called once thru class interface, also &parent->p->mutex is there to protect
the class_intf->add_dev() calling, so we can remove rtcdev_lock.
Is it making sense?


Subject: [PATCH] alarmtimer: Removing the usage of lock rtcdev_lock

alarmtimer_rtc_add_device() will be called once at the time
alarmtimer_init() is called.

alarmtimer_init -->
        alarmtimer_rtc_interface_setup -->
                class_interface_register -->
                        mutex_lock(&parent->p->mutex)
                        ...
                        class_intf->add_dev()/alarmtimer_rtc_add_device
                        ...
                        mutex_unlock(&parent->p->mutex);

But also the mutex parent->p->mutex has protected the add_dev()
callback.

So here removing the lock of rtcdev_lock.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/time/alarmtimer.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index eed3b26..660091c 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -51,7 +51,6 @@ static struct wakeup_source *ws;
 /* rtc timer and device for setting alarm wakeups at suspend */
 static struct rtc_timer                rtctimer;
 static struct rtc_device       *rtcdev;
-static DEFINE_SPINLOCK(rtcdev_lock);
 
 /**
  * alarmtimer_get_rtcdev - Return selected rtcdevice
@@ -69,7 +68,6 @@ struct rtc_device *alarmtimer_get_rtcdev(void)
 static int alarmtimer_rtc_add_device(struct device *dev,
                                struct class_interface *class_intf)
 {
-       unsigned long flags;
        struct rtc_device *rtc = to_rtc_device(dev);
 
        if (rtcdev)
@@ -80,13 +78,10 @@ static int alarmtimer_rtc_add_device(struct device *dev,
        if (!device_may_wakeup(rtc->dev.parent))
                return -1;
 
-       spin_lock_irqsave(&rtcdev_lock, flags);
-       if (!rtcdev) {
-               rtcdev = rtc;
-               /* hold a reference so it doesn't go away */
-               get_device(dev);
-       }
-       spin_unlock_irqrestore(&rtcdev_lock, flags);
+       rtcdev = rtc;
+       /* hold a reference so it doesn't go away */
+       get_device(dev);
+
        return 0;
 }
 
-- 
1.7.0.4

