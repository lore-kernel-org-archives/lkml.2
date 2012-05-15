Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2EOLYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:24:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50385 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab2EOLYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:24:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/12] pinctrl for Ux500 and Nomadik family
Date: Tue, 15 May 2012 11:24:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
References: <1336470214-23407-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1336470214-23407-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151124.13047.arnd@arndb.de>
X-Provags-ID: V02:K0:ElRBXLo51GWBShbljJ8pzzMsIfbiISg8fIlxy+KbEa+
 Dm0SPQrIUou0C2tKceWXxvLvUkrUXp8O/vzuP2VsMvaHYI8plO
 svTOlhlWPA6wICH5HDuQSaO1T17QKq416MzAtZf9LP137qbLG1
 XCO+u6tJm8XADyGZrytIHOGwVPDXyoeeIrMHpXKMgAfx8TYMhJ
 Q7S2PA+Yy+fvkHX65vWWR9CEr+v6nnSHmZUlTRNl/dmY2R/YbH
 cilDvZIKi3nQat8ESJVDC20RY7JiwOqCBXPK9xFOw4N6fC4k/J
 lCXqIypnDTHY4xqKfGIsQgb6d6KWeGwBLhD6b30/kkoudI8pnM
 wYS+nJsB9jqBYGfwalL4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 May 2012, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This moves the Nomadik "GPIO" driver to the pinctrl subsystem
> and adds the interfaces needed to provide a pinctrl driver for
> the DB8500 ASIC.
> 
> It further switches Ux500 over to using it with a combination
> of hogs and runtime controls.
> 
> The ux500 portions were developed on top of the gpio and pins
> branch earlier sent for integration in the ARM SoC tree.

I get build errors with nhk8815_defconfig after this:

arch/arm/mach-nomadik/built-in.o: In function `nhk8815_eth_init':
/home/arnd/linux-arm/arch/arm/mach-nomadik/board-nhk8815.c:224: undefined reference to `nmk_gpio_set_mode'
arch/arm/mach-nomadik/built-in.o: In function `nhk8815_i2c_init':
/home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:46: undefined reference to `nmk_gpio_set_mode'
/home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:47: undefined reference to `nmk_gpio_set_mode'
/home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:50: undefined reference to `nmk_gpio_set_mode'
/home/arnd/linux-arm/arch/arm/mach-nomadik/i2c-8815nhk.c:51: undefined reference to `nmk_gpio_set_mode'

Here is my suggested fix:

8<-----
ARM: nomadik: enable PINCTRL_NOMADIK where needed

The nomadik gpio code has been converted to pinctrl, but the nomadik platform
still expects the old code to be present. Change it to use the new one instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5eae559..ce9d88a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -929,6 +929,7 @@ config ARCH_NOMADIK
 	select CPU_ARM926T
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
+	select PINCTRL
 	select MIGHT_HAVE_CACHE_L2X0
 	select ARCH_REQUIRE_GPIOLIB
 	help
diff --git a/arch/arm/configs/nhk8815_defconfig b/arch/arm/configs/nhk8815_defconfig
index 37207d1..bf123c5 100644
--- a/arch/arm/configs/nhk8815_defconfig
+++ b/arch/arm/configs/nhk8815_defconfig
@@ -97,6 +97,7 @@ CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_GPIO=y
 CONFIG_DEBUG_GPIO=y
+CONFIG_PINCTRL_NOMADIK=y
 # CONFIG_HWMON is not set
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_RTC_CLASS=y
diff --git a/arch/arm/mach-nomadik/Kconfig b/arch/arm/mach-nomadik/Kconfig
index 3c5e0f5..365879b 100644
--- a/arch/arm/mach-nomadik/Kconfig
+++ b/arch/arm/mach-nomadik/Kconfig
@@ -15,6 +15,7 @@ config NOMADIK_8815
 config I2C_BITBANG_8815NHK
 	tristate "Driver for bit-bang busses found on the 8815 NHK"
 	depends on I2C && MACH_NOMADIK_8815NHK
+	depends on PINCTRL_NOMADIK
 	select I2C_ALGOBIT
 	default y
 
diff --git a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
index 3e8b7f1..826de74 100644
--- a/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
+++ b/arch/arm/plat-nomadik/include/plat/gpio-nomadik.h
@@ -62,7 +62,14 @@ enum nmk_gpio_slpm {
 
 extern int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode);
 extern int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull);
+#ifdef CONFIG_PINCTRL_NOMADIK
 extern int nmk_gpio_set_mode(int gpio, int gpio_mode);
+#else
+static inline int nmk_gpio_set_mode(int gpio, int gpio_mode)
+{
+	return -ENODEV;
+}
+#endif
 extern int nmk_gpio_get_mode(int gpio);
 
 extern void nmk_gpio_wakeups_suspend(void);
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 848097e..3755c1d 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -66,7 +66,7 @@ config PINCTRL_IMX28
 
 config PINCTRL_NOMADIK
 	bool "Nomadik pin controller driver"
-	depends on ARCH_U8500
+	depends on ARCH_U8500 || ARCH_NOMADIK
 	select PINMUX
 	select PINCONF
