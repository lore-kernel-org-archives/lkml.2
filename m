Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab2DKXOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:14:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2DKXOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:14:33 -0400
Message-Id: <20120411231018.542879288@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Mohr <andi@lisas.de>,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Lv <DavidLv@viatech.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 02/78] via-rhine: fix wait-bit inversion.
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Andreas Mohr <andi@lisas.de>

[ Upstream commit 3f8c91a7398b9266fbe7abcbe4bd5dffef907643 ]

Bug appeared in a384a33bb1c9ec2d99db2046b41f57023fa7d77b
("via-rhine: RHINE_WAIT_FOR macro removal). It can be noticed
during suspend/resume.

Signed-off-by: Andreas Mohr <andi@lisas.de>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: David Lv <DavidLv@viatech.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/via/via-rhine.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -503,30 +503,32 @@ static int rhine_vlan_rx_add_vid(struct
 static int rhine_vlan_rx_kill_vid(struct net_device *dev, unsigned short vid);
 static void rhine_restart_tx(struct net_device *dev);
 
-static void rhine_wait_bit(struct rhine_private *rp, u8 reg, u8 mask, bool high)
+static void rhine_wait_bit(struct rhine_private *rp, u8 reg, u8 mask, bool low)
 {
 	void __iomem *ioaddr = rp->base;
 	int i;
 
 	for (i = 0; i < 1024; i++) {
-		if (high ^ !!(ioread8(ioaddr + reg) & mask))
+		bool has_mask_bits = !!(ioread8(ioaddr + reg) & mask);
+
+		if (low ^ has_mask_bits)
 			break;
 		udelay(10);
 	}
 	if (i > 64) {
 		netif_dbg(rp, hw, rp->dev, "%s bit wait (%02x/%02x) cycle "
-			  "count: %04d\n", high ? "high" : "low", reg, mask, i);
+			  "count: %04d\n", low ? "low" : "high", reg, mask, i);
 	}
 }
 
 static void rhine_wait_bit_high(struct rhine_private *rp, u8 reg, u8 mask)
 {
-	rhine_wait_bit(rp, reg, mask, true);
+	rhine_wait_bit(rp, reg, mask, false);
 }
 
 static void rhine_wait_bit_low(struct rhine_private *rp, u8 reg, u8 mask)
 {
-	rhine_wait_bit(rp, reg, mask, false);
+	rhine_wait_bit(rp, reg, mask, true);
 }
 
 static u32 rhine_get_events(struct rhine_private *rp)


