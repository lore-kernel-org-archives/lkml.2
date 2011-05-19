Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130Ab1ESSPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:15:42 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54880 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934060Ab1ESSI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:56 -0400
X-Sasl-enc: nHXsxJIbrRxSj7J5+s5VOTK4scTPr1v09ETtBoZ0Yx/J 1305828535
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:58 2011
Message-Id: <20110519180558.623546432@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [45/71] zorro8390: Fix regression caused during net_device_ops conversion
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit cf7e032fc87d59c475df26c4d40bf45d401b2adb upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/Makefile    |    2 +-
 drivers/net/zorro8390.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -217,7 +217,7 @@ obj-$(CONFIG_SC92031) += sc92031.o
 obj-$(CONFIG_LP486E) += lp486e.o
 
 obj-$(CONFIG_ETH16I) += eth16i.o
-obj-$(CONFIG_ZORRO8390) += zorro8390.o 8390.o
+obj-$(CONFIG_ZORRO8390) += zorro8390.o
 obj-$(CONFIG_HPLANCE) += hplance.o 7990.o
 obj-$(CONFIG_MVME147_NET) += mvme147.o 7990.o
 obj-$(CONFIG_EQUALIZER) += eql.o
--- a/drivers/net/zorro8390.c
+++ b/drivers/net/zorro8390.c
@@ -126,7 +126,7 @@ static int __devinit zorro8390_init_one(
 
     board = z->resource.start;
     ioaddr = board+cards[i].offset;
-    dev = alloc_ei_netdev();
+    dev = ____alloc_ei_netdev(0);
     if (!dev)
 	return -ENOMEM;
     if (!request_mem_region(ioaddr, NE_IO_EXTENT*2, DRV_NAME)) {
@@ -146,15 +146,15 @@ static int __devinit zorro8390_init_one(
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
 


