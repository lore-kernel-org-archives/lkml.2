Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab2LNR6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:58:10 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:54406 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab2LNR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:58:08 -0500
X-manitu-Original-Sender-IP: 79.230.51.13
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <50CB68AB.5070806@grandegger.com>
Date: Fri, 14 Dec 2012 18:58:03 +0100
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
References: <1355495185-24220-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1355495185-24220-1-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/mixed;
 boundary="------------020102010208020503070207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020102010208020503070207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/14/2012 03:26 PM, Roland Stigge wrote:
> This set of patches adds:
> 
> * Block GPIO API to gpiolib
> * Sysfs support for GPIO API, to provide userland access
> * Device interface for userland access (alternative to sysfs)
> * Devicetree support to instantiate GPIO blocks via DT
> * Example implementations in several gpio drivers since they need
>   special accessor functions for block wise GPIO access
> * Fix for race condition in gpiolib on device creation
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Tested by: Wolfgang Grandegger <wg@grandegger.com>

I'm going to re-test this version next week. Attached you will find my
GPIO block adoptions for the AT91.

Wolfgang


--------------020102010208020503070207
Content-Type: text/x-diff;
 name="0001-gpio-add-GPIO-block-callback-functions-for-AT91.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-gpio-add-GPIO-block-callback-functions-for-AT91.patch"

>From 16c0e4b933dcdb3859184190b62655f4ac90949f Mon Sep 17 00:00:00 2001
From: Wolfgang Grandegger <wg@grandegger.com>
Date: Mon, 3 Dec 2012 08:31:55 +0100
Subject: [PATCH] gpio: add GPIO block callback functions for AT91

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
---
 arch/arm/mach-at91/gpio.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index be42cf0..dd0853d 100644
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
@@ -905,6 +919,14 @@ static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
 	__raw_writel(mask, pio + (val ? PIO_SODR : PIO_CODR));
 }
 
+static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
+{
+	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
+	void __iomem *pio = at91_gpio->regbase;
+
+	__raw_writel(mask, pio + (val ? PIO_SODR : PIO_CODR));
+}
+
 static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	int i;
-- 
1.7.9.5


--------------020102010208020503070207--
