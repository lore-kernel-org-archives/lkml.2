Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0CUHQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:16:57 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:20818 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0CUHQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:16:53 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/20] x86: use vector_desc instead of vector_irq
Date: Sun, 21 Mar 2010 00:13:12 -0700
Message-Id: <1269155601-18247-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BA5C78E.00CC,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric pointed out that radix tree version of irq_to_desc will magnify delay on
the path of handle_irq.

use vector_desc to reduce the calling of irq_to_desc.

next step: need to change all ack, mask, umask, eoi for all irq_chip to take irq_desc

-v2: irq should be unsigned in 32bit handle_irq according to Eric
     also reset vector_desc for lguest in setup_irq
-v3: keep irq in x+execute_on_irq_stack() ...
-v4: update after legacy_pic

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/include/asm/desc.h    |    2 +-
 arch/x86/include/asm/hw_irq.h  |   13 ++++---
 arch/x86/include/asm/irq.h     |    3 +-
 arch/x86/kernel/apic/io_apic.c |   77 +++++++++++++++++++++-------------------
 arch/x86/kernel/irq.c          |   15 ++++----
 arch/x86/kernel/irq_32.c       |   13 ++++---
 arch/x86/kernel/irq_64.c       |    7 +---
 arch/x86/kernel/irqinit.c      |   14 +++----
 arch/x86/kernel/smpboot.c      |    2 +-
 arch/x86/kernel/uv_irq.c       |    2 +-
 arch/x86/kernel/vmiclock_32.c  |    2 +-
 arch/x86/lguest/boot.c         |    7 +++-
 12 files changed, 82 insertions(+), 75 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 617bd56..25c5635 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -334,7 +334,7 @@ static inline void set_intr_gate(unsigned int n, void *addr)
 }
 
 extern int first_system_vector;
-/* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
+/* used_vectors is BITMAP for irq is not managed by percpu vector_desc */
 extern unsigned long used_vectors[];
 
 static inline void alloc_system_vector(int vector)
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 767d3f8..d23cf94 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -97,7 +97,8 @@ struct irq_cfg {
 };
 
 extern struct irq_cfg *irq_cfg(unsigned int);
-extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
+int assign_irq_vector(struct irq_desc *, struct irq_cfg *,
+			 const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
 
 struct irq_desc;
@@ -136,18 +137,18 @@ extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
 
 extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
-typedef int vector_irq_t[NR_VECTORS];
-DECLARE_PER_CPU(vector_irq_t, vector_irq);
-extern void setup_vector_irq(int cpu);
+typedef struct irq_desc *vector_desc_t[NR_VECTORS];
+DECLARE_PER_CPU(vector_desc_t, vector_desc);
+extern void setup_vector_desc(int cpu);
 
 #ifdef CONFIG_X86_IO_APIC
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
-extern void __setup_vector_irq(int cpu);
+extern void __setup_vector_desc(int cpu);
 #else
 static inline void lock_vector_lock(void) {}
 static inline void unlock_vector_lock(void) {}
-static inline void __setup_vector_irq(int cpu) {}
+static inline void __setup_vector_desc(int cpu) {}
 #endif
 
 #endif /* !ASSEMBLY_ */
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 5458380..64c5f6f 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -39,7 +39,8 @@ extern void irq_force_complete_move(int);
 
 extern void (*x86_platform_ipi_callback)(void);
 extern void native_init_IRQ(void);
-extern bool handle_irq(unsigned irq, struct pt_regs *regs);
+struct irq_desc;
+extern bool handle_irq(struct irq_desc *desc, struct pt_regs *regs);
 
 extern unsigned int do_IRQ(struct pt_regs *regs);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ba469f8..cd2f193 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1159,7 +1159,8 @@ void unlock_vector_lock(void)
 }
 
 static int
-__assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+__assign_irq_vector(struct irq_desc *desc, struct irq_cfg *cfg,
+			 const struct cpumask *mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1218,7 +1219,7 @@ next:
 			goto next;
 
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
-			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
+			if (per_cpu(vector_desc, new_cpu)[vector] != NULL)
 				goto next;
 		/* Found one! */
 		current_vector = vector;
@@ -1228,7 +1229,7 @@ next:
 			cpumask_copy(cfg->old_domain, cfg->domain);
 		}
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
-			per_cpu(vector_irq, new_cpu)[vector] = irq;
+			per_cpu(vector_desc, new_cpu)[vector] = desc;
 		cfg->vector = vector;
 		cpumask_copy(cfg->domain, tmp_mask);
 		err = 0;
@@ -1238,18 +1239,19 @@ next:
 	return err;
 }
 
-int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+int assign_irq_vector(struct irq_desc *desc, struct irq_cfg *cfg,
+			 const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, cfg, mask);
+	err = __assign_irq_vector(desc, cfg, mask);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
 
-static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
+static void __clear_irq_vector(struct irq_desc *desc, struct irq_cfg *cfg)
 {
 	int cpu, vector;
 
@@ -1257,7 +1259,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 
 	vector = cfg->vector;
 	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
-		per_cpu(vector_irq, cpu)[vector] = -1;
+		per_cpu(vector_desc, cpu)[vector] = NULL;
 
 	cfg->vector = 0;
 	cpumask_clear(cfg->domain);
@@ -1267,18 +1269,18 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 								vector++) {
-			if (per_cpu(vector_irq, cpu)[vector] != irq)
+			if (per_cpu(vector_desc, cpu)[vector] != desc)
 				continue;
-			per_cpu(vector_irq, cpu)[vector] = -1;
+			per_cpu(vector_desc, cpu)[vector] = NULL;
 			break;
 		}
 	}
 	cfg->move_in_progress = 0;
 }
 
-void __setup_vector_irq(int cpu)
+void __setup_vector_desc(int cpu)
 {
-	/* Initialize vector_irq on a new cpu */
+	/* Initialize vector_desc on a new cpu */
 	int irq, vector;
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
@@ -1303,17 +1305,17 @@ void __setup_vector_irq(int cpu)
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
-		per_cpu(vector_irq, cpu)[vector] = irq;
+		per_cpu(vector_desc, cpu)[vector] = desc;
 	}
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
-		irq = per_cpu(vector_irq, cpu)[vector];
-		if (irq < 0)
+		desc = per_cpu(vector_desc, cpu)[vector];
+		if (!desc)
 			continue;
 
-		cfg = irq_cfg(irq);
+		cfg = desc->chip_data;
 		if (!cpumask_test_cpu(cpu, cfg->domain))
-			per_cpu(vector_irq, cpu)[vector] = -1;
+			per_cpu(vector_desc, cpu)[vector] = NULL;
 	}
 	raw_spin_unlock(&vector_lock);
 }
@@ -1473,7 +1475,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 	if (irq < legacy_pic->nr_legacy_irqs && cpumask_test_cpu(0, cfg->domain))
 		apic->vector_allocation_domain(0, cfg->domain);
 
-	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
+	if (assign_irq_vector(desc, cfg, apic->target_cpus()))
 		return;
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
@@ -1489,7 +1491,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 			       dest, trigger, polarity, cfg->vector, pin)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic_id].apicid, pin);
-		__clear_irq_vector(irq, cfg);
+		__clear_irq_vector(desc, cfg);
 		return;
 	}
 
@@ -2386,14 +2388,12 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask,
 		  unsigned int *dest_id)
 {
 	struct irq_cfg *cfg;
-	unsigned int irq;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
 		return -1;
 
-	irq = desc->irq;
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+	if (assign_irq_vector(desc, cfg, mask))
 		return -1;
 
 	cpumask_copy(desc->affinity, mask);
@@ -2466,7 +2466,7 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 		return ret;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+	if (assign_irq_vector(desc, cfg, mask))
 		return ret;
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
@@ -2520,20 +2520,15 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
-		unsigned int irq;
 		unsigned int irr;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
-		irq = __get_cpu_var(vector_irq)[vector];
-
-		if (irq == -1)
-			continue;
+		desc = __get_cpu_var(vector_desc)[vector];
 
-		desc = irq_to_desc(irq);
 		if (!desc)
 			continue;
 
-		cfg = irq_cfg(irq);
+		cfg = desc->chip_data;
 		raw_spin_lock(&desc->lock);
 
 		/*
@@ -2558,7 +2553,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
 			goto unlock;
 		}
-		__get_cpu_var(vector_irq)[vector] = -1;
+		__get_cpu_var(vector_desc)[vector] = NULL;
 unlock:
 		raw_spin_unlock(&desc->lock);
 	}
@@ -3001,7 +2996,7 @@ static inline void __init check_timer(void)
 	 * get/set the timer IRQ vector:
 	 */
 	legacy_pic->chip->mask(0);
-	assign_irq_vector(0, cfg, apic->target_cpus());
+	assign_irq_vector(desc, cfg, apic->target_cpus());
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -3331,7 +3326,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 		desc_new = move_irq_desc(desc_new, node);
 		cfg_new = desc_new->chip_data;
 
-		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
+		if (__assign_irq_vector(desc_new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
 		break;
 	}
@@ -3361,12 +3356,16 @@ int create_irq(void)
 void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
+	struct irq_desc *desc;
+	struct irq_cfg *cfg;
 
 	dynamic_irq_cleanup_keep_chip_data(irq);
 
 	free_irte(irq);
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq, get_irq_chip_data(irq));
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	__clear_irq_vector(desc, cfg);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 }
 
@@ -3377,6 +3376,7 @@ void destroy_irq(unsigned int irq)
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 			   struct msi_msg *msg, u8 hpet_id)
 {
+	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
@@ -3384,8 +3384,9 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	if (disable_apic)
 		return -ENXIO;
 
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	err = assign_irq_vector(desc, cfg, apic->target_cpus());
 	if (err)
 		return err;
 
@@ -3876,14 +3877,16 @@ static struct irq_chip ht_irq_chip = {
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
+	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 	int err;
 
 	if (disable_apic)
 		return -ENXIO;
 
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	desc = irq_to_desc(irq);
+	cfg = desc->chip_data;
+	err = assign_irq_vector(desc, cfg, apic->target_cpus());
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 91fd0c7..f71625c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -229,19 +229,19 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
-	unsigned irq;
+	struct irq_desc *desc;
 
 	exit_idle();
 	irq_enter();
 
-	irq = __get_cpu_var(vector_irq)[vector];
+	desc = __get_cpu_var(vector_desc)[vector];
 
-	if (!handle_irq(irq, regs)) {
+	if (!handle_irq(desc, regs)) {
 		ack_APIC_irq();
 
 		if (printk_ratelimit())
-			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
-				__func__, smp_processor_id(), vector, irq);
+			pr_emerg("%s: %d.%d No irq handler for vector\n",
+				__func__, smp_processor_id(), vector);
 	}
 
 	irq_exit();
@@ -348,14 +348,13 @@ void fixup_irqs(void)
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
 		unsigned int irr;
 
-		if (__get_cpu_var(vector_irq)[vector] < 0)
+		if (__get_cpu_var(vector_desc)[vector] == NULL)
 			continue;
 
 		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
 		if (irr  & (1 << (vector % 32))) {
-			irq = __get_cpu_var(vector_irq)[vector];
+			desc = __get_cpu_var(vector_desc)[vector];
 
-			desc = irq_to_desc(irq);
 			raw_spin_lock(&desc->lock);
 			if (desc->chip->retrigger)
 				desc->chip->retrigger(irq);
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 10709f2..f5daa3d 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -76,7 +76,7 @@ static void call_on_stack(void *func, void *stack)
 }
 
 static inline int
-execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
+execute_on_irq_stack(int overflow, struct irq_desc *desc, unsigned int irq)
 {
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp, arg1, arg2;
@@ -189,20 +189,23 @@ asmlinkage void do_softirq(void)
 
 #else
 static inline int
-execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
+execute_on_irq_stack(int overflow, struct irq_desc *desc, unsigned int irq)
+{
+	 return 0;
+}
 #endif
 
-bool handle_irq(unsigned irq, struct pt_regs *regs)
+bool handle_irq(struct irq_desc *desc, struct pt_regs *regs)
 {
-	struct irq_desc *desc;
 	int overflow;
+	unsigned int irq;
 
 	overflow = check_stack_overflow();
 
-	desc = irq_to_desc(irq);
 	if (unlikely(!desc))
 		return false;
 
+	irq = desc->irq;
 	if (!execute_on_irq_stack(overflow, desc, irq)) {
 		if (unlikely(overflow))
 			print_stack_overflow();
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index acf8fbf..5e6e493 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -48,17 +48,14 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 #endif
 }
 
-bool handle_irq(unsigned irq, struct pt_regs *regs)
+bool handle_irq(struct irq_desc *desc, struct pt_regs *regs)
 {
-	struct irq_desc *desc;
-
 	stack_overflow_check(regs);
 
-	desc = irq_to_desc(irq);
 	if (unlikely(!desc))
 		return false;
 
-	generic_handle_irq_desc(irq, desc);
+	generic_handle_irq_desc(desc->irq, desc);
 	return true;
 }
 
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index f01d390..7b77458 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -83,16 +83,14 @@ static struct irqaction irq2 = {
 	.name = "cascade",
 };
 
-DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... NR_VECTORS - 1] = -1,
-};
+DEFINE_PER_CPU(vector_desc_t, vector_desc);
 
 int vector_used_by_percpu_irq(unsigned int vector)
 {
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		if (per_cpu(vector_irq, cpu)[vector] != -1)
+		if (per_cpu(vector_desc, cpu)[vector] != NULL)
 			return 1;
 	}
 
@@ -136,7 +134,7 @@ void __init init_IRQ(void)
 	 * irq's migrate etc.
 	 */
 	for (i = 0; i < legacy_pic->nr_legacy_irqs; i++)
-		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
+		per_cpu(vector_desc, 0)[IRQ0_VECTOR + i] = irq_to_desc(i);
 
 	x86_init.irqs.intr_init();
 }
@@ -144,7 +142,7 @@ void __init init_IRQ(void)
 /*
  * Setup the vector to irq mappings.
  */
-void setup_vector_irq(int cpu)
+void setup_vector_desc(int cpu)
 {
 #ifndef CONFIG_X86_IO_APIC
 	int irq;
@@ -157,10 +155,10 @@ void setup_vector_irq(int cpu)
 	 * legacy vector to irq mapping:
 	 */
 	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
-		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
+		per_cpu(vector_desc, cpu)[IRQ0_VECTOR + irq] = irq_to_desc(irq);
 #endif
 
-	__setup_vector_irq(cpu);
+	__setup_vector_desc(cpu);
 }
 
 static void __init smp_intr_init(void)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ba43b3b..a1483ac 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -246,7 +246,7 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
-	setup_vector_irq(smp_processor_id());
+	setup_vector_desc(smp_processor_id());
 	/*
 	 * Get our bogomips.
 	 *
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index 4c61f1b..44c430d 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -158,7 +158,7 @@ arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 
 	cfg = irq_cfg(irq);
 
-	err = assign_irq_vector(irq, cfg, eligible_cpu);
+	err = assign_irq_vector(desc, cfg, eligible_cpu);
 	if (err != 0)
 		return err;
 
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 5e1ff66..fb65235 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -236,7 +236,7 @@ void __init vmi_time_init(void)
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
 	for_each_possible_cpu(cpu)
-		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
+		per_cpu(vector_desc, cpu)[vmi_get_timer_vector()] = irq_to_desc(0);
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 8eb9eed..e0f6b26 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -819,7 +819,7 @@ static void __init lguest_init_IRQ(void)
 
 	for (i = FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
 		/* Some systems map "vectors" to interrupts weirdly.  Not us! */
-		__get_cpu_var(vector_irq)[i] = i - FIRST_EXTERNAL_VECTOR;
+		__get_cpu_var(vector_desc)[i] = irq_to_desc(i - FIRST_EXTERNAL_VECTOR);
 		if (i != SYSCALL_VECTOR)
 			set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
@@ -842,6 +842,11 @@ static void __init lguest_init_IRQ(void)
 void lguest_setup_irq(unsigned int irq)
 {
 	irq_to_desc_alloc_node(irq, 0);
+	/*
+	 *  for sparseirq, we could get new desc other than legacy irq,
+	 *  so set vector_desc again for that irq
+	 */
+	__get_cpu_var(vector_desc)[irq + FIRST_EXTERNAL_VECTOR] = irq_to_desc(irq);
 	set_irq_chip_and_handler_name(irq, &lguest_irq_controller,
 				      handle_level_irq, "level");
 }
-- 
1.6.4.2

