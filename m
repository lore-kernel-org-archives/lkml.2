Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2FQSZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:25:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50407 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758628Ab2FQSXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:23:03 -0400
Message-Id: <20120617175944.320483677@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AnilKumar Ch <anilkumar@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 21/69] can: c_can: fix "BUG! echo_skb is occupied!" during transmit
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AnilKumar Ch <anilkumar@ti.com>

commit 617caccebe451716df21c069b079d5936ed7b0f3 upstream.

This patch fixes an issue with transmit routine, which causes
"can_put_echo_skb: BUG! echo_skb is occupied!" message when
using "cansequence -p" on D_CAN controller.

In c_can driver, while transmitting packets tx_echo flag holds
the no of can frames put for transmission into the hardware.

As the comment above c_can_do_tx() indicates, if we find any packet
which is not transmitted then we should stop looking for more.
In the current implementation this is not taken care of causing the
said message.

Also, fix the condition used to find if the packet is transmitted
or not. Current code skips the first tx message object and ends up
checking one extra invalid object.

While at it, fix the comment on top of c_can_do_tx() to use the
terminology "packet" instead of "package" since it is more
standard.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/c_can/c_can.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 536bda0..9ac28df 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -686,7 +686,7 @@ static int c_can_get_berr_counter(const struct net_device *dev,
  *
  * We iterate from priv->tx_echo to priv->tx_next and check if the
  * packet has been transmitted, echo it back to the CAN framework.
- * If we discover a not yet transmitted package, stop looking for more.
+ * If we discover a not yet transmitted packet, stop looking for more.
  */
 static void c_can_do_tx(struct net_device *dev)
 {
@@ -698,7 +698,7 @@ static void c_can_do_tx(struct net_device *dev)
 	for (/* nix */; (priv->tx_next - priv->tx_echo) > 0; priv->tx_echo++) {
 		msg_obj_no = get_tx_echo_msg_obj(priv);
 		val = c_can_read_reg32(priv, &priv->regs->txrqst1);
-		if (!(val & (1 << msg_obj_no))) {
+		if (!(val & (1 << (msg_obj_no - 1)))) {
 			can_get_echo_skb(dev,
 					msg_obj_no - C_CAN_MSG_OBJ_TX_FIRST);
 			stats->tx_bytes += priv->read_reg(priv,
@@ -706,6 +706,8 @@ static void c_can_do_tx(struct net_device *dev)
 					& IF_MCONT_DLC_MASK;
 			stats->tx_packets++;
 			c_can_inval_msg_object(dev, 0, msg_obj_no);
+		} else {
+			break;
 		}
 	}
 


