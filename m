Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031817Ab2I1UDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:03:21 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63190 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913Ab2I1SzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 033/262] cs89x0 : packet reception not working
Date: Fri, 28 Sep 2012 11:49:22 -0700
Message-Id: <20120928183001.841597138@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>

[ Upstream commit b72c200975a4ed579dbf3353019e19528745a29a ]

The RxCFG register of the CS89x0 could be configured incorrectly
(because of misplaced parentheses), resulting in the disabling
of packet reception.

Signed-off-by: Jaccon Bastiaansen <jaccon.bastiaansen@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cirrus/cs89x0.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1243,6 +1243,7 @@ static void set_multicast_list(struct ne
 {
 	struct net_local *lp = netdev_priv(dev);
 	unsigned long flags;
+	u16 cfg;
 
 	spin_lock_irqsave(&lp->lock, flags);
 	if (dev->flags & IFF_PROMISC)
@@ -1260,11 +1261,10 @@ static void set_multicast_list(struct ne
 	/* in promiscuous mode, we accept errored packets,
 	 * so we have to enable interrupts on them also
 	 */
-	writereg(dev, PP_RxCFG,
-		 (lp->curr_rx_cfg |
-		  (lp->rx_mode == RX_ALL_ACCEPT)
-		  ? (RX_CRC_ERROR_ENBL | RX_RUNT_ENBL | RX_EXTRA_DATA_ENBL)
-		  : 0));
+	cfg = lp->curr_rx_cfg;
+	if (lp->rx_mode == RX_ALL_ACCEPT)
+		cfg |= RX_CRC_ERROR_ENBL | RX_RUNT_ENBL | RX_EXTRA_DATA_ENBL;
+	writereg(dev, PP_RxCFG, cfg);
 	spin_unlock_irqrestore(&lp->lock, flags);
 }
 


