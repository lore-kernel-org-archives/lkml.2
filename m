Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031276Ab2CNX7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:59:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43527 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031176Ab2CNX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:59:06 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] time: x86: Fix race switching from vsyscall to non-vsyscall clock
Date: Wed, 14 Mar 2012 16:58:55 -0700
Message-Id: <1331769536-4602-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331769536-4602-1-git-send-email-john.stultz@linaro.org>
References: <1331769536-4602-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031423-6148-0000-0000-0000044208E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When switching from a vsyscall capable to a non-vsyscall capable
clocksource, there was a small race, where the last vsyscall
gettimeofday before the switch might return a invalid time value
using the new non-vsyscall enabled clocksource values after the
switch is complete.

This is due to the vsyscall code checking the vclock_mode once
outside of the seqcount protected section. After it reads the
vclock mode, it doesn't re-check that the sampled clock data
that is obtained in the seqcount critical section still matches.

The fix is to sample vclock_mode inside the protected section,
and as long as it isn't VCLOCK_NONE, return the calculated
value. If it has changed and is now VCLOCK_NONE, fall back
to the syscall gettime calculation.

v2:
  * Cleanup checks as suggested by tglx
  * Also fix same issue present in gettimeofday path

CC: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/x86/vdso/vclock_gettime.c |   63 ++++++++++++++++++++++++----------------
 1 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6bc0e72..6c93209 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -70,6 +70,15 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 	return ret;
 }
 
+notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
+{
+	long ret;
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	return ret;
+}
+
+
 notrace static inline long vgetns(void)
 {
 	long v;
@@ -85,21 +94,26 @@ notrace static inline long vgetns(void)
 notrace static noinline int do_realtime(struct timespec *ts)
 {
 	unsigned long seq, ns;
+	int mode;
 	do {
 		seq = read_seqbegin(&gtod->lock);
+		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->wall_time_sec;
 		ts->tv_nsec = gtod->wall_time_nsec;
 		ns = vgetns();
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+
 	timespec_add_ns(ts, ns);
-	return 0;
+	return mode;
 }
 
 notrace static noinline int do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
+	int mode;
 	do {
 		seq = read_seqbegin(&gtod->lock);
+		mode = gtod->clock.vclock_mode;
 		secs = gtod->wall_time_sec;
 		ns = gtod->wall_time_nsec + vgetns();
 		secs += gtod->wall_to_monotonic.tv_sec;
@@ -116,7 +130,7 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 	ts->tv_sec = secs;
 	ts->tv_nsec = ns;
 
-	return 0;
+	return mode;
 }
 
 notrace static noinline int do_realtime_coarse(struct timespec *ts)
@@ -156,14 +170,13 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
+	int ret = VCLOCK_NONE;
 	switch (clock) {
 	case CLOCK_REALTIME:
-		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
-			return do_realtime(ts);
+		ret = do_realtime(ts);
 		break;
 	case CLOCK_MONOTONIC:
-		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
-			return do_monotonic(ts);
+		ret = do_monotonic(ts);
 		break;
 	case CLOCK_REALTIME_COARSE:
 		return do_realtime_coarse(ts);
@@ -171,32 +184,32 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 		return do_monotonic_coarse(ts);
 	}
 
-	return vdso_fallback_gettime(clock, ts);
+	if (ret == VCLOCK_NONE)
+		return vdso_fallback_gettime(clock, ts);
+	return 0;
 }
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
-	long ret;
-	if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
-		if (likely(tv != NULL)) {
-			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
-				     offsetof(struct timespec, tv_nsec) ||
-				     sizeof(*tv) != sizeof(struct timespec));
-			do_realtime((struct timespec *)tv);
-			tv->tv_usec /= 1000;
-		}
-		if (unlikely(tz != NULL)) {
-			/* Avoid memcpy. Some old compilers fail to inline it */
-			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
-			tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
-		}
-		return 0;
+	long ret = VCLOCK_NONE;
+	if (likely(tv != NULL)) {
+		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
+			     offsetof(struct timespec, tv_nsec) ||
+			     sizeof(*tv) != sizeof(struct timespec));
+		ret = do_realtime((struct timespec *)tv);
+		tv->tv_usec /= 1000;
 	}
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
-	return ret;
+	if (unlikely(tz != NULL)) {
+		/* Avoid memcpy. Some old compilers fail to inline it */
+		tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
+		tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
+	}
+
+	if (ret == VCLOCK_NONE)
+		return vdso_fallback_gtod(tv, tz);
+	return 0;
 }
 int gettimeofday(struct timeval *, struct timezone *)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
-- 
1.7.3.2.146.gca209

