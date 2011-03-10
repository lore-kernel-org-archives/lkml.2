Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1CJQIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:08:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:63084 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1CJQIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:08:36 -0500
X-IronPort-AV: E=Sophos;i="4.62,296,1297054800"; 
   d="scan'208";a="139621143"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 08/14] xen: events: turn irq_info constructors into initialiser functions
Date: Thu, 10 Mar 2011 16:08:09 +0000
Message-Id: <1299773295-348-8-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 10 Mar 2011 16:08:30.0526 (UTC) FILETIME=[65DE55E0:01CBDF3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |  104 +++++++++++++++++++++++++++++++------------------
 1 files changed, 66 insertions(+), 38 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2dffa43..72725fa 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -118,46 +118,76 @@ static struct irq_chip xen_dynamic_chip;
 static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
 
-/* Constructor for packed IRQ information. */
-static struct irq_info mk_unbound_info(void)
+/* Get info for IRQ */
+static struct irq_info *info_for_irq(unsigned irq)
 {
-	return (struct irq_info) { .type = IRQT_UNBOUND };
+	return &irq_info[irq];
 }
 
-static struct irq_info mk_evtchn_info(unsigned short evtchn)
+/* Constructors for packed IRQ information. */
+static void xen_irq_info_common_init(struct irq_info *info,
+				     enum xen_irq_type type,
+				     unsigned short evtchn,
+				     unsigned short cpu)
 {
-	return (struct irq_info) { .type = IRQT_EVTCHN, .evtchn = evtchn,
-			.cpu = 0 };
+
+	BUG_ON(info->type != IRQT_UNBOUND && info->type != type);
+
+	info->type = type;
+	info->evtchn = evtchn;
+	info->cpu = cpu;
 }
 
-static struct irq_info mk_ipi_info(unsigned short evtchn, enum ipi_vector ipi)
+static void xen_irq_info_evtchn_init(unsigned irq,
+				     unsigned short evtchn)
 {
-	return (struct irq_info) { .type = IRQT_IPI, .evtchn = evtchn,
-			.cpu = 0, .u.ipi = ipi };
+	struct irq_info *info = info_for_irq(irq);
+
+	xen_irq_info_common_init(info, IRQT_EVTCHN, evtchn, 0);
 }
 
-static struct irq_info mk_virq_info(unsigned short evtchn, unsigned short virq)
+static void xen_irq_info_ipi_init(unsigned irq,
+				  unsigned short evtchn,
+				  enum ipi_vector ipi)
 {
-	return (struct irq_info) { .type = IRQT_VIRQ, .evtchn = evtchn,
-			.cpu = 0, .u.virq = virq };
+	struct irq_info *info = info_for_irq(irq);
+
+	xen_irq_info_common_init(info, IRQT_IPI, evtchn, 0);
+
+	info->u.ipi = ipi;
 }
 
-static struct irq_info mk_pirq_info(unsigned short evtchn, unsigned short pirq,
-				    unsigned short gsi, unsigned short vector)
+static void xen_irq_info_virq_init(unsigned irq,
+				   unsigned short evtchn,
+				   unsigned short virq)
 {
-	return (struct irq_info) { .type = IRQT_PIRQ, .evtchn = evtchn,
-			.cpu = 0,
-			.u.pirq = { .pirq = pirq, .gsi = gsi, .vector = vector } };
+	struct irq_info *info = info_for_irq(irq);
+
+	xen_irq_info_common_init(info, IRQT_VIRQ, evtchn, 0);
+
+	info->u.virq = virq;
 }
 
-/*
- * Accessors for packed IRQ information.
- */
-static struct irq_info *info_for_irq(unsigned irq)
+static void xen_irq_info_pirq_init(unsigned irq,
+				   unsigned short evtchn,
+				   unsigned short pirq,
+				   unsigned short gsi,
+				   unsigned short vector,
+				   unsigned char flags)
 {
-	return &irq_info[irq];
+	struct irq_info *info = info_for_irq(irq);
+
+	xen_irq_info_common_init(info, IRQT_PIRQ, evtchn, 0);
+
+	info->u.pirq.pirq = pirq;
+	info->u.pirq.gsi = gsi;
+	info->u.pirq.vector = vector;
+	info->u.pirq.flags = flags;
 }
 
+/*
+ * Accessors for packed IRQ information.
+ */
 static unsigned int evtchn_from_irq(unsigned irq)
 {
 	if (unlikely(WARN(irq < 0 || irq >= nr_irqs, "Invalid irq %d!\n", irq)))
@@ -414,6 +444,8 @@ static int xen_allocate_irq_gsi(unsigned gsi)
 
 static void xen_free_irq(unsigned irq)
 {
+	irq_info[irq].type = IRQT_UNBOUND;
+
 	/* Legacy IRQ descriptors are managed by the arch. */
 	if (irq < NR_IRQS_LEGACY)
 		return;
@@ -610,8 +642,8 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 		goto out;
 	}
 
-	irq_info[irq] = mk_pirq_info(0, pirq, gsi, irq_op.vector);
-	irq_info[irq].u.pirq.flags |= shareable ? PIRQ_SHAREABLE : 0;
+	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector,
+			       shareable ? PIRQ_SHAREABLE : 0);
 	pirq_to_irq[pirq] = irq;
 
 out:
@@ -649,7 +681,7 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
 				      handle_level_irq, name);
 
-	irq_info[irq] = mk_pirq_info(0, pirq, 0, vector);
+	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, 0);
 	pirq_to_irq[pirq] = irq;
 	ret = set_irq_msi(irq, msidesc);
 	if (ret < 0)
@@ -688,8 +720,6 @@ int xen_destroy_irq(int irq)
 	}
 	pirq_to_irq[info->u.pirq.pirq] = -1;
 
-	irq_info[irq] = mk_unbound_info();
-
 	xen_free_irq(irq);
 
 out:
@@ -717,7 +747,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 					      handle_fasteoi_irq, "event");
 
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_evtchn_info(evtchn);
+		xen_irq_info_evtchn_init(irq, evtchn);
 	}
 
 	spin_unlock(&irq_mapping_update_lock);
@@ -750,7 +780,7 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 		evtchn = bind_ipi.port;
 
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_ipi_info(evtchn, ipi);
+		xen_irq_info_ipi_init(irq, evtchn, ipi);
 		per_cpu(ipi_to_irq, cpu)[ipi] = irq;
 
 		bind_evtchn_to_cpu(evtchn, cpu);
@@ -785,7 +815,7 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 		evtchn = bind_virq.port;
 
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_virq_info(evtchn, virq);
+		xen_irq_info_virq_init(irq, evtchn, virq);
 
 		per_cpu(virq_to_irq, cpu)[virq] = irq;
 
@@ -828,11 +858,9 @@ static void unbind_from_irq(unsigned int irq)
 		evtchn_to_irq[evtchn] = -1;
 	}
 
-	if (irq_info[irq].type != IRQT_UNBOUND) {
-		irq_info[irq] = mk_unbound_info();
+	BUG_ON(irq_info[irq].type == IRQT_UNBOUND);
 
-		xen_free_irq(irq);
-	}
+	xen_free_irq(irq);
 
 	spin_unlock(&irq_mapping_update_lock);
 }
@@ -1093,7 +1121,7 @@ void rebind_evtchn_irq(int evtchn, int irq)
 	BUG_ON(info->type == IRQT_UNBOUND);
 
 	evtchn_to_irq[evtchn] = irq;
-	irq_info[irq] = mk_evtchn_info(evtchn);
+	xen_irq_info_evtchn_init(irq, evtchn);
 
 	spin_unlock(&irq_mapping_update_lock);
 
@@ -1229,7 +1257,7 @@ static void restore_pirqs(void)
 		if (rc) {
 			printk(KERN_WARNING "xen map irq failed gsi=%d irq=%d pirq=%d rc=%d\n",
 					gsi, irq, pirq, rc);
-			irq_info[irq] = mk_unbound_info();
+			xen_free_irq(irq);
 			pirq_to_irq[pirq] = -1;
 			continue;
 		}
@@ -1261,7 +1289,7 @@ static void restore_cpu_virqs(unsigned int cpu)
 
 		/* Record the new mapping. */
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_virq_info(evtchn, virq);
+		xen_irq_info_virq_init(irq, evtchn, virq);
 		bind_evtchn_to_cpu(evtchn, cpu);
 	}
 }
@@ -1286,7 +1314,7 @@ static void restore_cpu_ipis(unsigned int cpu)
 
 		/* Record the new mapping. */
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_ipi_info(evtchn, ipi);
+		xen_irq_info_ipi_init(irq, evtchn, ipi);
 		bind_evtchn_to_cpu(evtchn, cpu);
 	}
 }
-- 
1.5.6.5

