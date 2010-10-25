Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0JYQXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:23:41 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44360 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab0JYQXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:23:40 -0400
X-IronPort-AV: E=Sophos;i="4.58,236,1286164800"; 
   d="scan'208";a="119590661"
From: Ian Campbell <ian.campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 1/5] xen: events: use irq_alloc_desc(_at) instead of open-coding an IRQ allocator.
Date: Mon, 25 Oct 2010 17:23:29 +0100
Message-Id: <1288023813-31989-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 25 Oct 2010 16:23:39.0384 (UTC) FILETIME=[FB690F80:01CB7460]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encapsulate allocate and free in xen_irq_alloc and xen_irq_free.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   68 ++++++++++++++++++++-----------------------------
 1 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 97612f5..c8f3e43 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -394,41 +394,29 @@ static int find_unbound_pirq(void)
 	return -1;
 }
 
-static int find_unbound_irq(void)
+static int xen_irq_alloc(void)
 {
-	struct irq_data *data;
-	int irq, res;
-	int start = get_nr_hw_irqs();
+	int irq = irq_alloc_desc(0);
 
-	if (start == nr_irqs)
-		goto no_irqs;
-
-	/* nr_irqs is a magic value. Must not use it.*/
-	for (irq = nr_irqs-1; irq > start; irq--) {
-		data = irq_get_irq_data(irq);
-		/* only 0->15 have init'd desc; handle irq > 16 */
-		if (!data)
-			break;
-		if (data->chip == &no_irq_chip)
-			break;
-		if (data->chip != &xen_dynamic_chip)
-			continue;
-		if (irq_info[irq].type == IRQT_UNBOUND)
-			return irq;
-	}
-
-	if (irq == start)
-		goto no_irqs;
+	if (irq < 0)
+		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
-	res = irq_alloc_desc_at(irq, 0);
+	return irq;
+}
 
-	if (WARN_ON(res != irq))
-		return -1;
+static void xen_irq_alloc_specific(unsigned irq)
+{
+	int res = irq_alloc_desc_at(irq, 0);
 
-	return irq;
+	if (res < 0)
+		panic("No available IRQ: increase nr_irqs!\n");
+	if (res != irq)
+		panic("Unable to allocate to IRQ%d\n", irq);
+}
 
-no_irqs:
-	panic("No available IRQ to bind to: increase nr_irqs!\n");
+static void xen_irq_free(unsigned irq)
+{
+	irq_free_desc(irq);
 }
 
 static bool identity_mapped_irq(unsigned irq)
@@ -627,9 +615,9 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 	if (identity_mapped_irq(gsi) || (!xen_initial_domain() &&
 				xen_pv_domain())) {
 		irq = gsi;
-		irq_alloc_desc_at(irq, 0);
+		xen_irq_alloc_specific(irq);
 	} else
-		irq = find_unbound_irq();
+		irq = xen_irq_alloc();
 
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
 				      handle_level_irq, name);
@@ -642,7 +630,7 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 	 * this in the priv domain. */
 	if (xen_initial_domain() &&
 	    HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
-		irq_free_desc(irq);
+		xen_irq_free(irq);
 		irq = -ENOSPC;
 		goto out;
 	}
@@ -665,7 +653,7 @@ void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
 {
 	spin_lock(&irq_mapping_update_lock);
 
-	*irq = find_unbound_irq();
+	*irq = xen_irq_alloc();
 	if (*irq == -1)
 		goto out;
 
@@ -712,7 +700,7 @@ int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
 
 	spin_lock(&irq_mapping_update_lock);
 
-	irq = find_unbound_irq();
+	irq = xen_irq_alloc();
 
 	if (irq == -1)
 		goto out;
@@ -721,7 +709,7 @@ int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
 	if (rc) {
 		printk(KERN_WARNING "xen map irq failed %d\n", rc);
 
-		irq_free_desc(irq);
+		xen_irq_free(irq);
 
 		irq = -1;
 		goto out;
@@ -762,7 +750,7 @@ int xen_destroy_irq(int irq)
 	}
 	irq_info[irq] = mk_unbound_info();
 
-	irq_free_desc(irq);
+	xen_irq_free(irq);
 
 out:
 	spin_unlock(&irq_mapping_update_lock);
@@ -788,7 +776,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 	irq = evtchn_to_irq[evtchn];
 
 	if (irq == -1) {
-		irq = find_unbound_irq();
+		irq = xen_irq_alloc();
 
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
 					      handle_fasteoi_irq, "event");
@@ -813,7 +801,7 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 	irq = per_cpu(ipi_to_irq, cpu)[ipi];
 
 	if (irq == -1) {
-		irq = find_unbound_irq();
+		irq = xen_irq_alloc();
 		if (irq < 0)
 			goto out;
 
@@ -849,7 +837,7 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 	irq = per_cpu(virq_to_irq, cpu)[virq];
 
 	if (irq == -1) {
-		irq = find_unbound_irq();
+		irq = xen_irq_alloc();
 
 		set_irq_chip_and_handler_name(irq, &xen_percpu_chip,
 					      handle_percpu_irq, "virq");
@@ -908,7 +896,7 @@ static void unbind_from_irq(unsigned int irq)
 	if (irq_info[irq].type != IRQT_UNBOUND) {
 		irq_info[irq] = mk_unbound_info();
 
-		irq_free_desc(irq);
+		xen_irq_free(irq);
 	}
 
 	spin_unlock(&irq_mapping_update_lock);
-- 
1.5.6.5

