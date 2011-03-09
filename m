Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab1CIRlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:41:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8739 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922Ab1CIRlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:49 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432628"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 10/14] xen: events: maintain a list of Xen interrupts
Date: Wed,  9 Mar 2011 17:41:22 +0000
Message-Id: <1299692486-28634-10-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:48.0883 (UTC) FILETIME=[44561230:01CBDE81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a PVHVM kernel not all interrupts are Xen interrupts (APIC interrupts can also be present).

Currently we get away with walking over all interrupts because the
lookup in the irq_info array simply returns IRQT_UNBOUND and we ignore
it. However this array will be going away in a future patch so we need
to manually track which interrupts have been allocated by the Xen
events infrastructure.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   59 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index cf372d4..e119989 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -56,6 +56,8 @@
  */
 static DEFINE_SPINLOCK(irq_mapping_update_lock);
 
+static LIST_HEAD(xen_irq_list_head);
+
 /* IRQ <-> VIRQ mapping. */
 static DEFINE_PER_CPU(int [NR_VIRQS], virq_to_irq) = {[0 ... NR_VIRQS-1] = -1};
 
@@ -85,7 +87,9 @@ enum xen_irq_type {
  */
 struct irq_info
 {
+	struct list_head list;
 	enum xen_irq_type type;	/* type */
+	unsigned irq;
 	unsigned short evtchn;	/* event channel */
 	unsigned short cpu;	/* cpu bound */
 
@@ -135,6 +139,7 @@ static void xen_irq_info_common_init(struct irq_info *info,
 	BUG_ON(info->type != IRQT_UNBOUND && info->type != type);
 
 	info->type = type;
+	info->irq = irq;
 	info->evtchn = evtchn;
 	info->cpu = cpu;
 
@@ -311,10 +316,11 @@ static void init_evtchn_cpu_bindings(void)
 {
 	int i;
 #ifdef CONFIG_SMP
-	struct irq_desc *desc;
+	struct irq_info *info;
 
 	/* By default all event channels notify CPU#0. */
-	for_each_irq_desc(i, desc) {
+	list_for_each_entry(info, &xen_irq_list_head, list) {
+		struct irq_desc *desc = irq_to_desc(info->irq);
 		cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
 	}
 #endif
@@ -397,6 +403,21 @@ static void unmask_evtchn(int port)
 	put_cpu();
 }
 
+static void xen_irq_init(unsigned irq)
+{
+	struct irq_info *info;
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	/* By default all event channels notify CPU#0. */
+	cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
+
+	info = &irq_info[irq];
+
+	info->type = IRQT_UNBOUND;
+
+	list_add_tail(&info->list, &xen_irq_list_head);
+}
+
 static int xen_allocate_irq_dynamic(void)
 {
 	int first = 0;
@@ -426,6 +447,8 @@ retry:
 	if (irq < 0)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
+	xen_irq_init(irq);
+
 	return irq;
 }
 
@@ -444,18 +467,25 @@ static int xen_allocate_irq_gsi(unsigned gsi)
 
 	/* Legacy IRQ descriptors are already allocated by the arch. */
 	if (gsi < NR_IRQS_LEGACY)
-		return gsi;
+		irq = gsi;
+	else
+		irq = irq_alloc_desc_at(gsi, -1);
 
-	irq = irq_alloc_desc_at(gsi, -1);
 	if (irq < 0)
 		panic("Unable to allocate to IRQ%d (%d)\n", gsi, irq);
 
+	xen_irq_init(irq);
+
 	return irq;
 }
 
 static void xen_free_irq(unsigned irq)
 {
-	irq_info[irq].type = IRQT_UNBOUND;
+	struct irq_info *info = &irq_info[irq];
+
+	info->type = IRQT_UNBOUND;
+
+	list_del(&info->list);
 
 	/* Legacy IRQ descriptors are managed by the arch. */
 	if (irq < NR_IRQS_LEGACY)
@@ -586,16 +616,14 @@ static void ack_pirq(struct irq_data *data)
 
 static int find_irq_by_gsi(unsigned gsi)
 {
-	int irq;
-
-	for (irq = 0; irq < nr_irqs; irq++) {
-		struct irq_info *info = info_for_irq(irq);
+	struct irq_info *info;
 
-		if (info == NULL || info->type != IRQT_PIRQ)
+	list_for_each_entry(info, &xen_irq_list_head, list) {
+		if (info->type != IRQT_PIRQ)
 			continue;
 
-		if (gsi_from_irq(irq) == gsi)
-			return irq;
+		if (info->u.pirq.gsi == gsi)
+			return info->irq;
 	}
 
 	return -1;
@@ -1374,7 +1402,8 @@ void xen_poll_irq(int irq)
 
 void xen_irq_resume(void)
 {
-	unsigned int cpu, irq, evtchn;
+	unsigned int cpu, evtchn;
+	struct irq_info *info;
 
 	init_evtchn_cpu_bindings();
 
@@ -1383,8 +1412,8 @@ void xen_irq_resume(void)
 		mask_evtchn(evtchn);
 
 	/* No IRQ <-> event-channel mappings. */
-	for (irq = 0; irq < nr_irqs; irq++)
-		irq_info[irq].evtchn = 0; /* zap event-channel binding */
+	list_for_each_entry(info, &xen_irq_list_head, list)
+		info->evtchn = 0; /* zap event-channel binding */
 
 	for (evtchn = 0; evtchn < NR_EVENT_CHANNELS; evtchn++)
 		evtchn_to_irq[evtchn] = -1;
-- 
1.5.6.5

