Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0LASYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:24:17 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25448 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab0LASXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:23:55 -0500
X-IronPort-AV: E=Sophos;i="4.59,284,1288584000"; 
   d="scan'208";a="124875292"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 4/5] xen: fix save/restore for PV on HVM guests with pirq remapping
Date: Wed,  1 Dec 2010 18:23:29 +0000
Message-Id: <1291227810-15094-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
References: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
X-OriginalArrivalTime: 01 Dec 2010 18:23:54.0423 (UTC) FILETIME=[E9316470:01CB9184]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Re-map and re-bind all the pirqs at resume time.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index f78945c..f34288a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1293,6 +1293,42 @@ static int retrigger_dynirq(unsigned int irq)
 	return ret;
 }
 
+static void restore_cpu_pirqs(void)
+{
+	int pirq, rc, irq, gsi;
+	struct physdev_map_pirq map_irq;
+
+	for (pirq = 0; pirq < nr_irqs; pirq++) {
+		irq = pirq_to_irq[pirq];
+		if (irq == -1)
+			continue;
+
+		/* save/restore of PT devices doesn't work, so at this point the
+		 * only devices present are GSI based emulated devices */
+		gsi = gsi_from_irq(irq);
+		if (!gsi)
+			continue;
+
+		map_irq.domid = DOMID_SELF;
+		map_irq.type = MAP_PIRQ_TYPE_GSI;
+		map_irq.index = gsi;
+		map_irq.pirq = pirq;
+
+		rc = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
+		if (rc) {
+			printk(KERN_WARNING "xen map irq failed gsi=%d irq=%d pirq=%d rc=%d\n",
+					gsi, irq, pirq, rc);
+			irq_info[irq] = mk_unbound_info();
+			pirq_to_irq[pirq] = -1;
+			continue;
+		}
+
+		printk(KERN_DEBUG "xen: --> irq=%d, pirq=%d\n", irq, map_irq.pirq);
+
+		startup_pirq(irq);
+	}
+}
+
 static void restore_cpu_virqs(unsigned int cpu)
 {
 	struct evtchn_bind_virq bind_virq;
@@ -1436,6 +1472,8 @@ void xen_irq_resume(void)
 
 		unmask_evtchn(evtchn);
 	}
+
+	restore_cpu_pirqs();
 }
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
-- 
1.5.6.5

