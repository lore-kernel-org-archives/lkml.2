Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab0EGVMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:12:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494Ab0EGVMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:12:13 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 5/8] [x86] watchdog: move trigger_all_cpu_backtrace to its own die_notifier
Date: Fri,  7 May 2010 17:11:48 -0400
Message-Id: <1273266711-18706-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the transition of the nmi watchdog to something more generic,
the trigger_all_cpu_backtrace code is getting left behind.  Put it in its
own die_notifier so it can still be used.

V2:
- use arch_spin_locks

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |   65 ++++++++++++++++++++++++++++++++---------
 1 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 79425f9..8c3edfb 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -17,6 +17,10 @@
 #include <linux/cpumask.h>
 #include <linux/kernel_stat.h>
 #include <asm/mce.h>
+#include <linux/kdebug.h>
+#include <linux/notifier.h>
+#include <linux/kprobes.h>
+
 
 #include <linux/nmi.h>
 #include <linux/module.h>
@@ -54,20 +58,6 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
 	unsigned int sum;
 	int cpu = smp_processor_id();
 
-	/* FIXME: cheap hack for this check, probably should get its own
-	 * die_notifier handler
-	 */
-	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
-		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
-
-		spin_lock(&lock);
-		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
-		show_regs(regs);
-		dump_stack();
-		spin_unlock(&lock);
-		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
-	}
-
 	/* if we are doing an mce, just assume the cpu is not stuck */
 	/* Could check oops_in_progress here too, but it's safer not to */
 	if (mce_in_progress())
@@ -109,6 +99,53 @@ void arch_trigger_all_cpu_backtrace(void)
 		mdelay(1);
 	}
 }
+
+static int __kprobes
+arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
+			 unsigned long cmd, void *__args)
+{
+	struct die_args *args = __args;
+	struct pt_regs *regs;
+	int cpu = smp_processor_id();
+
+	switch (cmd) {
+	case DIE_NMI:
+	case DIE_NMI_IPI:
+		break;
+
+	default:
+		return NOTIFY_DONE;
+	}
+
+	regs = args->regs;
+
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
+		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
+
+		arch_spin_lock(&lock);
+		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
+		show_regs(regs);
+		dump_stack();
+		arch_spin_unlock(&lock);
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
+		return NOTIFY_STOP;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static __read_mostly struct notifier_block backtrace_notifier = {
+	.notifier_call          = arch_trigger_all_cpu_backtrace_handler,
+	.next                   = NULL,
+	.priority               = 1
+};
+
+static int __init register_trigger_all_cpu_backtrace(void)
+{
+	register_die_notifier(&backtrace_notifier);
+	return 0;
+}
+early_initcall(register_trigger_all_cpu_backtrace);
 #endif
 
 /* STUB calls to mimic old nmi_watchdog behaviour */
-- 
1.7.0.1

