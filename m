Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab1FPMMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:12:15 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40329 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757145Ab1FPMMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:12:10 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jun 2011 08:12:09 EDT
Date: Thu, 16 Jun 2011 14:12:08 +0200
From: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
To: "David S. Miller" <davem@davemloft.net>,
        David Decotigny <decot@google.com>, "Hans J. Koch" <hjk@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Ben Pfaff <blp@cs.stanford.edu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: christian.dietrich@informatik.uni-erlangen.de
Subject: [PATCH 06/11] drivers/net: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <bbe5954082599bcf65e9fdf565df8b9646ec3e3b.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since printk_ratelimit() shouldn't be used anymore (see comment in
include/linux/printk.h), replace it with printk_ratelimited()

Signed-off-by: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
---
 drivers/net/sc92031.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/sc92031.c b/drivers/net/sc92031.c
index fa74314..6f6bbb3 100644
--- a/drivers/net/sc92031.c
+++ b/drivers/net/sc92031.c
@@ -31,6 +31,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/crc32.h>
+#include <linux/ratelimit.h>
 
 #include <asm/irq.h>
 
@@ -536,8 +537,7 @@ static bool _sc92031_check_media(struct net_device *dev)
 
 		netif_carrier_on(dev);
 
-		if (printk_ratelimit())
-			printk(KERN_INFO "%s: link up, %sMbps, %s-duplex\n",
+		printk_ratelimited(KERN_INFO "%s: link up, %sMbps, %s-duplex\n",
 				dev->name,
 				speed_100 ? "100" : "10",
 				duplex_full ? "full" : "half");
@@ -549,8 +549,7 @@ static bool _sc92031_check_media(struct net_device *dev)
 
 		_sc92031_disable_tx_rx(dev);
 
-		if (printk_ratelimit())
-			printk(KERN_INFO "%s: link down\n", dev->name);
+		printk_ratelimited(KERN_INFO "%s: link down\n", dev->name);
 		return false;
 	}
 }
@@ -755,8 +754,7 @@ static void _sc92031_rx_tasklet(struct net_device *dev)
 		return;
 
 	if (unlikely(rx_len > RX_BUF_LEN)) {
-		if (printk_ratelimit())
-			printk(KERN_ERR "%s: rx packets length > rx buffer\n",
+		printk_ratelimited(KERN_ERR "%s: rx packets length > rx buffer\n",
 					dev->name);
 		return;
 	}
@@ -786,8 +784,7 @@ static void _sc92031_rx_tasklet(struct net_device *dev)
 		}
 
 		if (unlikely(rx_size_align + 4 > rx_len)) {
-			if (printk_ratelimit())
-				printk(KERN_ERR "%s: rx_len is too small\n", dev->name);
+			printk_ratelimited(KERN_ERR "%s: rx_len is too small\n", dev->name);
 			break;
 		}
 
@@ -795,8 +792,7 @@ static void _sc92031_rx_tasklet(struct net_device *dev)
 
 		skb = netdev_alloc_skb_ip_align(dev, pkt_size);
 		if (unlikely(!skb)) {
-			if (printk_ratelimit())
-				printk(KERN_ERR "%s: Couldn't allocate a skb_buff for a packet of size %u\n",
+			printk_ratelimited(KERN_ERR "%s: Couldn't allocate a skb_buff for a packet of size %u\n",
 						dev->name, pkt_size);
 			goto next;
 		}
-- 
1.7.4.1

