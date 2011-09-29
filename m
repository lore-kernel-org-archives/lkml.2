Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab1I2Tyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:54:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36371 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab1I2TxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:53:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/9] xen/irq: If we fail during msi_capability_init return proper error code.
Date: Thu, 29 Sep 2011 15:52:48 -0400
Message-Id: <1317325971-21603-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E84CC9E.00F1:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three different modes: PV, HVM, and initial domain 0. In all
the cases we would return -1 for failure instead of a proper error code.
Fix this by propagating the error code from the generic IRQ code.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/pci/xen.c   |   10 +++++++---
 drivers/xen/events.c |    7 ++++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 1017c7b..11a9301 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -175,8 +175,10 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 					       "pcifront-msi-x" :
 					       "pcifront-msi",
 						DOMID_SELF);
-		if (irq < 0)
+		if (irq < 0) {
+			ret = irq;
 			goto free;
+		}
 		i++;
 	}
 	kfree(v);
@@ -221,8 +223,10 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		if (msg.data != XEN_PIRQ_MSI_DATA ||
 		    xen_irq_from_pirq(pirq) < 0) {
 			pirq = xen_allocate_pirq_msi(dev, msidesc);
-			if (pirq < 0)
+			if (pirq < 0) {
+				irq = -ENODEV;
 				goto error;
+			}
 			xen_msi_compose_msg(dev, pirq, &msg);
 			__write_msi_msg(msidesc, &msg);
 			dev_dbg(&dev->dev, "xen: msi bound to pirq=%d\n", pirq);
@@ -244,7 +248,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 error:
 	dev_err(&dev->dev,
 		"Xen PCI frontend has not registered MSI/MSI-X support!\n");
-	return -ENODEV;
+	return irq;
 }
 
 #ifdef CONFIG_XEN_DOM0
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 71d2363..93c69ee 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -432,7 +432,8 @@ static int __must_check xen_allocate_irq_dynamic(void)
 
 	irq = irq_alloc_desc_from(first, -1);
 
-	xen_irq_init(irq);
+	if (irq >= 0)
+		xen_irq_init(irq);
 
 	return irq;
 }
@@ -713,7 +714,7 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	mutex_lock(&irq_mapping_update_lock);
 
 	irq = xen_allocate_irq_dynamic();
-	if (irq == -1)
+	if (irq < 0)
 		goto out;
 
 	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_edge_irq,
@@ -729,7 +730,7 @@ out:
 error_irq:
 	mutex_unlock(&irq_mapping_update_lock);
 	xen_free_irq(irq);
-	return -1;
+	return ret;
 }
 #endif
 
-- 
1.7.4.1

