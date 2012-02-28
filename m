Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965183Ab2B1BgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:36:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797Ab2B1BHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:07:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.73.234 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010211.493534334@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andiry Xu <andiry.xu@amd.com>
Subject: [ 44/73] xhci: Fix encoding for HS bulk/control NAK rate.
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 340a3504fd39dad753ba908fb6f894ee81fc3ae2 upstream.

The xHCI 0.96 spec says that HS bulk and control endpoint NAK rate must
be encoded as an exponent of two number of microframes.  The endpoint
descriptor has the NAK rate encoded in number of microframes.  We were
just copying the value from the endpoint descriptor into the endpoint
context interval field, which was not correct.  This lead to the VIA
host rejecting the add of a bulk OUT endpoint from any USB 2.0 mass
storage device.

The fix is to use the correct encoding.  Refactor the code to convert
number of frames to an exponential number of microframes, and make sure
we convert the number of microframes in HS bulk and control endpoints to
an exponent.

This should be back ported to kernels as old as 2.6.31, that contain the
commit dfa49c4ad120a784ef1ff0717168aa79f55a483a "USB: xhci - fix math
in xhci_get_endpoint_interval"

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Felipe Contreras <felipe.contreras@gmail.com>
Suggested-by: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-mem.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1002,26 +1002,42 @@ static unsigned int xhci_parse_exponent_
 }
 
 /*
- * Convert bInterval expressed in frames (in 1-255 range) to exponent of
+ * Convert bInterval expressed in microframes (in 1-255 range) to exponent of
  * microframes, rounded down to nearest power of 2.
  */
-static unsigned int xhci_parse_frame_interval(struct usb_device *udev,
-		struct usb_host_endpoint *ep)
+static unsigned int xhci_microframes_to_exponent(struct usb_device *udev,
+		struct usb_host_endpoint *ep, unsigned int desc_interval,
+		unsigned int min_exponent, unsigned int max_exponent)
 {
 	unsigned int interval;
 
-	interval = fls(8 * ep->desc.bInterval) - 1;
-	interval = clamp_val(interval, 3, 10);
-	if ((1 << interval) != 8 * ep->desc.bInterval)
+	interval = fls(desc_interval) - 1;
+	interval = clamp_val(interval, min_exponent, max_exponent);
+	if ((1 << interval) != desc_interval)
 		dev_warn(&udev->dev,
 			 "ep %#x - rounding interval to %d microframes, ep desc says %d microframes\n",
 			 ep->desc.bEndpointAddress,
 			 1 << interval,
-			 8 * ep->desc.bInterval);
+			 desc_interval);
 
 	return interval;
 }
 
+static unsigned int xhci_parse_microframe_interval(struct usb_device *udev,
+		struct usb_host_endpoint *ep)
+{
+	return xhci_microframes_to_exponent(udev, ep,
+			ep->desc.bInterval, 0, 15);
+}
+
+
+static unsigned int xhci_parse_frame_interval(struct usb_device *udev,
+		struct usb_host_endpoint *ep)
+{
+	return xhci_microframes_to_exponent(udev, ep,
+			ep->desc.bInterval * 8, 3, 10);
+}
+
 /* Return the polling or NAK interval.
  *
  * The polling interval is expressed in "microframes".  If xHCI's Interval field
@@ -1040,7 +1056,7 @@ static unsigned int xhci_get_endpoint_in
 		/* Max NAK rate */
 		if (usb_endpoint_xfer_control(&ep->desc) ||
 		    usb_endpoint_xfer_bulk(&ep->desc)) {
-			interval = ep->desc.bInterval;
+			interval = xhci_parse_microframe_interval(udev, ep);
 			break;
 		}
 		/* Fall through - SS and HS isoc/int have same decoding */


