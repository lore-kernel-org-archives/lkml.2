Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab1FPUCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:02:03 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52091
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758151Ab1FPUB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:01:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>, stable <stable@kernel.org>
Subject: [PATCH 04/77] Staging: hv: netvsc: Fix a bug in accounting transmit slots
Date: Thu, 16 Jun 2011 13:16:37 -0700
Message-Id: <1308255470-3826-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The transmit slots were manipulated without proper locking. Fix this bug by 
making the variable tracking the transmit slots atomic.

This patch should be ported to prior stable kernels 2.6.32 and later. 


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Cc: stable <stable@kernel.org>
---
 drivers/staging/hv/netvsc_drv.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 33cab9c..38ca2c2 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -21,6 +21,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
+#include <linux/atomic.h>
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/device.h>
@@ -45,7 +46,7 @@
 struct net_device_context {
 	/* point back to our device context */
 	struct hv_device *device_ctx;
-	unsigned long avail;
+	atomic_t avail;
 	struct delayed_work dwork;
 };
 
@@ -118,8 +119,9 @@ static void netvsc_xmit_completion(void *context)
 
 		dev_kfree_skb_any(skb);
 
-		net_device_ctx->avail += num_pages;
-		if (net_device_ctx->avail >= PACKET_PAGES_HIWATER)
+		atomic_add(num_pages, &net_device_ctx->avail);
+		if (atomic_read(&net_device_ctx->avail) >=
+				PACKET_PAGES_HIWATER)
  			netif_wake_queue(net);
 	}
 }
@@ -133,7 +135,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 
 	/* Add 1 for skb->data and additional one for RNDIS */
 	num_pages = skb_shinfo(skb)->nr_frags + 1 + 1;
-	if (num_pages > net_device_ctx->avail)
+	if (num_pages > atomic_read(&net_device_ctx->avail))
 		return NETDEV_TX_BUSY;
 
 	/* Allocate a netvsc packet based on # of frags. */
@@ -185,8 +187,8 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 		net->stats.tx_bytes += skb->len;
 		net->stats.tx_packets++;
 
-		net_device_ctx->avail -= num_pages;
-		if (net_device_ctx->avail < PACKET_PAGES_LOWATER)
+		atomic_sub(num_pages, &net_device_ctx->avail);
+		if (atomic_read(&net_device_ctx->avail) < PACKET_PAGES_LOWATER)
 			netif_stop_queue(net);
 	} else {
 		/* we are shutting down or bus overloaded, just drop packet */
@@ -345,7 +347,7 @@ static int netvsc_probe(struct hv_device *dev)
 
 	net_device_ctx = netdev_priv(net);
 	net_device_ctx->device_ctx = dev;
-	net_device_ctx->avail = ring_size;
+	atomic_set(&net_device_ctx->avail, ring_size);
 	dev_set_drvdata(&dev->device, net);
 	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_send_garp);
 
-- 
1.7.4.1

