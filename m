Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1DSUS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:18:56 -0400
Received: from kroah.org ([198.145.64.141]:35755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab1DSURs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:50 2011
Message-Id: <20110419201050.250139761@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@vmware.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [66/70] USB: xhci - also free streams when resetting devices
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dtor@vmware.com>

commit 2dea75d96ade3c7cd2bfe73f99c7b3291dc3d03a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2335,10 +2335,18 @@ int xhci_discover_or_reset_device(struct
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


