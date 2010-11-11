Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab0KKCUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 21:20:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:62315 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0KKCUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 21:20:50 -0500
From: Dongdong Deng <dongdong.deng@windriver.com>
To: mingo@elte.hu, dzickus@redhat.com
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        dongdong.deng@windriver.com
Subject: [PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at the same time on SMP
Date: Thu, 11 Nov 2010 10:20:42 +0800
Message-Id: <1289442042-2515-1-git-send-email-dongdong.deng@windriver.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 11 Nov 2010 02:20:10.0066 (UTC) FILETIME=[F6EDBB20:01CB8146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spin_lock_debug/rcu_cpu_stall detector uses
trigger_all_cpu_backtrace() to dump cpu backtrace.
Therefore it is possible that trigger_all_cpu_backtrace()
could be called at the same time on different CPUs, which
triggers and 'unknown reason NMI' warning. The following case
illustrates the problem:

      CPU1                    CPU2                     ...   CPU N
                       trigger_all_cpu_backtrace()
                       set "backtrace_mask" to cpu mask
                               |
generate NMI interrupts  generate NMI interrupts       ...
    \                          |                               /
     \                         |                              /
   The "backtrace_mask" will be cleaned by the first NMI interrupt
  at nmi_watchdog_tick(), then the following NMI interrupts generated
by other cpus's arch_trigger_all_cpu_backtrace() will be took as
unknown reason NMI interrupts.

This patch uses a lock to avoid the problem, and stop the
arch_trigger_all_cpu_backtrace() calling to avoid dumping double cpu
backtrace info when there is already a trigger_all_cpu_backtrace()
in progress.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |   23 +++++++++++++++++++++++
 arch/x86/kernel/apic/nmi.c    |   23 +++++++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index cefd694..6084c3b 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -26,9 +26,27 @@ u64 hw_nmi_get_sample_period(void)
 }
 
 #ifdef ARCH_HAS_NMI_WATCHDOG
+/* "in progress" flag of arch_trigger_all_cpu_backtrace */
+static int backtrace_flag;
+
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
+	unsigned long flags;
+
+	/*
+	 * Have to disable irq here, as the
+	 * arch_trigger_all_cpu_backtrace() could be
+	 * triggered by "spin_lock()" with irqs on.
+	 */
+	local_irq_save(flags);
+
+	if (cmpxchg(&backtrace_flag, 0, 1) != 0)
+		/*
+		 * If there is already a trigger_all_cpu_backtrace() in progress
+		 * (backtrace_flag == 1), don't output double cpu dump infos.
+		 */
+		goto out_restore_irq;
 
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
@@ -41,6 +59,11 @@ void arch_trigger_all_cpu_backtrace(void)
 			break;
 		mdelay(1);
 	}
+
+	cmpxchg(&backtrace_flag, 1, 0);
+
+out_restore_irq:
+	local_irq_restore(flags);
 }
 
 static int __kprobes
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index c90041c..2d4b3a1 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -549,9 +549,27 @@ int do_nmi_callback(struct pt_regs *regs, int cpu)
 	return 0;
 }
 
+/* "in progress" flag of arch_trigger_all_cpu_backtrace */
+static int backtrace_flag;
+
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
+	unsigned long flags;
+
+	/*
+	 * Have to disable irq here, as the
+	 * arch_trigger_all_cpu_backtrace() could be
+	 * triggered by "spin_lock()" with irqs on.
+	 */
+	local_irq_save(flags);
+
+	if (cmpxchg(&backtrace_flag, 0, 1) != 0)
+		/*
+		 * If there is already a trigger_all_cpu_backtrace() in progress
+		 * (backtrace_flag == 1), don't output double cpu dump infos.
+		 */
+		goto out_restore_irq;
 
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
@@ -564,4 +582,9 @@ void arch_trigger_all_cpu_backtrace(void)
 			break;
 		mdelay(1);
 	}
+
+	cmpxchg(&backtrace_flag, 1, 0);
+
+out_restore_irq:
+	local_irq_restore(flags);
 }
-- 
1.6.0.4

