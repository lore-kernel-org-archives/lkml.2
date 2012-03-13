Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab2CMBHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:07:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:46681 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab2CMARq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 019/196] staging: hv: Fix GARP not sent after Quick Migration
Date: Mon, 12 Mar 2012 20:12:27 -0400
Message-Id: <1331597724-31358-20-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c996edcf1c451b81740abbcca5257ed7e353fcc6 upstream.

After Quick Migration, the network is not immediately operational in the
current context when receiving RNDIS_STATUS_MEDIA_CONNECT event. So, I added
another netif_notify_peers() into a scheduled work, otherwise GARP packet will
not be sent after quick migration, and cause network disconnection.

Thanks to Mike Surcouf <mike@surcouf.co.uk> for reporting the bug and
testing the patch.

Reported-by: Mike Surcouf <mike@surcouf.co.uk>
Tested-by: Mike Surcouf <mike@surcouf.co.uk>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/hv/netvsc_drv.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index d6940f4..5d77f11 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -44,6 +44,7 @@ struct net_device_context {
 	/* point back to our device context */
 	struct vm_device *device_ctx;
 	struct net_device_stats stats;
+	struct work_struct work;
 };
 
 struct netvsc_driver_context {
@@ -274,6 +275,7 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,
 {
 	struct vm_device *device_ctx = to_vm_device(device_obj);
 	struct net_device *net = dev_get_drvdata(&device_ctx->device);
+	struct net_device_context *ndev_ctx;
 
 	DPRINT_ENTER(NETVSC_DRV);
 
@@ -287,6 +289,8 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,
 		netif_carrier_on(net);
 		netif_wake_queue(net);
 		netif_notify_peers(net);
+		ndev_ctx = netdev_priv(net);
+		schedule_work(&ndev_ctx->work);
 	} else {
 		netif_carrier_off(net);
 		netif_stop_queue(net);
@@ -388,6 +392,25 @@ static const struct net_device_ops device_ops = {
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
 	struct driver_context *driver_ctx =
@@ -418,6 +441,7 @@ static int netvsc_probe(struct device *device)
 	net_device_ctx = netdev_priv(net);
 	net_device_ctx->device_ctx = device_ctx;
 	dev_set_drvdata(device, net);
+	INIT_WORK(&net_device_ctx->work, netvsc_send_garp);
 
 	/* Notify the netvsc driver of the new device */
 	ret = net_drv_obj->Base.OnDeviceAdd(device_obj, &device_info);
-- 
1.7.9.3

