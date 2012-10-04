Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422805Ab2JDPXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:23:35 -0400
Received: from zmc.proxad.net ([212.27.53.206]:34820 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422719Ab2JDPTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:19:45 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/24] USB: ohci: remove check for RH already suspended in ohci_suspend
Date: Thu,  4 Oct 2012 17:17:41 +0200
Message-Id: <1349363872-27004-14-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349363872-27004-1-git-send-email-florian@openwrt.org>
References: <1349363872-27004-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Alan Stern, the code checking for the OHCI Root Hub already
suspended is no longer required since the bug it fixes has not been seen in
ages, remove that check making ohci_suspend much simpler.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/ohci-hcd.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 0cba8d6..5d30992 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -985,26 +985,19 @@ static int __maybe_unused ohci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 {
 	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
 	unsigned long	flags;
-	int		rc = 0;
 
-	/* Root hub was already suspended. Disable irq emission and
-	 * mark HW unaccessible, bail out if RH has been resumed. Use
+	/* Disable irq emission and mark HW unaccessible. Use
 	 * the spinlock to properly synchronize with possible pending
 	 * RH suspend or resume activity.
 	 */
 	spin_lock_irqsave (&ohci->lock, flags);
-	if (ohci->rh_state != OHCI_RH_SUSPENDED) {
-		rc = -EINVAL;
-		goto bail;
-	}
 	ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrdisable);
 	(void)ohci_readl(ohci, &ohci->regs->intrdisable);
 
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
- bail:
 	spin_unlock_irqrestore (&ohci->lock, flags);
 
-	return rc;
+	return 0;
 }
 
 
-- 
1.7.9.5

