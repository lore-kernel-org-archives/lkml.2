Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1BPA1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:27:06 -0500
Received: from kroah.org ([198.145.64.141]:49974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab1BPAZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:52 2011
Message-Id: <20110216001451.993105178@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andiry Xu <andiry.xu@amd.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [269/272] xHCI: synchronize irq in xhci_suspend()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andiry Xu <andiry.xu@amd.com>

commit 0029227f1bc30b6c809ae751f9e7af6cef900997 upstream.

Synchronize the interrupts instead of free them in xhci_suspend(). This will
prevent a double free when the host is suspended and then the card removed.

Set the flag hcd->msix_enabled when using MSI-X, and check the flag in
suspend_common(). MSI-X synchronization will be handled by xhci_suspend(),
and MSI/INTx will be synchronized in suspend_common().

This patch should be queued for the 2.6.37 stable tree.

Reported-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd-pci.c |    7 +++++-
 drivers/usb/host/xhci.c    |   46 ++++++++++++++-------------------------------
 include/linux/usb/hcd.h    |    1 
 3 files changed, 22 insertions(+), 32 deletions(-)

--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -406,7 +406,12 @@ static int suspend_common(struct device
 			return retval;
 	}
 
-	synchronize_irq(pci_dev->irq);
+	/* If MSI-X is enabled, the driver will have synchronized all vectors
+	 * in pci_suspend(). If MSI or legacy PCI is enabled, that will be
+	 * synchronized here.
+	 */
+	if (!hcd->msix_enabled)
+		synchronize_irq(pci_dev->irq);
 
 	/* Downstream ports from this root hub should already be quiesced, so
 	 * there will be no DMA activity.  Now we can shut down the upstream
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -226,7 +226,8 @@ static int xhci_setup_msi(struct xhci_hc
 static int xhci_setup_msix(struct xhci_hcd *xhci)
 {
 	int i, ret = 0;
-	struct pci_dev *pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
+	struct usb_hcd *hcd = xhci_to_hcd(xhci);
+	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
 
 	/*
 	 * calculate number of msi-x vectors supported.
@@ -265,6 +266,7 @@ static int xhci_setup_msix(struct xhci_h
 			goto disable_msix;
 	}
 
+	hcd->msix_enabled = 1;
 	return ret;
 
 disable_msix:
@@ -280,7 +282,8 @@ free_entries:
 /* Free any IRQs and disable MSI-X */
 static void xhci_cleanup_msix(struct xhci_hcd *xhci)
 {
-	struct pci_dev *pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
+	struct usb_hcd *hcd = xhci_to_hcd(xhci);
+	struct pci_dev *pdev = to_pci_dev(hcd->self.controller);
 
 	xhci_free_irq(xhci);
 
@@ -292,6 +295,7 @@ static void xhci_cleanup_msix(struct xhc
 		pci_disable_msi(pdev);
 	}
 
+	hcd->msix_enabled = 0;
 	return;
 }
 
@@ -647,6 +651,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	int			rc = 0;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
+	int			i;
 
 	spin_lock_irq(&xhci->lock);
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
@@ -677,10 +682,15 @@ int xhci_suspend(struct xhci_hcd *xhci)
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;
 	}
-	/* step 5: remove core well power */
-	xhci_cleanup_msix(xhci);
 	spin_unlock_irq(&xhci->lock);
 
+	/* step 5: remove core well power */
+	/* synchronize irq when using MSI-X */
+	if (xhci->msix_entries) {
+		for (i = 0; i < xhci->msix_count; i++)
+			synchronize_irq(xhci->msix_entries[i].vector);
+	}
+
 	return rc;
 }
 
@@ -694,7 +704,6 @@ int xhci_resume(struct xhci_hcd *xhci, b
 {
 	u32			command, temp = 0;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
-	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
 	int	old_state, retval;
 
 	old_state = hcd->state;
@@ -729,9 +738,8 @@ int xhci_resume(struct xhci_hcd *xhci, b
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
 		xhci_reset(xhci);
-		if (hibernated)
-			xhci_cleanup_msix(xhci);
 		spin_unlock_irq(&xhci->lock);
+		xhci_cleanup_msix(xhci);
 
 #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
 		/* Tell the event ring poll function not to reschedule */
@@ -765,30 +773,6 @@ int xhci_resume(struct xhci_hcd *xhci, b
 		return retval;
 	}
 
-	spin_unlock_irq(&xhci->lock);
-	/* Re-setup MSI-X */
-	if (hcd->irq)
-		free_irq(hcd->irq, hcd);
-	hcd->irq = -1;
-
-	retval = xhci_setup_msix(xhci);
-	if (retval)
-		/* fall back to msi*/
-		retval = xhci_setup_msi(xhci);
-
-	if (retval) {
-		/* fall back to legacy interrupt*/
-		retval = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
-					hcd->irq_descr, hcd);
-		if (retval) {
-			xhci_err(xhci, "request interrupt %d failed\n",
-					pdev->irq);
-			return retval;
-		}
-		hcd->irq = pdev->irq;
-	}
-
-	spin_lock_irq(&xhci->lock);
 	/* step 4: set Run/Stop bit */
 	command = xhci_readl(xhci, &xhci->op_regs->command);
 	command |= CMD_RUN;
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -112,6 +112,7 @@ struct usb_hcd {
 	/* Flags that get set only during HCD registration or removal. */
 	unsigned		rh_registered:1;/* is root hub registered? */
 	unsigned		rh_pollable:1;	/* may we poll the root hub? */
+	unsigned		msix_enabled:1;	/* driver has MSI-X enabled? */
 
 	/* The next flag is a stopgap, to be removed when all the HCDs
 	 * support the new root-hub polling mechanism. */


