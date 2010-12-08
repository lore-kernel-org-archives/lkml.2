Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab0LHBbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:31:12 -0500
Received: from kroah.org ([198.145.64.141]:49103 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab0LHBB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:56 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:37 2010
Message-Id: <20101208005737.013400723@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [156/289] firewire: ohci: fix race in AR split packet handling
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit a1f805e5e73a8fe166b71c6592d3837df0cd5e2e upstream.

When handling an AR buffer that has been completely filled, we assumed
that its descriptor will not be read by the controller and can be
overwritten.  However, when the last received packet happens to end at
the end of the buffer, the controller might not yet have moved on to the
next buffer and might read the branch address later.  If we overwrite
and free the page before that, the DMA context will either go dead
because of an invalid Z value, or go off into some random memory.

To fix this, ensure that the descriptor does not get overwritten by
using only the actual buffer instead of the entire page for reassembling
the split packet.  Furthermore, to avoid freeing the page too early,
move on to the next buffer only when some data in it guarantees that the
controller has moved on.

This should eliminate the remaining firewire-net problems.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/ohci.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -750,20 +750,19 @@ static void ar_context_tasklet(unsigned
 		 */
 
 		offset = offsetof(struct ar_buffer, data);
-		start = buffer = ab;
+		start = ab;
 		start_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
+		buffer = ab->data;
 
 		ab = ab->next;
 		d = &ab->descriptor;
-		size = buffer + PAGE_SIZE - ctx->pointer;
+		size = start + PAGE_SIZE - ctx->pointer;
 		/* valid buffer data in the next page */
 		rest = le16_to_cpu(d->req_count) - le16_to_cpu(d->res_count);
 		/* what actually fits in this page */
-		size2 = min(rest, (size_t)PAGE_SIZE - size);
+		size2 = min(rest, (size_t)PAGE_SIZE - offset - size);
 		memmove(buffer, ctx->pointer, size);
 		memcpy(buffer + size, ab->data, size2);
-		ctx->current_buffer = ab;
-		ctx->pointer = (void *) ab->data + rest;
 
 		while (size > 0) {
 			void *next = handle_ar_packet(ctx, buffer);
@@ -782,22 +781,30 @@ static void ar_context_tasklet(unsigned
 			size -= pktsize;
 			/* fill up this page again */
 			size3 = min(rest - size2,
-				    (size_t)PAGE_SIZE - size - size2);
+				    (size_t)PAGE_SIZE - offset - size - size2);
 			memcpy(buffer + size + size2,
 			       (void *) ab->data + size2, size3);
 			size2 += size3;
 		}
 
-		/* handle the packets that are fully in the next page */
-		buffer = (void *) ab->data + (buffer - (start + size));
-		end = (void *) ab->data + rest;
-
-		while (buffer < end)
-			buffer = handle_ar_packet(ctx, buffer);
-
-		dma_free_coherent(ohci->card.device, PAGE_SIZE,
-				  start, start_bus);
-		ar_context_add_page(ctx);
+		if (rest > 0) {
+			/* handle the packets that are fully in the next page */
+			buffer = (void *) ab->data +
+					(buffer - (start + offset + size));
+			end = (void *) ab->data + rest;
+
+			while (buffer < end)
+				buffer = handle_ar_packet(ctx, buffer);
+
+			ctx->current_buffer = ab;
+			ctx->pointer = end;
+
+			dma_free_coherent(ohci->card.device, PAGE_SIZE,
+					  start, start_bus);
+			ar_context_add_page(ctx);
+		} else {
+			ctx->pointer = start + PAGE_SIZE;
+		}
 	} else {
 		buffer = ctx->pointer;
 		ctx->pointer = end =


