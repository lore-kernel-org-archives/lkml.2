Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0JYQXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:23:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44360 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab0JYQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:23:43 -0400
X-IronPort-AV: E=Sophos;i="4.58,236,1286164800"; 
   d="scan'208";a="119590672"
From: Ian Campbell <ian.campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 3/5] xen: events: push setup of irq<->{evtchn,pirq} maps into irq_info init functions
Date: Mon, 25 Oct 2010 17:23:31 +0100
Message-Id: <1288023813-31989-3-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 25 Oct 2010 16:23:43.0384 (UTC) FILETIME=[FDCB6980:01CB7460]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 33fae3d..94055ea 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -137,6 +137,7 @@ static struct irq_info *info_for_irq(unsigned irq)
 
 /* Constructors for packed IRQ information. */
 static void xen_irq_info_common_init(struct irq_info *info,
+				     unsigned irq,
 				     enum xen_irq_type type,
 				     unsigned short evtchn,
 				     unsigned short cpu)
@@ -147,6 +148,8 @@ static void xen_irq_info_common_init(struct irq_info *info,
 	info->type = type;
 	info->evtchn = evtchn;
 	info->cpu = cpu;
+
+	evtchn_to_irq[evtchn] = irq;
 }
 
 static void xen_irq_info_evtchn_init(unsigned irq,
@@ -154,7 +157,7 @@ static void xen_irq_info_evtchn_init(unsigned irq,
 {
 	struct irq_info *info = info_for_irq(irq);
 
-	xen_irq_info_common_init(info, IRQT_EVTCHN, evtchn, 0);
+	xen_irq_info_common_init(info, irq, IRQT_EVTCHN, evtchn, 0);
 }
 
 static void xen_irq_info_ipi_init(unsigned irq,
@@ -163,18 +166,17 @@ static void xen_irq_info_ipi_init(unsigned irq,
 {
 	struct irq_info *info = info_for_irq(irq);
 
-	xen_irq_info_common_init(info, IRQT_IPI, evtchn, 0);
+	xen_irq_info_common_init(info, irq, IRQT_IPI, evtchn, 0);
 
 	info->u.ipi = ipi;
 }
-
 static void xen_irq_info_virq_init(unsigned irq,
 				   unsigned short evtchn,
 				   unsigned short virq)
 {
 	struct irq_info *info = info_for_irq(irq);
 
-	xen_irq_info_common_init(info, IRQT_VIRQ, evtchn, 0);
+	xen_irq_info_common_init(info, irq, IRQT_VIRQ, evtchn, 0);
 
 	info->u.virq = virq;
 }
@@ -188,12 +190,14 @@ static void xen_irq_info_pirq_init(unsigned irq,
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
@@ -668,11 +672,9 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 
 	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector,
 			       shareable ? PIRQ_SHAREABLE : 0);
-	pirq_to_irq[pirq] = irq;
 
 out:
 	spin_unlock(&irq_mapping_update_lock);
-
 	return irq;
 }
 
@@ -696,7 +698,6 @@ void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
 				      handle_level_irq, name);
 
 	xen_irq_info_pirq_init(*irq, 0, *pirq, 0, 0, 0);
-	pirq_to_irq[*pirq] = *irq;
 
 out:
 	spin_unlock(&irq_mapping_update_lock);
@@ -811,7 +812,6 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
 					      handle_fasteoi_irq, "event");
 
-		evtchn_to_irq[evtchn] = irq;
 		xen_irq_info_evtchn_init(irq, evtchn);
 	}
 
@@ -844,7 +844,6 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 			BUG();
 		evtchn = bind_ipi.port;
 
-		evtchn_to_irq[evtchn] = irq;
 		xen_irq_info_ipi_init(irq, evtchn, ipi);
 		per_cpu(ipi_to_irq, cpu)[ipi] = irq;
 
@@ -879,7 +878,6 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 			BUG();
 		evtchn = bind_virq.port;
 
-		evtchn_to_irq[evtchn] = irq;
 		xen_irq_info_virq_init(irq, evtchn, virq);
 
 		per_cpu(virq_to_irq, cpu)[virq] = irq;
@@ -1185,7 +1183,6 @@ void rebind_evtchn_irq(int evtchn, int irq)
 	   so there should be a proper type */
 	BUG_ON(info->type == IRQT_UNBOUND);
 
-	evtchn_to_irq[evtchn] = irq;
 	xen_irq_info_evtchn_init(irq, evtchn);
 
 	spin_unlock(&irq_mapping_update_lock);
@@ -1312,7 +1309,6 @@ static void restore_cpu_virqs(unsigned int cpu)
 		evtchn = bind_virq.port;
 
 		/* Record the new mapping. */
-		evtchn_to_irq[evtchn] = irq;
 		xen_irq_info_virq_init(irq, evtchn, virq);
 		bind_evtchn_to_cpu(evtchn, cpu);
 
@@ -1340,7 +1336,6 @@ static void restore_cpu_ipis(unsigned int cpu)
 		evtchn = bind_ipi.port;
 
 		/* Record the new mapping. */
-		evtchn_to_irq[evtchn] = irq;
 		xen_irq_info_ipi_init(irq, evtchn, ipi);
 		bind_evtchn_to_cpu(evtchn, cpu);
 
-- 
1.5.6.5

