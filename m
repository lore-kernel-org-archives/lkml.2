Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1DEPYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:24:25 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:45789
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753373Ab1DEPYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:24:24 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Apr 2011 11:24:24 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Mike Surcouf <mike@surcouf.co.uk>, stable <stable@kernel.org>
Subject: [PATCH] staging: hv: Fix GARP not sent after Quick Migration
Date: Tue,  5 Apr 2011 08:27:48 -0700
Message-Id: <1302017268-22913-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After Quick Migration, the network is not immediately operational in the
current context when receiving RNDIS_STATUS_MEDIA_CONNECT event. So, I put
the netif_notify_peers() into a scheduled work, otherwise GARP packet will
not be sent after quick migration, and cause network disconnection.

Thanks to Mike Surcouf <mike@surcouf.co.uk> for reporting the bug and
testing the patch.

This patch should also be backported to stable kernel 2.6.32 and later.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Mike Surcouf <mike@surcouf.co.uk>
Cc: stable <stable@kernel.org>
---
 drivers/staging/hv/netvsc_drv.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 2d40f5f..417e5f7 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -46,6 +46,7 @@ struct net_device_context {
 	/* point back to our device context */
 	struct hv_device *device_ctx;
 	unsigned long avail;
+	struct work_struct work;
 };
 
 
@@ -219,6 +220,7 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,
 				       unsigned int status)
 {
 	struct net_device *net = dev_get_drvdata(&device_obj->device);
+	struct net_device_context *ndev_ctx;
 
 	if (!net) {
 		DPRINT_ERR(NETVSC_DRV, "got link status but net device "
@@ -229,7 +231,8 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,
 	if (status == 1) {
 		netif_carrier_on(net);
 		netif_wake_queue(net);
-		netif_notify_peers(net);
+		ndev_ctx = netdev_priv(net);
+		schedule_work(&ndev_ctx->work);
 	} else {
 		netif_carrier_off(net);
 		netif_stop_queue(net);
@@ -328,6 +331,17 @@ static const struct net_device_ops device_ops = {
 	.ndo_set_mac_address =		eth_mac_addr,
 };
 
+static void netvsc_send_garp(struct work_struct *w)
+{
+	struct net_device_context *ndev_ctx;
+	struct net_device *net;
+
+	ndev_ctx = container_of(w, struct net_device_context, work);
+	net = dev_get_drvdata(&ndev_ctx->device_ctx->device);
+	netif_notify_peers(net);
+}
+
+
 static int netvsc_probe(struct device *device)
 {
 	struct hv_driver *drv =
@@ -353,6 +367,7 @@ static int netvsc_probe(struct device *device)
 	net_device_ctx->device_ctx = device_obj;
 	net_device_ctx->avail = ring_size;
 	dev_set_drvdata(device, net);
+	INIT_WORK(&net_device_ctx->work, netvsc_send_garp);
 
 	/* Notify the netvsc driver of the new device */
 	ret = net_drv_obj->base.dev_add(device_obj, &device_info);
-- 
1.6.3.2

