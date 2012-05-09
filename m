Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab2EIItg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:49:36 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:46038 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2EIItd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:49:33 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <stern@rowland.harvard.edu>, <linux-usb@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] USB: ohci-at91: add a reset function to fix race condition
Date: Wed, 9 May 2012 10:48:54 +0200
Message-ID: <1336553334-31058-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A possible race condition appears because we are not initializing
the ohci->regs before calling usb_hcd_request_irqs().
We move the call to ohci_init() in hcd->driver->reset() instead of
hcd->driver->start() to fix this.
This was experienced when we share the same IRQ line between OHCI and EHCI
controllers.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Tested-by: Christian Eggers <christian.eggers@kathrein.de>
Cc: stable <stable@vger.kernel.org>
---
 drivers/usb/host/ohci-at91.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 13ebeca..55d3d64 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -223,7 +223,7 @@ static void __devexit usb_hcd_at91_remove(struct usb_hcd *hcd,
 /*-------------------------------------------------------------------------*/
 
 static int __devinit
-ohci_at91_start (struct usb_hcd *hcd)
+ohci_at91_reset (struct usb_hcd *hcd)
 {
 	struct at91_usbh_data	*board = hcd->self.controller->platform_data;
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
@@ -233,6 +233,14 @@ ohci_at91_start (struct usb_hcd *hcd)
 		return ret;
 
 	ohci->num_ports = board->ports;
+	return 0;
+}
+
+static int __devinit
+ohci_at91_start (struct usb_hcd *hcd)
+{
+	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
+	int			ret;
 
 	if ((ret = ohci_run(ohci)) < 0) {
 		err("can't start %s", hcd->self.bus_name);
@@ -418,6 +426,7 @@ static const struct hc_driver ohci_at91_hc_driver = {
 	/*
 	 * basic lifecycle operations
 	 */
+	.reset =		ohci_at91_reset,
 	.start =		ohci_at91_start,
 	.stop =			ohci_stop,
 	.shutdown =		ohci_shutdown,
-- 
1.7.10

