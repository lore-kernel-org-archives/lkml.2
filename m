Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1CJQIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:08:55 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:63084 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1CJQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:08:38 -0500
X-IronPort-AV: E=Sophos;i="4.62,296,1297054800"; 
   d="scan'208";a="139621149"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 09/14] xen: events: push setup of irq<->{evtchn,ipi,virq,pirq} maps into irq_info init functions
Date: Thu, 10 Mar 2011 16:08:10 +0000
Message-Id: <1299773295-348-9-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 10 Mar 2011 16:08:32.0385 (UTC) FILETIME=[66F9FF10:01CBDF3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encapsulate setup of XXX_to_irq array in the relevant
xen_irq_info_*_init function.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 72725fa..cf372d4 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -126,6 +126,7 @@ static struct irq_info *info_for_irq(unsigned irq)
 
 /* Constructors for packed IRQ information. */
 static void xen_irq_info_common_init(struct irq_info *info,
+				     unsigned irq,
 				     enum xen_irq_type type,
 				     unsigned short evtchn,
 				     unsigned short cpu)
@@ -136,6 +137,8 @@ static void xen_irq_info_common_init(struct irq_info *info,
 	info->type = type;
 	info->evtchn = evtchn;
 	info->cpu = cpu;
+
+	evtchn_to_irq[evtchn] = irq;
 }
 
 static void xen_irq_info_evtchn_init(unsigned irq,
@@ -143,29 +146,35 @@ static void xen_irq_info_evtchn_init(unsigned irq,
 {
 	struct irq_info *info = info_for_irq(irq);
 
-	xen_irq_info_common_init(info, IRQT_EVTCHN, evtchn, 0);
+	xen_irq_info_common_init(info, irq, IRQT_EVTCHN, evtchn, 0);
 }
 
-static void xen_irq_info_ipi_init(unsigned irq,
+static void xen_irq_info_ipi_init(unsigned cpu,
+				  unsigned irq,
 				  unsigned short evtchn,
 				  enum ipi_vector ipi)
 {
 	struct irq_info *info = info_for_irq(irq);
 
-	xen_irq_info_common_init(info, IRQT_IPI, evtchn, 0);
+	xen_irq_info_common_init(info, irq, IRQT_IPI, evtchn, 0);
 
 	info->u.ipi = ipi;
+
+	per_cpu(ipi_to_irq, cpu)[ipi] = irq;
 }
 
-static void xen_irq_info_virq_init(unsigned irq,
+static void xen_irq_info_virq_init(unsigned cpu,
+				   unsigned irq,
 				   unsigned short evtchn,
 				   unsigned short virq)
 {
 	struct irq_info *info = info_for_irq(irq);
 
-	xen_irq_info_common_init(info, IRQT_VIRQ, evtchn, 0);
+	xen_irq_info_common_init(info, irq, IRQT_VIRQ, evtchn, 0);
 
 	info->u.virq = virq;
+
+	per_cpu(virq_to_irq, cpu)[virq] = irq;
 }
 
 static void xen_irq_info_pirq_init(unsigned irq,
@@ -177,12 +186,14 @@ static void xen_irq_info_pirq_init(unsigned irq,
 {
 	struct irq_info *info = info_for_irq(irq);
 
-	xen_irq_info_common_init(info, IRQT_PIRQ, evtchn, 0);
+	xen_irq_info_common_init(info, irq, IRQT_PIRQ, evtchn, 0);
 
 	info->u.pirq.pirq = pirq;
 	info->u.pirq.gsi = gsi;
 	info->u.pirq.vector = vector;
 	info->u.pirq.flags = flags;
+
+	pirq_to_irq[pirq] = irq;
 }
 
 /*
@@ -644,7 +655,6 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 
 	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector,
 			       shareable ? PIRQ_SHAREABLE : 0);
-	pirq_to_irq[pirq] = irq;
 
 out:
 	spin_unlock(&irq_mapping_update_lock);
@@ -682,7 +692,6 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 				      handle_level_irq, name);
 
 	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, 0);
-	pirq_to_irq[pirq] = irq;
 	ret = set_irq_msi(irq, msidesc);
 	if (ret < 0)
 		goto error_irq;
@@ -746,7 +755,6 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
 					      handle_fasteoi_irq, "event");
 
-		evtchn_to_irq[evtchn] = irq;
 		xen_irq_info_evtchn_init(irq, evtchn);
 	}
 
@@ -779,9 +787,7 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 			BUG();
 		evtchn = bind_ipi.port;
 
-		evtchn_to_irq[evtchn] = irq;
-		xen_irq_info_ipi_init(irq, evtchn, ipi);
-		per_cpu(ipi_to_irq, cpu)[ipi] = irq;
+		xen_irq_info_ipi_init(cpu, irq, evtchn, ipi);
 
 		bind_evtchn_to_cpu(evtchn, cpu);
 	}
@@ -814,10 +820,7 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 			BUG();
 		evtchn = bind_virq.port;
 
-		evtchn_to_irq[evtchn] = irq;
-		xen_irq_info_virq_init(irq, evtchn, virq);
-
-		per_cpu(virq_to_irq, cpu)[virq] = irq;
+		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
 
 		bind_evtchn_to_cpu(evtchn, cpu);
 	}
@@ -1120,7 +1123,6 @@ void rebind_evtchn_irq(int evtchn, int irq)
 	   so there should be a proper type */
 	BUG_ON(info->type == IRQT_UNBOUND);
 
-	evtchn_to_irq[evtchn] = irq;
 	xen_irq_info_evtchn_init(irq, evtchn);
 
 	spin_unlock(&irq_mapping_update_lock);
@@ -1288,8 +1290,7 @@ static void restore_cpu_virqs(unsigned int cpu)
 		evtchn = bind_virq.port;
 
 		/* Record the new mapping. */
-		evtchn_to_irq[evtchn] = irq;
-		xen_irq_info_virq_init(irq, evtchn, virq);
+		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
 		bind_evtchn_to_cpu(evtchn, cpu);
 	}
 }
@@ -1313,8 +1314,7 @@ static void restore_cpu_ipis(unsigned int cpu)
 		evtchn = bind_ipi.port;
 
 		/* Record the new mapping. */
-		evtchn_to_irq[evtchn] = irq;
-		xen_irq_info_ipi_init(irq, evtchn, ipi);
+		xen_irq_info_ipi_init(cpu, irq, evtchn, ipi);
 		bind_evtchn_to_cpu(evtchn, cpu);
 	}
 }
-- 
1.5.6.5

