Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab0JYQXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:23:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44360 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab0JYQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:23:42 -0400
X-IronPort-AV: E=Sophos;i="4.58,236,1286164800"; 
   d="scan'208";a="119590667"
From: Ian Campbell <ian.campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 2/5] xen: events: turn irq_info constructors into initialiser functions
Date: Mon, 25 Oct 2010 17:23:30 +0100
Message-Id: <1288023813-31989-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 25 Oct 2010 16:23:41.0353 (UTC) FILETIME=[FC958190:01CB7460]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |  102 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 65 insertions(+), 37 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index c8f3e43..33fae3d 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -129,46 +129,76 @@ static struct irq_chip xen_dynamic_chip;
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
 	return info_for_irq(irq)->evtchn;
@@ -416,6 +446,7 @@ static void xen_irq_alloc_specific(unsigned irq)
 
 static void xen_irq_free(unsigned irq)
 {
+	irq_info[irq].type = IRQT_UNBOUND;
 	irq_free_desc(irq);
 }
 
@@ -635,8 +666,8 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 		goto out;
 	}
 
-	irq_info[irq] = mk_pirq_info(0, pirq, gsi, irq_op.vector);
-	irq_info[irq].u.pirq.flags |= shareable ? PIRQ_SHAREABLE : 0;
+	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector,
+			       shareable ? PIRQ_SHAREABLE : 0);
 	pirq_to_irq[pirq] = irq;
 
 out:
@@ -664,7 +695,7 @@ void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
 	set_irq_chip_and_handler_name(*irq, &xen_pirq_chip,
 				      handle_level_irq, name);
 
-	irq_info[*irq] = mk_pirq_info(0, *pirq, 0, 0);
+	xen_irq_info_pirq_init(*irq, 0, *pirq, 0, 0, 0);
 	pirq_to_irq[*pirq] = *irq;
 
 out:
@@ -714,7 +745,7 @@ int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
 		irq = -1;
 		goto out;
 	}
-	irq_info[irq] = mk_pirq_info(0, map_irq.pirq, 0, map_irq.index);
+	xen_irq_info_pirq_init(irq, 0, map_irq.pirq, 0, map_irq.index, 0);
 
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
 			handle_level_irq,
@@ -748,7 +779,6 @@ int xen_destroy_irq(int irq)
 			goto out;
 		}
 	}
-	irq_info[irq] = mk_unbound_info();
 
 	xen_irq_free(irq);
 
@@ -782,7 +812,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 					      handle_fasteoi_irq, "event");
 
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_evtchn_info(evtchn);
+		xen_irq_info_evtchn_init(irq, evtchn);
 	}
 
 	spin_unlock(&irq_mapping_update_lock);
@@ -815,7 +845,7 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 		evtchn = bind_ipi.port;
 
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_ipi_info(evtchn, ipi);
+		xen_irq_info_ipi_init(irq, evtchn, ipi);
 		per_cpu(ipi_to_irq, cpu)[ipi] = irq;
 
 		bind_evtchn_to_cpu(evtchn, cpu);
@@ -850,7 +880,7 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 		evtchn = bind_virq.port;
 
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_virq_info(evtchn, virq);
+		xen_irq_info_virq_init(irq, evtchn, virq);
 
 		per_cpu(virq_to_irq, cpu)[virq] = irq;
 
@@ -893,11 +923,9 @@ static void unbind_from_irq(unsigned int irq)
 		evtchn_to_irq[evtchn] = -1;
 	}
 
-	if (irq_info[irq].type != IRQT_UNBOUND) {
-		irq_info[irq] = mk_unbound_info();
+	BUG_ON(irq_info[irq].type == IRQT_UNBOUND);
 
-		xen_irq_free(irq);
-	}
+	xen_irq_free(irq);
 
 	spin_unlock(&irq_mapping_update_lock);
 }
@@ -1158,7 +1186,7 @@ void rebind_evtchn_irq(int evtchn, int irq)
 	BUG_ON(info->type == IRQT_UNBOUND);
 
 	evtchn_to_irq[evtchn] = irq;
-	irq_info[irq] = mk_evtchn_info(evtchn);
+	xen_irq_info_evtchn_init(irq, evtchn);
 
 	spin_unlock(&irq_mapping_update_lock);
 
@@ -1285,7 +1313,7 @@ static void restore_cpu_virqs(unsigned int cpu)
 
 		/* Record the new mapping. */
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_virq_info(evtchn, virq);
+		xen_irq_info_virq_init(irq, evtchn, virq);
 		bind_evtchn_to_cpu(evtchn, cpu);
 
 		/* Ready for use. */
@@ -1313,7 +1341,7 @@ static void restore_cpu_ipis(unsigned int cpu)
 
 		/* Record the new mapping. */
 		evtchn_to_irq[evtchn] = irq;
-		irq_info[irq] = mk_ipi_info(evtchn, ipi);
+		xen_irq_info_ipi_init(irq, evtchn, ipi);
 		bind_evtchn_to_cpu(evtchn, cpu);
 
 		/* Ready for use. */
-- 
1.5.6.5

