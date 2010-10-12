Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0JLQfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:35:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57076 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab0JLQfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:35:06 -0400
X-IronPort-AV: E=Sophos;i="4.57,320,1283745600"; 
   d="scan'208";a="117744594"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 1/7] xen: support pirq != irq
Date: Tue, 12 Oct 2010 17:34:43 +0100
Message-Id: <1286901289-8156-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
X-OriginalArrivalTime: 12 Oct 2010 16:35:04.0748 (UTC) FILETIME=[6C8C8EC0:01CB6A2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

PHYSDEVOP_map_pirq might return a pirq different from what we asked if
we are running as an HVM guest, so we need to be able to support pirqs
that are different from linux irqs.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c |   64 +++++++++++++++++++++++++++++++++++++------------
 include/xen/events.h |    1 +
 2 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index adad3a9..943f140 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -90,6 +90,7 @@ struct irq_info
 		unsigned short virq;
 		enum ipi_vector ipi;
 		struct {
+			unsigned short pirq;
 			unsigned short gsi;
 			unsigned char vector;
 			unsigned char flags;
@@ -100,6 +101,7 @@ struct irq_info
 #define PIRQ_SHAREABLE	(1 << 1)
 
 static struct irq_info *irq_info;
+static int *pirq_to_irq;
 
 static int *evtchn_to_irq;
 struct cpu_evtchn_s {
@@ -147,11 +149,12 @@ static struct irq_info mk_virq_info(unsigned short evtchn, unsigned short virq)
 			.cpu = 0, .u.virq = virq };
 }
 
-static struct irq_info mk_pirq_info(unsigned short evtchn,
+static struct irq_info mk_pirq_info(unsigned short evtchn, unsigned short pirq,
 				    unsigned short gsi, unsigned short vector)
 {
 	return (struct irq_info) { .type = IRQT_PIRQ, .evtchn = evtchn,
-			.cpu = 0, .u.pirq = { .gsi = gsi, .vector = vector } };
+			.cpu = 0,
+			.u.pirq = { .pirq = pirq, .gsi = gsi, .vector = vector } };
 }
 
 /*
@@ -193,6 +196,16 @@ static unsigned virq_from_irq(unsigned irq)
 	return info->u.virq;
 }
 
+static unsigned pirq_from_irq(unsigned irq)
+{
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info == NULL);
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	return info->u.pirq.pirq;
+}
+
 static unsigned gsi_from_irq(unsigned irq)
 {
 	struct irq_info *info = info_for_irq(irq);
@@ -365,6 +378,16 @@ static int get_nr_hw_irqs(void)
 	return ret;
 }
 
+static int find_unbound_pirq(void)
+{
+	int i;
+	for (i = 0; i < nr_irqs; i++) {
+		if (pirq_to_irq[i] < 0)
+			return i;
+	}
+	return -1;
+}
+
 static int find_unbound_irq(void)
 {
 	int irq;
@@ -411,7 +434,7 @@ static bool identity_mapped_irq(unsigned irq)
 
 static void pirq_unmask_notify(int irq)
 {
-	struct physdev_eoi eoi = { .irq = irq };
+	struct physdev_eoi eoi = { .irq = pirq_from_irq(irq) };
 
 	if (unlikely(pirq_needs_eoi(irq))) {
 		int rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
@@ -426,7 +449,7 @@ static void pirq_query_unmask(int irq)
 
 	BUG_ON(info->type != IRQT_PIRQ);
 
-	irq_status.irq = irq;
+	irq_status.irq = pirq_from_irq(irq);
 	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
 		irq_status.flags = 0;
 
@@ -454,7 +477,7 @@ static unsigned int startup_pirq(unsigned int irq)
 	if (VALID_EVTCHN(evtchn))
 		goto out;
 
-	bind_pirq.pirq = irq;
+	bind_pirq.pirq = pirq_from_irq(irq);
 	/* NB. We are happy to share unless we are probing. */
 	bind_pirq.flags = info->u.pirq.flags & PIRQ_SHAREABLE ?
 					BIND_PIRQ__WILL_SHARE : 0;
@@ -557,28 +580,32 @@ static int find_irq_by_gsi(unsigned gsi)
 	return -1;
 }
 
-/* xen_allocate_irq might allocate irqs from the top down, as a
+int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
+{
+	return xen_map_pirq_gsi(gsi, gsi, shareable, name);
+}
+
+/* xen_map_pirq_gsi might allocate irqs from the top down, as a
  * consequence don't assume that the irq number returned has a low value
  * or can be used as a pirq number unless you know otherwise.
  *
- * One notable exception is when xen_allocate_irq is called passing an
+ * One notable exception is when xen_map_pirq_gsi is called passing an
  * hardware gsi as argument, in that case the irq number returned
- * matches the gsi number passed as first argument.
-
- * Note: We don't assign an
- * event channel until the irq actually started up.  Return an
- * existing irq if we've already got one for the gsi.
+ * matches the gsi number passed as second argument.
+ *
+ * Note: We don't assign an event channel until the irq actually started
+ * up.  Return an existing irq if we've already got one for the gsi.
  */
-int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
+int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 {
-	int irq;
+	int irq = 0;
 	struct physdev_irq irq_op;
 
 	spin_lock(&irq_mapping_update_lock);
 
 	irq = find_irq_by_gsi(gsi);
 	if (irq != -1) {
-		printk(KERN_INFO "xen_allocate_pirq: returning irq %d for gsi %u\n",
+		printk(KERN_INFO "xen_map_pirq_gsi: returning irq %d for gsi %u\n",
 		       irq, gsi);
 		goto out;	/* XXX need refcount? */
 	}
@@ -608,8 +635,9 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 		goto out;
 	}
 
-	irq_info[irq] = mk_pirq_info(0, gsi, irq_op.vector);
+	irq_info[irq] = mk_pirq_info(0, pirq, gsi, irq_op.vector);
 	irq_info[irq].u.pirq.flags |= shareable ? PIRQ_SHAREABLE : 0;
+	pirq_to_irq[pirq] = irq;
 
 out:
 	spin_unlock(&irq_mapping_update_lock);
@@ -1329,6 +1357,10 @@ void __init xen_init_IRQ(void)
 				    GFP_KERNEL);
 	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
 
+	pirq_to_irq = kcalloc(nr_irqs, sizeof(*pirq_to_irq), GFP_KERNEL);
+	for (i = 0; i < nr_irqs; i++)
+		pirq_to_irq[i] = -1;
+
 	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
 				    GFP_KERNEL);
 	for (i = 0; i < NR_EVENT_CHANNELS; i++)
diff --git a/include/xen/events.h b/include/xen/events.h
index c1717ca..deec8fa 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -71,6 +71,7 @@ void xen_hvm_evtchn_do_upcall(void);
  * GSIs are identity mapped; others are dynamically allocated as
  * usual. */
 int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
+int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
 
 /* De-allocates the above mentioned physical interrupt. */
 int xen_destroy_irq(int irq);
-- 
1.5.6.5

