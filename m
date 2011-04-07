Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1DGRgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:36:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59550 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab1DGRgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:36:22 -0400
Date: Thu, 7 Apr 2011 19:36:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110407173611.GA21550@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, hibernate: Initialize mmu_cr4_features during boot

Hans Rosenfeld (1):
      x86-32, fpu: Fix FPU exception handling on non-SSE systems

Tejun Heo (1):
      x86-32, NUMA: Fix ACPI NUMA init broken by recent x86-64 change

Thomas Gleixner (1):
      x86: visws: Fixup irq overhaul fallout


 arch/x86/include/asm/i387.h            |    2 +-
 arch/x86/kernel/setup.c                |    5 +++++
 arch/x86/mm/srat_32.c                  |    4 +++-
 arch/x86/platform/visws/visws_quirks.c |   20 ++++++--------------
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ef32890..c9e09ea 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -237,7 +237,7 @@ static inline void fpu_save_init(struct fpu *fpu)
 	} else if (use_fxsr()) {
 		fpu_fxsave(fpu);
 	} else {
-		asm volatile("fsave %[fx]; fwait"
+		asm volatile("fnsave %[fx]; fwait"
 			     : [fx] "=m" (fpu->state->fsave));
 		return;
 	}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5a0484a..4be9b39 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -976,6 +976,11 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
 
+	if (boot_cpu_data.cpuid_level >= 0) {
+		/* A CPU has %cr4 if and only if it has CPUID */
+		mmu_cr4_features = read_cr4();
+	}
+
 #ifdef CONFIG_X86_32
 	/* sync back kernel address range */
 	clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 48651c6..364f36b 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -211,10 +211,12 @@ int __init get_memcfg_from_srat(void)
 {
 	int i, j, nid;
 
-
 	if (srat_disabled())
 		goto out_fail;
 
+	if (acpi_numa_init() < 0)
+		goto out_fail;
+
 	if (num_memory_chunks == 0) {
 		printk(KERN_DEBUG
 			 "could not find any ACPI SRAT memory areas.\n");
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index fe4cf82..c7abf13 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -471,15 +471,7 @@ static unsigned int startup_piix4_master_irq(struct irq_data *data)
 {
 	legacy_pic->init(0);
 	enable_cobalt_irq(data);
-}
-
-static void end_piix4_master_irq(struct irq_data *data)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cobalt_lock, flags);
-	enable_cobalt_irq(data);
-	spin_unlock_irqrestore(&cobalt_lock, flags);
+	return 0;
 }
 
 static struct irq_chip piix4_master_irq_type = {
@@ -492,7 +484,7 @@ static void pii4_mask(struct irq_data *data) { }
 
 static struct irq_chip piix4_virtual_irq_type = {
 	.name		= "PIIX4-virtual",
-	.mask		= pii4_mask,
+	.irq_mask	= pii4_mask,
 };
 
 /*
@@ -580,9 +572,9 @@ static struct irqaction cascade_action = {
 
 static inline void set_piix4_virtual_irq_type(void)
 {
-	piix4_virtual_irq_type.enable =	i8259A_chip.unmask;
-	piix4_virtual_irq_type.disable = i8259A_chip.mask;
-	piix4_virtual_irq_type.unmask =	i8259A_chip.unmask;
+	piix4_virtual_irq_type.irq_enable = i8259A_chip.irq_unmask;
+	piix4_virtual_irq_type.irq_disable = i8259A_chip.irq_mask;
+	piix4_virtual_irq_type.irq_unmask = i8259A_chip.irq_unmask;
 }
 
 static void __init visws_pre_intr_init(void)
@@ -599,7 +591,7 @@ static void __init visws_pre_intr_init(void)
 		else if (i == CO_IRQ_IDE0)
 			chip = &cobalt_irq_type;
 		else if (i == CO_IRQ_IDE1)
-			>chip = &cobalt_irq_type;
+			chip = &cobalt_irq_type;
 		else if (i == CO_IRQ_8259)
 			chip = &piix4_master_irq_type;
 		else if (i < CO_IRQ_APIC0)
