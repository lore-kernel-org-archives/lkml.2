Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268Ab2B1BMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:12:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965252Ab2B1BMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:12:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.239.165 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010435.125794299@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 65/72] can: sja1000: fix isr hang when hw is unplugged under load
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit a7762b10c12a70c5dbf2253142764b728ac88c3a upstream.

In the case of hotplug enabled devices (PCMCIA/PCIeC) the removal of the
hardware can cause an infinite loop in the common sja1000 isr.

Use the already retrieved status register to indicate a possible hardware
removal and double check by reading the mode register in sja1000_is_absent.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/sja1000/sja1000.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -95,11 +95,16 @@ static void sja1000_write_cmdreg(struct
 	spin_unlock_irqrestore(&priv->cmdreg_lock, flags);
 }
 
+static int sja1000_is_absent(struct sja1000_priv *priv)
+{
+	return (priv->read_reg(priv, REG_MOD) == 0xFF);
+}
+
 static int sja1000_probe_chip(struct net_device *dev)
 {
 	struct sja1000_priv *priv = netdev_priv(dev);
 
-	if (priv->reg_base && (priv->read_reg(priv, 0) == 0xFF)) {
+	if (priv->reg_base && sja1000_is_absent(priv)) {
 		printk(KERN_INFO "%s: probing @0x%lX failed\n",
 		       DRV_NAME, dev->base_addr);
 		return 0;
@@ -493,6 +498,9 @@ irqreturn_t sja1000_interrupt(int irq, v
 	while ((isrc = priv->read_reg(priv, REG_IR)) && (n < SJA1000_MAX_IRQ)) {
 		n++;
 		status = priv->read_reg(priv, REG_SR);
+		/* check for absent controller due to hw unplug */
+		if (status == 0xFF && sja1000_is_absent(priv))
+			return IRQ_NONE;
 
 		if (isrc & IRQ_WUI)
 			dev_warn(dev->dev.parent, "wakeup interrupt\n");
@@ -509,6 +517,9 @@ irqreturn_t sja1000_interrupt(int irq, v
 			while (status & SR_RBS) {
 				sja1000_rx(dev);
 				status = priv->read_reg(priv, REG_SR);
+				/* check for absent controller */
+				if (status == 0xFF && sja1000_is_absent(priv))
+					return IRQ_NONE;
 			}
 		}
 		if (isrc & (IRQ_DOI | IRQ_EI | IRQ_BEI | IRQ_EPI | IRQ_ALI)) {


