Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1DZQIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:08:14 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:45432
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751493Ab1DZQIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:08:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 05/25] Staging: hv: Get rid of the references to the priv element of struct hv_driver in net driver
Date: Tue, 26 Apr 2011 09:20:22 -0700
Message-Id: <1303834842-5022-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834842-5022-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for getting rid of the priv element from struct hv_driver,
get rid of the references to the priv element of struct
hv_driver in network driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c     |   11 +++++++----
 drivers/staging/hv/netvsc_drv.c |   16 ++++++----------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index b3e6497..27c7449 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -835,6 +835,9 @@ static void netvsc_receive(struct hv_device *device,
 	int i, j;
 	int count = 0, bytes_remain = 0;
 	unsigned long flags;
+	struct netvsc_driver *netvsc_drv =
+		 drv_to_netvscdrv(device->device.driver);
+
 	LIST_HEAD(listHead);
 
 	net_device = get_inbound_net_device(device);
@@ -995,8 +998,7 @@ static void netvsc_receive(struct hv_device *device,
 		}
 
 		/* Pass it to the upper layer */
-		((struct netvsc_driver *)device->drv)->
-			recv_cb(device, netvsc_packet);
+		netvsc_drv->recv_cb(device, netvsc_packet);
 
 		netvsc_receive_completion(netvsc_packet->
 				completion.recv.recv_completion_ctx);
@@ -1102,7 +1104,7 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *packet, *pos;
 	struct netvsc_driver *net_driver =
-				(struct netvsc_driver *)device->drv;
+		drv_to_netvscdrv(device->device.driver);
 
 	net_device = alloc_net_device(device);
 	if (!net_device) {
@@ -1183,7 +1185,8 @@ cleanup:
  */
 int netvsc_initialize(struct hv_driver *drv)
 {
-	struct netvsc_driver *driver = (struct netvsc_driver *)drv;
+	struct netvsc_driver *driver =
+		drv_to_netvscdrv(&drv->driver);
 
 	drv->name = driver_name;
 	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(struct hv_guid));
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 096a732..e61eb7e 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -132,9 +132,8 @@ static void netvsc_xmit_completion(void *context)
 static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
 	struct net_device_context *net_device_ctx = netdev_priv(net);
-	struct hv_driver *drv =
-	    drv_to_hv_drv(net_device_ctx->device_ctx->device.driver);
-	struct netvsc_driver *net_drv_obj = drv->priv;
+	struct netvsc_driver *net_drv_obj =
+		drv_to_netvscdrv(net_device_ctx->device_ctx->device.driver);
 	struct hv_netvsc_packet *packet;
 	int ret;
 	unsigned int i, num_pages;
@@ -343,9 +342,8 @@ static void netvsc_send_garp(struct work_struct *w)
 
 static int netvsc_probe(struct device *device)
 {
-	struct hv_driver *drv =
-		drv_to_hv_drv(device->driver);
-	struct netvsc_driver *net_drv_obj = drv->priv;
+	struct netvsc_driver *net_drv_obj =
+		drv_to_netvscdrv(device->driver);
 	struct hv_device *device_obj = device_to_hv_device(device);
 	struct net_device *net = NULL;
 	struct net_device_context *net_device_ctx;
@@ -413,9 +411,8 @@ static int netvsc_probe(struct device *device)
 
 static int netvsc_remove(struct device *device)
 {
-	struct hv_driver *drv =
-		drv_to_hv_drv(device->driver);
-	struct netvsc_driver *net_drv_obj = drv->priv;
+	struct netvsc_driver *net_drv_obj =
+		drv_to_netvscdrv(device->driver);
 	struct hv_device *device_obj = device_to_hv_device(device);
 	struct net_device *net = dev_get_drvdata(&device_obj->device);
 	int ret;
@@ -498,7 +495,6 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	net_drv_obj->ring_buf_size = ring_size * PAGE_SIZE;
 	net_drv_obj->recv_cb = netvsc_recv_callback;
 	net_drv_obj->link_status_change = netvsc_linkstatus_callback;
-	drv->priv = net_drv_obj;
 
 	/* Callback to client driver to complete the initialization */
 	drv_init(&net_drv_obj->base);
-- 
1.7.4.1

