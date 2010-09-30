Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0I3XSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:18:16 -0400
Received: from www.tglx.de ([62.245.132.106]:53042 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab0I3XSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:18:13 -0400
Message-Id: <20100930221742.125499553@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:17:50 -0000
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
Subject: [patch 37/47] x86: uv: Clean up the direct access to irq_desc
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-uv-cleanup-irq-desc-mess.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h  |    1 
 arch/x86/kernel/apic/io_apic.c |    2 -
 arch/x86/kernel/uv_irq.c       |   55 ++++++++++++++---------------------------
 3 files changed, 20 insertions(+), 38 deletions(-)

Index: linux-2.6-tip/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6-tip/arch/x86/include/asm/hw_irq.h
@@ -91,7 +91,6 @@ struct irq_cfg {
 	u8			move_in_progress : 1;
 };
 
-extern struct irq_cfg *irq_cfg(unsigned int);
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
 
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -177,7 +177,7 @@ int __init arch_early_irq_init(void)
 static struct irq_cfg *get_irq_cfg_at(unsigned int at, int node);
 
 #ifdef CONFIG_SPARSE_IRQ
-struct irq_cfg *irq_cfg(unsigned int irq)
+static struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	return get_irq_chip_data(irq);
 }
Index: linux-2.6-tip/arch/x86/kernel/uv_irq.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6-tip/arch/x86/kernel/uv_irq.c
@@ -28,34 +28,21 @@ struct uv_irq_2_mmr_pnode{
 static spinlock_t		uv_irq_lock;
 static struct rb_root		uv_irq_root;
 
-static int uv_set_irq_affinity(unsigned int, const struct cpumask *);
+static int uv_set_irq_affinity(struct irq_data *, const struct cpumask *, bool);
 
-static void uv_noop(unsigned int irq)
-{
-}
-
-static unsigned int uv_noop_ret(unsigned int irq)
-{
-	return 0;
-}
+static void uv_noop(struct irq_data *data) { }
 
-static void uv_ack_apic(unsigned int irq)
+static void uv_ack_apic(struct irq_data *data)
 {
 	ack_APIC_irq();
 }
 
 static struct irq_chip uv_irq_chip = {
-	.name		= "UV-CORE",
-	.startup	= uv_noop_ret,
-	.shutdown	= uv_noop,
-	.enable		= uv_noop,
-	.disable	= uv_noop,
-	.ack		= uv_noop,
-	.mask		= uv_noop,
-	.unmask		= uv_noop,
-	.eoi		= uv_ack_apic,
-	.end		= uv_noop,
-	.set_affinity	= uv_set_irq_affinity,
+	.name			= "UV-CORE",
+	.irq_mask		= uv_noop,
+	.irq_unmask		= uv_noop,
+	.irq_eoi		= uv_ack_apic,
+	.irq_set_affinity	= uv_set_irq_affinity,
 };
 
 /*
@@ -144,26 +131,22 @@ arch_enable_uv_irq(char *irq_name, unsig
 		       unsigned long mmr_offset, int limit)
 {
 	const struct cpumask *eligible_cpu = cpumask_of(cpu);
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg;
-	int mmr_pnode;
+	struct irq_cfg *cfg = get_irq_chip_data(irq);
 	unsigned long mmr_value;
 	struct uv_IO_APIC_route_entry *entry;
-	int err;
+	int mmr_pnode, err;
 
 	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
 			sizeof(unsigned long));
 
-	cfg = irq_cfg(irq);
-
 	err = assign_irq_vector(irq, cfg, eligible_cpu);
 	if (err != 0)
 		return err;
 
 	if (limit == UV_AFFINITY_CPU)
-		desc->status |= IRQ_NO_BALANCING;
+		irq_set_status_flags(irq, IRQ_NO_BALANCING);
 	else
-		desc->status |= IRQ_MOVE_PCNTXT;
+		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 
 	set_irq_chip_and_handler_name(irq, &uv_irq_chip, handle_percpu_irq,
 				      irq_name);
@@ -206,17 +189,17 @@ static void arch_disable_uv_irq(int mmr_
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 }
 
-static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int
+uv_set_irq_affinity(struct irq_data *data, const struct cpumask *mask,
+		    bool force)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_cfg *cfg = get_irq_desc_chip_data(desc);
+	struct irq_cfg *cfg = data->chip_data;
 	unsigned int dest;
-	unsigned long mmr_value;
+	unsigned long mmr_value, mmr_offset;
 	struct uv_IO_APIC_route_entry *entry;
-	unsigned long mmr_offset;
 	int mmr_pnode;
 
-	if (__ioapic_set_affinity(&desc->irq_data, mask, &dest))
+	if (__ioapic_set_affinity(data, mask, &dest))
 		return -1;
 
 	mmr_value = 0;
@@ -231,7 +214,7 @@ static int uv_set_irq_affinity(unsigned 
 	entry->dest		= dest;
 
 	/* Get previously stored MMR and pnode of hub sourcing interrupts */
-	if (uv_irq_2_mmr_info(irq, &mmr_offset, &mmr_pnode))
+	if (uv_irq_2_mmr_info(data->irq, &mmr_offset, &mmr_pnode))
 		return -1;
 
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);


