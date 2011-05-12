Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab1ELTMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:12:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:57041 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab1ELTMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:12:51 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Russell King <linux@arm.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, stable@kernel.org
Subject: [PATCH 1/3] zorro8390: Fix regression caused during net_device_ops conversion
Date: Thu, 12 May 2011 19:11:38 +0000
Message-Id: <1305227500-15595-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305227500-15595-1-git-send-email-geert@linux-m68k.org>
References: <1305227500-15595-1-git-send-email-geert@linux-m68k.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 May 2011 19:12:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changeset b6114794a1c394534659f4a17420e48cf23aa922 ("zorro8390: convert to
net_device_ops") broke zorro8390 by adding 8390.o to the link. That
meant that lib8390.c was included twice, once in zorro8390.c and once in
8390.c, subject to different macros. This patch reverts that by
avoiding the wrappers in 8390.c.

Fix based on commits 217cbfa856dc1cbc2890781626c4032d9e3ec59f ("mac8390:
fix regression caused during net_device_ops conversion") and
4e0168fa4842e27795a75b205a510f25b62181d9 ("mac8390: fix build with
NET_POLL_CONTROLLER").

Reported-by: Christian T. Steigies <cts@debian.org>
Suggested-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Christian T. Steigies <cts@debian.org>
Cc: stable@kernel.org
---
 drivers/net/Makefile    |    2 +-
 drivers/net/zorro8390.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 01b604a..c64675f 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -219,7 +219,7 @@ obj-$(CONFIG_SC92031) += sc92031.o
 obj-$(CONFIG_LP486E) += lp486e.o
 
 obj-$(CONFIG_ETH16I) += eth16i.o
-obj-$(CONFIG_ZORRO8390) += zorro8390.o 8390.o
+obj-$(CONFIG_ZORRO8390) += zorro8390.o
 obj-$(CONFIG_HPLANCE) += hplance.o 7990.o
 obj-$(CONFIG_MVME147_NET) += mvme147.o 7990.o
 obj-$(CONFIG_EQUALIZER) += eql.o
diff --git a/drivers/net/zorro8390.c b/drivers/net/zorro8390.c
index b78a38d..8c7c522 100644
--- a/drivers/net/zorro8390.c
+++ b/drivers/net/zorro8390.c
@@ -126,7 +126,7 @@ static int __devinit zorro8390_init_one(struct zorro_dev *z,
 
     board = z->resource.start;
     ioaddr = board+cards[i].offset;
-    dev = alloc_ei_netdev();
+    dev = ____alloc_ei_netdev(0);
     if (!dev)
 	return -ENOMEM;
     if (!request_mem_region(ioaddr, NE_IO_EXTENT*2, DRV_NAME)) {
@@ -146,15 +146,15 @@ static int __devinit zorro8390_init_one(struct zorro_dev *z,
 static const struct net_device_ops zorro8390_netdev_ops = {
 	.ndo_open		= zorro8390_open,
 	.ndo_stop		= zorro8390_close,
-	.ndo_start_xmit		= ei_start_xmit,
-	.ndo_tx_timeout		= ei_tx_timeout,
-	.ndo_get_stats		= ei_get_stats,
-	.ndo_set_multicast_list = ei_set_multicast_list,
+	.ndo_start_xmit		= __ei_start_xmit,
+	.ndo_tx_timeout		= __ei_tx_timeout,
+	.ndo_get_stats		= __ei_get_stats,
+	.ndo_set_multicast_list = __ei_set_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_change_mtu		= eth_change_mtu,
 #ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= ei_poll,
+	.ndo_poll_controller	= __ei_poll,
 #endif
 };
 
-- 
1.7.0.4

