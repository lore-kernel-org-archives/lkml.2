Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1DUTuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:50:21 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51295
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751218Ab1DUTuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:50:20 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 3/8] staging: hv: move netvsc_send_recv_completion() to clean up forward declaration
Date: Thu, 21 Apr 2011 12:30:42 -0700
Message-Id: <1303414247-22118-4-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
References: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   87 +++++++++++++++++++++----------------------
 1 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index edd2f4e..ea3c72e 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -63,9 +63,6 @@ static void netvsc_send_completion(struct hv_device *device,
 static void netvsc_receive(struct hv_device *device,
 			    struct vmpacket_descriptor *packet);
 
-static void netvsc_send_recv_completion(struct hv_device *device,
-					u64 transaction_id);
-
 
 static struct netvsc_device *alloc_net_device(struct hv_device *device)
 {
@@ -835,6 +832,48 @@ static int netvsc_send(struct hv_device *device,
 	return ret;
 }
 
+static void netvsc_send_recv_completion(struct hv_device *device,
+					u64 transaction_id)
+{
+	struct nvsp_message recvcompMessage;
+	int retries = 0;
+	int ret;
+
+	recvcompMessage.hdr.msg_type =
+				NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE;
+
+	/* FIXME: Pass in the status */
+	recvcompMessage.msg.v1_msg.send_rndis_pkt_complete.status =
+		NVSP_STAT_SUCCESS;
+
+retry_send_cmplt:
+	/* Send the completion */
+	ret = vmbus_sendpacket(device->channel, &recvcompMessage,
+			       sizeof(struct nvsp_message), transaction_id,
+			       VM_PKT_COMP, 0);
+	if (ret == 0) {
+		/* success */
+		/* no-op */
+	} else if (ret == -1) {
+		/* no more room...wait a bit and attempt to retry 3 times */
+		retries++;
+		dev_err(&device->device, "unable to send receive completion pkt"
+			" (tid %llx)...retrying %d", transaction_id, retries);
+
+		if (retries < 4) {
+			udelay(100);
+			goto retry_send_cmplt;
+		} else {
+			dev_err(&device->device, "unable to send receive "
+				"completion pkt (tid %llx)...give up retrying",
+				transaction_id);
+		}
+	} else {
+		dev_err(&device->device, "unable to send receive "
+			"completion pkt - %llx", transaction_id);
+	}
+}
+
 /* Send a receive completion packet to RNDIS device (ie NetVsp) */
 static void netvsc_receive_completion(void *context)
 {
@@ -1069,48 +1108,6 @@ static void netvsc_receive(struct hv_device *device,
 	put_net_device(device);
 }
 
-static void netvsc_send_recv_completion(struct hv_device *device,
-					u64 transaction_id)
-{
-	struct nvsp_message recvcompMessage;
-	int retries = 0;
-	int ret;
-
-	recvcompMessage.hdr.msg_type =
-				NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE;
-
-	/* FIXME: Pass in the status */
-	recvcompMessage.msg.v1_msg.send_rndis_pkt_complete.status =
-		NVSP_STAT_SUCCESS;
-
-retry_send_cmplt:
-	/* Send the completion */
-	ret = vmbus_sendpacket(device->channel, &recvcompMessage,
-			       sizeof(struct nvsp_message), transaction_id,
-			       VM_PKT_COMP, 0);
-	if (ret == 0) {
-		/* success */
-		/* no-op */
-	} else if (ret == -1) {
-		/* no more room...wait a bit and attempt to retry 3 times */
-		retries++;
-		dev_err(&device->device, "unable to send receive completion pkt"
-			" (tid %llx)...retrying %d", transaction_id, retries);
-
-		if (retries < 4) {
-			udelay(100);
-			goto retry_send_cmplt;
-		} else {
-			dev_err(&device->device, "unable to send receive "
-				"completion pkt (tid %llx)...give up retrying",
-				transaction_id);
-		}
-	} else {
-		dev_err(&device->device, "unable to send receive "
-			"completion pkt - %llx", transaction_id);
-	}
-}
-
 static void netvsc_channel_cb(void *context)
 {
 	int ret;
-- 
1.6.3.2

