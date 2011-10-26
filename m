Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab1JZPKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:10:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38452 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933076Ab1JZPKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:10:41 -0400
Date: Wed, 26 Oct 2011 17:08:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.2
Message-ID: <20111026150856.GA26208@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      apic, i386/bigsmp: Fix false warnings regarding logical APIC ID mismatches

Yinghai Lu (6):
      x86, ioapic: Pass struct irq_attr * to setup_ioapic_irq()
      x86, ioapic: Split up setup_ioapic_entry()
      x86, ioapic: Print out irte with right ioapic index
      x86, ioapic: Factor out print_IO_APIC() to only print one io apic
      x86, ioapic: Clean up ioapic/apic_id usage
      x86/irq: Standardize on CONFIG_SPARSE_IRQ=y


 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/apic.h        |    2 +-
 arch/x86/include/asm/irq_vectors.h |   12 +-
 arch/x86/kernel/apic/bigsmp_32.c   |   20 ++-
 arch/x86/kernel/apic/io_apic.c     |  394 ++++++++++++++++++------------------
 arch/x86/kernel/apic/probe_32.c    |   10 +-
 6 files changed, 219 insertions(+), 220 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..fcd34c3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -64,6 +64,7 @@ config X86
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select SPARSE_IRQ
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 7b3ca83..9b7273c 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -495,7 +495,7 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
-extern struct apic *generic_bigsmp_probe(void);
+extern void generic_bigsmp_probe(void);
 
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 7e50f06..4b44487 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -160,19 +160,11 @@ static inline int invalid_vm86_irq(int irq)
 #define IO_APIC_VECTOR_LIMIT		( 32 * MAX_IO_APICS )
 
 #ifdef CONFIG_X86_IO_APIC
-# ifdef CONFIG_SPARSE_IRQ
-#  define CPU_VECTOR_LIMIT		(64 * NR_CPUS)
-#  define NR_IRQS					\
+# define CPU_VECTOR_LIMIT		(64 * NR_CPUS)
+# define NR_IRQS					\
 	(CPU_VECTOR_LIMIT > IO_APIC_VECTOR_LIMIT ?	\
 		(NR_VECTORS + CPU_VECTOR_LIMIT)  :	\
 		(NR_VECTORS + IO_APIC_VECTOR_LIMIT))
-# else
-#  define CPU_VECTOR_LIMIT		(32 * NR_CPUS)
-#  define NR_IRQS					\
-	(CPU_VECTOR_LIMIT < IO_APIC_VECTOR_LIMIT ?	\
-		(NR_VECTORS + CPU_VECTOR_LIMIT)  :	\
-		(NR_VECTORS + IO_APIC_VECTOR_LIMIT))
-# endif
 #else /* !CONFIG_X86_IO_APIC: */
 # define NR_IRQS			NR_IRQS_LEGACY
 #endif
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index efd737e..521bead 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -255,12 +255,24 @@ static struct apic apic_bigsmp = {
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
 };
 
-struct apic * __init generic_bigsmp_probe(void)
+void __init generic_bigsmp_probe(void)
 {
-	if (probe_bigsmp())
-		return &apic_bigsmp;
+	unsigned int cpu;
 
-	return NULL;
+	if (!probe_bigsmp())
+		return;
+
+	apic = &apic_bigsmp;
+
+	for_each_possible_cpu(cpu) {
+		if (early_per_cpu(x86_cpu_to_logical_apicid,
+				  cpu) == BAD_APICID)
+			continue;
+		early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+			bigsmp_early_logical_apicid(cpu);
+	}
+
+	pr_info("Overriding APIC driver with %s\n", apic_bigsmp.name);
 }
 
 apic_driver(apic_bigsmp);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8eb863e..05a30c1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -92,21 +92,21 @@ static struct ioapic {
 	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } ioapics[MAX_IO_APICS];
 
-#define mpc_ioapic_ver(id)		ioapics[id].mp_config.apicver
+#define mpc_ioapic_ver(ioapic_idx)	ioapics[ioapic_idx].mp_config.apicver
 
-int mpc_ioapic_id(int id)
+int mpc_ioapic_id(int ioapic_idx)
 {
-	return ioapics[id].mp_config.apicid;
+	return ioapics[ioapic_idx].mp_config.apicid;
 }
 
-unsigned int mpc_ioapic_addr(int id)
+unsigned int mpc_ioapic_addr(int ioapic_idx)
 {
-	return ioapics[id].mp_config.apicaddr;
+	return ioapics[ioapic_idx].mp_config.apicaddr;
 }
 
-struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int id)
+struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic_idx)
 {
-	return &ioapics[id].gsi_config;
+	return &ioapics[ioapic_idx].gsi_config;
 }
 
 int nr_ioapics;
@@ -186,11 +186,7 @@ static struct irq_pin_list *alloc_irq_pin_list(int node)
 
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
-#ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg irq_cfgx[NR_IRQS_LEGACY];
-#else
-static struct irq_cfg irq_cfgx[NR_IRQS];
-#endif
 
 int __init arch_early_irq_init(void)
 {
@@ -234,7 +230,6 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
-#ifdef CONFIG_SPARSE_IRQ
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return irq_get_chip_data(irq);
@@ -269,22 +264,6 @@ static void free_irq_cfg(unsigned int at, struct irq_cfg *cfg)
 	kfree(cfg);
 }
 
-#else
-
-struct irq_cfg *irq_cfg(unsigned int irq)
-{
-	return irq < nr_irqs ? irq_cfgx + irq : NULL;
-}
-
-static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
-{
-	return irq_cfgx + irq;
-}
-
-static inline void free_irq_cfg(unsigned int at, struct irq_cfg *cfg) { }
-
-#endif
-
 static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 {
 	int res = irq_alloc_desc_at(at, node);
@@ -712,13 +691,13 @@ int restore_ioapic_entries(void)
 /*
  * Find the IRQ entry number of a certain pin.
  */
-static int find_irq_entry(int apic, int pin, int type)
+static int find_irq_entry(int ioapic_idx, int pin, int type)
 {
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++)
 		if (mp_irqs[i].irqtype == type &&
-		    (mp_irqs[i].dstapic == mpc_ioapic_id(apic) ||
+		    (mp_irqs[i].dstapic == mpc_ioapic_id(ioapic_idx) ||
 		     mp_irqs[i].dstapic == MP_APIC_ALL) &&
 		    mp_irqs[i].dstirq == pin)
 			return i;
@@ -757,12 +736,13 @@ static int __init find_isa_irq_apic(int irq, int type)
 		    (mp_irqs[i].srcbusirq == irq))
 			break;
 	}
+
 	if (i < mp_irq_entries) {
-		int apic;
-		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic)
-				return apic;
-		}
+		int ioapic_idx;
+
+		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic)
+				return ioapic_idx;
 	}
 
 	return -1;
@@ -977,7 +957,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 				struct io_apic_irq_attr *irq_attr)
 {
-	int apic, i, best_guess = -1;
+	int ioapic_idx, i, best_guess = -1;
 
 	apic_printk(APIC_DEBUG,
 		    "querying PCI -> IRQ mapping bus:%d, slot:%d, pin:%d.\n",
@@ -990,8 +970,8 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 	for (i = 0; i < mp_irq_entries; i++) {
 		int lbus = mp_irqs[i].srcbus;
 
-		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic ||
+		for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+			if (mpc_ioapic_id(ioapic_idx) == mp_irqs[i].dstapic ||
 			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
 
@@ -999,13 +979,13 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 		    !mp_irqs[i].irqtype &&
 		    (bus == lbus) &&
 		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
+			int irq = pin_2_irq(i, ioapic_idx, mp_irqs[i].dstirq);
 
-			if (!(apic || IO_APIC_IRQ(irq)))
+			if (!(ioapic_idx || IO_APIC_IRQ(irq)))
 				continue;
 
 			if (pin == (mp_irqs[i].srcbusirq & 3)) {
-				set_io_apic_irq_attr(irq_attr, apic,
+				set_io_apic_irq_attr(irq_attr, ioapic_idx,
 						     mp_irqs[i].dstirq,
 						     irq_trigger(i),
 						     irq_polarity(i));
@@ -1016,7 +996,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 			 * best-guess fuzzy result for broken mptables.
 			 */
 			if (best_guess < 0) {
-				set_io_apic_irq_attr(irq_attr, apic,
+				set_io_apic_irq_attr(irq_attr, ioapic_idx,
 						     mp_irqs[i].dstirq,
 						     irq_trigger(i),
 						     irq_polarity(i));
@@ -1255,77 +1235,100 @@ static void ioapic_register_intr(unsigned int irq, struct irq_cfg *cfg,
 				      fasteoi ? "fasteoi" : "edge");
 }
 
-static int setup_ioapic_entry(int apic_id, int irq,
-			      struct IO_APIC_route_entry *entry,
-			      unsigned int destination, int trigger,
-			      int polarity, int vector, int pin)
+
+static int setup_ir_ioapic_entry(int irq,
+			      struct IR_IO_APIC_route_entry *entry,
+			      unsigned int destination, int vector,
+			      struct io_apic_irq_attr *attr)
 {
-	/*
-	 * add it to the IO-APIC irq-routing table:
-	 */
-	memset(entry,0,sizeof(*entry));
+	int index;
+	struct irte irte;
+	int ioapic_id = mpc_ioapic_id(attr->ioapic);
+	struct intel_iommu *iommu = map_ioapic_to_ir(ioapic_id);
 
-	if (intr_remapping_enabled) {
-		struct intel_iommu *iommu = map_ioapic_to_ir(apic_id);
-		struct irte irte;
-		struct IR_IO_APIC_route_entry *ir_entry =
-			(struct IR_IO_APIC_route_entry *) entry;
-		int index;
+	if (!iommu) {
+		pr_warn("No mapping iommu for ioapic %d\n", ioapic_id);
+		return -ENODEV;
+	}
 
-		if (!iommu)
-			panic("No mapping iommu for ioapic %d\n", apic_id);
+	index = alloc_irte(iommu, irq, 1);
+	if (index < 0) {
+		pr_warn("Failed to allocate IRTE for ioapic %d\n", ioapic_id);
+		return -ENOMEM;
+	}
 
-		index = alloc_irte(iommu, irq, 1);
-		if (index < 0)
-			panic("Failed to allocate IRTE for ioapic %d\n", apic_id);
+	prepare_irte(&irte, vector, destination);
 
-		prepare_irte(&irte, vector, destination);
+	/* Set source-id of interrupt request */
+	set_ioapic_sid(&irte, ioapic_id);
 
-		/* Set source-id of interrupt request */
-		set_ioapic_sid(&irte, apic_id);
+	modify_irte(irq, &irte);
 
-		modify_irte(irq, &irte);
+	apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
+		"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
+		"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
+		"Avail:%X Vector:%02X Dest:%08X "
+		"SID:%04X SQ:%X SVT:%X)\n",
+		attr->ioapic, irte.present, irte.fpd, irte.dst_mode,
+		irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
+		irte.avail, irte.vector, irte.dest_id,
+		irte.sid, irte.sq, irte.svt);
+
+	memset(entry, 0, sizeof(*entry));
+
+	entry->index2	= (index >> 15) & 0x1;
+	entry->zero	= 0;
+	entry->format	= 1;
+	entry->index	= (index & 0x7fff);
+	/*
+	 * IO-APIC RTE will be configured with virtual vector.
+	 * irq handler will do the explicit EOI to the io-apic.
+	 */
+	entry->vector	= attr->ioapic_pin;
+	entry->mask	= 0;			/* enable IRQ */
+	entry->trigger	= attr->trigger;
+	entry->polarity	= attr->polarity;
 
-		ir_entry->index2 = (index >> 15) & 0x1;
-		ir_entry->zero = 0;
-		ir_entry->format = 1;
-		ir_entry->index = (index & 0x7fff);
-		/*
-		 * IO-APIC RTE will be configured with virtual vector.
-		 * irq handler will do the explicit EOI to the io-apic.
-		 */
-		ir_entry->vector = pin;
-
-		apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
-			"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
-			"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
-			"Avail:%X Vector:%02X Dest:%08X "
-			"SID:%04X SQ:%X SVT:%X)\n",
-			apic_id, irte.present, irte.fpd, irte.dst_mode,
-			irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
-			irte.avail, irte.vector, irte.dest_id,
-			irte.sid, irte.sq, irte.svt);
-	} else {
-		entry->delivery_mode = apic->irq_delivery_mode;
-		entry->dest_mode = apic->irq_dest_mode;
-		entry->dest = destination;
-		entry->vector = vector;
-	}
+	/* Mask level triggered irqs.
+	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
+	 */
+	if (attr->trigger)
+		entry->mask = 1;
+
+	return 0;
+}
 
-	entry->mask = 0;				/* enable IRQ */
-	entry->trigger = trigger;
-	entry->polarity = polarity;
+static int setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
+			       unsigned int destination, int vector,
+			       struct io_apic_irq_attr *attr)
+{
+	if (intr_remapping_enabled)
+		return setup_ir_ioapic_entry(irq,
+			 (struct IR_IO_APIC_route_entry *)entry,
+			 destination, vector, attr);
 
-	/* Mask level triggered irqs.
+	memset(entry, 0, sizeof(*entry));
+
+	entry->delivery_mode = apic->irq_delivery_mode;
+	entry->dest_mode     = apic->irq_dest_mode;
+	entry->dest	     = destination;
+	entry->vector	     = vector;
+	entry->mask	     = 0;			/* enable IRQ */
+	entry->trigger	     = attr->trigger;
+	entry->polarity	     = attr->polarity;
+
+	/*
+	 * Mask level triggered irqs.
 	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
 	 */
-	if (trigger)
+	if (attr->trigger)
 		entry->mask = 1;
+
 	return 0;
 }
 
-static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
-			     struct irq_cfg *cfg, int trigger, int polarity)
+static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
+				struct io_apic_irq_attr *attr)
 {
 	struct IO_APIC_route_entry entry;
 	unsigned int dest;
@@ -1348,49 +1351,48 @@ static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i Dest:%d)\n",
-		    apic_id, mpc_ioapic_id(apic_id), pin, cfg->vector,
-		    irq, trigger, polarity, dest);
-
+		    attr->ioapic, mpc_ioapic_id(attr->ioapic), attr->ioapic_pin,
+		    cfg->vector, irq, attr->trigger, attr->polarity, dest);
 
-	if (setup_ioapic_entry(mpc_ioapic_id(apic_id), irq, &entry,
-			       dest, trigger, polarity, cfg->vector, pin)) {
-		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mpc_ioapic_id(apic_id), pin);
+	if (setup_ioapic_entry(irq, &entry, dest, cfg->vector, attr)) {
+		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
+			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
 		__clear_irq_vector(irq, cfg);
+
 		return;
 	}
 
-	ioapic_register_intr(irq, cfg, trigger);
+	ioapic_register_intr(irq, cfg, attr->trigger);
 	if (irq < legacy_pic->nr_legacy_irqs)
 		legacy_pic->mask(irq);
 
-	ioapic_write_entry(apic_id, pin, entry);
+	ioapic_write_entry(attr->ioapic, attr->ioapic_pin, entry);
 }
 
-static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
+static bool __init io_apic_pin_not_connected(int idx, int ioapic_idx, int pin)
 {
 	if (idx != -1)
 		return false;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
-		    mpc_ioapic_id(apic_id), pin);
+		    mpc_ioapic_id(ioapic_idx), pin);
 	return true;
 }
 
-static void __init __io_apic_setup_irqs(unsigned int apic_id)
+static void __init __io_apic_setup_irqs(unsigned int ioapic_idx)
 {
 	int idx, node = cpu_to_node(0);
 	struct io_apic_irq_attr attr;
 	unsigned int pin, irq;
 
-	for (pin = 0; pin < ioapics[apic_id].nr_registers; pin++) {
-		idx = find_irq_entry(apic_id, pin, mp_INT);
-		if (io_apic_pin_not_connected(idx, apic_id, pin))
+	for (pin = 0; pin < ioapics[ioapic_idx].nr_registers; pin++) {
+		idx = find_irq_entry(ioapic_idx, pin, mp_INT);
+		if (io_apic_pin_not_connected(idx, ioapic_idx, pin))
 			continue;
 
-		irq = pin_2_irq(idx, apic_id, pin);
+		irq = pin_2_irq(idx, ioapic_idx, pin);
 
-		if ((apic_id > 0) && (irq > 16))
+		if ((ioapic_idx > 0) && (irq > 16))
 			continue;
 
 		/*
@@ -1398,10 +1400,10 @@ static void __init __io_apic_setup_irqs(unsigned int apic_id)
 		 * installed and if it returns 1:
 		 */
 		if (apic->multi_timer_check &&
-		    apic->multi_timer_check(apic_id, irq))
+		    apic->multi_timer_check(ioapic_idx, irq))
 			continue;
 
-		set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
+		set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
 				     irq_polarity(idx));
 
 		io_apic_setup_irq_pin(irq, node, &attr);
@@ -1410,12 +1412,12 @@ static void __init __io_apic_setup_irqs(unsigned int apic_id)
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	unsigned int apic_id;
+	unsigned int ioapic_idx;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++)
-		__io_apic_setup_irqs(apic_id);
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		__io_apic_setup_irqs(ioapic_idx);
 }
 
 /*
@@ -1425,28 +1427,28 @@ static void __init setup_IO_APIC_irqs(void)
  */
 void setup_IO_APIC_irq_extra(u32 gsi)
 {
-	int apic_id = 0, pin, idx, irq, node = cpu_to_node(0);
+	int ioapic_idx = 0, pin, idx, irq, node = cpu_to_node(0);
 	struct io_apic_irq_attr attr;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
 	 */
-	apic_id = mp_find_ioapic(gsi);
-	if (apic_id < 0)
+	ioapic_idx = mp_find_ioapic(gsi);
+	if (ioapic_idx < 0)
 		return;
 
-	pin = mp_find_ioapic_pin(apic_id, gsi);
-	idx = find_irq_entry(apic_id, pin, mp_INT);
+	pin = mp_find_ioapic_pin(ioapic_idx, gsi);
+	idx = find_irq_entry(ioapic_idx, pin, mp_INT);
 	if (idx == -1)
 		return;
 
-	irq = pin_2_irq(idx, apic_id, pin);
+	irq = pin_2_irq(idx, ioapic_idx, pin);
 
 	/* Only handle the non legacy irqs on secondary ioapics */
-	if (apic_id == 0 || irq < NR_IRQS_LEGACY)
+	if (ioapic_idx == 0 || irq < NR_IRQS_LEGACY)
 		return;
 
-	set_io_apic_irq_attr(&attr, apic_id, pin, irq_trigger(idx),
+	set_io_apic_irq_attr(&attr, ioapic_idx, pin, irq_trigger(idx),
 			     irq_polarity(idx));
 
 	io_apic_setup_irq_pin_once(irq, node, &attr);
@@ -1455,8 +1457,8 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 /*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
-static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
-					int vector)
+static void __init setup_timer_IRQ0_pin(unsigned int ioapic_idx,
+					 unsigned int pin, int vector)
 {
 	struct IO_APIC_route_entry entry;
 
@@ -1487,45 +1489,29 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
 	/*
 	 * Add it to the IO-APIC irq-routing table:
 	 */
-	ioapic_write_entry(apic_id, pin, entry);
+	ioapic_write_entry(ioapic_idx, pin, entry);
 }
 
-
-__apicdebuginit(void) print_IO_APIC(void)
+__apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 {
-	int apic, i;
+	int i;
 	union IO_APIC_reg_00 reg_00;
 	union IO_APIC_reg_01 reg_01;
 	union IO_APIC_reg_02 reg_02;
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
-	struct irq_cfg *cfg;
-	unsigned int irq;
-
-	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
-	for (i = 0; i < nr_ioapics; i++)
-		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mpc_ioapic_id(i), ioapics[i].nr_registers);
-
-	/*
-	 * We are a bit conservative about what we expect.  We have to
-	 * know about every hardware change ASAP.
-	 */
-	printk(KERN_INFO "testing the IO APIC.......................\n");
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(apic, 0);
-	reg_01.raw = io_apic_read(apic, 1);
+	reg_00.raw = io_apic_read(ioapic_idx, 0);
+	reg_01.raw = io_apic_read(ioapic_idx, 1);
 	if (reg_01.bits.version >= 0x10)
-		reg_02.raw = io_apic_read(apic, 2);
+		reg_02.raw = io_apic_read(ioapic_idx, 2);
 	if (reg_01.bits.version >= 0x20)
-		reg_03.raw = io_apic_read(apic, 3);
+		reg_03.raw = io_apic_read(ioapic_idx, 3);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mpc_ioapic_id(apic));
+	printk(KERN_DEBUG "IO APIC #%d......\n", mpc_ioapic_id(ioapic_idx));
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
@@ -1575,7 +1561,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 			struct IO_APIC_route_entry entry;
 			struct IR_IO_APIC_route_entry *ir_entry;
 
-			entry = ioapic_read_entry(apic, i);
+			entry = ioapic_read_entry(ioapic_idx, i);
 			ir_entry = (struct IR_IO_APIC_route_entry *) &entry;
 			printk(KERN_DEBUG " %02x %04X ",
 				i,
@@ -1596,7 +1582,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 		} else {
 			struct IO_APIC_route_entry entry;
 
-			entry = ioapic_read_entry(apic, i);
+			entry = ioapic_read_entry(ioapic_idx, i);
 			printk(KERN_DEBUG " %02x %02X  ",
 				i,
 				entry.dest
@@ -1614,7 +1600,28 @@ __apicdebuginit(void) print_IO_APIC(void)
 			);
 		}
 	}
-	}
+}
+
+__apicdebuginit(void) print_IO_APICs(void)
+{
+	int ioapic_idx;
+	struct irq_cfg *cfg;
+	unsigned int irq;
+
+	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
+		       mpc_ioapic_id(ioapic_idx),
+		       ioapics[ioapic_idx].nr_registers);
+
+	/*
+	 * We are a bit conservative about what we expect.  We have to
+	 * know about every hardware change ASAP.
+	 */
+	printk(KERN_INFO "testing the IO APIC.......................\n");
+
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
+		print_IO_APIC(ioapic_idx);
 
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
 	for_each_active_irq(irq) {
@@ -1633,8 +1640,6 @@ __apicdebuginit(void) print_IO_APIC(void)
 	}
 
 	printk(KERN_INFO ".................................... done.\n");
-
-	return;
 }
 
 __apicdebuginit(void) print_APIC_field(int base)
@@ -1828,7 +1833,7 @@ __apicdebuginit(int) print_ICs(void)
 		return 0;
 
 	print_local_APICs(show_lapic);
-	print_IO_APIC();
+	print_IO_APICs();
 
 	return 0;
 }
@@ -1953,7 +1958,7 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 {
 	union IO_APIC_reg_00 reg_00;
 	physid_mask_t phys_id_present_map;
-	int apic_id;
+	int ioapic_idx;
 	int i;
 	unsigned char old_id;
 	unsigned long flags;
@@ -1967,21 +1972,20 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
 	 */
-	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
-
+	for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++) {
 		/* Read the register 0 value */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic_id, 0);
+		reg_00.raw = io_apic_read(ioapic_idx, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
-		old_id = mpc_ioapic_id(apic_id);
+		old_id = mpc_ioapic_id(ioapic_idx);
 
-		if (mpc_ioapic_id(apic_id) >= get_physical_broadcast()) {
+		if (mpc_ioapic_id(ioapic_idx) >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic_id, mpc_ioapic_id(apic_id));
+				ioapic_idx, mpc_ioapic_id(ioapic_idx));
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			ioapics[apic_id].mp_config.apicid = reg_00.bits.ID;
+			ioapics[ioapic_idx].mp_config.apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -1990,9 +1994,9 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (apic->check_apicid_used(&phys_id_present_map,
-					    mpc_ioapic_id(apic_id))) {
+					    mpc_ioapic_id(ioapic_idx))) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic_id, mpc_ioapic_id(apic_id));
+				ioapic_idx, mpc_ioapic_id(ioapic_idx));
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -2001,14 +2005,14 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			ioapics[apic_id].mp_config.apicid = i;
+			ioapics[ioapic_idx].mp_config.apicid = i;
 		} else {
 			physid_mask_t tmp;
-			apic->apicid_to_cpu_present(mpc_ioapic_id(apic_id),
+			apic->apicid_to_cpu_present(mpc_ioapic_id(ioapic_idx),
 						    &tmp);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mpc_ioapic_id(apic_id));
+					mpc_ioapic_id(ioapic_idx));
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -2016,35 +2020,35 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mpc_ioapic_id(apic_id))
+		if (old_id != mpc_ioapic_id(ioapic_idx))
 			for (i = 0; i < mp_irq_entries; i++)
 				if (mp_irqs[i].dstapic == old_id)
 					mp_irqs[i].dstapic
-						= mpc_ioapic_id(apic_id);
+						= mpc_ioapic_id(ioapic_idx);
 
 		/*
 		 * Update the ID register according to the right value
 		 * from the MPC table if they are different.
 		 */
-		if (mpc_ioapic_id(apic_id) == reg_00.bits.ID)
+		if (mpc_ioapic_id(ioapic_idx) == reg_00.bits.ID)
 			continue;
 
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mpc_ioapic_id(apic_id));
+			mpc_ioapic_id(ioapic_idx));
 
-		reg_00.bits.ID = mpc_ioapic_id(apic_id);
+		reg_00.bits.ID = mpc_ioapic_id(ioapic_idx);
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		io_apic_write(apic_id, 0, reg_00.raw);
+		io_apic_write(ioapic_idx, 0, reg_00.raw);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		/*
 		 * Sanity check
 		 */
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic_id, 0);
+		reg_00.raw = io_apic_read(ioapic_idx, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mpc_ioapic_id(apic_id))
+		if (reg_00.bits.ID != mpc_ioapic_id(ioapic_idx))
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
@@ -2944,27 +2948,26 @@ static int __init io_apic_bug_finalize(void)
 
 late_initcall(io_apic_bug_finalize);
 
-static void resume_ioapic_id(int ioapic_id)
+static void resume_ioapic_id(int ioapic_idx)
 {
 	unsigned long flags;
 	union IO_APIC_reg_00 reg_00;
 
-
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	reg_00.raw = io_apic_read(ioapic_id, 0);
-	if (reg_00.bits.ID != mpc_ioapic_id(ioapic_id)) {
-		reg_00.bits.ID = mpc_ioapic_id(ioapic_id);
-		io_apic_write(ioapic_id, 0, reg_00.raw);
+	reg_00.raw = io_apic_read(ioapic_idx, 0);
+	if (reg_00.bits.ID != mpc_ioapic_id(ioapic_idx)) {
+		reg_00.bits.ID = mpc_ioapic_id(ioapic_idx);
+		io_apic_write(ioapic_idx, 0, reg_00.raw);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void ioapic_resume(void)
 {
-	int ioapic_id;
+	int ioapic_idx;
 
-	for (ioapic_id = nr_ioapics - 1; ioapic_id >= 0; ioapic_id--)
-		resume_ioapic_id(ioapic_id);
+	for (ioapic_idx = nr_ioapics - 1; ioapic_idx >= 0; ioapic_idx--)
+		resume_ioapic_id(ioapic_idx);
 
 	restore_ioapic_entries();
 }
@@ -3566,26 +3569,25 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 		return -EINVAL;
 	ret = __add_pin_to_irq_node(cfg, node, attr->ioapic, attr->ioapic_pin);
 	if (!ret)
-		setup_ioapic_irq(attr->ioapic, attr->ioapic_pin, irq, cfg,
-				 attr->trigger, attr->polarity);
+		setup_ioapic_irq(irq, cfg, attr);
 	return ret;
 }
 
 int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 			       struct io_apic_irq_attr *attr)
 {
-	unsigned int id = attr->ioapic, pin = attr->ioapic_pin;
+	unsigned int ioapic_idx = attr->ioapic, pin = attr->ioapic_pin;
 	int ret;
 
 	/* Avoid redundant programming */
-	if (test_bit(pin, ioapics[id].pin_programmed)) {
+	if (test_bit(pin, ioapics[ioapic_idx].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
-			 mpc_ioapic_id(id), pin);
+			 mpc_ioapic_id(ioapic_idx), pin);
 		return 0;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
 	if (!ret)
-		set_bit(pin, ioapics[id].pin_programmed);
+		set_bit(pin, ioapics[ioapic_idx].pin_programmed);
 	return ret;
 }
 
@@ -3621,7 +3623,6 @@ int get_nr_irqs_gsi(void)
 	return nr_irqs_gsi;
 }
 
-#ifdef CONFIG_SPARSE_IRQ
 int __init arch_probe_nr_irqs(void)
 {
 	int nr;
@@ -3641,7 +3642,6 @@ int __init arch_probe_nr_irqs(void)
 
 	return NR_IRQS_LEGACY;
 }
-#endif
 
 int io_apic_set_pci_routing(struct device *dev, int irq,
 			    struct io_apic_irq_attr *irq_attr)
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index b5254ad..0787bb3 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -200,14 +200,8 @@ void __init default_setup_apic_routing(void)
 	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
 	 */
 
-	if (!cmdline_apic && apic == &apic_default) {
-		struct apic *bigsmp = generic_bigsmp_probe();
-		if (bigsmp) {
-			apic = bigsmp;
-			printk(KERN_INFO "Overriding APIC driver with %s\n",
-			       apic->name);
-		}
-	}
+	if (!cmdline_apic && apic == &apic_default)
+		generic_bigsmp_probe();
 #endif
 
 	if (apic->setup_apic_routing)
