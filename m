Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1G1XpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:45:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:62194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab1G1Xou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552548"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: kys@microsoft.com, haiyangz@microsoft.com, hjanssen@microsoft.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [45/50] Staging: hv: netvsc: Fix a bug in accounting transmit slots
Message-Id: <20110728234450.1CB812403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: K. Y. Srinivasan <kys@microsoft.com>

[ upstream commit 9079ce691255792009c446d8c3382507b8d38635 ]

The transmit slots were manipulated without proper locking. Fix this bug by
making the variable tracking the transmit slots atomic.

This patch should be ported to prior stable kernels 2.6.32 and later.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/staging/hv/netvsc_drv.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/hv/netvsc_drv.c
+++ linux-2.6.35.y/drivers/staging/hv/netvsc_drv.c
@@ -19,6 +19,7 @@
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
 #include <linux/init.h>
+#include <linux/atomic.h>
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/device.h>
@@ -45,7 +46,7 @@
 struct net_device_context {
 	/* point back to our device context */
 	struct vm_device *device_ctx;
-	unsigned long avail;
+	atomic_t avail;
 	struct work_struct work;
 };
 
@@ -133,7 +134,9 @@ static void netvsc_xmit_completion(void 
 
 		dev_kfree_skb_any(skb);
 
-		if ((net_device_ctx->avail += num_pages) >= PACKET_PAGES_HIWATER)
+		atomic_add(num_pages, &net_device_ctx->avail);
+		if (atomic_read(&net_device_ctx->avail) >=
+				PACKET_PAGES_HIWATER)
  			netif_wake_queue(net);
 	}
 
@@ -159,7 +162,7 @@ static int netvsc_start_xmit(struct sk_b
 
 	/* Add 1 for skb->data and additional one for RNDIS */
 	num_pages = skb_shinfo(skb)->nr_frags + 1 + 1;
-	if (num_pages > net_device_ctx->avail)
+	if (num_pages > atomic_read(&net_device_ctx->avail))
 		return NETDEV_TX_BUSY;
 
 	/* Allocate a netvsc packet based on # of frags. */
@@ -218,7 +221,8 @@ static int netvsc_start_xmit(struct sk_b
 			   net->stats.tx_packets,
 			   net->stats.tx_bytes);
 
-		if ((net_device_ctx->avail -= num_pages) < PACKET_PAGES_LOWATER)
+		atomic_sub(num_pages, &net_device_ctx->avail);
+		if (atomic_read(&net_device_ctx->avail) < PACKET_PAGES_LOWATER)
 			netif_stop_queue(net);
 	} else {
 		/* we are shutting down or bus overloaded, just drop packet */
@@ -406,7 +410,7 @@ static int netvsc_probe(struct device *d
 
 	net_device_ctx = netdev_priv(net);
 	net_device_ctx->device_ctx = device_ctx;
-	net_device_ctx->avail = ring_size;
+	atomic_set(&net_device_ctx->avail, ring_size);
 	dev_set_drvdata(device, net);
 	INIT_WORK(&net_device_ctx->work, netvsc_send_garp);
 
