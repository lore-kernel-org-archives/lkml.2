Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2DOJxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 05:53:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58378 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757Ab2DOJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 05:53:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
Date: Sun, 15 Apr 2012 10:52:54 +0100
Message-Id: <1334483574-3997-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than requiring architectures that use gpiolib but don't have any
need to define anything custom to copy an asm/gpio.h provide a Kconfig
symbol which architectures must select in order to include gpio.h and
for other architectures just provide the trivial implementation directly.

This makes it much easier to do gpiolib updates and is also a step towards
making gpiolib APIs available on every architecture.

For architectures with existing boilerplate code leave a stub header in
place which warns on direct inclusion of asm/gpio.h and includes
linux/gpio.h to catch code that's doing this.  Direct inclusion of
asm/gpio.h has long been deprecated.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 arch/alpha/include/asm/gpio.h      |   59 ++----------------------------
 arch/arm/Kconfig                   |    1 +
 arch/avr32/Kconfig                 |    1 +
 arch/blackfin/Kconfig              |    1 +
 arch/ia64/include/asm/gpio.h       |   59 ++----------------------------
 arch/m68k/Kconfig.cpu              |    1 +
 arch/microblaze/include/asm/gpio.h |   57 ++---------------------------
 arch/mips/Kconfig                  |    1 +
 arch/openrisc/include/asm/gpio.h   |   69 ++---------------------------------
 arch/powerpc/include/asm/gpio.h    |   57 ++---------------------------
 arch/sh/Kconfig                    |    1 +
 arch/sparc/include/asm/gpio.h      |   40 ++-------------------
 arch/unicore32/Kconfig             |    1 +
 arch/x86/include/asm/gpio.h        |   57 ++---------------------------
 arch/xtensa/include/asm/gpio.h     |   60 ++-----------------------------
 drivers/gpio/Kconfig               |    8 ++++
 include/linux/gpio.h               |   34 +++++++++++++++++
 17 files changed, 81 insertions(+), 426 deletions(-)

diff --git a/arch/alpha/include/asm/gpio.h b/arch/alpha/include/asm/gpio.h
index 7dc6a63..b3799d8 100644
--- a/arch/alpha/include/asm/gpio.h
+++ b/arch/alpha/include/asm/gpio.h
@@ -1,55 +1,4 @@
-/*
- * Generic GPIO API implementation for Alpha.
- *
- * A stright copy of that for PowerPC which was:
- *
- * Copyright (c) 2007-2008  MontaVista Software, Inc.
- *
- * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef _ASM_ALPHA_GPIO_H
-#define _ASM_ALPHA_GPIO_H
-
-#include <linux/errno.h>
-#include <asm-generic/gpio.h>
-
-#ifdef CONFIG_GPIOLIB
-
-/*
- * We don't (yet) implement inlined/rapid versions for on-chip gpios.
- * Just call gpiolib.
- */
-static inline int gpio_get_value(unsigned int gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned int gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_cansleep(unsigned int gpio)
-{
-	return __gpio_cansleep(gpio);
-}
-
-static inline int gpio_to_irq(unsigned int gpio)
-{
-	return __gpio_to_irq(gpio);
-}
-
-static inline int irq_to_gpio(unsigned int irq)
-{
-	return -EINVAL;
-}
-
-#endif /* CONFIG_GPIOLIB */
-
-#endif /* _ASM_ALPHA_GPIO_H */
+#ifndef __LINUX_GPIO_H
+#warning Include linux/gpio.h instead of asm/gpio.h
+#include <linux/gpio.h>
+#endif
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a5dd93e..9101c61 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1,6 +1,7 @@
 config ARM
 	bool
 	default y
+	select ARCH_HAVE_CUSTOM_GPIO_H
 	select HAVE_AOUT
 	select HAVE_DMA_API_DEBUG
 	select HAVE_IDE if PCI || ISA || PCMCIA
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 3dea7231..859b2de 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -11,6 +11,7 @@ config AVR32
 	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
+	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 373a690..bf3d80f 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -31,6 +31,7 @@ config BLACKFIN
 	select HAVE_KERNEL_LZO if RAMKERNEL
 	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
diff --git a/arch/ia64/include/asm/gpio.h b/arch/ia64/include/asm/gpio.h
index 590a20d..b3799d8 100644
--- a/arch/ia64/include/asm/gpio.h
+++ b/arch/ia64/include/asm/gpio.h
@@ -1,55 +1,4 @@
-/*
- * Generic GPIO API implementation for IA-64.
- *
- * A stright copy of that for PowerPC which was:
- *
- * Copyright (c) 2007-2008  MontaVista Software, Inc.
- *
- * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef _ASM_IA64_GPIO_H
-#define _ASM_IA64_GPIO_H
-
-#include <linux/errno.h>
-#include <asm-generic/gpio.h>
-
-#ifdef CONFIG_GPIOLIB
-
-/*
- * We don't (yet) implement inlined/rapid versions for on-chip gpios.
- * Just call gpiolib.
- */
-static inline int gpio_get_value(unsigned int gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned int gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_cansleep(unsigned int gpio)
-{
-	return __gpio_cansleep(gpio);
-}
-
-static inline int gpio_to_irq(unsigned int gpio)
-{
-	return __gpio_to_irq(gpio);
-}
-
-static inline int irq_to_gpio(unsigned int irq)
-{
-	return -EINVAL;
-}
-
-#endif /* CONFIG_GPIOLIB */
-
-#endif /* _ASM_IA64_GPIO_H */
+#ifndef __LINUX_GPIO_H
+#warning Include linux/gpio.h instead of asm/gpio.h
+#include <linux/gpio.h>
+#endif
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index 8a9c767..8941af1 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -24,6 +24,7 @@ config COLDFIRE
 	bool "Coldfire CPU family support"
 	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_HAVE_CUSTOM_GPIO_H
 	select CPU_HAS_NO_BITFIELDS
 	select CPU_HAS_NO_MULDIV64
 	select GENERIC_CSUM
diff --git a/arch/microblaze/include/asm/gpio.h b/arch/microblaze/include/asm/gpio.h
index 2b2c18b..b3799d8 100644
--- a/arch/microblaze/include/asm/gpio.h
+++ b/arch/microblaze/include/asm/gpio.h
@@ -1,53 +1,4 @@
-/*
- * Generic GPIO API implementation for PowerPC.
- *
- * Copyright (c) 2007-2008  MontaVista Software, Inc.
- *
- * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef _ASM_MICROBLAZE_GPIO_H
-#define _ASM_MICROBLAZE_GPIO_H
-
-#include <linux/errno.h>
-#include <asm-generic/gpio.h>
-
-#ifdef CONFIG_GPIOLIB
-
-/*
- * We don't (yet) implement inlined/rapid versions for on-chip gpios.
- * Just call gpiolib.
- */
-static inline int gpio_get_value(unsigned int gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned int gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_cansleep(unsigned int gpio)
-{
-	return __gpio_cansleep(gpio);
-}
-
-static inline int gpio_to_irq(unsigned int gpio)
-{
-	return __gpio_to_irq(gpio);
-}
-
-static inline int irq_to_gpio(unsigned int irq)
-{
-	return -EINVAL;
-}
-
-#endif /* CONFIG_GPIOLIB */
-
-#endif /* _ASM_MICROBLAZE_GPIO_H */
+#ifndef __LINUX_GPIO_H
+#warning Include linux/gpio.h instead of asm/gpio.h
+#include <linux/gpio.h>
+#endif
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ce30e2f..63321b2 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -8,6 +8,7 @@ config MIPS
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_ARCH_KGDB
+	select ARCH_HAVE_CUSTOM_GPIO_H
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_DYNAMIC_FTRACE
diff --git a/arch/openrisc/include/asm/gpio.h b/arch/openrisc/include/asm/gpio.h
index 0b0d174..b3799d8 100644
--- a/arch/openrisc/include/asm/gpio.h
+++ b/arch/openrisc/include/asm/gpio.h
@@ -1,65 +1,4 @@
-/*
- * OpenRISC Linux
- *
- * Linux architectural port borrowing liberally from similar works of
- * others.  All original copyrights apply as per the original source
- * declaration.
- *
- * OpenRISC implementation:
- * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
- * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
- * et al.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __ASM_OPENRISC_GPIO_H
-#define __ASM_OPENRISC_GPIO_H
-
-#include <linux/errno.h>
-#include <asm-generic/gpio.h>
-
-#ifdef CONFIG_GPIOLIB
-
-/*
- * OpenRISC (or1k) does not have on-chip GPIO's so there is not really
- * any standardized implementation that makes sense here.  If passing
- * through gpiolib becomes a bottleneck then it may make sense, on a
- * case-by-case basis, to implement these inlined/rapid versions.
- *
- * Just call gpiolib.
- */
-static inline int gpio_get_value(unsigned int gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned int gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_cansleep(unsigned int gpio)
-{
-	return __gpio_cansleep(gpio);
-}
-
-/*
- * Not implemented, yet.
- */
-static inline int gpio_to_irq(unsigned int gpio)
-{
-	return -ENOSYS;
-}
-
-static inline int irq_to_gpio(unsigned int irq)
-{
-	return -EINVAL;
-}
-
-#endif /* CONFIG_GPIOLIB */
-
-#endif /* __ASM_OPENRISC_GPIO_H */
+#ifndef __LINUX_GPIO_H
+#warning Include linux/gpio.h instead of asm/gpio.h
+#include <linux/gpio.h>
+#endif
diff --git a/arch/powerpc/include/asm/gpio.h b/arch/powerpc/include/asm/gpio.h
index 38762ed..b3799d8 100644
--- a/arch/powerpc/include/asm/gpio.h
+++ b/arch/powerpc/include/asm/gpio.h
@@ -1,53 +1,4 @@
-/*
- * Generic GPIO API implementation for PowerPC.
- *
- * Copyright (c) 2007-2008  MontaVista Software, Inc.
- *
- * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __ASM_POWERPC_GPIO_H
-#define __ASM_POWERPC_GPIO_H
-
-#include <linux/errno.h>
-#include <asm-generic/gpio.h>
-
-#ifdef CONFIG_GPIOLIB
-
-/*
- * We don't (yet) implement inlined/rapid versions for on-chip gpios.
- * Just call gpiolib.
- */
-static inline int gpio_get_value(unsigned int gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned int gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_cansleep(unsigned int gpio)
-{
-	return __gpio_cansleep(gpio);
-}
-
-static inline int gpio_to_irq(unsigned int gpio)
-{
-	return __gpio_to_irq(gpio);
-}
-
-static inline int irq_to_gpio(unsigned int irq)
-{
-	return -EINVAL;
-}
-
-#endif /* CONFIG_GPIOLIB */
-
-#endif /* __ASM_POWERPC_GPIO_H */
+#ifndef __LINUX_GPIO_H
+#warning Include linux/gpio.h instead of asm/gpio.h
+#include <linux/gpio.h>
+#endif
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index ff9e033..c40b29a 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -13,6 +13,7 @@ config SUPERH
 	select HAVE_DMA_ATTRS
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
 	select PERF_USE_VMALLOC
 	select HAVE_KERNEL_GZIP
diff --git a/arch/sparc/include/asm/gpio.h b/arch/sparc/include/asm/gpio.h
index a0e3ac0..b3799d8 100644
--- a/arch/sparc/include/asm/gpio.h
+++ b/arch/sparc/include/asm/gpio.h
@@ -1,36 +1,4 @@
-#ifndef __ASM_SPARC_GPIO_H
-#define __ASM_SPARC_GPIO_H
-
-#include <linux/errno.h>
-#include <asm-generic/gpio.h>
-
-#ifdef CONFIG_GPIOLIB
-
-static inline int gpio_get_value(unsigned int gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned int gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_cansleep(unsigned int gpio)
-{
-	return __gpio_cansleep(gpio);
-}
-
-static inline int gpio_to_irq(unsigned int gpio)
-{
-	return -ENOSYS;
-}
-
-static inline int irq_to_gpio(unsigned int irq)
-{
-	return -EINVAL;
-}
-
-#endif /* CONFIG_GPIOLIB */
-
-#endif /* __ASM_SPARC_GPIO_H */
+#ifndef __LINUX_GPIO_H
+#warning Include linux/gpio.h instead of asm/gpio.h
+#include <linux/gpio.h>
+#endif
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index eeb8054..7ff6d10 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -8,6 +8,7 @@ config UNICORE32
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
+	select ARCH_HAVE_CUSTOM_GPIO_H
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff --git a/arch/x86/include/asm/gpio.h b/arch/x86/include/asm/gpio.h
index 91d915a..b3799d8 100644
--- a/arch/x86/include/asm/gpio.h
+++ b/arch/x86/include/asm/gpio.h
@@ -1,53 +1,4 @@
-/*
- * Generic GPIO API implementation for x86.
- *
- * Derived from the generic GPIO API for powerpc:
- *
- * Copyright (c) 2007-2008  MontaVista Software, Inc.
- *
- * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef _ASM_X86_GPIO_H
-#define _ASM_X86_GPIO_H
-
-#include <asm-generic/gpio.h>
-
-#ifdef CONFIG_GPIOLIB
-
-/*
- * Just call gpiolib.
- */
-static inline int gpio_get_value(unsigned int gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned int gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_cansleep(unsigned int gpio)
-{
-	return __gpio_cansleep(gpio);
-}
-
-static inline int gpio_to_irq(unsigned int gpio)
-{
-	return __gpio_to_irq(gpio);
-}
-
-static inline int irq_to_gpio(unsigned int irq)
-{
-	return -EINVAL;
-}
-
-#endif /* CONFIG_GPIOLIB */
-
-#endif /* _ASM_X86_GPIO_H */
+#ifndef __LINUX_GPIO_H
+#warning Include linux/gpio.h instead of asm/gpio.h
+#include <linux/gpio.h>
+#endif
diff --git a/arch/xtensa/include/asm/gpio.h b/arch/xtensa/include/asm/gpio.h
index a8c9fc4..b3799d8 100644
--- a/arch/xtensa/include/asm/gpio.h
+++ b/arch/xtensa/include/asm/gpio.h
@@ -1,56 +1,4 @@
-/*
- * Generic GPIO API implementation for xtensa.
- *
- * Stolen from x86, which is derived from the generic GPIO API for powerpc:
- *
- * Copyright (c) 2007-2008  MontaVista Software, Inc.
- *
- * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef _ASM_XTENSA_GPIO_H
-#define _ASM_XTENSA_GPIO_H
-
-#include <asm-generic/gpio.h>
-
-#ifdef CONFIG_GPIOLIB
-
-/*
- * Just call gpiolib.
- */
-static inline int gpio_get_value(unsigned int gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned int gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-static inline int gpio_cansleep(unsigned int gpio)
-{
-	return __gpio_cansleep(gpio);
-}
-
-static inline int gpio_to_irq(unsigned int gpio)
-{
-	return __gpio_to_irq(gpio);
-}
-
-/*
- * Not implemented, yet.
- */
-static inline int irq_to_gpio(unsigned int irq)
-{
-	return -EINVAL;
-}
-
-#endif /* CONFIG_GPIOLIB */
-
-#endif /* _ASM_XTENSA_GPIO_H */
+#ifndef __LINUX_GPIO_H
+#warning Include linux/gpio.h instead of asm/gpio.h
+#include <linux/gpio.h>
+#endif
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 7875c3f..4faec0a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -2,6 +2,14 @@
 # GPIO infrastructure and drivers
 #
 
+config ARCH_HAVE_CUSTOM_GPIO_H
+	bool
+	help
+	  Selecting this config option from the architecture Kconfig allows
+	  the architecture to provide a custom asm/gpio.h implementation
+	  overriding the default implementations.  New uses of this are
+	  strongly discouraged.
+
 config ARCH_WANT_OPTIONAL_GPIOLIB
 	bool
 	help
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index a68024e..1df711f 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_GPIO_H
 #define __LINUX_GPIO_H
 
+#include <linux/errno.h>
+
 /* see Documentation/gpio.txt */
 
 /* make these flag values available regardless of GPIO kconfig options */
@@ -38,7 +40,39 @@ struct gpio {
 };
 
 #ifdef CONFIG_GENERIC_GPIO
+
+#ifdef CONFIG_ARCH_HAVE_CUSTOM_GPIO_H
 #include <asm/gpio.h>
+#else
+
+#include <asm-generic/gpio.h>
+
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return __gpio_to_irq(gpio);
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+
+#endif
 
 #else
 
-- 
1.7.9.1

