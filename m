Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1F2Ouz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:50:55 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37126
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751921Ab1F2Ouy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:50:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 20/40] Staging: hv: netvsc: Get rid of release_inbound_net_device() by inlining the code
Date: Wed, 29 Jun 2011 07:39:17 -0700
Message-Id: <1309358377-8537-20-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of release_inbound_net_device() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   44 +++++++++---------------------------------
 1 files changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 7761370..f930b9e 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -100,28 +100,6 @@ static void put_net_device(struct hv_device *device)
 	spin_unlock_irqrestore(&device->ext_lock, flags);
 }
 
-static struct netvsc_device *release_inbound_net_device(
-		struct hv_device *device)
-{
-	struct netvsc_device *net_device;
-	unsigned long flags;
-
-	spin_lock_irqsave(&device->ext_lock, flags);
-	net_device = device->ext;
-	if (net_device == NULL) {
-		spin_unlock_irqrestore(&device->ext_lock, flags);
-		return NULL;
-	}
-
-	/* Busy wait until the ref drop to 1, then set it to 0 */
-	while (atomic_cmpxchg(&net_device->refcnt, 1, 0) != 1)
-		udelay(100);
-
-	device->ext = NULL;
-	spin_unlock_irqrestore(&device->ext_lock, flags);
-	return net_device;
-}
-
 static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 {
 	struct nvsp_message *revoke_packet;
@@ -402,6 +380,7 @@ int netvsc_device_remove(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *netvsc_packet, *pos;
+	unsigned long flags;
 
 	/* Stop outbound traffic ie sends and receives completions */
 
@@ -413,18 +392,17 @@ int netvsc_device_remove(struct hv_device *device)
 	atomic_dec(&net_device->refcnt);
 	net_device->destroy = true;
 
-	/* Wait for all send completions */
-	while (atomic_read(&net_device->num_outstanding_sends)) {
-		dev_info(&device->device,
-			"waiting for %d requests to complete...\n",
-			atomic_read(&net_device->num_outstanding_sends));
-		udelay(100);
-	}
-
+	/*
+	 * At this point, all outbound traffic is disabled. Wait
+	 * for outstanding sends to drain out.
+	 */
+	netvsc_wait_to_drain(net_device);
 	netvsc_disconnect_vsp(net_device);
 
-	/* Stop inbound traffic ie receives and sends completions */
-	net_device = release_inbound_net_device(device);
+	spin_lock_irqsave(&device->ext_lock, flags);
+	atomic_set(&net_device->refcnt, 0);
+	device->ext = NULL;
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 
 	/* At this point, no one should be accessing netDevice except in here */
 	dev_notice(&device->device, "net device safe to remove\n");
@@ -986,8 +964,6 @@ cleanup:
 			kfree(packet);
 		}
 
-		release_inbound_net_device(device);
-
 		kfree(net_device);
 	}
 
-- 
1.7.4.1

