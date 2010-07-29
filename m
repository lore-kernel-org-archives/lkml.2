Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0G2PIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:08:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34785 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0G2PIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:08:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 29 Jul 2010 17:08:13 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH rfc] firewire: add isochronous multichannel reception
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
Message-ID: <tkrat.c7f7ffc33f9f1ed2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the DMA context programming and userspace ABI for multichannel
reception, i.e. for listening on multiple channel numbers by means of a
single DMA context.

The use case is reception of more streams than there are IR DMA units
offered by the link layer.  This is already implemented by the older
ohci1394 + ieee1394 + raw1394 stack.  And as discussed recently on
linux1394-devel, this feature is occasionally used in practice.

The big drawbacks of this mode are that buffer layout and interrupt
generation necessarily differ from single-channel reception:  Headers
and trailers are not stripped from packets, packets are not aligned with
buffer chunks, interrupts are per buffer chunk, not per packet.

These drawbacks also cause a rather hefty code footprint to support this
rarely used OHCI-1394 feature.  (367 lines added, among them 94 lines of
added userspace ABI documentation.)

This implementation enforces that a multichannel reception context may
only listen to channels to which no single-channel context on the same
link layer is presently listening to.  OHCI-1394 would allow to overlay
single-channel contexts by the multi-channel context, but this would be
a departure from the present first-come-first-served policy of IR
context creation.

The implementation is heavily based on an earlier one by Jay Fenlason.
Thanks Jay.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

I intend to implement the libraw1394 backend for this next week.

 drivers/firewire/core-cdev.c  |   93 ++++++++--
 drivers/firewire/core-iso.c   |   32 ++-
 drivers/firewire/core.h       |    2 +
 drivers/firewire/ohci.c       |  312 +++++++++++++++++++++++++++-------
 include/linux/firewire-cdev.h |  281 +++++++++++++++++++++----------
 include/linux/firewire.h      |   29 ++-
 6 files changed, 558 insertions(+), 191 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -194,6 +194,11 @@ struct iso_interrupt_event {
 	struct fw_cdev_event_iso_interrupt interrupt;
 };
 
+struct iso_interrupt_mc_event {
+	struct event event;
+	struct fw_cdev_event_iso_interrupt_mc interrupt;
+};
+
 struct iso_resource_event {
 	struct event event;
 	struct fw_cdev_event_iso_resource iso_resource;
@@ -416,6 +421,7 @@ union ioctl_arg {
 	struct fw_cdev_get_cycle_timer2		get_cycle_timer2;
 	struct fw_cdev_send_phy_packet		send_phy_packet;
 	struct fw_cdev_receive_phy_packets	receive_phy_packets;
+	struct fw_cdev_set_iso_channels		set_iso_channels;
 };
 
 static int ioctl_get_info(struct client *client, union ioctl_arg *arg)
@@ -933,26 +939,54 @@ static void iso_callback(struct fw_iso_c
 		    sizeof(e->interrupt) + header_length, NULL, 0);
 }
 
+static void iso_mc_callback(struct fw_iso_context *context,
+			    dma_addr_t completed, void *data)
+{
+	struct client *client = data;
+	struct iso_interrupt_mc_event *e;
+
+	e = kmalloc(sizeof(*e), GFP_ATOMIC);
+	if (e == NULL) {
+		fw_notify("Out of memory when allocating event\n");
+		return;
+	}
+	e->interrupt.type      = FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL;
+	e->interrupt.closure   = client->iso_closure;
+	e->interrupt.completed = fw_iso_buffer_lookup(&client->buffer,
+						      completed);
+	queue_event(client, &e->event, &e->interrupt,
+		    sizeof(e->interrupt), NULL, 0);
+}
+
 static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 {
 	struct fw_cdev_create_iso_context *a = &arg->create_iso_context;
 	struct fw_iso_context *context;
+	fw_iso_callback_t cb;
 
 	BUILD_BUG_ON(FW_CDEV_ISO_CONTEXT_TRANSMIT != FW_ISO_CONTEXT_TRANSMIT ||
-		     FW_CDEV_ISO_CONTEXT_RECEIVE  != FW_ISO_CONTEXT_RECEIVE);
-
-	if (a->channel > 63)
-		return -EINVAL;
+		     FW_CDEV_ISO_CONTEXT_RECEIVE  != FW_ISO_CONTEXT_RECEIVE  ||
+		     FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL !=
+					FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL);
 
 	switch (a->type) {
-	case FW_ISO_CONTEXT_RECEIVE:
-		if (a->header_size < 4 || (a->header_size & 3))
+	case FW_ISO_CONTEXT_TRANSMIT:
+		if (a->speed > SCODE_3200 || a->channel > 63)
 			return -EINVAL;
+
+		cb = iso_callback;
 		break;
 
-	case FW_ISO_CONTEXT_TRANSMIT:
-		if (a->speed > SCODE_3200)
+	case FW_ISO_CONTEXT_RECEIVE:
+		if (a->header_size < 4 || (a->header_size & 3) ||
+		    a->channel > 63)
 			return -EINVAL;
+
+		cb = iso_callback;
+		break;
+
+	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
+		cb = (fw_iso_callback_t)iso_mc_callback;
 		break;
 
 	default:
@@ -960,8 +994,7 @@ static int ioctl_create_iso_context(stru
 	}
 
 	context = fw_iso_context_create(client->device->card, a->type,
-					a->channel, a->speed, a->header_size,
-					iso_callback, client);
+			a->channel, a->speed, a->header_size, cb, client);
 	if (IS_ERR(context))
 		return PTR_ERR(context);
 
@@ -981,6 +1014,17 @@ static int ioctl_create_iso_context(stru
 	return 0;
 }
 
+static int ioctl_set_iso_channels(struct client *client, union ioctl_arg *arg)
+{
+	struct fw_cdev_set_iso_channels *a = &arg->set_iso_channels;
+	struct fw_iso_context *ctx = client->iso_context;
+
+	if (ctx == NULL || a->handle != 0)
+		return -EINVAL;
+
+	return fw_iso_context_set_channels(ctx, &a->channels);
+}
+
 /* Macros for decoding the iso packet control header. */
 #define GET_PAYLOAD_LENGTH(v)	((v) & 0xffff)
 #define GET_INTERRUPT(v)	(((v) >> 16) & 0x01)
@@ -994,7 +1038,7 @@ static int ioctl_queue_iso(struct client
 	struct fw_cdev_queue_iso *a = &arg->queue_iso;
 	struct fw_cdev_iso_packet __user *p, *end, *next;
 	struct fw_iso_context *ctx = client->iso_context;
-	unsigned long payload, buffer_end, transmit_header_bytes;
+	unsigned long payload, buffer_end, transmit_header_bytes = 0;
 	u32 control;
 	int count;
 	struct {
@@ -1014,7 +1058,6 @@ static int ioctl_queue_iso(struct client
 	 * use the indirect payload, the iso buffer need not be mapped
 	 * and the a->data pointer is ignored.
 	 */
-
 	payload = (unsigned long)a->data - client->vm_start;
 	buffer_end = client->buffer.page_count << PAGE_SHIFT;
 	if (a->data == 0 || client->buffer.pages == NULL ||
@@ -1023,8 +1066,10 @@ static int ioctl_queue_iso(struct client
 		buffer_end = 0;
 	}
 
-	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(a->packets);
+	if (ctx->type == FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL && payload & 3)
+		return -EINVAL;
 
+	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(a->packets);
 	if (!access_ok(VERIFY_READ, p, a->size))
 		return -EFAULT;
 
@@ -1040,19 +1085,24 @@ static int ioctl_queue_iso(struct client
 		u.packet.sy = GET_SY(control);
 		u.packet.header_length = GET_HEADER_LENGTH(control);
 
-		if (ctx->type == FW_ISO_CONTEXT_TRANSMIT) {
-			if (u.packet.header_length % 4 != 0)
+		switch (ctx->type) {
+		case FW_ISO_CONTEXT_TRANSMIT:
+			if (u.packet.header_length & 3)
 				return -EINVAL;
 			transmit_header_bytes = u.packet.header_length;
-		} else {
-			/*
-			 * We require that header_length is a multiple of
-			 * the fixed header size, ctx->header_size.
-			 */
+			break;
+
+		case FW_ISO_CONTEXT_RECEIVE:
 			if (u.packet.header_length == 0 ||
 			    u.packet.header_length % ctx->header_size != 0)
 				return -EINVAL;
-			transmit_header_bytes = 0;
+			break;
+
+		case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
+			if (u.packet.payload_length == 0 ||
+			    u.packet.payload_length & 3)
+				return -EINVAL;
+			break;
 		}
 
 		next = (struct fw_cdev_iso_packet __user *)
@@ -1535,6 +1585,7 @@ static int (* const ioctl_handlers[])(st
 	[0x14] = ioctl_get_cycle_timer2,
 	[0x15] = ioctl_send_phy_packet,
 	[0x16] = ioctl_receive_phy_packets,
+	[0x17] = ioctl_set_iso_channels,
 };
 
 static int dispatch_ioctl(struct client *client,
Index: b/drivers/firewire/core-iso.c
===================================================================
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -118,6 +118,23 @@ void fw_iso_buffer_destroy(struct fw_iso
 }
 EXPORT_SYMBOL(fw_iso_buffer_destroy);
 
+/* Convert DMA address to offset into virtually contiguous buffer. */
+size_t fw_iso_buffer_lookup(struct fw_iso_buffer *buffer, dma_addr_t completed)
+{
+	int i;
+	dma_addr_t address;
+	ssize_t offset;
+
+	for (i = 0; i < buffer->page_count; i++) {
+		address = page_private(buffer->pages[i]);
+		offset = (ssize_t)completed - (ssize_t)address;
+		if (offset > 0 && offset <= PAGE_SIZE)
+			return (i << PAGE_SHIFT) + offset;
+	}
+
+	return 0;
+}
+
 struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
 		int type, int channel, int speed, size_t header_size,
 		fw_iso_callback_t callback, void *callback_data)
@@ -134,7 +151,7 @@ struct fw_iso_context *fw_iso_context_cr
 	ctx->channel = channel;
 	ctx->speed = speed;
 	ctx->header_size = header_size;
-	ctx->callback = callback;
+	ctx->callback.sc = callback;
 	ctx->callback_data = callback_data;
 
 	return ctx;
@@ -143,9 +160,7 @@ EXPORT_SYMBOL(fw_iso_context_create);
 
 void fw_iso_context_destroy(struct fw_iso_context *ctx)
 {
-	struct fw_card *card = ctx->card;
-
-	card->driver->free_iso_context(ctx);
+	ctx->card->driver->free_iso_context(ctx);
 }
 EXPORT_SYMBOL(fw_iso_context_destroy);
 
@@ -156,14 +171,17 @@ int fw_iso_context_start(struct fw_iso_c
 }
 EXPORT_SYMBOL(fw_iso_context_start);
 
+int fw_iso_context_set_channels(struct fw_iso_context *ctx, u64 *channels)
+{
+	return ctx->card->driver->set_iso_channels(ctx, channels);
+}
+
 int fw_iso_context_queue(struct fw_iso_context *ctx,
 			 struct fw_iso_packet *packet,
 			 struct fw_iso_buffer *buffer,
 			 unsigned long payload)
 {
-	struct fw_card *card = ctx->card;
-
-	return card->driver->queue_iso(ctx, packet, buffer, payload);
+	return ctx->card->driver->queue_iso(ctx, packet, buffer, payload);
 }
 EXPORT_SYMBOL(fw_iso_context_queue);
 
Index: b/drivers/firewire/core.h
===================================================================
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -90,6 +90,8 @@ struct fw_card_driver {
 	int (*start_iso)(struct fw_iso_context *ctx,
 			 s32 cycle, u32 sync, u32 tags);
 
+	int (*set_iso_channels)(struct fw_iso_context *ctx, u64 *channels);
+
 	int (*queue_iso)(struct fw_iso_context *ctx,
 			 struct fw_iso_packet *packet,
 			 struct fw_iso_buffer *buffer,
Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -190,11 +190,13 @@ struct fw_ohci {
 	struct context at_request_ctx;
 	struct context at_response_ctx;
 
-	u32 it_context_mask;
+	u32 it_context_mask;     /* unoccupied IT contexts */
 	struct iso_context *it_context_list;
-	u64 ir_context_channels;
-	u32 ir_context_mask;
+	u64 ir_context_channels; /* unoccupied channels */
+	u32 ir_context_mask;     /* unoccupied IR contexts */
 	struct iso_context *ir_context_list;
+	u64 mc_channels; /* channels in use by the multichannel IR context */
+	bool mc_allocated;
 
 	__be32    *config_rom;
 	dma_addr_t config_rom_bus;
@@ -2202,10 +2204,9 @@ static int handle_ir_packet_per_buffer(s
 	__le32 *ir_header;
 	void *p;
 
-	for (pd = d; pd <= last; pd++) {
+	for (pd = d; pd <= last; pd++)
 		if (pd->transfer_status)
 			break;
-	}
 	if (pd > last)
 		/* Descriptor(s) not done yet, stop iteration */
 		return 0;
@@ -2215,16 +2216,38 @@ static int handle_ir_packet_per_buffer(s
 
 	if (le16_to_cpu(last->control) & DESCRIPTOR_IRQ_ALWAYS) {
 		ir_header = (__le32 *) p;
-		ctx->base.callback(&ctx->base,
-				   le32_to_cpu(ir_header[0]) & 0xffff,
-				   ctx->header_length, ctx->header,
-				   ctx->base.callback_data);
+		ctx->base.callback.sc(&ctx->base,
+				      le32_to_cpu(ir_header[0]) & 0xffff,
+				      ctx->header_length, ctx->header,
+				      ctx->base.callback_data);
 		ctx->header_length = 0;
 	}
 
 	return 1;
 }
 
+/* d == last because each descriptor block is only a single descriptor. */
+static int handle_ir_buffer_fill(struct context *context,
+				 struct descriptor *d,
+				 struct descriptor *last)
+{
+	struct iso_context *ctx =
+		container_of(context, struct iso_context, context);
+
+	if (!last->transfer_status)
+		/* Descriptor(s) not done yet, stop iteration */
+		return 0;
+
+	if (le16_to_cpu(last->control) & DESCRIPTOR_IRQ_ALWAYS)
+		ctx->base.callback.mc(&ctx->base,
+				      le32_to_cpu(last->data_address) +
+				      le16_to_cpu(last->req_count) -
+				      le16_to_cpu(last->res_count),
+				      ctx->base.callback_data);
+
+	return 1;
+}
+
 static int handle_it_packet(struct context *context,
 			    struct descriptor *d,
 			    struct descriptor *last)
@@ -2250,72 +2273,118 @@ static int handle_it_packet(struct conte
 		ctx->header_length += 4;
 	}
 	if (le16_to_cpu(last->control) & DESCRIPTOR_IRQ_ALWAYS) {
-		ctx->base.callback(&ctx->base, le16_to_cpu(last->res_count),
-				   ctx->header_length, ctx->header,
-				   ctx->base.callback_data);
+		ctx->base.callback.sc(&ctx->base, le16_to_cpu(last->res_count),
+				      ctx->header_length, ctx->header,
+				      ctx->base.callback_data);
 		ctx->header_length = 0;
 	}
 	return 1;
 }
 
+static void set_multichannel_mask(struct fw_ohci *ohci, u64 channels)
+{
+	u32 hi = channels >> 32, lo = channels;
+
+	reg_write(ohci, OHCI1394_IRMultiChanMaskHiClear, ~hi);
+	reg_write(ohci, OHCI1394_IRMultiChanMaskLoClear, ~lo);
+	reg_write(ohci, OHCI1394_IRMultiChanMaskHiSet, hi);
+	reg_write(ohci, OHCI1394_IRMultiChanMaskLoSet, lo);
+	mmiowb();
+	ohci->mc_channels = channels;
+}
+
 static struct fw_iso_context *ohci_allocate_iso_context(struct fw_card *card,
 				int type, int channel, size_t header_size)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
-	struct iso_context *ctx, *list;
-	descriptor_callback_t callback;
-	u64 *channels, dont_care = ~0ULL;
-	u32 *mask, regs;
+	struct iso_context *uninitialized_var(ctx);
+	descriptor_callback_t uninitialized_var(callback);
+	u64 *uninitialized_var(channels);
+	u32 *uninitialized_var(mask), uninitialized_var(regs);
 	unsigned long flags;
-	int index, ret = -ENOMEM;
+	int index, ret = -EBUSY;
 
-	if (type == FW_ISO_CONTEXT_TRANSMIT) {
-		channels = &dont_care;
-		mask = &ohci->it_context_mask;
-		list = ohci->it_context_list;
+	spin_lock_irqsave(&ohci->lock, flags);
+
+	switch (type) {
+	case FW_ISO_CONTEXT_TRANSMIT:
+		mask     = &ohci->it_context_mask;
 		callback = handle_it_packet;
-	} else {
+		index    = ffs(*mask) - 1;
+		if (index >= 0) {
+			*mask &= ~(1 << index);
+			regs = OHCI1394_IsoXmitContextBase(index);
+			ctx  = &ohci->it_context_list[index];
+		}
+		break;
+
+	case FW_ISO_CONTEXT_RECEIVE:
 		channels = &ohci->ir_context_channels;
-		mask = &ohci->ir_context_mask;
-		list = ohci->ir_context_list;
+		mask     = &ohci->ir_context_mask;
 		callback = handle_ir_packet_per_buffer;
-	}
+		index    = *channels & 1ULL << channel ? ffs(*mask) - 1 : -1;
+		if (index >= 0) {
+			*channels &= ~(1ULL << channel);
+			*mask     &= ~(1 << index);
+			regs = OHCI1394_IsoRcvContextBase(index);
+			ctx  = &ohci->ir_context_list[index];
+		}
+		break;
 
-	spin_lock_irqsave(&ohci->lock, flags);
-	index = *channels & 1ULL << channel ? ffs(*mask) - 1 : -1;
-	if (index >= 0) {
-		*channels &= ~(1ULL << channel);
-		*mask &= ~(1 << index);
+	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
+		mask     = &ohci->ir_context_mask;
+		callback = handle_ir_buffer_fill;
+		index    = !ohci->mc_allocated ? ffs(*mask) - 1 : -1;
+		if (index >= 0) {
+			ohci->mc_allocated = true;
+			*mask &= ~(1 << index);
+			regs = OHCI1394_IsoRcvContextBase(index);
+			ctx  = &ohci->ir_context_list[index];
+		}
+		break;
+
+	default:
+		index = -1;
+		ret = -ENOSYS;
 	}
+
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
 	if (index < 0)
-		return ERR_PTR(-EBUSY);
-
-	if (type == FW_ISO_CONTEXT_TRANSMIT)
-		regs = OHCI1394_IsoXmitContextBase(index);
-	else
-		regs = OHCI1394_IsoRcvContextBase(index);
+		return ERR_PTR(ret);
 
-	ctx = &list[index];
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->header_length = 0;
 	ctx->header = (void *) __get_free_page(GFP_KERNEL);
-	if (ctx->header == NULL)
+	if (ctx->header == NULL) {
+		ret = -ENOMEM;
 		goto out;
-
+	}
 	ret = context_init(&ctx->context, ohci, regs, callback);
 	if (ret < 0)
 		goto out_with_header;
 
+	if (type == FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL)
+		set_multichannel_mask(ohci, 0);
+
 	return &ctx->base;
 
  out_with_header:
 	free_page((unsigned long)ctx->header);
  out:
 	spin_lock_irqsave(&ohci->lock, flags);
-	*channels |= 1ULL << channel;
+
+	switch (type) {
+	case FW_ISO_CONTEXT_RECEIVE:
+		*channels |= 1ULL << channel;
+		break;
+
+	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
+		ohci->mc_allocated = false;
+		break;
+	}
 	*mask |= 1 << index;
+
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
 	return ERR_PTR(ret);
@@ -2326,10 +2395,11 @@ static int ohci_start_iso(struct fw_iso_
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	struct fw_ohci *ohci = ctx->context.ohci;
-	u32 control, match;
+	u32 control = IR_CONTEXT_ISOCH_HEADER, match;
 	int index;
 
-	if (ctx->base.type == FW_ISO_CONTEXT_TRANSMIT) {
+	switch (ctx->base.type) {
+	case FW_ISO_CONTEXT_TRANSMIT:
 		index = ctx - ohci->it_context_list;
 		match = 0;
 		if (cycle >= 0)
@@ -2339,9 +2409,13 @@ static int ohci_start_iso(struct fw_iso_
 		reg_write(ohci, OHCI1394_IsoXmitIntEventClear, 1 << index);
 		reg_write(ohci, OHCI1394_IsoXmitIntMaskSet, 1 << index);
 		context_run(&ctx->context, match);
-	} else {
+		break;
+
+	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
+		control |= IR_CONTEXT_BUFFER_FILL|IR_CONTEXT_MULTI_CHANNEL_MODE;
+		/* fall through */
+	case FW_ISO_CONTEXT_RECEIVE:
 		index = ctx - ohci->ir_context_list;
-		control = IR_CONTEXT_ISOCH_HEADER;
 		match = (tags << 28) | (sync << 8) | ctx->base.channel;
 		if (cycle >= 0) {
 			match |= (cycle & 0x07fff) << 12;
@@ -2352,6 +2426,7 @@ static int ohci_start_iso(struct fw_iso_
 		reg_write(ohci, OHCI1394_IsoRecvIntMaskSet, 1 << index);
 		reg_write(ohci, CONTEXT_MATCH(ctx->context.regs), match);
 		context_run(&ctx->context, control);
+		break;
 	}
 
 	return 0;
@@ -2363,12 +2438,17 @@ static int ohci_stop_iso(struct fw_iso_c
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	int index;
 
-	if (ctx->base.type == FW_ISO_CONTEXT_TRANSMIT) {
+	switch (ctx->base.type) {
+	case FW_ISO_CONTEXT_TRANSMIT:
 		index = ctx - ohci->it_context_list;
 		reg_write(ohci, OHCI1394_IsoXmitIntMaskClear, 1 << index);
-	} else {
+		break;
+
+	case FW_ISO_CONTEXT_RECEIVE:
+	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
 		index = ctx - ohci->ir_context_list;
 		reg_write(ohci, OHCI1394_IsoRecvIntMaskClear, 1 << index);
+		break;
 	}
 	flush_writes(ohci);
 	context_stop(&ctx->context);
@@ -2389,22 +2469,64 @@ static void ohci_free_iso_context(struct
 
 	spin_lock_irqsave(&ohci->lock, flags);
 
-	if (ctx->base.type == FW_ISO_CONTEXT_TRANSMIT) {
+	switch (base->type) {
+	case FW_ISO_CONTEXT_TRANSMIT:
 		index = ctx - ohci->it_context_list;
 		ohci->it_context_mask |= 1 << index;
-	} else {
+		break;
+
+	case FW_ISO_CONTEXT_RECEIVE:
 		index = ctx - ohci->ir_context_list;
 		ohci->ir_context_mask |= 1 << index;
 		ohci->ir_context_channels |= 1ULL << base->channel;
+		break;
+
+	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
+		index = ctx - ohci->ir_context_list;
+		ohci->ir_context_mask |= 1 << index;
+		ohci->ir_context_channels |= ohci->mc_channels;
+		ohci->mc_channels = 0;
+		ohci->mc_allocated = false;
+		break;
 	}
 
 	spin_unlock_irqrestore(&ohci->lock, flags);
 }
 
-static int ohci_queue_iso_transmit(struct fw_iso_context *base,
-				   struct fw_iso_packet *packet,
-				   struct fw_iso_buffer *buffer,
-				   unsigned long payload)
+static int ohci_set_iso_channels(struct fw_iso_context *base, u64 *channels)
+{
+	struct fw_ohci *ohci = fw_ohci(base->card);
+	unsigned long flags;
+	int ret;
+
+	switch (base->type) {
+	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
+
+		spin_lock_irqsave(&ohci->lock, flags);
+
+		/* Don't allow multichannel to grab other contexts' channels. */
+		if (~ohci->ir_context_channels & ~ohci->mc_channels & *channels) {
+			*channels = ohci->ir_context_channels;
+			ret = -EBUSY;
+		} else {
+			set_multichannel_mask(ohci, *channels);
+			ret = 0;
+		}
+
+		spin_unlock_irqrestore(&ohci->lock, flags);
+
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int queue_iso_transmit(struct fw_iso_context *base,
+			      struct fw_iso_packet *packet,
+			      struct fw_iso_buffer *buffer,
+			      unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	struct descriptor *d, *last, *pd;
@@ -2502,14 +2624,13 @@ static int ohci_queue_iso_transmit(struc
 	return 0;
 }
 
-static int ohci_queue_iso_receive_packet_per_buffer(struct fw_iso_context *base,
-					struct fw_iso_packet *packet,
-					struct fw_iso_buffer *buffer,
-					unsigned long payload)
+static int queue_iso_packet_per_buffer(struct fw_iso_context *base,
+				       struct fw_iso_packet *packet,
+				       struct fw_iso_buffer *buffer,
+				       unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	struct descriptor *d, *pd;
-	struct fw_iso_packet *p = packet;
 	dma_addr_t d_bus, page_bus;
 	u32 z, header_z, rest;
 	int i, j, length;
@@ -2519,14 +2640,14 @@ static int ohci_queue_iso_receive_packet
 	 * The OHCI controller puts the isochronous header and trailer in the
 	 * buffer, so we need at least 8 bytes.
 	 */
-	packet_count = p->header_length / ctx->base.header_size;
+	packet_count = packet->header_length / ctx->base.header_size;
 	header_size  = max(ctx->base.header_size, (size_t)8);
 
 	/* Get header size in number of descriptors. */
 	header_z = DIV_ROUND_UP(header_size, sizeof(*d));
 	page     = payload >> PAGE_SHIFT;
 	offset   = payload & ~PAGE_MASK;
-	payload_per_buffer = p->payload_length / packet_count;
+	payload_per_buffer = packet->payload_length / packet_count;
 
 	for (i = 0; i < packet_count; i++) {
 		/* d points to the header descriptor */
@@ -2538,7 +2659,7 @@ static int ohci_queue_iso_receive_packet
 
 		d->control      = cpu_to_le16(DESCRIPTOR_STATUS |
 					      DESCRIPTOR_INPUT_MORE);
-		if (p->skip && i == 0)
+		if (packet->skip && i == 0)
 			d->control |= cpu_to_le16(DESCRIPTOR_WAIT);
 		d->req_count    = cpu_to_le16(header_size);
 		d->res_count    = d->req_count;
@@ -2571,7 +2692,7 @@ static int ohci_queue_iso_receive_packet
 		pd->control = cpu_to_le16(DESCRIPTOR_STATUS |
 					  DESCRIPTOR_INPUT_LAST |
 					  DESCRIPTOR_BRANCH_ALWAYS);
-		if (p->interrupt && i == packet_count - 1)
+		if (packet->interrupt && i == packet_count - 1)
 			pd->control |= cpu_to_le16(DESCRIPTOR_IRQ_ALWAYS);
 
 		context_append(&ctx->context, d, z, header_z);
@@ -2580,6 +2701,59 @@ static int ohci_queue_iso_receive_packet
 	return 0;
 }
 
+static int queue_iso_buffer_fill(struct fw_iso_context *base,
+				 struct fw_iso_packet *packet,
+				 struct fw_iso_buffer *buffer,
+				 unsigned long payload)
+{
+	struct iso_context *ctx = container_of(base, struct iso_context, base);
+	struct descriptor *d;
+	dma_addr_t d_bus, page_bus;
+	int page, offset, rest, z, i, length;
+
+	page   = payload >> PAGE_SHIFT;
+	offset = payload & ~PAGE_MASK;
+	rest   = packet->payload_length;
+
+	/* We need one descriptor for each page in the buffer. */
+	z = DIV_ROUND_UP(offset + rest, PAGE_SIZE);
+
+	if (WARN_ON(offset & 3 || rest & 3 || page + z > buffer->page_count))
+		return -EFAULT;
+
+	for (i = 0; i < z; i++) {
+		d = context_get_descriptors(&ctx->context, 1, &d_bus);
+		if (d == NULL)
+			return -ENOMEM;
+
+		d->control = cpu_to_le16(DESCRIPTOR_INPUT_MORE |
+					 DESCRIPTOR_BRANCH_ALWAYS);
+		if (packet->skip && i == 0)
+			d->control |= cpu_to_le16(DESCRIPTOR_WAIT);
+		if (packet->interrupt && i == z - 1)
+			d->control |= cpu_to_le16(DESCRIPTOR_IRQ_ALWAYS);
+
+		if (offset + rest < PAGE_SIZE)
+			length = rest;
+		else
+			length = PAGE_SIZE - offset;
+		d->req_count = cpu_to_le16(length);
+		d->res_count = d->req_count;
+		d->transfer_status = 0;
+
+		page_bus = page_private(buffer->pages[page]);
+		d->data_address = cpu_to_le32(page_bus + offset);
+
+		rest -= length;
+		offset = 0;
+		page++;
+
+		context_append(&ctx->context, d, 1, 0);
+	}
+
+	return 0;
+}
+
 static int ohci_queue_iso(struct fw_iso_context *base,
 			  struct fw_iso_packet *packet,
 			  struct fw_iso_buffer *buffer,
@@ -2587,14 +2761,17 @@ static int ohci_queue_iso(struct fw_iso_
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	unsigned long flags;
-	int ret;
+	int ret = -ENOSYS;
 
 	spin_lock_irqsave(&ctx->context.ohci->lock, flags);
-	if (base->type == FW_ISO_CONTEXT_TRANSMIT)
-		ret = ohci_queue_iso_transmit(base, packet, buffer, payload);
-	else
-		ret = ohci_queue_iso_receive_packet_per_buffer(base, packet,
-							buffer, payload);
+	switch (base->type) {
+	case FW_ISO_CONTEXT_TRANSMIT:
+		ret = queue_iso_transmit(base, packet, buffer, payload);
+	case FW_ISO_CONTEXT_RECEIVE:
+		ret = queue_iso_packet_per_buffer(base, packet, buffer, payload);
+	case FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
+		ret = queue_iso_buffer_fill(base, packet, buffer, payload);
+	}
 	spin_unlock_irqrestore(&ctx->context.ohci->lock, flags);
 
 	return ret;
@@ -2614,6 +2791,7 @@ static const struct fw_card_driver ohci_
 
 	.allocate_iso_context	= ohci_allocate_iso_context,
 	.free_iso_context	= ohci_free_iso_context,
+	.set_iso_channels	= ohci_set_iso_channels,
 	.queue_iso		= ohci_queue_iso,
 	.start_iso		= ohci_start_iso,
 	.stop_iso		= ohci_stop_iso,
Index: b/include/linux/firewire-cdev.h
===================================================================
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -30,17 +30,18 @@
 #include <linux/types.h>
 #include <linux/firewire-constants.h>
 
-#define FW_CDEV_EVENT_BUS_RESET			0x00
-#define FW_CDEV_EVENT_RESPONSE			0x01
-#define FW_CDEV_EVENT_REQUEST			0x02
-#define FW_CDEV_EVENT_ISO_INTERRUPT		0x03
-#define FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED	0x04
-#define FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED	0x05
+#define FW_CDEV_EVENT_BUS_RESET				0x00
+#define FW_CDEV_EVENT_RESPONSE				0x01
+#define FW_CDEV_EVENT_REQUEST				0x02
+#define FW_CDEV_EVENT_ISO_INTERRUPT			0x03
+#define FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED		0x04
+#define FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED		0x05
 
 /* available since kernel version 2.6.36 */
-#define FW_CDEV_EVENT_REQUEST2			0x06
-#define FW_CDEV_EVENT_PHY_PACKET_SENT		0x07
-#define FW_CDEV_EVENT_PHY_PACKET_RECEIVED	0x08
+#define FW_CDEV_EVENT_REQUEST2				0x06
+#define FW_CDEV_EVENT_PHY_PACKET_SENT			0x07
+#define FW_CDEV_EVENT_PHY_PACKET_RECEIVED		0x08
+#define FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL	0x09
 
 /**
  * struct fw_cdev_event_common - Common part of all fw_cdev_event_ types
@@ -223,35 +224,41 @@ struct fw_cdev_event_request2 {
  * This event is sent when the controller has completed an &fw_cdev_iso_packet
  * with the %FW_CDEV_ISO_INTERRUPT bit set.
  *
- * Isochronous transmit events:
+ * Isochronous transmit events (context type %FW_CDEV_ISO_CONTEXT_TRANSMIT):
  *
- * In version 1 of the ABI, &header_length is 0.  In version 3 and some
- * implementations of version 2 of the ABI, &header_length is a multiple of 4
- * and &header contains timestamps of all packets up until the interrupt packet.
- * The format of the timestamps is as described below for isochronous reception.
+ * In version 3 and some implementations of version 2 of the ABI, &header_length
+ * is a multiple of 4 and &header contains timestamps of all packets up until
+ * the interrupt packet.  The format of the timestamps is as described below for
+ * isochronous reception.  In version 1 of the ABI, &header_length was 0.
  *
- * Isochronous receive events:
+ * Isochronous receive events (context type %FW_CDEV_ISO_CONTEXT_RECEIVE):
  *
  * The headers stripped of all packets up until and including the interrupt
  * packet are returned in the @header field.  The amount of header data per
  * packet is as specified at iso context creation by
  * &fw_cdev_create_iso_context.header_size.
  *
- * In version 1 of this ABI, header data consisted of the 1394 isochronous
- * packet header, followed by quadlets from the packet payload if
- * &fw_cdev_create_iso_context.header_size > 4.
- *
- * In version 2 of this ABI, header data consist of the 1394 isochronous
- * packet header, followed by a timestamp quadlet if
- * &fw_cdev_create_iso_context.header_size > 4, followed by quadlets from the
- * packet payload if &fw_cdev_create_iso_context.header_size > 8.
+ * Hence, _interrupt.header_length / _context.header_size is the number of
+ * packets received in this interrupt event.  The client can now iterate
+ * through the mmap()'ed DMA buffer according to this number of packets and
+ * to the buffer sizes as the client specified in &fw_cdev_queue_iso.
+ *
+ * Since version 2 of this ABI, the portion for each packet in _interrupt.header
+ * consists of the 1394 isochronous packet header, followed by a timestamp
+ * quadlet if &fw_cdev_create_iso_context.header_size > 4, followed by quadlets
+ * from the packet payload if &fw_cdev_create_iso_context.header_size > 8.
+ *
+ * Format of 1394 iso packet header:  16 bits data_length, 2 bits tag, 6 bits
+ * channel, 4 bits tcode, 4 bits sy, in big endian byte order.
+ * data_length is the actual received size of the packet without the four
+ * 1394 iso packet header bytes.
  *
- * Behaviour of ver. 1 of this ABI is no longer available since ABI ver. 2.
+ * Format of timestamp:  16 bits invalid, 3 bits cycleSeconds, 13 bits
+ * cycleCount, in big endian byte order.
  *
- * Format of 1394 iso packet header: 16 bits len, 2 bits tag, 6 bits channel,
- * 4 bits tcode, 4 bits sy, in big endian byte order.  Format of timestamp:
- * 16 bits invalid, 3 bits cycleSeconds, 13 bits cycleCount, in big endian byte
- * order.
+ * In version 1 of the ABI, no timestamp quadlet was inserted; instead, payload
+ * data followed directly after the 1394 is header if header_size > 4.
+ * Behaviour of ver. 1 of this ABI is no longer available since ABI ver. 2.
  */
 struct fw_cdev_event_iso_interrupt {
 	__u64 closure;
@@ -262,6 +269,43 @@ struct fw_cdev_event_iso_interrupt {
 };
 
 /**
+ * struct fw_cdev_event_iso_interrupt_mc - An iso buffer chunk was completed
+ * @closure:	See &fw_cdev_event_common;
+ *		set by %FW_CDEV_CREATE_ISO_CONTEXT ioctl
+ * @type:	%FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL
+ * @completed:	Offset into the receive buffer; data before this offest is valid
+ *
+ * This event is sent in multichannel contexts (context type
+ * %FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL) for &fw_cdev_iso_packet buffer
+ * chunks that have the %FW_CDEV_ISO_INTERRUPT bit set.  Whether this happens
+ * when a packet is completed and/or when a buffer chunk is completed depends
+ * on the hardware implementation.
+ *
+ * The buffer is continuously filled with the following data, per packet:
+ *  - the 1394 iso packet header as described at &fw_cdev_event_iso_interrupt,
+ *    but in little endian byte order,
+ *  - packet payload (as many bytes as specified in the data_length field of
+ *    the 1394 iso packet header) in big endian byte order,
+ *  - 0...3 padding bytes as needed to align the following trailer quadlet,
+ *  - trailer quadlet, containing the reception timestamp as described at
+ *    &fw_cdev_event_iso_interrupt, but in little endian byte order.
+ *
+ * Hence the per-packet size is data_length (rounded up to a multiple of 4) + 8.
+ * When processing the data, stop before a packet that would cross the
+ * @completed offset.
+ *
+ * A packet near the end of a buffer chunk will typically spill over into the
+ * next queued buffer chunk.  It is the responsibility of the client to check
+ * for this condition, assemble a broken-up packet from its parts, and not to
+ * re-queue any buffer chunks in which as yet unread packet parts reside.
+ */
+struct fw_cdev_event_iso_interrupt_mc {
+	__u64 closure;
+	__u32 type;
+	__u32 completed;
+};
+
+/**
  * struct fw_cdev_event_iso_resource - Iso resources were allocated or freed
  * @closure:	See &fw_cdev_event_common;
  *		set by %FW_CDEV_IOC_(DE)ALLOCATE_ISO_RESOURCE(_ONCE) ioctl
@@ -316,16 +360,18 @@ struct fw_cdev_event_phy_packet {
 
 /**
  * union fw_cdev_event - Convenience union of fw_cdev_event_ types
- * @common:        Valid for all types
- * @bus_reset:     Valid if @common.type == %FW_CDEV_EVENT_BUS_RESET
- * @response:      Valid if @common.type == %FW_CDEV_EVENT_RESPONSE
- * @request:       Valid if @common.type == %FW_CDEV_EVENT_REQUEST
- * @request2:      Valid if @common.type == %FW_CDEV_EVENT_REQUEST2
- * @iso_interrupt: Valid if @common.type == %FW_CDEV_EVENT_ISO_INTERRUPT
- * @iso_resource:  Valid if @common.type ==
+ * @common:		Valid for all types
+ * @bus_reset:		Valid if @common.type == %FW_CDEV_EVENT_BUS_RESET
+ * @response:		Valid if @common.type == %FW_CDEV_EVENT_RESPONSE
+ * @request:		Valid if @common.type == %FW_CDEV_EVENT_REQUEST
+ * @request2:		Valid if @common.type == %FW_CDEV_EVENT_REQUEST2
+ * @iso_interrupt:	Valid if @common.type == %FW_CDEV_EVENT_ISO_INTERRUPT
+ * @iso_interrupt_mc:	Valid if @common.type ==
+ *				%FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL
+ * @iso_resource:	Valid if @common.type ==
  *				%FW_CDEV_EVENT_ISO_RESOURCE_ALLOCATED or
  *				%FW_CDEV_EVENT_ISO_RESOURCE_DEALLOCATED
- * @phy_packet:    Valid if @common.type ==
+ * @phy_packet:		Valid if @common.type ==
  *				%FW_CDEV_EVENT_PHY_PACKET_SENT or
  *				%FW_CDEV_EVENT_PHY_PACKET_RECEIVED
  *
@@ -342,10 +388,11 @@ union fw_cdev_event {
 	struct fw_cdev_event_bus_reset		bus_reset;
 	struct fw_cdev_event_response		response;
 	struct fw_cdev_event_request		request;
-	struct fw_cdev_event_request2		request2;     /* added in 2.6.36 */
+	struct fw_cdev_event_request2		request2;		/* added in 2.6.36 */
 	struct fw_cdev_event_iso_interrupt	iso_interrupt;
-	struct fw_cdev_event_iso_resource	iso_resource; /* added in 2.6.30 */
-	struct fw_cdev_event_phy_packet		phy_packet;   /* added in 2.6.36 */
+	struct fw_cdev_event_iso_interrupt_mc	iso_interrupt_mc;	/* added in 2.6.36 */
+	struct fw_cdev_event_iso_resource	iso_resource;		/* added in 2.6.30 */
+	struct fw_cdev_event_phy_packet		phy_packet;		/* added in 2.6.36 */
 };
 
 /* available since kernel version 2.6.22 */
@@ -380,6 +427,7 @@ union fw_cdev_event {
 /* available since kernel version 2.6.36 */
 #define FW_CDEV_IOC_SEND_PHY_PACKET    _IOWR('#', 0x15, struct fw_cdev_send_phy_packet)
 #define FW_CDEV_IOC_RECEIVE_PHY_PACKETS _IOW('#', 0x16, struct fw_cdev_receive_phy_packets)
+#define FW_CDEV_IOC_SET_ISO_CHANNELS    _IOW('#', 0x17, struct fw_cdev_set_iso_channels)
 
 /*
  * ABI version history
@@ -396,10 +444,13 @@ union fw_cdev_event {
  *               - shared use and auto-response for FCP registers
  *  3  (2.6.34)  - made &fw_cdev_get_cycle_timer reliable
  *               - added %FW_CDEV_IOC_GET_CYCLE_TIMER2
- *  4  (2.6.36)  - added %FW_CDEV_EVENT_REQUEST2, %FW_CDEV_EVENT_PHY_PACKET_*
+ *  4  (2.6.36)  - added %FW_CDEV_EVENT_REQUEST2, %FW_CDEV_EVENT_PHY_PACKET_*,
+ *                 and &fw_cdev_allocate.region_end
  *               - implemented &fw_cdev_event_bus_reset.bm_node_id
  *               - added %FW_CDEV_IOC_SEND_PHY_PACKET, _RECEIVE_PHY_PACKETS
- *               - added &fw_cdev_allocate.region_end
+ *               - added %FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL,
+ *                 %FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL, and
+ *                 %FW_CDEV_IOC_SET_ISO_CHANNELS
  */
 #define FW_CDEV_VERSION 3 /* Meaningless; don't use this macro. */
 
@@ -602,34 +653,43 @@ struct fw_cdev_remove_descriptor {
 	__u32 handle;
 };
 
-#define FW_CDEV_ISO_CONTEXT_TRANSMIT	0
-#define FW_CDEV_ISO_CONTEXT_RECEIVE	1
+#define FW_CDEV_ISO_CONTEXT_TRANSMIT			0
+#define FW_CDEV_ISO_CONTEXT_RECEIVE			1
+#define FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL	2 /* added in 2.6.36 */
 
 /**
- * struct fw_cdev_create_iso_context - Create a context for isochronous IO
- * @type:	%FW_CDEV_ISO_CONTEXT_TRANSMIT or %FW_CDEV_ISO_CONTEXT_RECEIVE
- * @header_size: Header size to strip for receive contexts
- * @channel:	Channel to bind to
- * @speed:	Speed for transmit contexts
- * @closure:	To be returned in &fw_cdev_event_iso_interrupt
+ * struct fw_cdev_create_iso_context - Create a context for isochronous I/O
+ * @type:	%FW_CDEV_ISO_CONTEXT_TRANSMIT or %FW_CDEV_ISO_CONTEXT_RECEIVE or
+ *		%FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL
+ * @header_size: Header size to strip in single-channel reception
+ * @channel:	Channel to bind to in single-channel reception or transmission
+ * @speed:	Transmission speed
+ * @closure:	To be returned in &fw_cdev_event_iso_interrupt or
+ *		&fw_cdev_event_iso_interrupt_multichannel
  * @handle:	Handle to context, written back by kernel
  *
  * Prior to sending or receiving isochronous I/O, a context must be created.
  * The context records information about the transmit or receive configuration
  * and typically maps to an underlying hardware resource.  A context is set up
  * for either sending or receiving.  It is bound to a specific isochronous
- * channel.
+ * @channel.
  *
- * If a context was successfully created, the kernel writes back a handle to the
- * context, which must be passed in for subsequent operations on that context.
+ * In case of multichannel reception, @header_size and @channel are ignored
+ * and the channels are selected by %FW_CDEV_IOC_SET_ISO_CHANNELS.
  *
- * For receive contexts, @header_size must be at least 4 and must be a multiple
- * of 4.
+ * For %FW_CDEV_ISO_CONTEXT_RECEIVE contexts, @header_size must be at least 4
+ * and must be a multiple of 4.  It is ignored in other context types.
  *
- * Note that the effect of a @header_size > 4 depends on
- * &fw_cdev_get_info.version, as documented at &fw_cdev_event_iso_interrupt.
+ * @speed is ignored in receive context types.
+ *
+ * If a context was successfully created, the kernel writes back a handle to the
+ * context, which must be passed in for subsequent operations on that context.
  *
+ * Limitations:
  * No more than one iso context can be created per fd.
+ * The total number of contexts that all userspace and kernelspace drivers can
+ * create on a card at a time is a hardware limit, typically 4 or 8 contexts per
+ * direction, and of them at most one multichannel receive context.
  */
 struct fw_cdev_create_iso_context {
 	__u32 type;
@@ -640,6 +700,22 @@ struct fw_cdev_create_iso_context {
 	__u32 handle;
 };
 
+/**
+ * struct fw_cdev_set_iso_channels - Select channels in multichannel reception
+ * @channels:	Bitmask of channels to listen to
+ * @handle:	Handle of the mutichannel receive context
+ *
+ * @channels is the bitwise or of 1ULL << n for each channel n to listen to.
+ *
+ * The ioctl fails with errno %EBUSY if there is already another receive context
+ * on a channel in @channels.  In that case, the bitmask of all unoccupied
+ * channels is returned in @channels.
+ */
+struct fw_cdev_set_iso_channels {
+	__u64 channels;
+	__u32 handle;
+};
+
 #define FW_CDEV_ISO_PAYLOAD_LENGTH(v)	(v)
 #define FW_CDEV_ISO_INTERRUPT		(1 << 16)
 #define FW_CDEV_ISO_SKIP		(1 << 17)
@@ -650,42 +726,72 @@ struct fw_cdev_create_iso_context {
 
 /**
  * struct fw_cdev_iso_packet - Isochronous packet
- * @control:	Contains the header length (8 uppermost bits), the sy field
- *		(4 bits), the tag field (2 bits), a sync flag (1 bit),
- *		a skip flag (1 bit), an interrupt flag (1 bit), and the
+ * @control:	Contains the header length (8 uppermost bits),
+ *		the sy field (4 bits), the tag field (2 bits), a sync flag
+ *		or a skip flag (1 bit), an interrupt flag (1 bit), and the
  *		payload length (16 lowermost bits)
- * @header:	Header and payload
+ * @header:	Header and payload in case of a transmit context.
  *
  * &struct fw_cdev_iso_packet is used to describe isochronous packet queues.
- *
  * Use the FW_CDEV_ISO_ macros to fill in @control.
+ * The @header array is empty in case of receive contexts.
+ *
+ * Context type %FW_CDEV_ISO_CONTEXT_TRANSMIT:
+ *
+ * @control.HEADER_LENGTH must be a multiple of 4.  It specifies the numbers of
+ * bytes in @header that will be prepended to the packet's payload.  These bytes
+ * are copied into the kernel and will not be accessed after the ioctl has
+ * returned.
+ *
+ * The @control.SY and TAG fields are copied to the iso packet header.  These
+ * fields are specified by IEEE 1394a and IEC 61883-1.
+ *
+ * The @control.SKIP flag specifies that no packet is to be sent in a frame.
+ * When using this, all other fields except @control.INTERRUPT must be zero.
+ *
+ * When a packet with the @control.INTERRUPT flag set has been completed, an
+ * &fw_cdev_event_iso_interrupt event will be sent.
  *
- * For transmit packets, the header length must be a multiple of 4 and specifies
- * the numbers of bytes in @header that will be prepended to the packet's
- * payload; these bytes are copied into the kernel and will not be accessed
- * after the ioctl has returned.  The sy and tag fields are copied to the iso
- * packet header (these fields are specified by IEEE 1394a and IEC 61883-1).
- * The skip flag specifies that no packet is to be sent in a frame; when using
- * this, all other fields except the interrupt flag must be zero.
- *
- * For receive packets, the header length must be a multiple of the context's
- * header size; if the header length is larger than the context's header size,
- * multiple packets are queued for this entry.  The sy and tag fields are
- * ignored.  If the sync flag is set, the context drops all packets until
- * a packet with a matching sy field is received (the sync value to wait for is
- * specified in the &fw_cdev_start_iso structure).  The payload length defines
- * how many payload bytes can be received for one packet (in addition to payload
- * quadlets that have been defined as headers and are stripped and returned in
- * the &fw_cdev_event_iso_interrupt structure).  If more bytes are received, the
- * additional bytes are dropped.  If less bytes are received, the remaining
- * bytes in this part of the payload buffer will not be written to, not even by
- * the next packet, i.e., packets received in consecutive frames will not
- * necessarily be consecutive in memory.  If an entry has queued multiple
- * packets, the payload length is divided equally among them.
+ * Context type %FW_CDEV_ISO_CONTEXT_RECEIVE:
  *
- * When a packet with the interrupt flag set has been completed, the
+ * @control.HEADER_LENGTH must be a multiple of the context's header_size.
+ * If the HEADER_LENGTH is larger than the context's header_size, multiple
+ * packets are queued for this entry.
+ *
+ * The @control.SY and TAG fields are ignored.
+ *
+ * If the @control.SYNC flag is set, the context drops all packets until a
+ * packet with a sy field is received which matches &fw_cdev_start_iso.sync.
+ *
+ * @control.PAYLOAD_LENGTH defines how many payload bytes can be received for
+ * one packet (in addition to payload quadlets that have been defined as headers
+ * and are stripped and returned in the &fw_cdev_event_iso_interrupt structure).
+ * If more bytes are received, the additional bytes are dropped.  If less bytes
+ * are received, the remaining bytes in this part of the payload buffer will not
+ * be written to, not even by the next packet.  I.e., packets received in
+ * consecutive frames will not necessarily be consecutive in memory.  If an
+ * entry has queued multiple packets, the PAYLOAD_LENGTH is divided equally
+ * among them.
+ *
+ * When a packet with the @control.INTERRUPT flag set has been completed, an
  * &fw_cdev_event_iso_interrupt event will be sent.  An entry that has queued
  * multiple receive packets is completed when its last packet is completed.
+ *
+ * Context type %FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL:
+ *
+ * Here, &fw_cdev_iso_packet would be more aptly named _iso_buffer_chunk since
+ * it specifies a chunk of the mmap()'ed buffer, while the number and alignment
+ * of packets to be placed into the buffer chunk is not known beforehand.
+ *
+ * @control.PAYLOAD_LENGTH is the size of the buffer chunk and specifies room
+ * for header, payload, padding, and trailer bytes of one or more packets.
+ * It must be a multiple of 4.
+ *
+ * @control.HEADER_LENGTH, TAG and SY are ignored.  SYNC is treated as described
+ * for single-channel reception.
+ *
+ * When a buffer chunk with the @control.INTERRUPT flag set has been filled
+ * entirely, an &fw_cdev_event_iso_interrupt_mc event will be sent.
  */
 struct fw_cdev_iso_packet {
 	__u32 control;
@@ -694,9 +800,9 @@ struct fw_cdev_iso_packet {
 
 /**
  * struct fw_cdev_queue_iso - Queue isochronous packets for I/O
- * @packets:	Userspace pointer to packet data
+ * @packets:	Userspace pointer to an array of &fw_cdev_iso_packet
  * @data:	Pointer into mmap()'ed payload buffer
- * @size:	Size of packet data in bytes
+ * @size:	Size of the @packets array, in bytes
  * @handle:	Isochronous context handle
  *
  * Queue a number of isochronous packets for reception or transmission.
@@ -709,6 +815,9 @@ struct fw_cdev_iso_packet {
  * The kernel may or may not queue all packets, but will write back updated
  * values of the @packets, @data and @size fields, so the ioctl can be
  * resubmitted easily.
+ *
+ * In case of a multichannel receive context, @data must be quadlet-aligned
+ * relative to the buffer start.
  */
 struct fw_cdev_queue_iso {
 	__u64 packets;
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -372,17 +372,19 @@ void fw_core_remove_descriptor(struct fw
  * scatter-gather streaming (e.g. assembling video frame automatically).
  */
 struct fw_iso_packet {
-	u16 payload_length;	/* Length of indirect payload. */
-	u32 interrupt:1;	/* Generate interrupt on this packet */
-	u32 skip:1;		/* Set to not send packet at all. */
-	u32 tag:2;
-	u32 sy:4;
-	u32 header_length:8;	/* Length of immediate header. */
-	u32 header[0];
+	u16 payload_length;	/* Length of indirect payload		*/
+	u32 interrupt:1;	/* Generate interrupt on this packet	*/
+	u32 skip:1;		/* tx: Set to not send packet at all	*/
+				/* rx: Sync bit, wait for matching sy	*/
+	u32 tag:2;		/* tx: Tag in packet header		*/
+	u32 sy:4;		/* tx: Sy in packet header		*/
+	u32 header_length:8;	/* Length of immediate header		*/
+	u32 header[0];		/* tx: Top of 1394 isoch. data_block	*/
 };
 
-#define FW_ISO_CONTEXT_TRANSMIT	0
-#define FW_ISO_CONTEXT_RECEIVE	1
+#define FW_ISO_CONTEXT_TRANSMIT			0
+#define FW_ISO_CONTEXT_RECEIVE			1
+#define FW_ISO_CONTEXT_RECEIVE_MULTICHANNEL	2
 
 #define FW_ISO_CONTEXT_MATCH_TAG0	 1
 #define FW_ISO_CONTEXT_MATCH_TAG1	 2
@@ -406,24 +408,31 @@ struct fw_iso_buffer {
 int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
 		       int page_count, enum dma_data_direction direction);
 void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer, struct fw_card *card);
+size_t fw_iso_buffer_lookup(struct fw_iso_buffer *buffer, dma_addr_t completed);
 
 struct fw_iso_context;
 typedef void (*fw_iso_callback_t)(struct fw_iso_context *context,
 				  u32 cycle, size_t header_length,
 				  void *header, void *data);
+typedef void (*fw_iso_mc_callback_t)(struct fw_iso_context *context,
+				     dma_addr_t completed, void *data);
 struct fw_iso_context {
 	struct fw_card *card;
 	int type;
 	int channel;
 	int speed;
 	size_t header_size;
-	fw_iso_callback_t callback;
+	union {
+		fw_iso_callback_t sc;
+		fw_iso_mc_callback_t mc;
+	} callback;
 	void *callback_data;
 };
 
 struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
 		int type, int channel, int speed, size_t header_size,
 		fw_iso_callback_t callback, void *callback_data);
+int fw_iso_context_set_channels(struct fw_iso_context *ctx, u64 *channels);
 int fw_iso_context_queue(struct fw_iso_context *ctx,
 			 struct fw_iso_packet *packet,
 			 struct fw_iso_buffer *buffer,

-- 
Stefan Richter
-=====-==-=- -=== ===-=
http://arcgraph.de/sr/

