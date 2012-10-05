Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2JEQW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:22:56 -0400
Received: from zmc.proxad.net ([212.27.53.206]:56334 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab2JEQWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:22:46 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/32 v2] USB: ohci: move ohci_pci_{suspend,resume} to ohci-hcd.c
Date: Fri,  5 Oct 2012 18:20:45 +0200
Message-Id: <1349454064-11606-14-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349454064-11606-1-git-send-email-florian@openwrt.org>
References: <1349454064-11606-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Alan Stern, move the ohci-pci.c ohci_pci_{suspend,resume}
routines to ohci-hcd.c. Due to their move, also rename them to
ohci_{suspend,resume} to make it clear they operate on ohci_hcd. Since they
are not necessarily called, annotate them with __maybe_unused.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes since v1:
- moved ohci_{suspend,resume} out of the #ifdef CONFIG_PM block
- removed the empty CONFIG_PM #ifdef/endif block in ohci-pci.c

 drivers/usb/host/ohci-hcd.c |   39 +++++++++++++++++++++++++++++++++++
 drivers/usb/host/ohci-pci.c |   47 ++-----------------------------------------
 2 files changed, 41 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 36f7ba7..b2fd85f 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -983,6 +983,45 @@ static int ohci_restart (struct ohci_hcd *ohci)
 
 #endif
 
+static int __maybe_unused ohci_suspend(struct usb_hcd *hcd, bool do_wakeup)
+{
+	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
+	unsigned long	flags;
+	int		rc = 0;
+
+	/* Root hub was already suspended. Disable irq emission and
+	 * mark HW unaccessible, bail out if RH has been resumed. Use
+	 * the spinlock to properly synchronize with possible pending
+	 * RH suspend or resume activity.
+	 */
+	spin_lock_irqsave (&ohci->lock, flags);
+	if (ohci->rh_state != OHCI_RH_SUSPENDED) {
+		rc = -EINVAL;
+		goto bail;
+	}
+	ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrdisable);
+	(void)ohci_readl(ohci, &ohci->regs->intrdisable);
+
+	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+ bail:
+	spin_unlock_irqrestore (&ohci->lock, flags);
+
+	return rc;
+}
+
+
+static int __maybe_unused ohci_resume(struct usb_hcd *hcd, bool hibernated)
+{
+	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+
+	/* Make sure resume from hibernation re-enumerates everything */
+	if (hibernated)
+		ohci_usb_reset(hcd_to_ohci(hcd));
+
+	ohci_finish_controller_resume(hcd);
+	return 0;
+}
+
 /*-------------------------------------------------------------------------*/
 
 MODULE_AUTHOR (DRIVER_AUTHOR);
diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
index 1843bb6..6afa7dc 100644
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -296,49 +296,6 @@ static int __devinit ohci_pci_start (struct usb_hcd *hcd)
 	return ret;
 }
 
-#ifdef	CONFIG_PM
-
-static int ohci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
-{
-	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
-	unsigned long	flags;
-	int		rc = 0;
-
-	/* Root hub was already suspended. Disable irq emission and
-	 * mark HW unaccessible, bail out if RH has been resumed. Use
-	 * the spinlock to properly synchronize with possible pending
-	 * RH suspend or resume activity.
-	 */
-	spin_lock_irqsave (&ohci->lock, flags);
-	if (ohci->rh_state != OHCI_RH_SUSPENDED) {
-		rc = -EINVAL;
-		goto bail;
-	}
-	ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrdisable);
-	(void)ohci_readl(ohci, &ohci->regs->intrdisable);
-
-	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
- bail:
-	spin_unlock_irqrestore (&ohci->lock, flags);
-
-	return rc;
-}
-
-
-static int ohci_pci_resume(struct usb_hcd *hcd, bool hibernated)
-{
-	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-
-	/* Make sure resume from hibernation re-enumerates everything */
-	if (hibernated)
-		ohci_usb_reset(hcd_to_ohci(hcd));
-
-	ohci_finish_controller_resume(hcd);
-	return 0;
-}
-
-#endif	/* CONFIG_PM */
-
 
 /*-------------------------------------------------------------------------*/
 
@@ -362,8 +319,8 @@ static const struct hc_driver ohci_pci_hc_driver = {
 	.shutdown =		ohci_shutdown,
 
 #ifdef	CONFIG_PM
-	.pci_suspend =		ohci_pci_suspend,
-	.pci_resume =		ohci_pci_resume,
+	.pci_suspend =		ohci_suspend,
+	.pci_resume =		ohci_resume,
 #endif
 
 	/*
-- 
1.7.9.5

