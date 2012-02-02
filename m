Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2BBUiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:38:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46333 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753222Ab2BBUiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:38:15 -0500
Date: Thu, 2 Feb 2012 15:38:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Keith Packard <keithp@keithp.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] USB: debugging code shouldn't alter control flow
In-Reply-To: <20120202105059.GC1643@atrey.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.44L0.1202021536080.1389-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People have complained that debugging code shouldn't alter the flow of
control; it should restrict itself to printing out warnings and error
messages.  Bowing to popular opinion, this patch (as1518) changes the
debugging checks in usb_submit_urb() to follow this guideline.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Keith Packard <keithp@keithp.com>
CC: Pavel Machek <pavel@ucw.cz>

---

 drivers/usb/core/urb.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

Index: usb-3.3/drivers/usb/core/urb.c
===================================================================
--- usb-3.3.orig/drivers/usb/core/urb.c
+++ usb-3.3/drivers/usb/core/urb.c
@@ -403,20 +403,17 @@ int usb_submit_urb(struct urb *urb, gfp_
 	 * cause problems in HCDs if they get it wrong.
 	 */
 	{
-	unsigned int	orig_flags = urb->transfer_flags;
 	unsigned int	allowed;
 	static int pipetypes[4] = {
 		PIPE_CONTROL, PIPE_ISOCHRONOUS, PIPE_BULK, PIPE_INTERRUPT
 	};
 
 	/* Check that the pipe's type matches the endpoint's type */
-	if (usb_pipetype(urb->pipe) != pipetypes[xfertype]) {
-		dev_err(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
+	if (usb_pipetype(urb->pipe) != pipetypes[xfertype])
+		dev_WARN(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
 			usb_pipetype(urb->pipe), pipetypes[xfertype]);
-		return -EPIPE;		/* The most suitable error code :-) */
-	}
 
-	/* enforce simple/standard policy */
+	/* Check against a simple/standard policy */
 	allowed = (URB_NO_TRANSFER_DMA_MAP | URB_NO_INTERRUPT | URB_DIR_MASK |
 			URB_FREE_BUFFER);
 	switch (xfertype) {
@@ -435,14 +432,12 @@ int usb_submit_urb(struct urb *urb, gfp_
 		allowed |= URB_ISO_ASAP;
 		break;
 	}
-	urb->transfer_flags &= allowed;
+	allowed &= urb->transfer_flags;
 
-	/* fail if submitter gave bogus flags */
-	if (urb->transfer_flags != orig_flags) {
-		dev_err(&dev->dev, "BOGUS urb flags, %x --> %x\n",
-			orig_flags, urb->transfer_flags);
-		return -EINVAL;
-	}
+	/* warn if submitter gave bogus flags */
+	if (allowed != urb->transfer_flags)
+		dev_WARN(&dev->dev, "BOGUS urb flags, %x --> %x\n",
+			urb->transfer_flags, allowed);
 	}
 #endif
 	/*

