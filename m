Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379Ab1ESScl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:32:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40694 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934365Ab1ESScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:36 -0400
X-Sasl-enc: ugTo3wzcGGsL+zYuW7IThdSFC27pwRaMd8fBZbKWyytc 1305829955
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:26 2011
Message-Id: <20110519183126.603523519@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [10/24] ne-h8300: Fix regression caused during net_device_ops conversion
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2616
Lines: 78

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 2592a7354092afd304a8c067319b15ab1e441e35 upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/Makefile   |    2 +-
 drivers/net/ne-h8300.c |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -138,7 +138,7 @@ obj-$(CONFIG_NE3210) += ne3210.o 8390.o
 obj-$(CONFIG_SB1250_MAC) += sb1250-mac.o
 obj-$(CONFIG_B44) += b44.o
 obj-$(CONFIG_FORCEDETH) += forcedeth.o
-obj-$(CONFIG_NE_H8300) += ne-h8300.o 8390.o
+obj-$(CONFIG_NE_H8300) += ne-h8300.o
 obj-$(CONFIG_AX88796) += ax88796.o
 obj-$(CONFIG_BCM63XX_ENET) += bcm63xx_enet.o
 
--- a/drivers/net/ne-h8300.c
+++ b/drivers/net/ne-h8300.c
@@ -167,7 +167,7 @@ static void cleanup_card(struct net_devi
 #ifndef MODULE
 struct net_device * __init ne_probe(int unit)
 {
-	struct net_device *dev = alloc_ei_netdev();
+	struct net_device *dev = ____alloc_ei_netdev(0);
 	int err;
 
 	if (!dev)
@@ -197,15 +197,15 @@ static const struct net_device_ops ne_ne
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
 
@@ -638,7 +638,7 @@ int init_module(void)
 	int err;
 
 	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
-		struct net_device *dev = alloc_ei_netdev();
+		struct net_device *dev = ____alloc_ei_netdev(0);
 		if (!dev)
 			break;
 		if (io[this_dev]) {


