Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2AQSlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:41:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45803 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab2AQSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:41:06 -0500
Date: Tue, 17 Jan 2012 18:40:48 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amba-pl011: do not disable RTS during shutdown
Message-ID: <20120117184047.GE22472@flint.arm.linux.org.uk>
References: <1326796189-21722-1-git-send-email-shreshthakumar.sahu@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326796189-21722-1-git-send-email-shreshthakumar.sahu@stericsson.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 03:59:49PM +0530, Shreshtha Kumar SAHU wrote:
> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> In present driver, shutdown clears RTS in CR register. But the
> documentation "Documentation/serial/driver" suggests not to
> disable RTS in shutdown(). Also RTS is preserved between shutdown
> and startup calls, i.e. it is restored in startup if it was enabled
> during shutdown. So that if autorts is set and RTS is set using
> pl011_set_mctrl then it should continue even after shutdown->startup
> sequence. And hence during set_termios it will enable RTS only if RTS
> bit is set in UARTx_CR register. For throttling/unthrottling user
> should call pl011_set_mctrl.
> 
> Change-Id: I743f33fb10e7e655657cd5dae1ec585e914a65bc

Please get rid of this line.

> Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/tty/serial/amba-pl011.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
> index 6958594..46a4690 100644
> --- a/drivers/tty/serial/amba-pl011.c
> +++ b/drivers/tty/serial/amba-pl011.c
> @@ -160,6 +160,7 @@ struct uart_amba_port {
>  	unsigned int		lcrh_tx;	/* vendor-specific */
>  	unsigned int		lcrh_rx;	/* vendor-specific */
>  	bool			autorts;
> +	bool			rts_state;	/* state during shutdown */

Do we really need a variable to track this?

>  	char			type[12];
>  	bool			interrupt_may_hang; /* vendor-specific */
>  #ifdef CONFIG_DMA_ENGINE
> @@ -1412,6 +1413,8 @@ static int pl011_startup(struct uart_port *port)
>  		barrier();
>  
>  	cr = UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
> +	if (uap->rts_state)
> +		cr |= UART011_CR_RTS;
>  	writew(cr, uap->port.membase + UART011_CR);

Note that this should preserve DTR as well.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
