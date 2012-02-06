Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab2BFMc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:32:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:57681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab2BFMc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:32:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="63722179"
From: Alex Shi <alex.shi@intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org, andiry.xu@amd.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: enable pci MSI/MSIX in usb core
Date: Mon,  6 Feb 2012 20:29:01 +0800
Message-Id: <1328531341-22705-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSI/MSIX is the favorite interrupt for PCIe device. PCIe usb HCD should
be used more and more in future, but current USB core still just wants
line IRQ, only XHCI usb driver enabled MSI/MSIX.

This patch enabled pci MSI/MSIX in usb core for HCD, and removed MSI/MSIX
setup code from XHCI since it becomes redundant now.
There 2 places need prepare to enable MSI/MSIX in usb driver.
1, set HCD_MSI_FIRST in driver->flags to enable MSI/MSIX.
2, prepare a get_msix_num() for specific drivers.
XHCI is a good example for this.

This patch bases on my "USB-try-MSI-before-legacy-irq-on-pci-xhci-HCD"
patch.

Thanks for Sarah's effort on the MSI/MSIX enabling in XHCI. In fact most
of MSI/MSIX setup functions reuse from XHCI.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 drivers/usb/core/hcd-pci.c  |  219 +++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/core/hcd.c      |   23 ++++-
 drivers/usb/host/xhci-pci.c |   13 +--
 drivers/usb/host/xhci.c     |  216 +++---------------------------------------
 drivers/usb/host/xhci.h     |    5 +-
 include/linux/usb/hcd.h     |   14 +++
 6 files changed, 268 insertions(+), 222 deletions(-)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index d6369a4..c4192e1 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -153,6 +153,220 @@ static inline void wait_for_companions(struct pci_dev *d, struct usb_hcd *h) {}
 
 /*-------------------------------------------------------------------------*/
 
+static int hcd_free_msix(struct usb_hcd *hcd)
+{
+	int i;
+	struct pci_dev  *pdev = to_pci_dev(hcd->self.controller);
+
+	if (!hcd->msix_entries) {
+		printk(KERN_ERR "No msix entries found!\n");
+		return -EINVAL;
+	}
+	for (i = 0; i < hcd->msix_count; i++)
+		if (hcd->msix_entries[i].vector)
+			free_irq(hcd->msix_entries[i].vector,
+					hcd);
+
+	pci_disable_msix(pdev);
+	kfree(hcd->msix_entries);
+	hcd->msix_entries = NULL;
+	hcd->msix_enabled = 0;
+
+	return 0;
+}
+
+static int hcd_free_msi(struct usb_hcd *hcd)
+{
+	struct pci_dev  *pdev = to_pci_dev(hcd->self.controller);
+
+	dev_dbg(&pdev->dev, "disable MSI interrupt\n");
+	pci_disable_msi(pdev);
+	return 0;
+}
+
+/* Free and disable msi/msix */
+void usb_hcd_free_msi_msix(struct usb_hcd *hcd)
+{
+	if (hcd->msix_entries)
+		hcd_free_msix(hcd);
+	else
+		hcd_free_msi(hcd);
+
+	return;
+}
+EXPORT_SYMBOL_GPL(usb_hcd_free_msi_msix);
+
+void usb_hcd_msix_sync_irqs(struct usb_hcd *hcd)
+{
+	int i;
+	if (hcd->msix_entries) {
+		for (i = 0; i < hcd->msix_count; i++)
+			synchronize_irq(hcd->msix_entries[i].vector);
+	}
+
+}
+EXPORT_SYMBOL_GPL(usb_hcd_msix_sync_irqs);
+
+/*
+ * Set up MSI
+ */
+static int hcd_setup_msi(struct pci_dev *pdev, struct usb_hcd *hcd)
+{
+	int ret;
+
+	ret = pci_enable_msi(pdev);
+	if (ret)
+		dev_dbg(&pdev->dev, "failed to allocate MSI entry\n");
+	return ret;
+}
+
+/*
+ * Set up MSI-X
+ */
+static int hcd_setup_msix(struct pci_dev *pdev, struct usb_hcd *hcd)
+{
+	int i, ret = 0;
+
+	/*
+	 * calculate number of msi-x vectors supported.
+	 * Add additional 1 vector to ensure always available interrupt.
+	 */
+	hcd->msix_count = min((int)num_online_cpus() + 1,
+				hcd->driver->get_msix_num(hcd));
+
+	hcd->msix_entries =
+		kmalloc((sizeof(struct msix_entry))*hcd->msix_count,
+				GFP_KERNEL);
+	if (!hcd->msix_entries) {
+		dev_err(&pdev->dev, "Failed to allocate MSI-X entries\n");
+		hcd->msix_count = 0;
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < hcd->msix_count; i++) {
+		hcd->msix_entries[i].entry = i;
+		hcd->msix_entries[i].vector = 0;
+	}
+
+	ret = pci_enable_msix(pdev, hcd->msix_entries, hcd->msix_count);
+	if (ret) {
+		dev_dbg(&pdev->dev, "Failed to enable MSI-X\n");
+		goto free_entries;
+	}
+
+	return ret;
+
+free_entries:
+	kfree(hcd->msix_entries);
+	hcd->msix_entries = NULL;
+	hcd->msix_count = 0;
+	return ret;
+}
+
+/* Device for a quirk */
+#define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
+#define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
+
+/* Check for buggy HCD devices, and driver's expectation for MSI.
+ * Now, only xhci driver want it by HCD_MSI_FIRST setting. Other driver
+ * like ehci/uhci can follow this setting, if they want.
+ */
+static int hcd_no_msi(struct pci_dev *pdev, struct usb_hcd *hcd)
+{
+	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
+			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK) {
+
+		/* Fresco Logic confirms: all revisions of this chip do not
+		 * support MSI, even though some of them claim to in their PCI
+		 * capabilities.
+		 */
+		dev_dbg(&pdev->dev, "QUIRK: Fresco Logic revision %u "
+				"has broken MSI implementation\n",
+				pdev->revision);
+		return 1;
+	} else if (!(hcd->driver->flags & HCD_MSI_FIRST))
+		return 1;
+
+	return 0;
+}
+
+/* setup msi/msix interrupts. if fails, fallback to line irq */
+static int hcd_setup_int(struct pci_dev *pdev, struct usb_hcd *hcd)
+{
+	int ret;
+
+	hcd->irq = -1;
+
+	if (!hcd_no_msi(pdev, hcd)) {
+
+		ret = hcd_setup_msix(pdev, hcd);
+		if (ret)
+			/* fall back to msi*/
+			ret = hcd_setup_msi(pdev, hcd);
+
+		if (!ret)
+			/* hcd->irq is -1, we have MSI */
+			return 0;
+	}
+
+	if (!pdev->irq) {
+		dev_err(&pdev->dev, "No msi or line irq found!\n");
+		return -1;
+	}
+	/* fallback to line irq */
+	hcd->irq = pdev->irq;
+	return 0;
+}
+
+/* msi irq handler should be here, if driver has */
+irqreturn_t hcd_msi_irq(int irq, struct usb_hcd *hcd)
+{
+	return hcd->driver->irq(hcd);
+}
+
+int usb_hcd_request_msi_msix_irqs(struct usb_hcd *hcd, unsigned int irqnum,
+					unsigned long irqflags)
+{
+	int retval = 1;
+	if (hcd->msix_entries && hcd->driver->irq) {
+		int i;
+		/* register hc_driver's irq handler */
+		for (i = 0; i < hcd->msix_count; i++) {
+			retval = request_irq(hcd->msix_entries[i].vector,
+					(irq_handler_t)hcd_msi_irq,
+					0, hcd->driver->description, hcd);
+			if (retval) {
+				hcd_free_msix(hcd);
+				break;
+			}
+		}
+		if (i == hcd->msix_count)
+			hcd->msix_enabled = 1;
+	} else if (hcd->irq == -1) {
+		/* use msi */
+		retval = request_irq(irqnum, (irq_handler_t)hcd_msi_irq,
+					0, hcd->driver->description, hcd);
+		if (retval)
+			hcd_free_msi(hcd);
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(usb_hcd_request_msi_msix_irqs);
+
+/* setup msi/msix interrupts and requestion irqs for them */
+int usb_hcd_register_msi_msix_irqs(struct usb_hcd *hcd)
+{
+	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
+	int ret = -1;
+
+	if (!hcd_setup_int(pdev, hcd))
+		ret = usb_hcd_request_msi_msix_irqs(hcd,
+				pdev->irq, IRQF_SHARED);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usb_hcd_register_msi_msix_irqs);
+
 /* configure so an HC device and id are always provided */
 /* always called with process context; sleeping is OK */
 
@@ -243,6 +457,11 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pci_set_master(dev);
 
+	/* try enable MSI, if fail, seek line irq */
+	retval = hcd_setup_int(dev, hcd);
+	if (retval != 0)
+		goto unmap_registers;
+
 	retval = usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
 	if (retval != 0)
 		goto unmap_registers;
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index b3a7920..579cbd3 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2322,7 +2322,7 @@ int usb_hcd_is_primary_hcd(struct usb_hcd *hcd)
 }
 EXPORT_SYMBOL_GPL(usb_hcd_is_primary_hcd);
 
-static int usb_hcd_request_irqs(struct usb_hcd *hcd,
+static int usb_hcd_request_default_irqs(struct usb_hcd *hcd,
 		unsigned int irqnum, unsigned long irqflags)
 {
 	int retval;
@@ -2362,6 +2362,20 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
 	return 0;
 }
 
+int usb_hcd_request_irqs(struct usb_hcd *hcd, unsigned int irqnum,
+		unsigned long irqflags)
+{
+	int retval = 1;
+
+#ifdef CONFIG_PCI
+	retval = usb_hcd_request_msi_msix_irqs(hcd, irqnum, irqflags);
+#endif
+	if (retval)
+		retval = usb_hcd_request_default_irqs(hcd, irqnum, irqflags);
+
+	return retval;
+}
+
 /**
  * usb_add_hcd - finish generic HCD structure initialization and register
  * @hcd: the usb_hcd structure to initialize
@@ -2447,11 +2461,8 @@ int usb_add_hcd(struct usb_hcd *hcd,
 			&& device_can_wakeup(&hcd->self.root_hub->dev))
 		dev_dbg(hcd->self.controller, "supports USB remote wakeup\n");
 
-	/* enable irqs just before we start the controller, except MSI
-	 * first try HCD. That will do it in following driver->start();
-	 */
-	if (usb_hcd_is_primary_hcd(hcd) &&
-			!(hcd->driver->flags & HCD_MSI_FIRST)) {
+	/* enable irqs just before we start the controller */
+	if (usb_hcd_is_primary_hcd(hcd)) {
 		retval = usb_hcd_request_irqs(hcd, irqnum, irqflags);
 		if (retval)
 			goto err_request_irq;
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 5185ab7..ec44180 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -55,8 +55,6 @@ static int xhci_pci_reinit(struct xhci_hcd *xhci, struct pci_dev *pdev)
 static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 {
 	struct pci_dev		*pdev = to_pci_dev(dev);
-	struct hc_driver	*hcp = (struct hc_driver *) xhci_to_hcd(xhci)
-						->driver;
 
 	/* Look for vendor-specific quirks */
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
@@ -66,15 +64,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 			xhci_dbg(xhci, "QUIRK: Fresco Logic xHC needs configure"
 					" endpoint cmd after reset endpoint\n");
 		}
-		/* Fresco Logic confirms: all revisions of this chip do not
-		 * support MSI, even though some of them claim to in their PCI
-		 * capabilities.
-		 */
-		xhci->quirks |= XHCI_BROKEN_MSI;
-		hcp->flags &= ~HCD_MSI_FIRST;
-		xhci_dbg(xhci, "QUIRK: Fresco Logic revision %u "
-				"has broken MSI implementation\n",
-				pdev->revision);
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_NEC)
@@ -127,6 +116,7 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
 	return retval;
 }
 
+
 /*
  * We need to register our own PCI probe function (instead of the USB core's
  * function) in order to create a second roothub under xHCI.
@@ -255,6 +245,7 @@ static const struct hc_driver xhci_pci_hc_driver = {
 	 */
 	.reset =		xhci_pci_setup,
 	.start =		xhci_run,
+	.get_msix_num =		xhci_get_msix_num,
 #ifdef CONFIG_PM
 	.pci_suspend =          xhci_pci_suspend,
 	.pci_resume =           xhci_pci_resume,
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c939f5f..00cf296 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -176,210 +176,24 @@ int xhci_reset(struct xhci_hcd *xhci)
 }
 
 #ifdef CONFIG_PCI
-static int xhci_free_msi(struct xhci_hcd *xhci)
-{
-	int i;
-
-	if (!xhci->msix_entries)
-		return -EINVAL;
-
-	for (i = 0; i < xhci->msix_count; i++)
-		if (xhci->msix_entries[i].vector)
-			free_irq(xhci->msix_entries[i].vector,
-					xhci_to_hcd(xhci));
-	return 0;
-}
-
-/*
- * Set up MSI
- */
-static int xhci_setup_msi(struct xhci_hcd *xhci)
-{
-	int ret;
-	struct pci_dev  *pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
-
-	ret = pci_enable_msi(pdev);
-	if (ret) {
-		xhci_dbg(xhci, "failed to allocate MSI entry\n");
-		return ret;
-	}
-
-	ret = request_irq(pdev->irq, (irq_handler_t)xhci_msi_irq,
-				0, "xhci_hcd", xhci_to_hcd(xhci));
-	if (ret) {
-		xhci_dbg(xhci, "disable MSI interrupt\n");
-		pci_disable_msi(pdev);
-	}
-
-	return ret;
-}
-
-/*
- * Free IRQs
- * free all IRQs request
- */
-static void xhci_free_irq(struct xhci_hcd *xhci)
-{
-	struct pci_dev *pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
-	int ret;
-
-	/* return if using legacy interrupt */
-	if (xhci_to_hcd(xhci)->irq >= 0)
-		return;
-
-	ret = xhci_free_msi(xhci);
-	if (!ret)
-		return;
-	if (pdev->irq >= 0)
-		free_irq(pdev->irq, xhci_to_hcd(xhci));
-
-	return;
-}
-
-/*
- * Set up MSI-X
- */
-static int xhci_setup_msix(struct xhci_hcd *xhci)
-{
-	int i, ret = 0;
-	struct usb_hcd *hcd = xhci_to_hcd(xhci);
-	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
-
-	/*
-	 * calculate number of msi-x vectors supported.
-	 * - HCS_MAX_INTRS: the max number of interrupts the host can handle,
-	 *   with max number of interrupters based on the xhci HCSPARAMS1.
-	 * - num_online_cpus: maximum msi-x vectors per CPUs core.
-	 *   Add additional 1 vector to ensure always available interrupt.
-	 */
-	xhci->msix_count = min(num_online_cpus() + 1,
-				HCS_MAX_INTRS(xhci->hcs_params1));
-
-	xhci->msix_entries =
-		kmalloc((sizeof(struct msix_entry))*xhci->msix_count,
-				GFP_KERNEL);
-	if (!xhci->msix_entries) {
-		xhci_err(xhci, "Failed to allocate MSI-X entries\n");
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < xhci->msix_count; i++) {
-		xhci->msix_entries[i].entry = i;
-		xhci->msix_entries[i].vector = 0;
-	}
-
-	ret = pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
-	if (ret) {
-		xhci_dbg(xhci, "Failed to enable MSI-X\n");
-		goto free_entries;
-	}
-
-	for (i = 0; i < xhci->msix_count; i++) {
-		ret = request_irq(xhci->msix_entries[i].vector,
-				(irq_handler_t)xhci_msi_irq,
-				0, "xhci_hcd", xhci_to_hcd(xhci));
-		if (ret)
-			goto disable_msix;
-	}
-
-	hcd->msix_enabled = 1;
-	return ret;
-
-disable_msix:
-	xhci_dbg(xhci, "disable MSI-X interrupt\n");
-	xhci_free_irq(xhci);
-	pci_disable_msix(pdev);
-free_entries:
-	kfree(xhci->msix_entries);
-	xhci->msix_entries = NULL;
-	return ret;
-}
-
-/* Free any IRQs and disable MSI-X */
-static void xhci_cleanup_msix(struct xhci_hcd *xhci)
-{
-	struct usb_hcd *hcd = xhci_to_hcd(xhci);
-	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
-
-	xhci_free_irq(xhci);
-
-	if (xhci->msix_entries) {
-		pci_disable_msix(pdev);
-		kfree(xhci->msix_entries);
-		xhci->msix_entries = NULL;
-	} else {
-		pci_disable_msi(pdev);
-	}
-
-	hcd->msix_enabled = 0;
-	return;
-}
 
 static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
 {
-	int i;
-
-	if (xhci->msix_entries) {
-		for (i = 0; i < xhci->msix_count; i++)
-			synchronize_irq(xhci->msix_entries[i].vector);
-	}
+	usb_hcd_msix_sync_irqs(xhci_to_hcd(xhci));
 }
 
-static int xhci_try_enable_msi(struct usb_hcd *hcd)
+/* called in interrupt setup during pci probe() */
+int xhci_get_msix_num(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	struct pci_dev  *pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
-	int ret;
-
-	/*
-	 * Some Fresco Logic host controllers advertise MSI, but fail to
-	 * generate interrupts.  Don't even try to enable MSI.
-	 */
-	if (xhci->quirks & XHCI_BROKEN_MSI)
-		return 0;
-
-	/* unregister the legacy interrupt */
-	if (hcd->irq)
-		free_irq(hcd->irq, hcd);
-	hcd->irq = -1;
 
-	ret = xhci_setup_msix(xhci);
-	if (ret)
-		/* fall back to msi*/
-		ret = xhci_setup_msi(xhci);
-
-	if (!ret)
-		/* hcd->irq is -1, we have MSI */
-		return 0;
-
-	if (!pdev->irq) {
-		xhci_err(xhci, "No msi-x/msi found and no IRQ in BIOS\n");
-		return -EINVAL;
-	}
-
-	/* fall back to legacy interrupt*/
-	ret = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
-			hcd->irq_descr, hcd);
-	if (ret) {
-		xhci_err(xhci, "request interrupt %d failed\n",
-				pdev->irq);
-		return ret;
-	}
-	hcd->irq = pdev->irq;
-	return 0;
+	/* danger: xhci may be null, but it's useless in xhci_readl() now */
+	return HCS_MAX_INTRS(xhci_readl(xhci,
+		&((struct xhci_cap_regs *)hcd->regs)->hcs_params1));
 }
 
 #else
 
-static int xhci_try_enable_msi(struct usb_hcd *hcd)
-{
-	return 0;
-}
-
-static void xhci_cleanup_msix(struct xhci_hcd *xhci)
-{
-}
-
 static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
 {
 }
@@ -411,7 +225,6 @@ int xhci_init(struct usb_hcd *hcd)
 
 	return retval;
 }
-
 /*-------------------------------------------------------------------------*/
 
 
@@ -497,7 +310,6 @@ int xhci_run(struct usb_hcd *hcd)
 {
 	u32 temp;
 	u64 temp_64;
-	int ret;
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 
 	/* Start the xHCI host controller running only after the USB 2.0 roothub
@@ -510,10 +322,6 @@ int xhci_run(struct usb_hcd *hcd)
 
 	xhci_dbg(xhci, "xhci_run\n");
 
-	ret = xhci_try_enable_msi(hcd);
-	if (ret)
-		return ret;
-
 #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
 	init_timer(&xhci->event_ring_timer);
 	xhci->event_ring_timer.data = (unsigned long) xhci;
@@ -609,7 +417,7 @@ void xhci_stop(struct usb_hcd *hcd)
 	xhci_reset(xhci);
 	spin_unlock_irq(&xhci->lock);
 
-	xhci_cleanup_msix(xhci);
+	usb_hcd_free_msi_msix(hcd);
 
 #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
 	/* Tell the event ring poll function not to reschedule */
@@ -651,7 +459,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	xhci_halt(xhci);
 	spin_unlock_irq(&xhci->lock);
 
-	xhci_cleanup_msix(xhci);
+	usb_hcd_free_msi_msix(hcd);
 
 	xhci_dbg(xhci, "xhci_shutdown completed - status = %x\n",
 		    xhci_readl(xhci, &xhci->op_regs->status));
@@ -853,7 +661,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		xhci_halt(xhci);
 		xhci_reset(xhci);
 		spin_unlock_irq(&xhci->lock);
-		xhci_cleanup_msix(xhci);
+		usb_hcd_free_msi_msix(hcd);
 
 #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
 		/* Tell the event ring poll function not to reschedule */
@@ -888,7 +696,11 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		if (retval)
 			return retval;
 		xhci_dbg(xhci, "Start the primary HCD\n");
-		retval = xhci_run(hcd->primary_hcd);
+		if (dev_is_pci(hcd->self.controller))
+			retval = usb_hcd_register_msi_msix_irqs(
+						hcd->primary_hcd);
+		if (!retval)
+			retval = xhci_run(hcd->primary_hcd);
 		if (!retval) {
 			xhci_dbg(xhci, "Start the secondary HCD\n");
 			retval = xhci_run(secondary_hcd);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index fb99c83..8d511dd 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1388,9 +1388,6 @@ struct xhci_hcd {
 	int		page_size;
 	/* Valid values are 12 to 20, inclusive */
 	int		page_shift;
-	/* msi-x vectors */
-	int		msix_count;
-	struct msix_entry	*msix_entries;
 	/* data structures */
 	struct xhci_device_context_array *dcbaa;
 	struct xhci_ring	*cmd_ring;
@@ -1643,9 +1640,11 @@ void xhci_free_command(struct xhci_hcd *xhci,
 /* xHCI PCI glue */
 int xhci_register_pci(void);
 void xhci_unregister_pci(void);
+int xhci_get_msix_num(struct usb_hcd *hcd);
 #else
 static inline int xhci_register_pci(void) { return 0; }
 static inline void xhci_unregister_pci(void) {}
+static inline int xhci_get_msix_num(struct usb_hcd *hcd) { return 0; }
 #endif
 
 /* xHCI host controller glue */
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 2cc8673..1f2df75 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -22,6 +22,7 @@
 #ifdef __KERNEL__
 
 #include <linux/rwsem.h>
+#include <linux/pci.h>		/* for struct msix_entry */
 
 #define MAX_TOPO_LEVEL		6
 
@@ -133,6 +134,12 @@ struct usb_hcd {
 	u64			rsrc_len;	/* memory/io resource length */
 	unsigned		power_budget;	/* in mA, 0 = no limit */
 
+#ifdef CONFIG_PCI
+	/* msi-x vectors */
+	int			msix_count;
+	struct msix_entry	*msix_entries;
+#endif
+
 	/* bandwidth_mutex should be taken before adding or removing
 	 * any new bus bandwidth constraints:
 	 *   1. Before adding a configuration for a new device.
@@ -219,6 +226,7 @@ struct hc_driver {
 	/* called to init HCD and root hub */
 	int	(*reset) (struct usb_hcd *hcd);
 	int	(*start) (struct usb_hcd *hcd);
+	int	(*get_msix_num) (struct usb_hcd *hcd);
 
 	/* NOTE:  these suspend/resume calls relate to the HC as
 	 * a whole, not just the root hub; they're for PCI bus glue.
@@ -394,6 +402,12 @@ extern int usb_hcd_pci_probe(struct pci_dev *dev,
 extern void usb_hcd_pci_remove(struct pci_dev *dev);
 extern void usb_hcd_pci_shutdown(struct pci_dev *dev);
 
+extern void usb_hcd_free_msi_msix(struct usb_hcd *hcd);
+extern void usb_hcd_msix_sync_irqs(struct usb_hcd *hcd);
+extern int usb_hcd_request_msi_msix_irqs(struct usb_hcd *hcd,
+		unsigned int irqnum, unsigned long irqflags);
+extern int usb_hcd_register_msi_msix_irqs(struct usb_hcd *hcd);
+
 #ifdef CONFIG_PM_SLEEP
 extern const struct dev_pm_ops usb_hcd_pci_pm_ops;
 #endif
-- 
1.6.3.3

