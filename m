Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2COEsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 00:48:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:41255 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2COEs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 00:48:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139115286"
Subject: [PATCH] usb/core: skip unnecessary line IRQ request for USB3
From: Alex Shi <alex.shi@intel.com>
To: stern@rowland.harvard.edu, gregkh <gregkh@linuxfoundation.org>
Cc: sarah.a.sharp@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 12:48:24 +0800
Message-ID: <1331786904.2979.64.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


USB3 requests line IRQ here but will disable it
in later driver->start function and try MSI first.

xhci_hcd 0000:02:00.0: irq 18, io mem 0xfe500000
xhci_hcd 0000:02:00.0: irq 45 for MSI/MSI-X
xhci_hcd 0000:02:00.0: irq 46 for MSI/MSI-X

So it is better to remove the redundant request here. And
save a little time in booting.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 drivers/usb/core/hcd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index e128232..5b09825 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2450,7 +2450,8 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	/* enable irqs just before we start the controller,
 	 * if the BIOS provides legacy PCI irqs.
 	 */
-	if (usb_hcd_is_primary_hcd(hcd) && irqnum) {
+	if (usb_hcd_is_primary_hcd(hcd) && irqnum
+		&& (hcd->driver->flags & HCD_MASK) != HCD_USB3) {
 		retval = usb_hcd_request_irqs(hcd, irqnum, irqflags);
 		if (retval)
 			goto err_request_irq;
-- 
1.7.5.1



