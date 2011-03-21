Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1CUXQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:16:08 -0400
Received: from kroah.org ([198.145.64.141]:49492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab1CUXPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:14 2011
Message-Id: <20110321230714.473276688@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [51/87] USB: Add support for SuperSpeed isoc endpoints
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit 500132a0f26ad7d9916102193cbc6c1b1becb373 upstream.

Use the Mult and bMaxBurst values from the endpoint companion
descriptor to calculate the max length of an isoc transfer.

Add USB_SS_MULT macro to access Mult field of bmAttributes, at
Sarah's suggestion.

This patch should be queued for the 2.6.36 and 2.6.37 stable trees, since
those were the first kernels to have isochronous support for SuperSpeed
devices.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/urb.c  |   11 ++++++++++-
 include/linux/usb/ch9.h |    2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -366,7 +366,16 @@ int usb_submit_urb(struct urb *urb, gfp_
 	if (xfertype == USB_ENDPOINT_XFER_ISOC) {
 		int	n, len;
 
-		/* FIXME SuperSpeed isoc endpoints have up to 16 bursts */
+		/* SuperSpeed isoc endpoints have up to 16 bursts of up to
+		 * 3 packets each
+		 */
+		if (dev->speed == USB_SPEED_SUPER) {
+			int     burst = 1 + ep->ss_ep_comp.bMaxBurst;
+			int     mult = USB_SS_MULT(ep->ss_ep_comp.bmAttributes);
+			max *= burst;
+			max *= mult;
+		}
+
 		/* "high bandwidth" mode, 1-3 packets/uframe? */
 		if (dev->speed == USB_SPEED_HIGH) {
 			int	mult = 1 + ((max >> 11) & 0x03);
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -575,6 +575,8 @@ struct usb_ss_ep_comp_descriptor {
 #define USB_DT_SS_EP_COMP_SIZE		6
 /* Bits 4:0 of bmAttributes if this is a bulk endpoint */
 #define USB_SS_MAX_STREAMS(p)		(1 << (p & 0x1f))
+/* Bits 1:0 of bmAttributes if this is an isoc endpoint */
+#define USB_SS_MULT(p)			(1 + ((p) & 0x3))
 
 /*-------------------------------------------------------------------------*/
 


