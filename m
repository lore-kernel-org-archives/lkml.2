Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2CWEQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:16:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40284 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2CWEQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:16:03 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Andy Lutomirski <luto@mit.edu>, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/2] x86-64: Simplify and optimize vdso clock_gettime monotonic variants
Date: Thu, 22 Mar 2012 21:15:51 -0700
Message-Id: <abfa364e4d2e63a344ccd35427a24a2eba7c582a.1332475308.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1332475308.git.luto@amacapital.net>
References: <cover.1332475308.git.luto@amacapital.net>
In-Reply-To: <cover.1332475308.git.luto@amacapital.net>
References: <cover.1332475308.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@mit.edu>

We used to store the wall-to-monotonic offset and the realtime base.
It's faster to precompute the monotonic base.

This is about a 3% speedup on Sandy Bridge for CLOCK_MONOTONIC.
It's much more impressive for CLOCK_MONOTONIC_COARSE.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/vgtod.h   |   15 +++++++++------
 arch/x86/kernel/vsyscall_64.c  |   10 +++++++++-
 arch/x86/vdso/vclock_gettime.c |   38 ++++++++------------------------------
 3 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 1f00717..8b38be2 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -7,11 +7,6 @@
 struct vsyscall_gtod_data {
 	seqcount_t	seq;
 
-	/* open coded 'struct timespec' */
-	time_t		wall_time_sec;
-	u32		wall_time_nsec;
-
-	struct timezone sys_tz;
 	struct { /* extract of a clocksource struct */
 		int vclock_mode;
 		cycle_t	cycle_last;
@@ -19,8 +14,16 @@ struct vsyscall_gtod_data {
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
+	struct timezone sys_tz;
 	struct timespec wall_time_coarse;
+	struct timespec monotonic_time_coarse;
 };
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index cdc95a7..4285f1f 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -84,6 +84,7 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 			struct clocksource *clock, u32 mult)
 {
 	write_seqcount_begin(&vsyscall_gtod_data.seq);
+	struct timespec monotonic;
 
 	/* copy vsyscall data */
 	vsyscall_gtod_data.clock.vclock_mode	= clock->archdata.vclock_mode;
@@ -91,10 +92,17 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
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
 
 	write_seqcount_end(&vsyscall_gtod_data.seq);
 }
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 944c5e5..6eea70b8 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -113,27 +113,17 @@ notrace static noinline int do_realtime(struct timespec *ts)
 
 notrace static noinline int do_monotonic(struct timespec *ts)
 {
-	unsigned long seq, ns, secs;
+	unsigned long seq, ns;
 	int mode;
 
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
-		secs = gtod->wall_time_sec;
-		ns = gtod->wall_time_nsec + vgetns();
-		secs += gtod->wall_to_monotonic.tv_sec;
-		ns += gtod->wall_to_monotonic.tv_nsec;
+		ts->tv_sec = gtod->monotonic_time_sec;
+		ts->tv_nsec = gtod->monotonic_time_nsec;
+		ns = vgetns();
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-
-	/* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
-	 * are all guaranteed to be nonnegative.
-	 */
-	while (ns >= NSEC_PER_SEC) {
-		ns -= NSEC_PER_SEC;
-		++secs;
-	}
-	ts->tv_sec = secs;
-	ts->tv_nsec = ns;
+	timespec_add_ns(ts, ns);
 
 	return mode;
 }
@@ -151,25 +141,13 @@ notrace static noinline int do_realtime_coarse(struct timespec *ts)
 
 notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 {
-	unsigned long seq, ns, secs;
+	unsigned long seq;
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
-		secs = gtod->wall_time_coarse.tv_sec;
-		ns = gtod->wall_time_coarse.tv_nsec;
-		secs += gtod->wall_to_monotonic.tv_sec;
-		ns += gtod->wall_to_monotonic.tv_nsec;
+		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
+		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 
-	/* wall_time_nsec and wall_to_monotonic.tv_nsec are
-	 * guaranteed to be between 0 and NSEC_PER_SEC.
-	 */
-	if (ns >= NSEC_PER_SEC) {
-		ns -= NSEC_PER_SEC;
-		++secs;
-	}
-	ts->tv_sec = secs;
-	ts->tv_nsec = ns;
-
 	return 0;
 }
 
-- 
1.7.7.6

