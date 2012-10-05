Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2JEQnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:43:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57556 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2JEQnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:43:21 -0400
Message-ID: <506F0E25.6080309@gmail.com>
Date: Fri, 05 Oct 2012 11:43:17 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] serial_core: Add helper for matching against linux,stdout-path
References: <1349453581-1685-1-git-send-email-s.hauer@pengutronix.de> <1349453581-1685-2-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1349453581-1685-2-git-send-email-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 11:12 AM, Sascha Hauer wrote:
> devicetrees may have a linux,stdout-path property in the chosen
> node describing the console device. This adds a helper function
> to match a device against this property so a driver can call
> add_preferred_console for a matching device.

Consoles can be on devices other than uarts, so this should really be
of_device_is_stdout_path() and in the DT core.

> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/tty/serial/serial_core.c |   30 ++++++++++++++++++++++++++++++
>  include/linux/serial_core.h      |    3 +++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index a21dc8e..f4a9f26 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -33,6 +33,7 @@
>  #include <linux/serial_core.h>
>  #include <linux/delay.h>
>  #include <linux/mutex.h>
> +#include <linux/of.h>
>  
>  #include <asm/irq.h>
>  #include <asm/uaccess.h>
> @@ -2540,6 +2541,35 @@ void uart_insert_char(struct uart_port *port, unsigned int status,
>  }
>  EXPORT_SYMBOL_GPL(uart_insert_char);
>  
> +#ifdef CONFIG_OF
> +/**
> + * of_uart_is_stdoutpath - check if this device matches the linux,stdout-path
> + *                         property
> + *
> + * Check if this device matches the linux,stdout-path property
> + * in the chosen node. return true if yes, false otherwise.
> + */
> +int of_uart_is_stdoutpath(struct device *dev)
> +{
> +	struct device_node *dn;
> +	const char *name;
> +
> +	name = of_get_property(of_chosen, "linux,stdout-path", NULL);
> +	if (name == NULL)
> +		return 0;
> +
> +	dn = of_find_node_by_path(name);
> +	if (!dn)
> +		return 0;
> +
> +	if (dn == dev->of_node)

I know I said use struct device, but since only device_node ptr is
needed you should just use that. Then the function is usable if you only
have the device_node ptr.

> +		return 1;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_uart_is_stdoutpath);
> +#endif
> +
>  EXPORT_SYMBOL(uart_write_wakeup);
>  EXPORT_SYMBOL(uart_register_driver);
>  EXPORT_SYMBOL(uart_unregister_driver);
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index 0253c20..35a61f6 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -560,6 +560,9 @@ static inline int uart_handle_break(struct uart_port *port)
>  					 (cflag) & CRTSCTS || \
>  					 !((cflag) & CLOCAL))
>  
> +/* check if a device matches the linux,stdout-path property */
> +int of_uart_is_stdoutpath(struct device *dev);

Need an empty version for !CONFIG_OF?

Rob

> +
>  #endif
>  
>  #endif /* LINUX_SERIAL_CORE_H */
> 
