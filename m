Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2BTJHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 04:07:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:4711 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab2BTJHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 04:07:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108566926"
From: Alex Shi <alex.shi@intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org, andiry.xu@amd.com,
        clemens@ladisch.de, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] USB: Try MSI first before line IRQ for Intel PCIe USB3 HCD
Date: Mon, 20 Feb 2012 17:05:31 +0800
Message-Id: <1329728733-32419-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1329728733-32419-1-git-send-email-alex.shi@intel.com>
References: <1329728733-32419-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

We have a PCI USB xhci host controller on a new platform. It doesn't
have a line IRQ definition in BIOS. The Linux driver refuses to
initial this controller, but Windows works well because it only depends
on MSI.

Actually, Linux also can work for MSI. This patch skips the first line
IRQ checking for our HCD in usb-core pci probe, then try to enable MSI
firstly. That make this HCD works well under Linux.

This patch should be backported to kernels as old as 2.6.32.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/usb/core/hcd-pci.c |    5 ++++-
 drivers/usb/core/hcd.c     |    6 ++++--
 drivers/usb/host/xhci.c    |    5 +++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index d136b8f..81e2c0d 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -187,7 +187,10 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		return -ENODEV;
 	dev->current_state = PCI_D0;
 
-	if (!dev->irq) {
+	/* The xHCI driver supports MSI and MSI-X,
+	 * so don't fail if the BIOS doesn't provide a legacy IRQ.
+	 */
+	if (!dev->irq && (driver->flags & HCD_MASK) != HCD_USB3) {
 		dev_err(&dev->dev,
 			"Found HC with no IRQ.  Check BIOS/PCI %s setup!\n",
 			pci_name(dev));
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index eb19cba..e128232 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2447,8 +2447,10 @@ int usb_add_hcd(struct usb_hcd *hcd,
 			&& device_can_wakeup(&hcd->self.root_hub->dev))
 		dev_dbg(hcd->self.controller, "supports USB remote wakeup\n");
 
-	/* enable irqs just before we start the controller */
-	if (usb_hcd_is_primary_hcd(hcd)) {
+	/* enable irqs just before we start the controller,
+	 * if the BIOS provides legacy PCI irqs.
+	 */
+	if (usb_hcd_is_primary_hcd(hcd) && irqnum) {
 		retval = usb_hcd_request_irqs(hcd, irqnum, irqflags);
 		if (retval)
 			goto err_request_irq;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6bbe3c3..c939f5f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -352,6 +352,11 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
 		/* hcd->irq is -1, we have MSI */
 		return 0;
 
+	if (!pdev->irq) {
+		xhci_err(xhci, "No msi-x/msi found and no IRQ in BIOS\n");
+		return -EINVAL;
+	}
+
 	/* fall back to legacy interrupt*/
 	ret = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
 			hcd->irq_descr, hcd);
-- 
1.6.3.3

