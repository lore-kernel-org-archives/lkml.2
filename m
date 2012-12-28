Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab2L1TT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55527 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932277Ab2L1TTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:20 -0500
Message-Id: <20121228190341.621376713@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julius Werner <jwerner@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 055/173] xhci: fix null-pointer dereference when destroying half-built
 segment rings
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Werner <jwerner@chromium.org>

commit 68e5254adb88bede68285f11fb442a4d34fb550c upstream.

xhci_alloc_segments_for_ring() builds a list of xhci_segments and links
the tail to head at the end (forming a ring). When it bails out for OOM
reasons half-way through, it tries to destroy its half-built list with
xhci_free_segments_for_ring(), even though it is not a ring yet. This
causes a null-pointer dereference upon hitting the last element.

Furthermore, one of its callers (xhci_ring_alloc()) mistakenly believes
the output parameters to be valid upon this kind of OOM failure, and
calls xhci_ring_free() on them. Since the (incomplete) list/ring should
already be destroyed in that case, this would lead to a use after free.

This patch fixes those issues by having xhci_alloc_segments_for_ring()
destroy its half-built, non-circular list manually and destroying the
invalid struct xhci_ring in xhci_ring_alloc() with a plain kfree().

This patch should be backported to kernels as old as 2.6.31, that
contains the commit 0ebbab37422315a5d0cb29792271085bafdf38c0 "USB: xhci:
Ring allocation and initialization."

A separate patch will need to be developed for kernels older than 3.4,
since the ring allocation code was refactored in that kernel.

Signed-off-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Since segment allocation is done directly in xhci_ring_alloc(), walk
   the list starting from ring->first_seg when freeing]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -178,8 +178,15 @@ static struct xhci_ring *xhci_ring_alloc
 		struct xhci_segment	*next;
 
 		next = xhci_segment_alloc(xhci, flags);
-		if (!next)
+		if (!next) {
+			prev = ring->first_seg;
+			while (prev) {
+				next = prev->next;
+				xhci_segment_free(xhci, prev);
+				prev = next;
+			}
 			goto fail;
+		}
 		xhci_link_segments(xhci, prev, next, link_trbs, isoc);
 
 		prev = next;
@@ -199,7 +206,7 @@ static struct xhci_ring *xhci_ring_alloc
 	return ring;
 
 fail:
-	xhci_ring_free(xhci, ring);
+	kfree(ring);
 	return NULL;
 }
 


