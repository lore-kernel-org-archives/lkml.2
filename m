Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668Ab1DNSXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:23:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:38264 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933205Ab1DNRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de> (cast PAGE_SIZE to
	size_t),
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 058/209] firewire: ohci: fix buffer overflow in AR split packet handling
Date: Thu, 14 Apr 2011 13:41:28 -0400
Message-Id: <1302803039-9400-59-git-send-email-paul.gortmaker@windriver.com>
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
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (cast PAGE_SIZE to size_t)
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/firewire/ohci.c |   35 ++++++++++++++++++++++++++++++++---
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 94b16e0..b1b0281 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -636,7 +636,7 @@ static void ar_context_tasklet(unsigned long data)
 	d = &ab->descriptor;
 
 	if (d->res_count == 0) {
-		size_t size, rest, offset;
+		size_t size, size2, rest, pktsize, size3, offset;
 		dma_addr_t start_bus;
 		void *start;
 
@@ -653,12 +653,41 @@ static void ar_context_tasklet(unsigned long data)
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
-- 
1.7.4.4

