Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0LJUAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:00:15 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:54000
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755822Ab0LJUAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:00:12 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 6/7] staging: hv: Convert camel cased struct fields in netvsc.h to lower cases
Date: Fri, 10 Dec 2010 12:03:59 -0800
Message-Id: <1292011440-21174-6-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1292011440-21174-5-git-send-email-haiyangz@microsoft.com>
References: <1292011440-21174-1-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-2-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-3-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-4-git-send-email-haiyangz@microsoft.com>
 <1292011440-21174-5-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c       |  340 +++++++++++++++++++------------------
 drivers/staging/hv/netvsc.h       |  164 +++++++++---------
 drivers/staging/hv/netvsc_api.h   |    2 +-
 drivers/staging/hv/rndis_filter.c |   22 ++--
 4 files changed, 265 insertions(+), 263 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index d678bf5..df9cd13 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -83,9 +83,9 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffic */
-	atomic_cmpxchg(&net_device->RefCount, 0, 2);
+	atomic_cmpxchg(&net_device->refcnt, 0, 2);
 
-	net_device->Device = device;
+	net_device->dev = device;
 	device->Extension = net_device;
 
 	return net_device;
@@ -93,8 +93,8 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 
 static void free_net_device(struct netvsc_device *device)
 {
-	WARN_ON(atomic_read(&device->RefCount) == 0);
-	device->Device->Extension = NULL;
+	WARN_ON(atomic_read(&device->refcnt) == 0);
+	device->dev->Extension = NULL;
 	kfree(device);
 }
 
@@ -105,8 +105,8 @@ static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 	struct netvsc_device *net_device;
 
 	net_device = device->Extension;
-	if (net_device && atomic_read(&net_device->RefCount) > 1)
-		atomic_inc(&net_device->RefCount);
+	if (net_device && atomic_read(&net_device->refcnt) > 1)
+		atomic_inc(&net_device->refcnt);
 	else
 		net_device = NULL;
 
@@ -119,8 +119,8 @@ static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 	struct netvsc_device *net_device;
 
 	net_device = device->Extension;
-	if (net_device && atomic_read(&net_device->RefCount))
-		atomic_inc(&net_device->RefCount);
+	if (net_device && atomic_read(&net_device->refcnt))
+		atomic_inc(&net_device->refcnt);
 	else
 		net_device = NULL;
 
@@ -134,7 +134,7 @@ static void put_net_device(struct hv_device *device)
 	net_device = device->Extension;
 	/* ASSERT(netDevice); */
 
-	atomic_dec(&net_device->RefCount);
+	atomic_dec(&net_device->refcnt);
 }
 
 static struct netvsc_device *release_outbound_net_device(
@@ -147,7 +147,7 @@ static struct netvsc_device *release_outbound_net_device(
 		return NULL;
 
 	/* Busy wait until the ref drop to 2, then set it to 1 */
-	while (atomic_cmpxchg(&net_device->RefCount, 2, 1) != 2)
+	while (atomic_cmpxchg(&net_device->refcnt, 2, 1) != 2)
 		udelay(100);
 
 	return net_device;
@@ -163,7 +163,7 @@ static struct netvsc_device *release_inbound_net_device(
 		return NULL;
 
 	/* Busy wait until the ref drop to 1, then set it to 0 */
-	while (atomic_cmpxchg(&net_device->RefCount, 1, 0) != 1)
+	while (atomic_cmpxchg(&net_device->refcnt, 1, 0) != 1)
 		udelay(100);
 
 	device->Extension = NULL;
@@ -222,12 +222,12 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	/* page-size grandularity */
 	/* ASSERT((netDevice->ReceiveBufferSize & (PAGE_SIZE - 1)) == 0); */
 
-	net_device->ReceiveBuffer =
-		osd_page_alloc(net_device->ReceiveBufferSize >> PAGE_SHIFT);
-	if (!net_device->ReceiveBuffer) {
+	net_device->recv_buf =
+		osd_page_alloc(net_device->recv_buf_size >> PAGE_SHIFT);
+	if (!net_device->recv_buf) {
 		DPRINT_ERR(NETVSC,
 			   "unable to allocate receive buffer of size %d",
-			   net_device->ReceiveBufferSize);
+			   net_device->recv_buf_size);
 		ret = -1;
 		goto Cleanup;
 	}
@@ -242,9 +242,9 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	 * channel.  Note: This call uses the vmbus connection rather
 	 * than the channel to establish the gpadl handle.
 	 */
-	ret = vmbus_establish_gpadl(device->channel, net_device->ReceiveBuffer,
-				    net_device->ReceiveBufferSize,
-				    &net_device->ReceiveBufferGpadlHandle);
+	ret = vmbus_establish_gpadl(device->channel, net_device->recv_buf,
+				    net_device->recv_buf_size,
+				    &net_device->recv_buf_gpadl_handle);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
 			   "unable to establish receive buffer's gpadl");
@@ -256,15 +256,15 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	/* Notify the NetVsp of the gpadl handle */
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendReceiveBuffer...");
 
-	init_packet = &net_device->ChannelInitPacket;
+	init_packet = &net_device->channel_init_pkt;
 
 	memset(init_packet, 0, sizeof(struct nvsp_message));
 
-	init_packet->Header.MessageType = NvspMessage1TypeSendReceiveBuffer;
-	init_packet->Messages.Version1Messages.SendReceiveBuffer.
-		GpadlHandle = net_device->ReceiveBufferGpadlHandle;
-	init_packet->Messages.Version1Messages.
-		SendReceiveBuffer.Id = NETVSC_RECEIVE_BUFFER_ID;
+	init_packet->hdr.msg_type = NVSP_MSG1_TYPE_SEND_RECV_BUF;
+	init_packet->msg.v1_msg.send_recv_buf.
+		gpadl_handle = net_device->recv_buf_gpadl_handle;
+	init_packet->msg.v1_msg.
+		send_recv_buf.id = NETVSC_RECEIVE_BUFFER_ID;
 
 	/* Send the gpadl notification request */
 	ret = vmbus_sendpacket(device->channel, init_packet,
@@ -278,15 +278,15 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(net_device->ChannelInitEvent);
+	osd_waitevent_wait(net_device->channel_init_event);
 
 	/* Check the response */
-	if (init_packet->Messages.Version1Messages.
-	    SendReceiveBufferComplete.Status != NvspStatusSuccess) {
+	if (init_packet->msg.v1_msg.
+	    send_recv_buf_complete.status != NVSP_STAT_SUCCESS) {
 		DPRINT_ERR(NETVSC, "Unable to complete receive buffer "
 			   "initialzation with NetVsp - status %d",
-			   init_packet->Messages.Version1Messages.
-			   SendReceiveBufferComplete.Status);
+			   init_packet->msg.v1_msg.
+			   send_recv_buf_complete.status);
 		ret = -1;
 		goto Cleanup;
 	}
@@ -295,36 +295,36 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	/* ASSERT(netDevice->ReceiveSectionCount == 0); */
 	/* ASSERT(netDevice->ReceiveSections == NULL); */
 
-	net_device->ReceiveSectionCount = init_packet->Messages.
-		Version1Messages.SendReceiveBufferComplete.NumSections;
+	net_device->recv_section_cnt = init_packet->msg.
+		v1_msg.send_recv_buf_complete.num_sections;
 
-	net_device->ReceiveSections = kmalloc(net_device->ReceiveSectionCount
+	net_device->recv_section = kmalloc(net_device->recv_section_cnt
 		* sizeof(struct nvsp_1_receive_buffer_section), GFP_KERNEL);
-	if (net_device->ReceiveSections == NULL) {
+	if (net_device->recv_section == NULL) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	memcpy(net_device->ReceiveSections,
-		init_packet->Messages.Version1Messages.
-	       SendReceiveBufferComplete.Sections,
-		net_device->ReceiveSectionCount *
+	memcpy(net_device->recv_section,
+		init_packet->msg.v1_msg.
+	       send_recv_buf_complete.sections,
+		net_device->recv_section_cnt *
 	       sizeof(struct nvsp_1_receive_buffer_section));
 
 	DPRINT_INFO(NETVSC, "Receive sections info (count %d, offset %d, "
 		    "endoffset %d, suballoc size %d, num suballocs %d)",
-		    net_device->ReceiveSectionCount,
-		    net_device->ReceiveSections[0].Offset,
-		    net_device->ReceiveSections[0].EndOffset,
-		    net_device->ReceiveSections[0].SubAllocationSize,
-		    net_device->ReceiveSections[0].NumSubAllocations);
+		    net_device->recv_section_cnt,
+		    net_device->recv_section[0].offset,
+		    net_device->recv_section[0].end_offset,
+		    net_device->recv_section[0].sub_alloc_size,
+		    net_device->recv_section[0].num_sub_allocs);
 
 	/*
 	 * For 1st release, there should only be 1 section that represents the
 	 * entire receive buffer
 	 */
-	if (net_device->ReceiveSectionCount != 1 ||
-	    net_device->ReceiveSections->Offset != 0) {
+	if (net_device->recv_section_cnt != 1 ||
+	    net_device->recv_section->offset != 0) {
 		ret = -1;
 		goto Cleanup;
 	}
@@ -351,7 +351,7 @@ static int netvsc_init_send_buf(struct hv_device *device)
 			   "device being destroyed?");
 		return -1;
 	}
-	if (net_device->SendBufferSize <= 0) {
+	if (net_device->send_buf_size <= 0) {
 		ret = -EINVAL;
 		goto Cleanup;
 	}
@@ -359,11 +359,11 @@ static int netvsc_init_send_buf(struct hv_device *device)
 	/* page-size grandularity */
 	/* ASSERT((netDevice->SendBufferSize & (PAGE_SIZE - 1)) == 0); */
 
-	net_device->SendBuffer =
-		osd_page_alloc(net_device->SendBufferSize >> PAGE_SHIFT);
-	if (!net_device->SendBuffer) {
+	net_device->send_buf =
+		osd_page_alloc(net_device->send_buf_size >> PAGE_SHIFT);
+	if (!net_device->send_buf) {
 		DPRINT_ERR(NETVSC, "unable to allocate send buffer of size %d",
-			   net_device->SendBufferSize);
+			   net_device->send_buf_size);
 		ret = -1;
 		goto Cleanup;
 	}
@@ -377,9 +377,9 @@ static int netvsc_init_send_buf(struct hv_device *device)
 	 * channel.  Note: This call uses the vmbus connection rather
 	 * than the channel to establish the gpadl handle.
 	 */
-	ret = vmbus_establish_gpadl(device->channel, net_device->SendBuffer,
-				    net_device->SendBufferSize,
-				    &net_device->SendBufferGpadlHandle);
+	ret = vmbus_establish_gpadl(device->channel, net_device->send_buf,
+				    net_device->send_buf_size,
+				    &net_device->send_buf_gpadl_handle);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC, "unable to establish send buffer's gpadl");
 		goto Cleanup;
@@ -390,14 +390,14 @@ static int netvsc_init_send_buf(struct hv_device *device)
 	/* Notify the NetVsp of the gpadl handle */
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendSendBuffer...");
 
-	init_packet = &net_device->ChannelInitPacket;
+	init_packet = &net_device->channel_init_pkt;
 
 	memset(init_packet, 0, sizeof(struct nvsp_message));
 
-	init_packet->Header.MessageType = NvspMessage1TypeSendSendBuffer;
-	init_packet->Messages.Version1Messages.SendReceiveBuffer.
-		GpadlHandle = net_device->SendBufferGpadlHandle;
-	init_packet->Messages.Version1Messages.SendReceiveBuffer.Id =
+	init_packet->hdr.msg_type = NVSP_MSG1_TYPE_SEND_SEND_BUF;
+	init_packet->msg.v1_msg.send_recv_buf.
+		gpadl_handle = net_device->send_buf_gpadl_handle;
+	init_packet->msg.v1_msg.send_recv_buf.id =
 		NETVSC_SEND_BUFFER_ID;
 
 	/* Send the gpadl notification request */
@@ -412,21 +412,21 @@ static int netvsc_init_send_buf(struct hv_device *device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(net_device->ChannelInitEvent);
+	osd_waitevent_wait(net_device->channel_init_event);
 
 	/* Check the response */
-	if (init_packet->Messages.Version1Messages.
-	    SendSendBufferComplete.Status != NvspStatusSuccess) {
+	if (init_packet->msg.v1_msg.
+	    send_send_buf_complete.status != NVSP_STAT_SUCCESS) {
 		DPRINT_ERR(NETVSC, "Unable to complete send buffer "
 			   "initialzation with NetVsp - status %d",
-			   init_packet->Messages.Version1Messages.
-			   SendSendBufferComplete.Status);
+			   init_packet->msg.v1_msg.
+			   send_send_buf_complete.status);
 		ret = -1;
 		goto Cleanup;
 	}
 
-	net_device->SendSectionSize = init_packet->
-	Messages.Version1Messages.SendSendBufferComplete.SectionSize;
+	net_device->send_section_size = init_packet->
+	msg.v1_msg.send_send_buf_complete.section_size;
 
 	goto Exit;
 
@@ -449,20 +449,20 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 	 * NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
 	 * to send a revoke msg here
 	 */
-	if (net_device->ReceiveSectionCount) {
+	if (net_device->recv_section_cnt) {
 		DPRINT_INFO(NETVSC,
 			    "Sending NvspMessage1TypeRevokeReceiveBuffer...");
 
 		/* Send the revoke receive buffer */
-		revoke_packet = &net_device->RevokePacket;
+		revoke_packet = &net_device->revoke_packet;
 		memset(revoke_packet, 0, sizeof(struct nvsp_message));
 
-		revoke_packet->Header.MessageType =
-			NvspMessage1TypeRevokeReceiveBuffer;
-		revoke_packet->Messages.Version1Messages.
-		RevokeReceiveBuffer.Id = NETVSC_RECEIVE_BUFFER_ID;
+		revoke_packet->hdr.msg_type =
+			NVSP_MSG1_TYPE_REVOKE_RECV_BUF;
+		revoke_packet->msg.v1_msg.
+		revoke_recv_buf.id = NETVSC_RECEIVE_BUFFER_ID;
 
-		ret = vmbus_sendpacket(net_device->Device->channel,
+		ret = vmbus_sendpacket(net_device->dev->channel,
 				       revoke_packet,
 				       sizeof(struct nvsp_message),
 				       (unsigned long)revoke_packet,
@@ -479,11 +479,11 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 	}
 
 	/* Teardown the gpadl on the vsp end */
-	if (net_device->ReceiveBufferGpadlHandle) {
+	if (net_device->recv_buf_gpadl_handle) {
 		DPRINT_INFO(NETVSC, "Tearing down receive buffer's GPADL...");
 
-		ret = vmbus_teardown_gpadl(net_device->Device->channel,
-			   net_device->ReceiveBufferGpadlHandle);
+		ret = vmbus_teardown_gpadl(net_device->dev->channel,
+			   net_device->recv_buf_gpadl_handle);
 
 		/* If we failed here, we might as well return and have a leak rather than continue and a bugchk */
 		if (ret != 0) {
@@ -491,22 +491,22 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 				   "unable to teardown receive buffer's gpadl");
 			return -1;
 		}
-		net_device->ReceiveBufferGpadlHandle = 0;
+		net_device->recv_buf_gpadl_handle = 0;
 	}
 
-	if (net_device->ReceiveBuffer) {
+	if (net_device->recv_buf) {
 		DPRINT_INFO(NETVSC, "Freeing up receive buffer...");
 
 		/* Free up the receive buffer */
-		osd_page_free(net_device->ReceiveBuffer,
-			     net_device->ReceiveBufferSize >> PAGE_SHIFT);
-		net_device->ReceiveBuffer = NULL;
+		osd_page_free(net_device->recv_buf,
+			     net_device->recv_buf_size >> PAGE_SHIFT);
+		net_device->recv_buf = NULL;
 	}
 
-	if (net_device->ReceiveSections) {
-		net_device->ReceiveSectionCount = 0;
-		kfree(net_device->ReceiveSections);
-		net_device->ReceiveSections = NULL;
+	if (net_device->recv_section) {
+		net_device->recv_section_cnt = 0;
+		kfree(net_device->recv_section);
+		net_device->recv_section = NULL;
 	}
 
 	return ret;
@@ -523,20 +523,20 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 	 *  NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
 	 *  to send a revoke msg here
 	 */
-	if (net_device->SendSectionSize) {
+	if (net_device->send_section_size) {
 		DPRINT_INFO(NETVSC,
 			    "Sending NvspMessage1TypeRevokeSendBuffer...");
 
 		/* Send the revoke send buffer */
-		revoke_packet = &net_device->RevokePacket;
+		revoke_packet = &net_device->revoke_packet;
 		memset(revoke_packet, 0, sizeof(struct nvsp_message));
 
-		revoke_packet->Header.MessageType =
-			NvspMessage1TypeRevokeSendBuffer;
-		revoke_packet->Messages.Version1Messages.
-			RevokeSendBuffer.Id = NETVSC_SEND_BUFFER_ID;
+		revoke_packet->hdr.msg_type =
+			NVSP_MSG1_TYPE_REVOKE_SEND_BUF;
+		revoke_packet->msg.v1_msg.
+			revoke_send_buf.id = NETVSC_SEND_BUFFER_ID;
 
-		ret = vmbus_sendpacket(net_device->Device->channel,
+		ret = vmbus_sendpacket(net_device->dev->channel,
 				       revoke_packet,
 				       sizeof(struct nvsp_message),
 				       (unsigned long)revoke_packet,
@@ -553,10 +553,10 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 	}
 
 	/* Teardown the gpadl on the vsp end */
-	if (net_device->SendBufferGpadlHandle) {
+	if (net_device->send_buf_gpadl_handle) {
 		DPRINT_INFO(NETVSC, "Tearing down send buffer's GPADL...");
-		ret = vmbus_teardown_gpadl(net_device->Device->channel,
-					   net_device->SendBufferGpadlHandle);
+		ret = vmbus_teardown_gpadl(net_device->dev->channel,
+					   net_device->send_buf_gpadl_handle);
 
 		/*
 		 * If we failed here, we might as well return and have a leak
@@ -567,16 +567,16 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 				   "gpadl");
 			return -1;
 		}
-		net_device->SendBufferGpadlHandle = 0;
+		net_device->send_buf_gpadl_handle = 0;
 	}
 
-	if (net_device->SendBuffer) {
+	if (net_device->send_buf) {
 		DPRINT_INFO(NETVSC, "Freeing up send buffer...");
 
 		/* Free up the receive buffer */
-		osd_page_free(net_device->SendBuffer,
-			     net_device->SendBufferSize >> PAGE_SHIFT);
-		net_device->SendBuffer = NULL;
+		osd_page_free(net_device->send_buf,
+			     net_device->send_buf_size >> PAGE_SHIFT);
+		net_device->send_buf = NULL;
 	}
 
 	return ret;
@@ -597,13 +597,13 @@ static int netvsc_connect_vsp(struct hv_device *device)
 		return -1;
 	}
 
-	init_packet = &net_device->ChannelInitPacket;
+	init_packet = &net_device->channel_init_pkt;
 
 	memset(init_packet, 0, sizeof(struct nvsp_message));
-	init_packet->Header.MessageType = NvspMessageTypeInit;
-	init_packet->Messages.InitMessages.Init.MinProtocolVersion =
+	init_packet->hdr.msg_type = NVSP_MSG_TYPE_INIT;
+	init_packet->msg.init_msg.init.min_protocol_ver =
 		NVSP_MIN_PROTOCOL_VERSION;
-	init_packet->Messages.InitMessages.Init.MaxProtocolVersion =
+	init_packet->msg.init_msg.init.max_protocol_ver =
 		NVSP_MAX_PROTOCOL_VERSION;
 
 	DPRINT_INFO(NETVSC, "Sending NvspMessageTypeInit...");
@@ -620,30 +620,30 @@ static int netvsc_connect_vsp(struct hv_device *device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(net_device->ChannelInitEvent);
+	osd_waitevent_wait(net_device->channel_init_event);
 
 	/* Now, check the response */
 	/* ASSERT(initPacket->Messages.InitMessages.InitComplete.MaximumMdlChainLength <= MAX_MULTIPAGE_BUFFER_COUNT); */
 	DPRINT_INFO(NETVSC, "NvspMessageTypeInit status(%d) max mdl chain (%d)",
-		init_packet->Messages.InitMessages.InitComplete.Status,
-		init_packet->Messages.InitMessages.
-		    InitComplete.MaximumMdlChainLength);
+		init_packet->msg.init_msg.init_complete.status,
+		init_packet->msg.init_msg.
+		    init_complete.max_mdl_chain_len);
 
-	if (init_packet->Messages.InitMessages.InitComplete.Status !=
-	    NvspStatusSuccess) {
+	if (init_packet->msg.init_msg.init_complete.status !=
+	    NVSP_STAT_SUCCESS) {
 		DPRINT_ERR(NETVSC,
 			"unable to initialize with netvsp (status 0x%x)",
-			init_packet->Messages.InitMessages.InitComplete.Status);
+			init_packet->msg.init_msg.init_complete.status);
 		ret = -1;
 		goto Cleanup;
 	}
 
-	if (init_packet->Messages.InitMessages.InitComplete.
-	    NegotiatedProtocolVersion != NVSP_PROTOCOL_VERSION_1) {
+	if (init_packet->msg.init_msg.init_complete.
+	    negotiated_protocol_ver != NVSP_PROTOCOL_VERSION_1) {
 		DPRINT_ERR(NETVSC, "unable to initialize with netvsp "
 			   "(version expected 1 got %d)",
-			   init_packet->Messages.InitMessages.
-			   InitComplete.NegotiatedProtocolVersion);
+			   init_packet->msg.init_msg.
+			   init_complete.negotiated_protocol_ver);
 		ret = -1;
 		goto Cleanup;
 	}
@@ -654,12 +654,12 @@ static int netvsc_connect_vsp(struct hv_device *device)
 
 	ndis_version = 0x00050000;
 
-	init_packet->Header.MessageType = NvspMessage1TypeSendNdisVersion;
-	init_packet->Messages.Version1Messages.
-		SendNdisVersion.NdisMajorVersion =
+	init_packet->hdr.msg_type = NVSP_MSG1_TYPE_SEND_NDIS_VER;
+	init_packet->msg.v1_msg.
+		send_ndis_ver.ndis_major_ver =
 				(ndis_version & 0xFFFF0000) >> 16;
-	init_packet->Messages.Version1Messages.
-		SendNdisVersion.NdisMinorVersion =
+	init_packet->msg.v1_msg.
+		send_ndis_ver.ndis_minor_ver =
 				ndis_version & 0xFFFF;
 
 	/* Send the init request */
@@ -719,12 +719,12 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 	DPRINT_DBG(NETVSC, "netvsc channel object allocated - %p", net_device);
 
 	/* Initialize the NetVSC channel extension */
-	net_device->ReceiveBufferSize = NETVSC_RECEIVE_BUFFER_SIZE;
-	spin_lock_init(&net_device->receive_packet_list_lock);
+	net_device->recv_buf_size = NETVSC_RECEIVE_BUFFER_SIZE;
+	spin_lock_init(&net_device->recv_pkt_list_lock);
 
-	net_device->SendBufferSize = NETVSC_SEND_BUFFER_SIZE;
+	net_device->send_buf_size = NETVSC_SEND_BUFFER_SIZE;
 
-	INIT_LIST_HEAD(&net_device->ReceivePacketList);
+	INIT_LIST_HEAD(&net_device->recv_pkt_list);
 
 	for (i = 0; i < NETVSC_RECEIVE_PACKETLIST_COUNT; i++) {
 		packet = kzalloc(sizeof(struct hv_netvsc_packet) +
@@ -737,10 +737,10 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 			break;
 		}
 		list_add_tail(&packet->list_ent,
-			      &net_device->ReceivePacketList);
+			      &net_device->recv_pkt_list);
 	}
-	net_device->ChannelInitEvent = osd_waitevent_create();
-	if (!net_device->ChannelInitEvent) {
+	net_device->channel_init_event = osd_waitevent_create();
+	if (!net_device->channel_init_event) {
 		ret = -ENOMEM;
 		goto Cleanup;
 	}
@@ -779,10 +779,10 @@ close:
 Cleanup:
 
 	if (net_device) {
-		kfree(net_device->ChannelInitEvent);
+		kfree(net_device->channel_init_event);
 
 		list_for_each_entry_safe(packet, pos,
-					 &net_device->ReceivePacketList,
+					 &net_device->recv_pkt_list,
 					 list_ent) {
 			list_del(&packet->list_ent);
 			kfree(packet);
@@ -816,9 +816,9 @@ static int netvsc_device_remove(struct hv_device *device)
 	}
 
 	/* Wait for all send completions */
-	while (atomic_read(&net_device->NumOutstandingSends)) {
+	while (atomic_read(&net_device->num_outstanding_sends)) {
 		DPRINT_INFO(NETVSC, "waiting for %d requests to complete...",
-			    atomic_read(&net_device->NumOutstandingSends));
+			    atomic_read(&net_device->num_outstanding_sends));
 		udelay(100);
 	}
 
@@ -840,12 +840,12 @@ static int netvsc_device_remove(struct hv_device *device)
 
 	/* Release all resources */
 	list_for_each_entry_safe(netvsc_packet, pos,
-				 &net_device->ReceivePacketList, list_ent) {
+				 &net_device->recv_pkt_list, list_ent) {
 		list_del(&netvsc_packet->list_ent);
 		kfree(netvsc_packet);
 	}
 
-	kfree(net_device->ChannelInitEvent);
+	kfree(net_device->channel_init_event);
 	free_net_device(net_device);
 	return 0;
 }
@@ -875,19 +875,19 @@ static void netvsc_send_completion(struct hv_device *device,
 			(packet->DataOffset8 << 3));
 
 	DPRINT_DBG(NETVSC, "send completion packet - type %d",
-		   nvsp_packet->Header.MessageType);
+		   nvsp_packet->hdr.msg_type);
 
-	if ((nvsp_packet->Header.MessageType == NvspMessageTypeInitComplete) ||
-	    (nvsp_packet->Header.MessageType ==
-	     NvspMessage1TypeSendReceiveBufferComplete) ||
-	    (nvsp_packet->Header.MessageType ==
-	     NvspMessage1TypeSendSendBufferComplete)) {
+	if ((nvsp_packet->hdr.msg_type == NVSP_MSG_TYPE_INIT_COMPLETE) ||
+	    (nvsp_packet->hdr.msg_type ==
+	     NVSP_MSG1_TYPE_SEND_RECV_BUF_COMPLETE) ||
+	    (nvsp_packet->hdr.msg_type ==
+	     NVSP_MSG1_TYPE_SEND_SEND_BUF_COMPLETE)) {
 		/* Copy the response back */
-		memcpy(&net_device->ChannelInitPacket, nvsp_packet,
+		memcpy(&net_device->channel_init_pkt, nvsp_packet,
 		       sizeof(struct nvsp_message));
-		osd_waitevent_set(net_device->ChannelInitEvent);
-	} else if (nvsp_packet->Header.MessageType ==
-		   NvspMessage1TypeSendRNDISPacketComplete) {
+		osd_waitevent_set(net_device->channel_init_event);
+	} else if (nvsp_packet->hdr.msg_type ==
+		   NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE) {
 		/* Get the send context */
 		nvsc_packet = (struct hv_netvsc_packet *)(unsigned long)
 			packet->TransactionId;
@@ -897,10 +897,10 @@ static void netvsc_send_completion(struct hv_device *device,
 		nvsc_packet->completion.send.send_completion(
 			nvsc_packet->completion.send.send_completion_ctx);
 
-		atomic_dec(&net_device->NumOutstandingSends);
+		atomic_dec(&net_device->num_outstanding_sends);
 	} else {
 		DPRINT_ERR(NETVSC, "Unknown send completion packet type - "
-			   "%d received!!", nvsp_packet->Header.MessageType);
+			   "%d received!!", nvsp_packet->hdr.msg_type);
 	}
 
 	put_net_device(device);
@@ -921,18 +921,19 @@ static int netvsc_send(struct hv_device *device,
 		return -2;
 	}
 
-	sendMessage.Header.MessageType = NvspMessage1TypeSendRNDISPacket;
+	sendMessage.hdr.msg_type = NVSP_MSG1_TYPE_SEND_RNDIS_PKT;
 	if (packet->is_data_pkt) {
 		/* 0 is RMC_DATA; */
-		sendMessage.Messages.Version1Messages.SendRNDISPacket.ChannelType = 0;
+		sendMessage.msg.v1_msg.send_rndis_pkt.channel_type = 0;
 	} else {
 		/* 1 is RMC_CONTROL; */
-		sendMessage.Messages.Version1Messages.SendRNDISPacket.ChannelType = 1;
+		sendMessage.msg.v1_msg.send_rndis_pkt.channel_type = 1;
 	}
 
 	/* Not using send buffer section */
-	sendMessage.Messages.Version1Messages.SendRNDISPacket.SendBufferSectionIndex = 0xFFFFFFFF;
-	sendMessage.Messages.Version1Messages.SendRNDISPacket.SendBufferSectionSize = 0;
+	sendMessage.msg.v1_msg.send_rndis_pkt.send_buf_section_index =
+		0xFFFFFFFF;
+	sendMessage.msg.v1_msg.send_rndis_pkt.send_buf_section_size = 0;
 
 	if (packet->page_buf_cnt) {
 		ret = vmbus_sendpacket_pagebuffer(device->channel,
@@ -954,7 +955,7 @@ static int netvsc_send(struct hv_device *device,
 		DPRINT_ERR(NETVSC, "Unable to send packet %p ret %d",
 			   packet, ret);
 
-	atomic_inc(&net_device->NumOutstandingSends);
+	atomic_inc(&net_device->num_outstanding_sends);
 	put_net_device(device);
 	return ret;
 }
@@ -997,16 +998,16 @@ static void netvsc_receive(struct hv_device *device,
 			(packet->DataOffset8 << 3));
 
 	/* Make sure this is a valid nvsp packet */
-	if (nvsp_packet->Header.MessageType !=
-	    NvspMessage1TypeSendRNDISPacket) {
+	if (nvsp_packet->hdr.msg_type !=
+	    NVSP_MSG1_TYPE_SEND_RNDIS_PKT) {
 		DPRINT_ERR(NETVSC, "Unknown nvsp packet type received - %d",
-			   nvsp_packet->Header.MessageType);
+			   nvsp_packet->hdr.msg_type);
 		put_net_device(device);
 		return;
 	}
 
 	DPRINT_DBG(NETVSC, "NVSP packet received - type %d",
-		   nvsp_packet->Header.MessageType);
+		   nvsp_packet->hdr.msg_type);
 
 	vmxferpage_packet = (struct vmtransfer_page_packet_header *)packet;
 
@@ -1027,13 +1028,13 @@ static void netvsc_receive(struct hv_device *device,
 	 * We grab it here so that we know exactly how many we can
 	 * fulfil
 	 */
-	spin_lock_irqsave(&net_device->receive_packet_list_lock, flags);
-	while (!list_empty(&net_device->ReceivePacketList)) {
-		list_move_tail(net_device->ReceivePacketList.next, &listHead);
+	spin_lock_irqsave(&net_device->recv_pkt_list_lock, flags);
+	while (!list_empty(&net_device->recv_pkt_list)) {
+		list_move_tail(net_device->recv_pkt_list.next, &listHead);
 		if (++count == vmxferpage_packet->RangeCount + 1)
 			break;
 	}
-	spin_unlock_irqrestore(&net_device->receive_packet_list_lock, flags);
+	spin_unlock_irqrestore(&net_device->recv_pkt_list_lock, flags);
 
 	/*
 	 * We need at least 2 netvsc pkts (1 to represent the xfer
@@ -1046,12 +1047,12 @@ static void netvsc_receive(struct hv_device *device,
 			   count, vmxferpage_packet->RangeCount + 1);
 
 		/* Return it to the freelist */
-		spin_lock_irqsave(&net_device->receive_packet_list_lock, flags);
+		spin_lock_irqsave(&net_device->recv_pkt_list_lock, flags);
 		for (i = count; i != 0; i--) {
 			list_move_tail(listHead.next,
-				       &net_device->ReceivePacketList);
+				       &net_device->recv_pkt_list);
 		}
-		spin_unlock_irqrestore(&net_device->receive_packet_list_lock,
+		spin_unlock_irqrestore(&net_device->recv_pkt_list_lock,
 				       flags);
 
 		netvsc_send_recv_completion(device,
@@ -1104,10 +1105,10 @@ static void netvsc_receive(struct hv_device *device,
 					vmxferpage_packet->Ranges[i].ByteCount;
 
 		start = virt_to_phys((void *)((unsigned long)net_device->
-		ReceiveBuffer + vmxferpage_packet->Ranges[i].ByteOffset));
+		recv_buf + vmxferpage_packet->Ranges[i].ByteOffset));
 
 		netvsc_packet->page_buf[0].Pfn = start >> PAGE_SHIFT;
-		end_virtual = (unsigned long)net_device->ReceiveBuffer
+		end_virtual = (unsigned long)net_device->recv_buf
 		    + vmxferpage_packet->Ranges[i].ByteOffset
 		    + vmxferpage_packet->Ranges[i].ByteCount - 1;
 		end = virt_to_phys((void *)end_virtual);
@@ -1175,11 +1176,12 @@ static void netvsc_send_recv_completion(struct hv_device *device,
 	DPRINT_DBG(NETVSC, "Sending receive completion pkt - %llx",
 		   transaction_id);
 
-	recvcompMessage.Header.MessageType =
-				NvspMessage1TypeSendRNDISPacketComplete;
+	recvcompMessage.hdr.msg_type =
+				NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE;
 
 	/* FIXME: Pass in the status */
-	recvcompMessage.Messages.Version1Messages.SendRNDISPacketComplete.Status = NvspStatusSuccess;
+	recvcompMessage.msg.v1_msg.send_rndis_pkt_complete.status =
+		NVSP_STAT_SUCCESS;
 
 retry_send_cmplt:
 	/* Send the completion */
@@ -1234,7 +1236,7 @@ static void netvsc_receive_completion(void *context)
 	}
 
 	/* Overloading use of the lock. */
-	spin_lock_irqsave(&net_device->receive_packet_list_lock, flags);
+	spin_lock_irqsave(&net_device->recv_pkt_list_lock, flags);
 
 	/* ASSERT(packet->XferPagePacket->Count > 0); */
 	packet->xfer_page_pkt->count--;
@@ -1247,13 +1249,13 @@ static void netvsc_receive_completion(void *context)
 		fsend_receive_comp = true;
 		transaction_id = packet->completion.recv.recv_completion_tid;
 		list_add_tail(&packet->xfer_page_pkt->list_ent,
-			      &net_device->ReceivePacketList);
+			      &net_device->recv_pkt_list);
 
 	}
 
 	/* Put the packet back */
-	list_add_tail(&packet->list_ent, &net_device->ReceivePacketList);
-	spin_unlock_irqrestore(&net_device->receive_packet_list_lock, flags);
+	list_add_tail(&packet->list_ent, &net_device->recv_pkt_list);
+	spin_unlock_irqrestore(&net_device->recv_pkt_list_lock, flags);
 
 	/* Send a receive completion for the xfer page packet */
 	if (fsend_receive_comp)
diff --git a/drivers/staging/hv/netvsc.h b/drivers/staging/hv/netvsc.h
index c71dce5..932a77c 100644
--- a/drivers/staging/hv/netvsc.h
+++ b/drivers/staging/hv/netvsc.h
@@ -38,48 +38,48 @@
 #define NVSP_MAX_PROTOCOL_VERSION	NVSP_PROTOCOL_VERSION_1
 
 enum {
-	NvspMessageTypeNone = 0,
+	NVSP_MSG_TYPE_NONE = 0,
 
 	/* Init Messages */
-	NvspMessageTypeInit			= 1,
-	NvspMessageTypeInitComplete		= 2,
+	NVSP_MSG_TYPE_INIT			= 1,
+	NVSP_MSG_TYPE_INIT_COMPLETE		= 2,
 
-	NvspVersionMessageStart			= 100,
+	NVSP_VERSION_MSG_START			= 100,
 
 	/* Version 1 Messages */
-	NvspMessage1TypeSendNdisVersion		= NvspVersionMessageStart,
+	NVSP_MSG1_TYPE_SEND_NDIS_VER		= NVSP_VERSION_MSG_START,
 
-	NvspMessage1TypeSendReceiveBuffer,
-	NvspMessage1TypeSendReceiveBufferComplete,
-	NvspMessage1TypeRevokeReceiveBuffer,
+	NVSP_MSG1_TYPE_SEND_RECV_BUF,
+	NVSP_MSG1_TYPE_SEND_RECV_BUF_COMPLETE,
+	NVSP_MSG1_TYPE_REVOKE_RECV_BUF,
 
-	NvspMessage1TypeSendSendBuffer,
-	NvspMessage1TypeSendSendBufferComplete,
-	NvspMessage1TypeRevokeSendBuffer,
+	NVSP_MSG1_TYPE_SEND_SEND_BUF,
+	NVSP_MSG1_TYPE_SEND_SEND_BUF_COMPLETE,
+	NVSP_MSG1_TYPE_REVOKE_SEND_BUF,
 
-	NvspMessage1TypeSendRNDISPacket,
-	NvspMessage1TypeSendRNDISPacketComplete,
+	NVSP_MSG1_TYPE_SEND_RNDIS_PKT,
+	NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE,
 
 	/*
 	 * This should be set to the number of messages for the version with
 	 * the maximum number of messages.
 	 */
-	NvspNumMessagePerVersion		= 9,
+	NVSP_NUM_MSG_PER_VERSION		= 9,
 };
 
 enum {
-	NvspStatusNone = 0,
-	NvspStatusSuccess,
-	NvspStatusFailure,
-	NvspStatusProtocolVersionRangeTooNew,
-	NvspStatusProtocolVersionRangeTooOld,
-	NvspStatusInvalidRndisPacket,
-	NvspStatusBusy,
-	NvspStatusMax,
+	NVSP_STAT_NONE = 0,
+	NVSP_STAT_SUCCESS,
+	NVSP_STAT_FAIL,
+	NVSP_STAT_PROTOCOL_TOO_NEW,
+	NVSP_STAT_PROTOCOL_TOO_OLD,
+	NVSP_STAT_INVALID_RNDIS_PKT,
+	NVSP_STAT_BUSY,
+	NVSP_STAT_MAX,
 };
 
 struct nvsp_message_header {
-	u32 MessageType;
+	u32 msg_type;
 };
 
 /* Init Messages */
@@ -90,8 +90,8 @@ struct nvsp_message_header {
  * versioning (i.e. this message will be the same for ever).
  */
 struct nvsp_message_init {
-	u32 MinProtocolVersion;
-	u32 MaxProtocolVersion;
+	u32 min_protocol_ver;
+	u32 max_protocol_ver;
 } __attribute__((packed));
 
 /*
@@ -100,14 +100,14 @@ struct nvsp_message_init {
  * (i.e. this message will be the same for ever).
  */
 struct nvsp_message_init_complete {
-	u32 NegotiatedProtocolVersion;
-	u32 MaximumMdlChainLength;
-	u32 Status;
+	u32 negotiated_protocol_ver;
+	u32 max_mdl_chain_len;
+	u32 status;
 } __attribute__((packed));
 
 union nvsp_message_init_uber {
-	struct nvsp_message_init Init;
-	struct nvsp_message_init_complete InitComplete;
+	struct nvsp_message_init init;
+	struct nvsp_message_init_complete init_complete;
 } __attribute__((packed));
 
 /* Version 1 Messages */
@@ -117,8 +117,8 @@ union nvsp_message_init_uber {
  * can use this information when handling OIDs sent by the VSC.
  */
 struct nvsp_1_message_send_ndis_version {
-	u32 NdisMajorVersion;
-	u32 NdisMinorVersion;
+	u32 ndis_major_ver;
+	u32 ndis_minor_ver;
 } __attribute__((packed));
 
 /*
@@ -126,15 +126,15 @@ struct nvsp_1_message_send_ndis_version {
  * can then use the receive buffer to send data to the VSC.
  */
 struct nvsp_1_message_send_receive_buffer {
-	u32 GpadlHandle;
-	u16 Id;
+	u32 gpadl_handle;
+	u16 id;
 } __attribute__((packed));
 
 struct nvsp_1_receive_buffer_section {
-	u32 Offset;
-	u32 SubAllocationSize;
-	u32 NumSubAllocations;
-	u32 EndOffset;
+	u32 offset;
+	u32 sub_alloc_size;
+	u32 num_sub_allocs;
+	u32 end_offset;
 } __attribute__((packed));
 
 /*
@@ -143,8 +143,8 @@ struct nvsp_1_receive_buffer_section {
  * buffer.
  */
 struct nvsp_1_message_send_receive_buffer_complete {
-	u32 Status;
-	u32 NumSections;
+	u32 status;
+	u32 num_sections;
 
 	/*
 	 * The receive buffer is split into two parts, a large suballocation
@@ -165,7 +165,7 @@ struct nvsp_1_message_send_receive_buffer_complete {
 	 *  LargeOffset                            SmallOffset
 	 */
 
-	struct nvsp_1_receive_buffer_section Sections[1];
+	struct nvsp_1_receive_buffer_section sections[1];
 } __attribute__((packed));
 
 /*
@@ -174,7 +174,7 @@ struct nvsp_1_message_send_receive_buffer_complete {
  * again.
  */
 struct nvsp_1_message_revoke_receive_buffer {
-	u16 Id;
+	u16 id;
 };
 
 /*
@@ -182,8 +182,8 @@ struct nvsp_1_message_revoke_receive_buffer {
  * can then use the send buffer to send data to the VSP.
  */
 struct nvsp_1_message_send_send_buffer {
-	u32 GpadlHandle;
-	u16 Id;
+	u32 gpadl_handle;
+	u16 id;
 } __attribute__((packed));
 
 /*
@@ -192,7 +192,7 @@ struct nvsp_1_message_send_send_buffer {
  * buffer.
  */
 struct nvsp_1_message_send_send_buffer_complete {
-	u32 Status;
+	u32 status;
 
 	/*
 	 * The VSC gets to choose the size of the send buffer and the VSP gets
@@ -200,7 +200,7 @@ struct nvsp_1_message_send_send_buffer_complete {
 	 * dynamic reconfigurations when the cost of GPA-direct buffers
 	 * decreases.
 	 */
-	u32 SectionSize;
+	u32 section_size;
 } __attribute__((packed));
 
 /*
@@ -208,7 +208,7 @@ struct nvsp_1_message_send_send_buffer_complete {
  * completes this transaction, the vsp should never use the send buffer again.
  */
 struct nvsp_1_message_revoke_send_buffer {
-	u16 Id;
+	u16 id;
 };
 
 /*
@@ -221,7 +221,7 @@ struct nvsp_1_message_send_rndis_packet {
 	 * channels of communication. However, the Network VSP only has one.
 	 * Therefore, the channel travels with the RNDIS packet.
 	 */
-	u32 ChannelType;
+	u32 channel_type;
 
 	/*
 	 * This field is used to send part or all of the data through a send
@@ -229,8 +229,8 @@ struct nvsp_1_message_send_rndis_packet {
 	 * index is 0xFFFFFFFF, then the send buffer is not being used and all
 	 * of the data was sent through other VMBus mechanisms.
 	 */
-	u32 SendBufferSectionIndex;
-	u32 SendBufferSectionSize;
+	u32 send_buf_section_index;
+	u32 send_buf_section_size;
 } __attribute__((packed));
 
 /*
@@ -239,35 +239,35 @@ struct nvsp_1_message_send_rndis_packet {
  * message cannot use any resources associated with the original RNDIS packet.
  */
 struct nvsp_1_message_send_rndis_packet_complete {
-	u32 Status;
+	u32 status;
 };
 
 union nvsp_1_message_uber {
-	struct nvsp_1_message_send_ndis_version SendNdisVersion;
+	struct nvsp_1_message_send_ndis_version send_ndis_ver;
 
-	struct nvsp_1_message_send_receive_buffer SendReceiveBuffer;
+	struct nvsp_1_message_send_receive_buffer send_recv_buf;
 	struct nvsp_1_message_send_receive_buffer_complete
-						SendReceiveBufferComplete;
-	struct nvsp_1_message_revoke_receive_buffer RevokeReceiveBuffer;
+						send_recv_buf_complete;
+	struct nvsp_1_message_revoke_receive_buffer revoke_recv_buf;
 
-	struct nvsp_1_message_send_send_buffer SendSendBuffer;
-	struct nvsp_1_message_send_send_buffer_complete SendSendBufferComplete;
-	struct nvsp_1_message_revoke_send_buffer RevokeSendBuffer;
+	struct nvsp_1_message_send_send_buffer send_send_buf;
+	struct nvsp_1_message_send_send_buffer_complete send_send_buf_complete;
+	struct nvsp_1_message_revoke_send_buffer revoke_send_buf;
 
-	struct nvsp_1_message_send_rndis_packet SendRNDISPacket;
+	struct nvsp_1_message_send_rndis_packet send_rndis_pkt;
 	struct nvsp_1_message_send_rndis_packet_complete
-						SendRNDISPacketComplete;
+						send_rndis_pkt_complete;
 } __attribute__((packed));
 
 union nvsp_all_messages {
-	union nvsp_message_init_uber InitMessages;
-	union nvsp_1_message_uber Version1Messages;
+	union nvsp_message_init_uber init_msg;
+	union nvsp_1_message_uber v1_msg;
 } __attribute__((packed));
 
 /* ALL Messages */
 struct nvsp_message {
-	struct nvsp_message_header Header;
-	union nvsp_all_messages Messages;
+	struct nvsp_message_header hdr;
+	union nvsp_all_messages msg;
 } __attribute__((packed));
 
 
@@ -293,39 +293,39 @@ struct nvsp_message {
 
 /* Per netvsc channel-specific */
 struct netvsc_device {
-	struct hv_device *Device;
+	struct hv_device *dev;
 
-	atomic_t RefCount;
-	atomic_t NumOutstandingSends;
+	atomic_t refcnt;
+	atomic_t num_outstanding_sends;
 	/*
 	 * List of free preallocated hv_netvsc_packet to represent receive
 	 * packet
 	 */
-	struct list_head ReceivePacketList;
-	spinlock_t receive_packet_list_lock;
+	struct list_head recv_pkt_list;
+	spinlock_t recv_pkt_list_lock;
 
 	/* Send buffer allocated by us but manages by NetVSP */
-	void *SendBuffer;
-	u32 SendBufferSize;
-	u32 SendBufferGpadlHandle;
-	u32 SendSectionSize;
+	void *send_buf;
+	u32 send_buf_size;
+	u32 send_buf_gpadl_handle;
+	u32 send_section_size;
 
 	/* Receive buffer allocated by us but manages by NetVSP */
-	void *ReceiveBuffer;
-	u32 ReceiveBufferSize;
-	u32 ReceiveBufferGpadlHandle;
-	u32 ReceiveSectionCount;
-	struct nvsp_1_receive_buffer_section *ReceiveSections;
+	void *recv_buf;
+	u32 recv_buf_size;
+	u32 recv_buf_gpadl_handle;
+	u32 recv_section_cnt;
+	struct nvsp_1_receive_buffer_section *recv_section;
 
 	/* Used for NetVSP initialization protocol */
-	struct osd_waitevent *ChannelInitEvent;
-	struct nvsp_message ChannelInitPacket;
+	struct osd_waitevent *channel_init_event;
+	struct nvsp_message channel_init_pkt;
 
-	struct nvsp_message RevokePacket;
+	struct nvsp_message revoke_packet;
 	/* unsigned char HwMacAddr[HW_MACADDR_LEN]; */
 
 	/* Holds rndis device info */
-	void *Extension;
+	void *extension;
 };
 
 #endif /* _NETVSC_H_ */
diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
index ac40db5..b4bed36 100644
--- a/drivers/staging/hv/netvsc_api.h
+++ b/drivers/staging/hv/netvsc_api.h
@@ -95,7 +95,7 @@ struct netvsc_driver {
 	 */
 	int (*recv_cb)(struct hv_device *dev,
 				 struct hv_netvsc_packet *packet);
-	void (*link_status_change)(struct hv_device *dev, u32 Status);
+	void (*link_status_change)(struct hv_device *dev, u32 status);
 
 	/* Specific to this driver */
 	int (*send)(struct hv_device *dev, struct hv_netvsc_packet *packet);
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index dffcc03..63d24c6 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -266,7 +266,7 @@ static int rndis_filter_send_request(struct rndis_device *dev,
 		rndis_filter_send_request_completion;
 	packet->completion.send.send_completion_tid = (unsigned long)dev;
 
-	ret = rndis_filter.inner_drv.send(dev->net_dev->Device, packet);
+	ret = rndis_filter.inner_drv.send(dev->net_dev->dev, packet);
 	return ret;
 }
 
@@ -338,10 +338,10 @@ static void rndis_filter_receive_indicate_status(struct rndis_device *dev,
 
 	if (indicate->Status == RNDIS_STATUS_MEDIA_CONNECT) {
 		rndis_filter.inner_drv.link_status_change(
-			dev->net_dev->Device, 1);
+			dev->net_dev->dev, 1);
 	} else if (indicate->Status == RNDIS_STATUS_MEDIA_DISCONNECT) {
 		rndis_filter.inner_drv.link_status_change(
-			dev->net_dev->Device, 0);
+			dev->net_dev->dev, 0);
 	} else {
 		/*
 		 * TODO:
@@ -376,7 +376,7 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 
 	pkt->is_data_pkt = true;
 
-	rndis_filter.inner_drv.recv_cb(dev->net_dev->Device,
+	rndis_filter.inner_drv.recv_cb(dev->net_dev->dev,
 						   pkt);
 }
 
@@ -392,13 +392,13 @@ static int rndis_filter_receive(struct hv_device *dev,
 		return -EINVAL;
 
 	/* Make sure the rndis device state is initialized */
-	if (!net_dev->Extension) {
+	if (!net_dev->extension) {
 		DPRINT_ERR(NETVSC, "got rndis message but no rndis device..."
 			  "dropping this message!");
 		return -1;
 	}
 
-	rndis_dev = (struct rndis_device *)net_dev->Extension;
+	rndis_dev = (struct rndis_device *)net_dev->extension;
 	if (rndis_dev->state == RNDIS_DEV_UNINITIALIZED) {
 		DPRINT_ERR(NETVSC, "got rndis message but rndis device "
 			   "uninitialized...dropping this message!");
@@ -782,7 +782,7 @@ static int rndis_filte_device_add(struct hv_device *dev,
 	/* ASSERT(netDevice); */
 	/* ASSERT(netDevice->Device); */
 
-	netDevice->Extension = rndisDevice;
+	netDevice->extension = rndisDevice;
 	rndisDevice->net_dev = netDevice;
 
 	/* Send the rndis initialization message */
@@ -819,13 +819,13 @@ static int rndis_filte_device_add(struct hv_device *dev,
 static int rndis_filter_device_remove(struct hv_device *dev)
 {
 	struct netvsc_device *net_dev = dev->Extension;
-	struct rndis_device *rndis_dev = net_dev->Extension;
+	struct rndis_device *rndis_dev = net_dev->extension;
 
 	/* Halt and release the rndis device */
 	rndis_filter_halt_device(rndis_dev);
 
 	kfree(rndis_dev);
-	net_dev->Extension = NULL;
+	net_dev->extension = NULL;
 
 	/* Pass control to inner driver to remove the device */
 	rndis_filter.inner_drv.base.OnDeviceRemove(dev);
@@ -844,7 +844,7 @@ int rndis_filter_open(struct hv_device *dev)
 	if (!netDevice)
 		return -EINVAL;
 
-	return rndis_filter_open_device(netDevice->Extension);
+	return rndis_filter_open_device(netDevice->extension);
 }
 
 int rndis_filter_close(struct hv_device *dev)
@@ -854,7 +854,7 @@ int rndis_filter_close(struct hv_device *dev)
 	if (!netDevice)
 		return -EINVAL;
 
-	return rndis_filter_close_device(netDevice->Extension);
+	return rndis_filter_close_device(netDevice->extension);
 }
 
 static int rndis_filter_send(struct hv_device *dev,
-- 
1.6.3.2

