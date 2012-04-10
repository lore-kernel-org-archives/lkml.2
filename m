Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab2DJEIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 00:08:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40791 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2DJEID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 00:08:03 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/2] usb/ehci-pci: Add workaround for EG20T/ML7213/ML7223/ML7831
Date: Tue, 10 Apr 2012 13:07:15 +0900
Message-Id: <1334030835-4681-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334030835-4681-1-git-send-email-tomoya.rohm@gmail.com>
References: <1334030835-4681-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISSUE: When a bit of EHCI status register (USBSTS) is set
as 1, if the corresponded bit of EHCI interrupt enable
register(USBINTR) is set as 1, an interrupt occurs.
After that, even if the bit of USBINTR is set as 0, the
interrupt continues occurring.
Workaround: Clear the bit 3 of USBSTS before enabling the
interrupt, at resume process.

This patch is for
Intel EG20T PCH
LAPIS Semiconductor ML7213 IOH
LAPIS Semiconductor ML7223 IOH
LAPIS Semiconductor ML7831 IOH

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/usb/host/ehci-pci.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 01bb7241d..30f3ad6 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -419,6 +419,30 @@ static int ehci_pci_resume(struct usb_hcd *hcd, bool hibernated)
 		ehci_prepare_ports_for_controller_resume(ehci);
 		if (!hcd->self.root_hub->do_remote_wakeup)
 			mask &= ~STS_PCD;
+
+		if ((pdev->vendor == PCI_VENDOR_ID_INTEL &&
+		     pdev->device == 0x8807) ||
+		   (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+		     pdev->device == 0x880F) ||
+		   (pdev->vendor == 0x10DB &&
+		    pdev->device == 0x801C) || /* ML7213 */
+		   (pdev->vendor == 0x10DB &&
+		    pdev->device == 0x8007) || /* ML7223 */
+		   (pdev->vendor == 0x10DB &&
+		    pdev->device == 0x8807)) { /* ML7831 */
+		/* ISSUE: When a bit of EHCI status register (USBSTS) is set
+		 * as 1, if the corresponded bit of EHCI interrupt enable
+		 * register(USBINTR) is set as 1, an interrupt occurs.
+		 * After that, even if the bit of USBINTR is set as 0, the
+		 * interrupt continues occurring.
+		 * Workaround: Clear the bit 3 of USBSTS before enabling the
+		 * interrupt, at resume process.
+		 */
+			ehci_writel(ehci, STS_FLR, &ehci->regs->status);
+			ehci_dbg(ehci, "Workaround: %s: Clear STS_FLR\n",
+				  __func__);
+		}
+
 		ehci_writel(ehci, mask, &ehci->regs->intr_enable);
 		ehci_readl(ehci, &ehci->regs->intr_enable);
 		return 0;
-- 
1.7.7.6

