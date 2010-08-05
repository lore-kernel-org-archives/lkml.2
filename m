Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135Ab0HELKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:10:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759007Ab0HELJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:09:59 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] apic: adding apic_send_IPI_* methods for apic's IPI callbacks
Date: Thu,  5 Aug 2010 13:09:37 +0200
Message-Id: <1281006578-5073-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1281006578-5073-1-git-send-email-jolsa@redhat.com>
References: <1281006578-5073-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding global methods apic_send_IPI_* for following APIC callbacks:

        void (*send_IPI_mask)(const struct cpumask *mask, int vector);
        void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
                                         int vector);
        void (*send_IPI_allbutself)(int vector);
        void (*send_IPI_all)(int vector);
        void (*send_IPI_self)(int vector);

apic_send_IPI_* calls will be used to generate the trace event.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/include/asm/apic.h             |   16 +++++++++++++++-
 arch/x86/include/asm/ipi.h              |    4 ++--
 arch/x86/kernel/apic/apic.c             |   27 ++++++++++++++++++++++++++-
 arch/x86/kernel/apic/apic_flat_64.c     |    4 ++--
 arch/x86/kernel/apic/hw_nmi.c           |    2 +-
 arch/x86/kernel/apic/io_apic.c          |    9 +++++----
 arch/x86/kernel/apic/nmi.c              |    2 +-
 arch/x86/kernel/apic/probe_64.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c        |    2 +-
 arch/x86/kernel/cpu/perf_event.c        |    2 +-
 arch/x86/kernel/kgdb.c                  |    2 +-
 arch/x86/kernel/reboot.c                |    2 +-
 arch/x86/kernel/smp.c                   |   12 ++++++------
 arch/x86/mm/tlb.c                       |    2 +-
 15 files changed, 65 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1fa03e0..d8da79f 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -404,6 +404,12 @@ static inline u32 safe_apic_wait_icr_idle(void)
 	return apic->safe_wait_icr_idle();
 }
 
+void apic_send_IPI_mask(const struct cpumask *mask, int vector);
+void apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+void apic_send_IPI_allbutself(int vector);
+void apic_send_IPI_all(int vector);
+void apic_send_IPI_self(int vector);
+
 #else /* CONFIG_X86_LOCAL_APIC */
 
 static inline u32 apic_read(u32 reg) { return 0; }
@@ -412,6 +418,14 @@ static inline u64 apic_icr_read(void) { return 0; }
 static inline void apic_icr_write(u32 low, u32 high) { }
 static inline void apic_wait_icr_idle(void) { }
 static inline u32 safe_apic_wait_icr_idle(void) { return 0; }
+static inline void apic_send_IPI_mask(const struct cpumask *mask,
+				      int vector) { }
+static inline void apic_send_IPI_mask_allbutself(const struct cpumask *mask,
+						 int vector) { }
+static inline void apic_send_IPI_allbutself(int vector) { }
+static inline void apic_send_IPI_all(int vector) { }
+static inline void apic_send_IPI_self(int vector) { }
+
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
@@ -449,7 +463,7 @@ extern struct apic apic_x2apic_cluster;
 extern struct apic apic_x2apic_phys;
 extern int default_acpi_madt_oem_check(char *, char *);
 
-extern void apic_send_IPI_self(int vector);
+extern void apic_send_IPI_self_default(int vector);
 
 extern struct apic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
diff --git a/arch/x86/include/asm/ipi.h b/arch/x86/include/asm/ipi.h
index 0b72282..19717cb 100644
--- a/arch/x86/include/asm/ipi.h
+++ b/arch/x86/include/asm/ipi.h
@@ -136,7 +136,7 @@ extern int no_broadcast;
 static inline void __default_local_send_IPI_allbutself(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR)
-		apic->send_IPI_mask_allbutself(cpu_online_mask, vector);
+		apic_send_IPI_mask_allbutself(cpu_online_mask, vector);
 	else
 		__default_send_IPI_shortcut(APIC_DEST_ALLBUT, vector, apic->dest_logical);
 }
@@ -144,7 +144,7 @@ static inline void __default_local_send_IPI_allbutself(int vector)
 static inline void __default_local_send_IPI_all(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR)
-		apic->send_IPI_mask(cpu_online_mask, vector);
+		apic_send_IPI_mask(cpu_online_mask, vector);
 	else
 		__default_send_IPI_shortcut(APIC_DEST_ALLINC, vector, apic->dest_logical);
 }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a96489e..2ab2f26 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -455,7 +455,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 static void lapic_timer_broadcast(const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
-	apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+	apic_send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
 #endif
 }
 
@@ -2332,3 +2332,28 @@ static int __init lapic_insert_resource(void)
  * that is using request_resource
  */
 late_initcall(lapic_insert_resource);
+
+void apic_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	apic->send_IPI_mask(mask, vector);
+}
+
+void apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
+{
+	apic->send_IPI_mask_allbutself(mask, vector);
+}
+
+void apic_send_IPI_allbutself(int vector)
+{
+	apic->send_IPI_allbutself(vector);
+}
+
+void apic_send_IPI_all(int vector)
+{
+	apic->send_IPI_all(vector);
+}
+
+void apic_send_IPI_self(int vector)
+{
+	apic->send_IPI_self(vector);
+}
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 09d3b17..47df43f 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -206,7 +206,7 @@ struct apic apic_flat =  {
 	.send_IPI_mask_allbutself	= flat_send_IPI_mask_allbutself,
 	.send_IPI_allbutself		= flat_send_IPI_allbutself,
 	.send_IPI_all			= flat_send_IPI_all,
-	.send_IPI_self			= apic_send_IPI_self,
+	.send_IPI_self			= apic_send_IPI_self_default,
 
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
@@ -358,7 +358,7 @@ struct apic apic_physflat =  {
 	.send_IPI_mask_allbutself	= physflat_send_IPI_mask_allbutself,
 	.send_IPI_allbutself		= physflat_send_IPI_allbutself,
 	.send_IPI_all			= physflat_send_IPI_all,
-	.send_IPI_self			= apic_send_IPI_self,
+	.send_IPI_self			= apic_send_IPI_self_default,
 
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index cefd694..03eed85 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -33,7 +33,7 @@ void arch_trigger_all_cpu_backtrace(void)
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
 	printk(KERN_INFO "sending NMI to all CPUs:\n");
-	apic->send_IPI_all(NMI_VECTOR);
+	apic_send_IPI_all(NMI_VECTOR);
 
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e41ed24..6589f84 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2258,7 +2258,7 @@ static int ioapic_retrigger_irq(unsigned int irq)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	apic->send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
+	apic_send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
@@ -2281,10 +2281,11 @@ void send_cleanup_vector(struct irq_cfg *cfg)
 	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
 		unsigned int i;
 		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
+			apic_send_IPI_mask(cpumask_of(i),
+					   IRQ_MOVE_CLEANUP_VECTOR);
 	} else {
 		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
-		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		apic_send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		free_cpumask_var(cleanup_mask);
 	}
 	cfg->move_in_progress = 0;
@@ -2493,7 +2494,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		 * to myself.
 		 */
 		if (irr  & (1 << (vector % 32))) {
-			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
+			apic_send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
 			goto unlock;
 		}
 		__get_cpu_var(vector_irq)[vector] = -1;
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index a43f71c..b28bf24 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -556,7 +556,7 @@ void arch_trigger_all_cpu_backtrace(void)
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
 	printk(KERN_INFO "sending NMI to all CPUs:\n");
-	apic->send_IPI_all(NMI_VECTOR);
+	apic_send_IPI_all(NMI_VECTOR);
 
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 83e9be4..7328526 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -87,7 +87,7 @@ void __init default_setup_apic_routing(void)
 
 /* Same for both flat and physical. */
 
-void apic_send_IPI_self(int vector)
+void apic_send_IPI_self_default(int vector)
 {
 	__default_send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index e7dbde7..3a59bbb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -158,7 +158,7 @@ static void raise_mce(struct mce *m)
 				cpumask_clear_cpu(cpu, mce_inject_cpumask);
 		}
 		if (!cpumask_empty(mce_inject_cpumask))
-			apic->send_IPI_mask(mce_inject_cpumask, NMI_VECTOR);
+			apic_send_IPI_mask(mce_inject_cpumask, NMI_VECTOR);
 		start = jiffies;
 		while (!cpumask_empty(mce_inject_cpumask)) {
 			if (!time_before(jiffies, start + 2*HZ)) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7a6f81e..5a00034 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -513,7 +513,7 @@ static void mce_report_event(struct pt_regs *regs)
 	 * through the APIC to instead do the notification
 	 * after interrupts are reenabled again.
 	 */
-	apic->send_IPI_self(MCE_SELF_VECTOR);
+	apic_send_IPI_self(MCE_SELF_VECTOR);
 
 	/*
 	 * Wait for idle afterwards again so that we don't leave the
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2da20f..b2971ad 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1185,7 +1185,7 @@ void set_perf_event_pending(void)
 	if (!x86_pmu.apic || !x86_pmu_initialized())
 		return;
 
-	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
+	apic_send_IPI_self(LOCAL_PENDING_VECTOR);
 #endif
 }
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 01ab17a..a7a2660 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -432,7 +432,7 @@ void kgdb_disable_hw_debug(struct pt_regs *regs)
  */
 void kgdb_roundup_cpus(unsigned long flags)
 {
-	apic->send_IPI_allbutself(APIC_DM_NMI);
+	apic_send_IPI_allbutself(APIC_DM_NMI);
 }
 #endif
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e3af342..669df18 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -779,7 +779,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 
 static void smp_send_nmi_allbutself(void)
 {
-	apic->send_IPI_allbutself(NMI_VECTOR);
+	apic_send_IPI_allbutself(NMI_VECTOR);
 }
 
 static struct notifier_block crash_nmi_nb = {
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index d801210..4dfda13 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -118,12 +118,12 @@ static void native_smp_send_reschedule(int cpu)
 		WARN_ON(1);
 		return;
 	}
-	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
+	apic_send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
-	apic->send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
+	apic_send_IPI_mask(cpumask_of(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
 void native_send_call_func_ipi(const struct cpumask *mask)
@@ -131,7 +131,7 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 	cpumask_var_t allbutself;
 
 	if (!alloc_cpumask_var(&allbutself, GFP_ATOMIC)) {
-		apic->send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+		apic_send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 		return;
 	}
 
@@ -140,9 +140,9 @@ void native_send_call_func_ipi(const struct cpumask *mask)
 
 	if (cpumask_equal(mask, allbutself) &&
 	    cpumask_equal(cpu_online_mask, cpu_callout_mask))
-		apic->send_IPI_allbutself(CALL_FUNCTION_VECTOR);
+		apic_send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
-		apic->send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+		apic_send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 
 	free_cpumask_var(allbutself);
 }
@@ -177,7 +177,7 @@ static void native_smp_send_stop(void)
 	 * currently)
 	 */
 	if (num_online_cpus() > 1) {
-		apic->send_IPI_allbutself(REBOOT_VECTOR);
+		apic_send_IPI_allbutself(REBOOT_VECTOR);
 
 		/* Don't wait longer than a second */
 		wait = USEC_PER_SEC;
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index c03f14a..368bd20 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -190,7 +190,7 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 		 * We have to send the IPI only to
 		 * CPUs affected.
 		 */
-		apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
+		apic_send_IPI_mask(to_cpumask(f->flush_cpumask),
 			      INVALIDATE_TLB_VECTOR_START + sender);
 
 		while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
-- 
1.7.2

