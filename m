Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0INAZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 20:25:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908Ab0INAZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 20:25:50 -0400
Date: Mon, 13 Sep 2010 17:25:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Add sc16is7x2 driver
Message-Id: <20100913172544.a81e8422.akpm@linux-foundation.org>
In-Reply-To: <4C80F419.5070601@iis.fraunhofer.de>
References: <4C80F419.5070601@iis.fraunhofer.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Sep 2010 15:11:53 +0200
Manuel Stahl <manuel.stahl@iis.fraunhofer.de> wrote:

> This patch adds support for the sc16is7x2 chips.
> 

The patch was pretty badly wordwrapped.

>
> ...
>
> +#define WRITE_CMD(reg, ch) (REG_WRITE | (reg & 0xf) << 3 | (ch & 0x1) << 1)
> +#define READ_CMD(reg, ch)  (REG_READ  | (reg & 0xf) << 3 | (ch & 0x1) << 1)

It would be better to implement these as lower-case-named inlined C
functions.

> +
> +/* 16bit SPI command to read or write a register */
> +struct sc16is7x2_spi_reg {
> +	u8 cmd;
> +	u8 value;
> +} __attribute__ ((packed));

We have a __packed helper macro for this.

> +struct sc16is7x2_chip;
> +
> +/*
> + * Some registers must be read back to modify.
> + * To save time we cache them here in memory

That implies that the caches have some locking (the mutex, perhaps?). 
Documenting that here would be appropriate.

>
> ...
>
> +/* ******************************** SPI 
> ********************************* */
> +
> +
> +/*
> + * Reserve memory for command sequence
> + * @param cnt number of commands

This "@param" stuff is some form of markup which the kernel does not
use.  Please use standard kerneldoc markup throughout the driver, or
just plain old English-language comments.

> + */
> +static inline struct sc16is7x2_spi_reg *
> +sc16is7x2_alloc_spi_cmds(unsigned cnt)
> +{
> +	return kzalloc(sizeof(struct sc16is7x2_spi_reg)*cnt, GFP_KERNEL);

Use kcalloc() here.

> +}
> +
>
> ...
>
> +/*
> + * sc16is7x2_write_async - Write a new register content (async)
> + */
> +static inline int sc16is7x2_write_async(struct spi_device *spi, u8 reg, 
> u8 ch,
> +		u8 value)
> +{
> +	struct sc16is7x2_spi_reg *cmd = sc16is7x2_alloc_spi_cmds(1);
> +	if (!cmd)
> +		return -ENOMEM;
> +	sc16is7x2_add_write_cmd(cmd, reg, ch, value);
> +	return sc16is7x2_spi_async(spi, cmd, 1);
> +}

It's comventional to place a blank line between end-of-definitions and
start-of-code.  The driver has many instances of this.

> +/*
> + * sc16is7x2_write - Write a new register content (sync)
> + */
> +static int sc16is7x2_write(struct spi_device *spi, u8 reg, u8 ch, u8 val)
> +{
> +	u16 word = REG_WRITE | (reg & 0xf) << 3 | (ch & 0x3) << 1 | val << 8;
> +	return spi_write(spi, (const u8 *)&word, sizeof(word));
> +}

There's another.

> +/**
> + * sc16is7x2_read - Read back register content
> + * @spi: The SPI device
> + * @reg: Register offset
> + *
> + * Returns positive 8 bit value from device if successful or a
> + * negative value on error
> + */

ah-hah.  That's a correct kerneldoc comment.

> +static int sc16is7x2_read(struct spi_device *spi, unsigned reg, 
> unsigned ch)
> +{
> +	u8 cmd = REG_READ | (reg & 0xf) << 3 | (ch & 0x3) << 1;
> +	return spi_w8r8(spi, cmd);
> +}
> +
> +/* ******************************** UART 
> ********************************* */
> +
> +/* Uart divisor latch write */
> +static inline void sc16is7x2_add_dl_write_cmd(struct sc16is7x2_spi_reg 
> *cmd,
> +		u8 ch, int value)
> +{
> +	sc16is7x2_add_write_cmd(&cmd[0], UART_DLL, ch, value & 0xff);
> +	sc16is7x2_add_write_cmd(&cmd[1], UART_DLM, ch, value >> 8 & 0xff);
> +}

Probably the driver doesn't need any explicit "inline" usage at all -
modern gcc's work all that out for themselves.  And if gcc disagreed
with your inline directive, it will just ignore it.

> +static unsigned int sc16is7x2_tx_empty(struct uart_port *port)
> +{
> +	struct sc16is7x2_channel *chan =
> +			container_of(port, struct sc16is7x2_channel, uart);
> +	struct sc16is7x2_chip *ts = chan->chip;
> +	unsigned lsr;
> +
> +	dev_dbg(&ts->spi->dev, "%s\n", __func__);
> +
> +	mutex_lock(&chan->lock);
> +	lsr = chan->lsr;
> +	mutex_unlock(&chan->lock);

It's strange to put locking around a single atomic read.  What are we
trying to do here?

> +	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
> +}
> +
>
> ...
>
> +static void sc16is7x2_break_ctl(struct uart_port *port, int break_state)
> +{
> +	struct sc16is7x2_channel *chan =
> +			container_of(port, struct sc16is7x2_channel, uart);
> +	struct sc16is7x2_chip *ts = chan->chip;
> +	unsigned ch = port->line & 0x01;
> +	unsigned long flags;
> +
> +	dev_dbg(&ts->spi->dev, "%s\n", __func__);
> +
> +	spin_lock_irqsave(&chan->uart.lock, flags);
> +	if (break_state == -1)
> +		chan->lcr |= UART_LCR_SBC;
> +	else
> +		chan->lcr &= ~UART_LCR_SBC;
> +	spin_unlock_irqrestore(&chan->uart.lock, flags);

hm.  Above we use the mutex to protect char->lcr but here we're using a
spinlock.

> +	sc16is7x2_write_async(ts->spi, UART_LCR, ch, chan->lcr);
> +}
> +
>
> ...
>
> +#define MIN(a, b) ((a < b) ? (a) : (b))

Nope.  Use the min() from include/linux/kernel.h.

>
> ...
>
> +static irqreturn_t sc16is7x2_interrupt(int irq, void *dev_id)
> +{
> +	struct sc16is7x2_chip *ts = dev_id;
> +
> +	dev_dbg(&ts->spi->dev, "%s\n", __func__);
> +
> +	if (!ts->force_end_work && !work_pending(&ts->work) &&
> +	    !freezing(current) && !ts->suspending)
> +		queue_work(ts->workqueue, &ts->work);
> +
> +	return IRQ_HANDLED;
> +}

The kernel has infrastructure for "threaded irqs" nowadays.  What this
driver is doing basically reimplements that concept.  Did you consider
using threaded IRQs directly?

>
> ...
>

