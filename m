Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043Ab2IFV6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:58:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43470 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932Ab2IFV6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:58:36 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 20/21] serial: omap: move uart_omap_port definition to C file
Organization: Deep Root Systems, LLC
References: <20120906122948.GC29202@arwen.pp.htv.fi>
	<1346935540-1792-1-git-send-email-balbi@ti.com>
	<1346935540-1792-21-git-send-email-balbi@ti.com>
Date: Thu, 06 Sep 2012 14:58:35 -0700
In-Reply-To: <1346935540-1792-21-git-send-email-balbi@ti.com> (Felipe Balbi's
	message of "Thu, 6 Sep 2012 15:45:39 +0300")
Message-ID: <87fw6uizjo.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <balbi@ti.com> writes:

> nobody needs to access the uart_omap_port structure
> other than omap-serial.c file. Let's move that
> structure definition to the C source file in order
> to prevent anyone from accessing our structure.
>
> Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

This one is clearly broken, and causes compile breakage...

> ---
>  arch/arm/plat-omap/include/plat/omap-serial.h | 37 --------------------------
>  drivers/tty/serial/omap-serial.c              | 38 +++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+), 37 deletions(-)
>
> diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
> index a79ed8b..3c9fd3e 100644
> --- a/arch/arm/plat-omap/include/plat/omap-serial.h
> +++ b/arch/arm/plat-omap/include/plat/omap-serial.h
> @@ -105,45 +105,8 @@ struct uart_omap_dma {
>  	unsigned int		rx_timeout;
>  };
>  
> -struct uart_omap_port {
> -	struct uart_port	port;
> -	struct uart_omap_dma	uart_dma;
> -	struct device		*dev;
> -
> -	unsigned char		ier;
> -	unsigned char		lcr;
> -	unsigned char		mcr;
> -	unsigned char		fcr;
> -	unsigned char		efr;
> -	unsigned char		dll;
> -	unsigned char		dlh;
> -	unsigned char		mdr1;
> -	unsigned char		scr;
> -
> -	int			use_dma;
> -	/*
> -	 * Some bits in registers are cleared on a read, so they must
> -	 * be saved whenever the register is read but the bits will not
> -	 * be immediately processed.
> -	 */
> -	unsigned int		lsr_break_flag;
> -	unsigned char		msr_saved_flags;
> -	char			name[20];
> -	unsigned long		port_activity;
> -	u32			context_loss_cnt;
> -	u32			errata;
> -	u8			wakeups_enabled;
>  
>  	int			DTR_gpio;
>  	int			DTR_inverted;
>  	int			DTR_active;

The whole struct has moved, but some fields left behind?

This looks to be caused by the rebase which includes Neil Brown's DTR
GPIO change[1]

> -
> -	struct pm_qos_request	pm_qos_request;
> -	u32			latency;
> -	u32			calc_latency;
> -	struct work_struct	qos_work;
> -};
> -
> -#define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
> -
>  #endif /* __OMAP_SERIAL_H__ */
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 881b652..164c3c9 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -70,6 +70,44 @@
>  #define OMAP_UART_MVR_MAJ_SHIFT		8
>  #define OMAP_UART_MVR_MIN_MASK		0x3f
>  
> +struct uart_omap_port {
> +	struct uart_port	port;
> +	struct uart_omap_dma	uart_dma;
> +	struct device		*dev;
> +
> +	unsigned char		ier;
> +	unsigned char		lcr;
> +	unsigned char		mcr;
> +	unsigned char		fcr;
> +	unsigned char		efr;
> +	unsigned char		dll;
> +	unsigned char		dlh;
> +	unsigned char		mdr1;
> +	unsigned char		scr;
> +
> +	int			use_dma;
> +	/*
> +	 * Some bits in registers are cleared on a read, so they must
> +	 * be saved whenever the register is read but the bits will not
> +	 * be immediately processed.
> +	 */
> +	unsigned int		lsr_break_flag;
> +	unsigned char		msr_saved_flags;
> +	char			name[20];
> +	unsigned long		port_activity;
> +	u32			context_loss_cnt;
> +	u32			errata;
> +	u8			wakeups_enabled;
> +	unsigned int		irq_pending:1;

And this field was not in the original, yet the changelog describes this
as a move.

Why is a this new field added (and not described in the changelog.)

Kevin


[1]
commit 9574f36fb801035f6ab0fbb1b53ce2c12c17d100
Author: NeilBrown <neilb@suse.de>
Date:   Mon Jul 30 10:30:26 2012 +1000

    OMAP/serial: Add support for driving a GPIO as DTR.
    
    OMAP hardware doesn't provide a phyisical DTR line, but
    some configurations may need a DTR line which tracks whether
    the device is open or not.
    
    So allow a gpio to be configured as the DTR line.
    
    Signed-off-by: NeilBrown <neilb@suse.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
