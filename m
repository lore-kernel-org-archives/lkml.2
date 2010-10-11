Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0JKK04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 06:26:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:44226 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0JKK0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 06:26:55 -0400
From: Dongdong Deng <dongdong.deng@windriver.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, dongdong.deng@windriver.com,
        bruce.ashfield@windriver.com
Subject: [PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at the same time on SMP
Date: Mon, 11 Oct 2010 18:31:51 +0800
Message-Id: <1286793111-27579-1-git-send-email-dongdong.deng@windriver.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 11 Oct 2010 10:25:22.0381 (UTC) FILETIME=[9C6A37D0:01CB692E]
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
---
 arch/x86/kernel/apic/hw_nmi.c |   14 ++++++++++++++
 arch/x86/kernel/apic/nmi.c    |   14 ++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index cefd694..3aea0a5 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -29,6 +29,16 @@ u64 hw_nmi_get_sample_period(void)
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
+	static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (!arch_spin_trylock(&lock))
+		/*
+		 * If there is already a trigger_all_cpu_backtrace()
+		 * in progress, don't output double cpu dump infos.
+		 */
+		goto out_restore_irq;
 
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
@@ -41,6 +51,10 @@ void arch_trigger_all_cpu_backtrace(void)
 			break;
 		mdelay(1);
 	}
+
+	arch_spin_unlock(&lock);
+out_restore_irq:
+	local_irq_restore(flags);
 }
 
 static int __kprobes
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index a43f71c..5fa8a13 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -552,6 +552,16 @@ int do_nmi_callback(struct pt_regs *regs, int cpu)
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
+	static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (!arch_spin_trylock(&lock))
+		/*
+		 * If there is already a trigger_all_cpu_backtrace()
+		 * in progress, don't output double cpu dump infos.
+		 */
+		goto out_restore_irq;
 
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
@@ -564,4 +574,8 @@ void arch_trigger_all_cpu_backtrace(void)
 			break;
 		mdelay(1);
 	}
+
+	arch_spin_unlock(&lock);
+out_restore_irq:
+	local_irq_restore(flags);
 }
-- 
1.6.0.4

