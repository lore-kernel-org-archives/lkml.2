Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab0JLPzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:55:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31542 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab0JLPve (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:51:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/23] xen: implement pirq type event channels
Date: Tue, 12 Oct 2010 11:44:11 -0400
Message-Id: <1286898271-32018-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

A privileged PV Xen domain can get direct access to hardware.  In
order for this to be useful, it must be able to get hardware
interrupts.

Being a PV Xen domain, all interrupts are delivered as event channels.
PIRQ event channels are bound to a pirq number and an interrupt
vector.  When a IO APIC raises a hardware interrupt on that vector, it
is delivered as an event channel, which we can deliver to the
appropriate device driver(s).

This patch simply implements the infrastructure for dealing with pirq
event channels.

[ Impact: integrate hardware interrupts into Xen's event scheme ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |  243 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/xen/events.h |   11 +++
 2 files changed, 252 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 13365ba..b8f030a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -16,7 +16,7 @@
  *    (typically dom0).
  * 2. VIRQs, typically used for timers.  These are per-cpu events.
  * 3. IPIs.
- * 4. Hardware interrupts. Not supported at present.
+ * 4. PIRQs - Hardware interrupts.
  *
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
@@ -46,6 +46,9 @@
 #include <xen/interface/hvm/hvm_op.h>
 #include <xen/interface/hvm/params.h>
 
+/* Leave low irqs free for identity mapping */
+#define LEGACY_IRQS	16
+
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -89,10 +92,12 @@ struct irq_info
 		enum ipi_vector ipi;
 		struct {
 			unsigned short gsi;
-			unsigned short vector;
+			unsigned char vector;
+			unsigned char flags;
 		} pirq;
 	} u;
 };
+#define PIRQ_NEEDS_EOI	(1 << 0)
 
 static struct irq_info irq_info[NR_IRQS];
 
@@ -113,6 +118,7 @@ static inline unsigned long *cpu_evtchn_mask(int cpu)
 
 static struct irq_chip xen_dynamic_chip;
 static struct irq_chip xen_percpu_chip;
+static struct irq_chip xen_pirq_chip;
 
 /* Constructor for packed IRQ information. */
 static struct irq_info mk_unbound_info(void)
@@ -225,6 +231,15 @@ static unsigned int cpu_from_evtchn(unsigned int evtchn)
 	return ret;
 }
 
+static bool pirq_needs_eoi(unsigned irq)
+{
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	return info->u.pirq.flags & PIRQ_NEEDS_EOI;
+}
+
 static inline unsigned long active_evtchns(unsigned int cpu,
 					   struct shared_info *sh,
 					   unsigned int idx)
@@ -366,6 +381,210 @@ static int find_unbound_irq(void)
 	return irq;
 }
 
+static bool identity_mapped_irq(unsigned irq)
+{
+	/* only identity map legacy irqs */
+	return irq < LEGACY_IRQS;
+}
+
+static void pirq_unmask_notify(int irq)
+{
+	struct physdev_eoi eoi = { .irq = irq };
+
+	if (unlikely(pirq_needs_eoi(irq))) {
+		int rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
+		WARN_ON(rc);
+	}
+}
+
+static void pirq_query_unmask(int irq)
+{
+	struct physdev_irq_status_query irq_status;
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	irq_status.irq = irq;
+	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
+		irq_status.flags = 0;
+
+	info->u.pirq.flags &= ~PIRQ_NEEDS_EOI;
+	if (irq_status.flags & XENIRQSTAT_needs_eoi)
+		info->u.pirq.flags |= PIRQ_NEEDS_EOI;
+}
+
+static bool probing_irq(int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	return desc && desc->action == NULL;
+}
+
+static unsigned int startup_pirq(unsigned int irq)
+{
+	struct evtchn_bind_pirq bind_pirq;
+	struct irq_info *info = info_for_irq(irq);
+	int evtchn = evtchn_from_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	if (VALID_EVTCHN(evtchn))
+		goto out;
+
+	bind_pirq.pirq = irq;
+	/* NB. We are happy to share unless we are probing. */
+	bind_pirq.flags = probing_irq(irq) ? 0 : BIND_PIRQ__WILL_SHARE;
+	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq) != 0) {
+		if (!probing_irq(irq))
+			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
+			       irq);
+		return 0;
+	}
+	evtchn = bind_pirq.port;
+
+	pirq_query_unmask(irq);
+
+	evtchn_to_irq[evtchn] = irq;
+	bind_evtchn_to_cpu(evtchn, 0);
+	info->evtchn = evtchn;
+
+out:
+	unmask_evtchn(evtchn);
+	pirq_unmask_notify(irq);
+
+	return 0;
+}
+
+static void shutdown_pirq(unsigned int irq)
+{
+	struct evtchn_close close;
+	struct irq_info *info = info_for_irq(irq);
+	int evtchn = evtchn_from_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	if (!VALID_EVTCHN(evtchn))
+		return;
+
+	mask_evtchn(evtchn);
+
+	close.port = evtchn;
+	if (HYPERVISOR_event_channel_op(EVTCHNOP_close, &close) != 0)
+		BUG();
+
+	bind_evtchn_to_cpu(evtchn, 0);
+	evtchn_to_irq[evtchn] = -1;
+	info->evtchn = 0;
+}
+
+static void enable_pirq(unsigned int irq)
+{
+	startup_pirq(irq);
+}
+
+static void disable_pirq(unsigned int irq)
+{
+}
+
+static void ack_pirq(unsigned int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+
+	move_native_irq(irq);
+
+	if (VALID_EVTCHN(evtchn)) {
+		mask_evtchn(evtchn);
+		clear_evtchn(evtchn);
+	}
+}
+
+static void end_pirq(unsigned int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (WARN_ON(!desc))
+		return;
+
+	if ((desc->status & (IRQ_DISABLED|IRQ_PENDING)) ==
+	    (IRQ_DISABLED|IRQ_PENDING)) {
+		shutdown_pirq(irq);
+	} else if (VALID_EVTCHN(evtchn)) {
+		unmask_evtchn(evtchn);
+		pirq_unmask_notify(irq);
+	}
+}
+
+static int find_irq_by_gsi(unsigned gsi)
+{
+	int irq;
+
+	for (irq = 0; irq < NR_IRQS; irq++) {
+		struct irq_info *info = info_for_irq(irq);
+
+		if (info == NULL || info->type != IRQT_PIRQ)
+			continue;
+
+		if (gsi_from_irq(irq) == gsi)
+			return irq;
+	}
+
+	return -1;
+}
+
+/*
+ * Allocate a physical irq, along with a vector.  We don't assign an
+ * event channel until the irq actually started up.  Return an
+ * existing irq if we've already got one for the gsi.
+ */
+int xen_allocate_pirq(unsigned gsi)
+{
+	int irq;
+	struct physdev_irq irq_op;
+
+	spin_lock(&irq_mapping_update_lock);
+
+	irq = find_irq_by_gsi(gsi);
+	if (irq != -1) {
+		printk(KERN_INFO "xen_allocate_pirq: returning irq %d for gsi %u\n",
+		       irq, gsi);
+		goto out;	/* XXX need refcount? */
+	}
+
+	if (identity_mapped_irq(gsi)) {
+		irq = gsi;
+		dynamic_irq_init(irq);
+	} else
+		irq = find_unbound_irq();
+
+	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
+				      handle_level_irq, "pirq");
+
+	irq_op.irq = irq;
+	if (HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
+		dynamic_irq_cleanup(irq);
+		irq = -ENOSPC;
+		goto out;
+	}
+
+	irq_info[irq] = mk_pirq_info(0, gsi, irq_op.vector);
+
+out:
+	spin_unlock(&irq_mapping_update_lock);
+
+	return irq;
+}
+
+int xen_vector_from_irq(unsigned irq)
+{
+	return vector_from_irq(irq);
+}
+
+int xen_gsi_from_irq(unsigned irq)
+{
+	return gsi_from_irq(irq);
+}
+
 int bind_evtchn_to_irq(unsigned int evtchn)
 {
 	int irq;
@@ -965,6 +1184,26 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.retrigger	= retrigger_dynirq,
 };
 
+static struct irq_chip xen_pirq_chip __read_mostly = {
+	.name		= "xen-pirq",
+
+	.startup	= startup_pirq,
+	.shutdown	= shutdown_pirq,
+
+	.enable		= enable_pirq,
+	.unmask		= enable_pirq,
+
+	.disable	= disable_pirq,
+	.mask		= disable_pirq,
+
+	.ack		= ack_pirq,
+	.end		= end_pirq,
+
+	.set_affinity	= set_affinity_irq,
+
+	.retrigger	= retrigger_dynirq,
+};
+
 static struct irq_chip xen_percpu_chip __read_mostly = {
 	.name		= "xen-percpu",
 
diff --git a/include/xen/events.h b/include/xen/events.h
index a15d932..8f62320 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -63,4 +63,15 @@ int xen_set_callback_via(uint64_t via);
 void xen_evtchn_do_upcall(struct pt_regs *regs);
 void xen_hvm_evtchn_do_upcall(void);
 
+/* Allocate an irq for a physical interrupt, given a gsi.  "Legacy"
+ * GSIs are identity mapped; others are dynamically allocated as
+ * usual. */
+int xen_allocate_pirq(unsigned gsi);
+
+/* Return vector allocated to pirq */
+int xen_vector_from_irq(unsigned pirq);
+
+/* Return gsi allocated to pirq */
+int xen_gsi_from_irq(unsigned pirq);
+
 #endif	/* _XEN_EVENTS_H */
-- 
1.7.0.4

