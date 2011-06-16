Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab1FPHLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57598 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756615Ab1FPHLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:23 -0400
X-Sasl-enc: izR9NLJXfvggpUjXVMzpiJTTCAj/wCPrRptdbKMK5fDW 1308208282
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:11 2011
Message-Id: <20110616002910.971201404@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@vmware.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [71/85] USB: xhci - fix interval calculation for FS isoc endpoints
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dtor@vmware.com>

commit cd3c18ba2fac14b34d03cae111f215009735ea06 upstream.

Full-speed isoc endpoints specify interval in exponent based form in
frames, not microframes, so we need to adjust accordingly.

NEC xHCI host controllers will return an error code of 0x11 if a full
speed isochronous endpoint is added with the Interval field set to
something less than 3 (2^3 = 8 microframes, or one frame).  It is
impossible for a full speed device to have an interval smaller than one
frame.

This was always an issue in the xHCI driver, but commit
dfa49c4ad120a784ef1ff0717168aa79f55a483a "USB: xhci - fix math in
xhci_get_endpoint_interval()" removed the clamping of the minimum value
in the Interval field, which revealed this bug.

This needs to be backported to stable kernels back to 2.6.31.

Reported-by: Matt Evans <matt@ozlabs.org>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -505,9 +505,19 @@ static unsigned int xhci_parse_exponent_
 	interval = clamp_val(ep->desc.bInterval, 1, 16) - 1;
 	if (interval != ep->desc.bInterval - 1)
 		dev_warn(&udev->dev,
-			 "ep %#x - rounding interval to %d microframes\n",
+			 "ep %#x - rounding interval to %d %sframes\n",
 			 ep->desc.bEndpointAddress,
-			 1 << interval);
+			 1 << interval,
+			 udev->speed == USB_SPEED_FULL ? "" : "micro");
+
+	if (udev->speed == USB_SPEED_FULL) {
+		/*
+		 * Full speed isoc endpoints specify interval in frames,
+		 * not microframes. We are using microframes everywhere,
+		 * so adjust accordingly.
+		 */
+		interval += 3;	/* 1 frame = 2^3 uframes */
+	}
 
 	return interval;
 }


