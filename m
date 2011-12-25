Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1LYQvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 11:51:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57032 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab1LYQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 11:51:21 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/4] x86-64: Optimize vdso clock_gettime
Date: Sun, 25 Dec 2011 08:51:02 -0800
Message-Id: <a288f365bafedd86f26f462d7a01803c3151bf78.1324831829.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <cover.1324831829.git.luto@amacapital.net>
References: <cover.1324831829.git.luto@amacapital.net>
In-Reply-To: <cover.1324831829.git.luto@amacapital.net>
References: <cover.1324831829.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a small improvement.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/vgtod.h   |   21 +++++++---
 arch/x86/kernel/vsyscall_64.c  |   25 +++++++++++-
 arch/x86/vdso/vclock_gettime.c |   89 ++++++++++++++++++++++-----------------
 3 files changed, 89 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 815285b..03b4999 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -7,11 +7,6 @@
 struct vsyscall_gtod_data {
 	seqlock_t	lock;
 
-	/* open coded 'struct timespec' */
-	time_t		wall_time_sec;
-	u32		wall_time_nsec;
-
-	struct timezone sys_tz;
 	struct { /* extract of a clocksource struct */
 		int vclock_mode;
 		cycle_t	cycle_last;
@@ -19,8 +14,22 @@ struct vsyscall_gtod_data {
 		u32	mult;
 		u32	shift;
 	} clock;
-	struct timespec wall_to_monotonic;
+
+	/* open coded 'struct timespec' */
+	time_t		wall_time_sec;
+	u32		wall_time_nsec;
+	u32		monotonic_time_nsec;
+	time_t		monotonic_time_sec;
+
+	/* Flat counts for clock_ns_get */
+	u64		wall_time_flat_ns;
+	u64		monotonic_time_flat_ns;
+	u64		wall_time_coarse_flat_ns;
+	u64		monotonic_time_coarse_flat_ns;
+
+	struct timezone sys_tz;
 	struct timespec wall_time_coarse;
+	struct timespec monotonic_time_coarse;
 };
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index b56c65de..9c2e148 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -91,6 +91,7 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 			struct clocksource *clock, u32 mult)
 {
 	unsigned long flags;
+	struct timespec monotonic;
 
 	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
 
@@ -100,10 +101,32 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	vsyscall_gtod_data.clock.mask		= clock->mask;
 	vsyscall_gtod_data.clock.mult		= mult;
 	vsyscall_gtod_data.clock.shift		= clock->shift;
+
 	vsyscall_gtod_data.wall_time_sec	= wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec	= wall_time->tv_nsec;
-	vsyscall_gtod_data.wall_to_monotonic	= *wtm;
+
+	monotonic = timespec_add(*wall_time, *wtm);
+	vsyscall_gtod_data.monotonic_time_sec	= monotonic.tv_sec;
+	vsyscall_gtod_data.monotonic_time_nsec	= monotonic.tv_nsec;
+
 	vsyscall_gtod_data.wall_time_coarse	= __current_kernel_time();
+	vsyscall_gtod_data.monotonic_time_coarse =
+		timespec_add(vsyscall_gtod_data.wall_time_coarse, *wtm);
+
+	/* generate flat data for clock_ns_get */
+	vsyscall_gtod_data.wall_time_flat_ns =
+		vsyscall_gtod_data.wall_time_sec * NSEC_PER_SEC +
+		vsyscall_gtod_data.wall_time_nsec;
+	vsyscall_gtod_data.monotonic_time_flat_ns =
+		vsyscall_gtod_data.monotonic_time_sec * NSEC_PER_SEC +
+		vsyscall_gtod_data.monotonic_time_nsec;
+
+	vsyscall_gtod_data.wall_time_coarse_flat_ns =
+		vsyscall_gtod_data.wall_time_coarse.tv_sec * NSEC_PER_SEC +
+		vsyscall_gtod_data.wall_time_coarse.tv_nsec;
+	vsyscall_gtod_data.monotonic_time_coarse_flat_ns =
+		vsyscall_gtod_data.monotonic_time_coarse.tv_sec * NSEC_PER_SEC +
+		vsyscall_gtod_data.monotonic_time_coarse.tv_nsec;
 
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index c8a2b46..fe960ac 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -94,26 +94,36 @@ notrace static noinline void do_realtime(struct timespec *ts)
 	timespec_add_ns(ts, ns);
 }
 
+notrace static noinline u64 do_realtime_ns(void)
+{
+	unsigned long seq, ns;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		ns = gtod->wall_time_flat_ns + vgetns();
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	return ns;
+}
+
 notrace static noinline void do_monotonic(struct timespec *ts)
 {
-	unsigned long seq, ns, secs;
+	unsigned long seq, ns;
 	do {
 		seq = read_seqbegin(&gtod->lock);
-		secs = gtod->wall_time_sec;
-		ns = gtod->wall_time_nsec + vgetns();
-		secs += gtod->wall_to_monotonic.tv_sec;
-		ns += gtod->wall_to_monotonic.tv_nsec;
+		ts->tv_sec = gtod->monotonic_time_sec;
+		ts->tv_nsec = gtod->monotonic_time_nsec;
+		ns = vgetns();
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	timespec_add_ns(ts, ns);
+}
 
-	/* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
-	 * are all guaranteed to be nonnegative.
-	 */
-	while (ns >= NSEC_PER_SEC) {
-		ns -= NSEC_PER_SEC;
-		++secs;
-	}
-	ts->tv_sec = secs;
-	ts->tv_nsec = ns;
+notrace static noinline u64 do_monotonic_ns(void)
+{
+	unsigned long seq, ns;
+	do {
+		seq = read_seqbegin(&gtod->lock);
+		ns = gtod->monotonic_time_flat_ns + vgetns();
+	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	return ns;
 }
 
 notrace static noinline void do_realtime_coarse(struct timespec *ts)
@@ -126,26 +136,26 @@ notrace static noinline void do_realtime_coarse(struct timespec *ts)
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
 }
 
+notrace static noinline u64 do_realtime_coarse_ns(void)
+{
+	/* This is atomic on x86-64. */
+	return ACCESS_ONCE(gtod->wall_time_coarse_flat_ns);
+}
+
 notrace static noinline void do_monotonic_coarse(struct timespec *ts)
 {
-	unsigned long seq, ns, secs;
+	unsigned long seq;
 	do {
 		seq = read_seqbegin(&gtod->lock);
-		secs = gtod->wall_time_coarse.tv_sec;
-		ns = gtod->wall_time_coarse.tv_nsec;
-		secs += gtod->wall_to_monotonic.tv_sec;
-		ns += gtod->wall_to_monotonic.tv_nsec;
+		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
+		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
 	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+}
 
-	/* wall_time_nsec and wall_to_monotonic.tv_nsec are
-	 * guaranteed to be between 0 and NSEC_PER_SEC.
-	 */
-	if (ns >= NSEC_PER_SEC) {
-		ns -= NSEC_PER_SEC;
-		++secs;
-	}
-	ts->tv_sec = secs;
-	ts->tv_nsec = ns;
+notrace static noinline u64 do_monotonic_coarse_ns(void)
+{
+	/* This is atomic on x86-64. */
+	return ACCESS_ONCE(gtod->monotonic_time_coarse_flat_ns);
 }
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
@@ -178,37 +188,38 @@ int clock_gettime(clockid_t, struct timespec *)
 
 notrace int __vdso_clock_gettime_ns(clockid_t clock, struct timens *t)
 {
-	/* This implementation is slow.  It will be improved later. */
-
 	struct timespec ts;
 	int error;
 
 	switch (clock) {
 	case CLOCK_REALTIME:
 		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
-			do_realtime(&ts);
-			goto done;
+			t->ns = do_realtime_ns();
+			t->padding = 0;
+			return 0;
 		}
 		break;
 	case CLOCK_MONOTONIC:
 		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
-			do_monotonic(&ts);
-			goto done;
+			t->ns = do_monotonic_ns();
+			t->padding = 0;
+			return 0;
 		}
 		break;
 	case CLOCK_REALTIME_COARSE:
-		do_realtime_coarse(&ts);
-		goto done;
+		t->ns = do_realtime_coarse_ns();
+		t->padding = 0;
+		return 0;
 	case CLOCK_MONOTONIC_COARSE:
-		do_monotonic_coarse(&ts);
-		goto done;
+		t->ns = do_monotonic_coarse_ns();
+		t->padding = 0;
+		return 0;
 	}
 
 	error = vdso_fallback_gettime(clock, &ts);
 	if (error)
 		return error;
 
-done:
 	t->ns = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
 	t->padding = 0;
 	return 0;
-- 
1.7.7.4

