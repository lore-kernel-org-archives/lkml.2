Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1DZVYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:24:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab1DZVOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831918"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: dtor@vmware.com, micah@vmware.com, sarah.a.sharp@linux.intel.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [77/106] USB: xhci - fix math in xhci_get_endpoint_interval()
Message-Id: <20110426211358.C58BB3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dmitry Torokhov <dtor@vmware.com>

commit dfa49c4ad120a784ef1ff0717168aa79f55a483a upstream.

When parsing exponent-expressed intervals we subtract 1 from the
value and then expect it to match with original + 1, which is
highly unlikely, and we end with frequent spew:

	usb 3-4: ep 0x83 - rounding interval to 512 microframes

Also, parsing interval for fullspeed isochronous endpoints was
incorrect - according to USB spec they use exponent-based
intervals (but xHCI spec claims frame-based intervals). I trust
USB spec more, especially since USB core agrees with it.

This should be queued for stable kernels back to 2.6.31.

Reviewed-by: Micah Elizabeth Scott <micah@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci-mem.c |   85 ++++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 23 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci-mem.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci-mem.c
+++ linux-2.6.35.y/drivers/usb/host/xhci-mem.c
@@ -961,6 +961,47 @@ int xhci_setup_addressable_virt_dev(stru
 	return 0;
 }
 
+/*
+ * Convert interval expressed as 2^(bInterval - 1) == interval into
+ * straight exponent value 2^n == interval.
+ *
+ */
+static unsigned int xhci_parse_exponent_interval(struct usb_device *udev,
+		struct usb_host_endpoint *ep)
+{
+	unsigned int interval;
+
+	interval = clamp_val(ep->desc.bInterval, 1, 16) - 1;
+	if (interval != ep->desc.bInterval - 1)
+		dev_warn(&udev->dev,
+			 "ep %#x - rounding interval to %d microframes\n",
+			 ep->desc.bEndpointAddress,
+			 1 << interval);
+
+	return interval;
+}
+
+/*
+ * Convert bInterval expressed in frames (in 1-255 range) to exponent of
+ * microframes, rounded down to nearest power of 2.
+ */
+static unsigned int xhci_parse_frame_interval(struct usb_device *udev,
+		struct usb_host_endpoint *ep)
+{
+	unsigned int interval;
+
+	interval = fls(8 * ep->desc.bInterval) - 1;
+	interval = clamp_val(interval, 3, 10);
+	if ((1 << interval) != 8 * ep->desc.bInterval)
+		dev_warn(&udev->dev,
+			 "ep %#x - rounding interval to %d microframes, ep desc says %d microframes\n",
+			 ep->desc.bEndpointAddress,
+			 1 << interval,
+			 8 * ep->desc.bInterval);
+
+	return interval;
+}
+
 /* Return the polling or NAK interval.
  *
  * The polling interval is expressed in "microframes".  If xHCI's Interval field
@@ -978,43 +1019,35 @@ static inline unsigned int xhci_get_endp
 	case USB_SPEED_HIGH:
 		/* Max NAK rate */
 		if (usb_endpoint_xfer_control(&ep->desc) ||
-				usb_endpoint_xfer_bulk(&ep->desc))
+		    usb_endpoint_xfer_bulk(&ep->desc)) {
 			interval = ep->desc.bInterval;
+			break;
+		}
 		/* Fall through - SS and HS isoc/int have same decoding */
 	case USB_SPEED_SUPER:
 		if (usb_endpoint_xfer_int(&ep->desc) ||
-				usb_endpoint_xfer_isoc(&ep->desc)) {
-			if (ep->desc.bInterval == 0)
-				interval = 0;
-			else
-				interval = ep->desc.bInterval - 1;
-			if (interval > 15)
-				interval = 15;
-			if (interval != ep->desc.bInterval + 1)
-				dev_warn(&udev->dev, "ep %#x - rounding interval to %d microframes\n",
-						ep->desc.bEndpointAddress, 1 << interval);
+		    usb_endpoint_xfer_isoc(&ep->desc)) {
+			interval = xhci_parse_exponent_interval(udev, ep);
 		}
 		break;
 	/* Convert bInterval (in 1-255 frames) to microframes and round down to
 	 * nearest power of 2.
 	 */
 	case USB_SPEED_FULL:
+		if (usb_endpoint_xfer_int(&ep->desc)) {
+			interval = xhci_parse_exponent_interval(udev, ep);
+			break;
+		}
+		/*
+		 * Fall through for isochronous endpoint interval decoding
+		 * since it uses the same rules as low speed interrupt
+		 * endpoints.
+		 */
 	case USB_SPEED_LOW:
 		if (usb_endpoint_xfer_int(&ep->desc) ||
-				usb_endpoint_xfer_isoc(&ep->desc)) {
-			interval = fls(8*ep->desc.bInterval) - 1;
-			if (interval > 10)
-				interval = 10;
-			if (interval < 3)
-				interval = 3;
-			if ((1 << interval) != 8*ep->desc.bInterval)
-				dev_warn(&udev->dev,
-						"ep %#x - rounding interval"
-						" to %d microframes, "
-						"ep desc says %d microframes\n",
-						ep->desc.bEndpointAddress,
-						1 << interval,
-						8*ep->desc.bInterval);
+		    usb_endpoint_xfer_isoc(&ep->desc)) {
+
+			interval = xhci_parse_frame_interval(udev, ep);
 		}
 		break;
 	default:
