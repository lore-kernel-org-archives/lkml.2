Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2JaHUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:20:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:48135 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2JaHUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:20:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="240664730"
Subject: [PATCH 1/3] alarmtimer: Replace the spinlock rtcdev_lock with mutex
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: john.stultz@linaro.org, tglx@linutronix.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Nov 2012 00:20:55 +0800
Message-ID: <1351700455.15558.1571.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When do code reviewing, found no special requirement to
use spin_lock_irqsave/spin_unlock_irqrestore, because
alarmtimer_get_rtcdev() is called by posix clock interface.
So would like to use mutex to replace it.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/time/alarmtimer.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index f11d83b..4fc17cb 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -51,7 +51,7 @@ static struct wakeup_source *ws;
 /* rtc timer and device for setting alarm wakeups at suspend */
 static struct rtc_timer		rtctimer;
 static struct rtc_device	*rtcdev;
-static DEFINE_SPINLOCK(rtcdev_lock);
+static DEFINE_MUTEX(rtcdev_mutex);
 
 /**
  * alarmtimer_get_rtcdev - Return selected rtcdevice
@@ -62,12 +62,11 @@ static DEFINE_SPINLOCK(rtcdev_lock);
  */
 struct rtc_device *alarmtimer_get_rtcdev(void)
 {
-	unsigned long flags;
 	struct rtc_device *ret;
 
-	spin_lock_irqsave(&rtcdev_lock, flags);
+	mutex_lock(&rtcdev_mutex);
 	ret = rtcdev;
-	spin_unlock_irqrestore(&rtcdev_lock, flags);
+	mutex_unlock(&rtcdev_mutex);
 
 	return ret;
 }
@@ -76,7 +75,6 @@ struct rtc_device *alarmtimer_get_rtcdev(void)
 static int alarmtimer_rtc_add_device(struct device *dev,
 				struct class_interface *class_intf)
 {
-	unsigned long flags;
 	struct rtc_device *rtc = to_rtc_device(dev);
 
 	if (rtcdev)
@@ -87,13 +85,13 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 	if (!device_may_wakeup(rtc->dev.parent))
 		return -1;
 
-	spin_lock_irqsave(&rtcdev_lock, flags);
+	mutex_lock(&rtcdev_mutex);
 	if (!rtcdev) {
 		rtcdev = rtc;
 		/* hold a reference so it doesn't go away */
 		get_device(dev);
 	}
-	spin_unlock_irqrestore(&rtcdev_lock, flags);
+	mutex_unlock(&rtcdev_mutex);
 	return 0;
 }
 
-- 
1.7.0.4



