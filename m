Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab1DZVjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:39:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:41140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758562Ab1DZVNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914748355"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: haiyangz@microsoft.com, mike@surcouf.co.uk, hjanssen@microsoft.com,
        v-abkane@microsoft.com, kys@microsoft.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [6/106] staging: hv: Fix GARP not sent after Quick Migration
Message-Id: <20110426211244.12EAB3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/hv/netvsc_drv.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: linux-2.6.35.y/drivers/staging/hv/netvsc_drv.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/hv/netvsc_drv.c
+++ linux-2.6.35.y/drivers/staging/hv/netvsc_drv.c
@@ -46,6 +46,7 @@ struct net_device_context {
 	/* point back to our device context */
 	struct vm_device *device_ctx;
 	unsigned long avail;
+	struct work_struct work;
 };
 
 struct netvsc_driver_context {
@@ -237,6 +238,7 @@ static void netvsc_linkstatus_callback(s
 {
 	struct vm_device *device_ctx = to_vm_device(device_obj);
 	struct net_device *net = dev_get_drvdata(&device_ctx->device);
+	struct net_device_context *ndev_ctx;
 
 	DPRINT_ENTER(NETVSC_DRV);
 
@@ -250,6 +252,8 @@ static void netvsc_linkstatus_callback(s
 		netif_carrier_on(net);
 		netif_wake_queue(net);
 		netif_notify_peers(net);
+		ndev_ctx = netdev_priv(net);
+		schedule_work(&ndev_ctx->work);
 	} else {
 		netif_carrier_off(net);
 		netif_stop_queue(net);
@@ -354,6 +358,25 @@ static const struct net_device_ops devic
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
@@ -385,6 +408,7 @@ static int netvsc_probe(struct device *d
 	net_device_ctx->device_ctx = device_ctx;
 	net_device_ctx->avail = ring_size;
 	dev_set_drvdata(device, net);
+	INIT_WORK(&net_device_ctx->work, netvsc_send_garp);
 
 	/* Notify the netvsc driver of the new device */
 	ret = net_drv_obj->Base.OnDeviceAdd(device_obj, &device_info);
