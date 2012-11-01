Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161089Ab2KATsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:48:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54706 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab2KATsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:48:23 -0400
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] xhci: fix null-pointer dereference when destroying half-built segment rings
Date: Thu,  1 Nov 2012 12:47:59 -0700
Message-Id: <1351799279-23824-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20121101175217.GJ29270@xanatos>
References: <20121101175217.GJ29270@xanatos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/host/xhci-mem.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 487bc08..fb51c70 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -205,7 +205,12 @@ static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
 
 		next = xhci_segment_alloc(xhci, cycle_state, flags);
 		if (!next) {
-			xhci_free_segments_for_ring(xhci, *first);
+			prev = *first;
+			while (prev) {
+				next = prev->next;
+				xhci_segment_free(xhci, prev);
+				prev = next;
+			}
 			return -ENOMEM;
 		}
 		xhci_link_segments(xhci, prev, next, type);
@@ -258,7 +263,7 @@ static struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci,
 	return ring;
 
 fail:
-	xhci_ring_free(xhci, ring);
+	kfree(ring);
 	return NULL;
 }
 
-- 
1.7.8.6

