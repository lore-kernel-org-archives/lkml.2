Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab2DLGPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:15:01 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:62286 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab2DLGPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:15:00 -0400
From: Mike Sinkovsky <msink@permonline.ru>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Sinkovsky <msink@permonline.ru>
Subject: [PATCH] drivers/net: Remove CONFIG_WIZNET_TX_FLOW option
Date: Thu, 12 Apr 2012 12:14:48 +0600
Message-Id: <1334211288-7682-1-git-send-email-msink@permonline.ru>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option was there for debugging race conditions,
just remove it, and assume TX_FLOW is always enabled.

Signed-off-by: Mike Sinkovsky <msink@permonline.ru>
---
This replaces patch from Paul Gortmaker:
"[PATCH 3/5] drivers/net: remove IS_ENABLED usage from wiznet drivers
The use of IS_ENABLED in C code (vs just in CPP #if directives)
causes us to carry the burden of a huge autoconf.h file.  It is
also misleading in that a casual inspection of the code would
leave one thinking that the if statements were evaluated at
runtime, when TX_FLOW is a Kconfig bool and hence evaluated
at configure time as an either/or."

Just remove this option instead.

 drivers/net/ethernet/wiznet/Kconfig |    8 --------
 drivers/net/ethernet/wiznet/w5100.c |    5 ++---
 drivers/net/ethernet/wiznet/w5300.c |    9 +++------
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/wiznet/Kconfig b/drivers/net/ethernet/wiznet/Kconfig
index c8291bf..cb18043 100644
--- a/drivers/net/ethernet/wiznet/Kconfig
+++ b/drivers/net/ethernet/wiznet/Kconfig
@@ -70,12 +70,4 @@ config WIZNET_BUS_ANY
 	  Performance may decrease compared to explicitly selected bus mode.
 endchoice
 
-config WIZNET_TX_FLOW
-	bool "Use transmit flow control"
-	depends on WIZNET_W5100 || WIZNET_W5300
-	default y
-	help
-	  This enables transmit flow control for WIZnet chips.
-	  If unsure, say Y.
-
 endif # NET_VENDOR_WIZNET
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index 157d2f0..22e2c5c 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -441,8 +441,7 @@ static int w5100_start_tx(struct sk_buff *skb, struct net_device *ndev)
 	struct w5100_priv *priv = netdev_priv(ndev);
 	u16 offset;
 
-	if (IS_ENABLED(CONFIG_WIZNET_TX_FLOW))
-		netif_stop_queue(ndev);
+	netif_stop_queue(ndev);
 
 	offset = w5100_read16(priv, W5100_S0_TX_WR);
 	w5100_writebuf(priv, offset, skb->data, skb->len);
@@ -517,7 +516,7 @@ static irqreturn_t w5100_interrupt(int irq, void *ndev_instance)
 	w5100_write(priv, W5100_S0_IR, ir);
 	mmiowb();
 
-	if (IS_ENABLED(CONFIG_WIZNET_TX_FLOW) && (ir & S0_IR_SENDOK)) {
+	if (ir & S0_IR_SENDOK) {
 		netif_dbg(priv, tx_done, ndev, "tx done\n");
 		netif_wake_queue(ndev);
 	}
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
index 86d07bb..63cb9dd 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -273,9 +273,7 @@ static void w5300_hw_start(struct w5300_priv *priv)
 			  S0_MR_MACRAW : S0_MR_MACRAW_MF);
 	mmiowb();
 	w5300_command(priv, S0_CR_OPEN);
-	w5300_write(priv, W5300_S0_IMR, IS_ENABLED(CONFIG_WIZNET_TX_FLOW) ?
-					S0_IR_RECV | S0_IR_SENDOK :
-					S0_IR_RECV);
+	w5300_write(priv, W5300_S0_IMR, S0_IR_RECV | S0_IR_SENDOK);
 	w5300_write(priv, W5300_IMR, IR_S0);
 	mmiowb();
 }
@@ -371,8 +369,7 @@ static int w5300_start_tx(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct w5300_priv *priv = netdev_priv(ndev);
 
-	if (IS_ENABLED(CONFIG_WIZNET_TX_FLOW))
-		netif_stop_queue(ndev);
+	netif_stop_queue(ndev);
 
 	w5300_write_frame(priv, skb->data, skb->len);
 	mmiowb();
@@ -439,7 +436,7 @@ static irqreturn_t w5300_interrupt(int irq, void *ndev_instance)
 	w5300_write(priv, W5300_S0_IR, ir);
 	mmiowb();
 
-	if (IS_ENABLED(CONFIG_WIZNET_TX_FLOW) && (ir & S0_IR_SENDOK)) {
+	if (ir & S0_IR_SENDOK) {
 		netif_dbg(priv, tx_done, ndev, "tx done\n");
 		netif_wake_queue(ndev);
 	}
-- 
1.6.3.3


