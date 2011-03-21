Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab1CUX1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:27:53 -0400
Received: from kroah.org ([198.145.64.141]:52635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289Ab1CUXSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:25 2011
Message-Id: <20110321230325.523921838@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Zimmerman <paulz@synopsys.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [37/78] USB: Add support for SuperSpeed isoc endpoints
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -585,6 +585,8 @@ struct usb_ss_ep_comp_descriptor {
 #define USB_DT_SS_EP_COMP_SIZE		6
 /* Bits 4:0 of bmAttributes if this is a bulk endpoint */
 #define USB_SS_MAX_STREAMS(p)		(1 << (p & 0x1f))
+/* Bits 1:0 of bmAttributes if this is an isoc endpoint */
+#define USB_SS_MULT(p)			(1 + ((p) & 0x3))
 
 /*-------------------------------------------------------------------------*/
 


