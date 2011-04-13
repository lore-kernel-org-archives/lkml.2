Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab1DMQKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:10:45 -0400
Received: from kroah.org ([198.145.64.141]:54252 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab1DMPzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:44 2011
Message-Id: <20110413155144.576111045@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:50:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [15/74] staging: hv: Fix GARP not sent after Quick Migration
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

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

---
 drivers/staging/hv/netvsc_drv.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -44,6 +44,7 @@ struct net_device_context {
 	/* point back to our device context */
 	struct device_context *device_ctx;
 	struct net_device_stats stats;
+	struct work_struct work;
 };
 
 struct netvsc_driver_context {
@@ -284,6 +285,7 @@ static void netvsc_linkstatus_callback(s
 {
 	struct device_context *device_ctx = to_device_context(device_obj);
 	struct net_device *net = dev_get_drvdata(&device_ctx->device);
+	struct net_device_context *ndev_ctx;
 
 	DPRINT_ENTER(NETVSC_DRV);
 
@@ -297,6 +299,8 @@ static void netvsc_linkstatus_callback(s
 		netif_carrier_on(net);
 		netif_wake_queue(net);
 		netif_notify_peers(net);
+		ndev_ctx = netdev_priv(net);
+		schedule_work(&ndev_ctx->work);
 	} else {
 		netif_carrier_off(net);
 		netif_stop_queue(net);
@@ -398,6 +402,25 @@ static const struct net_device_ops devic
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
@@ -428,6 +451,7 @@ static int netvsc_probe(struct device *d
 	net_device_ctx = netdev_priv(net);
 	net_device_ctx->device_ctx = device_ctx;
 	dev_set_drvdata(device, net);
+	INIT_WORK(&net_device_ctx->work, netvsc_send_garp);
 
 	/* Notify the netvsc driver of the new device */
 	ret = net_drv_obj->Base.OnDeviceAdd(device_obj, &device_info);


