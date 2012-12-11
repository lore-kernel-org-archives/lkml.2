Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2LKKnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 05:43:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44214 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2LKKnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 05:43:05 -0500
Date: Tue, 11 Dec 2012 11:42:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups changes for v3.8
Message-ID: <20121211104259.GA25758@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   HEAD: 28a793892296ca3367193c7a7de1714f80049fd0 x86: Fix the error of using "const" in gen-insn-attr-x86.awk

Small cleanups.

 Thanks,

	Ingo

------------------>
Cong Ding (1):
      x86: Fix the error of using "const" in gen-insn-attr-x86.awk

Daniel Lezcano (1):
      x86: Remove dead hlt_use_halt code

Suresh Siddha (1):
      x86, apic: Cleanup cfg->domain setup for legacy interrupts


 arch/x86/kernel/apic/io_apic.c       | 26 ++++++------------------
 arch/x86/kernel/process.c            | 39 +++++++++++++-----------------------
 arch/x86/tools/gen-insn-attr-x86.awk |  6 +++---
 3 files changed, 23 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c265593..0c1f366 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -234,11 +234,11 @@ int __init arch_early_irq_init(void)
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_KERNEL, node);
 		/*
 		 * For legacy IRQ's, start with assigning irq0 to irq15 to
-		 * IRQ0_VECTOR to IRQ15_VECTOR on cpu 0.
+		 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
 		 */
 		if (i < legacy_pic->nr_legacy_irqs) {
 			cfg[i].vector = IRQ0_VECTOR + i;
-			cpumask_set_cpu(0, cfg[i].domain);
+			cpumask_setall(cfg[i].domain);
 		}
 	}
 
@@ -1141,7 +1141,8 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 			 * allocation for the members that are not used anymore.
 			 */
 			cpumask_andnot(cfg->old_domain, cfg->domain, tmp_mask);
-			cfg->move_in_progress = 1;
+			cfg->move_in_progress =
+			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
 			cpumask_and(cfg->domain, cfg->domain, tmp_mask);
 			break;
 		}
@@ -1172,8 +1173,9 @@ next:
 		current_vector = vector;
 		current_offset = offset;
 		if (cfg->vector) {
-			cfg->move_in_progress = 1;
 			cpumask_copy(cfg->old_domain, cfg->domain);
+			cfg->move_in_progress =
+			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
 		}
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
@@ -1241,12 +1243,6 @@ void __setup_vector_irq(int cpu)
 		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
-		/*
-		 * If it is a legacy IRQ handled by the legacy PIC, this cpu
-		 * will be part of the irq_cfg's domain.
-		 */
-		if (irq < legacy_pic->nr_legacy_irqs && !IO_APIC_IRQ(irq))
-			cpumask_set_cpu(cpu, cfg->domain);
 
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			continue;
@@ -1356,16 +1352,6 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	if (!IO_APIC_IRQ(irq))
 		return;
 
-	/*
-	 * For legacy irqs, cfg->domain starts with cpu 0. Now that IO-APIC
-	 * can handle this irq and the apic driver is finialized at this point,
-	 * update the cfg->domain.
-	 */
-	if (irq < legacy_pic->nr_legacy_irqs &&
-	    cpumask_equal(cfg->domain, cpumask_of(0)))
-		apic->vector_allocation_domain(0, cfg->domain,
-					       apic->target_cpus());
-
 	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
 		return;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b644e1c..2f99e31 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -306,11 +306,6 @@ void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 #endif
 
-static inline int hlt_use_halt(void)
-{
-	return 1;
-}
-
 #ifndef CONFIG_SMP
 static inline void play_dead(void)
 {
@@ -410,28 +405,22 @@ void cpu_idle(void)
  */
 void default_idle(void)
 {
-	if (hlt_use_halt()) {
-		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle_rcuidle(1, smp_processor_id());
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
+	trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
+	trace_cpu_idle_rcuidle(1, smp_processor_id());
+	current_thread_info()->status &= ~TS_POLLING;
+	/*
+	 * TS_POLLING-cleared state must be visible before we
+	 * test NEED_RESCHED:
+	 */
+	smp_mb();
 
-		if (!need_resched())
-			safe_halt();	/* enables interrupts racelessly */
-		else
-			local_irq_enable();
-		current_thread_info()->status |= TS_POLLING;
-		trace_power_end_rcuidle(smp_processor_id());
-		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
-	} else {
+	if (!need_resched())
+		safe_halt();	/* enables interrupts racelessly */
+	else
 		local_irq_enable();
-		/* loop is done by the caller */
-		cpu_relax();
-	}
+	current_thread_info()->status |= TS_POLLING;
+	trace_power_end_rcuidle(smp_processor_id());
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 #ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(default_idle);
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index ddcf39b..e6773dc 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -356,7 +356,7 @@ END {
 		exit 1
 	# print escape opcode map's array
 	print "/* Escape opcode map array */"
-	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]" \
+	print "const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX + 1]" \
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < geid; i++)
 		for (j = 0; j < max_lprefix; j++)
@@ -365,7 +365,7 @@ END {
 	print "};\n"
 	# print group opcode map's array
 	print "/* Group opcode map array */"
-	print "const insn_attr_t const *inat_group_tables[INAT_GRP_MAX + 1]"\
+	print "const insn_attr_t * const inat_group_tables[INAT_GRP_MAX + 1]"\
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < ggid; i++)
 		for (j = 0; j < max_lprefix; j++)
@@ -374,7 +374,7 @@ END {
 	print "};\n"
 	# print AVX opcode map's array
 	print "/* AVX opcode map array */"
-	print "const insn_attr_t const *inat_avx_tables[X86_VEX_M_MAX + 1]"\
+	print "const insn_attr_t * const inat_avx_tables[X86_VEX_M_MAX + 1]"\
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < gaid; i++)
 		for (j = 0; j < max_lprefix; j++)
