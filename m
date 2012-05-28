Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2E1Do2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:44:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52074 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896Ab2E1D3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:32 -0400
Message-Id: <20120528031211.154957876@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Sergio Correia <lists@uece.net>
Subject: [ 060/117] xhci: Add new short TX quirk for Fresco Logic host.
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 1530bbc6272d9da1e39ef8e06190d42c13a02733 upstream.

Sergio reported that when he recorded audio from a USB headset mic
plugged into the USB 3.0 port on his ASUS N53SV-DH72, the audio sounded
"robotic".  When plugged into the USB 2.0 port under EHCI on the same
laptop, the audio sounded fine.  The device is:

Bus 002 Device 004: ID 046d:0a0c Logitech, Inc. Clear Chat Comfort USB Headset

The problem was tracked down to the Fresco Logic xHCI host controller
not correctly reporting short transfers on isochronous IN endpoints.
The driver would submit a 96 byte transfer, the device would only send
88 or 90 bytes, and the xHCI host would report the transfer had a
"successful" completion code, with an untransferred buffer length of 8
or 6 bytes.

The successful completion code and non-zero untransferred length is a
contradiction.  The xHCI host is supposed to only mark a transfer as
successful if all the bytes are transferred.  Otherwise, the transfer
should be marked with a short packet completion code.  Without the EHCI
bus trace, we wouldn't know whether the xHCI driver should trust the
completion code or the untransferred length.  With it, we know to trust
the untransferred length.

Add a new xHCI quirk for the Fresco Logic host controller.  If a
transfer is reported as successful, but the untransferred length is
non-zero, print a warning.  For the Fresco Logic host, change the
completion code to COMP_SHORT_TX and process the transfer like a short
transfer.

This should be backported to stable kernels that contain the commit
f5182b4155b9d686c5540a6822486400e34ddd98 "xhci: Disable MSI for some
Fresco Logic hosts."  That commit was marked for stable kernels as old
as 2.6.36.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Sergio Correia <lists@uece.net>
Tested-by: Sergio Correia <lists@uece.net>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-pci.c  |    1 +
 drivers/usb/host/xhci-ring.c |   20 +++++++++++++++++---
 drivers/usb/host/xhci.h      |    1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 7a856a7..19e8921 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -72,6 +72,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci_dbg(xhci, "QUIRK: Fresco Logic revision %u "
 				"has broken MSI implementation\n",
 				pdev->revision);
+		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_NEC)
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 329fd2a..c60617b 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1787,8 +1787,12 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	/* handle completion code */
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
-		frame->status = 0;
-		break;
+		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
+			frame->status = 0;
+			break;
+		}
+		if ((xhci->quirks & XHCI_TRUST_TX_LENGTH))
+			trb_comp_code = COMP_SHORT_TX;
 	case COMP_SHORT_TX:
 		frame->status = td->urb->transfer_flags & URB_SHORT_NOT_OK ?
 				-EREMOTEIO : 0;
@@ -1885,13 +1889,16 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	switch (trb_comp_code) {
 	case COMP_SUCCESS:
 		/* Double check that the HW transferred everything. */
-		if (event_trb != td->last_trb) {
+		if (event_trb != td->last_trb ||
+				TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			xhci_warn(xhci, "WARN Successful completion "
 					"on short TX\n");
 			if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
 				*status = -EREMOTEIO;
 			else
 				*status = 0;
+			if ((xhci->quirks & XHCI_TRUST_TX_LENGTH))
+				trb_comp_code = COMP_SHORT_TX;
 		} else {
 			*status = 0;
 		}
@@ -2050,6 +2057,13 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	 * transfer type
 	 */
 	case COMP_SUCCESS:
+		if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
+			break;
+		if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
+			trb_comp_code = COMP_SHORT_TX;
+		else
+			xhci_warn(xhci, "WARN Successful completion on short TX: "
+					"needs XHCI_TRUST_TX_LENGTH quirk?\n");
 	case COMP_SHORT_TX:
 		break;
 	case COMP_STOP:
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index ce1edd7..ac14276 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1481,6 +1481,7 @@ struct xhci_hcd {
 #define XHCI_RESET_ON_RESUME	(1 << 7)
 #define	XHCI_SW_BW_CHECKING	(1 << 8)
 #define XHCI_AMD_0x96_HOST	(1 << 9)
+#define XHCI_TRUST_TX_LENGTH	(1 << 10)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */


