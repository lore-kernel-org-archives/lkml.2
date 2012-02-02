Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab2BBRiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:38:21 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35909
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932673Ab2BBRiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:38:18 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, kys@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net/hyperv: Use netif_tx_disable() instead of netif_stop_queue() when necessary
Date: Thu,  2 Feb 2012 09:17:59 -0800
Message-Id: <1328203080-801-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For code path not on the xmit, use netif_tx_disable() instead of
netif_stop_queue() to ensure other CPUs are not doing xmit.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 9dccc7a..69193fc 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -123,7 +123,7 @@ static int netvsc_close(struct net_device *net)
 	struct hv_device *device_obj = net_device_ctx->device_ctx;
 	int ret;
 
-	netif_stop_queue(net);
+	netif_tx_disable(net);
 
 	ret = rndis_filter_close(device_obj);
 	if (ret != 0)
@@ -256,7 +256,7 @@ void netvsc_linkstatus_callback(struct hv_device *device_obj,
 		schedule_delayed_work(&ndev_ctx->dwork, msecs_to_jiffies(20));
 	} else {
 		netif_carrier_off(net);
-		netif_stop_queue(net);
+		netif_tx_disable(net);
 	}
 }
 
@@ -337,7 +337,7 @@ static int netvsc_change_mtu(struct net_device *ndev, int mtu)
 
 	nvdev->start_remove = true;
 	cancel_delayed_work_sync(&ndevctx->dwork);
-	netif_stop_queue(ndev);
+	netif_tx_disable(ndev);
 	rndis_filter_device_remove(hdev);
 
 	ndev->mtu = mtu;
@@ -460,7 +460,7 @@ static int netvsc_remove(struct hv_device *dev)
 	cancel_delayed_work_sync(&ndev_ctx->dwork);
 
 	/* Stop outbound asap */
-	netif_stop_queue(net);
+	netif_tx_disable(net);
 
 	unregister_netdev(net);
 
-- 
1.7.4.1

