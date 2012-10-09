Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab2JIPgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:36:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2JIPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:36:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: sirf: remove sirfsoc_gpio_set_pull function
Date: Tue, 9 Oct 2012 15:35:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091535.56487.arnd@arndb.de>
X-Provags-ID: V02:K0:904ndzK1douAEwTsiiNLEse3jUB9grkgdzYf7betnuq
 3N/IfE0LrmAe84C0lszi/N0CXPDTCoCanqau8VPsdejVMP4Nli
 LhCX3T/OekJoXAG09tpY6O4hJcmf9lxBf01huFoO0PF0/OYTiR
 fB6dnqapKYM18UMofT43u5wvqf7vG4Tv+pmU88rC/3wiPlrygP
 6345sZZld7BbGWUnZ4inkh/8vCQobOSkjS9aHgWPIzSUBNtjl3
 xdjyUNrWfTMmadeZyo5fvxWjz8bkaAb9VEWFwgyViGdvJp31yp
 Lg0YwamD0xvvzRl6s9g7n/vRFdUyBHgDUjoUg4Pdk/iJg5UG3y
 DvQ1Y5xqmfaRpiM1RB2E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prima2 platform advertises needing no mach/gpio.h header file,
but its pinctrl driver now has a sirfsoc_gpio_set_pull function
that uses constants defined in arch/arm/mach-prima2/include/mach/gpio.h,
which fails to build.

Fortunately, the sirfsoc_gpio_set_pull is not used anywhere in the
kernel, so we can safely remove it. Any out of tree drivers using
it will have to be converted to use proper pinctrl functions to
do the same.

Without this patch, building prima2_defconfig results in:

drivers/pinctrl/pinctrl-sirf.c: In function 'sirfsoc_gpio_set_pull':
drivers/pinctrl/pinctrl-sirf.c:1331:7: error: 'SIRFSOC_GPIO_PULL_NONE' undeclared (first use in this function)
drivers/pinctrl/pinctrl-sirf.c:1331:7: note: each undeclared identifier is reported only once for each function it appears in
drivers/pinctrl/pinctrl-sirf.c:1334:7: error: 'SIRFSOC_GPIO_PULL_UP' undeclared (first use in this function)
drivers/pinctrl/pinctrl-sirf.c:1338:7: error: 'SIRFSOC_GPIO_PULL_DOWN' undeclared (first use in this function)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <Baohua.Song@csr.com>
Cc: Linus Walleij <linus.walleij@linaro.org>

diff --git a/arch/arm/mach-prima2/include/mach/gpio.h b/arch/arm/mach-prima2/include/mach/gpio.h
deleted file mode 100644
index 1904bb0..0000000
--- a/arch/arm/mach-prima2/include/mach/gpio.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef __MACH_GPIO_H
-#define __MACH_GPIO_H
-
-/* Pull up/down values */
-enum sirfsoc_gpio_pull {
-	SIRFSOC_GPIO_PULL_NONE,
-	SIRFSOC_GPIO_PULL_UP,
-	SIRFSOC_GPIO_PULL_DOWN,
-};
-
-void sirfsoc_gpio_set_pull(unsigned gpio, unsigned mode);
-
-#endif
diff --git a/drivers/pinctrl/pinctrl-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
index 675497c..9ecacf3 100644
--- a/drivers/pinctrl/pinctrl-sirf.c
+++ b/drivers/pinctrl/pinctrl-sirf.c
@@ -1323,41 +1323,6 @@ static inline struct sirfsoc_gpio_bank *sirfsoc_gpio_to_bank(unsigned int gpio)
 	return &sgpio_bank[gpio / SIRFSOC_GPIO_BANK_SIZE];
 }
 
-void sirfsoc_gpio_set_pull(unsigned gpio, unsigned mode)
-{
-	struct sirfsoc_gpio_bank *bank = sirfsoc_gpio_to_bank(gpio);
-	int idx = sirfsoc_gpio_to_offset(gpio);
-	u32 val, offset;
-	unsigned long flags;
-
-	offset = SIRFSOC_GPIO_CTRL(bank->id, idx);
-
-	spin_lock_irqsave(&sgpio_lock, flags);
-
-	val = readl(bank->chip.regs + offset);
-
-	switch (mode) {
-	case SIRFSOC_GPIO_PULL_NONE:
-		val &= ~SIRFSOC_GPIO_CTL_PULL_MASK;
-		break;
-	case SIRFSOC_GPIO_PULL_UP:
-		val |= SIRFSOC_GPIO_CTL_PULL_MASK;
-		val |= SIRFSOC_GPIO_CTL_PULL_HIGH;
-		break;
-	case SIRFSOC_GPIO_PULL_DOWN:
-		val |= SIRFSOC_GPIO_CTL_PULL_MASK;
-		val &= ~SIRFSOC_GPIO_CTL_PULL_HIGH;
-		break;
-	default:
-		break;
-	}
-
-	writel(val, bank->chip.regs + offset);
-
-	spin_unlock_irqrestore(&sgpio_lock, flags);
-}
-EXPORT_SYMBOL(sirfsoc_gpio_set_pull);
-
 static inline struct sirfsoc_gpio_bank *sirfsoc_irqchip_to_bank(struct gpio_chip *chip)
 {
 	return container_of(to_of_mm_gpio_chip(chip), struct sirfsoc_gpio_bank, chip);
