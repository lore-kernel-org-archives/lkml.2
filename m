Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1DUTT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:19:28 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48377
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753357Ab1DUTTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:19:25 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 5/8] staging: hv: move netvsc_destroy_send_buf() to clean up forward declaration
Date: Thu, 21 Apr 2011 12:30:44 -0700
Message-Id: <1303414247-22118-6-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
References: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |  130 +++++++++++++++++++++----------------------
 1 files changed, 64 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 8b2defd..75640ea 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -51,8 +51,6 @@ static int netvsc_init_send_buf(struct hv_device *device);
 
 static int netvsc_init_recv_buf(struct hv_device *device);
 
-static int netvsc_destroy_send_buf(struct netvsc_device *net_device);
-
 static int netvsc_connect_vsp(struct hv_device *device);
 
 static void netvsc_send_completion(struct hv_device *device,
@@ -343,6 +341,70 @@ exit:
 	return ret;
 }
 
+static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
+{
+	struct nvsp_message *revoke_packet;
+	int ret = 0;
+
+	/*
+	 * If we got a section count, it means we received a
+	 *  SendReceiveBufferComplete msg (ie sent
+	 *  NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
+	 *  to send a revoke msg here
+	 */
+	if (net_device->send_section_size) {
+		/* Send the revoke send buffer */
+		revoke_packet = &net_device->revoke_packet;
+		memset(revoke_packet, 0, sizeof(struct nvsp_message));
+
+		revoke_packet->hdr.msg_type =
+			NVSP_MSG1_TYPE_REVOKE_SEND_BUF;
+		revoke_packet->msg.v1_msg.
+			revoke_send_buf.id = NETVSC_SEND_BUFFER_ID;
+
+		ret = vmbus_sendpacket(net_device->dev->channel,
+				       revoke_packet,
+				       sizeof(struct nvsp_message),
+				       (unsigned long)revoke_packet,
+				       VM_PKT_DATA_INBAND, 0);
+		/*
+		 * If we failed here, we might as well return and have a leak
+		 * rather than continue and a bugchk
+		 */
+		if (ret != 0) {
+			dev_err(&net_device->dev->device, "unable to send "
+				"revoke send buffer to netvsp");
+			return -1;
+		}
+	}
+
+	/* Teardown the gpadl on the vsp end */
+	if (net_device->send_buf_gpadl_handle) {
+		ret = vmbus_teardown_gpadl(net_device->dev->channel,
+					   net_device->send_buf_gpadl_handle);
+
+		/*
+		 * If we failed here, we might as well return and have a leak
+		 * rather than continue and a bugchk
+		 */
+		if (ret != 0) {
+			dev_err(&net_device->dev->device,
+				"unable to teardown send buffer's gpadl");
+			return -1;
+		}
+		net_device->send_buf_gpadl_handle = 0;
+	}
+
+	if (net_device->send_buf) {
+		/* Free up the receive buffer */
+		free_pages((unsigned long)net_device->send_buf,
+				get_order(net_device->send_buf_size));
+		net_device->send_buf = NULL;
+	}
+
+	return ret;
+}
+
 static int netvsc_init_send_buf(struct hv_device *device)
 {
 	int ret = 0;
@@ -436,70 +498,6 @@ exit:
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
 
 static int netvsc_connect_vsp(struct hv_device *device)
 {
-- 
1.6.3.2

