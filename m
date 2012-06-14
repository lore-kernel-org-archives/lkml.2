Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2FOAAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:00:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab2FOAAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:31 -0400
Message-Id: <20120614235626.729224401@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AnilKumar Ch <anilkumar@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 32/42] can: c_can: fix "BUG! echo_skb is occupied!" during transmit
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/c_can/c_can.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -686,7 +686,7 @@ static int c_can_get_berr_counter(const
  *
  * We iterate from priv->tx_echo to priv->tx_next and check if the
  * packet has been transmitted, echo it back to the CAN framework.
- * If we discover a not yet transmitted package, stop looking for more.
+ * If we discover a not yet transmitted packet, stop looking for more.
  */
 static void c_can_do_tx(struct net_device *dev)
 {
@@ -698,7 +698,7 @@ static void c_can_do_tx(struct net_devic
 	for (/* nix */; (priv->tx_next - priv->tx_echo) > 0; priv->tx_echo++) {
 		msg_obj_no = get_tx_echo_msg_obj(priv);
 		val = c_can_read_reg32(priv, &priv->regs->txrqst1);
-		if (!(val & (1 << msg_obj_no))) {
+		if (!(val & (1 << (msg_obj_no - 1)))) {
 			can_get_echo_skb(dev,
 					msg_obj_no - C_CAN_MSG_OBJ_TX_FIRST);
 			stats->tx_bytes += priv->read_reg(priv,
@@ -706,6 +706,8 @@ static void c_can_do_tx(struct net_devic
 					& IF_MCONT_DLC_MASK;
 			stats->tx_packets++;
 			c_can_inval_msg_object(dev, 0, msg_obj_no);
+		} else {
+			break;
 		}
 	}
 


