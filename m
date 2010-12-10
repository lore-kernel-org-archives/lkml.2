Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0LJUAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:00:19 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:36969
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756884Ab0LJUAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:00:12 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 3/7] staging: hv: Convert camel cased variables in rndis_filter.c to lower cases
Date: Fri, 10 Dec 2010 12:03:56 -0800
Message-Id: <1292011440-21174-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1292011440-21174-2-git-send-email-haiyangz@microsoft.com>
References: <1292011440-21174-1-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-2-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |  582 +++++++++++++++++++------------------
 1 files changed, 296 insertions(+), 286 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index b85c825..28b7e7e 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -32,7 +32,7 @@
 /* Data types */
 struct rndis_filter_driver_object {
 	/* The original driver */
-	struct netvsc_driver InnerDriver;
+	struct netvsc_driver inner_drv;
 };
 
 enum rndis_device_state {
@@ -43,61 +43,61 @@ enum rndis_device_state {
 };
 
 struct rndis_device {
-	struct netvsc_device *NetDevice;
+	struct netvsc_device *net_dev;
 
-	enum rndis_device_state State;
-	u32 LinkStatus;
-	atomic_t NewRequestId;
+	enum rndis_device_state state;
+	u32 link_stat;
+	atomic_t new_req_id;
 
 	spinlock_t request_lock;
-	struct list_head RequestList;
+	struct list_head req_list;
 
-	unsigned char HwMacAddr[ETH_ALEN];
+	unsigned char hw_mac_adr[ETH_ALEN];
 };
 
 struct rndis_request {
-	struct list_head ListEntry;
-	struct osd_waitevent *WaitEvent;
+	struct list_head list_ent;
+	struct osd_waitevent *waitevent;
 
 	/*
 	 * FIXME: We assumed a fixed size response here. If we do ever need to
 	 * handle a bigger response, we can either define a max response
 	 * message or add a response buffer variable above this field
 	 */
-	struct rndis_message ResponseMessage;
+	struct rndis_message response_msg;
 
 	/* Simplify allocation by having a netvsc packet inline */
-	struct hv_netvsc_packet	Packet;
-	struct hv_page_buffer Buffer;
+	struct hv_netvsc_packet	pkt;
+	struct hv_page_buffer buf;
 	/* FIXME: We assumed a fixed size request here. */
-	struct rndis_message RequestMessage;
+	struct rndis_message request_msg;
 };
 
 
 struct rndis_filter_packet {
-	void *CompletionContext;
-	void (*OnCompletion)(void *context);
-	struct rndis_message Message;
+	void *completion_ctx;
+	void (*completion)(void *context);
+	struct rndis_message msg;
 };
 
 
-static int RndisFilterOnDeviceAdd(struct hv_device *Device,
-				  void *AdditionalInfo);
+static int RndisFilterOnDeviceAdd(struct hv_device *dev,
+				  void *additional_info);
 
-static int RndisFilterOnDeviceRemove(struct hv_device *Device);
+static int RndisFilterOnDeviceRemove(struct hv_device *dev);
 
-static void RndisFilterOnCleanup(struct hv_driver *Driver);
+static void RndisFilterOnCleanup(struct hv_driver *drv);
 
-static int RndisFilterOnSend(struct hv_device *Device,
-			     struct hv_netvsc_packet *Packet);
+static int RndisFilterOnSend(struct hv_device *dev,
+			     struct hv_netvsc_packet *pkt);
 
-static void RndisFilterOnSendCompletion(void *Context);
+static void RndisFilterOnSendCompletion(void *ctx);
 
-static void RndisFilterOnSendRequestCompletion(void *Context);
+static void RndisFilterOnSendRequestCompletion(void *ctx);
 
 
 /* The one and only */
-static struct rndis_filter_driver_object gRndisFilter;
+static struct rndis_filter_driver_object rndis_filter;
 
 static struct rndis_device *GetRndisDevice(void)
 {
@@ -109,19 +109,19 @@ static struct rndis_device *GetRndisDevice(void)
 
 	spin_lock_init(&device->request_lock);
 
-	INIT_LIST_HEAD(&device->RequestList);
+	INIT_LIST_HEAD(&device->req_list);
 
-	device->State = RNDIS_DEV_UNINITIALIZED;
+	device->state = RNDIS_DEV_UNINITIALIZED;
 
 	return device;
 }
 
-static struct rndis_request *GetRndisRequest(struct rndis_device *Device,
-					     u32 MessageType,
-					     u32 MessageLength)
+static struct rndis_request *GetRndisRequest(struct rndis_device *dev,
+					     u32 msg_type,
+					     u32 msg_len)
 {
 	struct rndis_request *request;
-	struct rndis_message *rndisMessage;
+	struct rndis_message *rndis_msg;
 	struct rndis_set_request *set;
 	unsigned long flags;
 
@@ -129,61 +129,61 @@ static struct rndis_request *GetRndisRequest(struct rndis_device *Device,
 	if (!request)
 		return NULL;
 
-	request->WaitEvent = osd_waitevent_create();
-	if (!request->WaitEvent) {
+	request->waitevent = osd_waitevent_create();
+	if (!request->waitevent) {
 		kfree(request);
 		return NULL;
 	}
 
-	rndisMessage = &request->RequestMessage;
-	rndisMessage->NdisMessageType = MessageType;
-	rndisMessage->MessageLength = MessageLength;
+	rndis_msg = &request->request_msg;
+	rndis_msg->NdisMessageType = msg_type;
+	rndis_msg->MessageLength = msg_len;
 
 	/*
 	 * Set the request id. This field is always after the rndis header for
 	 * request/response packet types so we just used the SetRequest as a
 	 * template
 	 */
-	set = &rndisMessage->Message.SetRequest;
-	set->RequestId = atomic_inc_return(&Device->NewRequestId);
+	set = &rndis_msg->Message.SetRequest;
+	set->RequestId = atomic_inc_return(&dev->new_req_id);
 
 	/* Add to the request list */
-	spin_lock_irqsave(&Device->request_lock, flags);
-	list_add_tail(&request->ListEntry, &Device->RequestList);
-	spin_unlock_irqrestore(&Device->request_lock, flags);
+	spin_lock_irqsave(&dev->request_lock, flags);
+	list_add_tail(&request->list_ent, &dev->req_list);
+	spin_unlock_irqrestore(&dev->request_lock, flags);
 
 	return request;
 }
 
-static void PutRndisRequest(struct rndis_device *Device,
-			    struct rndis_request *Request)
+static void PutRndisRequest(struct rndis_device *dev,
+			    struct rndis_request *req)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&Device->request_lock, flags);
-	list_del(&Request->ListEntry);
-	spin_unlock_irqrestore(&Device->request_lock, flags);
+	spin_lock_irqsave(&dev->request_lock, flags);
+	list_del(&req->list_ent);
+	spin_unlock_irqrestore(&dev->request_lock, flags);
 
-	kfree(Request->WaitEvent);
-	kfree(Request);
+	kfree(req->waitevent);
+	kfree(req);
 }
 
-static void DumpRndisMessage(struct rndis_message *RndisMessage)
+static void DumpRndisMessage(struct rndis_message *rndis_msg)
 {
-	switch (RndisMessage->NdisMessageType) {
+	switch (rndis_msg->NdisMessageType) {
 	case REMOTE_NDIS_PACKET_MSG:
 		DPRINT_DBG(NETVSC, "REMOTE_NDIS_PACKET_MSG (len %u, "
 			   "data offset %u data len %u, # oob %u, "
 			   "oob offset %u, oob len %u, pkt offset %u, "
 			   "pkt len %u",
-			   RndisMessage->MessageLength,
-			   RndisMessage->Message.Packet.DataOffset,
-			   RndisMessage->Message.Packet.DataLength,
-			   RndisMessage->Message.Packet.NumOOBDataElements,
-			   RndisMessage->Message.Packet.OOBDataOffset,
-			   RndisMessage->Message.Packet.OOBDataLength,
-			   RndisMessage->Message.Packet.PerPacketInfoOffset,
-			   RndisMessage->Message.Packet.PerPacketInfoLength);
+			   rndis_msg->MessageLength,
+			   rndis_msg->Message.Packet.DataOffset,
+			   rndis_msg->Message.Packet.DataLength,
+			   rndis_msg->Message.Packet.NumOOBDataElements,
+			   rndis_msg->Message.Packet.OOBDataOffset,
+			   rndis_msg->Message.Packet.OOBDataLength,
+			   rndis_msg->Message.Packet.PerPacketInfoOffset,
+			   rndis_msg->Message.Packet.PerPacketInfoLength);
 		break;
 
 	case REMOTE_NDIS_INITIALIZE_CMPLT:
@@ -191,147 +191,157 @@ static void DumpRndisMessage(struct rndis_message *RndisMessage)
 			"(len %u, id 0x%x, status 0x%x, major %d, minor %d, "
 			"device flags %d, max xfer size 0x%x, max pkts %u, "
 			"pkt aligned %u)",
-			RndisMessage->MessageLength,
-			RndisMessage->Message.InitializeComplete.RequestId,
-			RndisMessage->Message.InitializeComplete.Status,
-			RndisMessage->Message.InitializeComplete.MajorVersion,
-			RndisMessage->Message.InitializeComplete.MinorVersion,
-			RndisMessage->Message.InitializeComplete.DeviceFlags,
-			RndisMessage->Message.InitializeComplete.MaxTransferSize,
-			RndisMessage->Message.InitializeComplete.MaxPacketsPerMessage,
-			RndisMessage->Message.InitializeComplete.PacketAlignmentFactor);
+			rndis_msg->MessageLength,
+			rndis_msg->Message.InitializeComplete.RequestId,
+			rndis_msg->Message.InitializeComplete.Status,
+			rndis_msg->Message.InitializeComplete.MajorVersion,
+			rndis_msg->Message.InitializeComplete.MinorVersion,
+			rndis_msg->Message.InitializeComplete.DeviceFlags,
+			rndis_msg->Message.InitializeComplete.MaxTransferSize,
+			rndis_msg->Message.InitializeComplete.
+			   MaxPacketsPerMessage,
+			rndis_msg->Message.InitializeComplete.
+			   PacketAlignmentFactor);
 		break;
 
 	case REMOTE_NDIS_QUERY_CMPLT:
 		DPRINT_DBG(NETVSC, "REMOTE_NDIS_QUERY_CMPLT "
 			"(len %u, id 0x%x, status 0x%x, buf len %u, "
 			"buf offset %u)",
-			RndisMessage->MessageLength,
-			RndisMessage->Message.QueryComplete.RequestId,
-			RndisMessage->Message.QueryComplete.Status,
-			RndisMessage->Message.QueryComplete.InformationBufferLength,
-			RndisMessage->Message.QueryComplete.InformationBufferOffset);
+			rndis_msg->MessageLength,
+			rndis_msg->Message.QueryComplete.RequestId,
+			rndis_msg->Message.QueryComplete.Status,
+			rndis_msg->Message.QueryComplete.
+			   InformationBufferLength,
+			rndis_msg->Message.QueryComplete.
+			   InformationBufferOffset);
 		break;
 
 	case REMOTE_NDIS_SET_CMPLT:
 		DPRINT_DBG(NETVSC,
 			"REMOTE_NDIS_SET_CMPLT (len %u, id 0x%x, status 0x%x)",
-			RndisMessage->MessageLength,
-			RndisMessage->Message.SetComplete.RequestId,
-			RndisMessage->Message.SetComplete.Status);
+			rndis_msg->MessageLength,
+			rndis_msg->Message.SetComplete.RequestId,
+			rndis_msg->Message.SetComplete.Status);
 		break;
 
 	case REMOTE_NDIS_INDICATE_STATUS_MSG:
 		DPRINT_DBG(NETVSC, "REMOTE_NDIS_INDICATE_STATUS_MSG "
 			"(len %u, status 0x%x, buf len %u, buf offset %u)",
-			RndisMessage->MessageLength,
-			RndisMessage->Message.IndicateStatus.Status,
-			RndisMessage->Message.IndicateStatus.StatusBufferLength,
-			RndisMessage->Message.IndicateStatus.StatusBufferOffset);
+			rndis_msg->MessageLength,
+			rndis_msg->Message.IndicateStatus.Status,
+			rndis_msg->Message.IndicateStatus.StatusBufferLength,
+			rndis_msg->Message.IndicateStatus.StatusBufferOffset);
 		break;
 
 	default:
 		DPRINT_DBG(NETVSC, "0x%x (len %u)",
-			RndisMessage->NdisMessageType,
-			RndisMessage->MessageLength);
+			rndis_msg->NdisMessageType,
+			rndis_msg->MessageLength);
 		break;
 	}
 }
 
-static int RndisFilterSendRequest(struct rndis_device *Device,
-				  struct rndis_request *Request)
+static int RndisFilterSendRequest(struct rndis_device *dev,
+				  struct rndis_request *req)
 {
 	int ret;
 	struct hv_netvsc_packet *packet;
 
 	/* Setup the packet to send it */
-	packet = &Request->Packet;
+	packet = &req->pkt;
 
 	packet->IsDataPacket = false;
-	packet->TotalDataBufferLength = Request->RequestMessage.MessageLength;
+	packet->TotalDataBufferLength = req->request_msg.MessageLength;
 	packet->PageBufferCount = 1;
 
-	packet->PageBuffers[0].Pfn = virt_to_phys(&Request->RequestMessage) >>
+	packet->PageBuffers[0].Pfn = virt_to_phys(&req->request_msg) >>
 					PAGE_SHIFT;
-	packet->PageBuffers[0].Length = Request->RequestMessage.MessageLength;
+	packet->PageBuffers[0].Length = req->request_msg.MessageLength;
 	packet->PageBuffers[0].Offset =
-		(unsigned long)&Request->RequestMessage & (PAGE_SIZE - 1);
+		(unsigned long)&req->request_msg & (PAGE_SIZE - 1);
 
-	packet->Completion.Send.SendCompletionContext = Request;/* packet; */
+	packet->Completion.Send.SendCompletionContext = req;/* packet; */
 	packet->Completion.Send.OnSendCompletion =
 		RndisFilterOnSendRequestCompletion;
-	packet->Completion.Send.SendCompletionTid = (unsigned long)Device;
+	packet->Completion.Send.SendCompletionTid = (unsigned long)dev;
 
-	ret = gRndisFilter.InnerDriver.OnSend(Device->NetDevice->Device, packet);
+	ret = rndis_filter.inner_drv.OnSend(dev->net_dev->Device, packet);
 	return ret;
 }
 
-static void RndisFilterReceiveResponse(struct rndis_device *Device,
-				       struct rndis_message *Response)
+static void RndisFilterReceiveResponse(struct rndis_device *dev,
+				       struct rndis_message *resp)
 {
 	struct rndis_request *request = NULL;
 	bool found = false;
 	unsigned long flags;
 
-	spin_lock_irqsave(&Device->request_lock, flags);
-	list_for_each_entry(request, &Device->RequestList, ListEntry) {
+	spin_lock_irqsave(&dev->request_lock, flags);
+	list_for_each_entry(request, &dev->req_list, list_ent) {
 		/*
 		 * All request/response message contains RequestId as the 1st
 		 * field
 		 */
-		if (request->RequestMessage.Message.InitializeRequest.RequestId
-		    == Response->Message.InitializeComplete.RequestId) {
+		if (request->request_msg.Message.InitializeRequest.RequestId
+		    == resp->Message.InitializeComplete.RequestId) {
 			DPRINT_DBG(NETVSC, "found rndis request for "
 				"this response (id 0x%x req type 0x%x res "
 				"type 0x%x)",
-				request->RequestMessage.Message.InitializeRequest.RequestId,
-				request->RequestMessage.NdisMessageType,
-				Response->NdisMessageType);
+				request->request_msg.Message.
+				   InitializeRequest.RequestId,
+				request->request_msg.NdisMessageType,
+				resp->NdisMessageType);
 
 			found = true;
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&Device->request_lock, flags);
+	spin_unlock_irqrestore(&dev->request_lock, flags);
 
 	if (found) {
-		if (Response->MessageLength <= sizeof(struct rndis_message)) {
-			memcpy(&request->ResponseMessage, Response,
-			       Response->MessageLength);
+		if (resp->MessageLength <= sizeof(struct rndis_message)) {
+			memcpy(&request->response_msg, resp,
+			       resp->MessageLength);
 		} else {
 			DPRINT_ERR(NETVSC, "rndis response buffer overflow "
 				  "detected (size %u max %zu)",
-				  Response->MessageLength,
+				  resp->MessageLength,
 				  sizeof(struct rndis_filter_packet));
 
-			if (Response->NdisMessageType ==
+			if (resp->NdisMessageType ==
 			    REMOTE_NDIS_RESET_CMPLT) {
 				/* does not have a request id field */
-				request->ResponseMessage.Message.ResetComplete.Status = STATUS_BUFFER_OVERFLOW;
+				request->response_msg.Message.ResetComplete.
+					Status = STATUS_BUFFER_OVERFLOW;
 			} else {
-				request->ResponseMessage.Message.InitializeComplete.Status = STATUS_BUFFER_OVERFLOW;
+				request->response_msg.Message.
+				InitializeComplete.Status =
+					STATUS_BUFFER_OVERFLOW;
 			}
 		}
 
-		osd_waitevent_set(request->WaitEvent);
+		osd_waitevent_set(request->waitevent);
 	} else {
 		DPRINT_ERR(NETVSC, "no rndis request found for this response "
 			   "(id 0x%x res type 0x%x)",
-			   Response->Message.InitializeComplete.RequestId,
-			   Response->NdisMessageType);
+			   resp->Message.InitializeComplete.RequestId,
+			   resp->NdisMessageType);
 	}
 }
 
-static void RndisFilterReceiveIndicateStatus(struct rndis_device *Device,
-					     struct rndis_message *Response)
+static void RndisFilterReceiveIndicateStatus(struct rndis_device *dev,
+					     struct rndis_message *resp)
 {
 	struct rndis_indicate_status *indicate =
-			&Response->Message.IndicateStatus;
+			&resp->Message.IndicateStatus;
 
 	if (indicate->Status == RNDIS_STATUS_MEDIA_CONNECT) {
-		gRndisFilter.InnerDriver.OnLinkStatusChanged(Device->NetDevice->Device, 1);
+		rndis_filter.inner_drv.OnLinkStatusChanged(
+			dev->net_dev->Device, 1);
 	} else if (indicate->Status == RNDIS_STATUS_MEDIA_DISCONNECT) {
-		gRndisFilter.InnerDriver.OnLinkStatusChanged(Device->NetDevice->Device, 0);
+		rndis_filter.inner_drv.OnLinkStatusChanged(
+			dev->net_dev->Device, 0);
 	} else {
 		/*
 		 * TODO:
@@ -339,18 +349,18 @@ static void RndisFilterReceiveIndicateStatus(struct rndis_device *Device,
 	}
 }
 
-static void RndisFilterReceiveData(struct rndis_device *Device,
-				   struct rndis_message *Message,
-				   struct hv_netvsc_packet *Packet)
+static void RndisFilterReceiveData(struct rndis_device *dev,
+				   struct rndis_message *msg,
+				   struct hv_netvsc_packet *pkt)
 {
-	struct rndis_packet *rndisPacket;
-	u32 dataOffset;
+	struct rndis_packet *rndis_pkt;
+	u32 data_offset;
 
 	/* empty ethernet frame ?? */
 	/* ASSERT(Packet->PageBuffers[0].Length > */
 	/* 	RNDIS_MESSAGE_SIZE(struct rndis_packet)); */
 
-	rndisPacket = &Message->Message.Packet;
+	rndis_pkt = &msg->Message.Packet;
 
 	/*
 	 * FIXME: Handle multiple rndis pkt msgs that maybe enclosed in this
@@ -358,48 +368,48 @@ static void RndisFilterReceiveData(struct rndis_device *Device,
 	 */
 
 	/* Remove the rndis header and pass it back up the stack */
-	dataOffset = RNDIS_HEADER_SIZE + rndisPacket->DataOffset;
+	data_offset = RNDIS_HEADER_SIZE + rndis_pkt->DataOffset;
 
-	Packet->TotalDataBufferLength -= dataOffset;
-	Packet->PageBuffers[0].Offset += dataOffset;
-	Packet->PageBuffers[0].Length -= dataOffset;
+	pkt->TotalDataBufferLength -= data_offset;
+	pkt->PageBuffers[0].Offset += data_offset;
+	pkt->PageBuffers[0].Length -= data_offset;
 
-	Packet->IsDataPacket = true;
+	pkt->IsDataPacket = true;
 
-	gRndisFilter.InnerDriver.OnReceiveCallback(Device->NetDevice->Device,
-						   Packet);
+	rndis_filter.inner_drv.OnReceiveCallback(dev->net_dev->Device,
+						   pkt);
 }
 
-static int RndisFilterOnReceive(struct hv_device *Device,
-				struct hv_netvsc_packet	*Packet)
+static int RndisFilterOnReceive(struct hv_device *dev,
+				struct hv_netvsc_packet	*pkt)
 {
-	struct netvsc_device *netDevice = Device->Extension;
-	struct rndis_device *rndisDevice;
-	struct rndis_message rndisMessage;
-	struct rndis_message *rndisHeader;
+	struct netvsc_device *net_dev = dev->Extension;
+	struct rndis_device *rndis_dev;
+	struct rndis_message rndis_msg;
+	struct rndis_message *rndis_hdr;
 
-	if (!netDevice)
+	if (!net_dev)
 		return -EINVAL;
 
 	/* Make sure the rndis device state is initialized */
-	if (!netDevice->Extension) {
+	if (!net_dev->Extension) {
 		DPRINT_ERR(NETVSC, "got rndis message but no rndis device..."
 			  "dropping this message!");
 		return -1;
 	}
 
-	rndisDevice = (struct rndis_device *)netDevice->Extension;
-	if (rndisDevice->State == RNDIS_DEV_UNINITIALIZED) {
+	rndis_dev = (struct rndis_device *)net_dev->Extension;
+	if (rndis_dev->state == RNDIS_DEV_UNINITIALIZED) {
 		DPRINT_ERR(NETVSC, "got rndis message but rndis device "
 			   "uninitialized...dropping this message!");
 		return -1;
 	}
 
-	rndisHeader = (struct rndis_message *)kmap_atomic(
-			pfn_to_page(Packet->PageBuffers[0].Pfn), KM_IRQ0);
+	rndis_hdr = (struct rndis_message *)kmap_atomic(
+			pfn_to_page(pkt->PageBuffers[0].Pfn), KM_IRQ0);
 
-	rndisHeader = (void *)((unsigned long)rndisHeader +
-			Packet->PageBuffers[0].Offset);
+	rndis_hdr = (void *)((unsigned long)rndis_hdr +
+			pkt->PageBuffers[0].Offset);
 
 	/* Make sure we got a valid rndis message */
 	/*
@@ -408,39 +418,39 @@ static int RndisFilterOnReceive(struct hv_device *Device,
 	 * range shows 52 bytes
 	 * */
 #if 0
-	if (Packet->TotalDataBufferLength != rndisHeader->MessageLength) {
-		kunmap_atomic(rndisHeader - Packet->PageBuffers[0].Offset,
+	if (pkt->TotalDataBufferLength != rndis_hdr->MessageLength) {
+		kunmap_atomic(rndis_hdr - pkt->PageBuffers[0].Offset,
 			      KM_IRQ0);
 
 		DPRINT_ERR(NETVSC, "invalid rndis message? (expected %u "
 			   "bytes got %u)...dropping this message!",
-			   rndisHeader->MessageLength,
-			   Packet->TotalDataBufferLength);
+			   rndis_hdr->MessageLength,
+			   pkt->TotalDataBufferLength);
 		return -1;
 	}
 #endif
 
-	if ((rndisHeader->NdisMessageType != REMOTE_NDIS_PACKET_MSG) &&
-	    (rndisHeader->MessageLength > sizeof(struct rndis_message))) {
+	if ((rndis_hdr->NdisMessageType != REMOTE_NDIS_PACKET_MSG) &&
+	    (rndis_hdr->MessageLength > sizeof(struct rndis_message))) {
 		DPRINT_ERR(NETVSC, "incoming rndis message buffer overflow "
 			   "detected (got %u, max %zu)...marking it an error!",
-			   rndisHeader->MessageLength,
+			   rndis_hdr->MessageLength,
 			   sizeof(struct rndis_message));
 	}
 
-	memcpy(&rndisMessage, rndisHeader,
-		(rndisHeader->MessageLength > sizeof(struct rndis_message)) ?
+	memcpy(&rndis_msg, rndis_hdr,
+		(rndis_hdr->MessageLength > sizeof(struct rndis_message)) ?
 			sizeof(struct rndis_message) :
-			rndisHeader->MessageLength);
+			rndis_hdr->MessageLength);
 
-	kunmap_atomic(rndisHeader - Packet->PageBuffers[0].Offset, KM_IRQ0);
+	kunmap_atomic(rndis_hdr - pkt->PageBuffers[0].Offset, KM_IRQ0);
 
-	DumpRndisMessage(&rndisMessage);
+	DumpRndisMessage(&rndis_msg);
 
-	switch (rndisMessage.NdisMessageType) {
+	switch (rndis_msg.NdisMessageType) {
 	case REMOTE_NDIS_PACKET_MSG:
 		/* data msg */
-		RndisFilterReceiveData(rndisDevice, &rndisMessage, Packet);
+		RndisFilterReceiveData(rndis_dev, &rndis_msg, pkt);
 		break;
 
 	case REMOTE_NDIS_INITIALIZE_CMPLT:
@@ -449,37 +459,37 @@ static int RndisFilterOnReceive(struct hv_device *Device,
 	/* case REMOTE_NDIS_RESET_CMPLT: */
 	/* case REMOTE_NDIS_KEEPALIVE_CMPLT: */
 		/* completion msgs */
-		RndisFilterReceiveResponse(rndisDevice, &rndisMessage);
+		RndisFilterReceiveResponse(rndis_dev, &rndis_msg);
 		break;
 
 	case REMOTE_NDIS_INDICATE_STATUS_MSG:
 		/* notification msgs */
-		RndisFilterReceiveIndicateStatus(rndisDevice, &rndisMessage);
+		RndisFilterReceiveIndicateStatus(rndis_dev, &rndis_msg);
 		break;
 	default:
 		DPRINT_ERR(NETVSC, "unhandled rndis message (type %u len %u)",
-			   rndisMessage.NdisMessageType,
-			   rndisMessage.MessageLength);
+			   rndis_msg.NdisMessageType,
+			   rndis_msg.MessageLength);
 		break;
 	}
 
 	return 0;
 }
 
-static int RndisFilterQueryDevice(struct rndis_device *Device, u32 Oid,
-				  void *Result, u32 *ResultSize)
+static int RndisFilterQueryDevice(struct rndis_device *dev, u32 oid,
+				  void *result, u32 *result_size)
 {
 	struct rndis_request *request;
-	u32 inresultSize = *ResultSize;
+	u32 inresult_size = *result_size;
 	struct rndis_query_request *query;
-	struct rndis_query_complete *queryComplete;
+	struct rndis_query_complete *query_complete;
 	int ret = 0;
 
-	if (!Result)
+	if (!result)
 		return -EINVAL;
 
-	*ResultSize = 0;
-	request = GetRndisRequest(Device, REMOTE_NDIS_QUERY_MSG,
+	*result_size = 0;
+	request = GetRndisRequest(dev, REMOTE_NDIS_QUERY_MSG,
 			RNDIS_MESSAGE_SIZE(struct rndis_query_request));
 	if (!request) {
 		ret = -1;
@@ -487,71 +497,71 @@ static int RndisFilterQueryDevice(struct rndis_device *Device, u32 Oid,
 	}
 
 	/* Setup the rndis query */
-	query = &request->RequestMessage.Message.QueryRequest;
-	query->Oid = Oid;
+	query = &request->request_msg.Message.QueryRequest;
+	query->Oid = oid;
 	query->InformationBufferOffset = sizeof(struct rndis_query_request);
 	query->InformationBufferLength = 0;
 	query->DeviceVcHandle = 0;
 
-	ret = RndisFilterSendRequest(Device, request);
+	ret = RndisFilterSendRequest(dev, request);
 	if (ret != 0)
 		goto Cleanup;
 
-	osd_waitevent_wait(request->WaitEvent);
+	osd_waitevent_wait(request->waitevent);
 
 	/* Copy the response back */
-	queryComplete = &request->ResponseMessage.Message.QueryComplete;
+	query_complete = &request->response_msg.Message.QueryComplete;
 
-	if (queryComplete->InformationBufferLength > inresultSize) {
+	if (query_complete->InformationBufferLength > inresult_size) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	memcpy(Result,
-	       (void *)((unsigned long)queryComplete +
-			 queryComplete->InformationBufferOffset),
-	       queryComplete->InformationBufferLength);
+	memcpy(result,
+	       (void *)((unsigned long)query_complete +
+			 query_complete->InformationBufferOffset),
+	       query_complete->InformationBufferLength);
 
-	*ResultSize = queryComplete->InformationBufferLength;
+	*result_size = query_complete->InformationBufferLength;
 
 Cleanup:
 	if (request)
-		PutRndisRequest(Device, request);
+		PutRndisRequest(dev, request);
 
 	return ret;
 }
 
-static int RndisFilterQueryDeviceMac(struct rndis_device *Device)
+static int RndisFilterQueryDeviceMac(struct rndis_device *dev)
 {
 	u32 size = ETH_ALEN;
 
-	return RndisFilterQueryDevice(Device,
+	return RndisFilterQueryDevice(dev,
 				      RNDIS_OID_802_3_PERMANENT_ADDRESS,
-				      Device->HwMacAddr, &size);
+				      dev->hw_mac_adr, &size);
 }
 
-static int RndisFilterQueryDeviceLinkStatus(struct rndis_device *Device)
+static int RndisFilterQueryDeviceLinkStatus(struct rndis_device *dev)
 {
 	u32 size = sizeof(u32);
 
-	return RndisFilterQueryDevice(Device,
+	return RndisFilterQueryDevice(dev,
 				      RNDIS_OID_GEN_MEDIA_CONNECT_STATUS,
-				      &Device->LinkStatus, &size);
+				      &dev->link_stat, &size);
 }
 
-static int RndisFilterSetPacketFilter(struct rndis_device *Device,
-				      u32 NewFilter)
+static int RndisFilterSetPacketFilter(struct rndis_device *dev,
+				      u32 new_filter)
 {
 	struct rndis_request *request;
 	struct rndis_set_request *set;
-	struct rndis_set_complete *setComplete;
+	struct rndis_set_complete *set_complete;
 	u32 status;
 	int ret;
 
 	/* ASSERT(RNDIS_MESSAGE_SIZE(struct rndis_set_request) + sizeof(u32) <= */
 	/* 	sizeof(struct rndis_message)); */
 
-	request = GetRndisRequest(Device, REMOTE_NDIS_SET_MSG,
+	request = GetRndisRequest(dev, REMOTE_NDIS_SET_MSG,
 			RNDIS_MESSAGE_SIZE(struct rndis_set_request) +
 			sizeof(u32));
 	if (!request) {
@@ -560,19 +570,19 @@ static int RndisFilterSetPacketFilter(struct rndis_device *Device,
 	}
 
 	/* Setup the rndis set */
-	set = &request->RequestMessage.Message.SetRequest;
+	set = &request->request_msg.Message.SetRequest;
 	set->Oid = RNDIS_OID_GEN_CURRENT_PACKET_FILTER;
 	set->InformationBufferLength = sizeof(u32);
 	set->InformationBufferOffset = sizeof(struct rndis_set_request);
 
 	memcpy((void *)(unsigned long)set + sizeof(struct rndis_set_request),
-	       &NewFilter, sizeof(u32));
+	       &new_filter, sizeof(u32));
 
-	ret = RndisFilterSendRequest(Device, request);
+	ret = RndisFilterSendRequest(dev, request);
 	if (ret != 0)
 		goto Cleanup;
 
-	ret = osd_waitevent_waitex(request->WaitEvent, 2000/*2sec*/);
+	ret = osd_waitevent_waitex(request->waitevent, 2000/*2sec*/);
 	if (!ret) {
 		ret = -1;
 		DPRINT_ERR(NETVSC, "timeout before we got a set response...");
@@ -584,27 +594,27 @@ static int RndisFilterSetPacketFilter(struct rndis_device *Device,
 	} else {
 		if (ret > 0)
 			ret = 0;
-		setComplete = &request->ResponseMessage.Message.SetComplete;
-		status = setComplete->Status;
+		set_complete = &request->response_msg.Message.SetComplete;
+		status = set_complete->Status;
 	}
 
 Cleanup:
 	if (request)
-		PutRndisRequest(Device, request);
+		PutRndisRequest(dev, request);
 Exit:
 	return ret;
 }
 
-int RndisFilterInit(struct netvsc_driver *Driver)
+int RndisFilterInit(struct netvsc_driver *drv)
 {
 	DPRINT_DBG(NETVSC, "sizeof(struct rndis_filter_packet) == %zd",
 		   sizeof(struct rndis_filter_packet));
 
-	Driver->RequestExtSize = sizeof(struct rndis_filter_packet);
+	drv->RequestExtSize = sizeof(struct rndis_filter_packet);
 
 	/* Driver->Context = rndisDriver; */
 
-	memset(&gRndisFilter, 0, sizeof(struct rndis_filter_driver_object));
+	memset(&rndis_filter, 0, sizeof(struct rndis_filter_driver_object));
 
 	/*rndisDriver->Driver = Driver;
 
@@ -612,38 +622,38 @@ int RndisFilterInit(struct netvsc_driver *Driver)
 	rndisDriver->OnLinkStatusChanged = Driver->OnLinkStatusChanged;*/
 
 	/* Save the original dispatch handlers before we override it */
-	gRndisFilter.InnerDriver.Base.OnDeviceAdd = Driver->Base.OnDeviceAdd;
-	gRndisFilter.InnerDriver.Base.OnDeviceRemove =
-					Driver->Base.OnDeviceRemove;
-	gRndisFilter.InnerDriver.Base.OnCleanup = Driver->Base.OnCleanup;
+	rndis_filter.inner_drv.Base.OnDeviceAdd = drv->Base.OnDeviceAdd;
+	rndis_filter.inner_drv.Base.OnDeviceRemove =
+					drv->Base.OnDeviceRemove;
+	rndis_filter.inner_drv.Base.OnCleanup = drv->Base.OnCleanup;
 
 	/* ASSERT(Driver->OnSend); */
 	/* ASSERT(Driver->OnReceiveCallback); */
-	gRndisFilter.InnerDriver.OnSend = Driver->OnSend;
-	gRndisFilter.InnerDriver.OnReceiveCallback = Driver->OnReceiveCallback;
-	gRndisFilter.InnerDriver.OnLinkStatusChanged =
-					Driver->OnLinkStatusChanged;
+	rndis_filter.inner_drv.OnSend = drv->OnSend;
+	rndis_filter.inner_drv.OnReceiveCallback = drv->OnReceiveCallback;
+	rndis_filter.inner_drv.OnLinkStatusChanged =
+					drv->OnLinkStatusChanged;
 
 	/* Override */
-	Driver->Base.OnDeviceAdd = RndisFilterOnDeviceAdd;
-	Driver->Base.OnDeviceRemove = RndisFilterOnDeviceRemove;
-	Driver->Base.OnCleanup = RndisFilterOnCleanup;
-	Driver->OnSend = RndisFilterOnSend;
+	drv->Base.OnDeviceAdd = RndisFilterOnDeviceAdd;
+	drv->Base.OnDeviceRemove = RndisFilterOnDeviceRemove;
+	drv->Base.OnCleanup = RndisFilterOnCleanup;
+	drv->OnSend = RndisFilterOnSend;
 	/* Driver->QueryLinkStatus = RndisFilterQueryDeviceLinkStatus; */
-	Driver->OnReceiveCallback = RndisFilterOnReceive;
+	drv->OnReceiveCallback = RndisFilterOnReceive;
 
 	return 0;
 }
 
-static int RndisFilterInitDevice(struct rndis_device *Device)
+static int RndisFilterInitDevice(struct rndis_device *dev)
 {
 	struct rndis_request *request;
 	struct rndis_initialize_request *init;
-	struct rndis_initialize_complete *initComplete;
+	struct rndis_initialize_complete *init_complete;
 	u32 status;
 	int ret;
 
-	request = GetRndisRequest(Device, REMOTE_NDIS_INITIALIZE_MSG,
+	request = GetRndisRequest(dev, REMOTE_NDIS_INITIALIZE_MSG,
 			RNDIS_MESSAGE_SIZE(struct rndis_initialize_request));
 	if (!request) {
 		ret = -1;
@@ -651,103 +661,103 @@ static int RndisFilterInitDevice(struct rndis_device *Device)
 	}
 
 	/* Setup the rndis set */
-	init = &request->RequestMessage.Message.InitializeRequest;
+	init = &request->request_msg.Message.InitializeRequest;
 	init->MajorVersion = RNDIS_MAJOR_VERSION;
 	init->MinorVersion = RNDIS_MINOR_VERSION;
 	/* FIXME: Use 1536 - rounded ethernet frame size */
 	init->MaxTransferSize = 2048;
 
-	Device->State = RNDIS_DEV_INITIALIZING;
+	dev->state = RNDIS_DEV_INITIALIZING;
 
-	ret = RndisFilterSendRequest(Device, request);
+	ret = RndisFilterSendRequest(dev, request);
 	if (ret != 0) {
-		Device->State = RNDIS_DEV_UNINITIALIZED;
+		dev->state = RNDIS_DEV_UNINITIALIZED;
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(request->WaitEvent);
+	osd_waitevent_wait(request->waitevent);
 
-	initComplete = &request->ResponseMessage.Message.InitializeComplete;
-	status = initComplete->Status;
+	init_complete = &request->response_msg.Message.InitializeComplete;
+	status = init_complete->Status;
 	if (status == RNDIS_STATUS_SUCCESS) {
-		Device->State = RNDIS_DEV_INITIALIZED;
+		dev->state = RNDIS_DEV_INITIALIZED;
 		ret = 0;
 	} else {
-		Device->State = RNDIS_DEV_UNINITIALIZED;
+		dev->state = RNDIS_DEV_UNINITIALIZED;
 		ret = -1;
 	}
 
 Cleanup:
 	if (request)
-		PutRndisRequest(Device, request);
+		PutRndisRequest(dev, request);
 
 	return ret;
 }
 
-static void RndisFilterHaltDevice(struct rndis_device *Device)
+static void RndisFilterHaltDevice(struct rndis_device *dev)
 {
 	struct rndis_request *request;
 	struct rndis_halt_request *halt;
 
 	/* Attempt to do a rndis device halt */
-	request = GetRndisRequest(Device, REMOTE_NDIS_HALT_MSG,
+	request = GetRndisRequest(dev, REMOTE_NDIS_HALT_MSG,
 				RNDIS_MESSAGE_SIZE(struct rndis_halt_request));
 	if (!request)
 		goto Cleanup;
 
 	/* Setup the rndis set */
-	halt = &request->RequestMessage.Message.HaltRequest;
-	halt->RequestId = atomic_inc_return(&Device->NewRequestId);
+	halt = &request->request_msg.Message.HaltRequest;
+	halt->RequestId = atomic_inc_return(&dev->new_req_id);
 
 	/* Ignore return since this msg is optional. */
-	RndisFilterSendRequest(Device, request);
+	RndisFilterSendRequest(dev, request);
 
-	Device->State = RNDIS_DEV_UNINITIALIZED;
+	dev->state = RNDIS_DEV_UNINITIALIZED;
 
 Cleanup:
 	if (request)
-		PutRndisRequest(Device, request);
+		PutRndisRequest(dev, request);
 	return;
 }
 
-static int RndisFilterOpenDevice(struct rndis_device *Device)
+static int RndisFilterOpenDevice(struct rndis_device *dev)
 {
 	int ret;
 
-	if (Device->State != RNDIS_DEV_INITIALIZED)
+	if (dev->state != RNDIS_DEV_INITIALIZED)
 		return 0;
 
-	ret = RndisFilterSetPacketFilter(Device,
+	ret = RndisFilterSetPacketFilter(dev,
 					 NDIS_PACKET_TYPE_BROADCAST |
 					 NDIS_PACKET_TYPE_ALL_MULTICAST |
 					 NDIS_PACKET_TYPE_DIRECTED);
 	if (ret == 0)
-		Device->State = RNDIS_DEV_DATAINITIALIZED;
+		dev->state = RNDIS_DEV_DATAINITIALIZED;
 
 	return ret;
 }
 
-static int RndisFilterCloseDevice(struct rndis_device *Device)
+static int RndisFilterCloseDevice(struct rndis_device *dev)
 {
 	int ret;
 
-	if (Device->State != RNDIS_DEV_DATAINITIALIZED)
+	if (dev->state != RNDIS_DEV_DATAINITIALIZED)
 		return 0;
 
-	ret = RndisFilterSetPacketFilter(Device, 0);
+	ret = RndisFilterSetPacketFilter(dev, 0);
 	if (ret == 0)
-		Device->State = RNDIS_DEV_INITIALIZED;
+		dev->state = RNDIS_DEV_INITIALIZED;
 
 	return ret;
 }
 
-static int RndisFilterOnDeviceAdd(struct hv_device *Device,
-				  void *AdditionalInfo)
+static int RndisFilterOnDeviceAdd(struct hv_device *dev,
+				  void *additional_info)
 {
 	int ret;
 	struct netvsc_device *netDevice;
 	struct rndis_device *rndisDevice;
-	struct netvsc_device_info *deviceInfo = AdditionalInfo;
+	struct netvsc_device_info *deviceInfo = additional_info;
 
 	rndisDevice = GetRndisDevice();
 	if (!rndisDevice)
@@ -760,7 +770,7 @@ static int RndisFilterOnDeviceAdd(struct hv_device *Device,
 	 * NOTE! Once the channel is created, we may get a receive callback
 	 * (RndisFilterOnReceive()) before this call is completed
 	 */
-	ret = gRndisFilter.InnerDriver.Base.OnDeviceAdd(Device, AdditionalInfo);
+	ret = rndis_filter.inner_drv.Base.OnDeviceAdd(dev, additional_info);
 	if (ret != 0) {
 		kfree(rndisDevice);
 		return ret;
@@ -768,12 +778,12 @@ static int RndisFilterOnDeviceAdd(struct hv_device *Device,
 
 
 	/* Initialize the rndis device */
-	netDevice = Device->Extension;
+	netDevice = dev->Extension;
 	/* ASSERT(netDevice); */
 	/* ASSERT(netDevice->Device); */
 
 	netDevice->Extension = rndisDevice;
-	rndisDevice->NetDevice = netDevice;
+	rndisDevice->net_dev = netDevice;
 
 	/* Send the rndis initialization message */
 	ret = RndisFilterInitDevice(rndisDevice);
@@ -793,43 +803,43 @@ static int RndisFilterOnDeviceAdd(struct hv_device *Device,
 	}
 
 	DPRINT_INFO(NETVSC, "Device 0x%p mac addr %pM",
-		    rndisDevice, rndisDevice->HwMacAddr);
+		    rndisDevice, rndisDevice->hw_mac_adr);
 
-	memcpy(deviceInfo->MacAddr, rndisDevice->HwMacAddr, ETH_ALEN);
+	memcpy(deviceInfo->MacAddr, rndisDevice->hw_mac_adr, ETH_ALEN);
 
 	RndisFilterQueryDeviceLinkStatus(rndisDevice);
 
-	deviceInfo->LinkState = rndisDevice->LinkStatus;
+	deviceInfo->LinkState = rndisDevice->link_stat;
 	DPRINT_INFO(NETVSC, "Device 0x%p link state %s", rndisDevice,
 		    ((deviceInfo->LinkState) ? ("down") : ("up")));
 
 	return ret;
 }
 
-static int RndisFilterOnDeviceRemove(struct hv_device *Device)
+static int RndisFilterOnDeviceRemove(struct hv_device *dev)
 {
-	struct netvsc_device *netDevice = Device->Extension;
-	struct rndis_device *rndisDevice = netDevice->Extension;
+	struct netvsc_device *net_dev = dev->Extension;
+	struct rndis_device *rndis_dev = net_dev->Extension;
 
 	/* Halt and release the rndis device */
-	RndisFilterHaltDevice(rndisDevice);
+	RndisFilterHaltDevice(rndis_dev);
 
-	kfree(rndisDevice);
-	netDevice->Extension = NULL;
+	kfree(rndis_dev);
+	net_dev->Extension = NULL;
 
 	/* Pass control to inner driver to remove the device */
-	gRndisFilter.InnerDriver.Base.OnDeviceRemove(Device);
+	rndis_filter.inner_drv.Base.OnDeviceRemove(dev);
 
 	return 0;
 }
 
-static void RndisFilterOnCleanup(struct hv_driver *Driver)
+static void RndisFilterOnCleanup(struct hv_driver *drv)
 {
 }
 
-int RndisFilterOnOpen(struct hv_device *Device)
+int RndisFilterOnOpen(struct hv_device *dev)
 {
-	struct netvsc_device *netDevice = Device->Extension;
+	struct netvsc_device *netDevice = dev->Extension;
 
 	if (!netDevice)
 		return -EINVAL;
@@ -837,9 +847,9 @@ int RndisFilterOnOpen(struct hv_device *Device)
 	return RndisFilterOpenDevice(netDevice->Extension);
 }
 
-int RndisFilterOnClose(struct hv_device *Device)
+int RndisFilterOnClose(struct hv_device *dev)
 {
-	struct netvsc_device *netDevice = Device->Extension;
+	struct netvsc_device *netDevice = dev->Extension;
 
 	if (!netDevice)
 		return -EINVAL;
@@ -847,8 +857,8 @@ int RndisFilterOnClose(struct hv_device *Device)
 	return RndisFilterCloseDevice(netDevice->Extension);
 }
 
-static int RndisFilterOnSend(struct hv_device *Device,
-			     struct hv_netvsc_packet *Packet)
+static int RndisFilterOnSend(struct hv_device *dev,
+			     struct hv_netvsc_packet *pkt)
 {
 	int ret;
 	struct rndis_filter_packet *filterPacket;
@@ -857,62 +867,62 @@ static int RndisFilterOnSend(struct hv_device *Device,
 	u32 rndisMessageSize;
 
 	/* Add the rndis header */
-	filterPacket = (struct rndis_filter_packet *)Packet->Extension;
+	filterPacket = (struct rndis_filter_packet *)pkt->Extension;
 	/* ASSERT(filterPacket); */
 
 	memset(filterPacket, 0, sizeof(struct rndis_filter_packet));
 
-	rndisMessage = &filterPacket->Message;
+	rndisMessage = &filterPacket->msg;
 	rndisMessageSize = RNDIS_MESSAGE_SIZE(struct rndis_packet);
 
 	rndisMessage->NdisMessageType = REMOTE_NDIS_PACKET_MSG;
-	rndisMessage->MessageLength = Packet->TotalDataBufferLength +
+	rndisMessage->MessageLength = pkt->TotalDataBufferLength +
 				      rndisMessageSize;
 
 	rndisPacket = &rndisMessage->Message.Packet;
 	rndisPacket->DataOffset = sizeof(struct rndis_packet);
-	rndisPacket->DataLength = Packet->TotalDataBufferLength;
+	rndisPacket->DataLength = pkt->TotalDataBufferLength;
 
-	Packet->IsDataPacket = true;
-	Packet->PageBuffers[0].Pfn = virt_to_phys(rndisMessage) >> PAGE_SHIFT;
-	Packet->PageBuffers[0].Offset =
+	pkt->IsDataPacket = true;
+	pkt->PageBuffers[0].Pfn = virt_to_phys(rndisMessage) >> PAGE_SHIFT;
+	pkt->PageBuffers[0].Offset =
 			(unsigned long)rndisMessage & (PAGE_SIZE-1);
-	Packet->PageBuffers[0].Length = rndisMessageSize;
+	pkt->PageBuffers[0].Length = rndisMessageSize;
 
 	/* Save the packet send completion and context */
-	filterPacket->OnCompletion = Packet->Completion.Send.OnSendCompletion;
-	filterPacket->CompletionContext =
-				Packet->Completion.Send.SendCompletionContext;
+	filterPacket->completion = pkt->Completion.Send.OnSendCompletion;
+	filterPacket->completion_ctx =
+				pkt->Completion.Send.SendCompletionContext;
 
 	/* Use ours */
-	Packet->Completion.Send.OnSendCompletion = RndisFilterOnSendCompletion;
-	Packet->Completion.Send.SendCompletionContext = filterPacket;
+	pkt->Completion.Send.OnSendCompletion = RndisFilterOnSendCompletion;
+	pkt->Completion.Send.SendCompletionContext = filterPacket;
 
-	ret = gRndisFilter.InnerDriver.OnSend(Device, Packet);
+	ret = rndis_filter.inner_drv.OnSend(dev, pkt);
 	if (ret != 0) {
 		/*
 		 * Reset the completion to originals to allow retries from
 		 * above
 		 */
-		Packet->Completion.Send.OnSendCompletion =
-				filterPacket->OnCompletion;
-		Packet->Completion.Send.SendCompletionContext =
-				filterPacket->CompletionContext;
+		pkt->Completion.Send.OnSendCompletion =
+				filterPacket->completion;
+		pkt->Completion.Send.SendCompletionContext =
+				filterPacket->completion_ctx;
 	}
 
 	return ret;
 }
 
-static void RndisFilterOnSendCompletion(void *Context)
+static void RndisFilterOnSendCompletion(void *ctx)
 {
-	struct rndis_filter_packet *filterPacket = Context;
+	struct rndis_filter_packet *filterPacket = ctx;
 
 	/* Pass it back to the original handler */
-	filterPacket->OnCompletion(filterPacket->CompletionContext);
+	filterPacket->completion(filterPacket->completion_ctx);
 }
 
 
-static void RndisFilterOnSendRequestCompletion(void *Context)
+static void RndisFilterOnSendRequestCompletion(void *ctx)
 {
 	/* Noop */
 }
-- 
1.6.3.2

