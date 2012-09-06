Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2IFLa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:30:58 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59333 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2IFL3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:29:55 -0400
X-AuditID: b753bd60-987dbba000000c4c-40-504888ad7788
X-AuditID: b753bd60-987dbba000000c4c-40-504888ad7788
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 03/21] x86: Support hrtimer on slave CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:27:34 +0900
Message-ID: <20120906112734.13320.81814.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
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

 arch/x86/include/asm/cpu.h |   11 -----------
 arch/x86/kernel/smpboot.c  |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/cpu.h        |   22 ++++++++++++++++++++++
 kernel/hrtimer.c           |   14 ++++++++++++++
 4 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index b7ace52..4564c8e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -30,17 +30,6 @@ extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
 #endif
 
-#ifdef CONFIG_SLAVE_CPU
-#define CPU_SLAVE_UP_PREPARE	0xff00
-#define CPU_SLAVE_UP		0xff01
-#define CPU_SLAVE_DEAD		0xff02
-
-extern int slave_cpu_up(unsigned int cpu);
-extern int slave_cpu_down(unsigned int cpu);
-extern void slave_cpu_call_function(unsigned int cpu,
-				    void (*f)(void *), void *arg);
-#endif
-
 DECLARE_PER_CPU(int, cpu_state);
 
 int mwait_usable(const struct cpuinfo_x86 *);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b9e1297..e8cfe377 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -127,6 +127,36 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
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
 
@@ -333,10 +364,14 @@ notrace static void __cpuinit start_slave_cpu(void *unused)
 	/* to prevent fake stack check failure */
 	boot_init_stack_canary();
 
+	x86_cpuinit.setup_percpu_clockev();
+	tick_nohz_idle_enter();
+
 	/* announce slave CPU started */
 	pr_info("Slave CPU %d is up\n", cpu);
 	__this_cpu_write(cpu_state, CPU_SLAVE_UP);
 	set_cpu_slave(cpu, true);
+	slave_cpu_notify(CPU_SLAVE_UP, cpu);
 	wmb();
 
 	/* wait for slave_cpu_call_function or slave_cpu_down */
@@ -363,6 +398,7 @@ notrace static void __cpuinit start_slave_cpu(void *unused)
 	local_irq_disable();
 	native_cpu_disable();
 	set_cpu_slave(cpu, false);
+	slave_cpu_notify(CPU_SLAVE_DYING, cpu);
 	native_play_dead();
 }
 #endif
@@ -995,6 +1031,7 @@ int slave_cpu_down(unsigned int cpu)
 		return -EBUSY;
 	}
 
+	slave_cpu_notify(CPU_SLAVE_DEAD, cpu);
 	return 0;
 }
 EXPORT_SYMBOL(slave_cpu_down);
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 8395ac9..f1aa3cc 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -221,4 +221,26 @@ static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
 #endif /* !CONFIG_PM_SLEEP_SMP */
 
+#ifdef CONFIG_SLAVE_CPU
+int register_slave_cpu_notifier(struct notifier_block *nb);
+void unregister_slave_cpu_notifier(struct notifier_block *nb);
+
+/* CPU notifier constants for slave processors */
+#define CPU_SLAVE_UP_PREPARE	0xff00
+#define CPU_SLAVE_UP		0xff01
+#define CPU_SLAVE_DEAD		0xff02
+#define CPU_SLAVE_DYING		0xff03
+
+extern int slave_cpu_up(unsigned int cpu);
+extern int slave_cpu_down(unsigned int cpu);
+extern void slave_cpu_call_function(unsigned int cpu,
+				    void (*f)(void *), void *arg);
+#else
+static inline int register_slave_cpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline void unregister_slave_cpu_notifier(struct notifier_block *nb) {}
+#endif
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..e899a2c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1727,16 +1727,25 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 
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
@@ -1755,11 +1764,16 @@ static struct notifier_block __cpuinitdata hrtimers_nb = {
 	.notifier_call = hrtimer_cpu_notify,
 };
 
+static struct notifier_block __cpuinitdata hrtimers_slave_nb = {
+	.notifier_call = hrtimer_cpu_notify,
+};
+
 void __init hrtimers_init(void)
 {
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
+	register_slave_cpu_notifier(&hrtimers_slave_nb);
 #ifdef CONFIG_HIGH_RES_TIMERS
 	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
 #endif


