Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2BXWeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:34:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64757 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab2BXWeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:34:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.68.74.97 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 4/4] x86: Optimize try_ipiless_wakeup avoid idle task lookup
Date: Fri, 24 Feb 2012 14:33:20 -0800
Message-Id: <1330122800-834-5-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330122800-834-1-git-send-email-venki@google.com>
References: <1330122800-834-1-git-send-email-venki@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize try_ipiless_wakeup with caching of idletask's ti_flags pointer
in a percpu area. Shows a measurable difference in cost of async
smp_call_function_single() to a target CPU that is mwait-idle.

This shows ~50-100 cycles (of total 1200(local) or 1900(remote)) savings on
the IPI send side (as measured with async smp_call_function_single).

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/include/asm/ipiless_wake.h |    7 ++++---
 arch/x86/kernel/smpboot.c           |    4 ++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/ipiless_wake.h b/arch/x86/include/asm/ipiless_wake.h
index a490dd3..232ce36 100644
--- a/arch/x86/include/asm/ipiless_wake.h
+++ b/arch/x86/include/asm/ipiless_wake.h
@@ -7,6 +7,7 @@
 
 #ifdef CONFIG_SMP
 
+DECLARE_PER_CPU(__u32 *, idletask_ti_flags);
 /*
  * TIF_IN_IPILESS_IDLE CPU being in a idle state with ipiless wakeup
  * capability, without any pending IPIs.
@@ -61,13 +62,13 @@ static inline void do_ipiless_pending_work(void)
 
 static inline int try_ipiless_wakeup(int cpu)
 {
-	struct thread_info *idle_ti = task_thread_info(idle_task(cpu));
+	__u32 *ti_flags = per_cpu(idletask_ti_flags, cpu);
 
-	if (!(idle_ti->flags & _TIF_IN_IPILESS_IDLE))
+	if (!(*ti_flags & _TIF_IN_IPILESS_IDLE))
 		return 0;
 
 	return test_and_clear_bit(TIF_IN_IPILESS_IDLE,
-					(unsigned long *)&idle_ti->flags);
+					(unsigned long *)ti_flags);
 }
 
 #else
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..33339e2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -133,6 +133,8 @@ DEFINE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
+DEFINE_PER_CPU(__u32 *, idletask_ti_flags);
+
 atomic_t init_deasserted;
 
 /*
@@ -715,6 +717,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	set_idle_for_cpu(cpu, c_idle.idle);
 do_rest:
 	per_cpu(current_task, cpu) = c_idle.idle;
+	per_cpu(idletask_ti_flags, cpu) = &task_thread_info(c_idle.idle)->flags;
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
@@ -1143,6 +1146,7 @@ void __init native_smp_prepare_boot_cpu(void)
 	/* already set me in cpu_online_mask in boot_cpu_init() */
 	cpumask_set_cpu(me, cpu_callout_mask);
 	per_cpu(cpu_state, me) = CPU_ONLINE;
+	per_cpu(idletask_ti_flags, me) = &task_thread_info(current)->flags;
 }
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
-- 
1.7.7.3

