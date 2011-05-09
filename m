Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1EIV5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:57:45 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47558
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752622Ab1EIVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 075/206] Staging: hv: Get rid of the indirection in invoking rndis_filter_device_remove()
Date: Mon,  9 May 2011 14:55:57 -0700
Message-Id: <1304978288-22999-75-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index d962308..3fc39cd 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -342,8 +342,6 @@ static void netvsc_send_garp(struct work_struct *w)
 
 static int netvsc_probe(struct hv_device *dev)
 {
-	struct netvsc_driver *net_drv_obj =
-		drv_to_netvscdrv(dev->device.driver);
 	struct net_device *net = NULL;
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device_info device_info;
@@ -398,7 +396,7 @@ static int netvsc_probe(struct hv_device *dev)
 	ret = register_netdev(net);
 	if (ret != 0) {
 		/* Remove the device and release the resource */
-		net_drv_obj->base.dev_rm(dev);
+		rndis_filter_device_remove(dev);
 		free_netdev(net);
 	}
 
@@ -407,8 +405,6 @@ static int netvsc_probe(struct hv_device *dev)
 
 static int netvsc_remove(struct hv_device *dev)
 {
-	struct netvsc_driver *net_drv_obj =
-		drv_to_netvscdrv(dev->device.driver);
 	struct net_device *net = dev_get_drvdata(&dev->device);
 	int ret;
 
@@ -417,9 +413,6 @@ static int netvsc_remove(struct hv_device *dev)
 		return 0;
 	}
 
-	if (!net_drv_obj->base.dev_rm)
-		return -1;
-
 	/* Stop outbound asap */
 	netif_stop_queue(net);
 	/* netif_carrier_off(net); */
@@ -430,7 +423,7 @@ static int netvsc_remove(struct hv_device *dev)
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = net_drv_obj->base.dev_rm(dev);
+	ret = rndis_filter_device_remove(dev);
 	if (ret != 0) {
 		/* TODO: */
 		netdev_err(net, "unable to remove vsc device (ret %d)\n", ret);
-- 
1.7.4.1

