Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0LJU2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:28:08 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:56057
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752853Ab0LJU2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:28:06 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 5/7] staging: hv: Convert camel cased struct fields in netvsc_api.h to lower cases
Date: Fri, 10 Dec 2010 12:03:58 -0800
Message-Id: <1292011440-21174-5-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1292011440-21174-4-git-send-email-haiyangz@microsoft.com>
References: <1292011440-21174-1-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-2-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-3-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-4-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c       |  104 +++++++++++++++++-----------------
 drivers/staging/hv/netvsc_api.h   |   58 ++++++++++----------
 drivers/staging/hv/netvsc_drv.c   |   74 ++++++++++++------------
 drivers/staging/hv/rndis_filter.c |  112 ++++++++++++++++++------------------
 4 files changed, 174 insertions(+), 174 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 5c327fc..d678bf5 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -196,11 +196,11 @@ int netvsc_initialize(struct hv_driver *drv)
 	/* ASSERT(driver->OnLinkStatusChanged); */
 
 	/* Setup the dispatch table */
-	driver->Base.OnDeviceAdd	= netvsc_device_add;
-	driver->Base.OnDeviceRemove	= netvsc_device_remove;
-	driver->Base.OnCleanup		= netvsc_cleanup;
+	driver->base.OnDeviceAdd	= netvsc_device_add;
+	driver->base.OnDeviceRemove	= netvsc_device_remove;
+	driver->base.OnCleanup		= netvsc_cleanup;
 
-	driver->OnSend			= netvsc_send;
+	driver->send			= netvsc_send;
 
 	rndis_filter_init(driver);
 	return 0;
@@ -736,7 +736,7 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 				   NETVSC_RECEIVE_PACKETLIST_COUNT, i);
 			break;
 		}
-		list_add_tail(&packet->ListEntry,
+		list_add_tail(&packet->list_ent,
 			      &net_device->ReceivePacketList);
 	}
 	net_device->ChannelInitEvent = osd_waitevent_create();
@@ -746,8 +746,8 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 	}
 
 	/* Open the channel */
-	ret = vmbus_open(device->channel, net_driver->RingBufferSize,
-			 net_driver->RingBufferSize, NULL, 0,
+	ret = vmbus_open(device->channel, net_driver->ring_buf_size,
+			 net_driver->ring_buf_size, NULL, 0,
 			 netvsc_channel_cb, device);
 
 	if (ret != 0) {
@@ -783,8 +783,8 @@ Cleanup:
 
 		list_for_each_entry_safe(packet, pos,
 					 &net_device->ReceivePacketList,
-					 ListEntry) {
-			list_del(&packet->ListEntry);
+					 list_ent) {
+			list_del(&packet->list_ent);
 			kfree(packet);
 		}
 
@@ -840,8 +840,8 @@ static int netvsc_device_remove(struct hv_device *device)
 
 	/* Release all resources */
 	list_for_each_entry_safe(netvsc_packet, pos,
-				 &net_device->ReceivePacketList, ListEntry) {
-		list_del(&netvsc_packet->ListEntry);
+				 &net_device->ReceivePacketList, list_ent) {
+		list_del(&netvsc_packet->list_ent);
 		kfree(netvsc_packet);
 	}
 
@@ -894,8 +894,8 @@ static void netvsc_send_completion(struct hv_device *device,
 		/* ASSERT(nvscPacket); */
 
 		/* Notify the layer above us */
-		nvsc_packet->Completion.Send.OnSendCompletion(
-			nvsc_packet->Completion.Send.SendCompletionContext);
+		nvsc_packet->completion.send.send_completion(
+			nvsc_packet->completion.send.send_completion_ctx);
 
 		atomic_dec(&net_device->NumOutstandingSends);
 	} else {
@@ -922,7 +922,7 @@ static int netvsc_send(struct hv_device *device,
 	}
 
 	sendMessage.Header.MessageType = NvspMessage1TypeSendRNDISPacket;
-	if (packet->IsDataPacket) {
+	if (packet->is_data_pkt) {
 		/* 0 is RMC_DATA; */
 		sendMessage.Messages.Version1Messages.SendRNDISPacket.ChannelType = 0;
 	} else {
@@ -934,10 +934,10 @@ static int netvsc_send(struct hv_device *device,
 	sendMessage.Messages.Version1Messages.SendRNDISPacket.SendBufferSectionIndex = 0xFFFFFFFF;
 	sendMessage.Messages.Version1Messages.SendRNDISPacket.SendBufferSectionSize = 0;
 
-	if (packet->PageBufferCount) {
+	if (packet->page_buf_cnt) {
 		ret = vmbus_sendpacket_pagebuffer(device->channel,
-						  packet->PageBuffers,
-						  packet->PageBufferCount,
+						  packet->page_buf,
+						  packet->page_buf_cnt,
 						  &sendMessage,
 						  sizeof(struct nvsp_message),
 						  (unsigned long)packet);
@@ -1063,82 +1063,82 @@ static void netvsc_receive(struct hv_device *device,
 
 	/* Remove the 1st packet to represent the xfer page packet itself */
 	xferpage_packet = (struct xferpage_packet *)listHead.next;
-	list_del(&xferpage_packet->ListEntry);
+	list_del(&xferpage_packet->list_ent);
 
 	/* This is how much we can satisfy */
-	xferpage_packet->Count = count - 1;
+	xferpage_packet->count = count - 1;
 	/* ASSERT(xferpagePacket->Count > 0 && xferpagePacket->Count <= */
 	/* 	vmxferpagePacket->RangeCount); */
 
-	if (xferpage_packet->Count != vmxferpage_packet->RangeCount) {
+	if (xferpage_packet->count != vmxferpage_packet->RangeCount) {
 		DPRINT_INFO(NETVSC, "Needed %d netvsc pkts to satisy this xfer "
 			    "page...got %d", vmxferpage_packet->RangeCount,
-			    xferpage_packet->Count);
+			    xferpage_packet->count);
 	}
 
 	/* Each range represents 1 RNDIS pkt that contains 1 ethernet frame */
 	for (i = 0; i < (count - 1); i++) {
 		netvsc_packet = (struct hv_netvsc_packet *)listHead.next;
-		list_del(&netvsc_packet->ListEntry);
+		list_del(&netvsc_packet->list_ent);
 
 		/* Initialize the netvsc packet */
-		netvsc_packet->XferPagePacket = xferpage_packet;
-		netvsc_packet->Completion.Recv.OnReceiveCompletion =
+		netvsc_packet->xfer_page_pkt = xferpage_packet;
+		netvsc_packet->completion.recv.recv_completion =
 					netvsc_receive_completion;
-		netvsc_packet->Completion.Recv.ReceiveCompletionContext =
+		netvsc_packet->completion.recv.recv_completion_ctx =
 					netvsc_packet;
-		netvsc_packet->Device = device;
+		netvsc_packet->device = device;
 		/* Save this so that we can send it back */
-		netvsc_packet->Completion.Recv.ReceiveCompletionTid =
+		netvsc_packet->completion.recv.recv_completion_tid =
 					vmxferpage_packet->d.TransactionId;
 
-		netvsc_packet->TotalDataBufferLength =
+		netvsc_packet->total_data_buflen =
 					vmxferpage_packet->Ranges[i].ByteCount;
-		netvsc_packet->PageBufferCount = 1;
+		netvsc_packet->page_buf_cnt = 1;
 
 		/* ASSERT(vmxferpagePacket->Ranges[i].ByteOffset + */
 		/* 	vmxferpagePacket->Ranges[i].ByteCount < */
 		/* 	netDevice->ReceiveBufferSize); */
 
-		netvsc_packet->PageBuffers[0].Length =
+		netvsc_packet->page_buf[0].Length =
 					vmxferpage_packet->Ranges[i].ByteCount;
 
 		start = virt_to_phys((void *)((unsigned long)net_device->
 		ReceiveBuffer + vmxferpage_packet->Ranges[i].ByteOffset));
 
-		netvsc_packet->PageBuffers[0].Pfn = start >> PAGE_SHIFT;
+		netvsc_packet->page_buf[0].Pfn = start >> PAGE_SHIFT;
 		end_virtual = (unsigned long)net_device->ReceiveBuffer
 		    + vmxferpage_packet->Ranges[i].ByteOffset
 		    + vmxferpage_packet->Ranges[i].ByteCount - 1;
 		end = virt_to_phys((void *)end_virtual);
 
 		/* Calculate the page relative offset */
-		netvsc_packet->PageBuffers[0].Offset =
+		netvsc_packet->page_buf[0].Offset =
 			vmxferpage_packet->Ranges[i].ByteOffset &
 			(PAGE_SIZE - 1);
 		if ((end >> PAGE_SHIFT) != (start >> PAGE_SHIFT)) {
 			/* Handle frame across multiple pages: */
-			netvsc_packet->PageBuffers[0].Length =
-				(netvsc_packet->PageBuffers[0].Pfn <<
+			netvsc_packet->page_buf[0].Length =
+				(netvsc_packet->page_buf[0].Pfn <<
 				 PAGE_SHIFT)
 				+ PAGE_SIZE - start;
-			bytes_remain = netvsc_packet->TotalDataBufferLength -
-					netvsc_packet->PageBuffers[0].Length;
+			bytes_remain = netvsc_packet->total_data_buflen -
+					netvsc_packet->page_buf[0].Length;
 			for (j = 1; j < NETVSC_PACKET_MAXPAGE; j++) {
-				netvsc_packet->PageBuffers[j].Offset = 0;
+				netvsc_packet->page_buf[j].Offset = 0;
 				if (bytes_remain <= PAGE_SIZE) {
-					netvsc_packet->PageBuffers[j].Length =
+					netvsc_packet->page_buf[j].Length =
 						bytes_remain;
 					bytes_remain = 0;
 				} else {
-					netvsc_packet->PageBuffers[j].Length =
+					netvsc_packet->page_buf[j].Length =
 						PAGE_SIZE;
 					bytes_remain -= PAGE_SIZE;
 				}
-				netvsc_packet->PageBuffers[j].Pfn =
+				netvsc_packet->page_buf[j].Pfn =
 				    virt_to_phys((void *)(end_virtual -
 						bytes_remain)) >> PAGE_SHIFT;
-				netvsc_packet->PageBufferCount++;
+				netvsc_packet->page_buf_cnt++;
 				if (bytes_remain == 0)
 					break;
 			}
@@ -1148,16 +1148,16 @@ static void netvsc_receive(struct hv_device *device,
 			   "(pfn %llx, offset %u, len %u)", i,
 			   vmxferpage_packet->Ranges[i].ByteOffset,
 			   vmxferpage_packet->Ranges[i].ByteCount,
-			   netvsc_packet->PageBuffers[0].Pfn,
-			   netvsc_packet->PageBuffers[0].Offset,
-			   netvsc_packet->PageBuffers[0].Length);
+			   netvsc_packet->page_buf[0].Pfn,
+			   netvsc_packet->page_buf[0].Offset,
+			   netvsc_packet->page_buf[0].Length);
 
 		/* Pass it to the upper layer */
 		((struct netvsc_driver *)device->Driver)->
-			OnReceiveCallback(device, netvsc_packet);
+			recv_cb(device, netvsc_packet);
 
 		netvsc_receive_completion(netvsc_packet->
-				Completion.Recv.ReceiveCompletionContext);
+				completion.recv.recv_completion_ctx);
 	}
 
 	/* ASSERT(list_empty(&listHead)); */
@@ -1213,7 +1213,7 @@ retry_send_cmplt:
 static void netvsc_receive_completion(void *context)
 {
 	struct hv_netvsc_packet *packet = context;
-	struct hv_device *device = (struct hv_device *)packet->Device;
+	struct hv_device *device = (struct hv_device *)packet->device;
 	struct netvsc_device *net_device;
 	u64 transaction_id = 0;
 	bool fsend_receive_comp = false;
@@ -1237,22 +1237,22 @@ static void netvsc_receive_completion(void *context)
 	spin_lock_irqsave(&net_device->receive_packet_list_lock, flags);
 
 	/* ASSERT(packet->XferPagePacket->Count > 0); */
-	packet->XferPagePacket->Count--;
+	packet->xfer_page_pkt->count--;
 
 	/*
 	 * Last one in the line that represent 1 xfer page packet.
 	 * Return the xfer page packet itself to the freelist
 	 */
-	if (packet->XferPagePacket->Count == 0) {
+	if (packet->xfer_page_pkt->count == 0) {
 		fsend_receive_comp = true;
-		transaction_id = packet->Completion.Recv.ReceiveCompletionTid;
-		list_add_tail(&packet->XferPagePacket->ListEntry,
+		transaction_id = packet->completion.recv.recv_completion_tid;
+		list_add_tail(&packet->xfer_page_pkt->list_ent,
 			      &net_device->ReceivePacketList);
 
 	}
 
 	/* Put the packet back */
-	list_add_tail(&packet->ListEntry, &net_device->ReceivePacketList);
+	list_add_tail(&packet->list_ent, &net_device->ReceivePacketList);
 	spin_unlock_irqrestore(&net_device->receive_packet_list_lock, flags);
 
 	/* Send a receive completion for the xfer page packet */
diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
index 315271d..ac40db5 100644
--- a/drivers/staging/hv/netvsc_api.h
+++ b/drivers/staging/hv/netvsc_api.h
@@ -32,10 +32,10 @@ struct hv_netvsc_packet;
 
 /* Represent the xfer page packet which contains 1 or more netvsc packet */
 struct xferpage_packet {
-	struct list_head ListEntry;
+	struct list_head list_ent;
 
 	/* # of netvsc packets this xfer packet contains */
-	u32 Count;
+	u32 count;
 };
 
 /* The number of pages which are enough to cover jumbo frame buffer. */
@@ -47,65 +47,65 @@ struct xferpage_packet {
  */
 struct hv_netvsc_packet {
 	/* Bookkeeping stuff */
-	struct list_head ListEntry;
+	struct list_head list_ent;
 
-	struct hv_device *Device;
-	bool IsDataPacket;
+	struct hv_device *device;
+	bool is_data_pkt;
 
 	/*
 	 * Valid only for receives when we break a xfer page packet
 	 * into multiple netvsc packets
 	 */
-	struct xferpage_packet *XferPagePacket;
+	struct xferpage_packet *xfer_page_pkt;
 
 	union {
 		struct{
-			u64 ReceiveCompletionTid;
-			void *ReceiveCompletionContext;
-			void (*OnReceiveCompletion)(void *context);
-		} Recv;
+			u64 recv_completion_tid;
+			void *recv_completion_ctx;
+			void (*recv_completion)(void *context);
+		} recv;
 		struct{
-			u64 SendCompletionTid;
-			void *SendCompletionContext;
-			void (*OnSendCompletion)(void *context);
-		} Send;
-	} Completion;
+			u64 send_completion_tid;
+			void *send_completion_ctx;
+			void (*send_completion)(void *context);
+		} send;
+	} completion;
 
-	/* This points to the memory after PageBuffers */
-	void *Extension;
+	/* This points to the memory after page_buf */
+	void *extension;
 
-	u32 TotalDataBufferLength;
+	u32 total_data_buflen;
 	/* Points to the send/receive buffer where the ethernet frame is */
-	u32 PageBufferCount;
-	struct hv_page_buffer PageBuffers[NETVSC_PACKET_MAXPAGE];
+	u32 page_buf_cnt;
+	struct hv_page_buffer page_buf[NETVSC_PACKET_MAXPAGE];
 };
 
 /* Represents the net vsc driver */
 struct netvsc_driver {
 	/* Must be the first field */
 	/* Which is a bug FIXME! */
-	struct hv_driver Base;
+	struct hv_driver base;
 
-	u32 RingBufferSize;
-	u32 RequestExtSize;
+	u32 ring_buf_size;
+	u32 req_ext_size;
 
 	/*
 	 * This is set by the caller to allow us to callback when we
 	 * receive a packet from the "wire"
 	 */
-	int (*OnReceiveCallback)(struct hv_device *dev,
+	int (*recv_cb)(struct hv_device *dev,
 				 struct hv_netvsc_packet *packet);
-	void (*OnLinkStatusChanged)(struct hv_device *dev, u32 Status);
+	void (*link_status_change)(struct hv_device *dev, u32 Status);
 
 	/* Specific to this driver */
-	int (*OnSend)(struct hv_device *dev, struct hv_netvsc_packet *packet);
+	int (*send)(struct hv_device *dev, struct hv_netvsc_packet *packet);
 
-	void *Context;
+	void *ctx;
 };
 
 struct netvsc_device_info {
-    unsigned char MacAddr[6];
-    bool LinkState;	/* 0 - link up, 1 - link down */
+	unsigned char mac_adr[6];
+	bool link_state;	/* 0 - link up, 1 - link down */
 };
 
 /* Interface */
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index e47681e..0147b40 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -115,7 +115,7 @@ static void netvsc_xmit_completion(void *context)
 {
 	struct hv_netvsc_packet *packet = (struct hv_netvsc_packet *)context;
 	struct sk_buff *skb = (struct sk_buff *)
-		(unsigned long)packet->Completion.Send.SendCompletionTid;
+		(unsigned long)packet->completion.send.send_completion_tid;
 
 	kfree(packet);
 
@@ -154,7 +154,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	/* Allocate a netvsc packet based on # of frags. */
 	packet = kzalloc(sizeof(struct hv_netvsc_packet) +
 			 (num_pages * sizeof(struct hv_page_buffer)) +
-			 net_drv_obj->RequestExtSize, GFP_ATOMIC);
+			 net_drv_obj->req_ext_size, GFP_ATOMIC);
 	if (!packet) {
 		/* out of memory, silently drop packet */
 		DPRINT_ERR(NETVSC_DRV, "unable to allocate hv_netvsc_packet");
@@ -164,40 +164,40 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 		return NETDEV_TX_OK;
 	}
 
-	packet->Extension = (void *)(unsigned long)packet +
+	packet->extension = (void *)(unsigned long)packet +
 				sizeof(struct hv_netvsc_packet) +
 				    (num_pages * sizeof(struct hv_page_buffer));
 
 	/* Setup the rndis header */
-	packet->PageBufferCount = num_pages;
+	packet->page_buf_cnt = num_pages;
 
 	/* TODO: Flush all write buffers/ memory fence ??? */
 	/* wmb(); */
 
 	/* Initialize it from the skb */
-	packet->TotalDataBufferLength	= skb->len;
+	packet->total_data_buflen	= skb->len;
 
 	/* Start filling in the page buffers starting after RNDIS buffer. */
-	packet->PageBuffers[1].Pfn = virt_to_phys(skb->data) >> PAGE_SHIFT;
-	packet->PageBuffers[1].Offset
+	packet->page_buf[1].Pfn = virt_to_phys(skb->data) >> PAGE_SHIFT;
+	packet->page_buf[1].Offset
 		= (unsigned long)skb->data & (PAGE_SIZE - 1);
-	packet->PageBuffers[1].Length = skb_headlen(skb);
+	packet->page_buf[1].Length = skb_headlen(skb);
 
 	/* Additional fragments are after SKB data */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 
-		packet->PageBuffers[i+2].Pfn = page_to_pfn(f->page);
-		packet->PageBuffers[i+2].Offset = f->page_offset;
-		packet->PageBuffers[i+2].Length = f->size;
+		packet->page_buf[i+2].Pfn = page_to_pfn(f->page);
+		packet->page_buf[i+2].Offset = f->page_offset;
+		packet->page_buf[i+2].Length = f->size;
 	}
 
 	/* Set the completion routine */
-	packet->Completion.Send.OnSendCompletion = netvsc_xmit_completion;
-	packet->Completion.Send.SendCompletionContext = packet;
-	packet->Completion.Send.SendCompletionTid = (unsigned long)skb;
+	packet->completion.send.send_completion = netvsc_xmit_completion;
+	packet->completion.send.send_completion_ctx = packet;
+	packet->completion.send.send_completion_tid = (unsigned long)skb;
 
-	ret = net_drv_obj->OnSend(&net_device_ctx->device_ctx->device_obj,
+	ret = net_drv_obj->send(&net_device_ctx->device_ctx->device_obj,
 				  packet);
 	if (ret == 0) {
 		net->stats.tx_bytes += skb->len;
@@ -263,7 +263,7 @@ static int netvsc_recv_callback(struct hv_device *device_obj,
 	}
 
 	/* Allocate a skb - TODO direct I/O to pages? */
-	skb = netdev_alloc_skb_ip_align(net, packet->TotalDataBufferLength);
+	skb = netdev_alloc_skb_ip_align(net, packet->total_data_buflen);
 	if (unlikely(!skb)) {
 		++net->stats.rx_dropped;
 		return 0;
@@ -276,17 +276,17 @@ static int netvsc_recv_callback(struct hv_device *device_obj,
 	 * Copy to skb. This copy is needed here since the memory pointed by
 	 * hv_netvsc_packet cannot be deallocated
 	 */
-	for (i = 0; i < packet->PageBufferCount; i++) {
-		data = kmap_atomic(pfn_to_page(packet->PageBuffers[i].Pfn),
+	for (i = 0; i < packet->page_buf_cnt; i++) {
+		data = kmap_atomic(pfn_to_page(packet->page_buf[i].Pfn),
 					       KM_IRQ1);
 		data = (void *)(unsigned long)data +
-				packet->PageBuffers[i].Offset;
+				packet->page_buf[i].Offset;
 
-		memcpy(skb_put(skb, packet->PageBuffers[i].Length), data,
-		       packet->PageBuffers[i].Length);
+		memcpy(skb_put(skb, packet->page_buf[i].Length), data,
+		       packet->page_buf[i].Length);
 
 		kunmap_atomic((void *)((unsigned long)data -
-				       packet->PageBuffers[i].Offset), KM_IRQ1);
+				       packet->page_buf[i].Offset), KM_IRQ1);
 	}
 
 	local_irq_restore(flags);
@@ -349,7 +349,7 @@ static int netvsc_probe(struct device *device)
 	struct netvsc_device_info device_info;
 	int ret;
 
-	if (!net_drv_obj->Base.OnDeviceAdd)
+	if (!net_drv_obj->base.OnDeviceAdd)
 		return -1;
 
 	net = alloc_etherdev(sizeof(struct net_device_context));
@@ -366,7 +366,7 @@ static int netvsc_probe(struct device *device)
 	dev_set_drvdata(device, net);
 
 	/* Notify the netvsc driver of the new device */
-	ret = net_drv_obj->Base.OnDeviceAdd(device_obj, &device_info);
+	ret = net_drv_obj->base.OnDeviceAdd(device_obj, &device_info);
 	if (ret != 0) {
 		free_netdev(net);
 		dev_set_drvdata(device, NULL);
@@ -385,10 +385,10 @@ static int netvsc_probe(struct device *device)
 	 * out of sync with the device's link status
 	 */
 	if (!netif_carrier_ok(net))
-		if (!device_info.LinkState)
+		if (!device_info.link_state)
 			netif_carrier_on(net);
 
-	memcpy(net->dev_addr, device_info.MacAddr, ETH_ALEN);
+	memcpy(net->dev_addr, device_info.mac_adr, ETH_ALEN);
 
 	net->netdev_ops = &device_ops;
 
@@ -401,7 +401,7 @@ static int netvsc_probe(struct device *device)
 	ret = register_netdev(net);
 	if (ret != 0) {
 		/* Remove the device and release the resource */
-		net_drv_obj->Base.OnDeviceRemove(device_obj);
+		net_drv_obj->base.OnDeviceRemove(device_obj);
 		free_netdev(net);
 	}
 
@@ -425,7 +425,7 @@ static int netvsc_remove(struct device *device)
 		return 0;
 	}
 
-	if (!net_drv_obj->Base.OnDeviceRemove)
+	if (!net_drv_obj->base.OnDeviceRemove)
 		return -1;
 
 	/* Stop outbound asap */
@@ -438,7 +438,7 @@ static int netvsc_remove(struct device *device)
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = net_drv_obj->Base.OnDeviceRemove(device_obj);
+	ret = net_drv_obj->base.OnDeviceRemove(device_obj);
 	if (ret != 0) {
 		/* TODO: */
 		DPRINT_ERR(NETVSC, "unable to remove vsc device (ret %d)", ret);
@@ -484,8 +484,8 @@ static void netvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	if (netvsc_drv_obj->Base.OnCleanup)
-		netvsc_drv_obj->Base.OnCleanup(&netvsc_drv_obj->Base);
+	if (netvsc_drv_obj->base.OnCleanup)
+		netvsc_drv_obj->base.OnCleanup(&netvsc_drv_obj->base);
 
 	vmbus_child_driver_unregister(drv_ctx);
 
@@ -498,15 +498,15 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	struct driver_context *drv_ctx = &g_netvsc_drv.drv_ctx;
 	int ret;
 
-	net_drv_obj->RingBufferSize = ring_size * PAGE_SIZE;
-	net_drv_obj->OnReceiveCallback = netvsc_recv_callback;
-	net_drv_obj->OnLinkStatusChanged = netvsc_linkstatus_callback;
+	net_drv_obj->ring_buf_size = ring_size * PAGE_SIZE;
+	net_drv_obj->recv_cb = netvsc_recv_callback;
+	net_drv_obj->link_status_change = netvsc_linkstatus_callback;
 
 	/* Callback to client driver to complete the initialization */
-	drv_init(&net_drv_obj->Base);
+	drv_init(&net_drv_obj->base);
 
-	drv_ctx->driver.name = net_drv_obj->Base.name;
-	memcpy(&drv_ctx->class_id, &net_drv_obj->Base.deviceType,
+	drv_ctx->driver.name = net_drv_obj->base.name;
+	memcpy(&drv_ctx->class_id, &net_drv_obj->base.deviceType,
 	       sizeof(struct hv_guid));
 
 	drv_ctx->probe = netvsc_probe;
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index e560f38..dffcc03 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -251,22 +251,22 @@ static int rndis_filter_send_request(struct rndis_device *dev,
 	/* Setup the packet to send it */
 	packet = &req->pkt;
 
-	packet->IsDataPacket = false;
-	packet->TotalDataBufferLength = req->request_msg.MessageLength;
-	packet->PageBufferCount = 1;
+	packet->is_data_pkt = false;
+	packet->total_data_buflen = req->request_msg.MessageLength;
+	packet->page_buf_cnt = 1;
 
-	packet->PageBuffers[0].Pfn = virt_to_phys(&req->request_msg) >>
+	packet->page_buf[0].Pfn = virt_to_phys(&req->request_msg) >>
 					PAGE_SHIFT;
-	packet->PageBuffers[0].Length = req->request_msg.MessageLength;
-	packet->PageBuffers[0].Offset =
+	packet->page_buf[0].Length = req->request_msg.MessageLength;
+	packet->page_buf[0].Offset =
 		(unsigned long)&req->request_msg & (PAGE_SIZE - 1);
 
-	packet->Completion.Send.SendCompletionContext = req;/* packet; */
-	packet->Completion.Send.OnSendCompletion =
+	packet->completion.send.send_completion_ctx = req;/* packet; */
+	packet->completion.send.send_completion =
 		rndis_filter_send_request_completion;
-	packet->Completion.Send.SendCompletionTid = (unsigned long)dev;
+	packet->completion.send.send_completion_tid = (unsigned long)dev;
 
-	ret = rndis_filter.inner_drv.OnSend(dev->net_dev->Device, packet);
+	ret = rndis_filter.inner_drv.send(dev->net_dev->Device, packet);
 	return ret;
 }
 
@@ -337,10 +337,10 @@ static void rndis_filter_receive_indicate_status(struct rndis_device *dev,
 			&resp->Message.IndicateStatus;
 
 	if (indicate->Status == RNDIS_STATUS_MEDIA_CONNECT) {
-		rndis_filter.inner_drv.OnLinkStatusChanged(
+		rndis_filter.inner_drv.link_status_change(
 			dev->net_dev->Device, 1);
 	} else if (indicate->Status == RNDIS_STATUS_MEDIA_DISCONNECT) {
-		rndis_filter.inner_drv.OnLinkStatusChanged(
+		rndis_filter.inner_drv.link_status_change(
 			dev->net_dev->Device, 0);
 	} else {
 		/*
@@ -370,13 +370,13 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 	/* Remove the rndis header and pass it back up the stack */
 	data_offset = RNDIS_HEADER_SIZE + rndis_pkt->DataOffset;
 
-	pkt->TotalDataBufferLength -= data_offset;
-	pkt->PageBuffers[0].Offset += data_offset;
-	pkt->PageBuffers[0].Length -= data_offset;
+	pkt->total_data_buflen -= data_offset;
+	pkt->page_buf[0].Offset += data_offset;
+	pkt->page_buf[0].Length -= data_offset;
 
-	pkt->IsDataPacket = true;
+	pkt->is_data_pkt = true;
 
-	rndis_filter.inner_drv.OnReceiveCallback(dev->net_dev->Device,
+	rndis_filter.inner_drv.recv_cb(dev->net_dev->Device,
 						   pkt);
 }
 
@@ -406,10 +406,10 @@ static int rndis_filter_receive(struct hv_device *dev,
 	}
 
 	rndis_hdr = (struct rndis_message *)kmap_atomic(
-			pfn_to_page(pkt->PageBuffers[0].Pfn), KM_IRQ0);
+			pfn_to_page(pkt->page_buf[0].Pfn), KM_IRQ0);
 
 	rndis_hdr = (void *)((unsigned long)rndis_hdr +
-			pkt->PageBuffers[0].Offset);
+			pkt->page_buf[0].Offset);
 
 	/* Make sure we got a valid rndis message */
 	/*
@@ -418,14 +418,14 @@ static int rndis_filter_receive(struct hv_device *dev,
 	 * range shows 52 bytes
 	 * */
 #if 0
-	if (pkt->TotalDataBufferLength != rndis_hdr->MessageLength) {
-		kunmap_atomic(rndis_hdr - pkt->PageBuffers[0].Offset,
+	if (pkt->total_data_buflen != rndis_hdr->MessageLength) {
+		kunmap_atomic(rndis_hdr - pkt->page_buf[0].Offset,
 			      KM_IRQ0);
 
 		DPRINT_ERR(NETVSC, "invalid rndis message? (expected %u "
 			   "bytes got %u)...dropping this message!",
 			   rndis_hdr->MessageLength,
-			   pkt->TotalDataBufferLength);
+			   pkt->total_data_buflen);
 		return -1;
 	}
 #endif
@@ -443,7 +443,7 @@ static int rndis_filter_receive(struct hv_device *dev,
 			sizeof(struct rndis_message) :
 			rndis_hdr->MessageLength);
 
-	kunmap_atomic(rndis_hdr - pkt->PageBuffers[0].Offset, KM_IRQ0);
+	kunmap_atomic(rndis_hdr - pkt->page_buf[0].Offset, KM_IRQ0);
 
 	dump_rndis_message(&rndis_msg);
 
@@ -610,7 +610,7 @@ int rndis_filter_init(struct netvsc_driver *drv)
 	DPRINT_DBG(NETVSC, "sizeof(struct rndis_filter_packet) == %zd",
 		   sizeof(struct rndis_filter_packet));
 
-	drv->RequestExtSize = sizeof(struct rndis_filter_packet);
+	drv->req_ext_size = sizeof(struct rndis_filter_packet);
 
 	/* Driver->Context = rndisDriver; */
 
@@ -622,25 +622,25 @@ int rndis_filter_init(struct netvsc_driver *drv)
 	rndisDriver->OnLinkStatusChanged = Driver->OnLinkStatusChanged;*/
 
 	/* Save the original dispatch handlers before we override it */
-	rndis_filter.inner_drv.Base.OnDeviceAdd = drv->Base.OnDeviceAdd;
-	rndis_filter.inner_drv.Base.OnDeviceRemove =
-					drv->Base.OnDeviceRemove;
-	rndis_filter.inner_drv.Base.OnCleanup = drv->Base.OnCleanup;
+	rndis_filter.inner_drv.base.OnDeviceAdd = drv->base.OnDeviceAdd;
+	rndis_filter.inner_drv.base.OnDeviceRemove =
+					drv->base.OnDeviceRemove;
+	rndis_filter.inner_drv.base.OnCleanup = drv->base.OnCleanup;
 
 	/* ASSERT(Driver->OnSend); */
 	/* ASSERT(Driver->OnReceiveCallback); */
-	rndis_filter.inner_drv.OnSend = drv->OnSend;
-	rndis_filter.inner_drv.OnReceiveCallback = drv->OnReceiveCallback;
-	rndis_filter.inner_drv.OnLinkStatusChanged =
-					drv->OnLinkStatusChanged;
+	rndis_filter.inner_drv.send = drv->send;
+	rndis_filter.inner_drv.recv_cb = drv->recv_cb;
+	rndis_filter.inner_drv.link_status_change =
+					drv->link_status_change;
 
 	/* Override */
-	drv->Base.OnDeviceAdd = rndis_filte_device_add;
-	drv->Base.OnDeviceRemove = rndis_filter_device_remove;
-	drv->Base.OnCleanup = rndis_filter_cleanup;
-	drv->OnSend = rndis_filter_send;
+	drv->base.OnDeviceAdd = rndis_filte_device_add;
+	drv->base.OnDeviceRemove = rndis_filter_device_remove;
+	drv->base.OnCleanup = rndis_filter_cleanup;
+	drv->send = rndis_filter_send;
 	/* Driver->QueryLinkStatus = RndisFilterQueryDeviceLinkStatus; */
-	drv->OnReceiveCallback = rndis_filter_receive;
+	drv->recv_cb = rndis_filter_receive;
 
 	return 0;
 }
@@ -770,7 +770,7 @@ static int rndis_filte_device_add(struct hv_device *dev,
 	 * NOTE! Once the channel is created, we may get a receive callback
 	 * (RndisFilterOnReceive()) before this call is completed
 	 */
-	ret = rndis_filter.inner_drv.Base.OnDeviceAdd(dev, additional_info);
+	ret = rndis_filter.inner_drv.base.OnDeviceAdd(dev, additional_info);
 	if (ret != 0) {
 		kfree(rndisDevice);
 		return ret;
@@ -805,13 +805,13 @@ static int rndis_filte_device_add(struct hv_device *dev,
 	DPRINT_INFO(NETVSC, "Device 0x%p mac addr %pM",
 		    rndisDevice, rndisDevice->hw_mac_adr);
 
-	memcpy(deviceInfo->MacAddr, rndisDevice->hw_mac_adr, ETH_ALEN);
+	memcpy(deviceInfo->mac_adr, rndisDevice->hw_mac_adr, ETH_ALEN);
 
 	rndis_filter_query_device_link_status(rndisDevice);
 
-	deviceInfo->LinkState = rndisDevice->link_stat;
+	deviceInfo->link_state = rndisDevice->link_stat;
 	DPRINT_INFO(NETVSC, "Device 0x%p link state %s", rndisDevice,
-		    ((deviceInfo->LinkState) ? ("down") : ("up")));
+		    ((deviceInfo->link_state) ? ("down") : ("up")));
 
 	return ret;
 }
@@ -828,7 +828,7 @@ static int rndis_filter_device_remove(struct hv_device *dev)
 	net_dev->Extension = NULL;
 
 	/* Pass control to inner driver to remove the device */
-	rndis_filter.inner_drv.Base.OnDeviceRemove(dev);
+	rndis_filter.inner_drv.base.OnDeviceRemove(dev);
 
 	return 0;
 }
@@ -867,7 +867,7 @@ static int rndis_filter_send(struct hv_device *dev,
 	u32 rndisMessageSize;
 
 	/* Add the rndis header */
-	filterPacket = (struct rndis_filter_packet *)pkt->Extension;
+	filterPacket = (struct rndis_filter_packet *)pkt->extension;
 	/* ASSERT(filterPacket); */
 
 	memset(filterPacket, 0, sizeof(struct rndis_filter_packet));
@@ -876,37 +876,37 @@ static int rndis_filter_send(struct hv_device *dev,
 	rndisMessageSize = RNDIS_MESSAGE_SIZE(struct rndis_packet);
 
 	rndisMessage->NdisMessageType = REMOTE_NDIS_PACKET_MSG;
-	rndisMessage->MessageLength = pkt->TotalDataBufferLength +
+	rndisMessage->MessageLength = pkt->total_data_buflen +
 				      rndisMessageSize;
 
 	rndisPacket = &rndisMessage->Message.Packet;
 	rndisPacket->DataOffset = sizeof(struct rndis_packet);
-	rndisPacket->DataLength = pkt->TotalDataBufferLength;
+	rndisPacket->DataLength = pkt->total_data_buflen;
 
-	pkt->IsDataPacket = true;
-	pkt->PageBuffers[0].Pfn = virt_to_phys(rndisMessage) >> PAGE_SHIFT;
-	pkt->PageBuffers[0].Offset =
+	pkt->is_data_pkt = true;
+	pkt->page_buf[0].Pfn = virt_to_phys(rndisMessage) >> PAGE_SHIFT;
+	pkt->page_buf[0].Offset =
 			(unsigned long)rndisMessage & (PAGE_SIZE-1);
-	pkt->PageBuffers[0].Length = rndisMessageSize;
+	pkt->page_buf[0].Length = rndisMessageSize;
 
 	/* Save the packet send completion and context */
-	filterPacket->completion = pkt->Completion.Send.OnSendCompletion;
+	filterPacket->completion = pkt->completion.send.send_completion;
 	filterPacket->completion_ctx =
-				pkt->Completion.Send.SendCompletionContext;
+				pkt->completion.send.send_completion_ctx;
 
 	/* Use ours */
-	pkt->Completion.Send.OnSendCompletion = rndis_filter_send_completion;
-	pkt->Completion.Send.SendCompletionContext = filterPacket;
+	pkt->completion.send.send_completion = rndis_filter_send_completion;
+	pkt->completion.send.send_completion_ctx = filterPacket;
 
-	ret = rndis_filter.inner_drv.OnSend(dev, pkt);
+	ret = rndis_filter.inner_drv.send(dev, pkt);
 	if (ret != 0) {
 		/*
 		 * Reset the completion to originals to allow retries from
 		 * above
 		 */
-		pkt->Completion.Send.OnSendCompletion =
+		pkt->completion.send.send_completion =
 				filterPacket->completion;
-		pkt->Completion.Send.SendCompletionContext =
+		pkt->completion.send.send_completion_ctx =
 				filterPacket->completion_ctx;
 	}
 
-- 
1.6.3.2

