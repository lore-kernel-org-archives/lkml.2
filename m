Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab1DNPb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:31:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65524 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab1DNPbZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Apr 2011 11:31:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/5] xen/irq: Check if the PCI device is owned by a domain different than DOMID_SELF.
Date: Thu, 14 Apr 2011 11:30:11 -0400
Message-Id: <1302795014-13289-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
References: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DA71349.0081:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check if there is a domain owner for the PCI device. In case of failure
(meaning no domain has registered for this device) we make DOMID_SELF the owner.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v2: deal with rebasing on v2.6.37-1]
[v3: deal with rebasing on stable/irq.cleanup]
[v4: deal with rebasing on stable/irq.ween_of_nr_irqs]
[v5: deal with rebasing on v2.6.39-rc3]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Xiantao Zhang <xiantao.zhang@intel.com>
---
 arch/x86/pci/xen.c   |   21 ++++++++++++++++-----
 drivers/xen/events.c |   12 ++++++++----
 include/xen/events.h |    3 ++-
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 6075f2d..393981f 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -108,7 +108,8 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		}
 		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, pirq, 0,
 					       (type == PCI_CAP_ID_MSIX) ?
-					       "msi-x" : "msi");
+					       "msi-x" : "msi",
+					       DOMID_SELF);
 		if (irq < 0)
 			goto error;
 		dev_dbg(&dev->dev,
@@ -148,7 +149,8 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, v[i], 0,
 					       (type == PCI_CAP_ID_MSIX) ?
 					       "pcifront-msi-x" :
-					       "pcifront-msi");
+					       "pcifront-msi",
+						DOMID_SELF);
 		if (irq < 0)
 			goto free;
 		i++;
@@ -190,9 +192,16 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		struct physdev_map_pirq map_irq;
+		domid_t domid;
+
+		domid = ret = xen_find_device_domain_owner(dev);
+		/* N.B. Casting int's -ENODEV to uint16_t results in 0xFFED,
+		 * hence check ret value for < 0. */
+		if (ret < 0)
+			domid = DOMID_SELF;
 
 		memset(&map_irq, 0, sizeof(map_irq));
-		map_irq.domid = DOMID_SELF;
+		map_irq.domid = domid;
 		map_irq.type = MAP_PIRQ_TYPE_MSI;
 		map_irq.index = -1;
 		map_irq.pirq = -1;
@@ -215,14 +224,16 @@ static int xen_initdom_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 		ret = HYPERVISOR_physdev_op(PHYSDEVOP_map_pirq, &map_irq);
 		if (ret) {
-			dev_warn(&dev->dev, "xen map irq failed %d\n", ret);
+			dev_warn(&dev->dev, "xen map irq failed %d for %d domain\n",
+				 ret, domid);
 			goto out;
 		}
 
 		ret = xen_bind_pirq_msi_to_irq(dev, msidesc,
 					       map_irq.pirq, map_irq.index,
 					       (type == PCI_CAP_ID_MSIX) ?
-					       "msi-x" : "msi");
+					       "msi-x" : "msi",
+						domid);
 		if (ret < 0)
 			goto out;
 	}
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 42d6c93..ac0e228 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -101,6 +101,7 @@ struct irq_info
 			unsigned short gsi;
 			unsigned char vector;
 			unsigned char flags;
+			uint16_t domid;
 		} pirq;
 	} u;
 };
@@ -184,6 +185,7 @@ static void xen_irq_info_pirq_init(unsigned irq,
 				   unsigned short pirq,
 				   unsigned short gsi,
 				   unsigned short vector,
+				   uint16_t domid,
 				   unsigned char flags)
 {
 	struct irq_info *info = info_for_irq(irq);
@@ -193,6 +195,7 @@ static void xen_irq_info_pirq_init(unsigned irq,
 	info->u.pirq.pirq = pirq;
 	info->u.pirq.gsi = gsi;
 	info->u.pirq.vector = vector;
+	info->u.pirq.domid = domid;
 	info->u.pirq.flags = flags;
 }
 
@@ -655,7 +658,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 		goto out;
 	}
 
-	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector,
+	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector, DOMID_SELF,
 			       shareable ? PIRQ_SHAREABLE : 0);
 
 out:
@@ -680,7 +683,8 @@ int xen_allocate_pirq_msi(struct pci_dev *dev, struct msi_desc *msidesc)
 }
 
 int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
-			     int pirq, int vector, const char *name)
+			     int pirq, int vector, const char *name,
+			     domid_t domid)
 {
 	int irq, ret;
 
@@ -693,7 +697,7 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_level_irq,
 				      name);
 
-	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, 0);
+	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, domid, 0);
 	ret = irq_set_msi_desc(irq, msidesc);
 	if (ret < 0)
 		goto error_irq;
@@ -722,7 +726,7 @@ int xen_destroy_irq(int irq)
 
 	if (xen_initial_domain()) {
 		unmap_irq.pirq = info->u.pirq.pirq;
-		unmap_irq.domid = DOMID_SELF;
+		unmap_irq.domid = info->u.pirq.domid;
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);
 		if (rc) {
 			printk(KERN_WARNING "unmap irq failed %d\n", rc);
diff --git a/include/xen/events.h b/include/xen/events.h
index f1b87ad..9aecc0b 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -85,7 +85,8 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 int xen_allocate_pirq_msi(struct pci_dev *dev, struct msi_desc *msidesc);
 /* Bind an PSI pirq to an irq. */
 int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
-			     int pirq, int vector, const char *name);
+			     int pirq, int vector, const char *name,
+			     domid_t domid);
 #endif
 
 /* De-allocates the above mentioned physical interrupt. */
-- 
1.7.1

