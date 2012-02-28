Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab2B1BdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:33:03 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab2B1BH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:07:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.73.234 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010213.648212641@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:03:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Shi <alex.shi@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 57/73] USB: Dont fail USB3 probe on missing legacy PCI IRQ.
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 68d07f64b8a11a852d48d1b05b724c3e20c0d94b upstream

Intel has a PCI USB xhci host controller on a new platform. It doesn't
have a line IRQ definition in BIOS.  The Linux driver refuses to
initialize this controller, but Windows works well because it only depends
on MSI.

Actually, Linux also can work for MSI.  This patch avoids the line IRQ
checking for USB3 HCDs in usb core PCI probe.  It allows the xHCI driver
to try to enable MSI or MSI-X first.  It will fail the probe if MSI
enabling failed and there's no legacy PCI IRQ.

This patch should be backported to kernels as old as 2.6.32.

[Maintainer note: This patch is a backport of commit
68d07f64b8a11a852d48d1b05b724c3e20c0d94b "USB: Don't fail USB3 probe on
missing legacy PCI IRQ." to the 3.0 kernel.  Note, the original patch
description was wrong.  We should not back port this to kernels older
than 2.6.36, since that was the first kernel to support MSI and MSI-X
for xHCI hosts.  These systems will just not work without MSI support,
so the probe should fail on kernels older than 2.6.36.]

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hcd-pci.c |    5 ++++-
 drivers/usb/core/hcd.c     |    6 ++++--
 drivers/usb/host/xhci.c    |    5 +++++
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -187,7 +187,10 @@ int usb_hcd_pci_probe(struct pci_dev *de
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
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2435,8 +2435,10 @@ int usb_add_hcd(struct usb_hcd *hcd,
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
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -444,6 +444,11 @@ int xhci_run(struct usb_hcd *hcd)
 
 	if (ret) {
 legacy_irq:
+		if (!pdev->irq) {
+			xhci_err(xhci, "No msi-x/msi found and "
+					"no IRQ in BIOS\n");
+			return -EINVAL;
+		}
 		/* fall back to legacy interrupt*/
 		ret = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
 					hcd->irq_descr, hcd);


