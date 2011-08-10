Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1HJXoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:44:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59099 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab1HJXnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:43:53 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        stable@kernel.org
Subject: [PATCH 3/3] alarmtimers: Avoid possible denial of service with high freq periodic timers
Date: Wed, 10 Aug 2011 16:43:36 -0700
Message-Id: <1313019816-32519-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1313019816-32519-1-git-send-email-john.stultz@linaro.org>
References: <1313019816-32519-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its possible to jam up the alarm timers by setting very small interval
timers, which will cause the alarmtimer subsystem to spend all of its time
firing and restarting timers. This can effectivly lock up a box.

A deeper fix is needed, closely mimicking the hrtimer code, but for now
just cap the interval to 100us to avoid userland hanging the system.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 0e9263f..ea5e1a9 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -481,6 +481,15 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 	if (!rtcdev)
 		return -ENOTSUPP;
 
+	/*
+	 * XXX HACK! Currently we can DOS a system if the interval
+	 * period on alarmtimers is too small. Cap the interval here
+	 * to 100us and solve this properly in a future patch! -jstultz
+	 */
+	if ((new_setting->it_interval.tv_sec == 0) &&
+			(new_setting->it_interval.tv_nsec < 100000))
+		new_setting->it_interval.tv_nsec = 100000;
+
 	if (old_setting)
 		alarm_timer_get(timr, old_setting);
 
-- 
1.7.3.2.146.gca209

