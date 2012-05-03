Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080Ab2ECXjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:39:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:23960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063Ab2ECXjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:39:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="139859334"
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
Date: Thu, 03 May 2012 16:42:32 -0700
In-Reply-To: <alpine.LFD.2.02.1205031137270.6271@ionos>
References: <20120420122120.097464672@linutronix.de>
	  <1334928098.2463.56.camel@laptop>
	  <alpine.LFD.2.02.1204201540400.2542@ionos>
	 <1334966930.28674.245.camel@sbsiddha-desk.sc.intel.com>
	 <alpine.LFD.2.02.1205031137270.6271@ionos>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336088552.28674.457.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 11:41 +0200, Thomas Gleixner wrote:
> On Fri, 20 Apr 2012, Suresh Siddha wrote:
> > Also, do we really need the workqueue/kthreadd based allocation? Just
> > like the percpu areas getting allocated for each possible cpu during
> > boot, shouldn't we extend this to the per-cpu idle threads too? So
> > something like the appended should be ok to?
> 
> The idea is correct, there are just a few problems :)
>  
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index 05c46ba..a5144ab 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -303,10 +303,6 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
> >  
> >  	cpu_hotplug_begin();
> >  
> > -	ret = smpboot_prepare(cpu);
> > -	if (ret)
> > -		goto out;
> > -
> 
> If we failed to allocate an idle_thread for this cpu in smp_init()
> then we unconditionally call __cpu_up() with a NULL pointer. That
> might surprise the arch code :)
> 
> Aside of that, we now miss to reinitialize the idle thread. We call
> init_idle() once when we allocate the thread, but not after a cpu
> offline operation. That might leave stuff in weird state.

Second one slipped through and wasn't intentional. Anyways your
modifications look good.

While I am here, noticed that we could do 'node' aware idle task struct
allocations. Appended the patch for this. Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: idle: allocate percpu idle taks from the local node

Use the arch specific early_cpu_to_node() to find out the local node for a
given 'cpu' and use that info while allocating memory for that cpu's idle task.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/topology.h |    8 +++++---
 arch/x86/mm/numa.c              |    2 +-
 include/asm-generic/topology.h  |    4 ++++
 include/linux/kthread.h         |    9 ++++++++-
 kernel/fork.c                   |    9 ++++++---
 kernel/kthread.c                |    8 +++-----
 6 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index b9676ae..bdbcee2 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -57,12 +57,12 @@ DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 extern int __cpu_to_node(int cpu);
 #define cpu_to_node __cpu_to_node
 
-extern int early_cpu_to_node(int cpu);
+extern int __early_cpu_to_node(int cpu);
 
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
 /* Same function but used if called before per_cpu areas are setup */
-static inline int early_cpu_to_node(int cpu)
+static inline int __early_cpu_to_node(int cpu)
 {
 	return early_per_cpu(x86_cpu_to_node_map, cpu);
 }
@@ -144,7 +144,7 @@ static inline int numa_node_id(void)
  */
 #define numa_node_id numa_node_id
 
-static inline int early_cpu_to_node(int cpu)
+static inline int __early_cpu_to_node(int cpu)
 {
 	return 0;
 }
@@ -153,6 +153,8 @@ static inline void setup_node_to_cpumask_map(void) { }
 
 #endif
 
+#define early_cpu_to_node(cpu)	__early_cpu_to_node(cpu)
+
 #include <asm-generic/topology.h>
 
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 19d3fa0..142738e 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -734,7 +734,7 @@ EXPORT_SYMBOL(__cpu_to_node);
  * Same function as cpu_to_node() but used if called before the
  * per_cpu areas are setup.
  */
-int early_cpu_to_node(int cpu)
+int __early_cpu_to_node(int cpu)
 {
 	if (early_per_cpu_ptr(x86_cpu_to_node_map))
 		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
index fc824e2..9ace6da 100644
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -73,4 +73,8 @@
 
 #endif	/* !CONFIG_NUMA || !CONFIG_HAVE_MEMORYLESS_NODES */
 
+#ifndef early_cpu_to_node
+#define early_cpu_to_node(cpu)	((void)(cpu), -1)
+#endif
+
 #endif /* _ASM_GENERIC_TOPOLOGY_H */
diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 0714b24..c1f05e3 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -40,7 +40,7 @@ void *kthread_data(struct task_struct *k);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
-extern int tsk_fork_get_node(struct task_struct *tsk);
+extern int tsk_fork_get_node(struct task_struct *tsk, int idle_tsk);
 
 /*
  * Simple work processor based on kthread.
@@ -131,4 +131,11 @@ bool queue_kthread_work(struct kthread_worker *worker,
 void flush_kthread_work(struct kthread_work *work);
 void flush_kthread_worker(struct kthread_worker *worker);
 
+static inline void set_fork_pref_node(int node)
+{
+#ifdef CONFIG_NUMA
+	current->pref_node_fork = node;
+#endif
+}
+
 #endif /* _LINUX_KTHREAD_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index ca9a384..108d566 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -253,12 +253,13 @@ int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
 	return 0;
 }
 
-static struct task_struct *dup_task_struct(struct task_struct *orig)
+static struct task_struct *dup_task_struct(struct task_struct *orig,
+					   int idle_tsk)
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
 	unsigned long *stackend;
-	int node = tsk_fork_get_node(orig);
+	int node = tsk_fork_get_node(orig, idle_tsk);
 	int err;
 
 	prepare_to_copy(orig);
@@ -1165,7 +1166,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	retval = -ENOMEM;
-	p = dup_task_struct(current);
+	p = dup_task_struct(current, pid == &init_struct_pid);
 	if (!p)
 		goto fork_out;
 
@@ -1531,6 +1532,8 @@ struct task_struct * __cpuinit fork_idle(int cpu)
 	struct task_struct *task;
 	struct pt_regs regs;
 
+	set_fork_pref_node(early_cpu_to_node(cpu));
+
 	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
 			    &init_struct_pid, 0);
 	if (!IS_ERR(task)) {
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 3d3de63..3d74ab1 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -125,10 +125,10 @@ static int kthread(void *_create)
 }
 
 /* called from do_fork() to get node information for about to be created task */
-int tsk_fork_get_node(struct task_struct *tsk)
+int tsk_fork_get_node(struct task_struct *tsk, int idle_tsk)
 {
 #ifdef CONFIG_NUMA
-	if (tsk == kthreadd_task)
+	if (tsk == kthreadd_task || idle_tsk)
 		return tsk->pref_node_fork;
 #endif
 	return numa_node_id();
@@ -138,9 +138,7 @@ static void create_kthread(struct kthread_create_info *create)
 {
 	int pid;
 
-#ifdef CONFIG_NUMA
-	current->pref_node_fork = create->node;
-#endif
+	set_fork_pref_node(create->node);
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
 	if (pid < 0) {



