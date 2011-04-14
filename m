Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab1DNSXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:23:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:38265 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab1DNRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 059/209] firewire: ohci: fix race in AR split packet handling
Date: Thu, 14 Apr 2011 13:41:29 -0400
Message-Id: <1302803039-9400-60-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/firewire/ohci.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index b1b0281..3816889 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -647,20 +647,19 @@ static void ar_context_tasklet(unsigned long data)
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
@@ -679,22 +678,30 @@ static void ar_context_tasklet(unsigned long data)
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
+		if (rest > 0) {
+			/* handle the packets that are fully in the next page */
+			buffer = (void *) ab->data +
+					(buffer - (start + offset + size));
+			end = (void *) ab->data + rest;
 
-		while (buffer < end)
-			buffer = handle_ar_packet(ctx, buffer);
+			while (buffer < end)
+				buffer = handle_ar_packet(ctx, buffer);
 
-		dma_free_coherent(ohci->card.device, PAGE_SIZE,
-				  start, start_bus);
-		ar_context_add_page(ctx);
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
-- 
1.7.4.4

