Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1LLD3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:29:33 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:3284 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1LLD3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:29:30 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Bob Liu <lliubbo@gmail.com>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH 04/11] blackfin: smp: cleanup smp code
Date: Mon, 12 Dec 2011 11:28:26 +0800
Message-ID: <1323660513-9620-4-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move idle task point to percpu blackfin_cpudata and add smp_timer_broadcast
interface.
enable SUPPLE_1_WAKEUP and add BFIN_IPI_TIMER ipi support.

Signed-off-by: Steven Miao <realmz6@gmail.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 arch/blackfin/include/asm/cpu.h             |    3 ++
 arch/blackfin/include/asm/smp.h             |    5 ++-
 arch/blackfin/kernel/time-ts.c              |   26 +++++++++++++-
 arch/blackfin/mach-bf561/include/mach/pll.h |    4 ++-
 arch/blackfin/mach-bf561/smp.c              |    2 +-
 arch/blackfin/mach-common/smp.c             |   53 +++++++++++++++++++++------
 6 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/arch/blackfin/include/asm/cpu.h b/arch/blackfin/include/asm/cpu.h
index 0504378..e349631 100644
--- a/arch/blackfin/include/asm/cpu.h
+++ b/arch/blackfin/include/asm/cpu.h
@@ -14,6 +14,9 @@ struct blackfin_cpudata {
 	struct cpu cpu;
 	unsigned int imemctl;
 	unsigned int dmemctl;
+#ifdef CONFIG_SMP
+	struct task_struct *idle;
+#endif
 };
 
 DECLARE_PER_CPU(struct blackfin_cpudata, cpu_data);
diff --git a/arch/blackfin/include/asm/smp.h b/arch/blackfin/include/asm/smp.h
index af6c0aa..dc3d144 100644
--- a/arch/blackfin/include/asm/smp.h
+++ b/arch/blackfin/include/asm/smp.h
@@ -37,7 +37,7 @@ extern unsigned long dcache_invld_count[NR_CPUS];
 #endif
 
 void smp_icache_flush_range_others(unsigned long start,
-				   unsigned long end);
+					unsigned long end);
 #ifdef CONFIG_HOTPLUG_CPU
 void coreb_die(void);
 void cpu_die(void);
@@ -46,4 +46,7 @@ int __cpu_disable(void);
 int __cpu_die(unsigned int cpu);
 #endif
 
+void smp_timer_broadcast(const struct cpumask *mask);
+
+
 #endif /* !__ASM_BLACKFIN_SMP_H */
diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index 1bcf3a3..6efd944 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -219,7 +219,7 @@ static void __init bfin_gptmr0_clockevent_init(struct clock_event_device *evt)
 
 #if defined(CONFIG_TICKSOURCE_CORETMR)
 /* per-cpu local core timer */
-static DEFINE_PER_CPU(struct clock_event_device, coretmr_events);
+DEFINE_PER_CPU(struct clock_event_device, coretmr_events);
 
 static int bfin_coretmr_set_next_event(unsigned long cycles,
 				struct clock_event_device *evt)
@@ -281,6 +281,25 @@ void bfin_coretmr_init(void)
 #ifdef CONFIG_CORE_TIMER_IRQ_L1
 __attribute__((l1_text))
 #endif
+
+static void broadcast_timer_set_mode(enum clock_event_mode mode,
+		struct clock_event_device *evt)
+{
+}
+
+static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
+{
+	evt->name       = "dummy_timer";
+	evt->features   = CLOCK_EVT_FEAT_ONESHOT |
+		CLOCK_EVT_FEAT_PERIODIC |
+		CLOCK_EVT_FEAT_DUMMY;
+	evt->rating     = 400;
+	evt->mult       = 1;
+	evt->set_mode   = broadcast_timer_set_mode;
+
+	clockevents_register_device(evt);
+}
+
 irqreturn_t bfin_coretmr_interrupt(int irq, void *dev_id)
 {
 	int cpu = smp_processor_id();
@@ -306,6 +325,11 @@ void bfin_coretmr_clockevent_init(void)
 	unsigned int cpu = smp_processor_id();
 	struct clock_event_device *evt = &per_cpu(coretmr_events, cpu);
 
+#ifdef CONFIG_SMP
+	evt->broadcast = smp_timer_broadcast;
+#endif
+
+
 	evt->name = "bfin_core_timer";
 	evt->rating = 350;
 	evt->irq = -1;
diff --git a/arch/blackfin/mach-bf561/include/mach/pll.h b/arch/blackfin/mach-bf561/include/mach/pll.h
index 7977db2..00bdace 100644
--- a/arch/blackfin/mach-bf561/include/mach/pll.h
+++ b/arch/blackfin/mach-bf561/include/mach/pll.h
@@ -16,6 +16,7 @@
 #include <mach/irq.h>
 
 #define SUPPLE_0_WAKEUP ((IRQ_SUPPLE_0 - (IRQ_CORETMR + 1)) % 32)
+#define SUPPLE_1_WAKEUP ((IRQ_SUPPLE_1 - (IRQ_CORETMR + 1)) % 32)
 
 static inline void
 bfin_iwr_restore(unsigned long iwr0, unsigned long iwr1, unsigned long iwr2)
@@ -42,7 +43,8 @@ bfin_iwr_save(unsigned long niwr0, unsigned long niwr1, unsigned long niwr2,
 static inline void
 bfin_iwr_set_sup0(unsigned long *iwr0, unsigned long *iwr1, unsigned long *iwr2)
 {
-	bfin_iwr_save(0, IWR_ENABLE(SUPPLE_0_WAKEUP), 0, iwr0, iwr1, iwr2);
+	bfin_iwr_save(0, IWR_ENABLE(SUPPLE_0_WAKEUP) |
+			IWR_ENABLE(SUPPLE_1_WAKEUP), 0, iwr0, iwr1, iwr2);
 }
 
 #endif
diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
index b2a6b77..ab1c617 100644
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -84,7 +84,7 @@ int __cpuinit platform_boot_secondary(unsigned int cpu, struct task_struct *idle
 
 	if ((bfin_read_SYSCR() & COREB_SRAM_INIT) == 0) {
 		/* CoreB already running, sending ipi to wakeup it */
-		platform_send_ipi_cpu(cpu, IRQ_SUPPLE_0);
+		smp_send_reschedule(cpu);
 	} else {
 		/* Kick CoreB, which should start execution from CORE_SRAM_BASE. */
 		bfin_write_SYSCR(bfin_read_SYSCR() & ~COREB_SRAM_INIT);
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 0784a52..d346405 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/cache.h>
+#include <linux/clockchips.h>
 #include <linux/profile.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
@@ -47,9 +48,10 @@ unsigned long blackfin_iflush_l1_entry[NR_CPUS];
 
 struct blackfin_initial_pda __cpuinitdata initial_pda_coreb;
 
-#define BFIN_IPI_RESCHEDULE   0
-#define BFIN_IPI_CALL_FUNC    1
-#define BFIN_IPI_CPU_STOP     2
+#define BFIN_IPI_TIMER	      0
+#define BFIN_IPI_RESCHEDULE   1
+#define BFIN_IPI_CALL_FUNC    2
+#define BFIN_IPI_CPU_STOP     3
 
 struct blackfin_flush_data {
 	unsigned long start;
@@ -160,6 +162,14 @@ static irqreturn_t ipi_handler_int0(int irq, void *dev_instance)
 	return IRQ_HANDLED;
 }
 
+DECLARE_PER_CPU(struct clock_event_device, coretmr_events);
+void ipi_timer(void)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *evt = &per_cpu(coretmr_events, cpu);
+	evt->event_handler(evt);
+}
+
 static irqreturn_t ipi_handler_int1(int irq, void *dev_instance)
 {
 	struct ipi_message *msg;
@@ -176,6 +186,9 @@ static irqreturn_t ipi_handler_int1(int irq, void *dev_instance)
 	while (msg_queue->count) {
 		msg = &msg_queue->ipi_message[msg_queue->head];
 		switch (msg->type) {
+		case BFIN_IPI_TIMER:
+			ipi_timer();
+			break;
 		case BFIN_IPI_RESCHEDULE:
 			scheduler_ipi();
 			break;
@@ -297,8 +310,6 @@ void smp_send_reschedule(int cpu)
 {
 	cpumask_t callmap;
 	/* simply trigger an ipi */
-	if (cpu_is_offline(cpu))
-		return;
 
 	cpumask_clear(&callmap);
 	cpumask_set_cpu(cpu, &callmap);
@@ -308,6 +319,16 @@ void smp_send_reschedule(int cpu)
 	return;
 }
 
+void smp_send_msg(const struct cpumask *mask, unsigned long type)
+{
+	smp_send_message(*mask, type, NULL, NULL, 0);
+}
+
+void smp_timer_broadcast(const struct cpumask *mask)
+{
+	smp_send_msg(mask, BFIN_IPI_TIMER);
+}
+
 void smp_send_stop(void)
 {
 	cpumask_t callmap;
@@ -326,17 +347,24 @@ void smp_send_stop(void)
 int __cpuinit __cpu_up(unsigned int cpu)
 {
 	int ret;
-	static struct task_struct *idle;
+	struct blackfin_cpudata *ci = &per_cpu(cpu_data, cpu);
+	struct task_struct *idle = ci->idle;
 
-	if (idle)
+	if (idle) {
 		free_task(idle);
-
-	idle = fork_idle(cpu);
-	if (IS_ERR(idle)) {
-		printk(KERN_ERR "CPU%u: fork() failed\n", cpu);
-		return PTR_ERR(idle);
+		idle = NULL;
 	}
 
+	if (!idle) {
+		idle = fork_idle(cpu);
+		if (IS_ERR(idle)) {
+			printk(KERN_ERR "CPU%u: fork() failed\n", cpu);
+			return PTR_ERR(idle);
+		}
+		ci->idle = idle;
+	} else {
+		init_idle(idle, cpu);
+	}
 	secondary_stack = task_stack_page(idle) + THREAD_SIZE;
 
 	ret = platform_boot_secondary(cpu, idle);
@@ -411,6 +439,7 @@ void __cpuinit secondary_start_kernel(void)
 
 	bfin_setup_caches(cpu);
 
+	notify_cpu_starting(cpu);
 	/*
 	 * Calibrate loops per jiffy value.
 	 * IRQs need to be enabled here - D-cache can be invalidated
-- 
1.7.0.4


