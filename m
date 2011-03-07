Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1CGVYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:24:22 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:59011
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754696Ab1CGVYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:24:20 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 10/16] Staging: hv: Eliminate netvsc_driver_context
Date: Mon,  7 Mar 2011 13:33:41 -0800
Message-Id: <1299533621-22763-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the consolidation of all driver state into one data structure;
netvsc_driver_context structure is not needed; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index fdcc8aa..f0d258c 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -48,9 +48,6 @@ struct net_device_context {
 	unsigned long avail;
 };
 
-struct netvsc_driver_context {
-	struct netvsc_driver drv_obj;
-};
 
 #define PACKET_PAGES_LOWATER  8
 /* Need this many pages to handle worst case fragmented packet */
@@ -61,7 +58,7 @@ module_param(ring_size, int, S_IRUGO);
 MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
 
 /* The one and only one */
-static struct netvsc_driver_context g_netvsc_drv;
+static struct  netvsc_driver g_netvsc_drv;
 
 /* no-op so the netdev core doesn't return -EINVAL when modifying the the
  * multicast address list in SIOCADDMULTI. hv is setup to get all multicast
@@ -134,9 +131,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	struct net_device_context *net_device_ctx = netdev_priv(net);
 	struct hv_driver *drv =
 	    drv_to_hv_drv(net_device_ctx->device_ctx->device.driver);
-	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)drv->priv;
-	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
+	struct netvsc_driver *net_drv_obj = drv->priv;
 	struct hv_netvsc_packet *packet;
 	int ret;
 	unsigned int i, num_pages;
@@ -339,9 +334,7 @@ static int netvsc_probe(struct device *device)
 {
 	struct hv_driver *drv =
 		drv_to_hv_drv(device->driver);
-	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)drv->priv;
-	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
+	struct netvsc_driver *net_drv_obj = drv->priv;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
 	struct net_device *net = NULL;
@@ -411,9 +404,7 @@ static int netvsc_remove(struct device *device)
 {
 	struct hv_driver *drv =
 		drv_to_hv_drv(device->driver);
-	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)drv->priv;
-	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
+	struct netvsc_driver *net_drv_obj = drv->priv;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct net_device *net = dev_get_drvdata(&device_ctx->device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
@@ -458,8 +449,8 @@ static int netvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void netvsc_drv_exit(void)
 {
-	struct netvsc_driver *netvsc_drv_obj = &g_netvsc_drv.drv_obj;
-	struct hv_driver *drv = &g_netvsc_drv.drv_obj.base;
+	struct netvsc_driver *netvsc_drv_obj = &g_netvsc_drv;
+	struct hv_driver *drv = &g_netvsc_drv.base;
 	struct device *current_dev;
 	int ret;
 
@@ -493,8 +484,8 @@ static void netvsc_drv_exit(void)
 
 static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 {
-	struct netvsc_driver *net_drv_obj = &g_netvsc_drv.drv_obj;
-	struct hv_driver *drv = &g_netvsc_drv.drv_obj.base;
+	struct netvsc_driver *net_drv_obj = &g_netvsc_drv;
+	struct hv_driver *drv = &g_netvsc_drv.base;
 	int ret;
 
 	net_drv_obj->ring_buf_size = ring_size * PAGE_SIZE;
-- 
1.5.5.6

