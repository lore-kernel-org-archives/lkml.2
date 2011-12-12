Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1LLVUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:20:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58636 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753643Ab1LLVUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:20:00 -0500
Message-ID: <4EE66FE9.1050202@fb.com>
Date: Mon, 12 Dec 2011 13:19:37 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Andy Lutomirski <luto@MIT.EDU>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
References: <1323718578-1157-1-git-send-email-asharma@fb.com>  <1323718578-1157-3-git-send-email-asharma@fb.com> <1323720791.2583.23.camel@edumazet-laptop>
In-Reply-To: <1323720791.2583.23.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-12_09:2011-12-12,2011-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 12:13 PM, Eric Dumazet wrote:

>> +
>> +struct vcpu_data {
>> +	struct vpercpu_data vpercpu[NR_CPUS];
>> +	unsigned int tsc_khz;
>> +	unsigned int tsc_unstable;
>> +};
>
> Thats a showstopper.
>
> Try to compile the thing with NR_CPUS=4096 ?
>

I get a link time error:

ld: section .data..percpu [0000000001ac2000 -> 0000000001ad48ff] 
overlaps section .vvar [0000000001ac0000 -> 0000000001b0083f]

which I consider better than runtime memory corruption :)

I could add a BUILD_BUG_ON() that tries to catch this earlier in the 
compile process.

Re: Fixing the build for NR_CPUS > 64

How about something along the lines of the following:

From: Arun Sharma <asharma@fb.com>
Date: Mon, 12 Dec 2011 13:13:43 -0800
Subject: [PATCH] Handle NR_CPUS > 64

---
arch/x86/kernel/tsc.c          |    8 ++++++--
arch/x86/vdso/vclock_gettime.c |    4 ++--
include/linux/jiffies.h        |    8 ++++++--
kernel/sched.c                 |    2 ++
4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 1dc7205..45f3438 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -571,7 +571,11 @@ int recalibrate_cpu_khz(void)
			cpufreq_scale(cpu_data(0).loops_per_jiffy,
					cpu_khz_old, cpu_khz);
		vcpu_data.tsc_khz = tsc_khz;
-		vcpu_data.tsc_unstable = 0;
+#if CONFIG_NR_CPUS <= 64
+		vcpu_data.thread_cputime_disabled = 0;
+#else
+		vcpu_data.thread_cputime_disabled = 1;
+#endif
		return 0;
	} else
		return -ENODEV;
@@ -790,7 +794,7 @@ void mark_tsc_unstable(char *reason)
		tsc_unstable = 1;
		sched_clock_stable = 0;
		disable_sched_clock_irqtime();
-		vcpu_data.tsc_unstable = 1;
+		vcpu_data.thread_cputime_disabled = 1;
		jump_label_dec(&vcpu_data_enabled);
		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
		/* Change only the rating, when not registered */
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 61ab74b..e41a7e9 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -185,7 +185,7 @@ notrace static inline unsigned long 
__do_thread_cpu_time(void)
	const struct vcpu_data *vp = &VVAR(vcpu_data);
	int cpu;

-	if (vp->tsc_unstable) {
+	if (vp->thread_cputime_disabled) {
		struct timespec ts;
		vdso_fallback_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
		return timespec_to_ns(&ts);
@@ -236,7 +236,7 @@ notrace int __vdso_clock_gettime(clockid_t clock, 
struct timespec *ts)
	case CLOCK_MONOTONIC_COARSE:
		return do_monotonic_coarse(ts);
	case CLOCK_THREAD_CPUTIME_ID:
-		if (vp->tsc_unstable)
+		if (vp->thread_cputime_disabled)
			break;
		ns = do_thread_cpu_time();
		if (likely(ns > 0)) {
diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index a0fe1f5..aec389f 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -319,9 +319,13 @@ struct vpercpu_data {
} ____cacheline_aligned;

struct vcpu_data {
-	struct vpercpu_data vpercpu[NR_CPUS];
	unsigned int tsc_khz;
-	unsigned int tsc_unstable;
+	unsigned int thread_cputime_disabled;
+#if CONFIG_NR_CPUS <= 64
+	struct vpercpu_data vpercpu[NR_CPUS];
+#else
+	struct vpercpu_data vpercpu[1];
+#endif
};
extern struct vcpu_data vcpu_data;

diff --git a/kernel/sched.c b/kernel/sched.c
index a72545a..e4f38ae 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3216,11 +3216,13 @@ static void finish_task_switch(struct rq *rq, 
struct task_struct *prev)
		put_task_struct(prev);
	}

+#if CONFIG_NR_CPUS <= 64
	if (static_branch(&vcpu_data_enabled)) {
		int cpu = smp_processor_id();
		vcpu_data.vpercpu[cpu].adj_sched_time =
                   current->se.sum_exec_runtime - sched_clock();
	}
+#endif
}

#ifdef CONFIG_SMP
-- 
1.7.4


