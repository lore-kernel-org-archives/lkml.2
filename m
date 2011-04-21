Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1DUTTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:19:31 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:45057
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753371Ab1DUTTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:19:25 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 4/8] staging: hv: move netvsc_destroy_recv_buf() to clean up forward declaration
Date: Thu, 21 Apr 2011 12:30:43 -0700
Message-Id: <1303414247-22118-5-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
References: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |  138 +++++++++++++++++++++---------------------
 1 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index ea3c72e..8b2defd 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -53,8 +53,6 @@ static int netvsc_init_recv_buf(struct hv_device *device);
 
 static int netvsc_destroy_send_buf(struct netvsc_device *net_device);
 
-static int netvsc_destroy_recv_buf(struct netvsc_device *net_device);
-
 static int netvsc_connect_vsp(struct hv_device *device);
 
 static void netvsc_send_completion(struct hv_device *device,
@@ -159,6 +157,75 @@ static struct netvsc_device *release_inbound_net_device(
 	return net_device;
 }
 
+static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
+{
+	struct nvsp_message *revoke_packet;
+	int ret = 0;
+
+	/*
+	 * If we got a section count, it means we received a
+	 * SendReceiveBufferComplete msg (ie sent
+	 * NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
+	 * to send a revoke msg here
+	 */
+	if (net_device->recv_section_cnt) {
+		/* Send the revoke receive buffer */
+		revoke_packet = &net_device->revoke_packet;
+		memset(revoke_packet, 0, sizeof(struct nvsp_message));
+
+		revoke_packet->hdr.msg_type =
+			NVSP_MSG1_TYPE_REVOKE_RECV_BUF;
+		revoke_packet->msg.v1_msg.
+		revoke_recv_buf.id = NETVSC_RECEIVE_BUFFER_ID;
+
+		ret = vmbus_sendpacket(net_device->dev->channel,
+				       revoke_packet,
+				       sizeof(struct nvsp_message),
+				       (unsigned long)revoke_packet,
+				       VM_PKT_DATA_INBAND, 0);
+		/*
+		 * If we failed here, we might as well return and
+		 * have a leak rather than continue and a bugchk
+		 */
+		if (ret != 0) {
+			dev_err(&net_device->dev->device, "unable to send "
+				"revoke receive buffer to netvsp");
+			return -1;
+		}
+	}
+
+	/* Teardown the gpadl on the vsp end */
+	if (net_device->recv_buf_gpadl_handle) {
+		ret = vmbus_teardown_gpadl(net_device->dev->channel,
+			   net_device->recv_buf_gpadl_handle);
+
+		/* If we failed here, we might as well return and have a leak
+		 * rather than continue and a bugchk
+		 */
+		if (ret != 0) {
+			dev_err(&net_device->dev->device,
+				   "unable to teardown receive buffer's gpadl");
+			return -1;
+		}
+		net_device->recv_buf_gpadl_handle = 0;
+	}
+
+	if (net_device->recv_buf) {
+		/* Free up the receive buffer */
+		free_pages((unsigned long)net_device->recv_buf,
+			get_order(net_device->recv_buf_size));
+		net_device->recv_buf = NULL;
+	}
+
+	if (net_device->recv_section) {
+		net_device->recv_section_cnt = 0;
+		kfree(net_device->recv_section);
+		net_device->recv_section = NULL;
+	}
+
+	return ret;
+}
+
 static int netvsc_init_recv_buf(struct hv_device *device)
 {
 	int ret = 0;
@@ -369,73 +436,6 @@ exit:
 	return ret;
 }
 
-static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
-{
-	struct nvsp_message *revoke_packet;
-	int ret = 0;
-
-	/*
-	 * If we got a section count, it means we received a
-	 * SendReceiveBufferComplete msg (ie sent
-	 * NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
-	 * to send a revoke msg here
-	 */
-	if (net_device->recv_section_cnt) {
-		/* Send the revoke receive buffer */
-		revoke_packet = &net_device->revoke_packet;
-		memset(revoke_packet, 0, sizeof(struct nvsp_message));
-
-		revoke_packet->hdr.msg_type =
-			NVSP_MSG1_TYPE_REVOKE_RECV_BUF;
-		revoke_packet->msg.v1_msg.
-		revoke_recv_buf.id = NETVSC_RECEIVE_BUFFER_ID;
-
-		ret = vmbus_sendpacket(net_device->dev->channel,
-				       revoke_packet,
-				       sizeof(struct nvsp_message),
-				       (unsigned long)revoke_packet,
-				       VM_PKT_DATA_INBAND, 0);
-		/*
-		 * If we failed here, we might as well return and
-		 * have a leak rather than continue and a bugchk
-		 */
-		if (ret != 0) {
-			dev_err(&net_device->dev->device, "unable to send "
-				"revoke receive buffer to netvsp");
-			return -1;
-		}
-	}
-
-	/* Teardown the gpadl on the vsp end */
-	if (net_device->recv_buf_gpadl_handle) {
-		ret = vmbus_teardown_gpadl(net_device->dev->channel,
-			   net_device->recv_buf_gpadl_handle);
-
-		/* If we failed here, we might as well return and have a leak rather than continue and a bugchk */
-		if (ret != 0) {
-			dev_err(&net_device->dev->device,
-				   "unable to teardown receive buffer's gpadl");
-			return -1;
-		}
-		net_device->recv_buf_gpadl_handle = 0;
-	}
-
-	if (net_device->recv_buf) {
-		/* Free up the receive buffer */
-		free_pages((unsigned long)net_device->recv_buf,
-			get_order(net_device->recv_buf_size));
-		net_device->recv_buf = NULL;
-	}
-
-	if (net_device->recv_section) {
-		net_device->recv_section_cnt = 0;
-		kfree(net_device->recv_section);
-		net_device->recv_section = NULL;
-	}
-
-	return ret;
-}
-
 static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 {
 	struct nvsp_message *revoke_packet;
-- 
1.6.3.2

