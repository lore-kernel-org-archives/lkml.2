Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab0LHBB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:56 -0500
Received: from kroah.org ([198.145.64.141]:49100 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab0LHBBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:54 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.918253546@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [155/289] firewire: ohci: fix buffer overflow in AR split packet handling
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/firewire/ohci.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -739,7 +739,7 @@ static void ar_context_tasklet(unsigned
 	d = &ab->descriptor;
 
 	if (d->res_count == 0) {
-		size_t size, rest, offset;
+		size_t size, size2, rest, pktsize, size3, offset;
 		dma_addr_t start_bus;
 		void *start;
 
@@ -756,12 +756,41 @@ static void ar_context_tasklet(unsigned
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


