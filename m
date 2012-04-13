Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203Ab2DMKSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:18:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41880 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934916Ab2DMKSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <201203191534.q2JFYl1b012744@gatekeeper.vosshq.de>
References: <cover.1322479017a.git.n.voss@weinmann.de>
	<201203191534.q2JFYl1b012744@gatekeeper.vosshq.de>
Date: Fri, 13 Apr 2012 12:17:59 +0200
Message-ID: <CAFfN3gWCu5RnKb6dK4YMCAhpkfLncYdk1Cwqxb3wxMVznSiSFQ@mail.gmail.com>
Subject: Re: [PATCH v9 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
From: Hubert Feurstein <h.feurstein@gmail.com>
To: Nikolaus Voss <n.voss@weinmann.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, nicolas.ferre@atmel.com,
        ben-linux@fluff.org, balbi@ti.com, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niko,

I'm using this driver since a while a now in my system
(soc:at91sam9m10; kernel:v3.2.14) and it works quite well. But
occasionally it happens that wrong data is read from my devices. I've
traced down the issue to the way how you do the interrupt handling. In
your code you do not consider that both status-flags (TXCOMP and
RXRDY) may be pending at the same time. So you handle the TXCOMP but
NOT the RXRDY which will cause a data-loss on the current transfer. As
a consequence also the next transfer will be corrupt, because you
start with old data in RHR. So I would suggest the following changes:

static irqreturn_t atmel_twi_interrupt(int irq, void *dev_id)
{
	struct at91_twi_dev *dev = dev_id;
	const unsigned status = at91_twi_read(dev, AT91_TWI_SR);
	unsigned irqstatus = status & at91_twi_read(dev, AT91_TWI_IMR);

	if (irqstatus & AT91_TWI_RXRDY) {
		at91_twi_read_next_byte(dev);
		irqstatus &= ~AT91_TWI_RXRDY;
	}

	if (irqstatus & AT91_TWI_TXRDY) {
		at91_twi_write_next_byte(dev);
		irqstatus &= ~AT91_TWI_TXRDY;
	}

	if (irqstatus & AT91_TWI_TXCOMP) {
		at91_disable_twi_interrupts(dev);
		dev->transfer_status = status;
		complete(&dev->cmd_complete);
		irqstatus &= ~AT91_TWI_TXCOMP;
	}
	
	if (irqstatus) {
		/* There should be no pending interrupt anymore. *)
		return IRQ_NONE;
	}

	return IRQ_HANDLED;
}

To make sure that we do not start with old data in any case, I would
suggest to read SR and RHR before initiating a new transfer.

static int at91_do_twi_transfer(struct at91_twi_dev *dev)
{
	int ret;

	dev_dbg(dev->dev, "transfer: %s %d bytes.\n",
		(dev->msg->flags & I2C_M_RD) ? "read" : "write", dev->buf_len);

	INIT_COMPLETION(dev->cmd_complete);
	if (dev->msg->flags & I2C_M_RD) {
		unsigned start_flags = AT91_TWI_START;

		/* clear any pending data */
		(void)at91_twi_read(dev, AT91_TWI_SR);
		(void)at91_twi_read(dev, AT91_TWI_RHR);
		
		/* if only one byte is to be read, immediately stop transfer */
		if (dev->buf_len <= 1 && !(dev->msg->flags & I2C_M_RECV_LEN))
			start_flags |= AT91_TWI_STOP;
		at91_twi_write(dev, AT91_TWI_CR, start_flags);

		[snip]
}


Hubert
