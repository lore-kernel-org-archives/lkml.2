Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab2LQLhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:37:38 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:40871 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2LQLhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:37:37 -0500
X-manitu-Original-Sender-IP: 93.104.18.146
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <50CF03FB.2030100@grandegger.com>
Date: Mon, 17 Dec 2012 12:37:31 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de>
In-Reply-To: <50CBBB25.20002@antcom.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On 12/15/2012 12:49 AM, Roland Stigge wrote:
> Hi Wolfgang,
> 
> thank you for the patch!
> 
> On 14/12/12 18:58, Wolfgang Grandegger wrote:
>> +static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
>> +{
>> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
>> +	void __iomem *pio = at91_gpio->regbase;
>> +
>> +	__raw_writel(mask, pio + (val ? PIO_SODR : PIO_CODR));
>> +}
>> +
> 
> Without having an AT91 available right now, I guess the hardware
> interface of this GPIO chip is different from the GPIO block API. While
> the hardware has clear and set registers, the val parameter of
> at91_gpiolib_set_block() should be interpreted as the actual output
> values. See lpc32xx_gpo_set_block() for an example for handling set and
> clear registers like this: First, set_bits and clear_bits words are
> calculated from mask and val parameters, and finally written to the
> respective hardware registers.
> 
> Note that one .set_block() can result in writing both the set and clear
> registers of the hardware when val contains both 0s and 1s in
> respectively masked positions.

Oops, I obviously did not test GPIO block write. The patch below does
work now. Feel free to add it to the next version of your series.

I tested with a block having both, inputs and outputs. The handling
of such a mixed block is clumsy because both, read and write do depend
on "block->cur_mask". It needs to be re-set when switching from read to
write or vice versa. Defining two blocks, one for input and the other
for output seems to be the better solution.

Hope this block gpio support will show up in mainline soon.

Thanks.

Wolfgang.



>From 6249995d129b290704cacb2c0114782414abeba7 Mon Sep 17 00:00:00 2001
From: Wolfgang Grandegger <wg@grandegger.com>
Date: Mon, 3 Dec 2012 08:31:55 +0100
Subject: [PATCH 1/2] gpio: add GPIO block callback functions for AT91

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
---
 arch/arm/mach-at91/gpio.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index be42cf0..0998854 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -48,7 +48,9 @@ struct at91_gpio_chip {
 
 static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip);
 static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val);
+static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val);
 static int at91_gpiolib_get(struct gpio_chip *chip, unsigned offset);
+static unsigned long at91_gpiolib_get_block(struct gpio_chip *chip, unsigned long mask);
 static int at91_gpiolib_direction_output(struct gpio_chip *chip,
 					 unsigned offset, int val);
 static int at91_gpiolib_direction_input(struct gpio_chip *chip,
@@ -62,7 +64,9 @@ static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset);
 			.direction_input  = at91_gpiolib_direction_input, \
 			.direction_output = at91_gpiolib_direction_output, \
 			.get		  = at91_gpiolib_get,		\
+			.get_block	  = at91_gpiolib_get_block,	\
 			.set		  = at91_gpiolib_set,		\
+			.set_block	  = at91_gpiolib_set_block,	\
 			.dbg_show	  = at91_gpiolib_dbg_show,	\
 			.to_irq		  = at91_gpiolib_to_irq,	\
 			.ngpio		  = nr_gpio,			\
@@ -896,6 +900,16 @@ static int at91_gpiolib_get(struct gpio_chip *chip, unsigned offset)
 	return (pdsr & mask) != 0;
 }
 
+static unsigned long at91_gpiolib_get_block(struct gpio_chip *chip, unsigned long mask)
+{
+	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
+	void __iomem *pio = at91_gpio->regbase;
+	u32 pdsr;
+
+	pdsr = __raw_readl(pio + PIO_PDSR);
+	return pdsr & mask;
+}
+
 static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
 {
 	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
@@ -905,6 +919,20 @@ static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
 	__raw_writel(mask, pio + (val ? PIO_SODR : PIO_CODR));
 }
 
+static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
+{
+	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
+	void __iomem *pio = at91_gpio->regbase;
+	u32 set_bits = values & mask;
+	u32 clr_bits = ~values & mask;
+
+	/* GPIO outputs can only be set at once or cleared at once */
+	if (set_bits)
+		__raw_writel(set_bits, pio + PIO_SODR);
+	if (clr_bits)
+		__raw_writel(clr_bits, pio + PIO_CODR);
+}
+
 static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	int i;
-- 
1.7.9.5


