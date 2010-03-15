Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936312Ab0CONqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:46:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54286 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935811Ab0CONqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:46:05 -0400
Date: Mon, 15 Mar 2010 14:45:57 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: John Ogness <john.ogness@linutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] serial: fix possible imx deadlock
Message-ID: <20100315134556.GX19843@pengutronix.de>
References: <80k4tehryt.fsf@merkur.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80k4tehryt.fsf@merkur.tec.linutronix.de>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 14:42:40 up 154 days,  2:31, 60 users,  load average: 0.18, 0.30,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 10:08:58AM +0100, John Ogness wrote:
> This patch fixes a possible deadlock situation with the port and timer
> locks. The calling paths for the deadlock situation are:
> 
> 1. imx_set_termios() -> LOCK(port.lock)
>       -> del_timer_sync() -> LOCK(timer.base.lock)
> 
> 2. run_timer_softirq() -> LOCK(timer.base.lock)
>       -> imx_timeout() -> LOCK(port.lock)
> 
> This patch is against 2.6.34-rc1.
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>
> ---
>  drivers/serial/imx.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> diff -Naurp a/drivers/serial/imx.c b/drivers/serial/imx.c
> --- a/drivers/serial/imx.c	2010-03-08 19:45:44.000000000 +0100
> +++ b/drivers/serial/imx.c	2010-03-15 09:52:39.855261060 +0100
> @@ -836,6 +836,12 @@ imx_set_termios(struct uart_port *port, 
>  	baud = uart_get_baud_rate(port, termios, old, 50, port->uartclk / 16);
>  	quot = uart_get_divisor(port, baud);
>  
> +	/*
> +	 * Stop our timer. This is done with the port unlocked
> +	 * to avoid possible deadlock against the timer function.
> +	 */
> +	del_timer_sync(&sport->timer);
> +

Is this call needed here anyway? Only few drivers have it. Does anyone
have more insights on this?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
