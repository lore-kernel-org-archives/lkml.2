Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab0GEMOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 08:14:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47228 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608Ab0GEMO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 08:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dxDDHmvGiMI5zpLY9IQUAPTKp1QmTBYiFAa/SHenYNi4DbBD14Oou0P2WNEalCg5HR
         /ux0msUBc07wY7uLp79WK3lYbWjAlCKDy6W+2gfmawU05vlTtFMFTL3eDmE2wVbma5T1
         pn21P4JzYlqLomjD69zp+1+VHMNp4ze1hwums=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
       Jiri Pirko <jpirko@redhat.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Jiri Kosina <jkosina@suse.cz>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ni52: Use the instance of net_device_stats from net_device.
Date: Mon,  5 Jul 2010 16:14:23 +0400
Message-Id: <1278332065-17831-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since net_device has an instance of net_device_stats,
we can remove the instance of this from the adapter structure.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/net/ni52.c |   37 ++++++++++++++++++-------------------
 1 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ni52.c b/drivers/net/ni52.c
index 9bddb5f..33618ed 100644
--- a/drivers/net/ni52.c
+++ b/drivers/net/ni52.c
@@ -185,7 +185,6 @@ static void    ni52_xmt_int(struct net_device *dev);
 static void    ni52_rnr_int(struct net_device *dev);
 
 struct priv {
-	struct net_device_stats stats;
 	char __iomem *base;
 	char __iomem *mapped;
 	char __iomem *memtop;
@@ -972,10 +971,10 @@ static void ni52_rcv_int(struct net_device *dev)
 					memcpy_fromio(skb->data, p->base + readl(&rbd->buffer), totlen);
 					skb->protocol = eth_type_trans(skb, dev);
 					netif_rx(skb);
-					p->stats.rx_packets++;
-					p->stats.rx_bytes += totlen;
+					dev->stats.rx_packets++;
+					dev->stats.rx_bytes += totlen;
 				} else
-					p->stats.rx_dropped++;
+					dev->stats.rx_dropped++;
 			} else {
 				int rstat;
 				 /* free all RBD's until RBD_LAST is set */
@@ -993,12 +992,12 @@ static void ni52_rcv_int(struct net_device *dev)
 				writew(0, &rbd->status);
 				printk(KERN_ERR "%s: received oversized frame! length: %d\n",
 					dev->name, totlen);
-				p->stats.rx_dropped++;
+				dev->stats.rx_dropped++;
 			 }
 		} else {/* frame !(ok), only with 'save-bad-frames' */
 			printk(KERN_ERR "%s: oops! rfd-error-status: %04x\n",
 				dev->name, status);
-			p->stats.rx_errors++;
+			dev->stats.rx_errors++;
 		}
 		writeb(0, &p->rfd_top->stat_high);
 		writeb(RFD_SUSP, &p->rfd_top->last); /* maybe exchange by RFD_LAST */
@@ -1043,7 +1042,7 @@ static void ni52_rnr_int(struct net_device *dev)
 {
 	struct priv *p = netdev_priv(dev);
 
-	p->stats.rx_errors++;
+	dev->stats.rx_errors++;
 
 	wait_for_scb_cmd(dev);		/* wait for the last cmd, WAIT_4_FULLSTAT?? */
 	writeb(RUC_ABORT, &p->scb->cmd_ruc); /* usually the RU is in the 'no resource'-state .. abort it now. */
@@ -1076,29 +1075,29 @@ static void ni52_xmt_int(struct net_device *dev)
 		printk(KERN_ERR "%s: strange .. xmit-int without a 'COMPLETE'\n", dev->name);
 
 	if (status & STAT_OK) {
-		p->stats.tx_packets++;
-		p->stats.collisions += (status & TCMD_MAXCOLLMASK);
+		dev->stats.tx_packets++;
+		dev->stats.collisions += (status & TCMD_MAXCOLLMASK);
 	} else {
-		p->stats.tx_errors++;
+		dev->stats.tx_errors++;
 		if (status & TCMD_LATECOLL) {
 			printk(KERN_ERR "%s: late collision detected.\n",
 				dev->name);
-			p->stats.collisions++;
+			dev->stats.collisions++;
 		} else if (status & TCMD_NOCARRIER) {
-			p->stats.tx_carrier_errors++;
+			dev->stats.tx_carrier_errors++;
 			printk(KERN_ERR "%s: no carrier detected.\n",
 				dev->name);
 		} else if (status & TCMD_LOSTCTS)
 			printk(KERN_ERR "%s: loss of CTS detected.\n",
 				dev->name);
 		else if (status & TCMD_UNDERRUN) {
-			p->stats.tx_fifo_errors++;
+			dev->stats.tx_fifo_errors++;
 			printk(KERN_ERR "%s: DMA underrun detected.\n",
 				dev->name);
 		} else if (status & TCMD_MAXCOLL) {
 			printk(KERN_ERR "%s: Max. collisions exceeded.\n",
 				dev->name);
-			p->stats.collisions += 16;
+			dev->stats.collisions += 16;
 		}
 	}
 #if (NUM_XMIT_BUFFS > 1)
@@ -1286,12 +1285,12 @@ static struct net_device_stats *ni52_get_stats(struct net_device *dev)
 	ovrn = readw(&p->scb->ovrn_errs);
 	writew(0, &p->scb->ovrn_errs);
 
-	p->stats.rx_crc_errors += crc;
-	p->stats.rx_fifo_errors += ovrn;
-	p->stats.rx_frame_errors += aln;
-	p->stats.rx_dropped += rsc;
+	dev->stats.rx_crc_errors += crc;
+	dev->stats.rx_fifo_errors += ovrn;
+	dev->stats.rx_frame_errors += aln;
+	dev->stats.rx_dropped += rsc;
 
-	return &p->stats;
+	return &dev->stats;
 }
 
 /********************************************************
-- 
1.7.0.4

