Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab1DZVRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:17:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:21108 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500Ab1DZVPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951716"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: micah@vmware.com, dtor@vmware.com, sarah.a.sharp@linux.intel.com,
        ak@linux.intel.com, stable@kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [104/106] From: USB: xhci - also free streams when resetting devices
Message-Id: <20110426211427.186303E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Date: Tue, 12 Apr 2011 23:06:28 -0700
Subject: [PATCH] USB: xhci - also free streams when resetting devices

upstream commit: 2dea75d96ade3c7cd2bfe73f99c7b3291dc3d03a

Currently, when resetting a device, xHCI driver disables all but one
endpoints and frees their rings, but leaves alone any streams that
might have been allocated. Later, when users try to free allocated
streams, we oops in xhci_setup_no_streams_ep_input_ctx() because
ep->ring is NULL.

Let's free not only rings but also stream data as well, so that
calling free_streams() on a device that was reset will be safe.

This should be queued for stable trees back to 2.6.35.

Reviewed-by: Micah Elizabeth Scott <micah@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@kernel.org
---
 drivers/usb/host/xhci.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci.c
+++ linux-2.6.35.y/drivers/usb/host/xhci.c
@@ -2010,10 +2010,18 @@ int xhci_reset_device(struct usb_hcd *hc
 	/* Everything but endpoint 0 is disabled, so free or cache the rings. */
 	last_freed_endpoint = 1;
 	for (i = 1; i < 31; ++i) {
-		if (!virt_dev->eps[i].ring)
-			continue;
-		xhci_free_or_cache_endpoint_ring(xhci, virt_dev, i);
-		last_freed_endpoint = i;
+		struct xhci_virt_ep *ep = &virt_dev->eps[i];
+
+		if (ep->ep_state & EP_HAS_STREAMS) {
+			xhci_free_stream_info(xhci, ep->stream_info);
+			ep->stream_info = NULL;
+			ep->ep_state &= ~EP_HAS_STREAMS;
+		}
+
+		if (ep->ring) {
+			xhci_free_or_cache_endpoint_ring(xhci, virt_dev, i);
+			last_freed_endpoint = i;
+		}
 	}
 	xhci_dbg(xhci, "Output context after successful reset device cmd:\n");
 	xhci_dbg_ctx(xhci, virt_dev->out_ctx, last_freed_endpoint);
