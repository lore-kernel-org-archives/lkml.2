Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1HKRs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:48:28 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:23712 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1HKRs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:48:27 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1313084905!34828918!2
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Ryan Mallon <rmallon@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Date: Thu, 11 Aug 2011 12:48:24 -0500
Subject: RE: [PATCH 10/19] mach-ep93xx: break out GPIO driver specifics
Thread-Topic: [PATCH 10/19] mach-ep93xx: break out GPIO driver specifics
Thread-Index: AcxYIlEzTDiKzyFnS+CbB8tv7Dj8ewAJPYaAAAEyWeA=
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3883899A6@AUSP01VMBX24.collaborationhost.net>
References: <1312978655-18405-1-git-send-email-linus.walleij@stericsson.com>
	<ADE657CA350FB648AAC2C43247A983F001F38838966E@AUSP01VMBX24.collaborationhost.net>
	<CACRpkdabHj_C7wgGfu3g6LSsa2iMZS0h279wf6McOxfge9Gm_w@mail.gmail.com>
 <ADE657CA350FB648AAC2C43247A983F001F388389983@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F388389983@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 11, 2011 10:16 AM, H Hartley Sweeten wrote:
> On Thursday, August 11, 2011 5:29 AM, Linus Walleij wrote:
>> On Wed, Aug 10, 2011 at 7:23 PM, H Hartley Sweeten wrote:
>>> On Wednesday, August 10, 2011 5:18 AM, Linus Walleij wrote:
>>>> +#include "gpio-ep93xx.h"
>>>
>>> Why this form?  Isn't <mach/gpio-ep93xx.h> the preferred form?
>>
>> This is to make the inclusion very local. The only reason it is
>> included at all is to get EP93XX_GPIO_LINE_MAX_IRQ,
>> nothing else.
>
> Hmm..  It is needed for gpio_to_irq()...
>
> The only other user of that define is drivers/gpio/gpio-ep93xx.c.
>
> To follow the intentions of this patch it would be nice to remove this 
> include from <mach/gpio.h> and add <mach/gpio-ep93xx.h> to the gpio driver.
> But, any user of gpio_to_irq() whould also have to include <mach/gpio-ep93xx.h>
> also.
>
> The other solution is to hook up the gpiolib to_irq callback in
> gpio-ep93xx and do:
>
> #define gpio_to_irq	__gpio_to_irq
>
> Maybe this is a better option?

BTW, I have a patch for this if you want.

----

gpio-ep93xx: hookup the to_irq callback in the driver

Remove the ep93xx machine specific dependencies for gpio_to_irq() by
hooking up the callback in the driver and using __gpio_to_irq.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/arch/arm/mach-ep93xx/include/mach/gpio.h b/arch/arm/mach-ep93xx/include/mach/gpio.h
index 071f676..76c68fa 100644
--- a/arch/arm/mach-ep93xx/include/mach/gpio.h
+++ b/arch/arm/mach-ep93xx/include/mach/gpio.h
@@ -99,14 +99,7 @@
 /* maximum value for irq capable line identifiers */
 #define EP93XX_GPIO_LINE_MAX_IRQ	EP93XX_GPIO_LINE_F(7)
 
-/*
- * Map GPIO A0..A7  (0..7)  to irq 64..71,
- *          B0..B7  (7..15) to irq 72..79, and
- *          F0..F7 (16..24) to irq 80..87.
- */
-#define gpio_to_irq(gpio)	\
-	(((gpio) <= EP93XX_GPIO_LINE_MAX_IRQ) ? (64 + (gpio)) : -EINVAL)
-
+#define gpio_to_irq		__gpio_to_irq
 #define irq_to_gpio(irq)	((irq) - gpio_to_irq(0))
 
 #endif
diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 468b27d..6a56895 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -308,6 +308,21 @@ static int ep93xx_gpio_set_debounce(struct gpio_chip *chip,
 	return 0;
 }
 
+/*
+ * Map GPIO A0..A7  (0..7)  to irq 64..71,
+ *          B0..B7  (7..15) to irq 72..79, and
+ *          F0..F7 (16..24) to irq 80..87.
+ */
+static int ep93xx_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	int gpio = chip->base + offset;
+
+	if (gpio > EP93XX_GPIO_LINE_MAX_IRQ)
+		return -EINVAL;
+
+	return 64 + gpio;
+}
+
 static int ep93xx_gpio_add_bank(struct bgpio_chip *bgc, struct device *dev,
 	void __iomem *mmio_base, struct ep93xx_gpio_bank *bank)
 {
@@ -322,8 +337,10 @@ static int ep93xx_gpio_add_bank(struct bgpio_chip *bgc, struct device *dev,
 	bgc->gc.label = bank->label;
 	bgc->gc.base = bank->base;
 
-	if (bank->has_debounce)
+	if (bank->has_debounce) {
 		bgc->gc.set_debounce = ep93xx_gpio_set_debounce;
+		bgc->gc.to_irq = ep93xx_gpio_to_irq;
+	}
 
 	return gpiochip_add(&bgc->gc);
 }
