Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab0JYQXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:23:47 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44360 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab0JYQXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:23:46 -0400
X-IronPort-AV: E=Sophos;i="4.58,236,1286164800"; 
   d="scan'208";a="119590674"
From: Ian Campbell <ian.campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 4/5] xen: events: dynamically allocate irq info structures
Date: Mon, 25 Oct 2010 17:23:32 +0100
Message-Id: <1288023813-31989-4-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 25 Oct 2010 16:23:45.0525 (UTC) FILETIME=[FF121A50:01CB7460]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes nr_irq sized array allocation at start of day.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   50 +++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 94055ea..9b58505 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -56,6 +56,8 @@
  */
 static DEFINE_SPINLOCK(irq_mapping_update_lock);
 
+static LIST_HEAD(xen_irq_list_head);
+
 /* IRQ <-> VIRQ mapping. */
 static DEFINE_PER_CPU(int [NR_VIRQS], virq_to_irq) = {[0 ... NR_VIRQS-1] = -1};
 
@@ -85,6 +87,7 @@ enum xen_irq_type {
  */
 struct irq_info
 {
+	struct list_head list;
 	enum xen_irq_type type;	/* type */
 	unsigned short evtchn;	/* event channel */
 	unsigned short cpu;	/* cpu bound */
@@ -103,7 +106,6 @@ struct irq_info
 #define PIRQ_NEEDS_EOI	(1 << 0)
 #define PIRQ_SHAREABLE	(1 << 1)
 
-static struct irq_info *irq_info;
 static int *pirq_to_irq;
 static int nr_pirqs;
 
@@ -132,7 +134,7 @@ static struct irq_chip xen_pirq_chip;
 /* Get info for IRQ */
 static struct irq_info *info_for_irq(unsigned irq)
 {
-	return &irq_info[irq];
+	return get_irq_data(irq);
 }
 
 /* Constructors for packed IRQ information. */
@@ -315,7 +317,7 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
 	__clear_bit(chn, cpu_evtchn_mask(cpu_from_irq(irq)));
 	__set_bit(chn, cpu_evtchn_mask(cpu));
 
-	irq_info[irq].cpu = cpu;
+	info_for_irq(irq)->cpu = cpu;
 }
 
 static void init_evtchn_cpu_bindings(void)
@@ -428,6 +430,21 @@ static int find_unbound_pirq(void)
 	return -1;
 }
 
+static void xen_irq_init(unsigned irq)
+{
+	struct irq_info *info;
+
+	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	if (info == NULL)
+		panic("Unable to allocate metadata for IRQ%d\n", irq);
+
+	info->type = IRQT_UNBOUND;
+
+	set_irq_data(irq, info);
+
+	list_add_tail(&info->list, &xen_irq_list_head);
+}
+
 static int xen_irq_alloc(void)
 {
 	int irq = irq_alloc_desc(0);
@@ -435,6 +452,8 @@ static int xen_irq_alloc(void)
 	if (irq < 0)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
+	xen_irq_init(irq);
+
 	return irq;
 }
 
@@ -446,11 +465,20 @@ static void xen_irq_alloc_specific(unsigned irq)
 		panic("No available IRQ: increase nr_irqs!\n");
 	if (res != irq)
 		panic("Unable to allocate to IRQ%d\n", irq);
+
+	xen_irq_init(irq);
 }
 
 static void xen_irq_free(unsigned irq)
 {
-	irq_info[irq].type = IRQT_UNBOUND;
+	struct irq_info *info = get_irq_data(irq);
+
+	list_del(&info->list);
+
+	set_irq_data(irq, NULL);
+
+	kfree(info);
+
 	irq_free_desc(irq);
 }
 
@@ -921,7 +949,7 @@ static void unbind_from_irq(unsigned int irq)
 		evtchn_to_irq[evtchn] = -1;
 	}
 
-	BUG_ON(irq_info[irq].type == IRQT_UNBOUND);
+	BUG_ON(info_for_irq(irq)->type == IRQT_UNBOUND);
 
 	xen_irq_free(irq);
 
@@ -1400,7 +1428,10 @@ void xen_poll_irq(int irq)
 
 void xen_irq_resume(void)
 {
-	unsigned int cpu, irq, evtchn;
+	unsigned int cpu, evtchn;
+	struct irq_info *info;
+
+	spin_lock(&irq_mapping_update_lock);
 
 	init_evtchn_cpu_bindings();
 
@@ -1409,8 +1440,8 @@ void xen_irq_resume(void)
 		mask_evtchn(evtchn);
 
 	/* No IRQ <-> event-channel mappings. */
-	for (irq = 0; irq < nr_irqs; irq++)
-		irq_info[irq].evtchn = 0; /* zap event-channel binding */
+	list_for_each_entry(info, &xen_irq_list_head, list)
+		info->evtchn = 0; /* zap event-channel binding */
 
 	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
 		evtchn_to_irq[evtchn] = -1;
@@ -1419,6 +1450,8 @@ void xen_irq_resume(void)
 		restore_cpu_virqs(cpu);
 		restore_cpu_ipis(cpu);
 	}
+
+	spin_unlock(&irq_mapping_update_lock);
 }
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
@@ -1508,7 +1541,6 @@ void __init xen_init_IRQ(void)
 
 	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
 				    GFP_KERNEL);
-	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
 
 	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_nr_pirqs, &op_nr_pirqs);
 	if (rc < 0) {
-- 
1.5.6.5

