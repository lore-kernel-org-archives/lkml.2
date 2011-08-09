Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1HIVqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:46:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63347 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1HIVqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:46:23 -0400
Message-ID: <4E41AB23.4080209@gmail.com>
Date: Wed, 10 Aug 2011 07:48:19 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, grant.likely@secretlab.ca
Subject: Re: gpio-ep93xx: Add helper function to convert irq to gpio, port,
 and mask.
References: <201108091104.14053.hartleys@visionengravers.com>
In-Reply-To: <201108091104.14053.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 04:04, H Hartley Sweeten wrote:
> This consolidates the irq_to_gpio() call and the shift magic used to convert
> a GPIO irq into it's relevant GPIO, port, and mask values.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>

I think this should have my:

Signed-off-by: Ryan Mallon <rmallon@gmail.com>

Since I wrote the original patch.

Thanks,
~Ryan

> Cc: Grant Likely <grant.likely@secretlab.ca>
>
> ---
>
> diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
> index 468b27d..788c7c4 100644
> --- a/drivers/gpio/gpio-ep93xx.c
> +++ b/drivers/gpio/gpio-ep93xx.c
> @@ -46,6 +46,20 @@ static const u8 eoi_register_offset[3]		= { 0x98, 0xb4, 0x54 };
>  static const u8 int_en_register_offset[3]	= { 0x9c, 0xb8, 0x58 };
>  static const u8 int_debounce_register_offset[3]	= { 0xa8, 0xc4, 0x64 };
>  
> +/*
> + * Map a sw irq to it's GPIO port and mask.
> + */
> +static int ep93xx_gpio_irq_to_gpio_port_mask(unsigned int irq,
> +			int *port, int *port_mask)
> +{
> +	int gpio = irq_to_gpio(irq);
> +
> +	*port = gpio >> 3;
> +	*port_mask = 1 << (gpio & 7);
> +
> +	return gpio;
> +}
> +
>  static void ep93xx_gpio_update_int_params(unsigned port)
>  {
>  	BUG_ON(port > 2);
> @@ -69,9 +83,9 @@ static inline void ep93xx_gpio_int_mask(unsigned line)
>  
>  static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
>  {
> -	int line = irq_to_gpio(irq);
> -	int port = line >> 3;
> -	int port_mask = 1 << (line & 7);
> +	int port, port_mask;
> +
> +	ep93xx_gpio_irq_to_gpio_port_mask(irq, &port, &port_mask);
>  
>  	if (enable)
>  		gpio_int_debounce[port] |= port_mask;
> @@ -119,9 +133,9 @@ static void ep93xx_gpio_f_irq_handler(unsigned int irq, struct irq_desc *desc)
>  
>  static void ep93xx_gpio_irq_ack(struct irq_data *d)
>  {
> -	int line = irq_to_gpio(d->irq);
> -	int port = line >> 3;
> -	int port_mask = 1 << (line & 7);
> +	int port, port_mask;
> +
> +	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
>  
>  	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
>  		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
> @@ -133,9 +147,9 @@ static void ep93xx_gpio_irq_ack(struct irq_data *d)
>  
>  static void ep93xx_gpio_irq_mask_ack(struct irq_data *d)
>  {
> -	int line = irq_to_gpio(d->irq);
> -	int port = line >> 3;
> -	int port_mask = 1 << (line & 7);
> +	int port, port_mask;
> +
> +	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
>  
>  	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH)
>  		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
> @@ -148,19 +162,21 @@ static void ep93xx_gpio_irq_mask_ack(struct irq_data *d)
>  
>  static void ep93xx_gpio_irq_mask(struct irq_data *d)
>  {
> -	int line = irq_to_gpio(d->irq);
> -	int port = line >> 3;
> +	int port, port_mask;
> +
> +	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
>  
> -	gpio_int_unmasked[port] &= ~(1 << (line & 7));
> +	gpio_int_unmasked[port] &= ~port_mask;
>  	ep93xx_gpio_update_int_params(port);
>  }
>  
>  static void ep93xx_gpio_irq_unmask(struct irq_data *d)
>  {
> -	int line = irq_to_gpio(d->irq);
> -	int port = line >> 3;
> +	int port, port_mask;
> +
> +	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
>  
> -	gpio_int_unmasked[port] |= 1 << (line & 7);
> +	gpio_int_unmasked[port] |= port_mask;
>  	ep93xx_gpio_update_int_params(port);
>  }
>  
> @@ -171,11 +187,11 @@ static void ep93xx_gpio_irq_unmask(struct irq_data *d)
>   */
>  static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
>  {
> -	const int gpio = irq_to_gpio(d->irq);
> -	const int port = gpio >> 3;
> -	const int port_mask = 1 << (gpio & 7);
> +	int gpio, port, port_mask;
>  	irq_flow_handler_t handler;
>  
> +	gpio = ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
> +
>  	gpio_direction_input(gpio);
>  
>  	switch (type) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

