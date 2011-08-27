Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1H0SLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:11:40 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54773
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751454Ab1H0SLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 15/46] Staging: hv: netvsc: Get rid of release_outbound_net_device() by inlining the code
Date: Sat, 27 Aug 2011 11:31:14 -0700
Message-Id: <1314469905-7058-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of release_outbound_net_device() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   38 ++++++++++++++------------------------
 1 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 67065c1..e46161d 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -88,22 +88,6 @@ static void put_net_device(struct hv_device *device)
 	atomic_dec(&net_device->refcnt);
 }
 
-static struct netvsc_device *release_outbound_net_device(
-		struct hv_device *device)
-{
-	struct netvsc_device *net_device;
-
-	net_device = device->ext;
-	if (net_device == NULL)
-		return NULL;
-
-	/* Busy wait until the ref drop to 2, then set it to 1 */
-	while (atomic_cmpxchg(&net_device->refcnt, 2, 1) != 2)
-		udelay(100);
-
-	return net_device;
-}
-
 static struct netvsc_device *release_inbound_net_device(
 		struct hv_device *device)
 {
@@ -400,13 +384,8 @@ int netvsc_device_remove(struct hv_device *device)
 	struct hv_netvsc_packet *netvsc_packet, *pos;
 	unsigned long flags;
 
-	/* Stop outbound traffic ie sends and receives completions */
-	net_device = release_outbound_net_device(device);
-	if (!net_device) {
-		dev_err(&device->device, "No net device present!!");
-		return -ENODEV;
-	}
-
+	net_device = (struct netvsc_device *)device->ext;
+	atomic_dec(&net_device->refcnt);
 	spin_lock_irqsave(&device->channel->inbound_lock, flags);
 	net_device->destroy = true;
 	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
@@ -424,6 +403,18 @@ int netvsc_device_remove(struct hv_device *device)
 	/* Stop inbound traffic ie receives and sends completions */
 	net_device = release_inbound_net_device(device);
 
+	/*
+	 * Wait until the ref cnt falls to 0.
+	 * We have already stopped any new references
+	 * for outgoing traffic. Also, at this point we don't have any
+	 * incoming traffic as well. So this must be outgoing refrences
+	 * established prior to marking the device as being destroyed.
+	 * Since the send path is non-blocking, it is reasonable to busy
+	 * wait here.
+	 */
+	while (atomic_read(&net_device->refcnt))
+		udelay(100);
+
 	/* At this point, no one should be accessing netDevice except in here */
 	dev_notice(&device->device, "net device safe to remove");
 
@@ -976,7 +967,6 @@ cleanup:
 			kfree(packet);
 		}
 
-		release_outbound_net_device(device);
 		release_inbound_net_device(device);
 
 		kfree(net_device);
-- 
1.7.4.1

