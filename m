Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0HWIrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:47:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57471 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0HWIrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:47:17 -0400
Message-ID: <4C72358E.90503@monstr.eu>
Date: Mon, 23 Aug 2010 10:47:10 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] serial: Add CONSOLE_POLL support for uartlite
References: <1282034525-19207-1-git-send-email-monstr@monstr.eu>	<1282034525-19207-2-git-send-email-monstr@monstr.eu> <87mxsejwpo.fsf@macbook.be.48ers.dk>
In-Reply-To: <87mxsejwpo.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard wrote:
>>>>>> "Michal" == Michal Simek <monstr@monstr.eu> writes:
> 
>  Michal> CONSOLE_POLL support for uartlite enables
>  Michal> KGDB debugging over serial line.
> 
> Please CC me on uartlite patches in the future, thanks.

Oou sorry.

> 
>  Michal> Signed-off-by: Michal Simek <monstr@monstr.eu>
>  Michal> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>  Michal> ---
>  Michal>  drivers/serial/uartlite.c |   26 +++++++++++++++++++++++++-
>  Michal>  1 files changed, 25 insertions(+), 1 deletions(-)
> 
>  Michal> diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
>  Michal> index 9b03d7b..c0fae0d 100644
>  Michal> --- a/drivers/serial/uartlite.c
>  Michal> +++ b/drivers/serial/uartlite.c
>  Michal> @@ -322,6 +322,26 @@ static int ulite_verify_port(struct uart_port *port, struct serial_struct *ser)
>  Michal>  	return -EINVAL;
>  Michal>  }
>  
>  Michal> +#ifdef CONFIG_CONSOLE_POLL
>  Michal> +static int ulite_get_poll_char(struct uart_port *port)
>  Michal> +{
>  Michal> +	while (!(ioread32be(port->membase + ULITE_STATUS)
>  Michal> +						& ULITE_STATUS_RXVALID))
>  Michal> +		return NO_POLL_CHAR;
>  Michal> +
> 
> Using while instead of 'if' is imho pretty obscure here.

Agree that if is the better solution.

> 
>  Michal> +	return ioread32be(port->membase + ULITE_RX);
>  Michal> +}
>  Michal> +
>  Michal> +static void ulite_put_poll_char(struct uart_port *port, unsigned char ch)
>  Michal> +{
>  Michal> +	while (ioread32be(port->membase + ULITE_STATUS) & ULITE_STATUS_TXFULL)
>  Michal> +		cpu_relax();
> 
> 
> You could reuse ulite_console_wait_tx() like ulite_console_putchar()
> does.

yes, but ulite_console_wait_tx is used only when uartlite console is 
used. Not sure if I tried to setup console and KGDB but in this case I 
will have to add some ifdef that's why was easier for me to write on ioread.

> 
> Otherwise it looks fine.
> 
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
> 

I will changed driver and send v2.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
