Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0H3LUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:20:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:55789 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0H3LUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:20:44 -0400
X-IronPort-AV: E=Sophos;i="4.56,292,1280721600"; 
   d="scan'208";a="111744717"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad.wilk@oracle.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/7] xen: support pirq != irq
Date: Mon, 30 Aug 2010 12:21:10 +0100
Message-Id: <1283167276-7364-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop>
References: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop>
X-OriginalArrivalTime: 30 Aug 2010 11:20:39.0064 (UTC) FILETIME=[5FF66180:01CB4835]
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
 drivers/xen/events.c |   49 +++++++++++++++++++++++++++++++++++++++++--------
 include/xen/events.h |    1 +
 2 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 395fd19..a5c30db 100644
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
@@ -146,11 +148,12 @@ static struct irq_info mk_virq_info(unsigned short evtchn, unsigned short virq)
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
@@ -192,6 +195,16 @@ static unsigned virq_from_irq(unsigned irq)
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
@@ -364,6 +377,16 @@ static int get_nr_hw_irqs(void)
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
@@ -410,7 +433,7 @@ static bool identity_mapped_irq(unsigned irq)
 
 static void pirq_unmask_notify(int irq)
 {
-	struct physdev_eoi eoi = { .irq = irq };
+	struct physdev_eoi eoi = { .irq = pirq_from_irq(irq) };
 
 	if (unlikely(pirq_needs_eoi(irq))) {
 		int rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
@@ -425,7 +448,7 @@ static void pirq_query_unmask(int irq)
 
 	BUG_ON(info->type != IRQT_PIRQ);
 
-	irq_status.irq = irq;
+	irq_status.irq = pirq_from_irq(irq);
 	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
 		irq_status.flags = 0;
 
@@ -453,7 +476,7 @@ static unsigned int startup_pirq(unsigned int irq)
 	if (VALID_EVTCHN(evtchn))
 		goto out;
 
-	bind_pirq.pirq = irq;
+	bind_pirq.pirq = pirq_from_irq(irq);
 	/* NB. We are happy to share unless we are probing. */
 	bind_pirq.flags = info->u.pirq.flags & PIRQ_SHAREABLE ?
 					BIND_PIRQ__WILL_SHARE : 0;
@@ -556,12 +579,17 @@ static int find_irq_by_gsi(unsigned gsi)
 	return -1;
 }
 
+int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
+{
+	return xen_map_pirq_gsi(gsi, gsi, shareable, name);
+}
+
 /*
  * Allocate a physical irq, along with a vector.  We don't assign an
  * event channel until the irq actually started up.  Return an
  * existing irq if we've already got one for the gsi.
  */
-int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
+int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 {
 	int irq;
 	struct physdev_irq irq_op;
@@ -570,7 +598,7 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 
 	irq = find_irq_by_gsi(gsi);
 	if (irq != -1) {
-		printk(KERN_INFO "xen_allocate_pirq: returning irq %d for gsi %u\n",
+		printk(KERN_INFO "xen_map_pirq_gsi: returning irq %d for gsi %u\n",
 		       irq, gsi);
 		goto out;	/* XXX need refcount? */
 	}
@@ -600,8 +628,9 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 		goto out;
 	}
 
-	irq_info[irq] = mk_pirq_info(0, gsi, irq_op.vector);
+	irq_info[irq] = mk_pirq_info(0, pirq, gsi, irq_op.vector);
 	irq_info[irq].u.pirq.flags |= shareable ? PIRQ_SHAREABLE : 0;
+	pirq_to_irq[pirq] = irq;
 
 out:
 	spin_unlock(&irq_mapping_update_lock);
@@ -1311,6 +1340,10 @@ void __init xen_init_IRQ(void)
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
index 2f70de4..b276c38 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -71,6 +71,7 @@ void xen_hvm_evtchn_do_upcall(void);
    GSIs are identity mapped; others are dynamically allocated as
    usual. */
 int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
+int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
 
 /* De-allocates the above mentioned physical interrupt. */
 int xen_destroy_irq(int irq);
-- 
1.5.6.5

