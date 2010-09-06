Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0IFNQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:16:55 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:28043 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0IFNQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:16:54 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bn@niasdigital.com, ryan@bluewatersys.com, david-b@pacbell.net
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2] AT91: pio: add gpio_is_valid() function
Date: Mon,  6 Sep 2010 16:21:04 +0200
Message-Id: <1283782864-10567-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4C73807F.4090007@atmel.com>
References: <4C73807F.4090007@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple gpio_is_valid() function to overload
the standard one. It takes into account the AT91
pio numbering to check if a proper value is used.
The upper limit keeps room for IO expanders above
regular on-chip GPIO numbers.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
Changes since v1:
	define ARCH_NR_GPIOS for AT91 keeping room for IO expanders
	now use an upper limit to conform with gpiolib

 arch/arm/mach-at91/include/mach/gpio.h |   14 ++++++++++++++
 include/asm-generic/gpio.h             |    4 ++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/gpio.h b/arch/arm/mach-at91/include/mach/gpio.h
index bfdd8ab..55828ad 100644
--- a/arch/arm/mach-at91/include/mach/gpio.h
+++ b/arch/arm/mach-at91/include/mach/gpio.h
@@ -21,6 +21,10 @@
 #define MAX_GPIO_BANKS		5
 #define NR_BUILTIN_GPIO		(PIN_BASE + (MAX_GPIO_BANKS * 32))
 
+/* keep room for a couple of GPIO expanders */
+#define NR_EXTRA_GPIO		64
+#define ARCH_NR_GPIOS		(NR_BUILTIN_GPIO + NR_EXTRA_GPIO)
+
 /* these pin numbers double as IRQ numbers, like AT91xxx_ID_* values */
 
 #define	AT91_PIN_PA0	(PIN_BASE + 0x00 + 0)
@@ -189,6 +193,16 @@
 #define	AT91_PIN_PE31	(PIN_BASE + 0x80 + 31)
 
 #ifndef __ASSEMBLY__
+static inline int gpio_is_valid(int number)
+{
+	if (number >= PIN_BASE &&
+	    number <= ARCH_NR_GPIOS)
+		return 1;
+	return 0;
+}
+#define __HAVE_ARCH_GPIO_IS_VALID 1
+
+
 /* setup setup routines, called from board init or driver probe() */
 extern int __init_or_module at91_set_GPIO_periph(unsigned pin, int use_pullup);
 extern int __init_or_module at91_set_A_periph(unsigned pin, int use_pullup);
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index c7376bf..264e701 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -22,11 +22,13 @@
 #define ARCH_NR_GPIOS		256
 #endif
 
+#ifndef __HAVE_ARCH_GPIO_IS_VALID
 static inline int gpio_is_valid(int number)
 {
 	/* only some non-negative numbers are valid */
 	return ((unsigned)number) < ARCH_NR_GPIOS;
 }
+#endif
 
 struct device;
 struct seq_file;
@@ -200,11 +202,13 @@ extern void gpio_unexport(unsigned gpio);
 
 #else	/* !CONFIG_HAVE_GPIO_LIB */
 
+#ifndef __HAVE_ARCH_GPIO_IS_VALID
 static inline int gpio_is_valid(int number)
 {
 	/* only non-negative numbers are valid */
 	return number >= 0;
 }
+#endif
 
 /* platforms that don't directly support access to GPIOs through I2C, SPI,
  * or other blocking infrastructure can use these wrappers.
-- 
1.5.6.5

