Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab0GAVPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:15:38 -0400
Received: from kroah.org ([198.145.64.141]:60872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953Ab0GAVNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:42 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:52 2010
Message-Id: <20100701174252.241532363@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Wolfgang Grandegger <wg@grandegger.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [069/200] can: Fix SJA1000 command register writes on SMP systems
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 57c8a456640fa3ca777652f11f2db4179a3e66b6 upstream.

The SJA1000 command register is concurrently written in the rx-path to free
the receive buffer _and_ in the tx-path to start the transmission.

The SJA1000 data sheet, 6.4.4 COMMAND REGISTER (CMR) states:
"Between two commands at least one internal clock cycle is needed in
order to proceed. The internal clock is half of the external oscillator
frequency."

On SMP systems the current implementation leads to a write stall in the
tx-path, which can be solved by adding some general locking and some time
to settle the write_reg() operation for the command register.

Thanks to Klaus Hitschler for the original fix and detailed problem
description.

This patch applies on net-2.6 and (with some offsets) on net-next-2.6 .

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/can/sja1000/sja1000.c |   20 +++++++++++++++++---
 drivers/net/can/sja1000/sja1000.h |    1 +
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -84,6 +84,20 @@ static struct can_bittiming_const sja100
 	.brp_inc = 1,
 };
 
+static void sja1000_write_cmdreg(struct sja1000_priv *priv, u8 val)
+{
+	unsigned long flags;
+
+	/*
+	 * The command register needs some locking and time to settle
+	 * the write_reg() operation - especially on SMP systems.
+	 */
+	spin_lock_irqsave(&priv->cmdreg_lock, flags);
+	priv->write_reg(priv, REG_CMR, val);
+	priv->read_reg(priv, REG_SR);
+	spin_unlock_irqrestore(&priv->cmdreg_lock, flags);
+}
+
 static int sja1000_probe_chip(struct net_device *dev)
 {
 	struct sja1000_priv *priv = netdev_priv(dev);
@@ -297,7 +311,7 @@ static netdev_tx_t sja1000_start_xmit(st
 
 	can_put_echo_skb(skb, dev, 0);
 
-	priv->write_reg(priv, REG_CMR, CMD_TR);
+	sja1000_write_cmdreg(priv, CMD_TR);
 
 	return NETDEV_TX_OK;
 }
@@ -346,7 +360,7 @@ static void sja1000_rx(struct net_device
 	cf->can_id = id;
 
 	/* release receive buffer */
-	priv->write_reg(priv, REG_CMR, CMD_RRB);
+	sja1000_write_cmdreg(priv, CMD_RRB);
 
 	netif_rx(skb);
 
@@ -374,7 +388,7 @@ static int sja1000_err(struct net_device
 		cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
 		stats->rx_over_errors++;
 		stats->rx_errors++;
-		priv->write_reg(priv, REG_CMR, CMD_CDO);	/* clear bit */
+		sja1000_write_cmdreg(priv, CMD_CDO);	/* clear bit */
 	}
 
 	if (isrc & IRQ_EI) {
--- a/drivers/net/can/sja1000/sja1000.h
+++ b/drivers/net/can/sja1000/sja1000.h
@@ -167,6 +167,7 @@ struct sja1000_priv {
 
 	void __iomem *reg_base;	 /* ioremap'ed address to registers */
 	unsigned long irq_flags; /* for request_irq() */
+	spinlock_t cmdreg_lock;  /* lock for concurrent cmd register writes */
 
 	u16 flags;		/* custom mode flags */
 	u8 ocr;			/* output control register */


