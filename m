Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031024Ab2CFVl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:41:56 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51659 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965219Ab2CFVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:41:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.182.37.99 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 1/5] x86: Move fork_idle from wq and idle caching to common code
Date: Tue,  6 Mar 2012 13:41:10 -0800
Message-Id: <1331070074-31717-2-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331070074-31717-1-git-send-email-venki@google.com>
References: <1330710103.30167.84.camel@sbsiddha-desk.sc.intel.com>
 <1331070074-31717-1-git-send-email-venki@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a part of cleanup suggested by Ingo here

* move smpboot wq stuff to common code.
* move idle task caching to common code and use the existing percpu
  idle_task() as cache, instead of another percpu var or NR_CPUs array.

These can be shared across archs.

Should not have any functionality impact.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/kernel/smpboot.c |   74 ++++++--------------------------------------
 include/linux/sched.h     |    1 +
 kernel/fork.c             |   48 +++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..cc714b1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -75,20 +75,8 @@
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-/* Store all idle threads, this can be reused instead of creating
-* a new thread. Also avoids complicated thread destroy functionality
-* for idle threads.
-*/
 #ifdef CONFIG_HOTPLUG_CPU
 /*
- * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
- * removed after init for !CONFIG_HOTPLUG_CPU.
- */
-static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
-#define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
-#define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
-
-/*
  * We need this for trampoline_base protection from concurrent accesses when
  * off- and onlining cores wildly.
  */
@@ -106,10 +94,6 @@ void cpu_hotplug_driver_unlock(void)
 
 ssize_t arch_cpu_probe(const char *buf, size_t count) { return -1; }
 ssize_t arch_cpu_release(const char *buf, size_t count) { return -1; }
-#else
-static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
-#define get_idle_for_cpu(x)      (idle_thread_array[(x)])
-#define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
 #endif
 
 /* Number of siblings per CPU package */
@@ -634,22 +618,6 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-static void __cpuinit do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle =
-		container_of(work, struct create_idle, work);
-
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 /* reduce the number of lines printed when booting a large cpu count system */
 static void __cpuinit announce_cpu(int cpu, int apicid)
 {
@@ -681,53 +649,32 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	unsigned long boot_error = 0;
 	unsigned long start_ip;
 	int timeout;
-	struct create_idle c_idle = {
-		.cpu	= cpu,
-		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-	};
-
-	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
+	struct task_struct *idle;
 
 	alternatives_smp_switch(1);
 
-	c_idle.idle = get_idle_for_cpu(cpu);
-
-	/*
-	 * We can't use kernel_thread since we must avoid to
-	 * reschedule the child.
-	 */
-	if (c_idle.idle) {
-		c_idle.idle->thread.sp = (unsigned long) (((struct pt_regs *)
-			(THREAD_SIZE +  task_stack_page(c_idle.idle))) - 1);
-		init_idle(c_idle.idle, cpu);
-		goto do_rest;
-	}
-
-	schedule_work(&c_idle.work);
-	wait_for_completion(&c_idle.done);
-
-	if (IS_ERR(c_idle.idle)) {
+	idle = fork_idle_from_wq(cpu);
+	if (IS_ERR(idle)) {
 		printk("failed fork for CPU %d\n", cpu);
-		destroy_work_on_stack(&c_idle.work);
-		return PTR_ERR(c_idle.idle);
+		return PTR_ERR(idle);
 	}
 
-	set_idle_for_cpu(cpu, c_idle.idle);
-do_rest:
-	per_cpu(current_task, cpu) = c_idle.idle;
+	idle->thread.sp = (unsigned long) (((struct pt_regs *)
+			(THREAD_SIZE +  task_stack_page(idle))) - 1);
+	per_cpu(current_task, cpu) = idle;
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
 #else
-	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
+	clear_tsk_thread_flag(idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
 	per_cpu(kernel_stack, cpu) =
-		(unsigned long)task_stack_page(c_idle.idle) -
+		(unsigned long)task_stack_page(idle) -
 		KERNEL_STACK_OFFSET + THREAD_SIZE;
 #endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
-	stack_start  = c_idle.idle->thread.sp;
+	stack_start  = idle->thread.sp;
 
 	/* start_ip had better be page-aligned! */
 	start_ip = trampoline_address();
@@ -831,7 +778,6 @@ do_rest:
 		smpboot_restore_warm_reset_vector();
 	}
 
-	destroy_work_on_stack(&c_idle.work);
 	return boot_error;
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d379a6..357057f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2292,6 +2292,7 @@ extern int do_execve(const char *,
 		     const char __user * const __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
+struct task_struct *fork_idle_from_wq(int);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index e2cd3e2..8704237 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -67,6 +67,8 @@
 #include <linux/oom.h>
 #include <linux/khugepaged.h>
 #include <linux/signalfd.h>
+#include <linux/workqueue.h>
+#include <linux/sched.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1479,6 +1481,52 @@ struct task_struct * __cpuinit fork_idle(int cpu)
 	return task;
 }
 
+struct create_idle {
+	struct work_struct work;
+	struct task_struct *idle;
+	struct completion done;
+	int cpu;
+};
+
+static void __cpuinit do_fork_idle(struct work_struct *work)
+{
+	struct create_idle *c_idle =
+		container_of(work, struct create_idle, work);
+
+	c_idle->idle = fork_idle(c_idle->cpu);
+	complete(&c_idle->done);
+}
+
+struct task_struct * __cpuinit fork_idle_from_wq(int cpu)
+{
+	struct task_struct *idle = idle_task(cpu);
+	struct create_idle c_idle = {
+		.cpu	= cpu,
+		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
+	};
+
+	/* Reuse stored idle thread when possible instead of creating
+	 * a new thread. Also avoids complicated thread destroy functionality
+	 * for idle threads.
+	 */
+	if (idle) {
+		init_idle(idle, cpu);
+		return idle;
+	}
+
+	/*
+	 * We can't use kernel_thread since we must avoid to
+	 * reschedule the child.
+	*/
+	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
+
+	schedule_work(&c_idle.work);
+	wait_for_completion(&c_idle.done);
+	destroy_work_on_stack(&c_idle.work);
+
+	return c_idle.idle;
+}
+
 /*
  *  Ok, this is the main fork-routine.
  *
-- 
1.7.7.3

