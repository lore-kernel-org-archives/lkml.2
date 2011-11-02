Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1KCCLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:11:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab1KCBfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:35:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:56 2011
Message-Id: <20111102221456.244353214@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jerry Huang <r66093@freescale.com>
Subject: [067/107] QE/FHCI: fixed the CONTROL bug
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jerry Huang <r66093@freescale.com>

commit 273d23574f9dacd9c63c80e7d63639a669aad441 upstream.

For USB CONTROL transaction, when the data length is zero,
the IN package is needed to finish this transaction in status stage.

Signed-off-by: Jerry Huang <r66093@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/fhci-sched.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -1,7 +1,7 @@
 /*
  * Freescale QUICC Engine USB Host Controller Driver
  *
- * Copyright (c) Freescale Semicondutor, Inc. 2006.
+ * Copyright (c) Freescale Semicondutor, Inc. 2006, 2011.
  *               Shlomi Gridish <gridish@freescale.com>
  *               Jerry Huang <Chang-Ming.Huang@freescale.com>
  * Copyright (c) Logic Product Development, Inc. 2007
@@ -810,9 +810,11 @@ void fhci_queue_urb(struct fhci_hcd *fhc
 		ed->dev_addr = usb_pipedevice(urb->pipe);
 		ed->max_pkt_size = usb_maxpacket(urb->dev, urb->pipe,
 			usb_pipeout(urb->pipe));
+		/* setup stage */
 		td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++, FHCI_TA_SETUP,
 			USB_TD_TOGGLE_DATA0, urb->setup_packet, 8, 0, 0, true);
 
+		/* data stage */
 		if (data_len > 0) {
 			td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
 				usb_pipeout(urb->pipe) ? FHCI_TA_OUT :
@@ -820,9 +822,18 @@ void fhci_queue_urb(struct fhci_hcd *fhc
 				USB_TD_TOGGLE_DATA1, data, data_len, 0, 0,
 				true);
 		}
-		td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
-			usb_pipeout(urb->pipe) ? FHCI_TA_IN : FHCI_TA_OUT,
-			USB_TD_TOGGLE_DATA1, data, 0, 0, 0, true);
+
+		/* status stage */
+		if (data_len > 0)
+			td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
+				(usb_pipeout(urb->pipe) ? FHCI_TA_IN :
+							  FHCI_TA_OUT),
+				USB_TD_TOGGLE_DATA1, data, 0, 0, 0, true);
+		else
+			 td = fhci_td_fill(fhci, urb, urb_priv, ed, cnt++,
+				FHCI_TA_IN,
+				USB_TD_TOGGLE_DATA1, data, 0, 0, 0, true);
+
 		urb_state = US_CTRL_SETUP;
 		break;
 	case FHCI_TF_ISO:


