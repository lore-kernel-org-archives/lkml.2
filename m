Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2DZLBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 07:01:32 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:46385 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab2DZLBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 07:01:30 -0400
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Date: Thu, 26 Apr 2012 13:01:18 +0200 (CEST)
From: Nikolaus Voss <n.voss@weinmann.de>
X-X-Sender: nn@gatekeeper.vosshq.de
To: Carsten Behling <carsten.behling@garz-fricke.com>
cc: Marc-Oliver Westerburg <Westerburg@garz-fricke.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, h.feurstein@gmail.com,
        w.sang@pengutronix.de
Subject: Re: [PATCH v10 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
In-Reply-To: <D99582E5322435468A77E74BB0039E7B1D22784CF0@SRV02.hamburg.garz-fricke.de>
Message-ID: <alpine.DEB.2.00.1204261035060.16439@gatekeeper.vosshq.de>
References: <D99582E5322435468A77E74BB0039E7B1D22784CF0@SRV02.hamburg.garz-fricke.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carsten,

On Wed, 25 Apr 2012, Carsten Behling wrote:
> I cannot find the fix for the RXRDY overrun bug in this patch:

The fix refers to the bug when RXRDY flag was masked out by TXCOMP,
reported by Hubert. I hope this is fixed with v10.

[...]
> here you only report the status flags after a complete transfer, but 
> an overrun can happen after every byte. After reading the status 
> register after an overrun for the next byte this info will be lost !

Right, I didn't consider this. Would you mind to test if the attached 
patch on top of v10 fixes your problem?

Thanks,
Niko

P.S. Are you using a RM9200? Seems that this SOC has some problems...

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 97f4365..df0f6ed 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -186,9 +186,11 @@ static irqreturn_t atmel_twi_interrupt(int irq, void *dev_id)
  	else if (irqstatus & AT91_TWI_TXRDY)
  		at91_twi_write_next_byte(dev);

+	/* catch error flags */
+	dev->transfer_status |= status;
+
  	if (irqstatus & AT91_TWI_TXCOMP) {
  		at91_disable_twi_interrupts(dev);
-		dev->transfer_status = status;
  		complete(&dev->cmd_complete);
  	}

@@ -203,6 +205,7 @@ static int at91_do_twi_transfer(struct at91_twi_dev *dev)
  		(dev->msg->flags & I2C_M_RD) ? "read" : "write", dev->buf_len);

  	INIT_COMPLETION(dev->cmd_complete);
+	dev->transfer_status = 0;
  	if (dev->msg->flags & I2C_M_RD) {
  		unsigned start_flags = AT91_TWI_START;

