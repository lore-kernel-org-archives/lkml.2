Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab0JUOOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:14:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33929 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab0JUOOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:14:51 -0400
Date: Thu, 21 Oct 2010 16:14:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/x2apic for v2.6.37
Message-ID: <20101021141440.GA10210@elte.hu>
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

Please pull the x86-x2apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-x2apic-for-linus

 Thanks,

	Ingo

------------------>
Suresh Siddha (3):
      x86, intr-remap: Set redirection hint in the IRTE
      x86, intr-remap: Remove IRTE setup duplicate code
      x86, x2apic: Simplify apic init in SMP and UP builds


 arch/x86/include/asm/irq_remapping.h |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c          |    3 ---
 arch/x86/kernel/apic/io_apic.c       |   25 ++-----------------------
 arch/x86/kernel/apic/probe_64.c      |    3 +++
 arch/x86/kernel/smpboot.c            |    4 ++--
 5 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index f275e22..8d84150 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -3,4 +3,31 @@
 
 #define IRTE_DEST(dest) ((x2apic_mode) ? dest : dest << 8)
 
+#ifdef CONFIG_INTR_REMAP
+static inline void prepare_irte(struct irte *irte, int vector,
+			        unsigned int dest)
+{
+	memset(irte, 0, sizeof(*irte));
+
+	irte->present = 1;
+	irte->dst_mode = apic->irq_dest_mode;
+	/*
+	 * Trigger mode in the IRTE will always be edge, and for IO-APIC, the
+	 * actual level or edge trigger will be setup in the IO-APIC
+	 * RTE. This will help simplify level triggered irq migration.
+	 * For more details, see the comments (in io_apic.c) explainig IO-APIC
+	 * irq migration in the presence of interrupt-remapping.
+	*/
+	irte->trigger_mode = 0;
+	irte->dlvry_mode = apic->irq_delivery_mode;
+	irte->vector = vector;
+	irte->dest_id = IRTE_DEST(dest);
+	irte->redir_hint = 1;
+}
+#else
+static void prepare_irte(struct irte *irte, int vector, unsigned int dest)
+{
+}
+#endif
+
 #endif	/* _ASM_X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e3b534c..8cf86fb 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1665,10 +1665,7 @@ int __init APIC_init_uniprocessor(void)
 	}
 #endif
 
-#ifndef CONFIG_SMP
-	enable_IR_x2apic();
 	default_setup_apic_routing();
-#endif
 
 	verify_local_APIC();
 	connect_bsp_APIC();
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f1efeba..e8c95a2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1377,21 +1377,7 @@ int setup_ioapic_entry(int apic_id, int irq,
 		if (index < 0)
 			panic("Failed to allocate IRTE for ioapic %d\n", apic_id);
 
-		memset(&irte, 0, sizeof(irte));
-
-		irte.present = 1;
-		irte.dst_mode = apic->irq_dest_mode;
-		/*
-		 * Trigger mode in the IRTE will always be edge, and the
-		 * actual level or edge trigger will be setup in the IO-APIC
-		 * RTE. This will help simplify level triggered irq migration.
-		 * For more details, see the comments above explainig IO-APIC
-		 * irq migration in the presence of interrupt-remapping.
-		 */
-		irte.trigger_mode = 0;
-		irte.dlvry_mode = apic->irq_delivery_mode;
-		irte.vector = vector;
-		irte.dest_id = IRTE_DEST(destination);
+		prepare_irte(&irte, vector, destination);
 
 		/* Set source-id of interrupt request */
 		set_ioapic_sid(&irte, apic_id);
@@ -3335,14 +3321,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 		ir_index = map_irq_to_irte_handle(irq, &sub_handle);
 		BUG_ON(ir_index == -1);
 
-		memset (&irte, 0, sizeof(irte));
-
-		irte.present = 1;
-		irte.dst_mode = apic->irq_dest_mode;
-		irte.trigger_mode = 0; /* edge */
-		irte.dlvry_mode = apic->irq_delivery_mode;
-		irte.vector = cfg->vector;
-		irte.dest_id = IRTE_DEST(dest);
+		prepare_irte(&irte, cfg->vector, dest);
 
 		/* Set source-id of interrupt request */
 		if (pdev)
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 83e9be4..f9e4e6a 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -54,6 +54,9 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
  */
 void __init default_setup_apic_routing(void)
 {
+
+	enable_IR_x2apic();
+
 #ifdef CONFIG_X86_X2APIC
 	if (x2apic_mode
 #ifdef CONFIG_X86_UV
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8b3bfc4..87a8c6b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1109,8 +1109,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	set_cpu_sibling_map(0);
 
-	enable_IR_x2apic();
-	default_setup_apic_routing();
 
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
@@ -1118,6 +1116,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		goto out;
 	}
 
+	default_setup_apic_routing();
+
 	preempt_disable();
 	if (read_apic_id() != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
