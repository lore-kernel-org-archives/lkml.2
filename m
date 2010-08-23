Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0HWN4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:56:21 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:28225 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab0HWN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:56:19 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bn@niasdigital.com, ryan@bluewatersys.com, david-b@pacbell.net
Cc: avictor.za@gmail.com, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] pio: add arch specific gpio_is_valid() function
Date: Mon, 23 Aug 2010 17:01:09 +0200
Message-Id: <1282575669-24501-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20091107122002.1ecf6483@hskinnemoen-d830>
References: <20091107122002.1ecf6483@hskinnemoen-d830>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple gpio_is_valid() function to replace
the standard one. It introduces the __HAVE_ARCH_GPIO_IS_VALID
macro to overload the generic code.
As an implementation example, it takes into account the AT91
pio numbering to check if a proper value is used.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi all,

I come back on this thread as I would like to implement the gpio_is_valid()
function for AT91. I have based this piece of code on comments from Ben and
Haavard and chose the  __HAVE_ARCH_* macro definition as it seems wide spread
in kernel code.
Please make comments and if it is ok for you, eventually accept for merging...


 arch/arm/mach-at91/include/mach/gpio.h |    9 +++++++++
 include/asm-generic/gpio.h             |    4 ++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/gpio.h b/arch/arm/mach-at91/include/mach/gpio.h
index 5cce2ed..103486d 100644
--- a/arch/arm/mach-at91/include/mach/gpio.h
+++ b/arch/arm/mach-at91/include/mach/gpio.h
@@ -188,6 +188,15 @@
 #define	AT91_PIN_PE31	(PIN_BASE + 0x80 + 31)
 
 #ifndef __ASSEMBLY__
+static inline int gpio_is_valid(int number)
+{
+	if (number >= PIN_BASE)
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
index 4f3d75e..2840f35 100644
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
@@ -185,11 +187,13 @@ extern void gpio_unexport(unsigned gpio);
 
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

