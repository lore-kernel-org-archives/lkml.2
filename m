Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422769Ab2E0BR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:17:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422746Ab2E0BRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:17:52 -0400
Message-Id: <20120527002518.008534841@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:57 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Christian Eggers <christian.eggers@kathrein.de>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 51/91] USB: ohci-at91: add a reset function to fix race condition
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@atmel.com>

commit 07e4e556eff4938eb2edf2591de3aa7d7fb82b52 upstream.

A possible race condition appears because we are not initializing
the ohci->regs before calling usb_hcd_request_irqs().
We move the call to ohci_init() in hcd->driver->reset() instead of
hcd->driver->start() to fix this.
This was experienced when we share the same IRQ line between OHCI and EHCI
controllers.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Tested-by: Christian Eggers <christian.eggers@kathrein.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ohci-at91.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -223,7 +223,7 @@ static void __devexit usb_hcd_at91_remov
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
@@ -418,6 +426,7 @@ static const struct hc_driver ohci_at91_
 	/*
 	 * basic lifecycle operations
 	 */
+	.reset =		ohci_at91_reset,
 	.start =		ohci_at91_start,
 	.stop =			ohci_stop,
 	.shutdown =		ohci_shutdown,


