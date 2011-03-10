Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1CJQIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:08:54 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50370 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1CJQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:08:38 -0500
X-IronPort-AV: E=Sophos;i="4.62,296,1297054800"; 
   d="scan'208";a="139621165"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 12/14] xen: events: remove use of nr_irqs as upper bound on number of pirqs
Date: Thu, 10 Mar 2011 16:08:13 +0000
Message-Id: <1299773295-348-12-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 10 Mar 2011 16:08:37.0604 (UTC) FILETIME=[6A165A40:01CBDF3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't really much relationship between the two, other than
nr_irqs often being the larger of the two.

Allows us to remove a nr_irqs sized array, the only users of this
array are MSI setup and restore, neither of which are particularly
performance critical.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   59 +++++++++++++++++++++----------------------------
 1 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 002283e..6782251 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -107,8 +107,6 @@ struct irq_info
 #define PIRQ_NEEDS_EOI	(1 << 0)
 #define PIRQ_SHAREABLE	(1 << 1)
 
-static int *pirq_to_irq;
-
 static int *evtchn_to_irq;
 
 static DEFINE_PER_CPU(unsigned long [NR_EVENT_CHANNELS/BITS_PER_LONG],
@@ -196,8 +194,6 @@ static void xen_irq_info_pirq_init(unsigned irq,
 	info->u.pirq.gsi = gsi;
 	info->u.pirq.vector = vector;
 	info->u.pirq.flags = flags;
-
-	pirq_to_irq[pirq] = irq;
 }
 
 /*
@@ -247,16 +243,6 @@ static unsigned pirq_from_irq(unsigned irq)
 	return info->u.pirq.pirq;
 }
 
-static unsigned gsi_from_irq(unsigned irq)
-{
-	struct irq_info *info = info_for_irq(irq);
-
-	BUG_ON(info == NULL);
-	BUG_ON(info->type != IRQT_PIRQ);
-
-	return info->u.pirq.gsi;
-}
-
 static enum xen_irq_type type_from_irq(unsigned irq)
 {
 	return info_for_irq(irq)->type;
@@ -653,12 +639,6 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 
 	spin_lock(&irq_mapping_update_lock);
 
-	if (pirq > nr_irqs) {
-		printk(KERN_WARNING "xen_map_pirq_gsi: pirq %d > nr_irqs %d!\n",
-		       pirq, nr_irqs);
-		goto out;
-	}
-
 	irq = find_irq_by_gsi(gsi);
 	if (irq != -1) {
 		printk(KERN_INFO "xen_map_pirq_gsi: returning irq %d for gsi %u\n",
@@ -758,7 +738,6 @@ int xen_destroy_irq(int irq)
 			goto out;
 		}
 	}
-	pirq_to_irq[info->u.pirq.pirq] = -1;
 
 	xen_free_irq(irq);
 
@@ -769,7 +748,24 @@ out:
 
 int xen_irq_from_pirq(unsigned pirq)
 {
-	return pirq_to_irq[pirq];
+	int irq;
+
+	struct irq_info *info;
+
+	spin_lock(&irq_mapping_update_lock);
+
+	list_for_each_entry(info, &xen_irq_list_head, list) {
+		if (info == NULL || info->type != IRQT_PIRQ)
+			continue;
+		irq = info->irq;
+		if (info->u.pirq.pirq == pirq)
+			goto out;
+	}
+	irq = -1;
+out:
+	spin_lock(&irq_mapping_update_lock);
+
+	return irq;
 }
 
 int bind_evtchn_to_irq(unsigned int evtchn)
@@ -1269,15 +1265,18 @@ static void restore_pirqs(void)
 {
 	int pirq, rc, irq, gsi;
 	struct physdev_map_pirq map_irq;
+	struct irq_info *info;
 
-	for (pirq = 0; pirq < nr_irqs; pirq++) {
-		irq = pirq_to_irq[pirq];
-		if (irq == -1)
+	list_for_each_entry(info, &xen_irq_list_head, list) {
+		if (info->type != IRQT_PIRQ)
 			continue;
 
+		pirq = info->u.pirq.pirq;
+		gsi = info->u.pirq.gsi;
+		irq = info->irq;
+
 		/* save/restore of PT devices doesn't work, so at this point the
 		 * only devices present are GSI based emulated devices */
-		gsi = gsi_from_irq(irq);
 		if (!gsi)
 			continue;
 
@@ -1291,7 +1290,6 @@ static void restore_pirqs(void)
 			printk(KERN_WARNING "xen map irq failed gsi=%d irq=%d pirq=%d rc=%d\n",
 					gsi, irq, pirq, rc);
 			xen_free_irq(irq);
-			pirq_to_irq[pirq] = -1;
 			continue;
 		}
 
@@ -1512,13 +1510,6 @@ void __init xen_init_IRQ(void)
 {
 	int i;
 
-	/* We are using nr_irqs as the maximum number of pirq available but
-	 * that number is actually chosen by Xen and we don't know exactly
-	 * what it is. Be careful choosing high pirq numbers. */
-	pirq_to_irq = kcalloc(nr_irqs, sizeof(*pirq_to_irq), GFP_KERNEL);
-	for (i = 0; i < nr_irqs; i++)
-		pirq_to_irq[i] = -1;
-
 	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
 				    GFP_KERNEL);
 	for (i = 0; i < NR_EVENT_CHANNELS; i++)
-- 
1.5.6.5

