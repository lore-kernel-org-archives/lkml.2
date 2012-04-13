Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2DMLpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:45:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58906 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2DMLpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:45:31 -0400
From: Hubert Feurstein <h.feurstein@gmail.com>
To: Nikolaus Voss <n.voss@weinmann.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, nicolas.ferre@atmel.com,
        ben-linux@fluff.org, balbi@ti.com, rmallon@gmail.com,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: [PATCH] i2c-at91: fix data-loss issue
Date: Fri, 13 Apr 2012 13:44:36 +0200
Message-Id: <1334317476-10044-1-git-send-email-h.feurstein@gmail.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <20120413103937.GH7154@arwen.pp.htv.fi>
References: <20120413103937.GH7154@arwen.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the interrupt handler both status-flags (TXCOMP and RXRDY) might be
pending at the same time. In this case TXCOMP is handled but NOT RXRDY
which causes a data-loss on the current transfer. As a consequence also the
next transfer will be corrupt, because old data is pending in RHR.

To make sure that we do not start with old data in any case, SR and RHR is
read empty before initiating a new transfer.

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 This patch applies on top of [PATCH v9 3/4] drivers/i2c/busses/i2c-at91.c: add new driver

 drivers/i2c/busses/i2c-at91.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 40c39a2..295835f 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -161,18 +161,22 @@ static irqreturn_t atmel_twi_interrupt(int irq, void *dev_id)
 {
 	struct at91_twi_dev *dev = dev_id;
 	const unsigned status = at91_twi_read(dev, AT91_TWI_SR);
-	const unsigned irqstatus = status & at91_twi_read(dev, AT91_TWI_IMR);
+	unsigned irqstatus = status & at91_twi_read(dev, AT91_TWI_IMR);
+
+	irqstatus &= (AT91_TWI_RXRDY | AT91_TWI_TXRDY | AT91_TWI_TXCOMP);
+	if (!irqstatus)
+		return IRQ_NONE;
+
+	if (irqstatus & AT91_TWI_RXRDY)
+		at91_twi_read_next_byte(dev);
+
+	if (irqstatus & AT91_TWI_TXRDY)
+		at91_twi_write_next_byte(dev);
 
 	if (irqstatus & AT91_TWI_TXCOMP) {
 		at91_disable_twi_interrupts(dev);
 		dev->transfer_status = status;
 		complete(&dev->cmd_complete);
-	} else if (irqstatus & AT91_TWI_RXRDY) {
-		at91_twi_read_next_byte(dev);
-	} else if (irqstatus & AT91_TWI_TXRDY) {
-		at91_twi_write_next_byte(dev);
-	} else {
-		return IRQ_NONE;
 	}
 
 	return IRQ_HANDLED;
@@ -189,6 +193,10 @@ static int at91_do_twi_transfer(struct at91_twi_dev *dev)
 	if (dev->msg->flags & I2C_M_RD) {
 		unsigned start_flags = AT91_TWI_START;
 
+		/* clear any pending data */
+		(void)at91_twi_read(dev, AT91_TWI_SR);
+		(void)at91_twi_read(dev, AT91_TWI_RHR);
+
 		/* if only one byte is to be read, immediately stop transfer */
 		if (dev->buf_len <= 1 && !(dev->msg->flags & I2C_M_RECV_LEN))
 			start_flags |= AT91_TWI_STOP;
@@ -259,6 +267,7 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 			internal_address |= addr << (8 * i);
 			int_addr_flag += AT91_TWI_IADRSZ_1;
 		}
+
 		at91_twi_write(dev, AT91_TWI_IADR, internal_address);
 	}
 
-- 
1.7.8.3

