Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab1KJDfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:35:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43442 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933778Ab1KJDfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:35:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:44 2011
Message-Id: <20111109213144.023670297@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kautuk Consul <consul.kautuk@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [019/264] xhci-mem.c: Check for ring->first_seg != NULL
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kautuk Consul <consul.kautuk@gmail.com>

commit 0e6c7f746ea99089fb3263709075c20485a479ae upstream.

There are 2 situations wherein the xhci_ring* might not get freed:
- When xhci_ring_alloc() -> xhci_segment_alloc() returns NULL and
  we goto the fail: label in xhci_ring_alloc. In this case, the ring
  will not get kfreed.
- When the num_segs argument to xhci_ring_alloc is passed as 0 and
  we try to free the rung after that.
  ( This doesn't really happen as of now in the code but we seem to
    be entertaining num_segs=0 in xhci_ring_alloc )

This should be backported to kernels as old as 2.6.31.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-mem.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -112,18 +112,20 @@ void xhci_ring_free(struct xhci_hcd *xhc
 	struct xhci_segment *seg;
 	struct xhci_segment *first_seg;
 
-	if (!ring || !ring->first_seg)
+	if (!ring)
 		return;
-	first_seg = ring->first_seg;
-	seg = first_seg->next;
-	xhci_dbg(xhci, "Freeing ring at %p\n", ring);
-	while (seg != first_seg) {
-		struct xhci_segment *next = seg->next;
-		xhci_segment_free(xhci, seg);
-		seg = next;
+	if (ring->first_seg) {
+		first_seg = ring->first_seg;
+		seg = first_seg->next;
+		xhci_dbg(xhci, "Freeing ring at %p\n", ring);
+		while (seg != first_seg) {
+			struct xhci_segment *next = seg->next;
+			xhci_segment_free(xhci, seg);
+			seg = next;
+		}
+		xhci_segment_free(xhci, first_seg);
+		ring->first_seg = NULL;
 	}
-	xhci_segment_free(xhci, first_seg);
-	ring->first_seg = NULL;
 	kfree(ring);
 }
 


