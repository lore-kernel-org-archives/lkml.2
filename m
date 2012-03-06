Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031434Ab2CFVmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:42:09 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51659 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031372Ab2CFVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:42:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.60.7.102 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
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
Subject: [PATCH 4/5] powerpc: Use common fork_idle_from_wq in smpboot
Date: Tue,  6 Mar 2012 13:41:13 -0800
Message-Id: <1331070074-31717-5-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331070074-31717-1-git-send-email-venki@google.com>
References: <1330710103.30167.84.camel@sbsiddha-desk.sc.intel.com>
 <1331070074-31717-1-git-send-email-venki@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. Instead of reimplementing fork_idle on wq and idle task caching,
use fork_idle_from_wq().

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/powerpc/kernel/smp.c |   63 +++++---------------------------------------
 1 files changed, 8 insertions(+), 55 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 46695fe..3b9705d 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -57,27 +57,11 @@
 #define DBG(fmt...)
 #endif
 
-
-/* Store all idle threads, this can be reused instead of creating
-* a new thread. Also avoids complicated thread destroy functionality
-* for idle threads.
-*/
 #ifdef CONFIG_HOTPLUG_CPU
-/*
- * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
- * removed after init for !CONFIG_HOTPLUG_CPU.
- */
-static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
-#define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
-#define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
 
 /* State of each CPU during hotplug phases */
 static DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-#else
-static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
-#define get_idle_for_cpu(x)      (idle_thread_array[(x)])
-#define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
 #endif
 
 struct thread_info *secondary_ti;
@@ -429,51 +413,20 @@ int generic_check_cpu_restart(unsigned int cpu)
 }
 #endif
 
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
 static int __cpuinit create_idle(unsigned int cpu)
 {
 	struct thread_info *ti;
-	struct create_idle c_idle = {
-		.cpu	= cpu,
-		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-	};
-	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
-
-	c_idle.idle = get_idle_for_cpu(cpu);
-
-	/* We can't use kernel_thread since we must avoid to
-	 * reschedule the child. We use a workqueue because
-	 * we want to fork from a kernel thread, not whatever
-	 * userspace process happens to be trying to online us.
-	 */
-	if (!c_idle.idle) {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-	} else
-		init_idle(c_idle.idle, cpu);
-	if (IS_ERR(c_idle.idle)) {		
-		pr_err("Failed fork for CPU %u: %li", cpu, PTR_ERR(c_idle.idle));
-		return PTR_ERR(c_idle.idle);
+	struct task_struct *idle;
+
+	idle = fork_idle_from_wq(cpu);
+	if (IS_ERR(idle)) {
+		pr_err("Failed fork for CPU %u: %li", cpu, PTR_ERR(idle));
+		return PTR_ERR(idle);
 	}
-	ti = task_thread_info(c_idle.idle);
+	ti = task_thread_info(idle);
 
 #ifdef CONFIG_PPC64
-	paca[cpu].__current = c_idle.idle;
+	paca[cpu].__current = idle;
 	paca[cpu].kstack = (unsigned long)ti + THREAD_SIZE - STACK_FRAME_OVERHEAD;
 #endif
 	ti->cpu = cpu;
-- 
1.7.7.3

