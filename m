Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1LMB1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:27:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33577 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab1LMB0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:26:52 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 2/2] x86-64: Add __vdso_clock_gettime_ns vsyscall
Date: Mon, 12 Dec 2011 17:26:38 -0800
Message-Id: <8db74f68d65f90e99825dacc16ef20948ebea1d4.1323739287.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <cover.1323739287.git.luto@amacapital.net>
References: <cover.1323739287.git.luto@amacapital.net>
In-Reply-To: <cover.1323739287.git.luto@amacapital.net>
References: <cover.1323739287.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just for the ABI.  An optimized implementation will come later.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vclock_gettime.c |   70 ++++++++++++++++++++++++++++++---------
 arch/x86/vdso/vdso.lds.S       |    7 ++++
 2 files changed, 61 insertions(+), 16 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6bc0e72..79d6919 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -82,7 +82,7 @@ notrace static inline long vgetns(void)
 	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
-notrace static noinline int do_realtime(struct timespec *ts)
+notrace static noinline void do_realtime(struct timespec *ts)
 {
 	unsigned long seq, ns;
 	do {
@@ -92,10 +92,9 @@ notrace static noinline int do_realtime(struct timespec *ts)
 		ns = vgetns();
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
 	timespec_add_ns(ts, ns);
-	return 0;
 }
 
-notrace static noinline int do_monotonic(struct timespec *ts)
+notrace static noinline void do_monotonic(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
 	do {
@@ -115,11 +114,9 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 	}
 	ts->tv_sec = secs;
 	ts->tv_nsec = ns;
-
-	return 0;
 }
 
-notrace static noinline int do_realtime_coarse(struct timespec *ts)
+notrace static noinline void do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
@@ -127,10 +124,9 @@ notrace static noinline int do_realtime_coarse(struct timespec *ts)
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
-	return 0;
 }
 
-notrace static noinline int do_monotonic_coarse(struct timespec *ts)
+notrace static noinline void do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq, ns, secs;
 	do {
@@ -150,25 +146,29 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 	}
 	ts->tv_sec = secs;
 	ts->tv_nsec = ns;
-
-	return 0;
 }
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	switch (clock) {
 	case CLOCK_REALTIME:
-		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
-			return do_realtime(ts);
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
+			do_realtime(ts);
+			return 0;
+		}
 		break;
 	case CLOCK_MONOTONIC:
-		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
-			return do_monotonic(ts);
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
+			do_monotonic(ts);
+			return 0;
+		}
 		break;
 	case CLOCK_REALTIME_COARSE:
-		return do_realtime_coarse(ts);
+		do_realtime_coarse(ts);
+		return 0;
 	case CLOCK_MONOTONIC_COARSE:
-		return do_monotonic_coarse(ts);
+		do_monotonic_coarse(ts);
+		return 0;
 	}
 
 	return vdso_fallback_gettime(clock, ts);
@@ -176,6 +176,44 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
+notrace int __vdso_clock_gettime_ns(clockid_t clock, u64 *t)
+{
+	/* This implementation is slow.  It will be improved later. */
+
+	struct timespec ts;
+	int error;
+
+	switch (clock) {
+	case CLOCK_REALTIME:
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
+			do_realtime(&ts);
+			*t = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+			return 0;
+		}
+		break;
+	case CLOCK_MONOTONIC:
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
+			do_monotonic(&ts);
+			*t = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+			return 0;
+		}
+		break;
+	case CLOCK_REALTIME_COARSE:
+		do_realtime_coarse(&ts);
+		*t = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+		return 0;
+	case CLOCK_MONOTONIC_COARSE:
+		do_monotonic_coarse(&ts);
+		*t = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+		return 0;
+	}
+
+	error = vdso_fallback_gettime(clock, &ts);
+	if (!error)
+		*t = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
+	return error;
+}
+
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index b96b267..238f500 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -17,6 +17,10 @@
 VERSION {
 	LINUX_2.6 {
 	global:
+		/*
+		 * These are the original vsyscalls.  They have weak symbols
+		 * without the __vdso_ prefix for ABI compatibility.
+		 */
 		clock_gettime;
 		__vdso_clock_gettime;
 		gettimeofday;
@@ -25,6 +29,9 @@ VERSION {
 		__vdso_getcpu;
 		time;
 		__vdso_time;
+
+		/* New vsyscalls are just plain functions. */
+		__vdso_clock_gettime_ns;
 	local: *;
 	};
 }
-- 
1.7.7.4

