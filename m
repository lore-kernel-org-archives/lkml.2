Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab0CaAGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:06:46 -0400
Received: from kroah.org ([198.145.64.141]:45242 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab0C3XSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:23 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:40 2010
Message-Id: <20100330225639.999195448@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [064/116] USB: EHCI: fix ITD list order
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 92bc3648e6027384479852b770a542722fadee7c upstream.

When isochronous URBs are shorter than one frame and when more than one
ITD in a frame has been completed before the interrupt can be handled,
scan_periodic() completes the URBs in the order in which they are found
in the descriptor list.  Therefore, the descriptor list must contain the
ITDs in the correct order, i.e., a new ITD must be linked in after any
previous ITDs of the same endpoint.

This should fix garbled capture data in the USB audio drivers.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-by: Colin Fletcher <colin.m.fletcher@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-sched.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1553,13 +1553,27 @@ itd_patch(
 static inline void
 itd_link (struct ehci_hcd *ehci, unsigned frame, struct ehci_itd *itd)
 {
-	/* always prepend ITD/SITD ... only QH tree is order-sensitive */
-	itd->itd_next = ehci->pshadow [frame];
-	itd->hw_next = ehci->periodic [frame];
-	ehci->pshadow [frame].itd = itd;
+	union ehci_shadow	*prev = &ehci->pshadow[frame];
+	__hc32			*hw_p = &ehci->periodic[frame];
+	union ehci_shadow	here = *prev;
+	__hc32			type = 0;
+
+	/* skip any iso nodes which might belong to previous microframes */
+	while (here.ptr) {
+		type = Q_NEXT_TYPE(ehci, *hw_p);
+		if (type == cpu_to_hc32(ehci, Q_TYPE_QH))
+			break;
+		prev = periodic_next_shadow(ehci, prev, type);
+		hw_p = shadow_next_periodic(ehci, &here, type);
+		here = *prev;
+	}
+
+	itd->itd_next = here;
+	itd->hw_next = *hw_p;
+	prev->itd = itd;
 	itd->frame = frame;
 	wmb ();
-	ehci->periodic[frame] = cpu_to_hc32(ehci, itd->itd_dma | Q_TYPE_ITD);
+	*hw_p = cpu_to_hc32(ehci, itd->itd_dma | Q_TYPE_ITD);
 }
 
 /* fit urb's itds into the selected schedule slot; activate as needed */


