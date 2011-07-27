Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab1G0VtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:13692 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab1G0VtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274706"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: dtor@vmware.com, sarah.a.sharp@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [51/99] USB: xhci - fix interval calculation for FS isoc endpoints
Message-Id: <20110727214850.3DF172403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-mem.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci-mem.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-mem.c
+++ linux-2.6.35.y/drivers/usb/host/xhci-mem.c
@@ -974,9 +974,19 @@ static unsigned int xhci_parse_exponent_
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
