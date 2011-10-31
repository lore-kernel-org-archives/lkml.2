Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab1JaRhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:37:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47923 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933411Ab1JaRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:37:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 31 Oct 2011 18:36:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [git pull] FireWire updates post 3.1
Message-ID: <20111031183659.2f31f8da@stein>
In-Reply-To: <20111031183259.4427c1e6@stein>
References: <20111031183259.4427c1e6@stein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9VHbXkP009445

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git for-linus
> 
>     head sha1: a572e688cf5d99d2382016c7241ec37b523b0137
> 
> to receive the following updates for the IEEE 1394 (FireWire) subsystem.

commit a572e688cf5d99d2382016c7241ec37b523b0137
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Sat Oct 15 23:12:23 2011 +0200

    firewire: ohci: fix isochronous DMA synchronization
    
    Add the dma_sync_single_* calls necessary to ensure proper cache
    synchronization for isochronous data buffers on non-coherent
    architectures.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index b697714..6628fea 100644
- --- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -126,6 +126,7 @@ struct context {
 	struct fw_ohci *ohci;
 	u32 regs;
 	int total_allocation;
+	u32 current_bus;
 	bool running;
 	bool flushing;
 
@@ -1057,6 +1058,7 @@ static void context_tasklet(unsigned long data)
 		address = le32_to_cpu(last->branch_address);
 		z = address & 0xf;
 		address &= ~0xf;
+		ctx->current_bus = address;
 
 		/* If the branch address points to a buffer outside of the
 		 * current buffer, advance to the next buffer. */
@@ -2697,6 +2699,7 @@ static int handle_ir_packet_per_buffer(struct context *context,
 	struct iso_context *ctx =
 		container_of(context, struct iso_context, context);
 	struct descriptor *pd;
+	u32 buffer_dma;
 	__le32 *ir_header;
 	void *p;
 
@@ -2707,6 +2710,16 @@ static int handle_ir_packet_per_buffer(struct context *context,
 		/* Descriptor(s) not done yet, stop iteration */
 		return 0;
 
+	while (!(d->control & cpu_to_le16(DESCRIPTOR_BRANCH_ALWAYS))) {
+		d++;
+		buffer_dma = le32_to_cpu(d->data_address);
+		dma_sync_single_range_for_cpu(context->ohci->card.device,
+					      buffer_dma & PAGE_MASK,
+					      buffer_dma & ~PAGE_MASK,
+					      le16_to_cpu(d->req_count),
+					      DMA_FROM_DEVICE);
+	}
+
 	p = last + 1;
 	copy_iso_headers(ctx, p);
 
@@ -2729,11 +2742,19 @@ static int handle_ir_buffer_fill(struct context *context,
 {
 	struct iso_context *ctx =
 		container_of(context, struct iso_context, context);
+	u32 buffer_dma;
 
 	if (!last->transfer_status)
 		/* Descriptor(s) not done yet, stop iteration */
 		return 0;
 
+	buffer_dma = le32_to_cpu(last->data_address);
+	dma_sync_single_range_for_cpu(context->ohci->card.device,
+				      buffer_dma & PAGE_MASK,
+				      buffer_dma & ~PAGE_MASK,
+				      le16_to_cpu(last->req_count),
+				      DMA_FROM_DEVICE);
+
 	if (le16_to_cpu(last->control) & DESCRIPTOR_IRQ_ALWAYS)
 		ctx->base.callback.mc(&ctx->base,
 				      le32_to_cpu(last->data_address) +
@@ -2744,6 +2765,43 @@ static int handle_ir_buffer_fill(struct context *context,
 	return 1;
 }
 
+static inline void sync_it_packet_for_cpu(struct context *context,
+					  struct descriptor *pd)
+{
+	__le16 control;
+	u32 buffer_dma;
+
+	/* only packets beginning with OUTPUT_MORE* have data buffers */
+	if (pd->control & cpu_to_le16(DESCRIPTOR_BRANCH_ALWAYS))
+		return;
+
+	/* skip over the OUTPUT_MORE_IMMEDIATE descriptor */
+	pd += 2;
+
+	/*
+	 * If the packet has a header, the first OUTPUT_MORE/LAST descriptor's
+	 * data buffer is in the context program's coherent page and must not
+	 * be synced.
+	 */
+	if ((le32_to_cpu(pd->data_address) & PAGE_MASK) ==
+	    (context->current_bus          & PAGE_MASK)) {
+		if (pd->control & cpu_to_le16(DESCRIPTOR_BRANCH_ALWAYS))
+			return;
+		pd++;
+	}
+
+	do {
+		buffer_dma = le32_to_cpu(pd->data_address);
+		dma_sync_single_range_for_cpu(context->ohci->card.device,
+					      buffer_dma & PAGE_MASK,
+					      buffer_dma & ~PAGE_MASK,
+					      le16_to_cpu(pd->req_count),
+					      DMA_TO_DEVICE);
+		control = pd->control;
+		pd++;
+	} while (!(control & cpu_to_le16(DESCRIPTOR_BRANCH_ALWAYS)));
+}
+
 static int handle_it_packet(struct context *context,
 			    struct descriptor *d,
 			    struct descriptor *last)
@@ -2760,6 +2818,8 @@ static int handle_it_packet(struct context *context,
 		/* Descriptor(s) not done yet, stop iteration */
 		return 0;
 
+	sync_it_packet_for_cpu(context, d);
+
 	i = ctx->header_length;
 	if (i + 4 < PAGE_SIZE) {
 		/* Present this value as big-endian to match the receive code */
@@ -3129,6 +3189,10 @@ static int queue_iso_transmit(struct iso_context *ctx,
 		page_bus = page_private(buffer->pages[page]);
 		pd[i].data_address = cpu_to_le32(page_bus + offset);
 
+		dma_sync_single_range_for_device(ctx->context.ohci->card.device,
+						 page_bus, offset, length,
+						 DMA_TO_DEVICE);
+
 		payload_index += length;
 	}
 
@@ -3153,6 +3217,7 @@ static int queue_iso_packet_per_buffer(struct iso_context *ctx,
 				       struct fw_iso_buffer *buffer,
 				       unsigned long payload)
 {
+	struct device *device = ctx->context.ohci->card.device;
 	struct descriptor *d, *pd;
 	dma_addr_t d_bus, page_bus;
 	u32 z, header_z, rest;
@@ -3207,6 +3272,10 @@ static int queue_iso_packet_per_buffer(struct iso_context *ctx,
 			page_bus = page_private(buffer->pages[page]);
 			pd->data_address = cpu_to_le32(page_bus + offset);
 
+			dma_sync_single_range_for_device(device, page_bus,
+							 offset, length,
+							 DMA_FROM_DEVICE);
+
 			offset = (offset + length) & ~PAGE_MASK;
 			rest -= length;
 			if (offset == 0)
@@ -3266,6 +3335,10 @@ static int queue_iso_buffer_fill(struct iso_context *ctx,
 		page_bus = page_private(buffer->pages[page]);
 		d->data_address = cpu_to_le32(page_bus + offset);
 
+		dma_sync_single_range_for_device(ctx->context.ohci->card.device,
+						 page_bus, offset, length,
+						 DMA_FROM_DEVICE);
+
 		rest -= length;
 		offset = 0;
 		page++;

commit 32eaeae177bf77fbc224c35262add45bd5e6abb3
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Sat Oct 15 18:14:39 2011 +0200

    firewire: ohci: work around selfID junk due to wrong gap count
    
    If a device's firmware initiates a bus reset by setting the IBR bit in
    PHY register 1 without resetting the gap count field to 63 (and without
    having sent a PHY configuration packet beforehand), the gap count of
    this node will remain at the old value after the bus reset and thus be
    inconsistent with the gap count on all other nodes.
    
    The bus manager is supposed to detect the inconsistent gap count values
    in the self ID packets and correct them by issuing another bus reset.
    
    However, if the buggy device happens to be the cycle master, and if it
    sends a cycle start packet immediately after the bus reset (which is
    likely after a long bus reset), then the time between the end of the
    selfID phase and the start of the cycle start packet will be based on
    the too-small gap count value, so this gap will be too short to be
    detected as a subaction gap by the other nodes.  This means that the
    cycle start packet will be assumed to be self ID data, and will be
    stored after the actual self ID quadlets in the self ID buffer.
    
    This garbage in the self ID buffer made firewire-core ignore all of the
    self ID data, and thus prevented the Linux bus manager from correcting
    the problem.  Furthermore, because the bus reset handling was aborted
    completely, asynchronous transfers would be no longer handled correctly,
    and fw_run_transaction() would hang until the next bus reset.
    
    To fix this, make the detection of inconsistent self IDs more
    discriminating:  If the invalid data in the self ID buffer looks like
    a cycle start packet, we can assume that the previous data in the buffer
    is correctly received self ID information, and process it normally.
    
    (We inspect only the first quadlet of the cycle start packet, because
    this value is different enough from any valid self ID quadlet, and many
    controllers do not store the cycle start packet in five quadlets because
    they expect self ID data to have an even number of quadlets.)
    
    This bug has been observed when a bus-powered DesktopKonnekt6 is
    switched off with its power button.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index bffc2ad..b697714 100644
- --- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -1860,8 +1860,22 @@ static void bus_reset_work(struct work_struct *work)
 
 	for (i = 1, j = 0; j < self_id_count; i += 2, j++) {
 		if (ohci->self_id_cpu[i] != ~ohci->self_id_cpu[i + 1]) {
- -			fw_notify("inconsistent self IDs\n");
- -			return;
+			/*
+			 * If the invalid data looks like a cycle start packet,
+			 * it's likely to be the result of the cycle master
+			 * having a wrong gap count.  In this case, the self IDs
+			 * so far are valid and should be processed so that the
+			 * bus manager can then correct the gap count.
+			 */
+			if (cond_le32_to_cpu(ohci->self_id_cpu[i])
+							== 0xffff008f) {
+				fw_notify("ignoring spurious self IDs\n");
+				self_id_count = j;
+				break;
+			} else {
+				fw_notify("inconsistent self IDs\n");
+				return;
+			}
 		}
 		ohci->self_id_buffer[j] =
 				cond_le32_to_cpu(ohci->self_id_cpu[i]);

commit a74477db9171e677b7a37b89e6e0ac8a15ba1f26
Author: Stephan Gatzka <stephan@gatzka.org>
Date:   Mon Sep 26 21:44:30 2011 +0200

    firewire: net: Use posted writes
    
    Change memory region to ohci "middle address space". This effectively
    reduces the number of packets by 50%.
    
    [Stefan R.:]  This eliminates 1394 ack packets and improved throughput
    by a few percent in some tests with an S400a connection with and without
    gap count optimization.  Since firewire-net taxes the AR-req DMA unit of
    a FireWire controller much more than firewire-sbp2 (which uses the
    middle address space with PCI posted writes too), this commit also
    changes a related error printk into a ratelimited one as a precaution.
    
    Side note:  The IPv4-over-1394 drivers of Mac OS X 10.4, Windows XP SP3,
    and the Thesycon 1394 bus driver for Windows all use the middle address
    space too.
    
    Signed-off-by: Stephan Gatzka <stephan@gatzka.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index d1fad1f..a20f45b 100644
- --- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1121,17 +1121,12 @@ static int fwnet_broadcast_start(struct fwnet_device *dev)
 	unsigned u;
 
 	if (dev->local_fifo == FWNET_NO_FIFO_ADDR) {
- -		/* outside OHCI posted write area? */
- -		static const struct fw_address_region region = {
- -			.start = 0xffff00000000ULL,
- -			.end   = CSR_REGISTER_BASE,
- -		};
- -
 		dev->handler.length = 4096;
 		dev->handler.address_callback = fwnet_receive_packet;
 		dev->handler.callback_data = dev;
 
- -		retval = fw_core_add_address_handler(&dev->handler, &region);
+		retval = fw_core_add_address_handler(&dev->handler,
+					&fw_high_memory_region);
 		if (retval < 0)
 			goto failed_initial;
 
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 399d592..bffc2ad 100644
- --- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2045,7 +2045,8 @@ static irqreturn_t irq_handler(int irq, void *data)
 		reg_read(ohci, OHCI1394_PostedWriteAddressLo);
 		reg_write(ohci, OHCI1394_IntEventClear,
 			  OHCI1394_postedWriteErr);
- -		fw_error("PCI posted write error\n");
+		if (printk_ratelimit())
+			fw_error("PCI posted write error\n");
 	}
 
 	if (unlikely(event & OHCI1394_cycleTooLong)) {

commit 4ec4a67aa100268b4ac5ae32b54843d975969969
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Sep 19 00:20:48 2011 +0200

    firewire: use clamp and min3 macros
    
    Use kernel.h's convenience macros.  Also omit a printk that should never
    happen and won't matter much if it ever happened.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index 334b82a..855ab3f 100644
- --- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -1046,8 +1046,8 @@ static void update_split_timeout(struct fw_card *card)
 
 	cycles = card->split_timeout_hi * 8000 + (card->split_timeout_lo >> 19);
 
- -	cycles = max(cycles, 800u); /* minimum as per the spec */
- -	cycles = min(cycles, 3u * 8000u); /* maximum OHCI timeout */
+	/* minimum per IEEE 1394, maximum which doesn't overflow OHCI */
+	cycles = clamp(cycles, 800u, 3u * 8000u);
 
 	card->split_timeout_cycles = cycles;
 	card->split_timeout_jiffies = DIV_ROUND_UP(cycles * HZ, 8000);
diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 03a7a85..d1fad1f 100644
- --- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -502,11 +502,7 @@ static struct fwnet_peer *fwnet_peer_find_by_node_id(struct fwnet_device *dev,
 static unsigned fwnet_max_payload(unsigned max_rec, unsigned speed)
 {
 	max_rec = min(max_rec, speed + 8);
- -	max_rec = min(max_rec, 0xbU); /* <= 4096 */
- -	if (max_rec < 8) {
- -		fw_notify("max_rec %x out of range\n", max_rec);
- -		max_rec = 8;
- -	}
+	max_rec = clamp(max_rec, 8U, 11U); /* 512...4096 */
 
 	return (1 << (max_rec + 1)) - RFC2374_FRAG_HDR_SIZE;
 }
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 8a8047d..68375bc 100644
- --- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1164,8 +1164,8 @@ static int sbp2_probe(struct device *dev)
 	 * specifies the max payload size as 2 ^ (max_payload + 2), so
 	 * if we set this to max_speed + 7, we get the right value.
 	 */
- -	tgt->max_payload = min(device->max_speed + 7, 10U);
- -	tgt->max_payload = min(tgt->max_payload, device->card->max_receive - 1);
+	tgt->max_payload = min3(device->max_speed + 7, 10U,
+				device->card->max_receive - 1);
 
 	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)

commit b810e4ae111cb8b4c0ccbbe7ff4ea0a23c671e4f
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Sep 19 09:29:30 2011 +0200

    firewire: ohci: optimize TSB41BA3D detection
    
    Takes less source code and machine code, and less runtime with PHYs
    other than TSB41BA3D (e.g. TSB81BA3 with device ID 0x831304 which takes
    one instead of six read_paged_phy_reg now).
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 862fdf3..399d592 100644
- --- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2159,38 +2159,26 @@ static int configure_1394a_enhancements(struct fw_ohci *ohci)
 	return 0;
 }
 
- -#define TSB41BA3D_VID 0x00080028
- -#define TSB41BA3D_PID 0x00833005
- -
 static int probe_tsb41ba3d(struct fw_ohci *ohci)
 {
- -	int reg, i, vendor_id, product_id;
+	/* TI vendor ID = 0x080028, TSB41BA3D product ID = 0x833005 (sic) */
+	static const u8 id[] = { 0x08, 0x00, 0x28, 0x83, 0x30, 0x05, };
+	int reg, i;
 
 	reg = read_phy_reg(ohci, 2);
 	if (reg < 0)
 		return reg;
+	if ((reg & PHY_EXTENDED_REGISTERS) != PHY_EXTENDED_REGISTERS)
+		return 0;
 
- -	if ((reg & PHY_EXTENDED_REGISTERS) == PHY_EXTENDED_REGISTERS) {
- -		vendor_id = 0;
- -		for (i = 10; i < 13; i++) {
- -			reg = read_paged_phy_reg(ohci, 1, i);
- -			if (reg < 0)
- -				return reg;
- -			vendor_id = (vendor_id << 8) | reg;
- -		}
- -		product_id = 0;
- -		for (i = 13; i < 16; i++) {
- -			reg = read_paged_phy_reg(ohci, 1, i);
- -			if (reg < 0)
- -				return reg;
- -			product_id = (product_id << 8) | reg;
- -		}
- -
- -		if ((vendor_id == TSB41BA3D_VID) &&
- -		    (product_id == TSB41BA3D_PID))
- -			return 1;
+	for (i = ARRAY_SIZE(id) - 1; i >= 0; i--) {
+		reg = read_paged_phy_reg(ohci, 1, i + 10);
+		if (reg < 0)
+			return reg;
+		if (reg != id[i])
+			return 0;
 	}
- -	return 0;
+	return 1;
 }
 
 static int ohci_enable(struct fw_card *card,

commit 28897fb73c848eb441e54e859d0b64ad6b44d2e6
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Mon Sep 19 00:17:37 2011 +0200

    firewire: ohci: TSB41BA3D support tweaks
    
    Fix:  phy_reg_mutex must be held over the write/read_phy_reg pair which
    gets PHY port status.
    
    Only print to the log when a TSB41BA3D was found.  By far most TSB82AA2
    cards have a TSB81BA3, and firewire-ohci can keep quiet about that.
    
    Shorten some strings and comments.  Change some whitespace.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index b983581..862fdf3 100644
- --- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -325,7 +325,7 @@ MODULE_PARM_DESC(quirks, "Chip quirks (default = 0"
 	", AR/selfID endianess = "	__stringify(QUIRK_BE_HEADERS)
 	", no 1394a enhancements = "	__stringify(QUIRK_NO_1394A)
 	", disable MSI = "		__stringify(QUIRK_NO_MSI)
- -	", workaround for TI SLLZ059 errata = "	__stringify(QUIRK_TI_SLLZ059)
+	", TI SLLZ059 erratum = "	__stringify(QUIRK_TI_SLLZ059)
 	")");
 
 #define OHCI_PARAM_DEBUG_AT_AR		1
@@ -1730,12 +1730,8 @@ static int get_status_for_port(struct fw_ohci *ohci, int port_index)
 
 	mutex_lock(&ohci->phy_reg_mutex);
 	reg = write_phy_reg(ohci, 7, port_index);
- -	mutex_unlock(&ohci->phy_reg_mutex);
- -	if (reg < 0)
- -		return reg;
- -
- -	mutex_lock(&ohci->phy_reg_mutex);
- -	reg = read_phy_reg(ohci, 8);
+	if (reg >= 0)
+		reg = read_phy_reg(ohci, 8);
 	mutex_unlock(&ohci->phy_reg_mutex);
 	if (reg < 0)
 		return reg;
@@ -1754,6 +1750,7 @@ static int get_self_id_pos(struct fw_ohci *ohci, u32 self_id,
 {
 	int i;
 	u32 entry;
+
 	for (i = 0; i < self_id_count; i++) {
 		entry = ohci->self_id_buffer[i];
 		if ((self_id & 0xff000000) == (entry & 0xff000000))
@@ -1765,33 +1762,16 @@ static int get_self_id_pos(struct fw_ohci *ohci, u32 self_id,
 }
 
 /*
- - * This function implements a work around for the Texas Instruments PHY
- - * TSB41BA3D. This phy has a bug at least in combination with the TI
- - * LLCs TSB82AA2B and TSB12LV26. The selfid coming from the locally
- - * connected phy is not propagated into the selfid buffer of the OHCI
- - * (see http://www.ti.com/litv/pdf/sllz059 for details).
- - * The main idea is to construct the selfid ourselves.
+ * TI TSB82AA2B and TSB12LV26 do not receive the selfID of a locally
+ * attached TSB41BA3D phy; see http://www.ti.com/litv/pdf/sllz059.
+ * Construct the selfID from phy register contents.
+ * FIXME:  How to determine the selfID.i flag?
  */
- -
 static int find_and_insert_self_id(struct fw_ohci *ohci, int self_id_count)
 {
- -	int reg;
- -	int i;
- -	int pos;
- -	int status;
- -	u32 self_id;
- -
- -/*
- - * preset bits in self_id
- - *
- - * link active: 0b1
- - * speed: 0b11
- - * bridge: 0b00
- - * contender: 0b1
- - * initiated reset: 0b0
- - * more packets: 0b0
- - */
- -	self_id = 0x8040C800;
+	int reg, i, pos, status;
+	/* link active 1, speed 3, bridge 0, contender 1, more packets 0 */
+	u32 self_id = 0x8040c800;
 
 	reg = reg_read(ohci, OHCI1394_NodeID);
 	if (!(reg & OHCI1394_NodeID_idValid)) {
@@ -1800,16 +1780,12 @@ static int find_and_insert_self_id(struct fw_ohci *ohci, int self_id_count)
 	}
 	self_id |= ((reg & 0x3f) << 24); /* phy ID */
 
- -	mutex_lock(&ohci->phy_reg_mutex);
- -	reg = read_phy_reg(ohci, 4);
- -	mutex_unlock(&ohci->phy_reg_mutex);
+	reg = ohci_read_phy_reg(&ohci->card, 4);
 	if (reg < 0)
 		return reg;
 	self_id |= ((reg & 0x07) << 8); /* power class */
 
- -	mutex_lock(&ohci->phy_reg_mutex);
- -	reg = read_phy_reg(ohci, 1);
- -	mutex_unlock(&ohci->phy_reg_mutex);
+	reg = ohci_read_phy_reg(&ohci->card, 1);
 	if (reg < 0)
 		return reg;
 	self_id |= ((reg & 0x3f) << 16); /* gap count */
@@ -1894,7 +1870,7 @@ static void bus_reset_work(struct work_struct *work)
 	if (ohci->quirks & QUIRK_TI_SLLZ059) {
 		self_id_count = find_and_insert_self_id(ohci, self_id_count);
 		if (self_id_count < 0) {
- -			fw_notify("could not construct local self IDs\n");
+			fw_notify("could not construct local self ID\n");
 			return;
 		}
 	}
@@ -2188,10 +2164,7 @@ static int configure_1394a_enhancements(struct fw_ohci *ohci)
 
 static int probe_tsb41ba3d(struct fw_ohci *ohci)
 {
- -	int reg;
- -	int i;
- -	int vendor_id;
- -	int product_id;
+	int reg, i, vendor_id, product_id;
 
 	reg = read_phy_reg(ohci, 2);
 	if (reg < 0)
@@ -2214,7 +2187,7 @@ static int probe_tsb41ba3d(struct fw_ohci *ohci)
 		}
 
 		if ((vendor_id == TSB41BA3D_VID) &&
- -			(product_id == TSB41BA3D_PID))
+		    (product_id == TSB41BA3D_PID))
 			return 1;
 	}
 	return 0;
@@ -2226,7 +2199,7 @@ static int ohci_enable(struct fw_card *card,
 	struct fw_ohci *ohci = fw_ohci(card);
 	struct pci_dev *dev = to_pci_dev(card->device);
 	u32 lps, seconds, version, irqs;
- -	int i, ret, tsb41ba3d_found;
+	int i, ret;
 
 	if (software_reset(ohci)) {
 		fw_error("Failed to reset ohci card.\n");
@@ -2258,14 +2231,13 @@ static int ohci_enable(struct fw_card *card,
 	}
 
 	if (ohci->quirks & QUIRK_TI_SLLZ059) {
- -		tsb41ba3d_found = probe_tsb41ba3d(ohci);
- -		if (tsb41ba3d_found < 0)
- -			return tsb41ba3d_found;
- -		if (!tsb41ba3d_found) {
- -			fw_notify("No TSB41BA3D found, "
- -				  "resetting QUIRK_TI_SLLZ059\n");
+		ret = probe_tsb41ba3d(ohci);
+		if (ret < 0)
+			return ret;
+		if (ret)
+			fw_notify("local TSB41BA3D phy\n");
+		else
 			ohci->quirks &= ~QUIRK_TI_SLLZ059;
- -		}
 	}
 
 	reg_write(ohci, OHCI1394_HCControlClear,

commit 25935ebebd861182ac58ecea67718bb6a617c7cb
Author: Stephan Gatzka <stephan@gatzka.org>
Date:   Mon Sep 12 22:23:53 2011 +0200

    firewire: ohci: Add support for TSB41BA3D phy
    
    This patch implements a work around for the Texas Instruments PHY
    TSB41BA3D.  This phy has a bug at least in combination with the TI LLCs
    TSB82AA2B and TSB12LV26.  The selfid coming from the locally connected
    phy is not propagated into the selfid buffer of the OHCI (see
    http://www.ti.com/litv/pdf/sllz059 for details).  The main idea is to
    construct the selfid ourselves.
    
    Signed-off-by: Stephan Gatzka <stephan@gatzka.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index c026f46..b983581 100644
- --- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -264,6 +264,8 @@ static char ohci_driver_name[] = KBUILD_MODNAME;
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
+#define PCI_DEVICE_ID_TI_TSB12LV26	0x8020
+#define PCI_DEVICE_ID_TI_TSB82AA2	0x8025
 #define PCI_VENDOR_ID_PINNACLE_SYSTEMS	0x11bd
 
 #define QUIRK_CYCLE_TIMER		1
@@ -271,6 +273,7 @@ static char ohci_driver_name[] = KBUILD_MODNAME;
 #define QUIRK_BE_HEADERS		4
 #define QUIRK_NO_1394A			8
 #define QUIRK_NO_MSI			16
+#define QUIRK_TI_SLLZ059		32
 
 /* In case of multiple matches in ohci_quirks[], only the first one is used. */
 static const struct {
@@ -300,6 +303,12 @@ static const struct {
 	{PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_TSB12LV22, PCI_ANY_ID,
 		QUIRK_CYCLE_TIMER | QUIRK_RESET_PACKET | QUIRK_NO_1394A},
 
+	{PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_TSB12LV26, PCI_ANY_ID,
+		QUIRK_RESET_PACKET | QUIRK_TI_SLLZ059},
+
+	{PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_TSB82AA2, PCI_ANY_ID,
+		QUIRK_RESET_PACKET | QUIRK_TI_SLLZ059},
+
 	{PCI_VENDOR_ID_TI, PCI_ANY_ID, PCI_ANY_ID,
 		QUIRK_RESET_PACKET},
 
@@ -316,6 +325,7 @@ MODULE_PARM_DESC(quirks, "Chip quirks (default = 0"
 	", AR/selfID endianess = "	__stringify(QUIRK_BE_HEADERS)
 	", no 1394a enhancements = "	__stringify(QUIRK_NO_1394A)
 	", disable MSI = "		__stringify(QUIRK_NO_MSI)
+	", workaround for TI SLLZ059 errata = "	__stringify(QUIRK_TI_SLLZ059)
 	")");
 
 #define OHCI_PARAM_DEBUG_AT_AR		1
@@ -1714,6 +1724,114 @@ static u32 update_bus_time(struct fw_ohci *ohci)
 	return ohci->bus_time | cycle_time_seconds;
 }
 
+static int get_status_for_port(struct fw_ohci *ohci, int port_index)
+{
+	int reg;
+
+	mutex_lock(&ohci->phy_reg_mutex);
+	reg = write_phy_reg(ohci, 7, port_index);
+	mutex_unlock(&ohci->phy_reg_mutex);
+	if (reg < 0)
+		return reg;
+
+	mutex_lock(&ohci->phy_reg_mutex);
+	reg = read_phy_reg(ohci, 8);
+	mutex_unlock(&ohci->phy_reg_mutex);
+	if (reg < 0)
+		return reg;
+
+	switch (reg & 0x0f) {
+	case 0x06:
+		return 2;	/* is child node (connected to parent node) */
+	case 0x0e:
+		return 3;	/* is parent node (connected to child node) */
+	}
+	return 1;		/* not connected */
+}
+
+static int get_self_id_pos(struct fw_ohci *ohci, u32 self_id,
+	int self_id_count)
+{
+	int i;
+	u32 entry;
+	for (i = 0; i < self_id_count; i++) {
+		entry = ohci->self_id_buffer[i];
+		if ((self_id & 0xff000000) == (entry & 0xff000000))
+			return -1;
+		if ((self_id & 0xff000000) < (entry & 0xff000000))
+			return i;
+	}
+	return i;
+}
+
+/*
+ * This function implements a work around for the Texas Instruments PHY
+ * TSB41BA3D. This phy has a bug at least in combination with the TI
+ * LLCs TSB82AA2B and TSB12LV26. The selfid coming from the locally
+ * connected phy is not propagated into the selfid buffer of the OHCI
+ * (see http://www.ti.com/litv/pdf/sllz059 for details).
+ * The main idea is to construct the selfid ourselves.
+ */
+
+static int find_and_insert_self_id(struct fw_ohci *ohci, int self_id_count)
+{
+	int reg;
+	int i;
+	int pos;
+	int status;
+	u32 self_id;
+
+/*
+ * preset bits in self_id
+ *
+ * link active: 0b1
+ * speed: 0b11
+ * bridge: 0b00
+ * contender: 0b1
+ * initiated reset: 0b0
+ * more packets: 0b0
+ */
+	self_id = 0x8040C800;
+
+	reg = reg_read(ohci, OHCI1394_NodeID);
+	if (!(reg & OHCI1394_NodeID_idValid)) {
+		fw_notify("node ID not valid, new bus reset in progress\n");
+		return -EBUSY;
+	}
+	self_id |= ((reg & 0x3f) << 24); /* phy ID */
+
+	mutex_lock(&ohci->phy_reg_mutex);
+	reg = read_phy_reg(ohci, 4);
+	mutex_unlock(&ohci->phy_reg_mutex);
+	if (reg < 0)
+		return reg;
+	self_id |= ((reg & 0x07) << 8); /* power class */
+
+	mutex_lock(&ohci->phy_reg_mutex);
+	reg = read_phy_reg(ohci, 1);
+	mutex_unlock(&ohci->phy_reg_mutex);
+	if (reg < 0)
+		return reg;
+	self_id |= ((reg & 0x3f) << 16); /* gap count */
+
+	for (i = 0; i < 3; i++) {
+		status = get_status_for_port(ohci, i);
+		if (status < 0)
+			return status;
+		self_id |= ((status & 0x3) << (6 - (i * 2)));
+	}
+
+	pos = get_self_id_pos(ohci, self_id, self_id_count);
+	if (pos >= 0) {
+		memmove(&(ohci->self_id_buffer[pos+1]),
+			&(ohci->self_id_buffer[pos]),
+			(self_id_count - pos) * sizeof(*ohci->self_id_buffer));
+		ohci->self_id_buffer[pos] = self_id;
+		self_id_count++;
+	}
+	return self_id_count;
+}
+
 static void bus_reset_work(struct work_struct *work)
 {
 	struct fw_ohci *ohci =
@@ -1755,10 +1873,12 @@ static void bus_reset_work(struct work_struct *work)
 	 * bit extra to get the actual number of self IDs.
 	 */
 	self_id_count = (reg >> 3) & 0xff;
- -	if (self_id_count == 0 || self_id_count > 252) {
+
+	if (self_id_count > 252) {
 		fw_notify("inconsistent self IDs\n");
 		return;
 	}
+
 	generation = (cond_le32_to_cpu(ohci->self_id_cpu[0]) >> 16) & 0xff;
 	rmb();
 
@@ -1770,6 +1890,19 @@ static void bus_reset_work(struct work_struct *work)
 		ohci->self_id_buffer[j] =
 				cond_le32_to_cpu(ohci->self_id_cpu[i]);
 	}
+
+	if (ohci->quirks & QUIRK_TI_SLLZ059) {
+		self_id_count = find_and_insert_self_id(ohci, self_id_count);
+		if (self_id_count < 0) {
+			fw_notify("could not construct local self IDs\n");
+			return;
+		}
+	}
+
+	if (self_id_count == 0) {
+		fw_notify("inconsistent self IDs\n");
+		return;
+	}
 	rmb();
 
 	/*
@@ -2050,13 +2183,50 @@ static int configure_1394a_enhancements(struct fw_ohci *ohci)
 	return 0;
 }
 
+#define TSB41BA3D_VID 0x00080028
+#define TSB41BA3D_PID 0x00833005
+
+static int probe_tsb41ba3d(struct fw_ohci *ohci)
+{
+	int reg;
+	int i;
+	int vendor_id;
+	int product_id;
+
+	reg = read_phy_reg(ohci, 2);
+	if (reg < 0)
+		return reg;
+
+	if ((reg & PHY_EXTENDED_REGISTERS) == PHY_EXTENDED_REGISTERS) {
+		vendor_id = 0;
+		for (i = 10; i < 13; i++) {
+			reg = read_paged_phy_reg(ohci, 1, i);
+			if (reg < 0)
+				return reg;
+			vendor_id = (vendor_id << 8) | reg;
+		}
+		product_id = 0;
+		for (i = 13; i < 16; i++) {
+			reg = read_paged_phy_reg(ohci, 1, i);
+			if (reg < 0)
+				return reg;
+			product_id = (product_id << 8) | reg;
+		}
+
+		if ((vendor_id == TSB41BA3D_VID) &&
+			(product_id == TSB41BA3D_PID))
+			return 1;
+	}
+	return 0;
+}
+
 static int ohci_enable(struct fw_card *card,
 		       const __be32 *config_rom, size_t length)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	struct pci_dev *dev = to_pci_dev(card->device);
 	u32 lps, seconds, version, irqs;
- -	int i, ret;
+	int i, ret, tsb41ba3d_found;
 
 	if (software_reset(ohci)) {
 		fw_error("Failed to reset ohci card.\n");
@@ -2087,6 +2257,17 @@ static int ohci_enable(struct fw_card *card,
 		return -EIO;
 	}
 
+	if (ohci->quirks & QUIRK_TI_SLLZ059) {
+		tsb41ba3d_found = probe_tsb41ba3d(ohci);
+		if (tsb41ba3d_found < 0)
+			return tsb41ba3d_found;
+		if (!tsb41ba3d_found) {
+			fw_notify("No TSB41BA3D found, "
+				  "resetting QUIRK_TI_SLLZ059\n");
+			ohci->quirks &= ~QUIRK_TI_SLLZ059;
+		}
+	}
+
 	reg_write(ohci, OHCI1394_HCControlClear,
 		  OHCI1394_HCControl_noByteSwapData);
 

commit 2d7a36e23300d268599f6eae4093643d22fbb356
Author: Stephan Gatzka <stephan@gatzka.org>
Date:   Mon Jul 25 22:16:24 2011 +0200

    firewire: ohci: Move code from the bus reset tasklet into a workqueue
    
    Code inside bus_reset_work may now sleep. This is a prerequisite to
    support a phy from Texas Instruments cleanly. The patch to support this
    phy will be submitted later.
    
    Signed-off-by: Stephan Gatzka <stephan@gatzka.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index fd7170a..c026f46 100644
- --- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -42,6 +42,7 @@
 #include <linux/string.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
+#include <linux/workqueue.h>
 
 #include <asm/byteorder.h>
 #include <asm/page.h>
@@ -226,7 +227,7 @@ struct fw_ohci {
 
 	__le32    *self_id_cpu;
 	dma_addr_t self_id_bus;
- -	struct tasklet_struct bus_reset_tasklet;
+	struct work_struct bus_reset_work;
 
 	u32 self_id_buffer[512];
 };
@@ -859,7 +860,7 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 	 *
 	 * Alas some chips sometimes emit bus reset packets with a
 	 * wrong generation.  We set the correct generation for these
- -	 * at a slightly incorrect time (in bus_reset_tasklet).
+	 * at a slightly incorrect time (in bus_reset_work).
 	 */
 	if (evt == OHCI1394_evt_bus_reset) {
 		if (!(ohci->quirks & QUIRK_RESET_PACKET))
@@ -1713,9 +1714,10 @@ static u32 update_bus_time(struct fw_ohci *ohci)
 	return ohci->bus_time | cycle_time_seconds;
 }
 
- -static void bus_reset_tasklet(unsigned long data)
+static void bus_reset_work(struct work_struct *work)
 {
- -	struct fw_ohci *ohci = (struct fw_ohci *)data;
+	struct fw_ohci *ohci =
+		container_of(work, struct fw_ohci, bus_reset_work);
 	int self_id_count, i, j, reg;
 	int generation, new_generation;
 	unsigned long flags;
@@ -1887,7 +1889,7 @@ static irqreturn_t irq_handler(int irq, void *data)
 	log_irqs(event);
 
 	if (event & OHCI1394_selfIDComplete)
- -		tasklet_schedule(&ohci->bus_reset_tasklet);
+		queue_work(fw_workqueue, &ohci->bus_reset_work);
 
 	if (event & OHCI1394_RQPkt)
 		tasklet_schedule(&ohci->ar_request_ctx.tasklet);
@@ -2260,7 +2262,7 @@ static int ohci_set_config_rom(struct fw_card *card,
 	 * then set up the real values for the two registers.
 	 *
 	 * We use ohci->lock to avoid racing with the code that sets
- -	 * ohci->next_config_rom to NULL (see bus_reset_tasklet).
+	 * ohci->next_config_rom to NULL (see bus_reset_work).
 	 */
 
 	next_config_rom =
@@ -3239,8 +3241,7 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	spin_lock_init(&ohci->lock);
 	mutex_init(&ohci->phy_reg_mutex);
 
- -	tasklet_init(&ohci->bus_reset_tasklet,
- -		     bus_reset_tasklet, (unsigned long)ohci);
+	INIT_WORK(&ohci->bus_reset_work, bus_reset_work);
 
 	err = pci_request_region(dev, 0, ohci_driver_name);
 	if (err) {
@@ -3382,6 +3383,7 @@ static void pci_remove(struct pci_dev *dev)
 	ohci = pci_get_drvdata(dev);
 	reg_write(ohci, OHCI1394_IntMaskClear, ~0);
 	flush_writes(ohci);
+	cancel_work_sync(&ohci->bus_reset_work);
 	fw_core_remove_card(&ohci->card);
 
 	/*

commit 32ce38f40337cf4a805552e494354d961587c838
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 27 15:35:23 2011 +0200

    firewire: sbp2: fold two functions into one
    
    sbp2_release_target() is folded into its primary user, sbp2_remove().
    The only other caller, a failure path in sbp2_probe(), now uses
    sbp2_remove().  This adds unnecessary cancel_delayed_work_sync() calls
    to that failure path but results in less code and text.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 09b79e9..8a8047d 100644
- --- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1110,7 +1110,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 }
 
 static struct scsi_host_template scsi_driver_template;
- -static void sbp2_release_target(struct sbp2_target *tgt);
+static int sbp2_remove(struct device *dev);
 
 static int sbp2_probe(struct device *dev)
 {
@@ -1153,7 +1153,7 @@ static int sbp2_probe(struct device *dev)
 
 	if (sbp2_scan_unit_dir(tgt, unit->directory, &model,
 			       &firmware_revision) < 0)
- -		goto fail_release_target;
+		goto fail_remove;
 
 	sbp2_clamp_management_orb_timeout(tgt);
 	sbp2_init_workarounds(tgt, model, firmware_revision);
@@ -1173,8 +1173,8 @@ static int sbp2_probe(struct device *dev)
 
 	return 0;
 
- - fail_release_target:
- -	sbp2_release_target(tgt);
+ fail_remove:
+	sbp2_remove(dev);
 	return -ENOMEM;
 
  fail_shost_put:
@@ -1200,18 +1200,21 @@ static void sbp2_update(struct fw_unit *unit)
 	}
 }
 
- -static void sbp2_release_target(struct sbp2_target *tgt)
+static int sbp2_remove(struct device *dev)
 {
+	struct fw_unit *unit = fw_unit(dev);
+	struct fw_device *device = fw_parent_device(unit);
+	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
 	struct sbp2_logical_unit *lu, *next;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 	struct scsi_device *sdev;
- -	struct fw_device *device = target_device(tgt);
 
 	/* prevent deadlocks */
 	sbp2_unblock(tgt);
 
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
+		cancel_delayed_work_sync(&lu->work);
 		sdev = scsi_device_lookup(shost, 0, 0, sbp2_lun2int(lu->lun));
 		if (sdev) {
 			scsi_remove_device(sdev);
@@ -1239,19 +1242,6 @@ static void sbp2_release_target(struct sbp2_target *tgt)
 	fw_notify("released %s, target %d:0:0\n", tgt->bus_id, shost->host_no);
 
 	scsi_host_put(shost);
- -}
- -
- -static int sbp2_remove(struct device *dev)
- -{
- -	struct fw_unit *unit = fw_unit(dev);
- -	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
- -	struct sbp2_logical_unit *lu;
- -
- -	list_for_each_entry(lu, &tgt->lu_list, link)
- -		cancel_delayed_work_sync(&lu->work);
- -
- -	sbp2_release_target(tgt);
- -
 	return 0;
 }
 

commit b2af07b6844aade3a6d69511625bef2b1cb609cc
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 27 15:34:32 2011 +0200

    firewire: sbp2: move some code to more sensible places
    
    Implement sbp2_queue_work(), which is now a very simple accessor to one
    of the struct sbp2_logical_unit members, right after the definition of
    struct sbp2_logical_unit.
    
    Put the sbp2_reconnect() implementation right after the sbp2_login()
    implementation.  They are both part of the SBP-2 access protocol.
    
    Implement the driver methods sbp2_probe(), spp2_update(), sbp2_remove()
    in this order, reflecting the lifetime of an SBP-2 target.
    
    Place the sbp2_release_target() implementation right next to
    sbp2_remove() which is its primary user, and after sbp2_probe() which is
    the counterpart to sbp2_release_target().
    
    There are no changes to the implementations here, or at least not meant
    to be.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index a2715b2..09b79e9 100644
- --- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -154,6 +154,11 @@ struct sbp2_logical_unit {
 	bool blocked;
 };
 
+static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
+{
+	queue_delayed_work(fw_workqueue, &lu->work, delay);
+}
+
 /*
  * We create one struct sbp2_target per IEEE 1212 Unit Directory
  * and one struct Scsi_Host per sbp2_target.
@@ -771,52 +776,6 @@ static int sbp2_lun2int(u16 lun)
 	return scsilun_to_int(&eight_bytes_lun);
 }
 
- -static void sbp2_release_target(struct sbp2_target *tgt)
- -{
- -	struct sbp2_logical_unit *lu, *next;
- -	struct Scsi_Host *shost =
- -		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
- -	struct scsi_device *sdev;
- -	struct fw_device *device = target_device(tgt);
- -
- -	/* prevent deadlocks */
- -	sbp2_unblock(tgt);
- -
- -	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
- -		sdev = scsi_device_lookup(shost, 0, 0, sbp2_lun2int(lu->lun));
- -		if (sdev) {
- -			scsi_remove_device(sdev);
- -			scsi_device_put(sdev);
- -		}
- -		if (lu->login_id != INVALID_LOGIN_ID) {
- -			int generation, node_id;
- -			/*
- -			 * tgt->node_id may be obsolete here if we failed
- -			 * during initial login or after a bus reset where
- -			 * the topology changed.
- -			 */
- -			generation = device->generation;
- -			smp_rmb(); /* node_id vs. generation */
- -			node_id    = device->node_id;
- -			sbp2_send_management_orb(lu, node_id, generation,
- -						 SBP2_LOGOUT_REQUEST,
- -						 lu->login_id, NULL);
- -		}
- -		fw_core_remove_address_handler(&lu->address_handler);
- -		list_del(&lu->link);
- -		kfree(lu);
- -	}
- -	scsi_remove_host(shost);
- -	fw_notify("released %s, target %d:0:0\n", tgt->bus_id, shost->host_no);
- -
- -	scsi_host_put(shost);
- -}
- -
- -static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
- -{
- -	queue_delayed_work(fw_workqueue, &lu->work, delay);
- -}
- -
 /*
  * Write retransmit retry values into the BUSY_TIMEOUT register.
  * - The single-phase retry protocol is supported by all SBP-2 devices, but the
@@ -955,6 +914,57 @@ static void sbp2_login(struct work_struct *work)
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 }
 
+static void sbp2_reconnect(struct work_struct *work)
+{
+	struct sbp2_logical_unit *lu =
+		container_of(work, struct sbp2_logical_unit, work.work);
+	struct sbp2_target *tgt = lu->tgt;
+	struct fw_device *device = target_device(tgt);
+	int generation, node_id, local_node_id;
+
+	if (fw_device_is_shutdown(device))
+		return;
+
+	generation    = device->generation;
+	smp_rmb();    /* node IDs must not be older than generation */
+	node_id       = device->node_id;
+	local_node_id = device->card->node_id;
+
+	if (sbp2_send_management_orb(lu, node_id, generation,
+				     SBP2_RECONNECT_REQUEST,
+				     lu->login_id, NULL) < 0) {
+		/*
+		 * If reconnect was impossible even though we are in the
+		 * current generation, fall back and try to log in again.
+		 *
+		 * We could check for "Function rejected" status, but
+		 * looking at the bus generation as simpler and more general.
+		 */
+		smp_rmb(); /* get current card generation */
+		if (generation == device->card->generation ||
+		    lu->retries++ >= 5) {
+			fw_error("%s: failed to reconnect\n", tgt->bus_id);
+			lu->retries = 0;
+			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+		}
+		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
+
+		return;
+	}
+
+	tgt->node_id      = node_id;
+	tgt->address_high = local_node_id << 16;
+	smp_wmb();	  /* node IDs must not be older than generation */
+	lu->generation	  = generation;
+
+	fw_notify("%s: reconnected to LUN %04x (%d retries)\n",
+		  tgt->bus_id, lu->lun, lu->retries);
+
+	sbp2_agent_reset(lu);
+	sbp2_cancel_orbs(lu);
+	sbp2_conditionally_unblock(lu);
+}
+
 static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 {
 	struct sbp2_logical_unit *lu;
@@ -1100,6 +1110,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 }
 
 static struct scsi_host_template scsi_driver_template;
+static void sbp2_release_target(struct sbp2_target *tgt);
 
 static int sbp2_probe(struct device *dev)
 {
@@ -1171,87 +1182,77 @@ static int sbp2_probe(struct device *dev)
 	return -ENOMEM;
 }
 
- -static int sbp2_remove(struct device *dev)
+static void sbp2_update(struct fw_unit *unit)
 {
- -	struct fw_unit *unit = fw_unit(dev);
 	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
 	struct sbp2_logical_unit *lu;
 
- -	list_for_each_entry(lu, &tgt->lu_list, link)
- -		cancel_delayed_work_sync(&lu->work);
- -
- -	sbp2_release_target(tgt);
+	fw_device_enable_phys_dma(fw_parent_device(unit));
 
- -	return 0;
+	/*
+	 * Fw-core serializes sbp2_update() against sbp2_remove().
+	 * Iteration over tgt->lu_list is therefore safe here.
+	 */
+	list_for_each_entry(lu, &tgt->lu_list, link) {
+		sbp2_conditionally_block(lu);
+		lu->retries = 0;
+		sbp2_queue_work(lu, 0);
+	}
 }
 
- -static void sbp2_reconnect(struct work_struct *work)
+static void sbp2_release_target(struct sbp2_target *tgt)
 {
- -	struct sbp2_logical_unit *lu =
- -		container_of(work, struct sbp2_logical_unit, work.work);
- -	struct sbp2_target *tgt = lu->tgt;
+	struct sbp2_logical_unit *lu, *next;
+	struct Scsi_Host *shost =
+		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+	struct scsi_device *sdev;
 	struct fw_device *device = target_device(tgt);
- -	int generation, node_id, local_node_id;
- -
- -	if (fw_device_is_shutdown(device))
- -		return;
 
- -	generation    = device->generation;
- -	smp_rmb();    /* node IDs must not be older than generation */
- -	node_id       = device->node_id;
- -	local_node_id = device->card->node_id;
+	/* prevent deadlocks */
+	sbp2_unblock(tgt);
 
- -	if (sbp2_send_management_orb(lu, node_id, generation,
- -				     SBP2_RECONNECT_REQUEST,
- -				     lu->login_id, NULL) < 0) {
- -		/*
- -		 * If reconnect was impossible even though we are in the
- -		 * current generation, fall back and try to log in again.
- -		 *
- -		 * We could check for "Function rejected" status, but
- -		 * looking at the bus generation as simpler and more general.
- -		 */
- -		smp_rmb(); /* get current card generation */
- -		if (generation == device->card->generation ||
- -		    lu->retries++ >= 5) {
- -			fw_error("%s: failed to reconnect\n", tgt->bus_id);
- -			lu->retries = 0;
- -			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
+		sdev = scsi_device_lookup(shost, 0, 0, sbp2_lun2int(lu->lun));
+		if (sdev) {
+			scsi_remove_device(sdev);
+			scsi_device_put(sdev);
 		}
- -		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
- -
- -		return;
+		if (lu->login_id != INVALID_LOGIN_ID) {
+			int generation, node_id;
+			/*
+			 * tgt->node_id may be obsolete here if we failed
+			 * during initial login or after a bus reset where
+			 * the topology changed.
+			 */
+			generation = device->generation;
+			smp_rmb(); /* node_id vs. generation */
+			node_id    = device->node_id;
+			sbp2_send_management_orb(lu, node_id, generation,
+						 SBP2_LOGOUT_REQUEST,
+						 lu->login_id, NULL);
+		}
+		fw_core_remove_address_handler(&lu->address_handler);
+		list_del(&lu->link);
+		kfree(lu);
 	}
+	scsi_remove_host(shost);
+	fw_notify("released %s, target %d:0:0\n", tgt->bus_id, shost->host_no);
 
- -	tgt->node_id      = node_id;
- -	tgt->address_high = local_node_id << 16;
- -	smp_wmb();	  /* node IDs must not be older than generation */
- -	lu->generation	  = generation;
- -
- -	fw_notify("%s: reconnected to LUN %04x (%d retries)\n",
- -		  tgt->bus_id, lu->lun, lu->retries);
- -
- -	sbp2_agent_reset(lu);
- -	sbp2_cancel_orbs(lu);
- -	sbp2_conditionally_unblock(lu);
+	scsi_host_put(shost);
 }
 
- -static void sbp2_update(struct fw_unit *unit)
+static int sbp2_remove(struct device *dev)
 {
+	struct fw_unit *unit = fw_unit(dev);
 	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
 	struct sbp2_logical_unit *lu;
 
- -	fw_device_enable_phys_dma(fw_parent_device(unit));
+	list_for_each_entry(lu, &tgt->lu_list, link)
+		cancel_delayed_work_sync(&lu->work);
 
- -	/*
- -	 * Fw-core serializes sbp2_update() against sbp2_remove().
- -	 * Iteration over tgt->lu_list is therefore safe here.
- -	 */
- -	list_for_each_entry(lu, &tgt->lu_list, link) {
- -		sbp2_conditionally_block(lu);
- -		lu->retries = 0;
- -		sbp2_queue_work(lu, 0);
- -	}
+	sbp2_release_target(tgt);
+
+	return 0;
 }
 
 #define SBP2_UNIT_SPEC_ID_ENTRY	0x0000609e

commit 6ff8147d075da2e1eb69fab2ee75104c59f573e0
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Aug 27 15:33:34 2011 +0200

    firewire: sbp2: remove obsolete reference counting
    
    Since commit 0278ccd9d53e07c4e699432b2fed9de6c56f506c "firewire: sbp2:
    fix panic after rmmod with slow targets", the lifetime of an sbp2_target
    instance does no longer extent past the return of sbp2_remove().
    Therefore it is no longer necessary to call fw_unit_get/put() and
    fw_device_get/put() in sbp2_probe/remove().
    
    Furthermore, said commit also ensures that lu->work is not going to be
    executed or requeued at a time when the sbp2_target is no longer in use.
    Hence there is no need for sbp2_target reference counting for lu->work.
    
    Other concurrent contexts:
    
      - Processes which access the sysfs of the SCSI host device or of one
        of its subdevices are safe because these interfaces are all removed
        by scsi_remove_device/host() in sbp2_release_target().
    
      - SBP-2 command block ORB transactions are finished when
        scsi_remove_device() in sbp2_release_target() returns.
    
      - SBP-2 management ORB transactions are finished when
        cancel_delayed_work_sync(&lu->work) before sbp2_release_target()
        returns.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 17cef86..a2715b2 100644
- --- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -159,7 +159,6 @@ struct sbp2_logical_unit {
  * and one struct Scsi_Host per sbp2_target.
  */
 struct sbp2_target {
- -	struct kref kref;
 	struct fw_unit *unit;
 	const char *bus_id;
 	struct list_head lu_list;
@@ -772,9 +771,8 @@ static int sbp2_lun2int(u16 lun)
 	return scsilun_to_int(&eight_bytes_lun);
 }
 
- -static void sbp2_release_target(struct kref *kref)
+static void sbp2_release_target(struct sbp2_target *tgt)
 {
- -	struct sbp2_target *tgt = container_of(kref, struct sbp2_target, kref);
 	struct sbp2_logical_unit *lu, *next;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
@@ -811,30 +809,12 @@ static void sbp2_release_target(struct kref *kref)
 	scsi_remove_host(shost);
 	fw_notify("released %s, target %d:0:0\n", tgt->bus_id, shost->host_no);
 
- -	fw_unit_put(tgt->unit);
 	scsi_host_put(shost);
- -	fw_device_put(device);
- -}
- -
- -static void sbp2_target_get(struct sbp2_target *tgt)
- -{
- -	kref_get(&tgt->kref);
- -}
- -
- -static void sbp2_target_put(struct sbp2_target *tgt)
- -{
- -	kref_put(&tgt->kref, sbp2_release_target);
 }
 
- -/*
- - * Always get the target's kref when scheduling work on one its units.
- - * Each workqueue job is responsible to call sbp2_target_put() upon return.
- - */
 static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
 {
- -	sbp2_target_get(lu->tgt);
- -	if (!queue_delayed_work(fw_workqueue, &lu->work, delay))
- -		sbp2_target_put(lu->tgt);
+	queue_delayed_work(fw_workqueue, &lu->work, delay);
 }
 
 /*
@@ -877,7 +857,7 @@ static void sbp2_login(struct work_struct *work)
 	int generation, node_id, local_node_id;
 
 	if (fw_device_is_shutdown(device))
- -		goto out;
+		return;
 
 	generation    = device->generation;
 	smp_rmb();    /* node IDs must not be older than generation */
@@ -899,7 +879,7 @@ static void sbp2_login(struct work_struct *work)
 			/* Let any waiting I/O fail from now on. */
 			sbp2_unblock(lu->tgt);
 		}
- -		goto out;
+		return;
 	}
 
 	tgt->node_id	  = node_id;
@@ -925,7 +905,8 @@ static void sbp2_login(struct work_struct *work)
 	if (lu->has_sdev) {
 		sbp2_cancel_orbs(lu);
 		sbp2_conditionally_unblock(lu);
- -		goto out;
+
+		return;
 	}
 
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_DELAY_INQUIRY)
@@ -957,7 +938,8 @@ static void sbp2_login(struct work_struct *work)
 	lu->has_sdev = true;
 	scsi_device_put(sdev);
 	sbp2_allow_block(lu);
- -	goto out;
+
+	return;
 
  out_logout_login:
 	smp_rmb(); /* generation may have changed */
@@ -971,8 +953,6 @@ static void sbp2_login(struct work_struct *work)
 	 * lu->work already.  Reset the work from reconnect to login.
 	 */
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
- - out:
- -	sbp2_target_put(tgt);
 }
 
 static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
@@ -1141,7 +1121,6 @@ static int sbp2_probe(struct device *dev)
 	tgt = (struct sbp2_target *)shost->hostdata;
 	dev_set_drvdata(&unit->device, tgt);
 	tgt->unit = unit;
- -	kref_init(&tgt->kref);
 	INIT_LIST_HEAD(&tgt->lu_list);
 	tgt->bus_id = dev_name(&unit->device);
 	tgt->guid = (u64)device->config_rom[3] << 32 | device->config_rom[4];
@@ -1154,9 +1133,6 @@ static int sbp2_probe(struct device *dev)
 	if (scsi_add_host(shost, &unit->device) < 0)
 		goto fail_shost_put;
 
- -	fw_device_get(device);
- -	fw_unit_get(unit);
- -
 	/* implicit directory ID */
 	tgt->directory_id = ((unit->directory - device->config_rom) * 4
 			     + CSR_CONFIG_ROM) & 0xffffff;
@@ -1166,7 +1142,7 @@ static int sbp2_probe(struct device *dev)
 
 	if (sbp2_scan_unit_dir(tgt, unit->directory, &model,
 			       &firmware_revision) < 0)
- -		goto fail_tgt_put;
+		goto fail_release_target;
 
 	sbp2_clamp_management_orb_timeout(tgt);
 	sbp2_init_workarounds(tgt, model, firmware_revision);
@@ -1183,10 +1159,11 @@ static int sbp2_probe(struct device *dev)
 	/* Do the login in a workqueue so we can easily reschedule retries. */
 	list_for_each_entry(lu, &tgt->lu_list, link)
 		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
+
 	return 0;
 
- - fail_tgt_put:
- -	sbp2_target_put(tgt);
+ fail_release_target:
+	sbp2_release_target(tgt);
 	return -ENOMEM;
 
  fail_shost_put:
@@ -1203,7 +1180,8 @@ static int sbp2_remove(struct device *dev)
 	list_for_each_entry(lu, &tgt->lu_list, link)
 		cancel_delayed_work_sync(&lu->work);
 
- -	sbp2_target_put(tgt);
+	sbp2_release_target(tgt);
+
 	return 0;
 }
 
@@ -1216,7 +1194,7 @@ static void sbp2_reconnect(struct work_struct *work)
 	int generation, node_id, local_node_id;
 
 	if (fw_device_is_shutdown(device))
- -		goto out;
+		return;
 
 	generation    = device->generation;
 	smp_rmb();    /* node IDs must not be older than generation */
@@ -1241,7 +1219,8 @@ static void sbp2_reconnect(struct work_struct *work)
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}
 		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
- -		goto out;
+
+		return;
 	}
 
 	tgt->node_id      = node_id;
@@ -1255,8 +1234,6 @@ static void sbp2_reconnect(struct work_struct *work)
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
 	sbp2_conditionally_unblock(lu);
- - out:
- -	sbp2_target_put(tgt);
 }
 
 static void sbp2_update(struct fw_unit *unit)


- -- 
Stefan Richter
- -=====-==-== =-=- =====
http://arcgraph.de/sr/
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJOrty8AAoJEHnzb7JUXXnQECMP/2+h8RGRPQP2d4zgAWQJ6lix
kbUs8gyZVh7k6w3mLct5Tb1Hbwi7Fy/ARorRFgoMiduRdi4gaxkN22H7OH0E6RPY
i4dbBUBIZouPMtu4+qvgpbdDw6kp56xdMQLwhpy0QobzFTrE9qbxnMjOUuKZzDAw
+6l/Mshx9VwskEypSeSG5SLGd1kS5AtPeKYX3eGZ+7TkfNiLmk3KH3vsL46NEKy1
3dSXeyMPAhBhfg4PtD6oRYIOwQBbB5/3y8JmINSEuOTmwulvx6HC/YnkSpodyG1d
NZe746m3yCEEU8L3/ALdsYkOdHdPaQSRQbMk4bJmKRkf5kIfaX2KW3mWajY+FjS/
4ucBBuwItYOVFQSasX4E8Oeimd8CzbREU+iuDUZ3T+iiVRIbSJXoDXgyQdbCdCb2
XAV4gOHhHbEKOmNLzoqPPIo5h0YMWbQNvIEx23HeTA5xV2BFB67/kF8RjCJFsrvK
8kWBAz4AXfHS6+Su7o6iX/CZvUJP2DEC8qTIVTYriz5ym96zA4+cLU8ZzjX/Vcia
ug9yVBzNn0VijH1w1E8msLiae5QlAbF9Ls5KLY9XlLkTOmgHQQR73eYvZqZXdZti
aCErVdSw37GIRUgSLDQuAAfpayspZT80ILuScmNreWL/opfzJ3kfoerzBEutlS9N
1nQaTkYeanlqLUYFxsrp
=UNzK
-----END PGP SIGNATURE-----
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
