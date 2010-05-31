Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0EaHbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:31:37 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:60890 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab0EaHbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:31:34 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, Daniel Mack <daniel@caiaq.de>,
       Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Christoph Lameter <cl@linux-foundation.org>,
       Joe Perches <joe@perches.com>, netdev@vger.kernel.org
Subject: [PATCH] drivers/net/arcnet/capmode.c: clean up code
Date: Mon, 31 May 2010 09:31:10 +0200
Message-Id: <1275291070-23062-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100531.002429.71095599.davem@davemloft.net>
References: <20100531.002429.71095599.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - shuffle around functions to get rid of forward declarations
 - fix some CodingStyle and indentation issues
 - last but not least, get rid of the following CONFIG_MODULE=n warning:

	drivers/net/arcnet/capmode.c:52: warning: ‘capmode_proto’ defined but not used

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/arcnet/capmode.c |  178 +++++++++++++++++++-----------------------
 1 files changed, 79 insertions(+), 99 deletions(-)

diff --git a/drivers/net/arcnet/capmode.c b/drivers/net/arcnet/capmode.c
index 355797f..e1810a3 100644
--- a/drivers/net/arcnet/capmode.c
+++ b/drivers/net/arcnet/capmode.c
@@ -37,69 +37,6 @@
 
 #define VERSION "arcnet: cap mode (`c') encapsulation support loaded.\n"
 
-
-static void rx(struct net_device *dev, int bufnum,
-	       struct archdr *pkthdr, int length);
-static int build_header(struct sk_buff *skb,
-			struct net_device *dev,
-			unsigned short type,
-			uint8_t daddr);
-static int prepare_tx(struct net_device *dev, struct archdr *pkt, int length,
-		      int bufnum);
-static int ack_tx(struct net_device *dev, int acked);
-
-
-static struct ArcProto capmode_proto =
-{
-	'r',
-	XMTU,
-	0,
-       	rx,
-	build_header,
-	prepare_tx,
-	NULL,
-	ack_tx
-};
-
-
-static void arcnet_cap_init(void)
-{
-	int count;
-
-	for (count = 1; count <= 8; count++)
-		if (arc_proto_map[count] == arc_proto_default)
-			arc_proto_map[count] = &capmode_proto;
-
-	/* for cap mode, we only set the bcast proto if there's no better one */
-	if (arc_bcast_proto == arc_proto_default)
-		arc_bcast_proto = &capmode_proto;
-
-	arc_proto_default = &capmode_proto;
-	arc_raw_proto = &capmode_proto;
-}
-
-
-#ifdef MODULE
-
-static int __init capmode_module_init(void)
-{
-	printk(VERSION);
-	arcnet_cap_init();
-	return 0;
-}
-
-static void __exit capmode_module_exit(void)
-{
-	arcnet_unregister_proto(&capmode_proto);
-}
-module_init(capmode_module_init);
-module_exit(capmode_module_exit);
-
-MODULE_LICENSE("GPL");
-#endif				/* MODULE */
-
-
-
 /* packet receiver */
 static void rx(struct net_device *dev, int bufnum,
 	       struct archdr *pkthdr, int length)
@@ -231,65 +168,108 @@ static int prepare_tx(struct net_device *dev, struct archdr *pkt, int length,
 	BUGMSG(D_DURING, "prepare_tx: length=%d ofs=%d\n",
 	       length,ofs);
 
-	// Copy the arcnet-header + the protocol byte down:
+	/* Copy the arcnet-header + the protocol byte down: */
 	lp->hw.copy_to_card(dev, bufnum, 0, hard, ARC_HDR_SIZE);
 	lp->hw.copy_to_card(dev, bufnum, ofs, &pkt->soft.cap.proto,
 			    sizeof(pkt->soft.cap.proto));
 
-	// Skip the extra integer we have written into it as a cookie
-	// but write the rest of the message:
+	/* Skip the extra integer we have written into it as a cookie
+	   but write the rest of the message: */
 	lp->hw.copy_to_card(dev, bufnum, ofs+1,
 			    ((unsigned char*)&pkt->soft.cap.mes),length-1);
 
 	lp->lastload_dest = hard->dest;
 
-	return 1;		/* done */
+	return 1;	/* done */
 }
 
-
 static int ack_tx(struct net_device *dev, int acked)
 {
-  struct arcnet_local *lp = netdev_priv(dev);
-  struct sk_buff *ackskb;
-  struct archdr *ackpkt;
-  int length=sizeof(struct arc_cap);
+	struct arcnet_local *lp = netdev_priv(dev);
+	struct sk_buff *ackskb;
+	struct archdr *ackpkt;
+	int length=sizeof(struct arc_cap);
 
-  BUGMSG(D_DURING, "capmode: ack_tx: protocol: %x: result: %d\n",
-	 lp->outgoing.skb->protocol, acked);
+	BUGMSG(D_DURING, "capmode: ack_tx: protocol: %x: result: %d\n",
+		lp->outgoing.skb->protocol, acked);
 
-  BUGLVL(D_SKB) arcnet_dump_skb(dev, lp->outgoing.skb, "ack_tx");
+	BUGLVL(D_SKB) arcnet_dump_skb(dev, lp->outgoing.skb, "ack_tx");
 
-  /* Now alloc a skb to send back up through the layers: */
-  ackskb = alloc_skb(length + ARC_HDR_SIZE , GFP_ATOMIC);
-  if (ackskb == NULL) {
-	  BUGMSG(D_NORMAL, "Memory squeeze, can't acknowledge.\n");
-	  goto free_outskb;
-  }
+	/* Now alloc a skb to send back up through the layers: */
+	ackskb = alloc_skb(length + ARC_HDR_SIZE , GFP_ATOMIC);
+	if (ackskb == NULL) {
+		BUGMSG(D_NORMAL, "Memory squeeze, can't acknowledge.\n");
+		goto free_outskb;
+	}
 
-  skb_put(ackskb, length + ARC_HDR_SIZE );
-  ackskb->dev = dev;
+	skb_put(ackskb, length + ARC_HDR_SIZE );
+	ackskb->dev = dev;
 
-  skb_reset_mac_header(ackskb);
-  ackpkt = (struct archdr *)skb_mac_header(ackskb);
-  /* skb_pull(ackskb, ARC_HDR_SIZE); */
+	skb_reset_mac_header(ackskb);
+	ackpkt = (struct archdr *)skb_mac_header(ackskb);
+	/* skb_pull(ackskb, ARC_HDR_SIZE); */
 
+	skb_copy_from_linear_data(lp->outgoing.skb, ackpkt,
+				  ARC_HDR_SIZE + sizeof(struct arc_cap));
+	ackpkt->soft.cap.proto = 0; /* using protocol 0 for acknowledge */
+	ackpkt->soft.cap.mes.ack=acked;
 
-  skb_copy_from_linear_data(lp->outgoing.skb, ackpkt,
-		ARC_HDR_SIZE + sizeof(struct arc_cap));
-  ackpkt->soft.cap.proto=0; /* using protocol 0 for acknowledge */
-  ackpkt->soft.cap.mes.ack=acked;
+	BUGMSG(D_PROTO, "Ackknowledge for cap packet %x.\n",
+			*((int*)&ackpkt->soft.cap.cookie[0]));
 
-  BUGMSG(D_PROTO, "Ackknowledge for cap packet %x.\n",
-	 *((int*)&ackpkt->soft.cap.cookie[0]));
+	ackskb->protocol = cpu_to_be16(ETH_P_ARCNET);
 
-  ackskb->protocol = cpu_to_be16(ETH_P_ARCNET);
+	BUGLVL(D_SKB) arcnet_dump_skb(dev, ackskb, "ack_tx_recv");
+	netif_rx(ackskb);
 
-  BUGLVL(D_SKB) arcnet_dump_skb(dev, ackskb, "ack_tx_recv");
-  netif_rx(ackskb);
+free_outskb:
+	dev_kfree_skb_irq(lp->outgoing.skb);
+	lp->outgoing.proto = NULL; /* We are always finished when in this protocol */
+
+	return 0;
+}
+
+static struct ArcProto capmode_proto =
+{
+	'r',
+	XMTU,
+	0,
+	rx,
+	build_header,
+	prepare_tx,
+	NULL,
+	ack_tx
+};
 
- free_outskb:
-  dev_kfree_skb_irq(lp->outgoing.skb);
-  lp->outgoing.proto = NULL; /* We are always finished when in this protocol */
+static void arcnet_cap_init(void)
+{
+	int count;
 
-  return 0;
+	for (count = 1; count <= 8; count++)
+		if (arc_proto_map[count] == arc_proto_default)
+			arc_proto_map[count] = &capmode_proto;
+
+	/* for cap mode, we only set the bcast proto if there's no better one */
+	if (arc_bcast_proto == arc_proto_default)
+		arc_bcast_proto = &capmode_proto;
+
+	arc_proto_default = &capmode_proto;
+	arc_raw_proto = &capmode_proto;
 }
+
+static int __init capmode_module_init(void)
+{
+	printk(VERSION);
+	arcnet_cap_init();
+	return 0;
+}
+
+static void __exit capmode_module_exit(void)
+{
+	arcnet_unregister_proto(&capmode_proto);
+}
+module_init(capmode_module_init);
+module_exit(capmode_module_exit);
+
+MODULE_LICENSE("GPL");
+
-- 
1.7.1

