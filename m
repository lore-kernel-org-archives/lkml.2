Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2BMOon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:44:43 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:11078 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab2BMOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:44:20 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: tglx@linutronix.de, devicetree-discuss@lists.ozlabs.org,
        avictor.za@gmail.com, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 7/9] ARM: at91/gpio: add .to_irq gpio_chip handler
Date: Mon, 13 Feb 2012 15:43:07 +0100
Message-Id: <3b6c5c3e124b46ad6f57c33a57631e95a25dc5c1.1329139662.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
References: <2fd1ebedc5ad5ac7aeb15c590c4400212a3b06cf.1329139662.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the gpio_to_irq() macro by a plain gpiolib .to_irq() handler.
This call is using the irqdomain to translate hardware to Linux
IRQ numbers.
The irq_to_gpio() macro is completely removed.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/gpio.c              |   13 +++++++++++++
 arch/arm/mach-at91/include/mach/gpio.h |   12 ------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index 0dc3f5e..e8f5831 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -11,6 +11,7 @@
 
 #include <linux/clk.h>
 #include <linux/errno.h>
+#include <linux/device.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -48,6 +49,7 @@ static int at91_gpiolib_direction_output(struct gpio_chip *chip,
 					 unsigned offset, int val);
 static int at91_gpiolib_direction_input(struct gpio_chip *chip,
 					unsigned offset);
+static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset);
 
 #define AT91_GPIO_CHIP(name, base_gpio, nr_gpio)			\
 	{								\
@@ -59,6 +61,7 @@ static int at91_gpiolib_direction_input(struct gpio_chip *chip,
 			.set		  = at91_gpiolib_set,		\
 			.dbg_show	  = at91_gpiolib_dbg_show,	\
 			.base		  = base_gpio,			\
+			.to_irq		  = at91_gpiolib_to_irq,	\
 			.ngpio		  = nr_gpio,			\
 		},							\
 	}
@@ -640,6 +643,16 @@ static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	}
 }
 
+static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
+	int virq = irq_find_mapping(at91_gpio->domain, offset);
+
+	dev_dbg(chip->dev, "%s: request IRQ for GPIO %d, return %d\n",
+				chip->label, offset + chip->base, virq);
+	return virq;
+}
+
 static int __init at91_gpio_setup_clk(int idx)
 {
 	struct at91_gpio_chip *at91_gpio = &gpio_chip[idx];
diff --git a/arch/arm/mach-at91/include/mach/gpio.h b/arch/arm/mach-at91/include/mach/gpio.h
index e3fd225..7cf009b 100644
--- a/arch/arm/mach-at91/include/mach/gpio.h
+++ b/arch/arm/mach-at91/include/mach/gpio.h
@@ -204,18 +204,6 @@ extern int at91_get_gpio_value(unsigned pin);
 extern void at91_gpio_suspend(void);
 extern void at91_gpio_resume(void);
 
-/*-------------------------------------------------------------------------*/
-
-/* wrappers for "new style" GPIO calls. the old AT91-specific ones should
- * eventually be removed (along with this errno.h inclusion), and the
- * gpio request/free calls should probably be implemented.
- */
-
-#include <asm/errno.h>
-
-#define gpio_to_irq(gpio) (gpio + NR_AIC_IRQS)
-#define irq_to_gpio(irq)  (irq - NR_AIC_IRQS)
-
 #endif	/* __ASSEMBLY__ */
 
 #endif
-- 
1.7.9

