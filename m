Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2H0WQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:16:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48827 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab2H0WQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <201208221301.19439.arnd@arndb.de>
References: <201208221253.07278.arnd@arndb.de>
	<201208221301.19439.arnd@arndb.de>
Date: Tue, 28 Aug 2012 06:16:35 +0800
Message-ID: <CAN1soZw4scDo7mgcBKrk_kdMt7aP_ty+hRGX=iMDjkfSbO6k8A@mail.gmail.com>
Subject: Re: [PATCH 4/4] [RFC] ARM: treewide: manually change more mach-*/*.h includes
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 9:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> These are lots of device drivers that include machine
> specific header files from ARM platforms and that are
> not easily scriptable. The changes have been found through
> manual inspection and should cause no visible changes
> because of the build script that maps the old names to the
> new ones.
>
Here's the potential issues.

arch/arm/include/asm/irq.h:
#ifndef CONFIG_SPARSE_IRQ
#include <mach/irqs.h>
#else
#define NR_IRQS NR_IRQS_LEGACY
#endif

arch/arm/include/asm/io.h:
#ifdef CONFIG_NEED_MACH_IO_H
#include <mach/io.h>
#else
#define __io(a)         __typesafe_io((a) & IO_SPACE_LIMIT)
#endif


And you also need the code in below.

diff --git a/drivers/gpio/gpio-sa1100.c b/drivers/gpio/gpio-sa1100.c
index 8ea3b33..0258c06 100644
--- a/drivers/gpio/gpio-sa1100.c
+++ b/drivers/gpio/gpio-sa1100.c
@@ -11,8 +11,8 @@
 #include <linux/init.h>
 #include <linux/module.h>

-#include <mach/hardware.h>
-#include <mach/irqs.h>
+#include <mach-sa1100/hardware.h>
+#include <mach-sa1100/irqs.h>

 static int sa1100_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
diff --git a/drivers/input/keyboard/pxa27x_keypad.c
b/drivers/input/keyboard/pxa27x_keypad.c
index b2e642a..d4b1e80 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -31,7 +31,14 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>

-#include <mach/hardware.h>
+#ifdef CONFIG_ARCH_PXA
+#include <mach-pxa/hardware.h>
+#endif
+
+#ifdef CONFIG_ARCH_MMP
+#include <mach-mmp/hardware.h>
+#endif
+
 #include <plat-pxa/pxa27x_keypad.h>
 /*
  * Keypad Controller registers
diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index d6683b7..f83d5ce 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -23,7 +23,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>

-#include <mach/dma.h>
+#include <mach-pxa/dma.h>
 #include <plat-pxa/pxa3xx_nand.h>

 #define	CHIP_DELAY_TIMEOUT	(2 * HZ/10)
diff --git a/drivers/pcmcia/pxa2xx_sharpsl.c b/drivers/pcmcia/pxa2xx_sharpsl.c
index b066273..77264ba 100644
--- a/drivers/pcmcia/pxa2xx_sharpsl.c
+++ b/drivers/pcmcia/pxa2xx_sharpsl.c
@@ -19,9 +19,9 @@
 #include <linux/platform_device.h>

 #include <asm/mach-types.h>
-#include <mach/hardware.h>
 #include <asm/irq.h>
 #include <asm/hardware/scoop.h>
+#include <mach-pxa/hardware.h>

 #include "soc_common.h"

diff --git a/drivers/pcmcia/sa1111_generic.c b/drivers/pcmcia/sa1111_generic.c
index 70f728c..ebfd5eb 100644
--- a/drivers/pcmcia/sa1111_generic.c
+++ b/drivers/pcmcia/sa1111_generic.c
@@ -16,7 +16,7 @@

 #include <pcmcia/ss.h>

-#include <mach/hardware.h>
+#include <mach-sa1100/hardware.h>
 #include <asm/hardware/sa1111.h>
 #include <asm/irq.h>

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 50a5c4a..812f39c 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -35,11 +35,21 @@
 #include <linux/bitops.h>
 #include <linux/io.h>

-#include <mach/hardware.h>
-#include <mach/irqs.h>
+#ifdef CONFIG_ARCH_MMP
+#include <mach-mmp/hardware.h>
+#include <mach-mmp/irqs.h>
+#include <mach-mmp/regs-rtc.h>
+#endif
+
+#ifdef CONFIG_ARCH_PXA
+#include <mach-pxa/hardware.h>
+#include <mach-pxa/irqs.h>
+#include <mach-pxa/regs-rtc.h>
+#endif

-#if defined(CONFIG_ARCH_PXA) || defined(CONFIG_ARCH_MMP)
-#include <mach/regs-rtc.h>
+#ifdef CONFIG_ARCH_SA1100
+#include <mach-sa1100/hardware.h>
+#include <mach-sa1100/irqs.h>
 #endif

 #define RTC_DEF_DIVIDER		(32768 - 1)
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index ccd6b29..3579d90 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -34,11 +34,15 @@
 #include <linux/timex.h>

 #ifdef CONFIG_ARCH_PXA
-#include <mach/regs-ost.h>
+#include <mach-pxa/regs-ost.h>
+#include <mach-pxa/reset.h>
+#include <mach-pxa/hardware.h>
 #endif

-#include <mach/reset.h>
-#include <mach/hardware.h>
+#ifdef CONFIG_ARCH_SA1100
+#include <mach-sa1100/reset.h>
+#include <mach-sa1100/hardware.h>
+#endif

 static unsigned long oscr_freq;
 static unsigned long sa1100wdt_users;
