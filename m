Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab2DUAGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:06:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:40348 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab2DUAGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:06:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144243205"
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        venki@google.com
Date: Fri, 20 Apr 2012 17:08:50 -0700
In-Reply-To: <alpine.LFD.2.02.1204201540400.2542@ionos>
References: <20120420122120.097464672@linutronix.de>
	 <1334928098.2463.56.camel@laptop>
	 <alpine.LFD.2.02.1204201540400.2542@ionos>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334966930.28674.245.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 15:47 +0200, Thomas Gleixner wrote:
> On Fri, 20 Apr 2012, Peter Zijlstra wrote:
> 
> > On Fri, 2012-04-20 at 13:05 +0000, Thomas Gleixner wrote:
> > > This first part moves the idle thread management for non-boot cpus
> > > into the core. fork_idle() is called in a workqueue as it is
> > > implemented in a few architectures already. This is necessary when not
> > > all cpus are brought up by the early boot code as otherwise we would
> > > take a ref on the user task VM of the thread which brings the cpu up
> > > via the sysfs interface. 
> > 
> > So I was thinking about this and I think we should make that kthreadd
> > instead of a random workqueue thread due to all that cgroup crap. People
> > are wanting to place all sorts of kernel threads in cgroups and I'm
> > still arguing that kthreadd should not be allowed in cgroups.
> 
> So your fear is that the idle_thread will end up in some random cgroup
> because some illdesigned user space code decided to stick kernel
> threads into cgroups.
> 
> Can we please have some sanity restrictions on this cgroup muck? I
> don't care when user space creates cgroups in circles, but holding the
> whole kernel hostage of this madness is going too far.
> 

Also, do we really need the workqueue/kthreadd based allocation? Just
like the percpu areas getting allocated for each possible cpu during
boot, shouldn't we extend this to the per-cpu idle threads too? So
something like the appended should be ok to?

In the context of Venki's fork_idle patches, Ingo mentioned of moving
the percpu idle threads into percpu areas. While we can easily do that
for non-boot cpu's, 'init_task' will be special. So for now, does the
appended (ontop of your other patches) look ok?
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: smp, idle: allocate idle thread for each possible cpu during boot

percpu areas are already allocated during boot for each possible cpu.
percpu idle threads can be considered as an extension of the percpu areas,
and allocate them for each possible cpu during boot.

This will eliminate the need for workqueue based idle thread allocation.
In future we can move the idle thread area into the percpu area too.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 05c46ba..a5144ab 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -303,10 +303,6 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 
 	cpu_hotplug_begin();
 
-	ret = smpboot_prepare(cpu);
-	if (ret)
-		goto out;
-
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
@@ -327,7 +323,6 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 out_notify:
 	if (ret != 0)
 		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
-out:
 	cpu_hotplug_done();
 
 	return ret;
diff --git a/kernel/smp.c b/kernel/smp.c
index 2f8b10e..e755fc6 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -13,6 +13,8 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 
+#include "smpboot.h"
+
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 static struct {
 	struct list_head	queue;
@@ -669,6 +671,10 @@ void __init smp_init(void)
 {
 	unsigned int cpu;
 
+	for_each_possible_cpu(cpu)
+		if (cpu != smp_processor_id())
+			smpboot_prepare(cpu);
+
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index a24ddbe..72b49fc 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -5,40 +5,10 @@
 #include <linux/smp.h>
 #include <linux/sched.h>
 #include <linux/percpu.h>
-#include <linux/workqueue.h>
 
 #include "smpboot.h"
 
 #ifdef CONFIG_GENERIC_SMP_IDLE_THREAD
-struct create_idle {
-	struct work_struct	work;
-	struct task_struct	*idle;
-	struct completion	done;
-	unsigned int cpu;
-};
-
-static void __cpuinit do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c = container_of(work, struct create_idle, work);
-
-	c->idle = fork_idle(c->cpu);
-	complete(&c->done);
-}
-
-static struct task_struct * __cpuinit idle_thread_create(unsigned int cpu)
-{
-	struct create_idle c_idle = {
-		.cpu	= cpu,
-		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-	};
-
-	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
-	schedule_work(&c_idle.work);
-	wait_for_completion(&c_idle.done);
-	destroy_work_on_stack(&c_idle.work);
-	return c_idle.idle;
-}
-
 /*
  * For the hotplug case we keep the task structs around and reuse
  * them.
@@ -50,7 +20,7 @@ static inline struct task_struct *get_idle_for_cpu(unsigned int cpu)
 	struct task_struct *tsk = per_cpu(idle_threads, cpu);
 
 	if (!tsk)
-		return idle_thread_create(cpu);
+		return fork_idle(cpu);
 	init_idle(tsk, cpu);
 	return tsk;
 }


