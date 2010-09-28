Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0I1Pgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:36:35 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:39359 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab0I1Pge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:36:34 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 11:36:33 EDT
Date: Tue, 28 Sep 2010 17:29:29 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] altera_uart: Add support for different address
	strides
Message-ID: <20100928152929.GD3137@distanz.ch>
References: <20100928133537.GD8289@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928133537.GD8289@oksana.dev.rtsoft.ru>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-28 at 15:35:37 +0200, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> Some controllers implement registers with a stride, to support
> those we must implement the proper IO accessors.
> 
> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> ---
>  drivers/serial/altera_uart.c |   59 +++++++++++++++++++++++++++---------------
>  include/linux/altera_uart.h  |    1 +
>  2 files changed, 39 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
> index 7686aaa..0a1a066 100644
> --- a/drivers/serial/altera_uart.c
> +++ b/drivers/serial/altera_uart.c
> @@ -78,13 +78,28 @@
>  struct altera_uart {
>  	struct uart_port port;
>  	struct timer_list tmr;
> +	int bus_shift;

This member is never used (only bus_shift from struct
altera_uart_platform_uart). Seems to be a leftover.

>  	unsigned int sigs;	/* Local copy of line sigs */
>  	unsigned short imr;	/* Local IMR mirror */
>  };
>  
> +static u32 altera_uart_readl(struct uart_port *port, int reg)
> +{
> +	struct altera_uart_platform_uart *platp = port->private_data;
> +
> +	return readl(port->membase + (reg << platp->bus_shift));
> +}
> +
> +static void altera_uart_writel(struct uart_port *port, u32 dat, int reg)
> +{
> +	struct altera_uart_platform_uart *platp = port->private_data;
> +
> +	writel(dat, port->membase + (reg << platp->bus_shift));
> +}

Why not make these inline?

Cheers,
  Tobias
