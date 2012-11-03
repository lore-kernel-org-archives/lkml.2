Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2KCJxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 05:53:23 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:62189 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753948Ab2KCJxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 05:53:21 -0400
Message-ID: <1351936395.1434.2.camel@x61.thuisdomein>
Subject: [PATCH] atp: remove set_rx_mode_8012()
From: Paul Bolle <pebolle@tiscali.nl>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 03 Nov 2012 10:53:15 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Nov 2012 09:53:15.0882 (UTC) FILETIME=[0B994CA0:01CDB9A9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building atp.o triggers this GCC warning:
    drivers/net/ethernet/realtek/atp.c: In function ‘set_rx_mode’:
    drivers/net/ethernet/realtek/atp.c:871:26: warning: ‘mc_filter[0]’ may be used uninitialized in this function [-Wuninitialized]

GCC is correct. In promiscuous mode 'mc_filter' will be used
uninitialized in set_rx_mode_8012(), which is apparently inlined into
set_rx_mode().

But it turns out set_rx_mode_8012() will never be called, since
net_local.chip_type will always be RTL8002. So we can just remove
set_rx_mode_8012() and do some related cleanups.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Note: compile test only.

 drivers/net/ethernet/realtek/atp.c | 58 ++------------------------------------
 drivers/net/ethernet/realtek/atp.h |  2 --
 2 files changed, 2 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/realtek/atp.c
index e02f04d..9f2d416 100644
--- a/drivers/net/ethernet/realtek/atp.c
+++ b/drivers/net/ethernet/realtek/atp.c
@@ -175,8 +175,7 @@ struct net_local {
     unsigned int tx_unit_busy:1;
     unsigned char re_tx,	/* Number of packet retransmissions. */
 		addr_mode,		/* Current Rx filter e.g. promiscuous, etc. */
-		pac_cnt_in_tx_buf,
-		chip_type;
+		pac_cnt_in_tx_buf;
 };
 
 /* This code, written by wwc@super.org, resets the adapter every
@@ -339,7 +338,6 @@ static int __init atp_probe1(long ioaddr)
 	write_reg_high(ioaddr, CMR1, CMR1h_RESET | CMR1h_MUX);
 
 	lp = netdev_priv(dev);
-	lp->chip_type = RTL8002;
 	lp->addr_mode = CMR2h_Normal;
 	spin_lock_init(&lp->lock);
 
@@ -852,7 +850,7 @@ net_close(struct net_device *dev)
  *	Set or clear the multicast filter for this adapter.
  */
 
-static void set_rx_mode_8002(struct net_device *dev)
+static void set_rx_mode(struct net_device *dev)
 {
 	struct net_local *lp = netdev_priv(dev);
 	long ioaddr = dev->base_addr;
@@ -864,58 +862,6 @@ static void set_rx_mode_8002(struct net_device *dev)
 	write_reg_high(ioaddr, CMR2, lp->addr_mode);
 }
 
-static void set_rx_mode_8012(struct net_device *dev)
-{
-	struct net_local *lp = netdev_priv(dev);
-	long ioaddr = dev->base_addr;
-	unsigned char new_mode, mc_filter[8]; /* Multicast hash filter */
-	int i;
-
-	if (dev->flags & IFF_PROMISC) {			/* Set promiscuous. */
-		new_mode = CMR2h_PROMISC;
-	} else if ((netdev_mc_count(dev) > 1000) ||
-		   (dev->flags & IFF_ALLMULTI)) {
-		/* Too many to filter perfectly -- accept all multicasts. */
-		memset(mc_filter, 0xff, sizeof(mc_filter));
-		new_mode = CMR2h_Normal;
-	} else {
-		struct netdev_hw_addr *ha;
-
-		memset(mc_filter, 0, sizeof(mc_filter));
-		netdev_for_each_mc_addr(ha, dev) {
-			int filterbit = ether_crc_le(ETH_ALEN, ha->addr) & 0x3f;
-			mc_filter[filterbit >> 5] |= 1 << (filterbit & 31);
-		}
-		new_mode = CMR2h_Normal;
-	}
-	lp->addr_mode = new_mode;
-    write_reg(ioaddr, CMR2, CMR2_IRQOUT | 0x04); /* Switch to page 1. */
-    for (i = 0; i < 8; i++)
-		write_reg_byte(ioaddr, i, mc_filter[i]);
-	if (net_debug > 2 || 1) {
-		lp->addr_mode = 1;
-		printk(KERN_DEBUG "%s: Mode %d, setting multicast filter to",
-			   dev->name, lp->addr_mode);
-		for (i = 0; i < 8; i++)
-			printk(" %2.2x", mc_filter[i]);
-		printk(".\n");
-	}
-
-	write_reg_high(ioaddr, CMR2, lp->addr_mode);
-    write_reg(ioaddr, CMR2, CMR2_IRQOUT); /* Switch back to page 0 */
-}
-
-static void set_rx_mode(struct net_device *dev)
-{
-	struct net_local *lp = netdev_priv(dev);
-
-	if (lp->chip_type == RTL8002)
-		return set_rx_mode_8002(dev);
-	else
-		return set_rx_mode_8012(dev);
-}
-
-
 static int __init atp_init_module(void) {
 	if (debug)					/* Emit version even if no cards detected. */
 		printk(KERN_INFO "%s", version);
diff --git a/drivers/net/ethernet/realtek/atp.h b/drivers/net/ethernet/realtek/atp.h
index 0edc642..040b137 100644
--- a/drivers/net/ethernet/realtek/atp.h
+++ b/drivers/net/ethernet/realtek/atp.h
@@ -16,8 +16,6 @@ struct rx_header {
 #define PAR_STATUS	1
 #define PAR_CONTROL 2
 
-enum chip_type { RTL8002, RTL8012 };
-
 #define Ctrl_LNibRead	0x08	/* LP_PSELECP */
 #define Ctrl_HNibRead	0
 #define Ctrl_LNibWrite	0x08	/* LP_PSELECP */
-- 
1.7.11.7

