Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab0I3XTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:19:50 -0400
Received: from www.tglx.de ([62.245.132.106]:43580 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab0I3XSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:18:41 -0400
Message-Id: <20100930221742.015002441@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:17:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 36/47] x86: ioapic: Cleanup sparse irq code
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-ioapic-cleanup-sparse.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch over to the new allocator and remove all the magic which was
caused by the unability to destroy irq descriptors. Get rid of the
create_irq_nr() loop for sparse and non sparse irq.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |  297 ++++++++++++++---------------------------
 1 file changed, 105 insertions(+), 192 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -174,164 +174,102 @@ int __init arch_early_irq_init(void)
 	return 0;
 }
 
+static struct irq_cfg *get_irq_cfg_at(unsigned int at, int node);
+
 #ifdef CONFIG_SPARSE_IRQ
 struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return get_irq_chip_data(irq);
 }
 
-static struct irq_cfg *get_one_free_irq_cfg(int node)
+static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
 {
 	struct irq_cfg *cfg;
 
 	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
-	if (cfg) {
-		if (!zalloc_cpumask_var_node(&cfg->domain, GFP_ATOMIC, node)) {
-			kfree(cfg);
-			cfg = NULL;
-		} else if (!zalloc_cpumask_var_node(&cfg->old_domain,
-							  GFP_ATOMIC, node)) {
-			free_cpumask_var(cfg->domain);
-			kfree(cfg);
-			cfg = NULL;
-		}
-	}
-
+	if (!cfg)
+		return NULL;
+	if (!zalloc_cpumask_var_node(&cfg->domain, GFP_ATOMIC, node))
+		goto out_cfg;
+	if (!zalloc_cpumask_var_node(&cfg->old_domain, GFP_ATOMIC, node))
+		goto out_domain;
 	return cfg;
-}
 
-int arch_init_chip_data(struct irq_desc *desc, int node)
-{
-	struct irq_cfg *cfg;
-
-	cfg = get_irq_desc_chip_data(desc);
-	if (!cfg) {
-		cfg = get_one_free_irq_cfg(node);
-		set_irq_desc_chip_data(desc, cfg);
-		if (!cfg) {
-			printk(KERN_ERR "can not alloc irq_cfg\n");
-			BUG_ON(1);
-		}
-	}
-
-	return 0;
+out_domain:
+	free_cpumask_var(cfg->domain);
+out_cfg:
+	kfree(cfg);
+	return NULL;
 }
 
-/* for move_irq_desc */
-static void
-init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int node)
+static void free_irq_cfg(unsigned int at, struct irq_cfg *cfg)
 {
-	struct irq_pin_list *old_entry, *head, *tail, *entry;
-
-	cfg->irq_2_pin = NULL;
-	old_entry = old_cfg->irq_2_pin;
-	if (!old_entry)
-		return;
-
-	entry = alloc_irq_pin_list(node);
-	if (!entry)
+	if (!cfg)
 		return;
-
-	entry->apic	= old_entry->apic;
-	entry->pin	= old_entry->pin;
-	head		= entry;
-	tail		= entry;
-	old_entry	= old_entry->next;
-	while (old_entry) {
-		entry = alloc_irq_pin_list(node);
-		if (!entry) {
-			entry = head;
-			while (entry) {
-				head = entry->next;
-				kfree(entry);
-				entry = head;
-			}
-			/* still use the old one */
-			return;
-		}
-		entry->apic	= old_entry->apic;
-		entry->pin	= old_entry->pin;
-		tail->next	= entry;
-		tail		= entry;
-		old_entry	= old_entry->next;
-	}
-
-	tail->next = NULL;
-	cfg->irq_2_pin = head;
+	set_irq_chip_data(at, NULL);
+	free_cpumask_var(cfg->domain);
+	free_cpumask_var(cfg->old_domain);
+	kfree(cfg);
 }
 
-static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
+static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 {
-	struct irq_pin_list *entry, *next;
-
-	if (old_cfg->irq_2_pin == cfg->irq_2_pin)
-		return;
+	int res = irq_alloc_desc_at(at, node);
+	struct irq_cfg *cfg;
 
-	entry = old_cfg->irq_2_pin;
+	if (res < 0)
+		return NULL;
 
-	while (entry) {
-		next = entry->next;
-		kfree(entry);
-		entry = next;
-	}
-	old_cfg->irq_2_pin = NULL;
+	cfg = alloc_irq_cfg(at, node);
+	if (cfg)
+		set_irq_chip_data(at, cfg);
+	else
+		irq_free_desc(at);
+	return cfg;
 }
-
-void arch_init_copy_chip_data(struct irq_desc *old_desc,
-				 struct irq_desc *desc, int node)
+#else
+struct irq_cfg *irq_cfg(unsigned int irq)
 {
-	struct irq_cfg *cfg;
-	struct irq_cfg *old_cfg;
-
-	cfg = get_one_free_irq_cfg(node);
-
-	if (!cfg)
-		return;
-
-	set_irq_desc_chip_data(desc, cfg);
-
-	old_cfg = get_irq_desc_chip_data(old_desc);
-
-	cfg->vector = old_cfg->vector;
-	cfg->move_in_progress = old_cfg->move_in_progress;
-	cpumask_copy(cfg->domain, old_cfg->domain);
-	cpumask_copy(cfg->old_domain, old_cfg->old_domain);
-
-	init_copy_irq_2_pin(old_cfg, cfg, node);
+	return irq < nr_irqs ? irq_cfgx + irq : NULL;
 }
 
-static void free_irq_cfg(struct irq_cfg *cfg)
+static struct irq_cfg *alloc_irq_cfg(unsigned int irq, int node)
 {
-	free_cpumask_var(cfg->domain);
-	free_cpumask_var(cfg->old_domain);
-	kfree(cfg);
+	return irq_cfgx + irq;
 }
 
-void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
+static inline void free_irq_cfg(unsigned int at, struct irq_cfg *cfg) { }
+
+static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
 {
-	struct irq_cfg *old_cfg, *cfg;
+	return get_irq_cfg_at(at, node);
+}
+#endif
 
-	old_cfg = get_irq_desc_chip_data(old_desc);
-	cfg = get_irq_desc_chip_data(desc);
+/*
+ * Allocate a new descriptor at irq number @at. If the allocation
+ * succeeds or the descriptor exists already, return the irq_cfg.
+ */
+static struct irq_cfg *get_irq_cfg_at(unsigned int at, int node)
+{
+	int res = irq_alloc_desc_at(at, node);
 
-	if (old_cfg == cfg)
-		return;
+	if (res < 0 && res != -EEXIST)
+		return NULL;
 
-	if (old_cfg) {
-		free_irq_2_pin(old_cfg, cfg);
-		free_irq_cfg(old_cfg);
-		set_irq_desc_chip_data(old_desc, NULL);
-	}
+	return get_irq_chip_data(at);
 }
-/* end for move_irq_desc */
 
-#else
-struct irq_cfg *irq_cfg(unsigned int irq)
+static int alloc_irq_from(unsigned int from, int node)
 {
-	return irq < nr_irqs ? irq_cfgx + irq : NULL;
+	return irq_alloc_desc_from(from, node);
 }
 
-#endif
+static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
+{
+	free_irq_cfg(at, cfg);
+	irq_free_desc(at);
+}
 
 struct io_apic {
 	unsigned int index;
@@ -1233,7 +1171,6 @@ void __setup_vector_irq(int cpu)
 	/* Initialize vector_irq on a new cpu */
 	int irq, vector;
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 
 	/*
 	 * vector_lock will make sure that we don't run into irq vector
@@ -1242,9 +1179,10 @@ void __setup_vector_irq(int cpu)
 	 */
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
-	for_each_irq_desc(irq, desc) {
-		cfg = get_irq_desc_chip_data(desc);
-
+	for_each_irq_nr(irq) {
+		cfg = get_irq_chip_data(irq);
+		if (!cfg)
+			continue;
 		/*
 		 * If it is a legacy IRQ handled by the legacy PIC, this cpu
 		 * will be part of the irq_cfg's domain.
@@ -1454,11 +1392,9 @@ static struct {
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic_id, pin, idx, irq;
-	int notcon = 0;
-	struct irq_desc *desc;
-	struct irq_cfg *cfg;
+	int apic_id, pin, idx, irq, notcon = 0;
 	int node = cpu_to_node(boot_cpu_id);
+	struct irq_cfg *cfg;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -1495,12 +1431,10 @@ static void __init setup_IO_APIC_irqs(vo
 				apic->multi_timer_check(apic_id, irq))
 			continue;
 
-		desc = irq_to_desc_alloc_node(irq, node);
-		if (!desc) {
-			printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+		cfg = get_irq_cfg_at(irq, node);
+		if (!cfg)
 			continue;
-		}
-		cfg = get_irq_desc_chip_data(desc);
+
 		add_pin_to_irq_node(cfg, node, apic_id, pin);
 		/*
 		 * don't mark it in pin_programmed, so later acpi could
@@ -1522,9 +1456,7 @@ static void __init setup_IO_APIC_irqs(vo
  */
 void setup_IO_APIC_irq_extra(u32 gsi)
 {
-	int apic_id = 0, pin, idx, irq;
-	int node = cpu_to_node(boot_cpu_id);
-	struct irq_desc *desc;
+	int apic_id = 0, pin, idx, irq, node = cpu_to_node(boot_cpu_id);
 	struct irq_cfg *cfg;
 
 	/*
@@ -1540,18 +1472,11 @@ void setup_IO_APIC_irq_extra(u32 gsi)
 		return;
 
 	irq = pin_2_irq(idx, apic_id, pin);
-#ifdef CONFIG_SPARSE_IRQ
-	desc = irq_to_desc(irq);
-	if (desc)
-		return;
-#endif
-	desc = irq_to_desc_alloc_node(irq, node);
-	if (!desc) {
-		printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+
+	cfg = alloc_irq_and_cfg_at(irq, node);
+	if (!cfg)
 		return;
-	}
 
-	cfg = get_irq_desc_chip_data(desc);
 	add_pin_to_irq_node(cfg, node, apic_id, pin);
 
 	if (test_bit(pin, mp_ioapic_routing[apic_id].pin_programmed)) {
@@ -3153,44 +3078,37 @@ device_initcall(ioapic_init_sysfs);
 /*
  * Dynamic irq allocate and deallocation
  */
-unsigned int create_irq_nr(unsigned int irq_want, int node)
+unsigned int create_irq_nr(unsigned int from, int node)
 {
-	/* Allocate an unused irq */
-	unsigned int irq;
-	unsigned int new;
+	struct irq_cfg *cfg;
 	unsigned long flags;
-	struct irq_cfg *cfg_new = NULL;
-	struct irq_desc *desc_new = NULL;
-
-	irq = 0;
-	if (irq_want < nr_irqs_gsi)
-		irq_want = nr_irqs_gsi;
-
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	for (new = irq_want; new < nr_irqs; new++) {
-		desc_new = irq_to_desc_alloc_node(new, node);
-		if (!desc_new) {
-			printk(KERN_INFO "can not get irq_desc for %d\n", new);
-			continue;
-		}
-		cfg_new = get_irq_desc_chip_data(desc_new);
-
-		if (cfg_new->vector != 0)
-			continue;
+	unsigned int ret = 0;
+	int irq;
 
-		desc_new = move_irq_desc(desc_new, node);
-		cfg_new = get_irq_desc_chip_data(desc_new);
+	if (from < nr_irqs_gsi)
+		from = nr_irqs_gsi;
 
-		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
-			irq = new;
-		break;
+	irq = alloc_irq_from(from, node);
+	if (irq < 0)
+		return 0;
+	cfg = alloc_irq_cfg(irq, node);
+	if (!cfg) {
+		free_irq_at(irq, NULL);
+		return 0;
 	}
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (irq > 0)
-		dynamic_irq_init_keep_chip_data(irq);
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	if (!__assign_irq_vector(irq, cfg, apic->target_cpus()))
+		ret = irq;
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
-	return irq;
+	if (ret) {
+		set_irq_chip_data(irq, cfg);
+		irq_clear_status_flags(irq, IRQ_NOREQUEST);
+	} else {
+		free_irq_at(irq, cfg);
+	}
+	return ret;
 }
 
 int create_irq(void)
@@ -3210,14 +3128,16 @@ int create_irq(void)
 
 void destroy_irq(unsigned int irq)
 {
+	struct irq_cfg *cfg = get_irq_chip_data(irq);
 	unsigned long flags;
 
-	dynamic_irq_cleanup_keep_chip_data(irq);
+	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
 
 	free_irte(irq);
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq, get_irq_chip_data(irq));
+	__clear_irq_vector(irq, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
+	free_irq_at(irq, cfg);
 }
 
 /*
@@ -3785,11 +3705,8 @@ int __init arch_probe_nr_irqs(void)
 static int __io_apic_set_pci_routing(struct device *dev, int irq,
 				struct io_apic_irq_attr *irq_attr)
 {
-	struct irq_desc *desc;
+	int node, ioapic, pin, trigger, polarity;
 	struct irq_cfg *cfg;
-	int node;
-	int ioapic, pin;
-	int trigger, polarity;
 
 	ioapic = irq_attr->ioapic;
 	if (!IO_APIC_IRQ(irq)) {
@@ -3803,18 +3720,14 @@ static int __io_apic_set_pci_routing(str
 	else
 		node = cpu_to_node(boot_cpu_id);
 
-	desc = irq_to_desc_alloc_node(irq, node);
-	if (!desc) {
-		printk(KERN_INFO "can not get irq_desc %d\n", irq);
+	cfg = get_irq_cfg_at(irq, node);
+	if (!cfg)
 		return 0;
-	}
 
 	pin = irq_attr->ioapic_pin;
 	trigger = irq_attr->trigger;
 	polarity = irq_attr->polarity;
 
-	cfg = get_irq_desc_chip_data(desc);
-
 	/*
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
@@ -4215,11 +4128,11 @@ void __init pre_init_apic_IRQ0(void)
 #ifndef CONFIG_SMP
 	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
 #endif
-	irq_to_desc_alloc_node(0, 0);
+	/* Make sure the irq descriptor is set up */
+	cfg = get_irq_cfg_at(0, 0);
 
 	setup_local_APIC();
 
-	cfg = irq_cfg(0);
 	add_pin_to_irq_node(cfg, 0, 0, 0);
 	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
 


