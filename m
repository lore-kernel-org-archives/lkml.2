Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0G0Krt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:47:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0G0Krs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:47:48 -0400
Date: Tue, 27 Jul 2010 10:47:29 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
        hpa@zytor.com, mingo@redhat.com, johnstul@us.ibm.com,
        schwidefsky@de.ibm.com, tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        schwidefsky@de.ibm.com, tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <1279068988-21864-7-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-7-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/clocksource] timkeeping: Fix update_vsyscall to provide wall_to_monotonic offset
Message-ID: <tip-7615856ebfee52b080c22d263ca4debbd0df0ac1@git.kernel.org>
Git-Commit-ID: 7615856ebfee52b080c22d263ca4debbd0df0ac1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 10:47:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7615856ebfee52b080c22d263ca4debbd0df0ac1
Gitweb:     http://git.kernel.org/tip/7615856ebfee52b080c22d263ca4debbd0df0ac1
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Tue, 13 Jul 2010 17:56:23 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 27 Jul 2010 12:40:54 +0200

timkeeping: Fix update_vsyscall to provide wall_to_monotonic offset

update_vsyscall() did not provide the wall_to_monotoinc offset,
so arch specific implementations tend to reference wall_to_monotonic
directly. This limits future cleanups in the timekeeping core, so
this patch fixes the update_vsyscall interface to provide
wall_to_monotonic, allowing wall_to_monotonic to be made static
as planned in Documentation/feature-removal-schedule.txt

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tony Luck <tony.luck@intel.com>
LKML-Reference: <1279068988-21864-7-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
index dce0c3c..dcbb28c 100644
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
index 73edd40..b15c3ac 100644
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
 
 /**
@@ -326,7 +327,8 @@ int do_settimeofday(struct timespec *tv)
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -809,7 +811,8 @@ void update_wall_time(void)
 	}
 
 	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
+	update_vsyscall(&xtime, &wall_to_monotonic, timekeeper.clock,
+				timekeeper.mult);
 }
 
 /**
