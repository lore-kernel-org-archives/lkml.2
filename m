Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162924Ab1FAIZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:25:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:44922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162862Ab1FAIZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:25:35 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:01 2011
Message-Id: <20110601081200.986282036@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:28 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [118/165] xhci: Fix memory leak in ring cache deallocation.
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2333
Lines: 60

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 30f89ca021c3e584b61bc5a14eede89f74b2e826 upstream.

When an endpoint ring is freed, it is either cached in a per-device ring
cache, or simply freed if the ring cache is full.  If the ring was added
to the cache, then virt_dev->num_rings_cached is incremented.  The cache
is designed to hold up to 31 endpoint rings, in array indexes 0 to 30.
When the device is freed (when the slot was disabled),
xhci_free_virt_device() is called, it would free the cached rings in
array indexes 0 to virt_dev->num_rings_cached.

Unfortunately, the original code in xhci_free_or_cache_endpoint_ring()
would put the first entry into the ring cache in array index 1, instead of
array index 0.  This was caused by the second assignment to rings_cached:

	rings_cached = virt_dev->num_rings_cached;
	if (rings_cached < XHCI_MAX_RINGS_CACHED) {
		virt_dev->num_rings_cached++;
		rings_cached = virt_dev->num_rings_cached;
		virt_dev->ring_cache[rings_cached] =
			virt_dev->eps[ep_index].ring;

This meant that when the device was freed, cached rings with indexes 0 to
N would be freed, and the last cached ring in index N+1 would not be
freed.  When the driver was unloaded, this caused interesting messages
like:

xhci_hcd 0000:06:00.0: dma_pool_destroy xHCI ring segments, ffff880063040000 busy

This should be queued to stable kernels back to 2.6.33.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -207,14 +207,13 @@ void xhci_free_or_cache_endpoint_ring(st
 
 	rings_cached = virt_dev->num_rings_cached;
 	if (rings_cached < XHCI_MAX_RINGS_CACHED) {
-		virt_dev->num_rings_cached++;
-		rings_cached = virt_dev->num_rings_cached;
 		virt_dev->ring_cache[rings_cached] =
 			virt_dev->eps[ep_index].ring;
+		virt_dev->num_rings_cached++;
 		xhci_dbg(xhci, "Cached old ring, "
 				"%d ring%s cached\n",
-				rings_cached,
-				(rings_cached > 1) ? "s" : "");
+				virt_dev->num_rings_cached,
+				(virt_dev->num_rings_cached > 1) ? "s" : "");
 	} else {
 		xhci_ring_free(xhci, virt_dev->eps[ep_index].ring);
 		xhci_dbg(xhci, "Ring cache full (%d rings), "


