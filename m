Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1DFWHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:07:16 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60390
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932117Ab1DFWHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:07:14 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Mike Surcouf <mike@surcouf.co.uk>, stable <stable@kernel.org>
Subject: [PATCH] staging: hv: Fix GARP not sent after Quick Migration
Date: Wed,  6 Apr 2011 15:18:00 -0700
Message-Id: <1302128280-14390-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After Quick Migration, the network is not immediately operational in the
current context when receiving RNDIS_STATUS_MEDIA_CONNECT event. So, I added
another netif_notify_peers() into a scheduled work, otherwise GARP packet will
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
 drivers/staging/hv/netvsc_drv.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 54a203b..258233d 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -48,6 +48,7 @@ struct net_device_context {
 	/* point back to our device context */
 	struct hv_device *device_ctx;
 	unsigned long avail;
+	struct work_struct work;
 };
 
 
@@ -214,6 +215,7 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,
 				       unsigned int status)
 {
 	struct net_device *net = dev_get_drvdata(&device_obj->device);
+	struct net_device_context *ndev_ctx;
 
 	if (!net) {
 		netdev_err(net, "got link status but net device "
@@ -225,6 +227,8 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,
 		netif_carrier_on(net);
 		netif_wake_queue(net);
 		netif_notify_peers(net);
+		ndev_ctx = netdev_priv(net);
+		schedule_work(&ndev_ctx->work);
 	} else {
 		netif_carrier_off(net);
 		netif_stop_queue(net);
@@ -320,6 +324,25 @@ static const struct net_device_ops device_ops = {
 	.ndo_set_mac_address =		eth_mac_addr,
 };
 
+/*
+ * Send GARP packet to network peers after migrations.
+ * After Quick Migration, the network is not immediately operational in the
+ * current context when receiving RNDIS_STATUS_MEDIA_CONNECT event. So, add
+ * another netif_notify_peers() into a scheduled work, otherwise GARP packet
+ * will not be sent after quick migration, and cause network disconnection.
+ */
+static void netvsc_send_garp(struct work_struct *w)
+{
+	struct net_device_context *ndev_ctx;
+	struct net_device *net;
+
+	msleep(20);
+	ndev_ctx = container_of(w, struct net_device_context, work);
+	net = dev_get_drvdata(&ndev_ctx->device_ctx->device);
+	netif_notify_peers(net);
+}
+
+
 static int netvsc_probe(struct device *device)
 {
 	struct hv_driver *drv =
@@ -345,6 +368,7 @@ static int netvsc_probe(struct device *device)
 	net_device_ctx->device_ctx = device_obj;
 	net_device_ctx->avail = ring_size;
 	dev_set_drvdata(device, net);
+	INIT_WORK(&net_device_ctx->work, netvsc_send_garp);
 
 	/* Notify the netvsc driver of the new device */
 	ret = net_drv_obj->base.dev_add(device_obj, &device_info);
-- 
1.7.4.1

