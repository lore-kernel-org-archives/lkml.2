Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab2IQWFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:05:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45856 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab2IQWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:05:23 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Tony Luck <tony.luck@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/6][RFC] time: Convert x86_64 to using new update_vsyscall
Date: Mon, 17 Sep 2012 18:05:01 -0400
Message-Id: <1347919501-64534-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091722-3534-0000-0000-00000CD52F25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch x86_64 to using sub-ns precise vsyscall

Cc: Tony Luck <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/x86/Kconfig               |    2 +-
 arch/x86/include/asm/vgtod.h   |    4 ++--
 arch/x86/kernel/vsyscall_64.c  |   47 ++++++++++++++++++++++++----------------
 arch/x86/vdso/vclock_gettime.c |   22 ++++++++++++-------
 4 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e3f3c1a..8ec3a1a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -93,7 +93,7 @@ config X86
 	select GENERIC_CLOCKEVENTS
 	select ARCH_CLOCKSOURCE_DATA if X86_64
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
-	select GENERIC_TIME_VSYSCALL_OLD if X86_64
+	select GENERIC_TIME_VSYSCALL if X86_64
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 8b38be2..46e24d3 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -17,8 +17,8 @@ struct vsyscall_gtod_data {
 
 	/* open coded 'struct timespec' */
 	time_t		wall_time_sec;
-	u32		wall_time_nsec;
-	u32		monotonic_time_nsec;
+	u64		wall_time_snsec;
+	u64		monotonic_time_snsec;
 	time_t		monotonic_time_sec;
 
 	struct timezone sys_tz;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 77dde29..3a3e8c9 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -82,32 +82,41 @@ void update_vsyscall_tz(void)
 	vsyscall_gtod_data.sys_tz = sys_tz;
 }
 
-void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
-			struct clocksource *clock, u32 mult)
+void update_vsyscall(struct timekeeper *tk)
 {
-	struct timespec monotonic;
+	struct vsyscall_gtod_data *vdata = &vsyscall_gtod_data;
 
-	write_seqcount_begin(&vsyscall_gtod_data.seq);
+	write_seqcount_begin(&vdata->seq);
 
 	/* copy vsyscall data */
-	vsyscall_gtod_data.clock.vclock_mode	= clock->archdata.vclock_mode;
-	vsyscall_gtod_data.clock.cycle_last	= clock->cycle_last;
-	vsyscall_gtod_data.clock.mask		= clock->mask;
-	vsyscall_gtod_data.clock.mult		= mult;
-	vsyscall_gtod_data.clock.shift		= clock->shift;
-
-	vsyscall_gtod_data.wall_time_sec	= wall_time->tv_sec;
-	vsyscall_gtod_data.wall_time_nsec	= wall_time->tv_nsec;
+	vdata->clock.vclock_mode	= tk->clock->archdata.vclock_mode;
+	vdata->clock.cycle_last		= tk->clock->cycle_last;
+	vdata->clock.mask		= tk->clock->mask;
+	vdata->clock.mult		= tk->mult;
+	vdata->clock.shift		= tk->shift;
+
+	vdata->wall_time_sec		= tk->xtime_sec;
+	vdata->wall_time_snsec		= tk->xtime_nsec;
+
+	vdata->monotonic_time_sec	= tk->xtime_sec
+					+ tk->wall_to_monotonic.tv_sec;
+	vdata->monotonic_time_snsec	= tk->xtime_nsec
+					+ (tk->wall_to_monotonic.tv_nsec
+						<< tk->shift);
+	while (vdata->monotonic_time_snsec >=
+					(((u64)NSEC_PER_SEC) << tk->shift)) {
+		vdata->monotonic_time_snsec -=
+					((u64)NSEC_PER_SEC) << tk->shift;
+		vdata->monotonic_time_sec++;
+	}
 
-	monotonic = timespec_add(*wall_time, *wtm);
-	vsyscall_gtod_data.monotonic_time_sec	= monotonic.tv_sec;
-	vsyscall_gtod_data.monotonic_time_nsec	= monotonic.tv_nsec;
+	vdata->wall_time_coarse.tv_sec	= tk->xtime_sec;
+	vdata->wall_time_coarse.tv_nsec	= (long)(tk->xtime_nsec >> tk->shift);
 
-	vsyscall_gtod_data.wall_time_coarse	= __current_kernel_time();
-	vsyscall_gtod_data.monotonic_time_coarse =
-		timespec_add(vsyscall_gtod_data.wall_time_coarse, *wtm);
+	vdata->monotonic_time_coarse	= timespec_add(vdata->wall_time_coarse,
+							tk->wall_to_monotonic);
 
-	write_seqcount_end(&vsyscall_gtod_data.seq);
+	write_seqcount_end(&vdata->seq);
 }
 
 static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 885eff4..4df6c37 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -80,7 +80,7 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 }
 
 
-notrace static inline long vgetns(void)
+notrace static inline u64 vgetsns(void)
 {
 	long v;
 	cycles_t cycles;
@@ -91,21 +91,24 @@ notrace static inline long vgetns(void)
 	else
 		return 0;
 	v = (cycles - gtod->clock.cycle_last) & gtod->clock.mask;
-	return (v * gtod->clock.mult) >> gtod->clock.shift;
+	return v * gtod->clock.mult;
 }
 
 /* Code size doesn't matter (vdso is 4k anyway) and this is faster. */
 notrace static int __always_inline do_realtime(struct timespec *ts)
 {
-	unsigned long seq, ns;
+	unsigned long seq;
+	u64 ns;
 	int mode;
 
+	ts->tv_nsec = 0;
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->wall_time_sec;
-		ts->tv_nsec = gtod->wall_time_nsec;
-		ns = vgetns();
+		ns = gtod->wall_time_snsec;
+		ns += vgetsns();
+		ns >>= gtod->clock.shift;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 
 	timespec_add_ns(ts, ns);
@@ -114,15 +117,18 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 
 notrace static int do_monotonic(struct timespec *ts)
 {
-	unsigned long seq, ns;
+	unsigned long seq;
+	u64 ns;
 	int mode;
 
+	ts->tv_nsec = 0;
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->monotonic_time_sec;
-		ts->tv_nsec = gtod->monotonic_time_nsec;
-		ns = vgetns();
+		ns = gtod->monotonic_time_snsec;
+		ns += vgetsns();
+		ns >>= gtod->clock.shift;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	timespec_add_ns(ts, ns);
 
-- 
1.7.9.5

