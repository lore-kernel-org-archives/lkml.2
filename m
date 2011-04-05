Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1DEMJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:09:38 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:31145 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab1DEMJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:09:35 -0400
X-IronPort-AV: E=Sophos;i="4.63,304,1299456000"; 
   d="scan'208";a="5144772"
Date: Tue, 5 Apr 2011 13:10:47 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Thomas Gleixner <tglx@linutronix.de>
CC: <xen-devel@lists.xensource.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3] xen: do not clear and mask evtchns in
 __xen_evtchn_do_upcall
Message-ID: <alpine.DEB.2.00.1104051254530.16492@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,
I am trying to make the xen event channel handling code more consistent
with the corresponding native code: use the same irq handlers that the
native code would use for the same kind of interrupts, and use the
handlers in the same way.

A bit of informations about xen event channels: xen exports two bitmaps
in the shared_info page, one is used by xen to set which evtchn was
triggered (the bit has to be cleared by the guest to receive more evtchns
of the same kind); the other one is used by the guest to mask/unmask one
or more evtchns.
We used to unconditionally clear and mask an evtchn in the upcall
function even before calling the corresponding irq handler, because this
minimizes the amount of time during which we cannot receive any
notifications. However it messes with the semantic of the irq handler
and for this reason I want to remove it and make a better use of the irq
handlers to achieve the same results.
 
Considering your expertise in the area, I would appreciate any input you
can give me.

Thanks,

Stefano

---

commit cca177d06e0a0ffb40bdf22a434229974a31f862
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Tue Mar 29 14:15:06 2011 +0000

    xen: do not clear and mask evtchns in __xen_evtchn_do_upcall
    
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

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 036343b..67b8027 100644
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
@@ -572,27 +587,6 @@ static void shutdown_pirq(struct irq_data *data)
 	info->evtchn = 0;
 }
 
-static void enable_pirq(struct irq_data *data)
-{
-	startup_pirq(data);
-}
-
-static void disable_pirq(struct irq_data *data)
-{
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
-}
-
 static int find_irq_by_gsi(unsigned gsi)
 {
 	struct irq_info *info;
@@ -639,9 +633,6 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 	if (irq < 0)
 		goto out;
 
-	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_level_irq,
-				      name);
-
 	irq_op.irq = irq;
 	irq_op.vector = 0;
 
@@ -658,6 +649,32 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
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
 
@@ -690,8 +707,8 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	if (irq == -1)
 		goto out;
 
-	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_level_irq,
-				      name);
+	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_edge_irq,
+			name);
 
 	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, 0);
 	ret = irq_set_msi_desc(irq, msidesc);
@@ -773,7 +790,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 			goto out;
 
 		irq_set_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_fasteoi_irq, "event");
+					      handle_edge_irq, "event");
 
 		xen_irq_info_evtchn_init(irq, evtchn);
 	}
@@ -1181,9 +1198,6 @@ static void __xen_evtchn_do_upcall(void)
 				port = (word_idx * BITS_PER_LONG) + bit_idx;
 				irq = evtchn_to_irq[port];
 
-				mask_evtchn(port);
-				clear_evtchn(port);
-
 				if (irq != -1) {
 					desc = irq_to_desc(irq);
 					if (desc)
@@ -1339,12 +1353,18 @@ static void ack_dynirq(struct irq_data *data)
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
@@ -1533,11 +1553,12 @@ void xen_irq_resume(void)
 static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.name			= "xen-dyn",
 
-	.irq_disable		= disable_dynirq,
 	.irq_mask		= disable_dynirq,
 	.irq_unmask		= enable_dynirq,
 
-	.irq_eoi		= ack_dynirq,
+	.irq_ack		= ack_dynirq,
+	.irq_mask_ack		= mask_ack_dynirq,
+
 	.irq_set_affinity	= set_affinity_irq,
 	.irq_retrigger		= retrigger_dynirq,
 };
@@ -1548,13 +1569,12 @@ static struct irq_chip xen_pirq_chip __read_mostly = {
 	.irq_startup		= startup_pirq,
 	.irq_shutdown		= shutdown_pirq,
 
-	.irq_enable		= enable_pirq,
-	.irq_unmask		= enable_pirq,
-
-	.irq_disable		= disable_pirq,
-	.irq_mask		= disable_pirq,
+	.irq_mask		= disable_dynirq,
+	.irq_unmask		= enable_dynirq,
 
-	.irq_ack		= ack_pirq,
+	.irq_ack		= eoi_pirq,
+	.irq_eoi		= eoi_pirq,
+	.irq_mask_ack		= mask_ack_pirq,
 
 	.irq_set_affinity	= set_affinity_irq,
 
