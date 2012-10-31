Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab2JaHWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:22:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:44586 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab2JaHWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:22:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="242265324"
Subject: [PATCH 2/3] alarmtimer: Using the alarmtimer_get_rtcdev for all
 posix clock interface
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: john.stultz@linaro.org, tglx@linutronix.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1351700455.15558.1571.camel@cliu38-desktop-build>
References: <1351700455.15558.1571.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Nov 2012 00:23:03 +0800
Message-ID: <1351700583.15558.1573.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some posix clock interface directly use the variable rtcdev,
cleanup it here by alarmtimer_get_rtcdev().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/time/alarmtimer.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 4fc17cb..5490fa8 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -86,11 +86,10 @@ static int alarmtimer_rtc_add_device(struct device *dev,
 		return -1;
 
 	mutex_lock(&rtcdev_mutex);
-	if (!rtcdev) {
-		rtcdev = rtc;
-		/* hold a reference so it doesn't go away */
-		get_device(dev);
-	}
+	rtcdev = rtc;
+	/* hold a reference so it doesn't go away */
+	get_device(dev);
+
 	mutex_unlock(&rtcdev_mutex);
 	return 0;
 }
@@ -516,7 +515,7 @@ static void alarm_timer_get(struct k_itimer *timr,
  */
 static int alarm_timer_del(struct k_itimer *timr)
 {
-	if (!rtcdev)
+	if (!alarmtimer_get_rtcdev())
 		return -ENOTSUPP;
 
 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
@@ -538,7 +537,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 				struct itimerspec *new_setting,
 				struct itimerspec *old_setting)
 {
-	if (!rtcdev)
+	if (!alarmtimer_get_rtcdev())
 		return -ENOTSUPP;
 
 	if (old_setting)
-- 
1.7.0.4



