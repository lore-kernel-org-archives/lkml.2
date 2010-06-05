Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0FECyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:54:15 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57126 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0FECxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:53:30 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
       Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 3/6] Fix update_vsyscall to provide wall_to_monotonic offset
Date: Fri,  4 Jun 2010 19:53:23 -0700
Message-Id: <1275706406-8111-4-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1275706406-8111-3-git-send-email-johnstul@us.ibm.com>
References: <1275706406-8111-1-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-2-git-send-email-johnstul@us.ibm.com>
 <1275706406-8111-3-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update_vsyscall() did not provide the wall_to_monotoinc offset,
so arch specific implementations tend to reference wall_to_monotonic
directly. This limits future cleanups in the timekeeping core, so
this patch fixes the update_vsyscall interface to provide
wall_to_monotonic, allowing wall_to_monotonic to be made static
as planned in Documentation/feature-removal-schedule.txt

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Anton Blanchard <anton@samba.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Tony Luck <tony.luck@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/kernel/time.c       |    7 ++++---
 arch/powerpc/kernel/time.c    |    8 ++++----
 arch/s390/kernel/time.c       |    8 ++++----
 arch/x86/kernel/vsyscall_64.c |    6 +++---
 include/linux/clocksource.h   |    6 ++++--
 kernel/time/timekeeping.c     |    9 ++++++---
 6 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 653b3c4..ed6f22e 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -471,7 +471,8 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct clocksource *c, u32 mult)
+void update_vsyscall(struct timespec *wall, struct timespec *wtm,
+			struct clocksource *c, u32 mult)
 {
         unsigned long flags;
 
@@ -487,9 +488,9 @@ void update_vsyscall(struct timespec *wall, struct clocksource *c, u32 mult)
 	/* copy kernel time structures */
         fsyscall_gtod_data.wall_time.tv_sec = wall->tv_sec;
         fsyscall_gtod_data.wall_time.tv_nsec = wall->tv_nsec;
-        fsyscall_gtod_data.monotonic_time.tv_sec = wall_to_monotonic.tv_sec
+	fsyscall_gtod_data.monotonic_time.tv_sec = wtm->tv_sec
 							+ wall->tv_sec;
-        fsyscall_gtod_data.monotonic_time.tv_nsec = wall_to_monotonic.tv_nsec
+	fsyscall_gtod_data.monotonic_time.tv_nsec = wtm->tv_nsec
 							+ wall->tv_nsec;
 
 	/* normalize */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 0711d60..e215f76 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -849,8 +849,8 @@ static cycle_t timebase_read(struct clocksource *cs)
 	return (cycle_t)get_tb();
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
-		     u32 mult)
+void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+			struct clocksource *clock, u32 mult)
 {
 	u64 new_tb_to_xs, new_stamp_xsec;
 
@@ -882,8 +882,8 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	vdso_data->tb_orig_stamp = clock->cycle_last;
 	vdso_data->stamp_xsec = new_stamp_xsec;
 	vdso_data->tb_to_xs = new_tb_to_xs;
-	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
-	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
+	vdso_data->wtom_clock_sec = wtm->tv_sec;
+	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
 	vdso_data->stamp_xtime = *wall_time;
 	smp_wmb();
 	++(vdso_data->tb_update_count);
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index a2163c9..aeb30c6 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -207,8 +207,8 @@ struct clocksource * __init clocksource_default_clock(void)
 	return &clocksource_tod;
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
-		     u32 mult)
+void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+			struct clocksource *clock, u32 mult)
 {
 	if (clock != &clocksource_tod)
 		return;
@@ -219,8 +219,8 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	vdso_data->xtime_tod_stamp = clock->cycle_last;
 	vdso_data->xtime_clock_sec = wall_time->tv_sec;
 	vdso_data->xtime_clock_nsec = wall_time->tv_nsec;
-	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
-	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
+	vdso_data->wtom_clock_sec = wtm->tv_sec;
+	vdso_data->wtom_clock_nsec = wtm->tv_nsec;
 	vdso_data->ntp_mult = mult;
 	smp_wmb();
 	++vdso_data->tb_update_count;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 1c0c6ab..3499be3 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -73,8 +73,8 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
-		     u32 mult)
+void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
+			struct clocksource *clock, u32 mult)
 {
 	unsigned long flags;
 
@@ -87,7 +87,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	vsyscall_gtod_data.clock.shift = clock->shift;
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
-	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
+	vsyscall_gtod_data.wall_to_monotonic = *wtm;
 	vsyscall_gtod_data.wall_time_coarse = __current_kernel_time();
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 5ea3c60..21677d9 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -313,11 +313,13 @@ clocksource_calc_mult_shift(struct clocksource *cs, u32 freq, u32 minsec)
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void
-update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult);
+update_vsyscall(struct timespec *ts, struct timespec *wtm,
+			struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
 #else
 static inline void
-update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult)
+update_vsyscall(struct timespec *ts, struct timespec *wtm,
+			struct clocksource *c, u32 mult)
 {
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index caf8d4d..fdfdeb6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -170,7 +170,8 @@ void timekeeping_leap_insert(int leapsecond)
 {
 	xtime.tv_sec += leapsecond;
 	wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+			timekeeper.mult);
 }
 
 #ifdef CONFIG_GENERIC_TIME
@@ -328,7 +329,8 @@ int do_settimeofday(struct timespec *tv)
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -856,7 +858,8 @@ void update_wall_time(void)
 	}
 
 	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
 }
 
 /**
-- 
1.6.0.4

