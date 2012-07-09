Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2GIJqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:46:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12529 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2GIJqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:46:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 09 Jul 2012 02:46:34 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v2] usb: host: Fix possible kernel crash
Date: Mon, 9 Jul 2012 15:15:51 +0530
Message-ID: <1341827151-21991-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In functions itd_complete &  sitd_complete, a pointer
by name stream may get dereferenced after freeing it, when
iso_stream_put is called with stream->refcount = 2.

Hence fixing it.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
In Patchset 1, modified parameter of iso_stream_put() to handle the crash.

However the crash can be handled without modifying the function 
parameter, by just adding a local variable in the functions that call 
iso_stream_put(). Hence implemented it in the current patch.

 drivers/usb/host/ehci-sched.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 33182c6..20d0c38 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1715,6 +1715,7 @@ itd_complete (
 	struct ehci_iso_stream			*stream = itd->stream;
 	struct usb_device			*dev;
 	unsigned				retval = false;
+	u32					stream_ref_count = 0;
 
 	/* for each uframe with a packet */
 	for (uframe = 0; uframe < 8; uframe++) {
@@ -1783,7 +1784,8 @@ itd_complete (
 			dev->devpath, stream->bEndpointAddress & 0x0f,
 			(stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out");
 	}
-	iso_stream_put (ehci, stream);
+	stream_ref_count = stream->refcount;
+	iso_stream_put(ehci, stream);
 
 done:
 	itd->urb = NULL;
@@ -1797,7 +1799,7 @@ done:
 		 * Move it to a safe place until a new frame starts.
 		 */
 		list_move(&itd->itd_list, &ehci->cached_itd_list);
-		if (stream->refcount == 2) {
+		if (stream_ref_count == 3) {
 			/* If iso_stream_put() were called here, stream
 			 * would be freed.  Instead, just prevent reuse.
 			 */
@@ -1866,7 +1868,7 @@ done_not_linked:
 
 done:
 	if (unlikely (status < 0))
-		iso_stream_put (ehci, stream);
+		iso_stream_put(ehci, stream);
 	return status;
 }
 
@@ -2127,6 +2129,7 @@ sitd_complete (
 	struct ehci_iso_stream			*stream = sitd->stream;
 	struct usb_device			*dev;
 	unsigned				retval = false;
+	u32					stream_ref_count = 0;
 
 	urb_index = sitd->index;
 	desc = &urb->iso_frame_desc [urb_index];
@@ -2179,7 +2182,8 @@ sitd_complete (
 			dev->devpath, stream->bEndpointAddress & 0x0f,
 			(stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out");
 	}
-	iso_stream_put (ehci, stream);
+	stream_ref_count = stream->refcount;
+	iso_stream_put(ehci, stream);
 
 done:
 	sitd->urb = NULL;
@@ -2193,7 +2197,7 @@ done:
 		 * Move it to a safe place until a new frame starts.
 		 */
 		list_move(&sitd->sitd_list, &ehci->cached_sitd_list);
-		if (stream->refcount == 2) {
+		if (stream_ref_count == 3) {
 			/* If iso_stream_put() were called here, stream
 			 * would be freed.  Instead, just prevent reuse.
 			 */
@@ -2259,7 +2263,7 @@ done_not_linked:
 
 done:
 	if (status < 0)
-		iso_stream_put (ehci, stream);
+		iso_stream_put(ehci, stream);
 	return status;
 }
 
-- 
1.7.1.1

