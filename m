Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850Ab1HIAWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 20:22:44 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:9814 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1HIAWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 20:22:43 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1312849362!31049931!3
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ryan Mallon <rmallon@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Date: Mon, 8 Aug 2011 19:22:40 -0500
Subject: RE: gpio: ep93xx: remove unused inline function
Thread-Topic: gpio: ep93xx: remove unused inline function
Thread-Index: AcxWJofHV4wmTaLFRjKH0qLsQHvEKwAA12fg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F38838920C@AUSP01VMBX24.collaborationhost.net>
References: <201108081618.30158.hartleys@visionengravers.com>
 <4E407700.5080304@gmail.com>
In-Reply-To: <4E407700.5080304@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p790N976028100

On Monday, August 08, 2011 4:54 PM, Ryan Mallon wrote:
> Note that we have a lot of line >> 3 and (1 << (line & 7)) scattered 
> through this file. We could do something like this (completely untested):
>
> ----
> gpio-ep93xx: Add helper functions for irq_port and irq_port_mask
> 
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>
> ---
> 
> diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
> index 72fb9c6..3092155 100644
> --- a/drivers/gpio/gpio-ep93xx.c
> +++ b/drivers/gpio/gpio-ep93xx.c
> @@ -45,6 +45,16 @@ static const u8 eoi_register_offset[3]		= { 0x98, 0xb4, 0x54 };
>   static const u8 int_en_register_offset[3]	= { 0x9c, 0xb8, 0x58 };
>   static const u8 int_debounce_register_offset[3]	= { 0xa8, 0xc4, 0x64 };
> 
> +static inline int irq_port_mask(unsigned int irq)
> +{
> +	return 1<<  (irq_to_gpio(irq)&  7);
> +}
> +
> +static inline int irq_port(unsigned int irq)
> +{
> +	return irq_to_gpio(irq)>>  3;
> +}
> +

Ryan,

If you _do_ want to consolidate the port/mask stuff how about something like
this instead?  This at least gets the irq_to_gpio() call in one place.

Regards,
Hartley

---

gpio: ep93xx: Add helper function to convert irq to gpio, port, and mask.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 468b27d..59074f6 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -46,6 +46,17 @@ static const u8 eoi_register_offset[3]		= { 0x98, 0xb4, 0x54 };
 static const u8 int_en_register_offset[3]	= { 0x9c, 0xb8, 0x58 };
 static const u8 int_debounce_register_offset[3]	= { 0xa8, 0xc4, 0x64 };
 
+static int ep93xx_gpio_irq_to_gpio_port_mask(unsigned int irq,
+			int *port, int *mask)
+{
+	int gpio = irq_to_gpio(irq);
+
+	*port = gpio >> 3;
+	*mask = 1 << (gpio & 7);
+
+	return gpio;
+}
+
 static void ep93xx_gpio_update_int_params(unsigned port)
 {
 	BUG_ON(port > 2);
@@ -69,14 +80,14 @@ static inline void ep93xx_gpio_int_mask(unsigned line)
 
 static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
 {
-	int line = irq_to_gpio(irq);
-	int port = line >> 3;
-	int port_mask = 1 << (line & 7);
+	int port, mask;
+
+	ep93xx_gpio_irq_to_gpio_port_mask(irq, &port, &mask);
 
 	if (enable)
-		gpio_int_debounce[port] |= port_mask;
+		gpio_int_debounce[port] |= mask;
 	else
-		gpio_int_debounce[port] &= ~port_mask;
+		gpio_int_debounce[port] &= ~mask;
 
 	__raw_writeb(gpio_int_debounce[port],
 		EP93XX_GPIO_REG(int_debounce_register_offset[port]));
@@ -119,48 +130,50 @@ static void ep93xx_gpio_f_irq_handler(unsigned int irq, struct irq_desc *desc)
 
 static void ep93xx_gpio_irq_ack(struct irq_data *d)
 {
-	int line = irq_to_gpio(d->irq);
-	int port = line >> 3;
-	int port_mask = 1 << (line & 7);
+	int port, mask;
+
+	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &mask);
 
 	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
-		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
+		gpio_int_type2[port] ^= mask; /* switch edge direction */
 		ep93xx_gpio_update_int_params(port);
 	}
 
-	__raw_writeb(port_mask, EP93XX_GPIO_REG(eoi_register_offset[port]));
+	__raw_writeb(mask, EP93XX_GPIO_REG(eoi_register_offset[port]));
 }
 
 static void ep93xx_gpio_irq_mask_ack(struct irq_data *d)
 {
-	int line = irq_to_gpio(d->irq);
-	int port = line >> 3;
-	int port_mask = 1 << (line & 7);
+	int port, mask;
+
+	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &mask);
 
 	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH)
-		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
+		gpio_int_type2[port] ^= mask; /* switch edge direction */
 
-	gpio_int_unmasked[port] &= ~port_mask;
+	gpio_int_unmasked[port] &= ~mask;
 	ep93xx_gpio_update_int_params(port);
 
-	__raw_writeb(port_mask, EP93XX_GPIO_REG(eoi_register_offset[port]));
+	__raw_writeb(mask, EP93XX_GPIO_REG(eoi_register_offset[port]));
 }
 
 static void ep93xx_gpio_irq_mask(struct irq_data *d)
 {
-	int line = irq_to_gpio(d->irq);
-	int port = line >> 3;
+	int port, mask;
+
+	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &mask);
 
-	gpio_int_unmasked[port] &= ~(1 << (line & 7));
+	gpio_int_unmasked[port] &= ~mask;
 	ep93xx_gpio_update_int_params(port);
 }
 
 static void ep93xx_gpio_irq_unmask(struct irq_data *d)
 {
-	int line = irq_to_gpio(d->irq);
-	int port = line >> 3;
+	int port, mask;
 
-	gpio_int_unmasked[port] |= 1 << (line & 7);
+	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &mask);
+
+	gpio_int_unmasked[port] |= mask;
 	ep93xx_gpio_update_int_params(port);
 }
 
@@ -171,41 +184,41 @@ static void ep93xx_gpio_irq_unmask(struct irq_data *d)
  */
 static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
 {
-	const int gpio = irq_to_gpio(d->irq);
-	const int port = gpio >> 3;
-	const int port_mask = 1 << (gpio & 7);
+	int gpio, port, mask;
 	irq_flow_handler_t handler;
 
+	gpio = ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &mask);
+
 	gpio_direction_input(gpio);
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
-		gpio_int_type1[port] |= port_mask;
-		gpio_int_type2[port] |= port_mask;
+		gpio_int_type1[port] |= mask;
+		gpio_int_type2[port] |= mask;
 		handler = handle_edge_irq;
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		gpio_int_type1[port] |= port_mask;
-		gpio_int_type2[port] &= ~port_mask;
+		gpio_int_type1[port] |= mask;
+		gpio_int_type2[port] &= ~mask;
 		handler = handle_edge_irq;
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
-		gpio_int_type1[port] &= ~port_mask;
-		gpio_int_type2[port] |= port_mask;
+		gpio_int_type1[port] &= ~mask;
+		gpio_int_type2[port] |= mask;
 		handler = handle_level_irq;
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		gpio_int_type1[port] &= ~port_mask;
-		gpio_int_type2[port] &= ~port_mask;
+		gpio_int_type1[port] &= ~mask;
+		gpio_int_type2[port] &= ~mask;
 		handler = handle_level_irq;
 		break;
 	case IRQ_TYPE_EDGE_BOTH:
-		gpio_int_type1[port] |= port_mask;
+		gpio_int_type1[port] |= mask;
 		/* set initial polarity based on current input level */
 		if (gpio_get_value(gpio))
-			gpio_int_type2[port] &= ~port_mask; /* falling */
+			gpio_int_type2[port] &= ~mask; /* falling */
 		else
-			gpio_int_type2[port] |= port_mask; /* rising */
+			gpio_int_type2[port] |= mask; /* rising */
 		handler = handle_edge_irq;
 		break;
 	default:
@@ -215,7 +228,7 @@ static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
 
 	__irq_set_handler_locked(d->irq, handler);
 
-	gpio_int_enabled[port] |= port_mask;
+	gpio_int_enabled[port] |= mask;
 
 	ep93xx_gpio_update_int_params(port);
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
