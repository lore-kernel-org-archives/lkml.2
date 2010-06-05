Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0FECxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:53:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40037 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab0FECx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:53:29 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 5/6] Cleanup hrtimer.c's direct access to wall_to_monotonic
Date: Fri,  4 Jun 2010 19:53:25 -0700
Message-Id: <1275706406-8111-6-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1275706406-8111-5-git-send-email-johnstul@us.ibm.com>
References: <1275706406-8111-1-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-2-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-3-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-4-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-5-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides an accessor function to replace hrtimer.c's
direct access of wall_to_monotonic.

This will allow wall_to_monotonic to be made static as
planned in Documentation/feature-removal-schedule.txt

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/time.h      |    3 ++-
 kernel/hrtimer.c          |    9 ++++-----
 kernel/time/timekeeping.c |    5 +++++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index ea3559f..d18edd8 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -110,7 +110,8 @@ extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
-struct timespec __current_kernel_time(void); /* does not hold xtime_lock */
+struct timespec __current_kernel_time(void); /* does not take xtime_lock */
+struct timespec __get_wall_to_monotonic(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
 
 #define CURRENT_TIME		(current_kernel_time())
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 5c69e99..809f48c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -90,7 +90,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 		xts = __current_kernel_time();
-		tom = wall_to_monotonic;
+		tom = __get_wall_to_monotonic();
 	} while (read_seqretry(&xtime_lock, seq));
 
 	xtim = timespec_to_ktime(xts);
@@ -612,7 +612,7 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base;
-	struct timespec realtime_offset;
+	struct timespec realtime_offset, wtm;
 	unsigned long seq;
 
 	if (!hrtimer_hres_active())
@@ -620,10 +620,9 @@ static void retrigger_next_event(void *arg)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		set_normalized_timespec(&realtime_offset,
-					-wall_to_monotonic.tv_sec,
-					-wall_to_monotonic.tv_nsec);
+		wtm = __get_wall_to_monotonic();
 	} while (read_seqretry(&xtime_lock, seq));
+	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
 
 	base = &__get_cpu_var(hrtimer_bases);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fdfdeb6..8600218 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -905,6 +905,11 @@ struct timespec __current_kernel_time(void)
 	return xtime;
 }
 
+struct timespec __get_wall_to_monotonic(void)
+{
+	return wall_to_monotonic;
+}
+
 struct timespec current_kernel_time(void)
 {
 	struct timespec now;
-- 
1.6.0.4

