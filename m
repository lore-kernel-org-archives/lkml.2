Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab1BWULX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:11:23 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:38764
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755465Ab1BWULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:11:21 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 2/4] staging: hv: Fix the code depending on struct netvsc_driver_context data order
Date: Wed, 23 Feb 2011 12:19:56 -0800
Message-Id: <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixed the code depending on the exact order of fields in the
struct netvsc_driver_context. Now, we use container_of() instead of type
casting from the first field to the container struct.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/netvsc_drv.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 364b6c7..c78624c 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -49,8 +49,6 @@ struct net_device_context {
 };
 
 struct netvsc_driver_context {
-	/* !! These must be the first 2 fields !! */
-	/* Which is a bug FIXME! */
 	struct driver_context drv_ctx;
 	struct netvsc_driver drv_obj;
 };
@@ -137,8 +135,8 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	struct net_device_context *net_device_ctx = netdev_priv(net);
 	struct driver_context *driver_ctx =
 	    driver_to_driver_context(net_device_ctx->device_ctx->device.driver);
-	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)driver_ctx;
+	struct netvsc_driver_context *net_drv_ctx = container_of(driver_ctx,
+		struct netvsc_driver_context, drv_ctx);
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct hv_netvsc_packet *packet;
 	int ret;
@@ -342,8 +340,8 @@ static int netvsc_probe(struct device *device)
 {
 	struct driver_context *driver_ctx =
 		driver_to_driver_context(device->driver);
-	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)driver_ctx;
+	struct netvsc_driver_context *net_drv_ctx = container_of(driver_ctx,
+		struct netvsc_driver_context, drv_ctx);
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
@@ -414,8 +412,8 @@ static int netvsc_remove(struct device *device)
 {
 	struct driver_context *driver_ctx =
 		driver_to_driver_context(device->driver);
-	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)driver_ctx;
+	struct netvsc_driver_context *net_drv_ctx = container_of(driver_ctx,
+		struct netvsc_driver_context, drv_ctx);
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct net_device *net = dev_get_drvdata(&device_ctx->device);
-- 
1.6.3.2

