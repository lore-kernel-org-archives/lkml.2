Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab2BNA0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:26:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:24914 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab2BNAZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:25:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="107076485"
Date: Mon, 13 Feb 2012 16:25:57 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: stern@rowland.harvard.edu, Greg KH <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, andiry.xu@amd.com,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Takashi Iwai <tiwai@suse.de>, trenn@suse.de, linux-pci@vger.kernel.org,
        Michal Marek <MMarek@suse.com>
Subject: [RFT] USB: Try MSI first before line IRQ for Intel PCIe USB3 HCD
Message-ID: <20120214002557.GA13003@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214002030.GA10364@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Hi Alex,

Please test this on your Panther Point system that doesn't have a BIOS
provided IRQ line.  I think this is a much simpler solution.

Sarah Sharp

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
1.7.9

