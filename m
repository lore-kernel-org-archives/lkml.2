Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2E1Dfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:35:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52134 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108Ab2E1D3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:47 -0400
Message-Id: <20120528031210.061766277@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Christian Eggers <christian.eggers@kathrein.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 052/117] USB: ohci-at91: add a reset function to fix race condition
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ohci-at91.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -199,7 +199,7 @@
 /*-------------------------------------------------------------------------*/
 
 static int __devinit
-ohci_at91_start (struct usb_hcd *hcd)
+ohci_at91_reset (struct usb_hcd *hcd)
 {
 	struct at91_usbh_data	*board = hcd->self.controller->platform_data;
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
@@ -209,6 +209,14 @@
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
@@ -390,6 +398,7 @@
 	/*
 	 * basic lifecycle operations
 	 */
+	.reset =		ohci_at91_reset,
 	.start =		ohci_at91_start,
 	.stop =			ohci_stop,
 	.shutdown =		ohci_shutdown,


