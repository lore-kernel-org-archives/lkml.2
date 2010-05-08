Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0EHPSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:18:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:50770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab0EHPST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:18:19 -0400
Message-ID: <4BE58092.5020101@kernel.org>
Date: Sat, 08 May 2010 17:17:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: peterz@infradead.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: [PATCH] cpu_stop: add dummy implementation for UP
References: <1273164772-19149-1-git-send-email-tj@kernel.org> <20100508111529.GA19796@elte.hu>
In-Reply-To: <20100508111529.GA19796@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 15:17:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When !CONFIG_SMP, cpu_stop functions weren't defined at all which
could lead to build failures if UP code uses cpu_stop facility.  Add
dummy cpu_stop implementation for UP.  The waiting variants execute
the work function directly with preempt disabled and
stop_one_cpu_nowait() schedules a workqueue work.

Makefile and ifdefs around stop_machine implementation are updated to
accomodate CONFIG_SMP && !CONFIG_STOP_MACHINE case.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
---
This patch should fix possible build issues on UP configurations.
I've published the patch to the cpu_stop branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cpu_stop

Ingo, can you please pull from it?

Thank you.

 include/linux/stop_machine.h |   69 ++++++++++++++++++++++++++++++++++++++----
 kernel/Makefile              |    2 +-
 kernel/stop_machine.c        |    4 ++
 3 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 0e552e7..6b524a0 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -6,8 +6,6 @@
 #include <linux/list.h>
 #include <asm/system.h>

-#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
-
 /*
  * stop_cpu[s]() is simplistic per-cpu maximum priority cpu
  * monopolization mechanism.  The caller can specify a non-sleeping
@@ -18,9 +16,10 @@
  * up and requests are guaranteed to be served as long as the target
  * cpus are online.
  */
-
 typedef int (*cpu_stop_fn_t)(void *arg);

+#ifdef CONFIG_SMP
+
 struct cpu_stop_work {
 	struct list_head	list;		/* cpu_stopper->works */
 	cpu_stop_fn_t		fn;
@@ -34,12 +33,70 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 int stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);
 int try_stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg);

+#else	/* CONFIG_SMP */
+
+#include <linux/workqueue.h>
+
+struct cpu_stop_work {
+	struct work_struct	work;
+	cpu_stop_fn_t		fn;
+	void			*arg;
+};
+
+static inline int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg)
+{
+	int ret = -ENOENT;
+	preempt_disable();
+	if (cpu == smp_processor_id())
+		ret = fn(arg);
+	preempt_enable();
+	return ret;
+}
+
+static void stop_one_cpu_nowait_workfn(struct work_struct *work)
+{
+	struct cpu_stop_work *stwork =
+		container_of(work, struct cpu_stop_work, work);
+	preempt_disable();
+	stwork->fn(stwork->arg);
+	preempt_enable();
+}
+
+static inline void stop_one_cpu_nowait(unsigned int cpu,
+				       cpu_stop_fn_t fn, void *arg,
+				       struct cpu_stop_work *work_buf)
+{
+	if (cpu == smp_processor_id()) {
+		INIT_WORK(&work_buf->work, stop_one_cpu_nowait_workfn);
+		work_buf->fn = fn;
+		work_buf->arg = arg;
+		schedule_work(&work_buf->work);
+	}
+}
+
+static inline int stop_cpus(const struct cpumask *cpumask,
+			    cpu_stop_fn_t fn, void *arg)
+{
+	if (cpumask_test_cpu(raw_smp_processor_id(), cpumask))
+		return stop_one_cpu(raw_smp_processor_id(), fn, arg);
+	return -ENOENT;
+}
+
+static inline int try_stop_cpus(const struct cpumask *cpumask,
+				cpu_stop_fn_t fn, void *arg)
+{
+	return stop_cpus(cpumask, fn, arg);
+}
+
+#endif	/* CONFIG_SMP */
+
 /*
  * stop_machine "Bogolock": stop the entire machine, disable
  * interrupts.  This is a very heavy lock, which is equivalent to
  * grabbing every spinlock (and more).  So the "read" side to such a
  * lock is anything which disables preeempt.
  */
+#if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)

 /**
  * stop_machine: freeze the machine on all CPUs and run this function
@@ -67,7 +124,7 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
  */
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);

-#else
+#else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */

 static inline int stop_machine(int (*fn)(void *), void *data,
 			       const struct cpumask *cpus)
@@ -79,5 +136,5 @@ static inline int stop_machine(int (*fn)(void *), void *data,
 	return ret;
 }

-#endif /* CONFIG_SMP */
-#endif /* _LINUX_STOP_MACHINE */
+#endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
+#endif	/* _LINUX_STOP_MACHINE */
diff --git a/kernel/Makefile b/kernel/Makefile
index a987aa1..149e18e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -68,7 +68,7 @@ obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
-obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
+obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o audit_watch.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 5b20141..ef51d1f 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -375,6 +375,8 @@ static int __init cpu_stop_init(void)
 }
 early_initcall(cpu_stop_init);

+#ifdef CONFIG_STOP_MACHINE
+
 /* This controls the threads on each CPU. */
 enum stopmachine_state {
 	/* Dummy starting state for thread. */
@@ -477,3 +479,5 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
+
+#endif	/* CONFIG_STOP_MACHINE */
-- 
1.6.4.2

