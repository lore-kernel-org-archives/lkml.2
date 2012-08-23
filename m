Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab2HWO0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:26:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56667 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab2HWO0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:26:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] ARM: ux500: don't select LEDS_GPIO for snowball
Date: Thu, 23 Aug 2012 14:26:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de> <1345648390-4234-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1345648390-4234-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201208231426.43105.arnd@arndb.de>
X-Provags-ID: V02:K0:ffQIjPC8k/2Fivwq6I1G5Bd6xxJQ6LijqnY+h2Kx926
 I6NmSi1VTPZ0P+u8DB0d5Ky9+LcTy9nNcjKJPkRg2SvqLJEe0b
 wg2M/UA8p8B8cNenc01ZM6t//Sst9LEY+Ywxx8w4OuT7Nz1PGR
 ycHzMnyQBLe+xAMYU4mEaS9RhVGTxTRsb9wZJhjM+w5TS2KjoK
 ZIp4rU6D4iMhseLC4QxqHGZ3agQfYFC+xMv0oBI6w+IhLsEZyX
 8wRkYNXr+5JZeAv6yhjnsQQX6HKlejAnv6UklywhXF50H5jtXX
 jf4mewNT2SAINODKmZ8Xten5fH7Wh/xt5JKgUD8qyaEt1subYb
 iK4DtDmwmj8VFC1YAyVI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Arnd Bergmann wrote:
> The gpio leds driver can only be built if the generic LED code is
> also enabled. Snowball selects LEDS_GPIO for an unknown reason
> but it does not select LEDS_CLASS and also does not really require
> the LED support at all, so we can just drop this dependency.
> 
> Without this patch, building without LEDS_CLASS esults in:
> 
> drivers/built-in.o: In function `create_gpio_led.part.2':
> governor_userspace.c:(.devinit.text+0x5a58): undefined reference to `led_classdev_register'
> drivers/built-in.o: In function `gpio_led_remove':
> governor_userspace.c:(.devexit.text+0x6b8): undefined reference to `led_classdev_unregister'
> 
> This reverts 8733f53c6 "ARM: ux500: Kconfig: Compile in leds-gpio
> support for Snowball", which was not completely thought through.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Lee Jones <lee.jones@linaro.org>

I discussed this with Lee on IRC, he really wants to keep the LED enabled for snowball
for his own convenience. How is this version instead?

	Arnd

>From 53c4e002b7ebd70ad9dcfa7a97c0ae58e874e643 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 15 Aug 2012 20:34:48 +0000
Subject: [PATCH] ARM: ux500: don't select LEDS_GPIO for snowball

The gpio leds driver can only be built if the generic LED code is
also enabled. Snowball selects LEDS_GPIO for an unknown reason
but it does not select LEDS_CLASS and also does not really require
the LED support at all, so we can just drop this dependency.

Without this patch, building without LEDS_CLASS esults in:

drivers/built-in.o: In function `create_gpio_led.part.2':
governor_userspace.c:(.devinit.text+0x5a58): undefined reference to `led_classdev_register'
drivers/built-in.o: In function `gpio_led_remove':
governor_userspace.c:(.devexit.text+0x6b8): undefined reference to `led_classdev_unregister'

This reverts 8733f53c6 "ARM: ux500: Kconfig: Compile in leds-gpio
support for Snowball", which was not completely thought through.

In order to leave the GPIO LED code still present in normal
builds, this also enables the symbol in u8500_defconfig, in addition
to the other LED drivers that are already selected there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 2d4f661..da68454 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -86,6 +86,7 @@ CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_LM3530=y
 CONFIG_LEDS_LP5521=y
+CONFIG_LEDS_GPIO=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_AB8500=y
 CONFIG_RTC_DRV_PL031=y
diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index c013bbf..53d3d46 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -41,7 +41,6 @@ config MACH_HREFV60
 config MACH_SNOWBALL
 	bool "U8500 Snowball platform"
 	select MACH_MOP500
-	select LEDS_GPIO
 	help
 	  Include support for the snowball development platform.
 
