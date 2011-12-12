Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1LLXIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:08:35 -0500
Received: from d1.icnet.pl ([212.160.220.21]:60947 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab1LLXIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:08:32 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 01/10] GPIO: gpio-generic: Move initialization up to postcore
Date: Tue, 13 Dec 2011 00:05:34 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-serial@vger.kernel.org
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl> <1323634328-856-2-git-send-email-jkrzyszt@tis.icnet.pl> <20111212180456.GF31337@atomide.com>
In-Reply-To: <20111212180456.GF31337@atomide.com>
MIME-Version: 1.0
Message-Id: <201112130005.35386.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Greg Kroah-Hartman and linux-serial@vger.kernel.org to Cc:)

On Monday 12 of December 2011 at 19:04:56, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111211 11:41]:
> > This will allow boards with custom memory mapped GPIO ports to set up
> > and use those port pins while initializing devices from arch init.
> 
> Care to explain a bit more why you need to initialize those devices
> early on?

Let me try.

>From patch 2/10 "ARM: OMAP1: ams-delta: Convert latches to 
basic_mmio_gpio":

> @@ -307,8 +487,8 @@ static void __init ams_delta_init(void)
>  	omap_serial_init();
>  	omap_register_i2c_bus(1, 100, NULL, 0);
>  
> -	/* Clear latch2 (NAND, LCD, modem enable) */
> -	ams_delta_latch2_write(~0, 0);
> +	platform_add_devices(_latch_devices, ARRAY_SIZE(_latch_devices));
> +	BUG_ON(gpio_request_array(_latch_gpios, ARRAY_SIZE(_latch_gpios)));
>  
>  	omap1_usb_init(&ams_delta_usb_config);
>  	omap1_set_camera_info(&ams_delta_camera_platform_data);

Here I'm accessing the latches from ams_delta_init() (.init_machine 
hook) with gpio_request_array() in order to:
a) clear their contents,
b) avoid accessing them, from ams_delta_latch_write(), never requested.

I could imagine clearing their contents with something like

	*(volatile __u8 *) AMS_DELTA_LATCH2_VIRT = 0;
	*(volatile __u16 *) AMS_DELTA_LATCH2_VIRT = 0;

instead, i.e., the way the old code used to, than accessing those GPIO 
pins not requested, until they are finally requested by drivers updated 
to use gpiolib with successive patche. Would this be acceptable?

However,
>From patch 6/10 "ARM: OMAP1: ams-delta: Use GPIO API in modem setup":

> @@ -482,6 +472,12 @@ static void __init ams_delta_init(void)
>  	omap_writew(omap_readw(ARM_RSTCT1) | 0x0004, ARM_RSTCT1);
>  }
>  
> +static void _modem_pm(struct uart_port *port, unsigned int state, unsigned old)
> +{
> +	if (state != old)
> +		gpio_set_value(AMS_DELTA_GPIO_PIN_MODEM_NRESET, state == 0);
> +}
> +
>  static struct plat_serial8250_port ams_delta_modem_ports[] = {
>  	{
>  		.membase	= IOMEM(_MODEM_VIRT),
> @@ -492,6 +488,7 @@ static struct plat_serial8250_port ams_delta_modem_ports[] = {
>  		.iotype		= UPIO_MEM,
>  		.regshift	= 1,
>  		.uartclk	= BASE_BAUD * 16,
> +		.pm		= _modem_pm,
>  	},
>  	{ },
>  };
> @@ -504,6 +501,24 @@ static struct platform_device ams_delta_modem_device = {
>  	},
>  };
>  
> +static struct gpio _modem_gpios[] __initconst = {
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_IRQ,
> +		.flags	= GPIOF_DIR_IN,
> +		.label	= "modem_irq",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_NRESET,
> +		.flags	= GPIOF_OUT_INIT_HIGH,
> +		.label	= "modem_nreset",
> +	},
> +	{
> +		.gpio	= AMS_DELTA_GPIO_PIN_MODEM_CODEC,
> +		.flags	= GPIOF_OUT_INIT_HIGH,
> +		.label	= "modem_codec",
> +	},
> +};
> +
>  static int __init ams_delta_modem_init(void)
>  {
>  	int err;
> @@ -515,16 +530,11 @@ static int __init ams_delta_modem_init(void)
>  	ams_delta_modem_ports[0].irq =
>  			gpio_to_irq(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
>  
> -	err = gpio_request(AMS_DELTA_GPIO_PIN_MODEM_IRQ, "modem");
> +	err = gpio_request_array(_modem_gpios, ARRAY_SIZE(_modem_gpios));
>  	if (err) {
> -		pr_err("Couldn't request gpio pin for modem\n");
> +		pr_err("Couldn't request gpio pins for modem\n");
>  		return err;
>  	}
> -	gpio_direction_input(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
> -
> -	ams_delta_latch2_write(
> -		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
> -		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
>  
>  	return platform_device_register(&ams_delta_modem_device);
>  }

Before the change, only one GPIO pin, that IRQ, driven with omap_gpio 
driver which is registered from postcore, was gpio_request()ed. Now, two 
more, gpio-generic driven pins, are also requested _and_ initialized in 
order to make the modem accessible. The ams_delta_modem_init() is 
installed with arch_initcall().

I could imagine initializing those modem pins the old way I've suggested 
above, but I can see no good solution to delegate calling of that 
gpio_request*() to the 8250 driver. For me, the only hook passed to the 
driver with platform_data that can be suitable is the .pm hook. However, 
when I tried to remove powering up the modem (rising up 
AMS_DELTA_GPIO_PIN_MODEM_NRESET) from the arch init and do this only 
from that .pm hook, the device was not detected, so I wonder if and when 
that hook is called, and if it is before probe, then perhaps powering 
up the modem chip from there is too late for the device to get up before 
being examined. But then, maybe if we initialize the pin the old way 
from arch init, it would be enough for the device to be detected, while 
consecutive open() response times may not be so critical. Perhaps Greg 
or another serial guru can shed some more light on this.

But this way or another, we are talking about dirty hacks here IMHO.

Thanks,
Janusz
