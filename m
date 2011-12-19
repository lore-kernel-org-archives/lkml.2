Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1LSTvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:51:54 -0500
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:41210 "EHLO
	intmgw003.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752812Ab1LSTvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:51:39 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Andy Lutomirski <luto@MIT.EDU>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH 2/2] Add a thread cpu time implementation to vDSO
Date: Mon, 19 Dec 2011 11:51:33 -0800
Message-Id: <1324324293-10390-3-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1324324293-10390-1-git-send-email-asharma@fb.com>
References: <1324324293-10390-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Sundararajan <kumar@fb.com>

This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..)
We use the following method to compute the thread cpu time:

t0 = process start
t1 = most recent context switch time
t2 = time at which the vsyscall is invoked

thread_cpu_time = sum(time slices between t0 to t1) + (t2 - t1)
		= current->se.sum_exec_runtime + now - sched_clock()

At context switch time We stash away

adj_sched_time = sum_exec_runtime - sched_clock()

in a per-cpu struct in the VVAR page (which has now been extended
to two pages) and then compute

thread_cpu_time = adj_sched_time + now

All computations are done in nanosecs on systems where TSC is stable.
If TSC is unstable, we fallback to a regular syscall.

Benchmark data:

Baseline:

        for (i = 0; i < 100000000; i++) {
                clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
                sum += ts.tv_sec * NSECS_PER_SEC + ts.tv_nsec;
        }

vclock_gettime:

        vclock_gettime = dlsym(vdso, "__vdso_clock_gettime");
        for (i = 0; i < 100000000; i++) {
                (*vclock_gettime)(CLOCK_THREAD_CPUTIME_ID, &ts);
                sum += ts.tv_sec * NSECS_PER_SEC + ts.tv_nsec;
        }

Baseline: 		19.34 secs
vclock_gettime: 	4.74 secs

This should speed up profilers that need to query thread
cpu time a lot to do fine-grained timestamps.

No statistically significant regression was detected on x86_64
context switch code. Most archs that don't support vsyscalls
will have this code disabled via jump labels.

Signed-off-by: Kumar Sundararajan <kumar@fb.com>
Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andy Lutomirski <luto@MIT.EDU>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/timer.h   |   18 +++++++++++++-----
 arch/x86/include/asm/vvar.h    |    1 +
 arch/x86/kernel/tsc.c          |   16 ++++++++++++++++
 arch/x86/kernel/vsyscall_64.c  |    1 +
 arch/x86/vdso/vclock_gettime.c |   36 ++++++++++++++++++++++++++++++++++--
 arch/x86/vdso/vma.c            |    5 +++++
 include/linux/jiffies.h        |   16 ++++++++++++++++
 kernel/sched.c                 |    8 ++++++++
 8 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 431793e..99a3670 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -55,19 +55,27 @@ DECLARE_PER_CPU(unsigned long long, cyc2ns_offset);
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
-static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
+static inline unsigned long long ___cycles_2_ns(unsigned long long cyc,
+						unsigned long long scale,
+						unsigned long long offset)
 {
 	unsigned long long quot;
 	unsigned long long rem;
-	int cpu = smp_processor_id();
-	unsigned long long ns = per_cpu(cyc2ns_offset, cpu);
+	unsigned long long ns = offset;
 	quot = (cyc >> CYC2NS_SCALE_FACTOR);
 	rem = cyc & ((1ULL << CYC2NS_SCALE_FACTOR) - 1);
-	ns += quot * per_cpu(cyc2ns, cpu) +
-		((rem * per_cpu(cyc2ns, cpu)) >> CYC2NS_SCALE_FACTOR);
+	ns += quot * scale + ((rem * scale) >> CYC2NS_SCALE_FACTOR);
 	return ns;
 }
 
+static inline unsigned long long __cycles_2_ns(unsigned long long cyc)
+{
+	int cpu = smp_processor_id();
+	unsigned long long offset = per_cpu(cyc2ns_offset, cpu);
+	unsigned long long scale = per_cpu(cyc2ns, cpu);
+	return ___cycles_2_ns(cyc, scale, offset);
+}
+
 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 {
 	unsigned long long ns;
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 0fd7a4a..6710e2a 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -47,5 +47,6 @@
 DECLARE_VVAR(0, volatile unsigned long, jiffies)
 DECLARE_VVAR(16, int, vgetcpu_mode)
 DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
+DECLARE_VVAR(256, struct vcpu_data, vcpu_data)
 
 #undef DECLARE_VVAR
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index db48336..8e9f52c 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -623,6 +623,8 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	if (cpu_khz) {
 		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
 		*offset = ns_now - (tsc_now * *scale >> CYC2NS_SCALE_FACTOR);
+		vcpu_data.vpercpu[cpu].cyc2ns = *scale;
+		vcpu_data.vpercpu[cpu].cyc2ns_offset = *offset;
 	}
 
 	sched_clock_idle_wakeup_event(0);
@@ -786,6 +788,8 @@ void mark_tsc_unstable(char *reason)
 		tsc_unstable = 1;
 		sched_clock_stable = 0;
 		disable_sched_clock_irqtime();
+		vcpu_data.thread_cputime_disabled = 1;
+		jump_label_dec(&vcpu_data_enabled);
 		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
@@ -943,6 +947,15 @@ static int __init init_tsc_clocksource(void)
  */
 device_initcall(init_tsc_clocksource);
 
+/* Should be optimized away at compile time */
+static noinline int check_vvar_overflow(void)
+{
+	long vcpu_data_offset =  (long) vvaraddr_vcpu_data - VVAR_ADDRESS;
+	size_t size = (vcpu_data_offset + sizeof(vcpu_data)
+			+ sizeof(struct vpercpu_data) * CONFIG_NR_CPUS);
+	return (size > VVAR_NUM_PAGES * PAGE_SIZE);
+}
+
 void __init tsc_init(void)
 {
 	u64 lpj;
@@ -979,6 +992,9 @@ void __init tsc_init(void)
 
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
+	vcpu_data.tsc_khz = tsc_khz;
+	vcpu_data.thread_cputime_disabled = check_vvar_overflow()
+		|| !cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP);
 
 	if (!no_sched_irq_time)
 		enable_sched_clock_irqtime();
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 7960d3a..cdfcedf 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -56,6 +56,7 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 {
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 };
+DEFINE_VVAR(struct vcpu_data, vcpu_data);
 
 static enum { EMULATE, NATIVE, NONE } vsyscall_mode = NATIVE;
 
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6bc0e72..14d466a 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -18,6 +18,7 @@
 #include <asm/vsyscall.h>
 #include <asm/fixmap.h>
 #include <asm/vgtod.h>
+#include <asm/timer.h>
 #include <asm/timex.h>
 #include <asm/hpet.h>
 #include <asm/unistd.h>
@@ -154,8 +155,32 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 	return 0;
 }
 
+notrace static noinline unsigned long do_thread_cpu_time(void)
+{
+	unsigned int p;
+	u_int64_t tscval;
+	unsigned long long adj_sched_time, scale, offset;
+	const struct vcpu_data *vp = &VVAR(vcpu_data);
+	int cpu;
+
+	do {
+		native_read_tscp(&p);
+		cpu = p & 0xfff;
+		adj_sched_time = vp->vpercpu[cpu].adj_sched_time;
+		scale = vp->vpercpu[cpu].cyc2ns;
+		offset = vp->vpercpu[cpu].cyc2ns_offset;
+		rdtscpll(tscval, p);
+		cpu = p & 0xfff;
+	} while (unlikely(adj_sched_time != vp->vpercpu[cpu].adj_sched_time));
+
+	return  ___cycles_2_ns(tscval, scale, offset) + adj_sched_time;
+}
+
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
+	unsigned long ns;
+	const struct vcpu_data *vp = &VVAR(vcpu_data);
+
 	switch (clock) {
 	case CLOCK_REALTIME:
 		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE))
@@ -169,6 +194,13 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 		return do_realtime_coarse(ts);
 	case CLOCK_MONOTONIC_COARSE:
 		return do_monotonic_coarse(ts);
+	case CLOCK_THREAD_CPUTIME_ID:
+		if (vp->thread_cputime_disabled)
+			break;
+		ns = do_thread_cpu_time();
+		ts->tv_sec = 0;
+		timespec_add_ns(ts, ns);
+		return 0;
 	}
 
 	return vdso_fallback_gettime(clock, ts);
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 153407c..8b7630e 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/random.h>
 #include <linux/elf.h>
+#include <linux/jump_label.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
@@ -24,6 +25,8 @@ extern unsigned short vdso_sync_cpuid;
 extern struct page *vdso_pages[];
 static unsigned vdso_size;
 
+struct jump_label_key vcpu_data_enabled;
+
 static void __init patch_vdso(void *vdso, size_t len)
 {
 	Elf64_Ehdr *hdr = vdso;
@@ -66,6 +69,8 @@ static int __init init_vdso(void)
 	for (i = 0; i < npages; i++)
 		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
 
+	if (!vcpu_data.thread_cputime_disabled)
+		jump_label_inc(&vcpu_data_enabled);
 	return 0;
 }
 subsys_initcall(init_vdso);
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 265e2c3..d44e6aa 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -312,4 +312,20 @@ extern unsigned long nsecs_to_jiffies(u64 n);
 
 #define TIMESTAMP_SIZE	30
 
+struct vpercpu_data {
+	unsigned long long adj_sched_time;
+	unsigned long long cyc2ns_offset;
+	unsigned long cyc2ns;
+} ____cacheline_aligned;
+
+struct vcpu_data {
+	unsigned int tsc_khz;
+	unsigned int thread_cputime_disabled;
+	struct vpercpu_data vpercpu[0];
+};
+extern struct vcpu_data vcpu_data;
+
+struct jump_label_key;
+extern struct jump_label_key vcpu_data_enabled;
+
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..b738dd6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3216,6 +3216,14 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		kprobe_flush_task(prev);
 		put_task_struct(prev);
 	}
+
+#if CONFIG_NR_CPUS <= 64
+	if (static_branch(&vcpu_data_enabled)) {
+		int cpu = smp_processor_id();
+		vcpu_data.vpercpu[cpu].adj_sched_time =
+                  current->se.sum_exec_runtime - sched_clock();
+	}
+#endif
 }
 
 #ifdef CONFIG_SMP
-- 
1.7.4

