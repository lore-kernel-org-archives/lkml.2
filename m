Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0DEKim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 06:38:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0DEKi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 06:38:26 -0400
Message-ID: <4BB9BD8A.9040209@cn.fujitsu.com>
Date: Mon, 05 Apr 2010 18:38:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
       Sachin Sant <sachinp@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Shane Wang <shane.wang@intel.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 2/2] cpuhotplug: make get_online_cpus() scalability by using
 percpu counter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current get_online_cpus() acquires a mutex lock and then
release it. It is not scale and it hurts cache. This patch rewrite it.

1) get_online_cpus() must be allowed to be called recursively, so I added
   get_online_cpus_nest for every task for new code.

   This patch just allows get_online_cpus() to be called recursively,
   but when it is not nested, get_online_cpus() will wait until
   cpuhotplug finished, so the potential starvation is avoided.

   And, the livelock of cpu_hotplug_begin() is avoided, so the comment
   is removed.

2) This new code use PER_CPU counters, and this counters protected
   by RCU. These counters acts like the reference counters of a modules.
   (Actually, all these code is stolen from module.c: try_refcount_get()
   is stolen from try_module_get(), put_online_cpus() from module_put()...)

   After this patch applied, get_online_cpus() is very light and scale when
   cpuhotplug is not running. It just disables preemption and increase
   the cpu counter and then enables preemption.

3) Since we have try_refcount_get(), I add a new API try_get_online_cpus().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/cpu.h   |    2
 include/linux/sched.h |    3 +
 kernel/cpu.c          |  131 ++++++++++++++++++++++++++++++++------------------
 kernel/fork.c         |    3 +
 4 files changed, 94 insertions(+), 45 deletions(-)
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index e287863..a32809c 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -112,6 +112,7 @@ extern struct sysdev_class cpu_sysdev_class;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern int try_get_online_cpus(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -134,6 +135,7 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define try_get_online_cpus()	(1)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c46b6e5..0422ea3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1501,6 +1501,9 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_HOTPLUG_CPU
+	int get_online_cpus_nest;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index bc1e3d5..ede02c6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
+#include <linux/percpu.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -42,41 +43,82 @@ static int cpu_hotplug_disabled;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static struct {
-	struct task_struct *active_writer;
-	struct mutex lock; /* Synchronizes accesses to refcount, */
-	/*
-	 * Also blocks the new readers during
-	 * an ongoing cpu hotplug operation.
-	 */
-	int refcount;
-} cpu_hotplug = {
-	.active_writer = NULL,
-	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
-	.refcount = 0,
-};
+DEFINE_MUTEX(cpu_hotplug_lock);
+struct task_struct *cpu_hotplug_task;
+DEFINE_PER_CPU(int, refcount);
+
+static int try_refcount_get(void)
+{
+	preempt_disable();
+
+	if (likely(!cpu_hotplug_task)) {
+		__get_cpu_var(refcount)++;
+		preempt_enable();
+		return 1;
+	}
+
+	preempt_enable();
+	return 0;
+}
+
+int try_get_online_cpus(void)
+{
+	if (cpu_hotplug_task == current)
+		return 1;
+
+	if (current->get_online_cpus_nest || try_refcount_get()) {
+		current->get_online_cpus_nest++;
+		return 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(try_get_online_cpus);
 
 void get_online_cpus(void)
 {
 	might_sleep();
-	if (cpu_hotplug.active_writer == current)
+	if (cpu_hotplug_task == current)
+		return;
+
+	if (current->get_online_cpus_nest++)
+		return;
+
+	if (likely(try_refcount_get()))
 		return;
-	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount++;
-	mutex_unlock(&cpu_hotplug.lock);
 
+	mutex_lock(&cpu_hotplug_lock);
+	percpu_add(refcount, 1);
+	mutex_unlock(&cpu_hotplug_lock);
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
 
+static unsigned int refcount_sum(void)
+{
+	unsigned int total = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		total += per_cpu(refcount, cpu);
+
+	return total;
+}
+
 void put_online_cpus(void)
 {
-	if (cpu_hotplug.active_writer == current)
+	if (cpu_hotplug_task == current)
+		return;
+
+	if (WARN_ON(!current->get_online_cpus_nest))
 		return;
-	mutex_lock(&cpu_hotplug.lock);
-	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
-		wake_up_process(cpu_hotplug.active_writer);
-	mutex_unlock(&cpu_hotplug.lock);
 
+	if (!--current->get_online_cpus_nest) {
+		preempt_disable();
+		__get_cpu_var(refcount)--;
+		if (cpu_hotplug_task)
+			wake_up_process(cpu_hotplug_task);
+		preempt_enable();
+	}
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
 
@@ -85,41 +127,40 @@ EXPORT_SYMBOL_GPL(put_online_cpus);
  * refcount goes to zero.
  *
  * Note that during a cpu-hotplug operation, the new readers, if any,
- * will be blocked by the cpu_hotplug.lock
- *
- * Since cpu_hotplug_begin() is always called after invoking
- * cpu_maps_update_begin(), we can be sure that only one writer is active.
- *
- * Note that theoretically, there is a possibility of a livelock:
- * - Refcount goes to zero, last reader wakes up the sleeping
- *   writer.
- * - Last reader unlocks the cpu_hotplug.lock.
- * - A new reader arrives at this moment, bumps up the refcount.
- * - The writer acquires the cpu_hotplug.lock finds the refcount
- *   non zero and goes to sleep again.
- *
- * However, this is very difficult to achieve in practice since
- * get_online_cpus() not an api which is called all that often.
- *
+ * will be blocked by the cpu_hotplug_lock
  */
 static void cpu_hotplug_begin(void)
 {
-	cpu_hotplug.active_writer = current;
+	mutex_lock(&cpu_hotplug_lock);
+
+	/*
+	 * Set cpu_hotplug_task. Wait until all running try_refcount_get()
+	 * finished and all these try_refcount_get() behavior are seen.
+	 */
+	cpu_hotplug_task = current;
+	synchronize_sched();
 
+	/* Wait for zero refcount */
 	for (;;) {
-		mutex_lock(&cpu_hotplug.lock);
-		if (likely(!cpu_hotplug.refcount))
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!refcount_sum())
 			break;
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&cpu_hotplug.lock);
 		schedule();
 	}
+
+	__set_current_state(TASK_RUNNING);
 }
 
 static void cpu_hotplug_done(void)
 {
-	cpu_hotplug.active_writer = NULL;
-	mutex_unlock(&cpu_hotplug.lock);
+	/*
+	 * Ensure try_refcount_get() sees the front befavior
+	 * after it sees cpu_hotplug_task == NULL.
+	 */
+	smp_mb();
+
+	cpu_hotplug_task = NULL;
+	mutex_unlock(&cpu_hotplug_lock);
 }
 
 #else /* #if CONFIG_HOTPLUG_CPU */
diff --git a/kernel/fork.c b/kernel/fork.c
index d67f1db..b162014 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1109,6 +1109,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->memcg_batch.memcg = NULL;
 #endif
 	p->stack_start = stack_start;
+#ifdef CONFIG_HOTPLUG_CPU
+	p->get_online_cpus_nest = 0;
+#endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);

