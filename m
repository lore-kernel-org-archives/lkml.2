Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab2EIF43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:56:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38940 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756246Ab2EIFxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:54 -0400
Message-Id: <20120509055041.165623104@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 082/167] [PATCH] dummy: Add ndo_uninit().
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

commit 890fdf2a0cb88202d1427589db2cf29c1bdd3c1d upstream.

In register_netdevice(), when ndo_init() is successful and later
some error occurred, ndo_uninit() will be called.
So dummy deivce is desirable to implement ndo_uninit() method
to free percpu stats for this case.
And, ndo_uninit() is also called along with dev->destructor() when
device is unregistered, so in order to prevent dev->dstats from
being freed twice, dev->destructor is modified to free_netdev().

Signed-off-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/dummy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index d5c6d92..442d91a 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -107,14 +107,14 @@ static int dummy_dev_init(struct net_device *dev)
 	return 0;
 }
 
-static void dummy_dev_free(struct net_device *dev)
+static void dummy_dev_uninit(struct net_device *dev)
 {
 	free_percpu(dev->dstats);
-	free_netdev(dev);
 }
 
 static const struct net_device_ops dummy_netdev_ops = {
 	.ndo_init		= dummy_dev_init,
+	.ndo_uninit		= dummy_dev_uninit,
 	.ndo_start_xmit		= dummy_xmit,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= set_multicast_list,
@@ -128,7 +128,7 @@ static void dummy_setup(struct net_device *dev)
 
 	/* Initialize the device structure. */
 	dev->netdev_ops = &dummy_netdev_ops;
-	dev->destructor = dummy_dev_free;
+	dev->destructor = free_netdev;
 
 	/* Fill in device structure with ethernet-generic values. */
 	dev->tx_queue_len = 0;
-- 
1.7.10



