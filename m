Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0KMUgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 15:36:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43039 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0KMUgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 15:36:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 13 Nov 2010 21:35:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: ohci: fix reception of 4k sized asynchronous
 packets
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>
Message-ID: <tkrat.cf3673ab5a3d1660@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At S800, packets may up to 4096 bytes + headers (+ OHCI trailer) large.
This was not handled by firewire-ohci until now.

As Maxim Levitsky points out, 8k buffer segments instead of 4k ones let
us easily fix the bug that async packets with 4096 bytes payload cannot
be received.  Plus, this is a quick and easy way to reduce ack-busy-*
events without having to change the ar_context_tasklet to deal with more
than two segments.  (In my testing, firewire-net is still able to
saturate some controllers even with its current low transmitter queue
depth of <= 8 datagrams at default MTU of 1500 bytes.  FTP over fw-net
throughput from a XIO2213A to an FW323 is only improved by about 4% by
this change, and even less in the other direction.)

Clemens Ladisch found that rather about 20k are required to converge to
optimum performance, but for now I do not dare to rely on slab
allocations larger than 8k (times two per context, for two contexts).
Better defer that to a code change for more than two RA buffer segments.

Also,
 - since "firewire: ohci: avoid reallocation of AR buffers",
   ar_context_add_page is only used by ar_context_init/ pci_probe and
   therefore can allocate with GFP_KERNEL,
 - add WARN_ON(allocation failure) as a lame way of error handling.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -580,6 +580,8 @@ static int ohci_update_phy_reg(struct fw
 	return ret;
 }
 
+#define AR_PAGE_SIZE (8*1024)
+
 static void ar_context_link_page(struct ar_context *ctx,
 				 struct ar_buffer *ab, dma_addr_t ab_bus)
 {
@@ -591,9 +593,9 @@ static void ar_context_link_page(struct 
 						    DESCRIPTOR_STATUS |
 						    DESCRIPTOR_BRANCH_ALWAYS);
 	offset = offsetof(struct ar_buffer, data);
-	ab->descriptor.req_count      = cpu_to_le16(PAGE_SIZE - offset);
+	ab->descriptor.req_count      = cpu_to_le16(AR_PAGE_SIZE - offset);
 	ab->descriptor.data_address   = cpu_to_le32(ab_bus + offset);
-	ab->descriptor.res_count      = cpu_to_le16(PAGE_SIZE - offset);
+	ab->descriptor.res_count      = cpu_to_le16(AR_PAGE_SIZE - offset);
 	ab->descriptor.branch_address = 0;
 
 	wmb(); /* finish init of new descriptors before branch_address update */
@@ -611,7 +613,7 @@ static int ar_context_add_page(struct ar
 	struct ar_buffer *ab;
 	dma_addr_t uninitialized_var(ab_bus);
 
-	ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_ATOMIC);
+	ab = dma_alloc_coherent(dev, AR_PAGE_SIZE, &ab_bus, GFP_KERNEL);
 	if (ab == NULL)
 		return -ENOMEM;
 
@@ -630,7 +632,7 @@ static void ar_context_release(struct ar
 		ab_next = ab->next;
 		offset = offsetof(struct ar_buffer, data);
 		ab_bus = le32_to_cpu(ab->descriptor.data_address) - offset;
-		dma_free_coherent(ctx->ohci->card.device, PAGE_SIZE,
+		dma_free_coherent(ctx->ohci->card.device, AR_PAGE_SIZE,
 				  ab, ab_bus);
 	}
 }
@@ -767,11 +769,11 @@ static void ar_context_tasklet(unsigned 
 
 		ab = ab->next;
 		d = &ab->descriptor;
-		size = start + PAGE_SIZE - ctx->pointer;
+		size = start + AR_PAGE_SIZE - ctx->pointer;
 		/* valid buffer data in the next page */
 		rest = le16_to_cpu(d->req_count) - le16_to_cpu(d->res_count);
 		/* what actually fits in this page */
-		size2 = min(rest, (size_t)PAGE_SIZE - offset - size);
+		size2 = min(rest, AR_PAGE_SIZE - offset - size);
 		memmove(buffer, ctx->pointer, size);
 		memcpy(buffer + size, ab->data, size2);
 
@@ -792,7 +794,7 @@ static void ar_context_tasklet(unsigned 
 			size -= pktsize;
 			/* fill up this page again */
 			size3 = min(rest - size2,
-				    (size_t)PAGE_SIZE - offset - size - size2);
+				    AR_PAGE_SIZE - offset - size - size2);
 			memcpy(buffer + size + size2,
 			       (void *) ab->data + size2, size3);
 			size2 += size3;
@@ -812,20 +814,20 @@ static void ar_context_tasklet(unsigned 
 
 			ar_context_link_page(ctx, start, start_bus);
 		} else {
-			ctx->pointer = start + PAGE_SIZE;
+			ctx->pointer = start + AR_PAGE_SIZE;
 		}
 	} else {
 		buffer = ctx->pointer;
 		ctx->pointer = end =
-			(void *) ab + PAGE_SIZE - le16_to_cpu(res_count);
+			(void *) ab + AR_PAGE_SIZE - le16_to_cpu(res_count);
 
 		while (buffer < end)
 			buffer = handle_ar_packet(ctx, buffer);
 	}
 }
 
-static int ar_context_init(struct ar_context *ctx,
-			   struct fw_ohci *ohci, u32 regs)
+static void ar_context_init(struct ar_context *ctx,
+			    struct fw_ohci *ohci, u32 regs)
 {
 	struct ar_buffer ab;
 
@@ -834,12 +836,10 @@ static int ar_context_init(struct ar_con
 	ctx->last_buffer = &ab;
 	tasklet_init(&ctx->tasklet, ar_context_tasklet, (unsigned long)ctx);
 
-	ar_context_add_page(ctx);
-	ar_context_add_page(ctx);
+	WARN_ON(ar_context_add_page(ctx) ||
+		ar_context_add_page(ctx));
 	ctx->current_buffer = ab.next;
 	ctx->pointer = ctx->current_buffer->data;
-
-	return 0;
 }
 
 static void ar_context_run(struct ar_context *ctx)

-- 
Stefan Richter
-=====-==-=- =-== -==-=
http://arcgraph.de/sr/

