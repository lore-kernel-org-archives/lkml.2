Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab2DKXwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:52:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:39415 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001Ab2DKXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:51:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/5] drivers/net: remove IS_ENABLED usage from wiznet drivers
Date: Wed, 11 Apr 2012 19:50:55 -0400
Message-Id: <1334188257-3449-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of IS_ENABLED in C code (vs just in CPP #if directives)
causes us to carry the burden of a huge autoconf.h file.  It is
also misleading in that a casual inspection of the code would
leave one thinking that the if statements were evaluated at
runtime, when TX_FLOW is a Kconfig bool and hence evaluated
at configure time as an either/or.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/ethernet/wiznet/w5100.c |    9 ++++++---
 drivers/net/ethernet/wiznet/w5300.c |   18 ++++++++++++------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index c28e1d5..fdac57d 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -441,8 +441,9 @@ static int w5100_start_tx(struct sk_buff *skb, struct net_device *ndev)
 	struct w5100_priv *priv = netdev_priv(ndev);
 	u16 offset;
 
-	if (IS_ENABLED(CONFIG_WIZNET_TX_FLOW))
-		netif_stop_queue(ndev);
+#ifdef CONFIG_WIZNET_TX_FLOW
+	netif_stop_queue(ndev);
+#endif
 
 	offset = w5100_read16(priv, W5100_S0_TX_WR);
 	w5100_writebuf(priv, offset, skb->data, skb->len);
@@ -517,10 +518,12 @@ static irqreturn_t w5100_interrupt(int irq, void *ndev_instance)
 	w5100_write(priv, W5100_S0_IR, ir);
 	mmiowb();
 
-	if (IS_ENABLED(CONFIG_WIZNET_TX_FLOW) && (ir & S0_IR_SENDOK)) {
+#ifdef CONFIG_WIZNET_TX_FLOW
+	if (ir & S0_IR_SENDOK) {
 		netif_dbg(priv, tx_done, ndev, "tx done\n");
 		netif_wake_queue(ndev);
 	}
+#endif
 
 	if (ir & S0_IR_RECV) {
 		if (napi_schedule_prep(&priv->napi)) {
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
index 88afde9..294b3fd 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -73,6 +73,11 @@ MODULE_LICENSE("GPL");
 #define W5300_S0_IR		0x0206	/* S0 Interrupt Register */
 #define   S0_IR_RECV		  0x0004  /* Receive interrupt */
 #define   S0_IR_SENDOK		  0x0010  /* Send OK interrupt */
+#ifdef CONFIG_WIZNET_TX_FLOW
+#define   S0_IR_FLAGS		  (S0_IR_RECV | S0_IR_SENDOK)
+#else
+#define   S0_IR_FLAGS		  S0_IR_RECV
+#endif
 #define W5300_S0_SSR		0x0208	/* S0 Socket Status Register */
 #define W5300_S0_TX_WRSR	0x0220	/* S0 TX Write Size Register */
 #define W5300_S0_TX_FSR		0x0224	/* S0 TX Free Size Register */
@@ -273,9 +278,7 @@ static void w5300_hw_start(struct w5300_priv *priv)
 			  S0_MR_MACRAW : S0_MR_MACRAW_MF);
 	mmiowb();
 	w5300_command(priv, S0_CR_OPEN);
-	w5300_write(priv, W5300_S0_IMR, IS_ENABLED(CONFIG_WIZNET_TX_FLOW) ?
-					S0_IR_RECV | S0_IR_SENDOK :
-					S0_IR_RECV);
+	w5300_write(priv, W5300_S0_IMR, S0_IR_FLAGS);
 	w5300_write(priv, W5300_IMR, IR_S0);
 	mmiowb();
 }
@@ -371,8 +374,9 @@ static int w5300_start_tx(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct w5300_priv *priv = netdev_priv(ndev);
 
-	if (IS_ENABLED(CONFIG_WIZNET_TX_FLOW))
-		netif_stop_queue(ndev);
+#ifdef CONFIG_WIZNET_TX_FLOW
+	netif_stop_queue(ndev);
+#endif
 
 	w5300_write_frame(priv, skb->data, skb->len);
 	mmiowb();
@@ -439,10 +443,12 @@ static irqreturn_t w5300_interrupt(int irq, void *ndev_instance)
 	w5300_write(priv, W5300_S0_IR, ir);
 	mmiowb();
 
-	if (IS_ENABLED(CONFIG_WIZNET_TX_FLOW) && (ir & S0_IR_SENDOK)) {
+#ifdef CONFIG_WIZNET_TX_FLOW
+	if (ir & S0_IR_SENDOK) {
 		netif_dbg(priv, tx_done, ndev, "tx done\n");
 		netif_wake_queue(ndev);
 	}
+#endif
 
 	if (ir & S0_IR_RECV) {
 		if (napi_schedule_prep(&priv->napi)) {
-- 
1.7.9.1

