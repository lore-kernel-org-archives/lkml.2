Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1DUTT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:19:27 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:40098
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753316Ab1DUTTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:19:25 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 2/8] staging: hv: move netvsc_receive_completion() to clean up forward declaration
Date: Thu, 21 Apr 2011 12:30:41 -0700
Message-Id: <1303414247-22118-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
References: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |  102 +++++++++++++++++++++----------------------
 1 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 6eaecc1..edd2f4e 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -63,8 +63,6 @@ static void netvsc_send_completion(struct hv_device *device,
 static void netvsc_receive(struct hv_device *device,
 			    struct vmpacket_descriptor *packet);
 
-static void netvsc_receive_completion(void *context);
-
 static void netvsc_send_recv_completion(struct hv_device *device,
 					u64 transaction_id);
 
@@ -837,6 +835,56 @@ static int netvsc_send(struct hv_device *device,
 	return ret;
 }
 
+/* Send a receive completion packet to RNDIS device (ie NetVsp) */
+static void netvsc_receive_completion(void *context)
+{
+	struct hv_netvsc_packet *packet = context;
+	struct hv_device *device = (struct hv_device *)packet->device;
+	struct netvsc_device *net_device;
+	u64 transaction_id = 0;
+	bool fsend_receive_comp = false;
+	unsigned long flags;
+
+	/*
+	 * Even though it seems logical to do a GetOutboundNetDevice() here to
+	 * send out receive completion, we are using GetInboundNetDevice()
+	 * since we may have disable outbound traffic already.
+	 */
+	net_device = get_inbound_net_device(device);
+	if (!net_device) {
+		dev_err(&device->device, "unable to get net device..."
+			   "device being destroyed?");
+		return;
+	}
+
+	/* Overloading use of the lock. */
+	spin_lock_irqsave(&net_device->recv_pkt_list_lock, flags);
+
+	packet->xfer_page_pkt->count--;
+
+	/*
+	 * Last one in the line that represent 1 xfer page packet.
+	 * Return the xfer page packet itself to the freelist
+	 */
+	if (packet->xfer_page_pkt->count == 0) {
+		fsend_receive_comp = true;
+		transaction_id = packet->completion.recv.recv_completion_tid;
+		list_add_tail(&packet->xfer_page_pkt->list_ent,
+			      &net_device->recv_pkt_list);
+
+	}
+
+	/* Put the packet back */
+	list_add_tail(&packet->list_ent, &net_device->recv_pkt_list);
+	spin_unlock_irqrestore(&net_device->recv_pkt_list_lock, flags);
+
+	/* Send a receive completion for the xfer page packet */
+	if (fsend_receive_comp)
+		netvsc_send_recv_completion(device, transaction_id);
+
+	put_net_device(device);
+}
+
 static void netvsc_receive(struct hv_device *device,
 			    struct vmpacket_descriptor *packet)
 {
@@ -1063,56 +1111,6 @@ retry_send_cmplt:
 	}
 }
 
-/* Send a receive completion packet to RNDIS device (ie NetVsp) */
-static void netvsc_receive_completion(void *context)
-{
-	struct hv_netvsc_packet *packet = context;
-	struct hv_device *device = (struct hv_device *)packet->device;
-	struct netvsc_device *net_device;
-	u64 transaction_id = 0;
-	bool fsend_receive_comp = false;
-	unsigned long flags;
-
-	/*
-	 * Even though it seems logical to do a GetOutboundNetDevice() here to
-	 * send out receive completion, we are using GetInboundNetDevice()
-	 * since we may have disable outbound traffic already.
-	 */
-	net_device = get_inbound_net_device(device);
-	if (!net_device) {
-		dev_err(&device->device, "unable to get net device..."
-			   "device being destroyed?");
-		return;
-	}
-
-	/* Overloading use of the lock. */
-	spin_lock_irqsave(&net_device->recv_pkt_list_lock, flags);
-
-	packet->xfer_page_pkt->count--;
-
-	/*
-	 * Last one in the line that represent 1 xfer page packet.
-	 * Return the xfer page packet itself to the freelist
-	 */
-	if (packet->xfer_page_pkt->count == 0) {
-		fsend_receive_comp = true;
-		transaction_id = packet->completion.recv.recv_completion_tid;
-		list_add_tail(&packet->xfer_page_pkt->list_ent,
-			      &net_device->recv_pkt_list);
-
-	}
-
-	/* Put the packet back */
-	list_add_tail(&packet->list_ent, &net_device->recv_pkt_list);
-	spin_unlock_irqrestore(&net_device->recv_pkt_list_lock, flags);
-
-	/* Send a receive completion for the xfer page packet */
-	if (fsend_receive_comp)
-		netvsc_send_recv_completion(device, transaction_id);
-
-	put_net_device(device);
-}
-
 static void netvsc_channel_cb(void *context)
 {
 	int ret;
-- 
1.6.3.2

