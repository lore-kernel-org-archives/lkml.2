Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1EFL00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 07:26:26 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:19499 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab1EFL0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 07:26:25 -0400
X-IronPort-AV: E=Sophos;i="4.64,325,1301889600"; 
   d="scan'208";a="147260106"
From: <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 1/2] xen: do not clear and mask evtchns in __xen_evtchn_do_upcall
Date: Fri, 6 May 2011 12:27:50 +0100
Message-ID: <1304681271-3836-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Change the irq handler of evtchns and pirqs that don't need EOI (pirqs
that correspond to physical edge interrupts) to handle_edge_irq.

Use handle_fasteoi_irq for pirqs that need eoi (they generally
correspond to level triggered irqs), no risk in loosing interrupts
because we have to EOI the irq anyway.

This change has the following benefits:

- it uses the very same handlers that Linux would use on native for the
same irqs (handle_edge_irq for edge irqs and msis, and
handle_fasteoi_irq for everything else);

- it uses these handlers in the same way native code would use them: it
let Linux mask\unmask and ack the irq when Linux want to mask\unmask
and ack the irq;

- it fixes a problem occurring when a driver calls disable_irq() in its
handler: the old code was unconditionally unmasking the evtchn even if
the irq is disabled when irq_eoi was called.

See Documentation/DocBook/genericirq.tmpl for more informations.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c |  113 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 73 insertions(+), 40 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 33167b4..bb59651 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -118,6 +118,8 @@ static DEFINE_PER_CPU(unsigned long [NR_EVENT_CHANNELS/BITS_PER_LONG],
 static struct irq_chip xen_dynamic_chip;
 static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
+static void enable_dynirq(struct irq_data *data);
+static void disable_dynirq(struct irq_data *data);
 
 /* Get info for IRQ */
 static struct irq_info *info_for_irq(unsigned irq)
@@ -473,16 +475,6 @@ static void xen_free_irq(unsigned irq)
 	irq_free_desc(irq);
 }
 
-static void pirq_unmask_notify(int irq)
-{
-	struct physdev_eoi eoi = { .irq = pirq_from_irq(irq) };
-
-	if (unlikely(pirq_needs_eoi(irq))) {
-		int rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
-		WARN_ON(rc);
-	}
-}
-
 static void pirq_query_unmask(int irq)
 {
 	struct physdev_irq_status_query irq_status;
@@ -506,6 +498,29 @@ static bool probing_irq(int irq)
 	return desc && desc->action == NULL;
 }
 
+static void eoi_pirq(struct irq_data *data)
+{
+	int evtchn = evtchn_from_irq(data->irq);
+ 	struct physdev_eoi eoi = { .irq = pirq_from_irq(data->irq) };
+	int rc = 0;
+
+	irq_move_irq(data);
+
+	if (VALID_EVTCHN(evtchn))
+		clear_evtchn(evtchn);
+
+	if (pirq_needs_eoi(data->irq)) {
+		rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
+		WARN_ON(rc);
+	}
+}
+
+static void mask_ack_pirq(struct irq_data *data)
+{
+	disable_dynirq(data);
+	eoi_pirq(data);
+}
+ 
 static unsigned int __startup_pirq(unsigned int irq)
 {
 	struct evtchn_bind_pirq bind_pirq;
@@ -539,7 +554,7 @@ static unsigned int __startup_pirq(unsigned int irq)
 
 out:
 	unmask_evtchn(evtchn);
-	pirq_unmask_notify(irq);
+	eoi_pirq(irq_get_irq_data(irq));
 
 	return 0;
 }
@@ -579,18 +594,7 @@ static void enable_pirq(struct irq_data *data)
 
 static void disable_pirq(struct irq_data *data)
 {
-}
-
-static void ack_pirq(struct irq_data *data)
-{
-	int evtchn = evtchn_from_irq(data->irq);
-
-	irq_move_irq(data);
-
-	if (VALID_EVTCHN(evtchn)) {
-		mask_evtchn(evtchn);
-		clear_evtchn(evtchn);
-	}
+	disable_dynirq(data);
 }
 
 static int find_irq_by_gsi(unsigned gsi)
@@ -639,9 +643,6 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 	if (irq < 0)
 		goto out;
 
-	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_level_irq,
-				      name);
-
 	irq_op.irq = irq;
 	irq_op.vector = 0;
 
@@ -658,6 +659,32 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector,
 			       shareable ? PIRQ_SHAREABLE : 0);
 
+	pirq_query_unmask(irq);
+	/* We try to use the handler with the appropriate semantic for the
+	 * type of interrupt: if the interrupt doesn't need an eoi
+	 * (pirq_needs_eoi returns false), we treat it like an edge
+	 * triggered interrupt so we use handle_edge_irq.
+	 * As a matter of fact this only happens when the corresponding
+	 * physical interrupt is edge triggered or an msi.
+	 *
+	 * On the other hand if the interrupt needs an eoi (pirq_needs_eoi
+	 * returns true) we treat it like a level triggered interrupt so we
+	 * use handle_fasteoi_irq like the native code does for this kind of
+	 * interrupts.
+	 * Depending on the Xen version, pirq_needs_eoi might return true
+	 * not only for level triggered interrupts but for edge triggered
+	 * interrupts too. In any case Xen always honors the eoi mechanism,
+	 * not injecting any more pirqs of the same kind if the first one
+	 * hasn't received an eoi yet. Therefore using the fasteoi handler
+	 * is the right choice either way.
+	 */
+	if (pirq_needs_eoi(irq))
+		irq_set_chip_and_handler_name(irq, &xen_pirq_chip,
+				handle_fasteoi_irq, name);
+	else
+		irq_set_chip_and_handler_name(irq, &xen_pirq_chip,
+				handle_edge_irq, name);
+
 out:
 	spin_unlock(&irq_mapping_update_lock);
 
@@ -690,8 +717,8 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	if (irq == -1)
 		goto out;
 
-	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_level_irq,
-				      name);
+	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_edge_irq,
+			name);
 
 	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, 0);
 	ret = irq_set_msi_desc(irq, msidesc);
@@ -773,7 +800,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 			goto out;
 
 		irq_set_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_fasteoi_irq, "event");
+					      handle_edge_irq, "event");
 
 		xen_irq_info_evtchn_init(irq, evtchn);
 	}
@@ -1179,9 +1206,6 @@ static void __xen_evtchn_do_upcall(void)
 				port = (word_idx * BITS_PER_LONG) + bit_idx;
 				irq = evtchn_to_irq[port];
 
-				mask_evtchn(port);
-				clear_evtchn(port);
-
 				if (irq != -1) {
 					desc = irq_to_desc(irq);
 					if (desc)
@@ -1337,12 +1361,18 @@ static void ack_dynirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
 
-	irq_move_masked_irq(data);
+	irq_move_irq(data);
 
 	if (VALID_EVTCHN(evtchn))
-		unmask_evtchn(evtchn);
+		clear_evtchn(evtchn);
 }
 
+static void mask_ack_dynirq(struct irq_data *data)
+{
+	disable_dynirq(data);
+	ack_dynirq(data);
+}
+ 
 static int retrigger_dynirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
@@ -1535,7 +1565,9 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.irq_mask		= disable_dynirq,
 	.irq_unmask		= enable_dynirq,
 
-	.irq_eoi		= ack_dynirq,
+	.irq_ack		= ack_dynirq,
+	.irq_mask_ack		= mask_ack_dynirq,
+
 	.irq_set_affinity	= set_affinity_irq,
 	.irq_retrigger		= retrigger_dynirq,
 };
@@ -1545,14 +1577,15 @@ static struct irq_chip xen_pirq_chip __read_mostly = {
 
 	.irq_startup		= startup_pirq,
 	.irq_shutdown		= shutdown_pirq,
-
 	.irq_enable		= enable_pirq,
-	.irq_unmask		= enable_pirq,
-
 	.irq_disable		= disable_pirq,
-	.irq_mask		= disable_pirq,
 
-	.irq_ack		= ack_pirq,
+	.irq_mask		= disable_dynirq,
+	.irq_unmask		= enable_dynirq,
+
+	.irq_ack		= eoi_pirq,
+	.irq_eoi		= eoi_pirq,
+	.irq_mask_ack		= mask_ack_pirq,
 
 	.irq_set_affinity	= set_affinity_irq,
 
-- 
1.7.2.3

