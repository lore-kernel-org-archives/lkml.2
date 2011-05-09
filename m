Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1EIVtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:49:49 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47711
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755074Ab1EIVoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 115/206] Staging: hv: Use completion abstraction in struct netvsc_device
Date: Mon,  9 May 2011 14:56:37 -0700
Message-Id: <1304978288-22999-115-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use completion abstraction in struct netvsc_device instead of 
struct wait_queue_head_t to synchronize.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   32 +++++++++++++-------------------
 drivers/staging/hv/netvsc.h |    3 +--
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 832f62e..4eb4482 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -213,6 +213,7 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 static int netvsc_init_recv_buf(struct hv_device *device)
 {
 	int ret = 0;
+	int t;
 	struct netvsc_device *net_device;
 	struct nvsp_message *init_packet;
 
@@ -260,7 +261,6 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		send_recv_buf.id = NETVSC_RECEIVE_BUFFER_ID;
 
 	/* Send the gpadl notification request */
-	net_device->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
@@ -272,10 +272,8 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		goto cleanup;
 	}
 
-	wait_event_timeout(net_device->channel_init_wait,
-			net_device->wait_condition,
-			msecs_to_jiffies(1000));
-	BUG_ON(net_device->wait_condition == 0);
+	t = wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
+	BUG_ON(t == 0);
 
 
 	/* Check the response */
@@ -394,6 +392,7 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 static int netvsc_init_send_buf(struct hv_device *device)
 {
 	int ret = 0;
+	int t;
 	struct netvsc_device *net_device;
 	struct nvsp_message *init_packet;
 
@@ -443,7 +442,6 @@ static int netvsc_init_send_buf(struct hv_device *device)
 		NETVSC_SEND_BUFFER_ID;
 
 	/* Send the gpadl notification request */
-	net_device->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
@@ -455,10 +453,9 @@ static int netvsc_init_send_buf(struct hv_device *device)
 		goto cleanup;
 	}
 
-	wait_event_timeout(net_device->channel_init_wait,
-			net_device->wait_condition,
-			msecs_to_jiffies(1000));
-	BUG_ON(net_device->wait_condition == 0);
+	t = wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
+
+	BUG_ON(t == 0);
 
 	/* Check the response */
 	if (init_packet->msg.v1_msg.
@@ -487,7 +484,7 @@ exit:
 
 static int netvsc_connect_vsp(struct hv_device *device)
 {
-	int ret;
+	int ret, t;
 	struct netvsc_device *net_device;
 	struct nvsp_message *init_packet;
 	int ndis_version;
@@ -509,7 +506,6 @@ static int netvsc_connect_vsp(struct hv_device *device)
 		NVSP_MAX_PROTOCOL_VERSION;
 
 	/* Send the init request */
-	net_device->wait_condition = 0;
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
@@ -519,10 +515,9 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	if (ret != 0)
 		goto cleanup;
 
-	wait_event_timeout(net_device->channel_init_wait,
-			net_device->wait_condition,
-			msecs_to_jiffies(1000));
-	if (net_device->wait_condition == 0) {
+	t = wait_for_completion_timeout(&net_device->channel_init_wait, HZ);
+
+	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
 	}
@@ -647,8 +642,7 @@ static void netvsc_send_completion(struct hv_device *device,
 		/* Copy the response back */
 		memcpy(&net_device->channel_init_pkt, nvsp_packet,
 		       sizeof(struct nvsp_message));
-		net_device->wait_condition = 1;
-		wake_up(&net_device->channel_init_wait);
+		complete(&net_device->channel_init_wait);
 	} else if (nvsp_packet->hdr.msg_type ==
 		   NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE) {
 		/* Get the send context */
@@ -1123,7 +1117,7 @@ int netvsc_device_add(struct hv_device *device, void *additional_info)
 		list_add_tail(&packet->list_ent,
 			      &net_device->recv_pkt_list);
 	}
-	init_waitqueue_head(&net_device->channel_init_wait);
+	init_completion(&net_device->channel_init_wait);
 
 	/* Open the channel */
 	ret = vmbus_open(device->channel, net_driver->ring_buf_size,
diff --git a/drivers/staging/hv/netvsc.h b/drivers/staging/hv/netvsc.h
index 45d24b9..9ebea3b 100644
--- a/drivers/staging/hv/netvsc.h
+++ b/drivers/staging/hv/netvsc.h
@@ -318,8 +318,7 @@ struct netvsc_device {
 	struct nvsp_1_receive_buffer_section *recv_section;
 
 	/* Used for NetVSP initialization protocol */
-	int wait_condition;
-	wait_queue_head_t channel_init_wait;
+	struct completion channel_init_wait;
 	struct nvsp_message channel_init_pkt;
 
 	struct nvsp_message revoke_packet;
-- 
1.7.4.1

