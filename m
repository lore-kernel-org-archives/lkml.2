Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2CIWEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:04:48 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:60307 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2CIWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:04:47 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@lianro.org>
Subject: [PATCH] time: x86: Fix race switching from vsyscall to non-vsyscall clock
Date: Fri,  9 Mar 2012 14:04:07 -0800
Message-Id: <1331330647-31480-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030922-5518-0000-0000-000002DA42C6
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

CC: Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@lianro.org>
---
 arch/x86/vdso/vclock_gettime.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6bc0e72..e7cf1dd 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -85,21 +85,28 @@ notrace static inline long vgetns(void)
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
+	if (mode == VCLOCK_NONE)
+		return -1;
 	return 0;
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
@@ -116,6 +123,8 @@ notrace static noinline int do_monotonic(struct timespec *ts)
 	ts->tv_sec = secs;
 	ts->tv_nsec = ns;
 
+	if (mode == VCLOCK_NONE)
+		return -1;
 	return 0;
 }
 
@@ -158,19 +167,25 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	switch (clock) {
 	case CLOCK_REALTIME:
-		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
-			return do_realtime(ts);
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
+			if (do_realtime(ts))
+				goto fallback;
+			return 0;
+		}
 		break;
 	case CLOCK_MONOTONIC:
-		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
-			return do_monotonic(ts);
+		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
+			if (do_monotonic(ts))
+				goto fallback;
+			return 0;
+		}
 		break;
 	case CLOCK_REALTIME_COARSE:
 		return do_realtime_coarse(ts);
 	case CLOCK_MONOTONIC_COARSE:
 		return do_monotonic_coarse(ts);
 	}
-
+fallback:
 	return vdso_fallback_gettime(clock, ts);
 }
 int clock_gettime(clockid_t, struct timespec *)
-- 
1.7.3.2.146.gca209

