Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1BPWTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:19:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21180 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab1BPWTF (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Feb 2011 17:19:05 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] Xen PCI fronted fixes for 2.6.39
Date: Wed, 16 Feb 2011 17:17:15 -0500
Message-Id: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0203.4D5C4D4F.0007:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am proposing these three patches for 2.6.39.

The first is to take advantage of the new method of requesting
a Linux IRQ and providing the Xen PIRQ value. The second
makes it possible for a PV guest to bootup if the backend has provided
incorrect values. [*2]

Lastly, the third is to remove deprecated code.

Konrad Rzeszutek Wilk (2):
      pci/xen: Use xen_allocate_pirq_msi
      xen-pcifront: Sanity check the MSI/MSI-X values

Tejun Heo (1):
      xen-pcifront: don't use flush_scheduled_work()

 arch/x86/pci/xen.c         |    6 +++---
 drivers/pci/xen-pcifront.c |   20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 25cd4a0..6432f75 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -157,14 +157,14 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		goto error;
 	i = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
+		xen_allocate_pirq_msi(
 			(type == PCI_CAP_ID_MSIX) ?
-			"pcifront-msi-x" : "pcifront-msi");
+			"pcifront-msi-x" : "pcifront-msi",
+			&irq, &v[i], XEN_ALLOC_IRQ);
 		if (irq < 0) {
 			ret = -1;
 			goto free;
 		}
-
 		ret = set_irq_msi(irq, msidesc);
 		if (ret)
 			goto error_while;
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 3a5a6fc..dd615d9 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -277,13 +277,20 @@ static int pci_frontend_enable_msix(struct pci_dev *dev,
 	if (likely(!err)) {
 		if (likely(!op.value)) {
 			/* we get the result */
-			for (i = 0; i < nvec; i++)
+			for (i = 0; i < nvec; i++) {
+				if (op.msix_entries[i].vector <= 0) {
+					dev_warn(&dev->dev, "MSI-X entry %d" \
+						" is zero!\n", i);
+					err = -EINVAL;
+					continue;
+				}
 				*(*vector+i) = op.msix_entries[i].vector;
-			return 0;
+			}
+			return err;
 		} else {
 			printk(KERN_DEBUG "enable msix get value %x\n",
 				op.value);
-			return op.value;
+			return err;
 		}
 	} else {
 		dev_err(&dev->dev, "enable msix get err %x\n", err);
@@ -325,6 +332,10 @@ static int pci_frontend_enable_msi(struct pci_dev *dev, int **vector)
 	err = do_pci_op(pdev, &op);
 	if (likely(!err)) {
 		*(*vector) = op.value;
+		if (op.value <= 0) {
+			dev_warn(&dev->dev, "MSI entry is zero!\n");
+			err = -EINVAL;
+		}
 	} else {
 		dev_err(&dev->dev, "pci frontend enable msi failed for dev "
 				    "%x:%x\n", op.bus, op.devfn);
@@ -733,8 +744,7 @@ static void free_pdev(struct pcifront_device *pdev)
 
 	pcifront_free_roots(pdev);
 
-	/*For PCIE_AER error handling job*/
-	flush_scheduled_work();
+	cancel_work_sync(&pdev->op_work);
 
 	if (pdev->irq >= 0)
 		unbind_from_irqhandler(pdev->irq, pdev);


[*2]: as so:

    0.877864] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.20-k2
[    0.877874] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    0.877957] e1000e 0000:00:00.0: enabling device (0000 -> 0002)
[    0.878054] e1000e 0000:00:00.0: Xen PCI mapped GSI16 to IRQ27
[    0.878056] e1000e 0000:00:00.0: setting latency timer to 64
[    0.879924] e1000e 0000:00:00.0: MSI-X entry 0 is zero!
[    0.879935] e1000e 0000:00:00.0: MSI-X entry 1 is zero!
[    0.879940] e1000e 0000:00:00.0: MSI-X entry 2 is zero!
[    0.880207] e1000e 0000:00:00.0: (unregistered net_device): Failed to initialize MSI-X interrupts.  Falling back to MSI interrupts.
[    0.880730] e1000e 0000:00:00.0: MSI entry is zero!
[    0.880788] e1000e 0000:00:00.0: (unregistered net_device): Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
[    0.880945] e1000e 0000:00:00.0: Disabling ASPM L0s 
[    0.977188] e1000e 0000:00:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1b:21:61:49:00
[    0.977201] e1000e 0000:00:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    0.977217] e1000e 0000:00:00.0: eth0: MAC: 3, PHY: 8, PBA No: E46981-003
...
