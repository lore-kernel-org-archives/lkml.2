Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1F2OXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:23:15 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51123
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755851Ab1F2OWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 13/40] Staging: hv: netvsc: Introduce code to properly manage outstanding sends
Date: Wed, 29 Jun 2011 07:39:10 -0700
Message-Id: <1309358377-8537-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce code to properly manage outstanding sends.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_net.h |   10 ++++++++++
 drivers/staging/hv/netvsc.c     |    6 +++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/hyperv_net.h b/drivers/staging/hv/hyperv_net.h
index 5782fea..b5bee9e 100644
--- a/drivers/staging/hv/hyperv_net.h
+++ b/drivers/staging/hv/hyperv_net.h
@@ -371,6 +371,8 @@ struct netvsc_device {
 
 	atomic_t refcnt;
 	atomic_t num_outstanding_sends;
+	bool drain_notify;
+	wait_queue_head_t waiting_to_drain;
 	/*
 	 * List of free preallocated hv_netvsc_packet to represent receive
 	 * packet
@@ -1051,6 +1053,14 @@ struct rndis_filter_packet {
 #define NDIS_PACKET_TYPE_FUNCTIONAL	0x00000400
 #define NDIS_PACKET_TYPE_MAC_FRAME	0x00000800
 
+static inline void netvsc_wait_to_drain(struct netvsc_device *dev)
+{
+	dev->drain_notify = true;
+	wait_event(dev->waiting_to_drain,
+		atomic_read(&dev->num_outstanding_sends) == 0);
+	dev->drain_notify = false;
+}
+
 
 
 #endif /* _HYPERV_NET_H */
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 551537a..bdd5c2b 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -42,6 +42,8 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 
 	/* Set to 2 to allow both inbound and outbound traffic */
 	atomic_cmpxchg(&net_device->refcnt, 0, 2);
+	net_device->drain_notify = false;
+	init_waitqueue_head(&net_device->waiting_to_drain);
 
 	net_device->dev = device;
 	device->ext = net_device;
@@ -483,7 +485,9 @@ static void netvsc_send_completion(struct hv_device *device,
 		nvsc_packet->completion.send.send_completion(
 			nvsc_packet->completion.send.send_completion_ctx);
 
-		atomic_dec(&net_device->num_outstanding_sends);
+		if (atomic_dec_and_test(&net_device->num_outstanding_sends) &&
+			net_device->drain_notify)
+			wake_up(&net_device->waiting_to_drain);
 	} else {
 		netdev_err(ndev, "Unknown send completion packet type- "
 			   "%d received!!\n", nvsp_packet->hdr.msg_type);
-- 
1.7.4.1

