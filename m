Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1CVPNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:13:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34358 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753239Ab1CVPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:13:51 -0400
Date: Tue, 22 Mar 2011 11:13:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <roger.quadros@nokia.com>
cc: gregkh@suse.de, <sshtylyov@mvista.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] usb: gadget: file_storage: Make CD-ROM emulation
 work with Mac OS-X
In-Reply-To: <4D88B490.9060606@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1103221044370.2292-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Roger Quadros wrote:

> However, if host asked for data more than the TOC length then residue will be 
> greater than zero and this will result in zero padded transfers.
> 
> Not a big issue but should we be fixing it?
> 
> one way could be to set fsg->residue to actual TOC length. in do_read_toc().

The current behavior is required by the the Bulk-Only Transport
specification.  The spec says (section 6.7.2, case (4) or (5)):

If the device intends to send less data than the host indicated, then:
    The device shall send the intended data.
	The device may send fill data to pad up to a total of 
	dCBWDataTransferLength.
	If the device actually transfers less data than the host indicated, 
	then:
	    The device may end the transfer with a short packet.
	    The device shall STALL the Bulk-In pipe.

You're loading the mass-storage gadget with the "stall=n" module
parameter, right?  Therefore the driver is not allowed to halt the
Bulk-In endpoint, and therefore the driver is not allowed to send less
data than the host indicated, which means the data has to be padded.

On the other hand, I don't think any implementations would get upset if 
we simply ended the transfer with a short packet instead of adhering 
strictly to the spec.

The patch below should do what you want.  I haven't tested it.

Alan Stern



 drivers/usb/gadget/f_mass_storage.c |   54 +++++++-----------------------------
 drivers/usb/gadget/file_storage.c   |   53 ++++++++---------------------------
 2 files changed, 23 insertions(+), 84 deletions(-)

Index: usb-2.6/drivers/usb/gadget/f_mass_storage.c
===================================================================
--- usb-2.6.orig/drivers/usb/gadget/f_mass_storage.c
+++ usb-2.6/drivers/usb/gadget/f_mass_storage.c
@@ -1584,37 +1584,6 @@ static int wedge_bulk_in_endpoint(struct
 	return rc;
 }
 
-static int pad_with_zeros(struct fsg_dev *fsg)
-{
-	struct fsg_buffhd	*bh = fsg->common->next_buffhd_to_fill;
-	u32			nkeep = bh->inreq->length;
-	u32			nsend;
-	int			rc;
-
-	bh->state = BUF_STATE_EMPTY;		/* For the first iteration */
-	fsg->common->usb_amount_left = nkeep + fsg->common->residue;
-	while (fsg->common->usb_amount_left > 0) {
-
-		/* Wait for the next buffer to be free */
-		while (bh->state != BUF_STATE_EMPTY) {
-			rc = sleep_thread(fsg->common);
-			if (rc)
-				return rc;
-		}
-
-		nsend = min(fsg->common->usb_amount_left, FSG_BUFLEN);
-		memset(bh->buf + nkeep, 0, nsend - nkeep);
-		bh->inreq->length = nsend;
-		bh->inreq->zero = 0;
-		start_transfer(fsg, fsg->bulk_in, bh->inreq,
-			       &bh->inreq_busy, &bh->state);
-		bh = fsg->common->next_buffhd_to_fill = bh->next;
-		fsg->common->usb_amount_left -= nsend;
-		nkeep = 0;
-	}
-	return 0;
-}
-
 static int throw_away_data(struct fsg_common *common)
 {
 	struct fsg_buffhd	*bh;
@@ -1702,6 +1671,10 @@ static int finish_reply(struct fsg_commo
 		if (common->data_size == 0) {
 			/* Nothing to send */
 
+		/* Don't know what to do if common->fsg is NULL */
+		} else if (!common->fsg) {
+			rc = -EIO;
+
 		/* If there's no residue, simply send the last buffer */
 		} else if (common->residue == 0) {
 			bh->inreq->zero = 0;
@@ -1710,24 +1683,19 @@ static int finish_reply(struct fsg_commo
 			common->next_buffhd_to_fill = bh->next;
 
 		/*
-		 * For Bulk-only, if we're allowed to stall then send the
-		 * short packet and halt the bulk-in endpoint.  If we can't
-		 * stall, pad out the remaining data with 0's.
+		 * For Bulk-only, mark the end of the data with a short
+		 * packet.  If we are allowed to stall, halt the bulk-in
+		 * endpoint.  (Note: This violates the Bulk-Only Transport
+		 * specification, which requires us to pad the data if we
+		 * don't halt the endpoint.  Presumably nobody will mind.)
 		 */
-		} else if (common->can_stall) {
+		} else {
 			bh->inreq->zero = 1;
 			if (!start_in_transfer(common, bh))
-				/* Don't know what to do if
-				 * common->fsg is NULL */
 				rc = -EIO;
 			common->next_buffhd_to_fill = bh->next;
-			if (common->fsg)
+			if (common->can_stall)
 				rc = halt_bulk_in_endpoint(common->fsg);
-		} else if (fsg_is_set(common)) {
-			rc = pad_with_zeros(common->fsg);
-		} else {
-			/* Don't know what to do if common->fsg is NULL */
-			rc = -EIO;
 		}
 		break;
 
Index: usb-2.6/drivers/usb/gadget/file_storage.c
===================================================================
--- usb-2.6.orig/drivers/usb/gadget/file_storage.c
+++ usb-2.6/drivers/usb/gadget/file_storage.c
@@ -1947,37 +1947,6 @@ static int wedge_bulk_in_endpoint(struct
 	return rc;
 }
 
-static int pad_with_zeros(struct fsg_dev *fsg)
-{
-	struct fsg_buffhd	*bh = fsg->next_buffhd_to_fill;
-	u32			nkeep = bh->inreq->length;
-	u32			nsend;
-	int			rc;
-
-	bh->state = BUF_STATE_EMPTY;		// For the first iteration
-	fsg->usb_amount_left = nkeep + fsg->residue;
-	while (fsg->usb_amount_left > 0) {
-
-		/* Wait for the next buffer to be free */
-		while (bh->state != BUF_STATE_EMPTY) {
-			rc = sleep_thread(fsg);
-			if (rc)
-				return rc;
-		}
-
-		nsend = min(fsg->usb_amount_left, (u32) mod_data.buflen);
-		memset(bh->buf + nkeep, 0, nsend - nkeep);
-		bh->inreq->length = nsend;
-		bh->inreq->zero = 0;
-		start_transfer(fsg, fsg->bulk_in, bh->inreq,
-				&bh->inreq_busy, &bh->state);
-		bh = fsg->next_buffhd_to_fill = bh->next;
-		fsg->usb_amount_left -= nsend;
-		nkeep = 0;
-	}
-	return 0;
-}
-
 static int throw_away_data(struct fsg_dev *fsg)
 {
 	struct fsg_buffhd	*bh;
@@ -2082,18 +2051,20 @@ static int finish_reply(struct fsg_dev *
 			}
 		}
 
-		/* For Bulk-only, if we're allowed to stall then send the
-		 * short packet and halt the bulk-in endpoint.  If we can't
-		 * stall, pad out the remaining data with 0's. */
+		/*
+		 * For Bulk-only, mark the end of the data with a short
+		 * packet.  If we are allowed to stall, halt the bulk-in
+		 * endpoint.  (Note: This violates the Bulk-Only Transport
+		 * specification, which requires us to pad the data if we
+		 * don't halt the endpoint.  Presumably nobody will mind.)
+		 */
 		else {
-			if (mod_data.can_stall) {
-				bh->inreq->zero = 1;
-				start_transfer(fsg, fsg->bulk_in, bh->inreq,
-						&bh->inreq_busy, &bh->state);
-				fsg->next_buffhd_to_fill = bh->next;
+			bh->inreq->zero = 1;
+			start_transfer(fsg, fsg->bulk_in, bh->inreq,
+					&bh->inreq_busy, &bh->state);
+			fsg->next_buffhd_to_fill = bh->next;
+			if (mod_data.can_stall)
 				rc = halt_bulk_in_endpoint(fsg);
-			} else
-				rc = pad_with_zeros(fsg);
 		}
 		break;
 

