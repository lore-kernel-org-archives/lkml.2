Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab1C2UsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:48:16 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54078
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754039Ab1C2UsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:48:09 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 02/07] Remove all unneeded DPRINT from hv_netvsc
Date: Tue, 29 Mar 2011 13:58:45 -0700
Message-Id: <1301432330-1705-3-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
References: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all un-needed DPRINT calls from hv_netvsc.

This patch deals with hv_netvsc only.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/netvsc.c       |  102 ++-----------------------------------
 drivers/staging/hv/netvsc_drv.c   |   10 ----
 drivers/staging/hv/rndis_filter.c |   13 -----
 3 files changed, 4 insertions(+), 121 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 20b1597..be572b4 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -178,13 +178,6 @@ int netvsc_initialize(struct hv_driver *drv)
 {
 	struct netvsc_driver *driver = (struct netvsc_driver *)drv;
 
-	DPRINT_DBG(NETVSC, "sizeof(struct hv_netvsc_packet)=%zd, "
-		   "sizeof(struct nvsp_message)=%zd, "
-		   "sizeof(struct vmtransfer_page_packet_header)=%zd",
-		   sizeof(struct hv_netvsc_packet),
-		   sizeof(struct nvsp_message),
-		   sizeof(struct vmtransfer_page_packet_header));
-
 	drv->name = driver_name;
 	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(struct hv_guid));
 
@@ -223,8 +216,6 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		goto cleanup;
 	}
 
-	DPRINT_INFO(NETVSC, "Establishing receive buffer's GPADL...");
-
 	/*
 	 * Establish the gpadl handle for this buffer on this
 	 * channel.  Note: This call uses the vmbus connection rather
@@ -241,8 +232,6 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 
 
 	/* Notify the NetVsp of the gpadl handle */
-	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendReceiveBuffer...");
-
 	init_packet = &net_device->channel_init_pkt;
 
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -301,14 +290,6 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		net_device->recv_section_cnt *
 	       sizeof(struct nvsp_1_receive_buffer_section));
 
-	DPRINT_INFO(NETVSC, "Receive sections info (count %d, offset %d, "
-		    "endoffset %d, suballoc size %d, num suballocs %d)",
-		    net_device->recv_section_cnt,
-		    net_device->recv_section[0].offset,
-		    net_device->recv_section[0].end_offset,
-		    net_device->recv_section[0].sub_alloc_size,
-		    net_device->recv_section[0].num_sub_allocs);
-
 	/*
 	 * For 1st release, there should only be 1 section that represents the
 	 * entire receive buffer
@@ -356,8 +337,6 @@ static int netvsc_init_send_buf(struct hv_device *device)
 		goto cleanup;
 	}
 
-	DPRINT_INFO(NETVSC, "Establishing send buffer's GPADL...");
-
 	/*
 	 * Establish the gpadl handle for this buffer on this
 	 * channel.  Note: This call uses the vmbus connection rather
@@ -372,8 +351,6 @@ static int netvsc_init_send_buf(struct hv_device *device)
 	}
 
 	/* Notify the NetVsp of the gpadl handle */
-	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendSendBuffer...");
-
 	init_packet = &net_device->channel_init_pkt;
 
 	memset(init_packet, 0, sizeof(struct nvsp_message));
@@ -438,9 +415,6 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 	 * to send a revoke msg here
 	 */
 	if (net_device->recv_section_cnt) {
-		DPRINT_INFO(NETVSC,
-			    "Sending NvspMessage1TypeRevokeReceiveBuffer...");
-
 		/* Send the revoke receive buffer */
 		revoke_packet = &net_device->revoke_packet;
 		memset(revoke_packet, 0, sizeof(struct nvsp_message));
@@ -468,8 +442,6 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 
 	/* Teardown the gpadl on the vsp end */
 	if (net_device->recv_buf_gpadl_handle) {
-		DPRINT_INFO(NETVSC, "Tearing down receive buffer's GPADL...");
-
 		ret = vmbus_teardown_gpadl(net_device->dev->channel,
 			   net_device->recv_buf_gpadl_handle);
 
@@ -483,8 +455,6 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 	}
 
 	if (net_device->recv_buf) {
-		DPRINT_INFO(NETVSC, "Freeing up receive buffer...");
-
 		/* Free up the receive buffer */
 		free_pages((unsigned long)net_device->recv_buf,
 			get_order(net_device->recv_buf_size));
@@ -512,9 +482,6 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 	 *  to send a revoke msg here
 	 */
 	if (net_device->send_section_size) {
-		DPRINT_INFO(NETVSC,
-			    "Sending NvspMessage1TypeRevokeSendBuffer...");
-
 		/* Send the revoke send buffer */
 		revoke_packet = &net_device->revoke_packet;
 		memset(revoke_packet, 0, sizeof(struct nvsp_message));
@@ -542,7 +509,6 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 
 	/* Teardown the gpadl on the vsp end */
 	if (net_device->send_buf_gpadl_handle) {
-		DPRINT_INFO(NETVSC, "Tearing down send buffer's GPADL...");
 		ret = vmbus_teardown_gpadl(net_device->dev->channel,
 					   net_device->send_buf_gpadl_handle);
 
@@ -559,8 +525,6 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 	}
 
 	if (net_device->send_buf) {
-		DPRINT_INFO(NETVSC, "Freeing up send buffer...");
-
 		/* Free up the receive buffer */
 		free_pages((unsigned long)net_device->send_buf,
 				get_order(net_device->send_buf_size));
@@ -594,8 +558,6 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	init_packet->msg.init_msg.init.max_protocol_ver =
 		NVSP_MAX_PROTOCOL_VERSION;
 
-	DPRINT_INFO(NETVSC, "Sending NvspMessageTypeInit...");
-
 	/* Send the init request */
 	net_device->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, init_packet,
@@ -604,10 +566,8 @@ static int netvsc_connect_vsp(struct hv_device *device)
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
-	if (ret != 0) {
-		DPRINT_ERR(NETVSC, "unable to send NvspMessageTypeInit");
+	if (ret != 0)
 		goto cleanup;
-	}
 
 	wait_event_timeout(net_device->channel_init_wait,
 			net_device->wait_condition,
@@ -617,31 +577,17 @@ static int netvsc_connect_vsp(struct hv_device *device)
 		goto cleanup;
 	}
 
-	DPRINT_INFO(NETVSC, "NvspMessageTypeInit status(%d) max mdl chain (%d)",
-		init_packet->msg.init_msg.init_complete.status,
-		init_packet->msg.init_msg.
-		    init_complete.max_mdl_chain_len);
-
-	if (init_packet->msg.init_msg.init_complete.status !=
+	if (init_packet->msg.init_msg.init_complete.status !=
 	    NVSP_STAT_SUCCESS) {
-		DPRINT_ERR(NETVSC,
-			"unable to initialize with netvsp (status 0x%x)",
-			init_packet->msg.init_msg.init_complete.status);
 		ret = -1;
 		goto cleanup;
 	}
 
 	if (init_packet->msg.init_msg.init_complete.
 	    negotiated_protocol_ver != NVSP_PROTOCOL_VERSION_1) {
-		DPRINT_ERR(NETVSC, "unable to initialize with netvsp "
-			   "(version expected 1 got %d)",
-			   init_packet->msg.init_msg.
-			   init_complete.negotiated_protocol_ver);
 		ret = -1;
 		goto cleanup;
 	}
-	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendNdisVersion...");
-
 	/* Send the ndis version */
 	memset(init_packet, 0, sizeof(struct nvsp_message));
 
@@ -661,8 +607,6 @@ static int netvsc_connect_vsp(struct hv_device *device)
 				(unsigned long)init_packet,
 				VM_PKT_DATA_INBAND, 0);
 	if (ret != 0) {
-		DPRINT_ERR(NETVSC,
-			   "unable to send NvspMessage1TypeSendNdisVersion");
 		ret = -1;
 		goto cleanup;
 	}
@@ -702,8 +646,6 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 		goto cleanup;
 	}
 
-	DPRINT_DBG(NETVSC, "netvsc channel object allocated - %p", net_device);
-
 	/* Initialize the NetVSC channel extension */
 	net_device->recv_buf_size = NETVSC_RECEIVE_BUFFER_SIZE;
 	spin_lock_init(&net_device->recv_pkt_list_lock);
@@ -716,12 +658,9 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 		packet = kzalloc(sizeof(struct hv_netvsc_packet) +
 				 (NETVSC_RECEIVE_SG_COUNT *
 				  sizeof(struct hv_page_buffer)), GFP_KERNEL);
-		if (!packet) {
-			DPRINT_DBG(NETVSC, "unable to allocate netvsc pkts "
-				   "for receive pool (wanted %d got %d)",
-				   NETVSC_RECEIVE_PACKETLIST_COUNT, i);
+		if (!packet)
 			break;
-		}
+
 		list_add_tail(&packet->list_ent,
 			      &net_device->recv_pkt_list);
 	}
@@ -749,9 +688,6 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 		goto close;
 	}
 
-	DPRINT_INFO(NETVSC, "*** NetVSC channel handshake result - %d ***",
-		    ret);
-
 	return ret;
 
 close:
@@ -785,9 +721,6 @@ static int netvsc_device_remove(struct hv_device *device)
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *netvsc_packet, *pos;
 
-	DPRINT_INFO(NETVSC, "Disabling outbound traffic on net device (%p)...",
-		    device->ext);
-
 	/* Stop outbound traffic ie sends and receives completions */
 	net_device = release_outbound_net_device(device);
 	if (!net_device) {
@@ -802,13 +735,8 @@ static int netvsc_device_remove(struct hv_device *device)
 		udelay(100);
 	}
 
-	DPRINT_INFO(NETVSC, "Disconnecting from netvsp...");
-
 	NetVscDisconnectFromVsp(net_device);
 
-	DPRINT_INFO(NETVSC, "Disabling inbound traffic on net device (%p)...",
-		    device->ext);
-
 	/* Stop inbound traffic ie receives and sends completions */
 	net_device = release_inbound_net_device(device);
 
@@ -853,9 +781,6 @@ static void netvsc_send_completion(struct hv_device *device,
 	nvsp_packet = (struct nvsp_message *)((unsigned long)packet +
 			(packet->offset8 << 3));
 
-	DPRINT_DBG(NETVSC, "send completion packet - type %d",
-		   nvsp_packet->hdr.msg_type);
-
 	if ((nvsp_packet->hdr.msg_type == NVSP_MSG_TYPE_INIT_COMPLETE) ||
 	    (nvsp_packet->hdr.msg_type ==
 	     NVSP_MSG1_TYPE_SEND_RECV_BUF_COMPLETE) ||
@@ -985,9 +910,6 @@ static void netvsc_receive(struct hv_device *device,
 		return;
 	}
 
-	DPRINT_DBG(NETVSC, "NVSP packet received - type %d",
-		   nvsp_packet->hdr.msg_type);
-
 	vmxferpage_packet = (struct vmtransfer_page_packet_header *)packet;
 
 	if (vmxferpage_packet->xfer_pageset_id != NETVSC_RECEIVE_BUFFER_ID) {
@@ -998,9 +920,6 @@ static void netvsc_receive(struct hv_device *device,
 		return;
 	}
 
-	DPRINT_DBG(NETVSC, "xfer page - range count %d",
-		   vmxferpage_packet->range_cnt);
-
 	/*
 	 * Grab free packets (range count + 1) to represent this xfer
 	 * page packet. +1 to represent the xfer page packet itself.
@@ -1117,13 +1036,6 @@ static void netvsc_receive(struct hv_device *device,
 					break;
 			}
 		}
-		DPRINT_DBG(NETVSC, "[%d] - (abs offset %u len %u) => "
-			   "(pfn %llx, offset %u, len %u)", i,
-			   vmxferpage_packet->ranges[i].byte_offset,
-			   vmxferpage_packet->ranges[i].byte_count,
-			   netvsc_packet->page_buf[0].pfn,
-			   netvsc_packet->page_buf[0].offset,
-			   netvsc_packet->page_buf[0].len);
 
 		/* Pass it to the upper layer */
 		((struct netvsc_driver *)device->drv)->
@@ -1143,9 +1055,6 @@ static void netvsc_send_recv_completion(struct hv_device *device,
 	int retries = 0;
 	int ret;
 
-	DPRINT_DBG(NETVSC, "Sending receive completion pkt - %llx",
-		   transaction_id);
-
 	recvcompMessage.hdr.msg_type =
 				NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE;
 
@@ -1261,9 +1170,6 @@ static void netvsc_channel_cb(void *context)
 					   &bytes_recvd, &request_id);
 		if (ret == 0) {
 			if (bytes_recvd > 0) {
-				DPRINT_DBG(NETVSC, "receive %d bytes, tid %llx",
-					   bytes_recvd, request_id);
-
 				desc = (struct vmpacket_descriptor *)buffer;
 				switch (desc->type) {
 				case VM_PKT_COMP:
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 2d40f5f..1772a19 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -136,9 +136,6 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	int ret;
 	unsigned int i, num_pages;
 
-	DPRINT_DBG(NETVSC_DRV, "xmit packet - len %d data_len %d",
-		   skb->len, skb->data_len);
-
 	/* Add 1 for skb->data and additional one for RNDIS */
 	num_pages = skb_shinfo(skb)->nr_frags + 1 + 1;
 	if (num_pages > net_device_ctx->avail)
@@ -196,10 +193,6 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 		net->stats.tx_bytes += skb->len;
 		net->stats.tx_packets++;
 
-		DPRINT_DBG(NETVSC_DRV, "# of xmits %lu total size %lu",
-			   net->stats.tx_packets,
-			   net->stats.tx_bytes);
-
 		net_device_ctx->avail -= num_pages;
 		if (net_device_ctx->avail < PACKET_PAGES_LOWATER)
 			netif_stop_queue(net);
@@ -297,9 +290,6 @@ static int netvsc_recv_callback(struct hv_device *device_obj,
 	 */
 	netif_rx(skb);
 
-	DPRINT_DBG(NETVSC_DRV, "# of recvs %lu total size %lu",
-		   net->stats.rx_packets, net->stats.rx_bytes);
-
 	return 0;
 }
 
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index e7189cd..d1b13dc 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -283,14 +283,6 @@ static void rndis_filter_receive_response(struct rndis_device *dev,
 		 */
 		if (request->request_msg.msg.init_req.req_id
 		    == resp->msg.init_complete.req_id) {
-			DPRINT_DBG(NETVSC, "found rndis request for "
-				"this response (id 0x%x req type 0x%x res "
-				"type 0x%x)",
-				request->request_msg.msg.
-				   init_req.req_id,
-				request->request_msg.ndis_msg_type,
-				resp->ndis_msg_type);
-
 			found = true;
 			break;
 		}
@@ -605,9 +597,6 @@ Exit:
 
 int rndis_filter_init(struct netvsc_driver *drv)
 {
-	DPRINT_DBG(NETVSC, "sizeof(struct rndis_filter_packet) == %zd",
-		   sizeof(struct rndis_filter_packet));
-
 	drv->req_ext_size = sizeof(struct rndis_filter_packet);
 
 	/* Driver->Context = rndisDriver; */
@@ -765,8 +754,6 @@ static int rndis_filte_device_add(struct hv_device *dev,
 	if (!rndisDevice)
 		return -1;
 
-	DPRINT_DBG(NETVSC, "rndis device object allocated - %p", rndisDevice);
-
 	/*
 	 * Let the inner driver handle this first to create the netvsc channel
 	 * NOTE! Once the channel is created, we may get a receive callback
-- 
1.6.0.2

