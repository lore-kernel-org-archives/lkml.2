Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0C2Pgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:36:51 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:48618 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab0C2Pgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:36:49 -0400
Date: Mon, 29 Mar 2010 17:36:44 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 11/12] drivers/usb/gadget: Add missing unlock
Message-ID: <Pine.LNX.4.64.1003291736250.21896@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In an error handling case the lock is not unlocked.  The return is
converted to a goto, to share the unlock at the end of the function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irqsave (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/gadget/s3c-hsotg.c      |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index f742c8e..85dedf0 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2144,6 +2144,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	u32 epctrl;
 	u32 mps;
 	int dir_in;
+	int ret = 0;
 
 	dev_dbg(hsotg->dev,
 		"%s: ep %s: a 0x%02x, attr 0x%02x, mps 0x%04x, intr %d\n",
@@ -2195,7 +2196,8 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
 	case USB_ENDPOINT_XFER_ISOC:
 		dev_err(hsotg->dev, "no current ISOC support\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 
 	case USB_ENDPOINT_XFER_BULK:
 		epctrl |= S3C_DxEPCTL_EPType_Bulk;
@@ -2234,8 +2236,9 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	/* enable the endpoint interrupt */
 	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
 
+out:
 	spin_unlock_irqrestore(&hs_ep->lock, flags);
-	return 0;
+	return ret;
 }
 
 static int s3c_hsotg_ep_disable(struct usb_ep *ep)
