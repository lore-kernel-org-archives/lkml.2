Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0JARiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab0JARiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:38:06 -0400
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] use a stable clock reference in vdso vgetns
Date: Fri,  1 Oct 2010 09:09:56 -0400
Message-Id: <1285938596-2186-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using vdso services for clock_gettime, we test for the ability
of a fine-grained measurement through the existance of a vread() function.

However, from the time we test it, to the time we use it, vread() reference
may not be valid anymore. It happens, for example, when we change the current
clocksource from one that provides vread (say tsc) to one that lacks it
(say acpi_pm), in the middle of clock_gettime routine.

seqlock does not really protect us, since readers here won't stop the writers
to change references. The proposed solution is to grab a copy of the clock
structure early, and use it as a stable reference onwards.

Since we don't free parts of memory associated with old clocksources, we
merely stop using it for a while, this is a safe thing to do.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/vgtod.h   |    2 +-
 arch/x86/vdso/vclock_gettime.c |   51 +++++++++++++++++++++++++++------------
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 3d61e20..7f813bc 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -13,7 +13,7 @@ struct vsyscall_gtod_data {
 
 	int		sysctl_enabled;
 	struct timezone sys_tz;
-	struct { /* extract of a clocksource struct */
+	struct vclock { /* extract of a clocksource struct */
 		cycle_t (*vread)(void);
 		cycle_t	cycle_last;
 		cycle_t	mask;
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index ee55754..c82ade0 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -34,23 +34,26 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 	return ret;
 }
 
-notrace static inline long vgetns(void)
+/*
+ * The clock structure must be provided from the outside, instead of accessed
+ * from gtod. The clock can have changed, leading to an invalid vread by the
+ * time we get here. All other values must also be consistent with vread result
+ */
+notrace static inline long vgetns(struct vclock *clock)
 {
 	long v;
-	cycles_t (*vread)(void);
-	vread = gtod->clock.vread;
-	v = (vread() - gtod->clock.cycle_last) & gtod->clock.mask;
-	return (v * gtod->clock.mult) >> gtod->clock.shift;
+	v = (clock->vread() - clock->cycle_last) & clock->mask;
+	return (v * clock->mult) >> clock->shift;
 }
 
-notrace static noinline int do_realtime(struct timespec *ts)
+notrace static noinline int do_realtime(struct timespec *ts, struct vclock *clock)
 {
 	unsigned long seq, ns;
 	do {
 		seq = read_seqbegin(&gtod->lock);
 		ts->tv_sec = gtod->wall_time_sec;
 		ts->tv_nsec = gtod->wall_time_nsec;
-		ns = vgetns();
+		ns = vgetns(clock);
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
 	timespec_add_ns(ts, ns);
 	return 0;
@@ -72,13 +75,13 @@ vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
 	ts->tv_nsec = nsec;
 }
 
-notrace static noinline int do_monotonic(struct timespec *ts)
+notrace static noinline int do_monotonic(struct timespec *ts, struct vclock *clock)
 {
 	unsigned long seq, ns, secs;
 	do {
 		seq = read_seqbegin(&gtod->lock);
 		secs = gtod->wall_time_sec;
-		ns = gtod->wall_time_nsec + vgetns();
+		ns = gtod->wall_time_nsec + vgetns(clock);
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
@@ -113,21 +116,29 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
-	if (likely(gtod->sysctl_enabled))
+	if (likely(gtod->sysctl_enabled)) {
+		struct vclock clk;
+		unsigned long seq;
+		do {
+			seq = read_seqbegin(&gtod->lock);
+			memcpy(&clk, &gtod->clock, sizeof(clk));
+		} while (unlikely(read_seqretry(&gtod->lock, seq)));
+
 		switch (clock) {
 		case CLOCK_REALTIME:
-			if (likely(gtod->clock.vread))
-				return do_realtime(ts);
+			if (likely(clk.vread))
+				return do_realtime(ts, &clk);
 			break;
 		case CLOCK_MONOTONIC:
-			if (likely(gtod->clock.vread))
-				return do_monotonic(ts);
+			if (likely(clk.vread))
+				return do_monotonic(ts, &clk);
 			break;
 		case CLOCK_REALTIME_COARSE:
 			return do_realtime_coarse(ts);
 		case CLOCK_MONOTONIC_COARSE:
 			return do_monotonic_coarse(ts);
 		}
+	}
 	return vdso_fallback_gettime(clock, ts);
 }
 int clock_gettime(clockid_t, struct timespec *)
@@ -136,12 +147,20 @@ int clock_gettime(clockid_t, struct timespec *)
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
-	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
+	struct vclock clock;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		memcpy(&clock, &gtod->clock, sizeof(clock));
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+
+	if (likely(gtod->sysctl_enabled && clock.vread)) {
 		if (likely(tv != NULL)) {
 			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
 				     offsetof(struct timespec, tv_nsec) ||
 				     sizeof(*tv) != sizeof(struct timespec));
-			do_realtime((struct timespec *)tv);
+			do_realtime((struct timespec *)tv, &clock);
 			tv->tv_usec /= 1000;
 		}
 		if (unlikely(tz != NULL)) {
-- 
1.7.0.1

