Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2CUGA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:00:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:11113 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab2CUGAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:00:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="79857493"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNBpNw+iFYoHtVgUi0ZHHhj4G4opZ0P9Cw
Date: Wed, 21 Mar 2012 05:59:20 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A05B485@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
	 <1331891364.18960.221.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
	 <1332151397.18960.252.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
 <1332245842.18960.413.camel@twins>
In-Reply-To: <1332245842.18960.413.camel@twins>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the below on top of current tip/master work?
Still has the same warning problem, and system hang there.
Could you consider the advice that setting the active just after set online?

Paste the both patches from you that I am testing:
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 11b9630..56eb3b4
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -285,19 +285,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	x86_platform.nmi_init();
 
-	/*
-	 * Wait until the cpu which brought this one up marked it
-	 * online before enabling interrupts. If we don't do that then
-	 * we can end up waking up the softirq thread before this cpu
-	 * reached the active state, which makes the scheduler unhappy
-	 * and schedule the softirq thread on the wrong cpu. This is
-	 * only observable with forced threaded interrupts, but in
-	 * theory it could also happen w/o them. It's just way harder
-	 * to achieve.
-	 */
-	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
-		cpu_relax();
-
 	/* enable local interrupts */
 	local_irq_enable();
 

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index e9eaec5..f3190db
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -22,7 +22,7 @@ extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
-extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
+extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -144,7 +144,7 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 	cpumask_copy(mask, cpu_possible_mask);
 }
 
-static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
+static inline void cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
 	do_set_cpus_allowed(p, cpu_possible_mask);
 	return cpumask_any(cpu_active_mask);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
old mode 100644
new mode 100755
index 9c9b754..76ba3b8
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2182,7 +2182,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	mutex_unlock(&callback_mutex);
 }
 
-int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
+void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
 	const struct cpuset *cs;
 	int cpu;
@@ -2206,22 +2206,12 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 	 * changes in tsk_cs()->cpus_allowed. Otherwise we can temporary
 	 * set any mask even if it is not right from task_cs() pov,
 	 * the pending set_cpus_allowed_ptr() will fix things.
-	 */
-
-	cpu = cpumask_any_and(&tsk->cpus_allowed, cpu_active_mask);
-	if (cpu >= nr_cpu_ids) {
-		/*
-		 * Either tsk->cpus_allowed is wrong (see above) or it
-		 * is actually empty. The latter case is only possible
-		 * if we are racing with remove_tasks_in_empty_cpuset().
-		 * Like above we can temporary set any mask and rely on
-		 * set_cpus_allowed_ptr() as synchronization point.
+	 *
+	 * select_fallback_rq() will fix things ups and set cpu_possible_mask
+	 * if required.
 		 */
-		do_set_cpus_allowed(tsk, cpu_possible_mask);
-		cpu = cpumask_any(cpu_active_mask);
-	}
 
-	return cpu;
+
 }
 
 void cpuset_init_current_mems_allowed(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index d1c6969..bb3377d
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2374,29 +2374,65 @@ EXPORT_SYMBOL_GPL(kick_process);
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
-	int dest_cpu;
 	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+	enum { cpuset, possible, fail } state = cpuset;
+	int dest_cpu;
 
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
-		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+	for_each_cpu_mask(dest_cpu, *nodemask) {
+		if (!cpu_online(dest_cpu))
+			continue;
+		if (!cpu_active(dest_cpu))
+			continue;
+		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
 			return dest_cpu;
+	}
+
 
 	/* Any allowed, online CPU? */
 	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
 	if (dest_cpu < nr_cpu_ids)
 		return dest_cpu;
+	for (;;) {
+		/* Any allowed, online CPU? */
+		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
+			if (!cpu_online(dest_cpu))
+				continue;
+			if (!cpu_active(dest_cpu))
+				continue;
+			goto out;
+		}
+		
+
+		switch (state) {
+		case cpuset:
+			/* No more Mr. Nice Guy. */
+			cpuset_cpus_allowed_fallback(p);
+			state = possible;
+			break;
+	
+		case possible:
+			do_set_cpus_allowed(p, cpu_possible_mask);
+			state = fail;
+			break;
+	
+		case fail:
+			BUG();
+			break;
+		}
+	}
+out:
+	if (state != cpuset) {
+			/*
+			 * Don't tell them about moving exiting tasks or
+			 * kernel threads (both mm NULL), since they never
+			 * leave kernel.
+			 */
+			if (p->mm && printk_ratelimit()) {
+				printk(KERN_INFO "process %d (%s) no longer affine to cpu%d\n",
+						task_pid_nr(p), p->comm, cpu);
+			}
 
-	/* No more Mr. Nice Guy. */
-	dest_cpu = cpuset_cpus_allowed_fallback(p);
-	/*
-	 * Don't tell them about moving exiting tasks or
-	 * kernel threads (both mm NULL), since they never
-	 * leave kernel.
-	 */
-	if (p->mm && printk_ratelimit()) {
-		printk(KERN_INFO "process %d (%s) no longer affine to cpu%d\n",
-				task_pid_nr(p), p->comm, cpu);
 	}
 
 	return dest_cpu;
@@ -6489,7 +6525,7 @@ static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_ONLINE:
+	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;


> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Tuesday, March 20, 2012 8:17 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> On Tue, 2012-03-20 at 00:22 +0000, Liu, Chuansheng wrote:
> > Thanks to give some time to have a look.
> >
> Does the below on top of current tip/master work?
> >
> ---
>  include/linux/cpuset.h |    6 +---
>  kernel/cpuset.c        |   20 +++------------
>  kernel/sched/core.c    |   62
> +++++++++++++++++++++++++++++++++++------------
>  3 files changed, 52 insertions(+), 36 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h index
> e9eaec5..e0ffaf0 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -22,7 +22,7 @@ extern int cpuset_init(void);  extern void
> cpuset_init_smp(void);  extern void cpuset_update_active_cpus(void);
> extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
> -extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
> +extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
>  extern nodemask_t cpuset_mems_allowed(struct task_struct *p);  #define
> cpuset_current_mems_allowed (current->mems_allowed)  void
> cpuset_init_current_mems_allowed(void);
> @@ -144,10 +144,8 @@ static inline void cpuset_cpus_allowed(struct
> task_struct *p,
>  	cpumask_copy(mask, cpu_possible_mask);  }
> 
> -static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
> +static inline void cpuset_cpus_allowed_fallback(struct task_struct *p)
>  {
> -	do_set_cpus_allowed(p, cpu_possible_mask);
> -	return cpumask_any(cpu_active_mask);
>  }
> 
>  static inline nodemask_t cpuset_mems_allowed(struct task_struct *p) diff
> --git a/kernel/cpuset.c b/kernel/cpuset.c index a09ac2b..c9837b7 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2195,7 +2195,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk,
> struct cpumask *pmask)
>  	mutex_unlock(&callback_mutex);
>  }
> 
> -int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
> +void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
>  {
>  	const struct cpuset *cs;
>  	int cpu;
> @@ -2219,22 +2219,10 @@ int cpuset_cpus_allowed_fallback(struct
> task_struct *tsk)
>  	 * changes in tsk_cs()->cpus_allowed. Otherwise we can temporary
>  	 * set any mask even if it is not right from task_cs() pov,
>  	 * the pending set_cpus_allowed_ptr() will fix things.
> +	 *
> +	 * select_fallback_rq() will fix things ups and set cpu_possible_mask
> +	 * if required.
>  	 */
> -
> -	cpu = cpumask_any_and(&tsk->cpus_allowed, cpu_active_mask);
> -	if (cpu >= nr_cpu_ids) {
> -		/*
> -		 * Either tsk->cpus_allowed is wrong (see above) or it
> -		 * is actually empty. The latter case is only possible
> -		 * if we are racing with remove_tasks_in_empty_cpuset().
> -		 * Like above we can temporary set any mask and rely on
> -		 * set_cpus_allowed_ptr() as synchronization point.
> -		 */
> -		do_set_cpus_allowed(tsk, cpu_possible_mask);
> -		cpu = cpumask_any(cpu_active_mask);
> -	}
> -
> -	return cpu;
>  }
> 
>  void cpuset_init_current_mems_allowed(void)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c index e37c9af..04d3f7f
> 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1263,29 +1263,59 @@ EXPORT_SYMBOL_GPL(kick_process);
>   */
>  static int select_fallback_rq(int cpu, struct task_struct *p)  {
> -	int dest_cpu;
>  	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
> +	enum { cpuset, possible, fail } state = cpuset;
> +	int dest_cpu;
> 
>  	/* Look for allowed, online CPU in same node. */
> -	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
> +	for_each_cpu_mask(dest_cpu, *nodemask) {
> +		if (!cpu_online(dest_cpu))
> +			continue;
> +		if (!cpu_active(dest_cpu))
> +			continue;
>  		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
>  			return dest_cpu;
> +	}
> 
> -	/* Any allowed, online CPU? */
> -	dest_cpu = cpumask_any_and(tsk_cpus_allowed(p), cpu_active_mask);
> -	if (dest_cpu < nr_cpu_ids)
> -		return dest_cpu;
> +	for (;;) {
> +		/* Any allowed, online CPU? */
> +		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
> +			if (!cpu_online(dest_cpu))
> +				continue;
> +			if (!cpu_active(dest_cpu))
> +				continue;
> +			goto out;
> +		}
> 
> -	/* No more Mr. Nice Guy. */
> -	dest_cpu = cpuset_cpus_allowed_fallback(p);
> -	/*
> -	 * Don't tell them about moving exiting tasks or
> -	 * kernel threads (both mm NULL), since they never
> -	 * leave kernel.
> -	 */
> -	if (p->mm && printk_ratelimit()) {
> -		printk_sched("process %d (%s) no longer affine to cpu%d\n",
> -				task_pid_nr(p), p->comm, cpu);
> +		switch (state) {
> +		case cpuset:
> +			/* No more Mr. Nice Guy. */
> +			cpuset_cpus_allowed_fallback(p);
> +			state = possible;
> +			break;
> +
> +		case possible:
> +			do_set_cpus_allowed(p, cpu_possible_mask);
> +			state = fail;
> +			break;
> +
> +		case fail:
> +			BUG();
> +			break;
> +		}
> +	}
> +
> +out:
> +	if (state != cpuset) {
> +		/*
> +		 * Don't tell them about moving exiting tasks or
> +		 * kernel threads (both mm NULL), since they never
> +		 * leave kernel.
> +		 */
> +		if (p->mm && printk_ratelimit()) {
> +			printk_sched("process %d (%s) no longer affine to cpu%d\n",
> +					task_pid_nr(p), p->comm, cpu);
> +		}
>  	}
> 
>  	return dest_cpu;

