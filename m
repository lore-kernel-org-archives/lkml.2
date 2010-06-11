Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab0FKLNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:13:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36286 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab0FKLNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:13:36 -0400
Date: Fri, 11 Jun 2010 12:13:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: add STMPE811 core support
Message-ID: <20100611111326.GD12436@sirena.org.uk>
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de> <1276251195-22981-2-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276251195-22981-2-git-send-email-l.fu@pengutronix.de>
X-Cookie: Postage will be paid by addressee.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:13:13PM +0200, Luotao Fu wrote:

> +	for_each_set_bit(bit, (unsigned long *)&int_stat, STMPE811_NUM_IRQ) {
> +		handler = stm->irqhandler[bit];
> +		data = stm->irqdata[bit];
> +		if (handler) {

You should be using genirq here - just call handle_nested_irq() if the
IRQ is asserted and let genirq manage the handler for you.

> +static irqreturn_t stmpe811_irq(int irq, void *data)
> +{
> +	struct stmpe811 *stm = data;
> +
> +	get_device(stm->dev);
> +	disable_irq_nosync(stm->irq);
> +	queue_work(stm->work_queue, &stm->irq_work);
> +
> +	return IRQ_HANDLED;
> +}

You should use request_threaded_irq() for the main IRQ - it will take
care of all this for you.


> +static struct i2c_device_id stmpe811_id_table[] = {
> +	{"stmpe811", 0x88},

Any reason for the 0x88 - you don't seem to use it anywhere?

> +int stmpe811_register_irq(struct stmpe811 *stm, int irq,
> +			  irq_handler_t handler, void *data);
> +int stmpe811_free_irq(struct stmpe811 *stm, int irq);

If you use genirq these can be dropped - this will also mean that
existing generic drivers using the standard GPIO and IRQ frameworks will
be able to use the chip without modification.
