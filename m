Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1HHXxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:53:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49967 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HHXxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:53:44 -0400
Message-ID: <4E407700.5080304@gmail.com>
Date: Tue, 09 Aug 2011 09:53:36 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, grant.likely@secretlab.ca
Subject: Re: gpio: ep93xx: remove unused inline function
References: <201108081618.30158.hartleys@visionengravers.com>
In-Reply-To: <201108081618.30158.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/11 09:18, H Hartley Sweeten wrote:
> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
> Cc: Ryan Mallon<rmallon@gmail.com>
> Cc: Grant Likely<grant.likely@secretlab.ca>
>
> ---
>
> diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
> index 468b27d..e0ad8e0 100644
> --- a/drivers/gpio/gpio-ep93xx.c
> +++ b/drivers/gpio/gpio-ep93xx.c
> @@ -62,11 +62,6 @@ static void ep93xx_gpio_update_int_params(unsigned port)
>   		EP93XX_GPIO_REG(int_en_register_offset[port]));
>   }
>
> -static inline void ep93xx_gpio_int_mask(unsigned line)
> -{
> -	gpio_int_unmasked[line>>  3]&= ~(1<<  (line&  7));
> -}
> -
>   static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
>   {
>   	int line = irq_to_gpio(irq);

Yup. Looks like it got factored directly into ep93xx_gpio_irq_mask.

Acked-by: Ryan Mallon <rmallon@gmail.com>

Note that we have a lot of line >> 3 and (1 << (line & 7)) scattered 
through this file. We could do something like this (completely untested):
----
gpio-ep93xx: Add helper functions for irq_port and irq_port_mask

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 72fb9c6..3092155 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -45,6 +45,16 @@ static const u8 eoi_register_offset[3]		= { 0x98, 0xb4, 0x54 };
  static const u8 int_en_register_offset[3]	= { 0x9c, 0xb8, 0x58 };
  static const u8 int_debounce_register_offset[3]	= { 0xa8, 0xc4, 0x64 };

+static inline int irq_port_mask(unsigned int irq)
+{
+	return 1<<  (irq_to_gpio(irq)&  7);
+}
+
+static inline int irq_port(unsigned int irq)
+{
+	return irq_to_gpio(irq)>>  3;
+}
+
  static void ep93xx_gpio_update_int_params(unsigned port)
  {
  	BUG_ON(port>  2);
@@ -68,9 +78,8 @@ static inline void ep93xx_gpio_int_mask(unsigned line)

  static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
  {
-	int line = irq_to_gpio(irq);
-	int port = line>>  3;
-	int port_mask = 1<<  (line&  7);
+	int port = irq_port(irq);
+	int port_mask = irq_port_mask(irq);

  	if (enable)
  		gpio_int_debounce[port] |= port_mask;
@@ -118,9 +127,8 @@ static void ep93xx_gpio_f_irq_handler(unsigned int irq, struct irq_desc *desc)

  static void ep93xx_gpio_irq_ack(struct irq_data *d)
  {
-	int line = irq_to_gpio(d->irq);
-	int port = line>>  3;
-	int port_mask = 1<<  (line&  7);
+	int port = irq_port(irq);
+	int port_mask = irq_port_mask(irq);

  	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
  		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
@@ -132,9 +140,8 @@ static void ep93xx_gpio_irq_ack(struct irq_data *d)

  static void ep93xx_gpio_irq_mask_ack(struct irq_data *d)
  {
-	int line = irq_to_gpio(d->irq);
-	int port = line>>  3;
-	int port_mask = 1<<  (line&  7);
+	int port = irq_port(irq);
+	int port_mask = irq_port_mask(irq);

  	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH)
  		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
@@ -147,19 +154,19 @@ static void ep93xx_gpio_irq_mask_ack(struct irq_data *d)

  static void ep93xx_gpio_irq_mask(struct irq_data *d)
  {
-	int line = irq_to_gpio(d->irq);
-	int port = line>>  3;
+	int port = irq_port(irq);
+	int port_mask = irq_port_mask(irq);

-	gpio_int_unmasked[port]&= ~(1<<  (line&  7));
+	gpio_int_unmasked[port]&= ~port_mask;
  	ep93xx_gpio_update_int_params(port);
  }

  static void ep93xx_gpio_irq_unmask(struct irq_data *d)
  {
-	int line = irq_to_gpio(d->irq);
-	int port = line>>  3;
+	int port = irq_port(irq);
+	int port_mask = irq_port_mask(irq);

-	gpio_int_unmasked[port] |= 1<<  (line&  7);
+	gpio_int_unmasked[port] |= port_mask;
  	ep93xx_gpio_update_int_params(port);
  }

@@ -170,9 +177,8 @@ static void ep93xx_gpio_irq_unmask(struct irq_data *d)
   */
  static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
  {
-	const int gpio = irq_to_gpio(d->irq);
-	const int port = gpio>>  3;
-	const int port_mask = 1<<  (gpio&  7);
+	const int port = irq_port(d->irq);
+	const int port_mask = irq_port_mask(d->irq);
  	irq_flow_handler_t handler;

  	gpio_direction_input(gpio);


