Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab1IATgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:36:40 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:34067
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757811Ab1IATgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:36:39 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 05/10] staging: hv: re-order the code in netvsc_probe()
Date: Thu,  1 Sep 2011 12:19:43 -0700
Message-Id: <1314904788-32746-6-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
References: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-order the code in netvsc_probe() to prevent a guest crash caused by
packets possibly received from NetVSP before call to register_netdev().

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index e6513be..b49a08f 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -348,19 +348,6 @@ static int netvsc_probe(struct hv_device *dev)
 	dev_set_drvdata(&dev->device, net);
 	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_send_garp);
 
-	/* Notify the netvsc driver of the new device */
-	device_info.ring_size = ring_size;
-	ret = rndis_filter_device_add(dev, &device_info);
-	if (ret != 0) {
-		free_netdev(net);
-		dev_set_drvdata(&dev->device, NULL);
-		return ret;
-	}
-
-	netif_carrier_on(net);
-
-	memcpy(net->dev_addr, device_info.mac_adr, ETH_ALEN);
-
 	net->netdev_ops = &device_ops;
 
 	/* TODO: Add GSO and Checksum offload */
@@ -372,11 +359,26 @@ static int netvsc_probe(struct hv_device *dev)
 
 	ret = register_netdev(net);
 	if (ret != 0) {
-		/* Remove the device and release the resource */
-		rndis_filter_device_remove(dev);
+		pr_err("Unable to register netdev.\n");
 		free_netdev(net);
+		goto out;
 	}
 
+	/* Notify the netvsc driver of the new device */
+	device_info.ring_size = ring_size;
+	ret = rndis_filter_device_add(dev, &device_info);
+	if (ret != 0) {
+		netdev_err(net, "unable to add netvsc device (ret %d)\n", ret);
+		unregister_netdev(net);
+		free_netdev(net);
+		dev_set_drvdata(&dev->device, NULL);
+		return ret;
+	}
+	memcpy(net->dev_addr, device_info.mac_adr, ETH_ALEN);
+
+	netif_carrier_on(net);
+
+out:
 	return ret;
 }
 
-- 
1.6.3.2

