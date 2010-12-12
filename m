Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0LMALF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:11:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36190 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab0LLXqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:52 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: clemens@ladisch.de, maximlevitsky@gmail.com, stefanr@s5r6.in-berlin.de,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [110/223] firewire: ohci: fix buffer overflow in AR split packet handling
Message-Id: <20101212234651.12CB1B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 85f7ffd5d2b320f73912b15fe8cef34bae297daf upstream.

When the controller had to split a received asynchronous packet into two
buffers, the driver tries to reassemble it by copying both parts into
the first page.  However, if size + rest > PAGE_SIZE, i.e., if the yet
unhandled packets before the split packet, the split packet itself, and
any received packets after the split packet are together larger than one
page, then the memory after the first page would get overwritten.

To fix this, do not try to copy the data of all unhandled packets at
once, but copy the possibly needed data every time when handling
a packet.

This gets rid of most of the infamous crashes and data corruptions when
using firewire-net.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/firewire/ohci.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/ohci.c
===================================================================
--- linux.orig/drivers/firewire/ohci.c
+++ linux/drivers/firewire/ohci.c
@@ -684,7 +684,7 @@ static void ar_context_tasklet(unsigned
 	d = &ab->descriptor;
 
 	if (d->res_count == 0) {
-		size_t size, rest, offset;
+		size_t size, size2, rest, pktsize, size3, offset;
 		dma_addr_t start_bus;
 		void *start;
 
@@ -701,12 +701,41 @@ static void ar_context_tasklet(unsigned
 		ab = ab->next;
 		d = &ab->descriptor;
 		size = buffer + PAGE_SIZE - ctx->pointer;
+		/* valid buffer data in the next page */
 		rest = le16_to_cpu(d->req_count) - le16_to_cpu(d->res_count);
+		/* what actually fits in this page */
+		size2 = min(rest, (size_t)PAGE_SIZE - size);
 		memmove(buffer, ctx->pointer, size);
-		memcpy(buffer + size, ab->data, rest);
+		memcpy(buffer + size, ab->data, size2);
 		ctx->current_buffer = ab;
 		ctx->pointer = (void *) ab->data + rest;
-		end = buffer + size + rest;
+
+		while (size > 0) {
+			void *next = handle_ar_packet(ctx, buffer);
+			pktsize = next - buffer;
+			if (pktsize >= size) {
+				/*
+				 * We have handled all the data that was
+				 * originally in this page, so we can now
+				 * continue in the next page.
+				 */
+				buffer = next;
+				break;
+			}
+			/* move the next packet to the start of the buffer */
+			memmove(buffer, next, size + size2 - pktsize);
+			size -= pktsize;
+			/* fill up this page again */
+			size3 = min(rest - size2,
+				    (size_t)PAGE_SIZE - size - size2);
+			memcpy(buffer + size + size2,
+			       (void *) ab->data + size2, size3);
+			size2 += size3;
+		}
+
+		/* handle the packets that are fully in the next page */
+		buffer = (void *) ab->data + (buffer - (start + size));
+		end = (void *) ab->data + rest;
 
 		while (buffer < end)
 			buffer = handle_ar_packet(ctx, buffer);
