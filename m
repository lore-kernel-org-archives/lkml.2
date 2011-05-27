Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1E0NKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:10:11 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60964
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753688Ab1E0NKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:10:08 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 2/2] staging: hv: use delayed_work for netvsc_send_garp()
Date: Fri, 27 May 2011 06:21:55 -0700
Message-Id: <1306502515-18961-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306502515-18961-1-git-send-email-haiyangz@microsoft.com>
References: <1306502515-18961-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of sleeping in a scheduled work, we now use delayed_work
for netvsc_send_garp().

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>

---
 drivers/staging/hv/netvsc_drv.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index f510959..33cab9c 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -46,7 +46,7 @@ struct net_device_context {
 	/* point back to our device context */
 	struct hv_device *device_ctx;
 	unsigned long avail;
-	struct work_struct work;
+	struct delayed_work dwork;
 };
 
 
@@ -217,7 +217,7 @@ void netvsc_linkstatus_callback(struct hv_device *device_obj,
 		netif_wake_queue(net);
 		netif_notify_peers(net);
 		ndev_ctx = netdev_priv(net);
-		schedule_work(&ndev_ctx->work);
+		schedule_delayed_work(&ndev_ctx->dwork, msecs_to_jiffies(20));
 	} else {
 		netif_carrier_off(net);
 		netif_stop_queue(net);
@@ -315,7 +315,7 @@ static const struct net_device_ops device_ops = {
  * Send GARP packet to network peers after migrations.
  * After Quick Migration, the network is not immediately operational in the
  * current context when receiving RNDIS_STATUS_MEDIA_CONNECT event. So, add
- * another netif_notify_peers() into a scheduled work, otherwise GARP packet
+ * another netif_notify_peers() into a delayed work, otherwise GARP packet
  * will not be sent after quick migration, and cause network disconnection.
  */
 static void netvsc_send_garp(struct work_struct *w)
@@ -323,8 +323,7 @@ static void netvsc_send_garp(struct work_struct *w)
 	struct net_device_context *ndev_ctx;
 	struct net_device *net;
 
-	msleep(20);
-	ndev_ctx = container_of(w, struct net_device_context, work);
+	ndev_ctx = container_of(w, struct net_device_context, dwork.work);
 	net = dev_get_drvdata(&ndev_ctx->device_ctx->device);
 	netif_notify_peers(net);
 }
@@ -348,7 +347,7 @@ static int netvsc_probe(struct hv_device *dev)
 	net_device_ctx->device_ctx = dev;
 	net_device_ctx->avail = ring_size;
 	dev_set_drvdata(&dev->device, net);
-	INIT_WORK(&net_device_ctx->work, netvsc_send_garp);
+	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_send_garp);
 
 	/* Notify the netvsc driver of the new device */
 	device_info.ring_size = ring_size;
@@ -387,12 +386,16 @@ static int netvsc_probe(struct hv_device *dev)
 static int netvsc_remove(struct hv_device *dev)
 {
 	struct net_device *net = dev_get_drvdata(&dev->device);
+	struct net_device_context *ndev_ctx;
 
 	if (net == NULL) {
 		dev_err(&dev->device, "No net device to remove\n");
 		return 0;
 	}
 
+	ndev_ctx = netdev_priv(net);
+	cancel_delayed_work_sync(&ndev_ctx->dwork);
+
 	/* Stop outbound asap */
 	netif_stop_queue(net);
 
-- 
1.6.3.2

