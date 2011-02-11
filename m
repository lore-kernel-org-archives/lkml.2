Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab1BKQYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 11:24:14 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39086 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757195Ab1BKQYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 11:24:11 -0500
Date: Fri, 11 Feb 2011 16:28:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
Message-ID: <20110211162814.6ff274f1@lxorguk.ukuu.org.uk>
In-Reply-To: <1297435892-28278-14-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
	<1297435892-28278-14-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't see why it needs its own sub-directory



> +#ifdef __SUART_DEBUG
> +#define __suart_debug(fmt, args...) \
> +		printk(KERN_DEBUG "suart_debug: " fmt, ## args)
> +#else
> +#define __suart_debug(fmt, args...)
> +#endif
> +
> +#define  __suart_err(fmt, args...) printk(KERN_ERR "suart_err: " fmt, ## args)

Use dev_dbg/dev_err/pr_debug/pr_err


> +static void omapl_pru_tx_chars(struct omapl_pru_suart *soft_uart, u32 uart_no)
> +{
> +	struct circ_buf *xmit = &soft_uart->port[uart_no].state->xmit;
> +	struct device *dev = soft_uart->dev;
> +	s32 count = 0;
> +
> +	if (!(suart_get_duplex(soft_uart, uart_no) & ePRU_SUART_HALF_TX))
> +		return;
> +
> +	if (down_trylock(&soft_uart->port_sem[uart_no]))
> +		return;

Please use a mutex not a semaphore. We are trying to get almost all the
kernel using mutexes as it is needed for hard real time.


> +		pru_softuart_read_data(dev, &soft_uart->suart_hdl[uart_no],
> +				       suart_data, data_len + 1,
> +				       &data_len_read);
> +
> +		for (i = 0; i <= data_len_read; i++) {
> +			soft_uart->port[uart_no].icount.rx++;
> +			/* check for sys rq */
> +			if (uart_handle_sysrq_char
> +			    (&soft_uart->port[uart_no], suart_data))
> +				continue;
> +		}
> +		/* update the tty data structure */
> +		tty_insert_flip_string(tty, suart_data, data_len_read);

You can avoid a copy here by using tty_prepare_flip_string()

Also please use the tty_port_tty_get/tty_kref_put interfaces so the tty
refcounting is right


> +static void pruss_suart_set_termios(struct uart_port *port,
> +				  struct ktermios *termios,
> +				  struct ktermios *old)
> +{
> +	struct omapl_pru_suart *soft_uart =
> +	    container_of(port, struct omapl_pru_suart, port[port->line]);
> +	struct device *dev = soft_uart->dev;
> +	u8 cval = 0;
> +	unsigned long flags = 0;
> +	u32 baud = 0;
> +	u32 old_csize = old ? old->c_cflag & CSIZE : CS8;
> +
> +/*
> + * Do not allow unsupported configurations to be set
> + */
> +	if (1) {
> +		termios->c_cflag &= ~(HUPCL | CRTSCTS | CMSPAR | CSTOPB
> +				      | PARENB | PARODD | CMSPAR);
> +		termios->c_cflag |= CLOCAL;

No. CLOCAL and HUPCL are user side flags. Apps expect to able to set them
even if in fact they have no effect, so leave those two alone. The rest
is fine.


> +/*
> + * Characteres to ignore

Typo



> diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_api.c b/drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
> new file mode 100644
> index 0000000..d809dd3
> --- /dev/null
> +++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
> @@ -0,0 +1,2350 @@
> +/*
> + * Copyright (C) 2010 Texas Instruments Incorporated
> + * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as  published by the
> + * Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/mfd/pruss/da8xx_pru.h>
> +#include <linux/io.h>
> +#include <mach/hardware.h>
> +#include "pruss_suart_api.h"
> +#include "pruss_suart_regs.h"
> +#include "pruss_suart_board.h"
> +#include "pruss_suart_utils.h"
> +#include "pruss_suart_err.h"
> +
> +static u8 g_uart_statu_table[8];
Can you lose the g_, its  a windows naming convention we dont use


> +s16 pru_softuart_open(suart_handle h_suart)
> +{

If you just used normal integers you could surely make this routine
trivial and remove all the duplication in the switches

> +	s16 status = PRU_SUART_SUCCESS;

And please stick to Linux error codes


> +/* suart instance close routine */
> +s16 pru_softuart_close(suart_handle h_uart)
> +{
> +	s16 status = SUART_SUCCESS;
> +
> +	if (h_uart == NULL) {
> +		return PRU_SUART_ERR_HANDLE_INVALID;

Which is never checked. Far better to use WARN_ON and the like for such
cases - or if like this one they don't appear to be possible to simply
delete them

> +	if ((tx_clk_divisor > 385) || (tx_clk_divisor == 0))
> +		return SUART_INVALID_CLKDIVISOR;
> +	if ((rx_clk_divisor > 385) || (rx_clk_divisor == 0))
> +		return SUART_INVALID_CLKDIVISOR;

[minor] Lots of excess brackets


> +		u32offset = (u32) (PRUSS_INTC_CHANMAP9 & 0xFFFF);
> +		u32value = PRU_INTC_CHAN_34_SYSEVT_36_39;
> +		s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
> +		if (-1 == s16retval)
> +			return -1;

If you fixed the API here you'd be able to just write

		if (pruss_writel(dev, PRUSS_INTC_CHANMAP9 & 0xFFFF,
				PRU_INTC_BLAH)

or similar which would clean up a lot of messy code and shrink it
dramatically. Given you have lots of series of writes some kind of

	pruss_writel_multi(dev, array, len)

that took an array of addr/value pairs might also clean up a ton of code
and turn it into trivial tables

