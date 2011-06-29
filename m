Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1F2O3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:29:45 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51138
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755907Ab1F2OWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 19/40] Staging: hv: netvsc: Get rid of release_outbound_net_device() by inlining the code
Date: Wed, 29 Jun 2011 07:39:16 -0700
Message-Id: <1309358377-8537-19-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of release_outbound_net_device() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   35 +++++++----------------------------
 1 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 3ac0e17..7761370 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -100,27 +100,6 @@ static void put_net_device(struct hv_device *device)
 	spin_unlock_irqrestore(&device->ext_lock, flags);
 }
 
-static struct netvsc_device *release_outbound_net_device(
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
-	/* Busy wait until the ref drop to 2, then set it to 1 */
-	while (atomic_cmpxchg(&net_device->refcnt, 2, 1) != 2)
-		udelay(100);
-
-	spin_unlock_irqrestore(&device->ext_lock, flags);
-	return net_device;
-}
-
 static struct netvsc_device *release_inbound_net_device(
 		struct hv_device *device)
 {
@@ -423,14 +402,15 @@ int netvsc_device_remove(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *netvsc_packet, *pos;
-	struct net_device *ndev = dev_get_drvdata(&device->device);
 
 	/* Stop outbound traffic ie sends and receives completions */
-	net_device = release_outbound_net_device(device);
-	if (!net_device) {
-		netdev_err(ndev, "No net device present!!\n");
-		return -ENODEV;
-	}
+
+	/*
+	 * Since we currently hold a reference on the net_device,
+	 * it is safe to dereference the ext pointer.
+	 */
+	net_device = (struct netvsc_device *)device->ext;
+	atomic_dec(&net_device->refcnt);
 	net_device->destroy = true;
 
 	/* Wait for all send completions */
@@ -1006,7 +986,6 @@ cleanup:
 			kfree(packet);
 		}
 
-		release_outbound_net_device(device);
 		release_inbound_net_device(device);
 
 		kfree(net_device);
-- 
1.7.4.1

