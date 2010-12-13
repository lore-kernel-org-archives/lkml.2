Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab0LMSCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:02:14 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47537 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0LMSCI (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 13 Dec 2010 13:02:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/9] xen: Check if the PCI device is owned by a domain different than DOMID_SELF.
Date: Mon, 13 Dec 2010 13:01:37 -0500
Message-Id: <1292263303-31680-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check if there is a domain owner for the PCI device. In case of failure
(meaning no domain has registered for this device) we make
DOMID_SELF the owner.

[v2: deal with rebasing on v2.6.37-1]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
---
 drivers/xen/events.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index a04da4b..96c93e7 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -40,6 +40,7 @@
 #include <asm/xen/pci.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
+#include <asm/xen/pci.h>
 
 #include <xen/xen.h>
 #include <xen/hvm.h>
@@ -97,6 +98,7 @@ struct irq_info
 			unsigned short gsi;
 			unsigned char vector;
 			unsigned char flags;
+			uint16_t domid;
 		} pirq;
 	} u;
 };
@@ -158,7 +160,8 @@ static struct irq_info mk_pirq_info(unsigned short evtchn, unsigned short pirq,
 {
 	return (struct irq_info) { .type = IRQT_PIRQ, .evtchn = evtchn,
 			.cpu = 0,
-			.u.pirq = { .pirq = pirq, .gsi = gsi, .vector = vector } };
+			.u.pirq = { .pirq = pirq, .gsi = gsi,
+				     .vector = vector, .domid = DOMID_SELF } };
 }
 
 /*
@@ -688,11 +691,16 @@ int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
 	int irq = -1;
 	struct physdev_map_pirq map_irq;
 	int rc;
+	domid_t domid;
 	int pos;
 	u32 table_offset, bir;
 
+	domid = rc = xen_find_device_domain_owner(dev);
+	if (rc < 0)
+		domid = DOMID_SELF;
+	
 	memset(&map_irq, 0, sizeof(map_irq));
-	map_irq.domid = DOMID_SELF;
+	map_irq.domid = domid;
 	map_irq.type = MAP_PIRQ_TYPE_MSI;
 	map_irq.index = -1;
 	map_irq.pirq = -1;
@@ -727,6 +735,8 @@ int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
 		goto out;
 	}
 	irq_info[irq] = mk_pirq_info(0, map_irq.pirq, 0, map_irq.index);
+	if (domid)
+		irq_info[irq].u.pirq.domid = domid;
 
 	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
 			handle_level_irq,
@@ -753,7 +763,7 @@ int xen_destroy_irq(int irq)
 
 	if (xen_initial_domain()) {
 		unmap_irq.pirq = info->u.pirq.gsi;
-		unmap_irq.domid = DOMID_SELF;
+		unmap_irq.domid = info->u.pirq.domid;
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);
 		if (rc) {
 			printk(KERN_WARNING "unmap irq failed %d\n", rc);
-- 
1.7.1

