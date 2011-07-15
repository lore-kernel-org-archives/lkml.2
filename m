Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1GORem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:34:42 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37371
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754239Ab1GORaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 094/117] Staging: hv: netvsc: Get rid of release_inbound_net_device() by inlining the code
Date: Fri, 15 Jul 2011 10:47:22 -0700
Message-Id: <1310752065-27895-94-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of release_inbound_net_device() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   32 ++++----------------------------
 1 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 3975219..6805137 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -98,30 +98,6 @@ static void put_net_device(struct hv_device *device)
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
-	spin_unlock_irqrestore(&device->ext_lock, flags);
-	/* Busy wait until the ref drop to 1, then set it to 0 */
-	while (atomic_cmpxchg(&net_device->refcnt, 1, 0) != 1)
-		udelay(100);
-
-	spin_lock_irqsave(&device->ext_lock, flags);
-	device->ext = NULL;
-	spin_unlock_irqrestore(&device->ext_lock, flags);
-	return net_device;
-}
-
 static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 {
 	struct nvsp_message *revoke_packet;
@@ -423,8 +399,10 @@ int netvsc_device_remove(struct hv_device *device)
 
 	netvsc_disconnect_vsp(net_device);
 
-	/* Stop inbound traffic ie receives and sends completions */
-	net_device = release_inbound_net_device(device);
+	spin_lock_irqsave(&device->ext_lock, flags);
+	atomic_dec(&net_device->refcnt);
+	device->ext = NULL;
+	spin_unlock_irqrestore(&device->ext_lock, flags);
 
 	/*
 	 * Wait until the ref cnt falls to 0.
@@ -990,8 +968,6 @@ cleanup:
 			kfree(packet);
 		}
 
-		release_inbound_net_device(device);
-
 		kfree(net_device);
 	}
 
-- 
1.7.4.1

