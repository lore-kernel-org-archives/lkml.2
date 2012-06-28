Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2F1GHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:07:49 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51365 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab2F1GHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:07:46 -0400
X-AuditID: b753bd60-914c2ba0000047ca-f8-4febf4afd957
X-AuditID: b753bd60-914c2ba0000047ca-f8-4febf4afd957
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 03/18] x86: Support hrtimer on slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:07:35 +0900
Message-ID: <20120628060735.19298.61354.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a facility to use hrtimer on slave CPUs.

To initialize hrtimer when slave CPUs are activated, and to shutdown hrtimer
when slave CPUs are stopped, this patch adds the slave cpu notifier chain,
which call registered callbacks when slave CPUs are up, dying, and died.

The registered callbacks are called with CPU_SLAVE_UP when a slave CPU
becomes active. When the slave CPU is stopped, callbacks are called with
CPU_SLAVE_DYING on slave CPUs, and with CPU_SLAVE_DEAD on online CPUs.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/cpu.h |    5 +++++
 arch/x86/kernel/smpboot.c  |   36 ++++++++++++++++++++++++++++++++++++
 kernel/hrtimer.c           |   22 ++++++++++++++++++++++
 3 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index a6dc43d..808b084 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -31,9 +31,14 @@ extern void arch_unregister_cpu(int);
 #endif
 
 #ifdef CONFIG_SLAVE_CPU
+int register_slave_cpu_notifier(struct notifier_block *nb);
+void unregister_slave_cpu_notifier(struct notifier_block *nb);
+
+/* CPU notifier constants for slave processors */
 #define CPU_SLAVE_UP_PREPARE	0xff00
 #define CPU_SLAVE_UP		0xff01
 #define CPU_SLAVE_DEAD		0xff02
+#define CPU_SLAVE_DYING		0xff03
 
 extern int slave_cpu_up(unsigned int cpu);
 extern int slave_cpu_down(unsigned int cpu);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index edeebad..527c4ca 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -125,6 +125,36 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;
 
+static void __ref remove_cpu_from_maps(int cpu);
+
+
+#ifdef CONFIG_SLAVE_CPU
+/* Notify slave cpu up and down */
+static RAW_NOTIFIER_HEAD(slave_cpu_chain);
+
+int register_slave_cpu_notifier(struct notifier_block *nb)
+{
+	return raw_notifier_chain_register(&slave_cpu_chain, nb);
+}
+EXPORT_SYMBOL(register_slave_cpu_notifier);
+
+void unregister_slave_cpu_notifier(struct notifier_block *nb)
+{
+	raw_notifier_chain_unregister(&slave_cpu_chain, nb);
+}
+EXPORT_SYMBOL(unregister_slave_cpu_notifier);
+
+static int slave_cpu_notify(unsigned long val, int cpu)
+{
+	int ret;
+
+	ret = __raw_notifier_call_chain(&slave_cpu_chain, val,
+					(void *)(long)cpu, -1, NULL);
+
+	return notifier_to_errno(ret);
+}
+#endif
+
 /*
  * Report back to the Boot Processor.
  * Running on AP.
@@ -307,6 +337,7 @@ notrace static void __cpuinit start_slave_cpu(void *unused)
 	 * most necessary things.
 	 */
 	cpu_init();
+	x86_cpuinit.early_percpu_clock_init();
 	preempt_disable();
 	smp_callin(0);
 
@@ -333,10 +364,13 @@ notrace static void __cpuinit start_slave_cpu(void *unused)
 	/* to prevent fake stack check failure */
 	boot_init_stack_canary();
 
+	x86_cpuinit.setup_percpu_clockev();
+
 	/* announce slave CPU started */
 	pr_info("Slave CPU %d is up\n", cpu);
 	per_cpu(cpu_state, cpu) = CPU_SLAVE_UP;
 	set_cpu_slave(cpu, true);
+	slave_cpu_notify(CPU_SLAVE_UP, cpu);
 	wmb();
 
 	/* wait for smp_call_function interrupt */
@@ -348,6 +382,7 @@ notrace static void __cpuinit start_slave_cpu(void *unused)
 	pr_info("Slave CPU %d is going down ...\n", cpu);
 	native_cpu_disable();
 	set_cpu_slave(cpu, false);
+	slave_cpu_notify(CPU_SLAVE_DYING, cpu);
 	native_play_dead();
 }
 #endif
@@ -978,6 +1013,7 @@ int slave_cpu_down(unsigned int cpu)
 		return -EBUSY;
 	}
 
+	slave_cpu_notify(CPU_SLAVE_DEAD, cpu);
 	return 0;
 }
 EXPORT_SYMBOL(slave_cpu_down);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ae34bf5..0d94142 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -48,6 +48,10 @@
 
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_SLAVE_CPU
+#include <asm/cpu.h>
+#endif
+
 #include <trace/events/timer.h>
 
 /*
@@ -1706,16 +1710,25 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
+#ifdef CONFIG_SLAVE_CPU
+	case CPU_SLAVE_UP:
+#endif
 		init_hrtimers_cpu(scpu);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
+#ifdef CONFIG_SLAVE_CPU
+	case CPU_SLAVE_DYING:
+#endif
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DYING, &scpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+#ifdef CONFIG_SLAVE_CPU
+	case CPU_SLAVE_DEAD:
+#endif
 	{
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
 		migrate_hrtimers(scpu);
@@ -1734,11 +1747,20 @@ static struct notifier_block __cpuinitdata hrtimers_nb = {
 	.notifier_call = hrtimer_cpu_notify,
 };
 
+#ifdef CONFIG_SLAVE_CPU
+static struct notifier_block __cpuinitdata hrtimers_slave_nb = {
+	.notifier_call = hrtimer_cpu_notify,
+};
+#endif
+
 void __init hrtimers_init(void)
 {
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
+#ifdef CONFIG_SLAVE_CPU
+	register_slave_cpu_notifier(&hrtimers_slave_nb);
+#endif
 #ifdef CONFIG_HIGH_RES_TIMERS
 	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
 #endif


