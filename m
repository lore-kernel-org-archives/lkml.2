Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1ELTMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:12:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:56998 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab1ELTMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:12:36 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Russell King <linux@arm.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@chicken.sonytel.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>, stable@kernel.org
Subject: [PATCH 3/3] ne-h8300: Fix regression caused during net_device_ops conversion
Date: Thu, 12 May 2011 19:11:40 +0000
Message-Id: <1305227500-15595-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305227500-15595-1-git-send-email-geert@linux-m68k.org>
References: <1305227500-15595-1-git-send-email-geert@linux-m68k.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 May 2011 19:12:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@chicken.sonytel.be>

Changeset dcd39c90290297f6e6ed8a04bb20da7ac2b043c5 ("ne-h8300: convert to
net_device_ops") broke ne-h8300 by adding 8390.o to the link. That
meant that lib8390.c was included twice, once in ne-h8300.c and once in
8390.c, subject to different macros. This patch reverts that by
avoiding the wrappers in 8390.c.

Fix based on commits 217cbfa856dc1cbc2890781626c4032d9e3ec59f ("mac8390:
fix regression caused during net_device_ops conversion") and
4e0168fa4842e27795a75b205a510f25b62181d9 ("mac8390: fix build with
NET_POLL_CONTROLLER").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@kernel.org
---
 drivers/net/Makefile   |    2 +-
 drivers/net/ne-h8300.c |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 4d2f094..e5a7375 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -144,7 +144,7 @@ obj-$(CONFIG_NE3210) += ne3210.o 8390.o
 obj-$(CONFIG_SB1250_MAC) += sb1250-mac.o
 obj-$(CONFIG_B44) += b44.o
 obj-$(CONFIG_FORCEDETH) += forcedeth.o
-obj-$(CONFIG_NE_H8300) += ne-h8300.o 8390.o
+obj-$(CONFIG_NE_H8300) += ne-h8300.o
 obj-$(CONFIG_AX88796) += ax88796.o
 obj-$(CONFIG_BCM63XX_ENET) += bcm63xx_enet.o
 obj-$(CONFIG_FTMAC100) += ftmac100.o
diff --git a/drivers/net/ne-h8300.c b/drivers/net/ne-h8300.c
index 30be8c6..7298a34 100644
--- a/drivers/net/ne-h8300.c
+++ b/drivers/net/ne-h8300.c
@@ -167,7 +167,7 @@ static void cleanup_card(struct net_device *dev)
 #ifndef MODULE
 struct net_device * __init ne_probe(int unit)
 {
-	struct net_device *dev = alloc_ei_netdev();
+	struct net_device *dev = ____alloc_ei_netdev(0);
 	int err;
 
 	if (!dev)
@@ -197,15 +197,15 @@ static const struct net_device_ops ne_netdev_ops = {
 	.ndo_open		= ne_open,
 	.ndo_stop		= ne_close,
 
-	.ndo_start_xmit		= ei_start_xmit,
-	.ndo_tx_timeout		= ei_tx_timeout,
-	.ndo_get_stats		= ei_get_stats,
-	.ndo_set_multicast_list = ei_set_multicast_list,
+	.ndo_start_xmit		= __ei_start_xmit,
+	.ndo_tx_timeout		= __ei_tx_timeout,
+	.ndo_get_stats		= __ei_get_stats,
+	.ndo_set_multicast_list = __ei_set_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_change_mtu		= eth_change_mtu,
 #ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= ei_poll,
+	.ndo_poll_controller	= __ei_poll,
 #endif
 };
 
@@ -637,7 +637,7 @@ int init_module(void)
 	int err;
 
 	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
-		struct net_device *dev = alloc_ei_netdev();
+		struct net_device *dev = ____alloc_ei_netdev(0);
 		if (!dev)
 			break;
 		if (io[this_dev]) {
-- 
1.7.0.4

