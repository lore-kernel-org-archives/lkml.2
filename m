Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197Ab2J2RFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:05:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42670 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130Ab2J2RFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:05:09 -0400
From: Julius Werner <jwerner@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] xhci: fix null-pointer dereference when destroying half-built segment rings
Date: Mon, 29 Oct 2012 10:00:30 -0700
Message-Id: <1351530030-7080-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.7.7.3
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
 drivers/usb/host/xhci-mem.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 487bc08..420ba37 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -205,7 +205,11 @@ static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
 
 		next = xhci_segment_alloc(xhci, cycle_state, flags);
 		if (!next) {
-			xhci_free_segments_for_ring(xhci, *first);
+			prev = *first;
+			do {
+				next = prev->next;
+				xhci_segment_free(xhci, prev);
+			} while ((prev = next));
 			return -ENOMEM;
 		}
 		xhci_link_segments(xhci, prev, next, type);
@@ -258,7 +262,7 @@ static struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci,
 	return ring;
 
 fail:
-	xhci_ring_free(xhci, ring);
+	kfree(ring);
 	return NULL;
 }
 
-- 
1.7.8.6

