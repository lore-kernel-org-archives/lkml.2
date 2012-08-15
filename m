Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2HOTvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:36852 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2HOTuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jerry Huang <r66093@freescale.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 079/165] QE/FHCI: fixed the CONTROL bug
Date: Wed, 15 Aug 2012 15:47:03 -0400
Message-ID: <1345060109-9187-80-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerry Huang <r66093@freescale.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 273d23574f9dacd9c63c80e7d63639a669aad441 upstream.

For USB CONTROL transaction, when the data length is zero,
the IN package is needed to finish this transaction in status stage.

Signed-off-by: Jerry Huang <r66093@freescale.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/fhci-sched.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index ff43747..b13d78a 100644
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
@@ -810,9 +810,11 @@ void fhci_queue_urb(struct fhci_hcd *fhci, struct urb *urb)
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
@@ -820,9 +822,18 @@ void fhci_queue_urb(struct fhci_hcd *fhci, struct urb *urb)
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
-- 
1.7.12.rc2

