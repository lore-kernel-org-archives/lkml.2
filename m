Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0JNWb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:31:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33360 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0JNWb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:31:26 -0400
Date: Thu, 14 Oct 2010 18:31:25 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        kyle@mcmartin.ca
Subject: [PATCH 2/3] alpha: irq clean up
Message-ID: <20101014223125.GC8332@bombadil.infradead.org>
References: <20101014222805.GA8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014222805.GA8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop touching irq_desc[irq] directly, instead use accessor
functions provided. Use irq_has_action instead of directly
testing the irq_desc.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/alpha/kernel/irq.c           |   27 ++++++++++++++++++---------
 arch/alpha/kernel/irq_alpha.c     |   10 +++++++---
 arch/alpha/kernel/irq_i8259.c     |    3 ++-
 arch/alpha/kernel/irq_pyxis.c     |    5 +++--
 arch/alpha/kernel/irq_srm.c       |    4 ++--
 arch/alpha/kernel/sys_alcor.c     |    4 ++--
 arch/alpha/kernel/sys_cabriolet.c |    4 ++--
 arch/alpha/kernel/sys_dp264.c     |    6 +++---
 arch/alpha/kernel/sys_eb64p.c     |    4 ++--
 arch/alpha/kernel/sys_eiger.c     |    4 ++--
 arch/alpha/kernel/sys_jensen.c    |   10 ++--------
 arch/alpha/kernel/sys_marvel.c    |    6 +++---
 arch/alpha/kernel/sys_mikasa.c    |    4 ++--
 arch/alpha/kernel/sys_noritake.c  |    4 ++--
 arch/alpha/kernel/sys_rawhide.c   |    4 ++--
 arch/alpha/kernel/sys_rx164.c     |    4 ++--
 arch/alpha/kernel/sys_sable.c     |    4 ++--
 arch/alpha/kernel/sys_takara.c    |    4 ++--
 arch/alpha/kernel/sys_titan.c     |    4 ++--
 arch/alpha/kernel/sys_wildfire.c  |   10 +++++-----
 20 files changed, 67 insertions(+), 58 deletions(-)

diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index ecfa51e..cea8913 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -44,10 +44,11 @@ static char irq_user_affinity[NR_IRQS];
 
 int irq_select_affinity(unsigned int irq)
 {
+	struct irq_desc *desc = irq_to_desc[irq];
 	static int last_cpu;
 	int cpu = last_cpu + 1;
 
-	if (!irq_desc[irq].chip->set_affinity || irq_user_affinity[irq])
+	if (!desc || !get_irq_desc_chip(desc)->set_affinity || irq_user_affinity[irq])
 		return 1;
 
 	while (!cpu_possible(cpu) ||
@@ -55,8 +56,8 @@ int irq_select_affinity(unsigned int irq)
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
-	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
-	irq_desc[irq].chip->set_affinity(irq, cpumask_of(cpu));
+	cpumask_copy(desc->affinity, cpumask_of(cpu));
+	get_irq_desc_chip(desc)->set_affinity(irq, cpumask_of(cpu));
 	return 0;
 }
 #endif /* CONFIG_SMP */
@@ -67,6 +68,7 @@ show_interrupts(struct seq_file *p, void *v)
 	int j;
 	int irq = *(loff_t *) v;
 	struct irqaction * action;
+	struct irq_desc *desc;
 	unsigned long flags;
 
 #ifdef CONFIG_SMP
@@ -79,8 +81,13 @@ show_interrupts(struct seq_file *p, void *v)
 #endif
 
 	if (irq < ACTUAL_NR_IRQS) {
-		raw_spin_lock_irqsave(&irq_desc[irq].lock, flags);
-		action = irq_desc[irq].action;
+		desc = irq_to_desc(irq);
+
+		if (!desc)
+			return 0;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
 		if (!action) 
 			goto unlock;
 		seq_printf(p, "%3d: ", irq);
@@ -90,7 +97,7 @@ show_interrupts(struct seq_file *p, void *v)
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, j));
 #endif
-		seq_printf(p, " %14s", irq_desc[irq].chip->name);
+		seq_printf(p, " %14s", get_irq_desc_chip(desc)->name);
 		seq_printf(p, "  %c%s",
 			(action->flags & IRQF_DISABLED)?'+':' ',
 			action->name);
@@ -103,7 +110,7 @@ show_interrupts(struct seq_file *p, void *v)
 
 		seq_putc(p, '\n');
 unlock:
-		raw_spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (irq == ACTUAL_NR_IRQS) {
 #ifdef CONFIG_SMP
 		seq_puts(p, "IPI: ");
@@ -142,8 +149,10 @@ handle_irq(int irq)
 	 * handled by some other CPU. (or is disabled)
 	 */
 	static unsigned int illegal_count=0;
+	struct irq_desc *desc = irq_to_desc(irq);
 	
-	if ((unsigned) irq > ACTUAL_NR_IRQS && illegal_count < MAX_ILLEGAL_IRQS ) {
+	if (!desc || ((unsigned) irq > ACTUAL_NR_IRQS &&
+	    illegal_count < MAX_ILLEGAL_IRQS)) {
 		irq_err_count++;
 		illegal_count++;
 		printk(KERN_CRIT "device_interrupt: invalid interrupt %d\n",
@@ -159,7 +168,7 @@ handle_irq(int irq)
 	 * at IPL 0.
 	 */
 	local_irq_disable();
-	generic_handle_irq(irq);
+	generic_handle_irq_desc(irq, desc);
 	irq_exit();
 }
 
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index 5f77afb..001db4f 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -243,9 +243,13 @@ static struct irq_chip rtc_irq_type = {
 void __init
 init_rtc_irq(void)
 {
-	irq_desc[RTC_IRQ].status = IRQ_DISABLED;
-	irq_desc[RTC_IRQ].chip = &rtc_irq_type;
-	setup_irq(RTC_IRQ, &timer_irqaction);
+	struct irq_desc *desc = irq_to_desc(RTC_IRQ);
+
+	if (desc) {
+		desc->status |= IRQ_DISABLED;
+		set_irq_chip(RTC_IRQ, &rtc_irq_type);
+		setup_irq(RTC_IRQ, &timer_irqaction);
+	}
 }
 
 /* Dummy irqactions.  */
diff --git a/arch/alpha/kernel/irq_i8259.c b/arch/alpha/kernel/irq_i8259.c
index 39299fb..9e49395 100644
--- a/arch/alpha/kernel/irq_i8259.c
+++ b/arch/alpha/kernel/irq_i8259.c
@@ -79,7 +79,8 @@ i8259a_startup_irq(unsigned int irq)
 void
 i8259a_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	struct irq_desc *desc = irq_to_desc(irq);
+	if (desc || !(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		i8259a_enable_irq(irq);
 }
 
diff --git a/arch/alpha/kernel/irq_pyxis.c b/arch/alpha/kernel/irq_pyxis.c
index 4e1904c..9f603cf 100644
--- a/arch/alpha/kernel/irq_pyxis.c
+++ b/arch/alpha/kernel/irq_pyxis.c
@@ -50,7 +50,8 @@ pyxis_startup_irq(unsigned int irq)
 static void
 pyxis_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	struct irq_desc *desc = irq_to_desc(irq);
+	if (desc || !(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		pyxis_enable_irq(irq);
 }
 
@@ -120,7 +121,7 @@ init_pyxis_irqs(unsigned long ignore_mask)
 		if ((ignore_mask >> i) & 1)
 			continue;
 		set_irq_chip_and_handler(i, &pyxis_irq_type, alpha_do_IRQ);
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 	}
 
 	setup_irq(16+7, &isa_cascade_irqaction);
diff --git a/arch/alpha/kernel/irq_srm.c b/arch/alpha/kernel/irq_srm.c
index b337cfc..ea79006 100644
--- a/arch/alpha/kernel/irq_srm.c
+++ b/arch/alpha/kernel/irq_srm.c
@@ -43,7 +43,7 @@ srm_startup_irq(unsigned int irq)
 static void
 srm_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		srm_enable_irq(irq);
 }
 
@@ -68,8 +68,8 @@ init_srm_irqs(long max, unsigned long ignore_mask)
 	for (i = 16; i < max; ++i) {
 		if (i < 64 && ((ignore_mask >> i) & 1))
 			continue;
-		irq_desc[i].status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &srm_irq_type, alpha_do_IRQ);
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 	}
 }
 
diff --git a/arch/alpha/kernel/sys_alcor.c b/arch/alpha/kernel/sys_alcor.c
index d8c9183..138cc15 100644
--- a/arch/alpha/kernel/sys_alcor.c
+++ b/arch/alpha/kernel/sys_alcor.c
@@ -85,7 +85,7 @@ alcor_isa_mask_and_ack_irq(unsigned int irq)
 static void
 alcor_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		alcor_enable_irq(irq);
 }
 
@@ -142,8 +142,8 @@ alcor_init_irq(void)
 		   on while IRQ probing.  */
 		if (i >= 16+20 && i <= 16+30)
 			continue;
-		irq_desc[i].status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &alcor_irq_type, alpha_do_IRQ);
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 	}
 	i8259a_irq_type.ack = alcor_isa_mask_and_ack_irq;
 
diff --git a/arch/alpha/kernel/sys_cabriolet.c b/arch/alpha/kernel/sys_cabriolet.c
index ba38fcd..01a932b 100644
--- a/arch/alpha/kernel/sys_cabriolet.c
+++ b/arch/alpha/kernel/sys_cabriolet.c
@@ -67,7 +67,7 @@ cabriolet_startup_irq(unsigned int irq)
 static void
 cabriolet_end_irq(unsigned int irq)
 { 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		cabriolet_enable_irq(irq);
 }
 
@@ -124,7 +124,7 @@ common_init_irq(void (*srm_dev_int)(unsigned long v))
 		for (i = 16; i < 35; ++i) {
 			set_irq_chip_and_handler(i, &cabriolet_irq_type,
 				alpha_do_IRQ);
-			irq_desc[i].status |= IRQ_LEVEL;
+			irq_to_desc(i)->status |= IRQ_LEVEL;
 		}
 	}
 
diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index 147154d..34abb5c 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -125,7 +125,7 @@ dp264_startup_irq(unsigned int irq)
 static void
 dp264_end_irq(unsigned int irq)
 { 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		dp264_enable_irq(irq);
 }
 
@@ -157,7 +157,7 @@ clipper_startup_irq(unsigned int irq)
 static void
 clipper_end_irq(unsigned int irq)
 { 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		clipper_enable_irq(irq);
 }
 
@@ -302,7 +302,7 @@ init_tsunami_irqs(struct irq_chip * ops, int imin, int imax)
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, ops, alpha_do_IRQ);
 	}
 }
diff --git a/arch/alpha/kernel/sys_eb64p.c b/arch/alpha/kernel/sys_eb64p.c
index cb309a4..f7a957a 100644
--- a/arch/alpha/kernel/sys_eb64p.c
+++ b/arch/alpha/kernel/sys_eb64p.c
@@ -65,7 +65,7 @@ eb64p_startup_irq(unsigned int irq)
 static void
 eb64p_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		eb64p_enable_irq(irq);
 }
 
@@ -135,7 +135,7 @@ eb64p_init_irq(void)
 	init_i8259a_irqs();
 
 	for (i = 16; i < 32; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &eb64p_irq_type, alpha_do_IRQ);
 	}		
 
diff --git a/arch/alpha/kernel/sys_eiger.c b/arch/alpha/kernel/sys_eiger.c
index 16a5483..4f3596e 100644
--- a/arch/alpha/kernel/sys_eiger.c
+++ b/arch/alpha/kernel/sys_eiger.c
@@ -76,7 +76,7 @@ eiger_startup_irq(unsigned int irq)
 static void
 eiger_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		eiger_enable_irq(irq);
 }
 
@@ -153,7 +153,7 @@ eiger_init_irq(void)
 	init_i8259a_irqs();
 
 	for (i = 16; i < 128; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &eiger_irq_type, alpha_do_IRQ);
 	}
 }
diff --git a/arch/alpha/kernel/sys_jensen.c b/arch/alpha/kernel/sys_jensen.c
index 5b64f91..460d82b 100644
--- a/arch/alpha/kernel/sys_jensen.c
+++ b/arch/alpha/kernel/sys_jensen.c
@@ -68,13 +68,7 @@ jensen_local_startup(unsigned int irq)
 	/* the parport is really hw IRQ 1, silly Jensen.  */
 	if (irq == 7)
 		i8259a_startup_irq(1);
-	else
-		/*
-		 * For all true local interrupts, set the flag that prevents
-		 * the IPL from being dropped during handler processing.
-		 */
-		if (irq_desc[irq].action)
-			irq_desc[irq].action->flags |= IRQF_DISABLED;
+
 	return 0;
 }
 
@@ -158,7 +152,7 @@ jensen_device_interrupt(unsigned long vector)
 	}
 
 	/* If there is no handler yet... */
-	if (irq_desc[irq].action == NULL) {
+	if (!irq_has_action(irq)) {
 	    /* If it is a local interrupt that cannot be masked... */
 	    if (vector >= 0x900)
 	    {
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 0d0699e..a5095e0 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -153,7 +153,7 @@ io7_startup_irq(unsigned int irq)
 static void
 io7_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		io7_enable_irq(irq);
 }
 
@@ -304,7 +304,7 @@ init_io7_irqs(struct io7 *io7,
 
 	/* Set up the lsi irqs.  */
 	for (i = 0; i < 128; ++i) {
-		irq_desc[base + i].status |= IRQ_LEVEL;
+		irq_to_desc(base + i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(base + i, lsi_ops, alpha_do_IRQ);
 	}
 
@@ -318,7 +318,7 @@ init_io7_irqs(struct io7 *io7,
 
 	/* Set up the msi irqs.  */
 	for (i = 128; i < (128 + 512); ++i) {
-		irq_desc[base + i].status |= IRQ_LEVEL;
+		irq_to_desc(base + i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(base + i, msi_ops, alpha_do_IRQ);
 	}
 
diff --git a/arch/alpha/kernel/sys_mikasa.c b/arch/alpha/kernel/sys_mikasa.c
index a27bc56..37e5c65 100644
--- a/arch/alpha/kernel/sys_mikasa.c
+++ b/arch/alpha/kernel/sys_mikasa.c
@@ -64,7 +64,7 @@ mikasa_startup_irq(unsigned int irq)
 static void
 mikasa_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		mikasa_enable_irq(irq);
 }
 
@@ -115,7 +115,7 @@ mikasa_init_irq(void)
 	mikasa_update_irq_hw(0);
 
 	for (i = 16; i < 32; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &mikasa_irq_type, alpha_do_IRQ);
 	}
 
diff --git a/arch/alpha/kernel/sys_noritake.c b/arch/alpha/kernel/sys_noritake.c
index a4f07d6..004f8ec 100644
--- a/arch/alpha/kernel/sys_noritake.c
+++ b/arch/alpha/kernel/sys_noritake.c
@@ -69,7 +69,7 @@ noritake_startup_irq(unsigned int irq)
 static void
 noritake_end_irq(unsigned int irq)
 {
-        if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+        if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
                 noritake_enable_irq(irq);
 }
 
@@ -144,7 +144,7 @@ noritake_init_irq(void)
 	outw(0, 0x54c);
 
 	for (i = 16; i < 48; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &noritake_irq_type, alpha_do_IRQ);
 	}
 
diff --git a/arch/alpha/kernel/sys_rawhide.c b/arch/alpha/kernel/sys_rawhide.c
index a63da5c..60d152a 100644
--- a/arch/alpha/kernel/sys_rawhide.c
+++ b/arch/alpha/kernel/sys_rawhide.c
@@ -131,7 +131,7 @@ rawhide_startup_irq(unsigned int irq)
 static void
 rawhide_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		rawhide_enable_irq(irq);
 }
 
@@ -194,7 +194,7 @@ rawhide_init_irq(void)
 	}
 
 	for (i = 16; i < 128; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &rawhide_irq_type, alpha_do_IRQ);
 	}
 
diff --git a/arch/alpha/kernel/sys_rx164.c b/arch/alpha/kernel/sys_rx164.c
index 0465716..8a029a9 100644
--- a/arch/alpha/kernel/sys_rx164.c
+++ b/arch/alpha/kernel/sys_rx164.c
@@ -68,7 +68,7 @@ rx164_startup_irq(unsigned int irq)
 static void
 rx164_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		rx164_enable_irq(irq);
 }
 
@@ -116,7 +116,7 @@ rx164_init_irq(void)
 
 	rx164_update_irq_hw(0);
 	for (i = 16; i < 40; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &rx164_irq_type, alpha_do_IRQ);
 	}
 
diff --git a/arch/alpha/kernel/sys_sable.c b/arch/alpha/kernel/sys_sable.c
index 944b598..ed88315 100644
--- a/arch/alpha/kernel/sys_sable.c
+++ b/arch/alpha/kernel/sys_sable.c
@@ -484,7 +484,7 @@ sable_lynx_startup_irq(unsigned int irq)
 static void
 sable_lynx_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		sable_lynx_enable_irq(irq);
 }
 
@@ -535,7 +535,7 @@ sable_lynx_init_irq(int nr_of_irqs)
 	long i;
 
 	for (i = 0; i < nr_of_irqs; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &sable_lynx_irq_type,
 			alpha_do_IRQ);
 	}
diff --git a/arch/alpha/kernel/sys_takara.c b/arch/alpha/kernel/sys_takara.c
index 00df4e7..dc3c232 100644
--- a/arch/alpha/kernel/sys_takara.c
+++ b/arch/alpha/kernel/sys_takara.c
@@ -70,7 +70,7 @@ takara_startup_irq(unsigned int irq)
 static void
 takara_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		takara_enable_irq(irq);
 }
 
@@ -153,7 +153,7 @@ takara_init_irq(void)
 		takara_update_irq_hw(i, -1);
 
 	for (i = 16; i < 128; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, &takara_irq_type, alpha_do_IRQ);
 	}
 
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index ffa48e8..9870f3d 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -139,7 +139,7 @@ titan_startup_irq(unsigned int irq)
 static void
 titan_end_irq(unsigned int irq)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		titan_enable_irq(irq);
 }
 
@@ -189,7 +189,7 @@ init_titan_irqs(struct irq_chip * ops, int imin, int imax)
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
-		irq_desc[i].status |= IRQ_LEVEL;
+		irq_to_desc(i)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i, ops, alpha_do_IRQ);
 	}
 }
diff --git a/arch/alpha/kernel/sys_wildfire.c b/arch/alpha/kernel/sys_wildfire.c
index ea86103..f6004f0 100644
--- a/arch/alpha/kernel/sys_wildfire.c
+++ b/arch/alpha/kernel/sys_wildfire.c
@@ -150,10 +150,10 @@ static void
 wildfire_end_irq(unsigned int irq)
 { 
 #if 0
-	if (!irq_desc[irq].action)
+	if (!irq_has_action(irq))
 		printk("got irq %d\n", irq);
 #endif
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+	if (!(irq_to_desc(irq)->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		wildfire_enable_irq(irq);
 }
 
@@ -198,15 +198,15 @@ wildfire_init_irq_per_pca(int qbbno, int pcano)
 	for (i = 0; i < 16; ++i) {
 		if (i == 2)
 			continue;
-		irq_desc[i+irq_bias].status |= IRQ_LEVEL;
+		irq_to_desc(i+irq_bias)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i+irq_bias, &wildfire_irq_type,
 			alpha_do_IRQ);
 	}
 
-	irq_desc[36+irq_bias].status |= IRQ_LEVEL;
+	irq_to_desc(36+irq_bias)->status |= IRQ_LEVEL;
 	set_irq_chip_and_handler(36+irq_bias, &wildfire_irq_type, alpha_do_IRQ);
 	for (i = 40; i < 64; ++i) {
-		irq_desc[i+irq_bias].status |= IRQ_LEVEL;
+		irq_to_desc(i+irq_bias)->status |= IRQ_LEVEL;
 		set_irq_chip_and_handler(i+irq_bias, &wildfire_irq_type,
 			alpha_do_IRQ);
 	}
-- 
1.7.2.3

