Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1CJQJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:09:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50370 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1CJQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:08:38 -0500
X-IronPort-AV: E=Sophos;i="4.62,296,1297054800"; 
   d="scan'208";a="139621160"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 11/14] xen: events: dynamically allocate irq info structures
Date: Thu, 10 Mar 2011 16:08:12 +0000
Message-Id: <1299773295-348-11-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 10 Mar 2011 16:08:35.0916 (UTC) FILETIME=[6914C8C0:01CBDF3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes nr_irq sized array allocation at start of day.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index e119989..002283e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -107,7 +107,6 @@ struct irq_info
 #define PIRQ_NEEDS_EOI	(1 << 0)
 #define PIRQ_SHAREABLE	(1 << 1)
 
-static struct irq_info *irq_info;
 static int *pirq_to_irq;
 
 static int *evtchn_to_irq;
@@ -125,7 +124,7 @@ static struct irq_chip xen_pirq_chip;
 /* Get info for IRQ */
 static struct irq_info *info_for_irq(unsigned irq)
 {
-	return &irq_info[irq];
+	return get_irq_data(irq);
 }
 
 /* Constructors for packed IRQ information. */
@@ -309,7 +308,7 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
 	clear_bit(chn, per_cpu(cpu_evtchn_mask, cpu_from_irq(irq)));
 	set_bit(chn, per_cpu(cpu_evtchn_mask, cpu));
 
-	irq_info[irq].cpu = cpu;
+	info_for_irq(irq)->cpu = cpu;
 }
 
 static void init_evtchn_cpu_bindings(void)
@@ -328,7 +327,6 @@ static void init_evtchn_cpu_bindings(void)
 	for_each_possible_cpu(i)
 		memset(per_cpu(cpu_evtchn_mask, i),
 		       (i == 0) ? ~0 : 0, sizeof(*per_cpu(cpu_evtchn_mask, i)));
-
 }
 
 static inline void clear_evtchn(int port)
@@ -411,10 +409,14 @@ static void xen_irq_init(unsigned irq)
 	/* By default all event channels notify CPU#0. */
 	cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
 
-	info = &irq_info[irq];
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (info == NULL)
+		panic("Unable to allocate metadata for IRQ%d\n", irq);
 
 	info->type = IRQT_UNBOUND;
 
+	set_irq_data(irq, info);
+
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
 
@@ -481,12 +483,14 @@ static int xen_allocate_irq_gsi(unsigned gsi)
 
 static void xen_free_irq(unsigned irq)
 {
-	struct irq_info *info = &irq_info[irq];
-
-	info->type = IRQT_UNBOUND;
+	struct irq_info *info = get_irq_data(irq);
 
 	list_del(&info->list);
 
+	set_irq_data(irq, NULL);
+
+	kfree(info);
+
 	/* Legacy IRQ descriptors are managed by the arch. */
 	if (irq < NR_IRQS_LEGACY)
 		return;
@@ -649,10 +653,9 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 
 	spin_lock(&irq_mapping_update_lock);
 
-	if ((pirq > nr_irqs) || (gsi > nr_irqs)) {
-		printk(KERN_WARNING "xen_map_pirq_gsi: %s %s is incorrect!\n",
-			pirq > nr_irqs ? "pirq" :"",
-			gsi > nr_irqs ? "gsi" : "");
+	if (pirq > nr_irqs) {
+		printk(KERN_WARNING "xen_map_pirq_gsi: pirq %d > nr_irqs %d!\n",
+		       pirq, nr_irqs);
 		goto out;
 	}
 
@@ -889,7 +892,7 @@ static void unbind_from_irq(unsigned int irq)
 		evtchn_to_irq[evtchn] = -1;
 	}
 
-	BUG_ON(irq_info[irq].type == IRQT_UNBOUND);
+	BUG_ON(info_for_irq(irq)->type == IRQT_UNBOUND);
 
 	xen_free_irq(irq);
 
@@ -1509,8 +1512,6 @@ void __init xen_init_IRQ(void)
 {
 	int i;
 
-	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
-
 	/* We are using nr_irqs as the maximum number of pirq available but
 	 * that number is actually chosen by Xen and we don't know exactly
 	 * what it is. Be careful choosing high pirq numbers. */
-- 
1.5.6.5

