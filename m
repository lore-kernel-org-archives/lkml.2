Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2GWLqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:46:37 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:52042 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab2GWLqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:46:35 -0400
Message-ID: <500D3998.7010705@compulab.co.il>
Date: Mon, 23 Jul 2012 14:46:32 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] xhci: EHCI/XHCI ports switching on Intense-PC.
References: <5004454E.9030903@compulab.co.il> <20120717045416.GJ7599@xanatos> <50065E5A.2040103@compulab.co.il> <20120718165916.GA30828@xanatos>
In-Reply-To: <20120718165916.GA30828@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intense-PC is Compulab's mini-desktop with Intel Panther Point
chipset.

Unconditional switchover to xHCI provided by function
usb_enable_xhci_ports() leads to surprising results, after shutdown
system powered-on again after a few seconds. On Windows power
related problems were not observed. Switching back to EHCI solves
the problem.

The patch switches usb ports back to EHCI during xhci shutdown
for Intense-PC.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/usb/host/xhci.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a979cd0..541efaa 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -26,6 +26,8 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/dmi.h>
+#include "pci-quirks.h"

 #include "xhci.h"

@@ -656,8 +658,20 @@ void xhci_stop(struct usb_hcd *hcd)
  */
 void xhci_shutdown(struct usb_hcd *hcd)
 {
+	struct pci_dev *pdev;
+	const char *brd_name;
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);

+	pdev = to_pci_dev(hcd->self.controller);
+
+	if (usb_is_intel_switchable_xhci(pdev)) {
+		brd_name = dmi_get_system_info(DMI_BOARD_NAME);
+
+		/* quirk for Compulab's Intense-PC board */
+		if (brd_name && strstr(brd_name, "Intense-PC"))
+			usb_disable_xhci_ports(pdev);
+	}
+
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
 	spin_unlock_irq(&xhci->lock);
-- 
1.7.9.5

