Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0GNA5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:57:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54483 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0GNA4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:56:31 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/11] Implement timespec_add
Date: Tue, 13 Jul 2010 17:56:19 -0700
Message-Id: <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After accidentally misusing timespec_add_safe, I wanted to make sure
we don't accidently trip over that issue again, so I created a simple
timespec_add() function which we can use to replace the instances
of timespec_add_safe() that don't want the overflow detection.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/time.h      |   16 ++++++++++++++++
 kernel/time/timekeeping.c |    6 +++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index ea3559f..36b42f5 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -76,9 +76,25 @@ extern unsigned long mktime(const unsigned int year, const unsigned int mon,
 			    const unsigned int min, const unsigned int sec);
 
 extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
+
+/*
+ * timespec_add_safe assumes both values are positive and checks 
+ * for overflow. It will return TIME_T_MAX if the reutrn would be
+ * smaller then either of the arguments.
+ */
 extern struct timespec timespec_add_safe(const struct timespec lhs,
 					 const struct timespec rhs);
 
+
+static inline struct timespec timespec_add(struct timespec lhs,
+						struct timespec rhs)
+{
+	struct timespec ts_delta;
+	set_normalized_timespec(&ts_delta, lhs.tv_sec + rhs.tv_sec,
+				lhs.tv_nsec + rhs.tv_nsec);
+	return ts_delta;
+}
+
 /*
  * sub = lhs - rhs, in normalized form
  */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index caf8d4d..623fe3d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -579,9 +579,9 @@ static int timekeeping_resume(struct sys_device *dev)
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
-		xtime = timespec_add_safe(xtime, ts);
+		xtime = timespec_add(xtime, ts);
 		wall_to_monotonic = timespec_sub(wall_to_monotonic, ts);
-		total_sleep_time = timespec_add_safe(total_sleep_time, ts);
+		total_sleep_time = timespec_add(total_sleep_time, ts);
 	}
 	/* re-base the last cycle value */
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
@@ -887,7 +887,7 @@ EXPORT_SYMBOL_GPL(getboottime);
  */
 void monotonic_to_bootbased(struct timespec *ts)
 {
-	*ts = timespec_add_safe(*ts, total_sleep_time);
+	*ts = timespec_add(*ts, total_sleep_time);
 }
 EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
-- 
1.6.0.4

