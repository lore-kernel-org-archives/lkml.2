Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0KEUEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:04:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59537 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0KEUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:04:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 5 Nov 2010 21:04:12 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.5a156c7e9d93aa41@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the fixes branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git fixes

to receive the following updates.  These address old but severe bugs in
firewire-ohci that caused memory corruption and crashes under workloads
like with firewire-net or forensics applications.

Clemens Ladisch (4):
      firewire: ohci: fix buffer overflow in AR split packet handling
      firewire: ohci: fix race in AR split packet handling
      firewire: ohci: avoid reallocation of AR buffers
      firewire: ohci: fix race when reading count in AR descriptor

 drivers/firewire/ohci.c |   92 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 67 insertions(+), 25 deletions(-)

Thanks.

Full logs and diff:

commit 693fa7792e9db9f32da9436e633976fbacd04b55
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Oct 25 11:43:05 2010 +0200

    firewire: ohci: fix race when reading count in AR descriptor
    
    If the controller is storing a split packet and therefore changing
    d->res_count to zero between the two reads by the driver, we end up with
    an end pointer that is not at a packet boundary, and therefore overflow
    the buffer when handling the split packet.
    
    To fix this, read the field once, atomically.  The compiler usually
    merges the two reads anyway, but for correctness, we have to enforce it.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index b5ba666..84eb607 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -740,11 +740,13 @@ static void ar_context_tasklet(unsigned long data)
 	struct ar_buffer *ab;
 	struct descriptor *d;
 	void *buffer, *end;
+	__le16 res_count;
 
 	ab = ctx->current_buffer;
 	d = &ab->descriptor;
 
-	if (d->res_count == 0) {
+	res_count = ACCESS_ONCE(d->res_count);
+	if (res_count == 0) {
 		size_t size, size2, rest, pktsize, size3, offset;
 		dma_addr_t start_bus;
 		void *start;
@@ -812,7 +814,7 @@ static void ar_context_tasklet(unsigned long data)
 	} else {
 		buffer = ctx->pointer;
 		ctx->pointer = end =
-			(void *) ab + PAGE_SIZE - le16_to_cpu(d->res_count);
+			(void *) ab + PAGE_SIZE - le16_to_cpu(res_count);
 
 		while (buffer < end)
 			buffer = handle_ar_packet(ctx, buffer);

commit 837596a61ba8f9bb53bb7aa27d17328ff9b2bcd5
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Oct 25 11:42:42 2010 +0200

    firewire: ohci: avoid reallocation of AR buffers
    
    Freeing an AR buffer page just to allocate a new page immediately
    afterwards is not only a pointless effort but also dangerous because
    the allocation can fail, which would result in an oops later.
    
    Split ar_context_add_page() into two functions so that we can reuse
    the old page directly.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 7570b71..b5ba666 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -577,17 +577,11 @@ static int ohci_update_phy_reg(struct fw_card *card, int addr,
 	return ret;
 }
 
-static int ar_context_add_page(struct ar_context *ctx)
+static void ar_context_link_page(struct ar_context *ctx,
+				 struct ar_buffer *ab, dma_addr_t ab_bus)
 {
-	struct device *dev = ctx->ohci->card.device;
-	struct ar_buffer *ab;
-	dma_addr_t uninitialized_var(ab_bus);
 	size_t offset;
 
-	ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_ATOMIC);
-	if (ab == NULL)
-		return -ENOMEM;
-
 	ab->next = NULL;
 	memset(&ab->descriptor, 0, sizeof(ab->descriptor));
 	ab->descriptor.control        = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
@@ -606,6 +600,19 @@ static int ar_context_add_page(struct ar_context *ctx)
 
 	reg_write(ctx->ohci, CONTROL_SET(ctx->regs), CONTEXT_WAKE);
 	flush_writes(ctx->ohci);
+}
+
+static int ar_context_add_page(struct ar_context *ctx)
+{
+	struct device *dev = ctx->ohci->card.device;
+	struct ar_buffer *ab;
+	dma_addr_t uninitialized_var(ab_bus);
+
+	ab = dma_alloc_coherent(dev, PAGE_SIZE, &ab_bus, GFP_ATOMIC);
+	if (ab == NULL)
+		return -ENOMEM;
+
+	ar_context_link_page(ctx, ab, ab_bus);
 
 	return 0;
 }
@@ -730,7 +737,6 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 static void ar_context_tasklet(unsigned long data)
 {
 	struct ar_context *ctx = (struct ar_context *)data;
-	struct fw_ohci *ohci = ctx->ohci;
 	struct ar_buffer *ab;
 	struct descriptor *d;
 	void *buffer, *end;
@@ -799,9 +805,7 @@ static void ar_context_tasklet(unsigned long data)
 			ctx->current_buffer = ab;
 			ctx->pointer = end;
 
-			dma_free_coherent(ohci->card.device, PAGE_SIZE,
-					  start, start_bus);
-			ar_context_add_page(ctx);
+			ar_context_link_page(ctx, start, start_bus);
 		} else {
 			ctx->pointer = start + PAGE_SIZE;
 		}

commit a1f805e5e73a8fe166b71c6592d3837df0cd5e2e
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Oct 25 11:42:20 2010 +0200

    firewire: ohci: fix race in AR split packet handling
    
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
    Cc: 2.6.22-2.6.36 <stable@kernel.org>
    Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 5826ae3..7570b71 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -750,20 +750,19 @@ static void ar_context_tasklet(unsigned long data)
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
@@ -782,22 +781,30 @@ static void ar_context_tasklet(unsigned long data)
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
+
+			ctx->current_buffer = ab;
+			ctx->pointer = end;
 
-		dma_free_coherent(ohci->card.device, PAGE_SIZE,
-				  start, start_bus);
-		ar_context_add_page(ctx);
+			dma_free_coherent(ohci->card.device, PAGE_SIZE,
+					  start, start_bus);
+			ar_context_add_page(ctx);
+		} else {
+			ctx->pointer = start + PAGE_SIZE;
+		}
 	} else {
 		buffer = ctx->pointer;
 		ctx->pointer = end =

commit 85f7ffd5d2b320f73912b15fe8cef34bae297daf
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Oct 25 11:41:53 2010 +0200

    firewire: ohci: fix buffer overflow in AR split packet handling
    
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
    Cc: 2.6.22-2.6.36 <stable@kernel.org>
    Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (cast PAGE_SIZE to size_t)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 9dcb17d..5826ae3 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -739,7 +739,7 @@ static void ar_context_tasklet(unsigned long data)
 	d = &ab->descriptor;
 
 	if (d->res_count == 0) {
-		size_t size, rest, offset;
+		size_t size, size2, rest, pktsize, size3, offset;
 		dma_addr_t start_bus;
 		void *start;
 
@@ -756,12 +756,41 @@ static void ar_context_tasklet(unsigned long data)
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
Stefan Richter
-=====-==-=- =-== --=-=
http://arcgraph.de/sr/

