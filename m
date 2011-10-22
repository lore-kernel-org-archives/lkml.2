Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1JVNsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 09:48:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57919 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1JVNsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 09:48:03 -0400
Date: Sat, 22 Oct 2011 14:47:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Schilling <paul.s.schilling@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Boojin Kim <boojin.kim@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 02/14] ARM : SAMSUNG : Add RS485 support.
Message-ID: <20111022134726.GD21374@n2100.arm.linux.org.uk>
References: <samsung_rs485> <1319255194-4799-1-git-send-email-paul.s.schilling@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319255194-4799-1-git-send-email-paul.s.schilling@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 10:46:34PM -0500, Paul Schilling wrote:
> +config SAMSUNG_HAS_RS485
> +	bool "Enable RS485 support for Samsung"
> +	depends on SERIAL_SAMSUNG && (MACH_CONDOR2440 || MACH_CONDOR2416 || MACH_MINI2440)
> +	default y if (MACH_CONDOR2440 || MACH_CONDOR2416)
> +	default n if (MACH_MINI2440)
> +
> +config SAMSUNG_485_LOW_RES_TIMER
> +    bool "Samsung RS-485 use low res timer during transmit"
> +    depends on SERIAL_SAMSUNG && SAMSUNG_HAS_RS485
> +    default n

n is the default, so this doesn't need to be specified.

> +static void s3c24xx_serial_rx_fifo_enable(
> +		struct uart_port *port,
> +		unsigned int en)
> +{
> +	unsigned long flags;
> +	unsigned int ucon;
> +	static unsigned int last_state = 1;
> +/* FIXME */
> +	#if 0
> +	if (last_state != en) {
> +
> +		struct s3c2410_uartcfg *cfg = s3c24xx_port_to_cfg(port);
> +
> +		spin_lock_irqsave(&port->lock, flags);
> +
> +		ucon = rd_regl(port, S3C2410_UCON);
> +
> +		ucon &= ~(S3C2440_UFCON_RXTRIG32 | S3C2410_UCON_RXILEVEL);
> +
> +		if (en) {
> +			ucon |= cfg->ucon;
> +		}
> +
> +		wr_regl(port, S3C2410_UCON, ucon);
> +
> +		spin_unlock_irqrestore(&port->lock, flags);
> +	}
> +#endif

This looks like dead code.

> +		} else {
> +			/* Set a short timer to toggle RTS */
> +			mod_timer(
> +					&(ourport->rs485_tx_timer),
> +					jiffies + usecs_to_jiffies(
> +							ourport->char_time_usec
> +							/ 10));

This could do with being better formatted.  Also, & doesn't need following
parens.

> +	/* Read UART transmit status register */
> +	utrstat = rd_regl(&(ourport->port), S3C2410_UTRSTAT);

Doesn't need the parens.

> +/* Callback array*/
> +enum hrtimer_restart (*callback_list[CONFIG_SERIAL_SAMSUNG_UARTS])(struct hrtimer *) = {
> +		&rs485_hr_timer_callback_uart0,
> +		&rs485_hr_timer_callback_uart1,
> +
> +#if CONFIG_SERIAL_SAMSUNG_UARTS > 2
> +		&rs485_hr_timer_callback_uart2,
> +#endif
> +
> +#if CONFIG_SERIAL_SAMSUNG_UARTS > 3
> +		&rs485_hr_timer_callback_uart3,
> +#endif

Silly indentation - this doesn't need two tabs.

> +};
> +
> +#endif
> +#endif /* CONFIG_SAMSUNG_HAS_RS485 */
> +
> +
>  static void s3c24xx_serial_stop_tx(struct uart_port *port)
>  {
>  	struct s3c24xx_uart_port *ourport = to_ourport(port);
>  
>  	if (tx_enabled(port)) {
> +#ifdef CONFIG_SAMSUNG_HAS_RS485
> +		if (ourport->rs485.flags & SER_RS485_ENABLED) {
> +#ifdef CONFIG_SAMSUNG_485_LOW_RES_TIMER
> +			/* Set a short timer to toggle RTS */
> +			mod_timer(&(ourport->rs485_tx_timer),

Doesn't need parens.

> +					jiffies + usecs_to_jiffies(ourport->char_time_usec * s3c24xx_serial_tx_getfifocnt(ourport)));
> +#else
> +			ktime_t kt;
> +
> +			/* Set time struct to one char time. */
> +			kt = ktime_set(0, ourport->char_time_nanosec);
> +
> +			/* Start the high res timer. */
> +			hrtimer_start(&(ourport->hr_rs485_tx_timer), kt, HRTIMER_MODE_REL);

Doesn't need parens.

> +#endif /* CONFIG_SAMSUNG_485_LOW_RES_TIMER */
> +
> +			s3c24xx_serial_rx_fifo_enable(port, 0);
> +
> +		}
> +#endif /* CONFIG_SAMSUNG_HAS_RS485 */
> +
>  		disable_irq_nosync(ourport->tx_irq);
>  		tx_enabled(port) = 0;
> -		if (port->flags & UPF_CONS_FLOW)
> +		if (port->flags & UPF_CONS_FLOW) {
>  			s3c24xx_serial_rx_enable(port);
> +		}

Why are you reformatting code?

> @@ -785,7 +1177,7 @@ static void s3c24xx_serial_set_termios(struct uart_port *port,
>  	port->ignore_status_mask = 0;
>  	if (termios->c_iflag & IGNPAR)
>  		port->ignore_status_mask |= S3C2410_UERSTAT_OVERRUN;
> -	if (termios->c_iflag & IGNBRK && termios->c_iflag & IGNPAR)
> +	if ((termios->c_iflag & IGNBRK) && (termios->c_iflag & IGNPAR))

More code reformatting.

> @@ -830,7 +1228,7 @@ static void s3c24xx_serial_config_port(struct uart_port *port, int flags)
>  {
>  	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
>  
> -	if (flags & UART_CONFIG_TYPE &&
> +	if ((flags & UART_CONFIG_TYPE) &&

And some more.

> +#if 0
> +	dev_info(port., "rts: on send = %i, after = %i, enabled = %i",

That can't be correct - and as its #if 0'd out, either remove this or
fix it to be correct (and use dev_dbg if you want it to be debugging.)

> +static ssize_t s3c24xx_serial_set_485_mode(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf, size_t count)
> +
> +{
> +	struct uart_port *port = s3c24xx_dev_to_port(dev);
> +	struct s3c24xx_uart_port *ourport = to_ourport(port);
> +
> +	if (!strncmp(buf, "Enabled", 7)) {
> +		ourport->rs485.flags |= SER_RS485_ENABLED;
> +	} else if (!strncmp(buf, "Disabled", 8)) {

Do you really require the first character to be capitalized?

> +#ifdef CONFIG_SAMSUNG_HAS_RS485
> +
> +	ret = device_create_file(&dev->dev, &dev_attr_485_status);
> +	if (ret < 0)
> +		printk(KERN_ERR "%s: failed to add 485 status attr.\n", __func__);

pr_err() ?  dev_err() ?
