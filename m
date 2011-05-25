Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab1EYVsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:48:07 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39813
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754450Ab1EYVsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:48:02 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 1/1] staging: hv: remove netvsc send buffer and related functions
Date: Wed, 25 May 2011 15:02:24 -0700
Message-Id: <1306360944-9796-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netvsc send buffer is not used, so remove it.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/hyperv_net.h |   10 ---
 drivers/staging/hv/netvsc.c     |  161 ---------------------------------------
 2 files changed, 0 insertions(+), 171 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index cf762bd..27f987b 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -355,10 +355,6 @@ struct nvsp_message {
 /* #define NVSC_MIN_PROTOCOL_VERSION		1 */
 /* #define NVSC_MAX_PROTOCOL_VERSION		1 */
 
-#define NETVSC_SEND_BUFFER_SIZE			(64*1024)	/* 64K */
-#define NETVSC_SEND_BUFFER_ID			0xface
-
-
 #define NETVSC_RECEIVE_BUFFER_SIZE		(1024*1024)	/* 1MB */
 
 #define NETVSC_RECEIVE_BUFFER_ID		0xcafe
@@ -383,12 +379,6 @@ struct netvsc_device {
 	struct list_head recv_pkt_list;
 	spinlock_t recv_pkt_list_lock;
 
-	/* Send buffer allocated by us but manages by NetVSP */
-	void *send_buf;
-	u32 send_buf_size;
-	u32 send_buf_gpadl_handle;
-	u32 send_section_size;
-
 	/* Receive buffer allocated by us but manages by NetVSP */
 	void *recv_buf;
 	u32 recv_buf_size;
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 41cbb26..7b5bf0d 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -323,162 +323,6 @@ exit:
 	return ret;
 }
 
-static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
-{
-	struct nvsp_message *revoke_packet;
-	int ret = 0;
-
-	/*
-	 * If we got a section count, it means we received a
-	 *  SendReceiveBufferComplete msg (ie sent
-	 *  NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
-	 *  to send a revoke msg here
-	 */
-	if (net_device->send_section_size) {
-		/* Send the revoke send buffer */
-		revoke_packet = &net_device->revoke_packet;
-		memset(revoke_packet, 0, sizeof(struct nvsp_message));
-
-		revoke_packet->hdr.msg_type =
-			NVSP_MSG1_TYPE_REVOKE_SEND_BUF;
-		revoke_packet->msg.v1_msg.
-			revoke_send_buf.id = NETVSC_SEND_BUFFER_ID;
-
-		ret = vmbus_sendpacket(net_device->dev->channel,
-				       revoke_packet,
-				       sizeof(struct nvsp_message),
-				       (unsigned long)revoke_packet,
-				       VM_PKT_DATA_INBAND, 0);
-		/*
-		 * If we failed here, we might as well return and have a leak
-		 * rather than continue and a bugchk
-		 */
-		if (ret != 0) {
-			dev_err(&net_device->dev->device, "unable to send "
-				"revoke send buffer to netvsp");
-			return -1;
-		}
-	}
-
-	/* Teardown the gpadl on the vsp end */
-	if (net_device->send_buf_gpadl_handle) {
-		ret = vmbus_teardown_gpadl(net_device->dev->channel,
-					   net_device->send_buf_gpadl_handle);
-
-		/*
-		 * If we failed here, we might as well return and have a leak
-		 * rather than continue and a bugchk
-		 */
-		if (ret != 0) {
-			dev_err(&net_device->dev->device,
-				"unable to teardown send buffer's gpadl");
-			return -1;
-		}
-		net_device->send_buf_gpadl_handle = 0;
-	}
-
-	if (net_device->send_buf) {
-		/* Free up the receive buffer */
-		free_pages((unsigned long)net_device->send_buf,
-				get_order(net_device->send_buf_size));
-		net_device->send_buf = NULL;
-	}
-
-	return ret;
-}
-
-static int netvsc_init_send_buf(struct hv_device *device)
-{
-	int ret = 0;
-	int t;
-	struct netvsc_device *net_device;
-	struct nvsp_message *init_packet;
-
-	net_device = get_outbound_net_device(device);
-	if (!net_device) {
-		dev_err(&device->device, "unable to get net device..."
-			   "device being destroyed?");
-		return -1;
-	}
-	if (net_device->send_buf_size <= 0) {
-		ret = -EINVAL;
-		goto cleanup;
-	}
-
-	net_device->send_buf =
-		(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
-				get_order(net_device->send_buf_size));
-	if (!net_device->send_buf) {
-		dev_err(&device->device, "unable to allocate send "
-			"buffer of size %d", net_device->send_buf_size);
-		ret = -1;
-		goto cleanup;
-	}
-
-	/*
-	 * Establish the gpadl handle for this buffer on this
-	 * channel.  Note: This call uses the vmbus connection rather
-	 * than the channel to establish the gpadl handle.
-	 */
-	ret = vmbus_establish_gpadl(device->channel, net_device->send_buf,
-				    net_device->send_buf_size,
-				    &net_device->send_buf_gpadl_handle);
-	if (ret != 0) {
-		dev_err(&device->device, "unable to establish send buffer's gpadl");
-		goto cleanup;
-	}
-
-	/* Notify the NetVsp of the gpadl handle */
-	init_packet = &net_device->channel_init_pkt;
-
-	memset(init_packet, 0, sizeof(struct nvsp_message));
-
-	init_packet->hdr.msg_type = NVSP_MSG1_TYPE_SEND_SEND_BUF;
-	init_packet->msg.v1_msg.send_recv_buf.
-		gpadl_handle = net_device->send_buf_gpadl_handle;
-	init_packet->msg.v1_msg.send_recv_buf.id =
-		NETVSC_SEND_BUFFER_ID;
-
-	/* Send the gpadl notification request */
-	ret = vmbus_sendpacket(device->channel, init_packet,
-			       sizeof(struct nvsp_message),
-			       (unsigned long)init_packet,
-			       VM_PKT_DATA_INBAND,
-			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0) {
-		dev_err(&device->device,
-			   "unable to send receive buffer's gpadl to netvsp");
-		goto cleanup;
-	}
-
-	t = wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
-
-	BUG_ON(t == 0);
-
-	/* Check the response */
-	if (init_packet->msg.v1_msg.
-	    send_send_buf_complete.status != NVSP_STAT_SUCCESS) {
-		dev_err(&device->device, "Unable to complete send buffer "
-			   "initialzation with NetVsp - status %d",
-			   init_packet->msg.v1_msg.
-			   send_send_buf_complete.status);
-		ret = -1;
-		goto cleanup;
-	}
-
-	net_device->send_section_size = init_packet->
-	msg.v1_msg.send_send_buf_complete.section_size;
-
-	goto exit;
-
-cleanup:
-	netvsc_destroy_send_buf(net_device);
-
-exit:
-	put_net_device(device);
-	return ret;
-}
-
 
 static int netvsc_connect_vsp(struct hv_device *device)
 {
@@ -556,8 +400,6 @@ static int netvsc_connect_vsp(struct hv_device *device)
 
 	/* Post the big receive buffer to NetVSP */
 	ret = netvsc_init_recv_buf(device);
-	if (ret == 0)
-		ret = netvsc_init_send_buf(device);
 
 cleanup:
 	put_net_device(device);
@@ -567,7 +409,6 @@ cleanup:
 static void netvsc_disconnect_vsp(struct netvsc_device *net_device)
 {
 	netvsc_destroy_recv_buf(net_device);
-	netvsc_destroy_send_buf(net_device);
 }
 
 /*
@@ -1099,8 +940,6 @@ int netvsc_device_add(struct hv_device *device, void *additional_info)
 	net_device->recv_buf_size = NETVSC_RECEIVE_BUFFER_SIZE;
 	spin_lock_init(&net_device->recv_pkt_list_lock);
 
-	net_device->send_buf_size = NETVSC_SEND_BUFFER_SIZE;
-
 	INIT_LIST_HEAD(&net_device->recv_pkt_list);
 
 	for (i = 0; i < NETVSC_RECEIVE_PACKETLIST_COUNT; i++) {
-- 
1.6.3.2

