Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2FNX6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:58:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45611 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab2FNX6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:12 -0400
Message-Id: <20120614235645.086262906@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AnilKumar Ch <anilkumar@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 09/20] can: c_can: fix an interrupt thrash issue with c_can driver
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AnilKumar Ch <anilkumar@ti.com>

commit 148c87c89e1a8863d3d965179f3ab1a06490569e upstream.

This patch fixes an interrupt thrash issue with c_can driver.

In c_can_isr() function interrupts are disabled and enabled only in
c_can_poll() function. c_can_isr() & c_can_poll() both read the
irqstatus flag. However, irqstatus is always read as 0 in c_can_poll()
because all C_CAN interrupts are disabled in c_can_isr(). This causes
all interrupts to be re-enabled in c_can_poll() which in turn causes
another interrupt since the event is not really handled. This keeps
happening causing a flood of interrupts.

To fix this, read the irqstatus register in isr and use the same cached
value in the poll function.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/c_can/c_can.c |    7 +++----
 drivers/net/can/c_can/c_can.h |    1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -954,7 +954,7 @@ static int c_can_poll(struct napi_struct
 	struct net_device *dev = napi->dev;
 	struct c_can_priv *priv = netdev_priv(dev);
 
-	irqstatus = priv->read_reg(priv, &priv->regs->interrupt);
+	irqstatus = priv->irqstatus;
 	if (!irqstatus)
 		goto end;
 
@@ -1032,12 +1032,11 @@ end:
 
 static irqreturn_t c_can_isr(int irq, void *dev_id)
 {
-	u16 irqstatus;
 	struct net_device *dev = (struct net_device *)dev_id;
 	struct c_can_priv *priv = netdev_priv(dev);
 
-	irqstatus = priv->read_reg(priv, &priv->regs->interrupt);
-	if (!irqstatus)
+	priv->irqstatus = priv->read_reg(priv, &priv->regs->interrupt);
+	if (!priv->irqstatus)
 		return IRQ_NONE;
 
 	/* disable all interrupts and schedule the NAPI */
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -76,6 +76,7 @@ struct c_can_priv {
 	unsigned int tx_next;
 	unsigned int tx_echo;
 	void *priv;		/* for board-specific data */
+	u16 irqstatus;
 };
 
 struct net_device *alloc_c_can_dev(void);


