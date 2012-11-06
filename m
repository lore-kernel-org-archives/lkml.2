Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2KFHEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:04:41 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59135 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2KFHEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:04:40 -0500
Message-ID: <1352185470.3088.1.camel@phoenix>
Subject: [PATCH] pinctrl: PINCTRL_SAMSUNG and PINCTRL_EXYNOS4 need to depend
 on OF && GPIOLIB
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Date: Tue, 06 Nov 2012 15:04:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below build error when !CONFIG_OF_GPIO.

  CC      drivers/pinctrl/pinctrl-samsung.o
drivers/pinctrl/pinctrl-samsung.c: In function 'samsung_pinctrl_parse_dt_pins':
drivers/pinctrl/pinctrl-samsung.c:557:19: warning: unused variable 'prop' [-Wunused-variable]
drivers/pinctrl/pinctrl-samsung.c: In function 'samsung_gpiolib_register':
drivers/pinctrl/pinctrl-samsung.c:797:5: error: 'struct gpio_chip' has no member named 'of_node'
make[2]: *** [drivers/pinctrl/pinctrl-samsung.o] Error 1
make[1]: *** [drivers/pinctrl] Error 2
make: *** [drivers] Error 2

The samsung pinctrl driver supports only device tree enabled platforms.
Thus make PINCTRL_SAMSUNG depend on OF && GPIOLIB.

The reason to depend on GPIOLIB is CONFIG_OF_GPIO only available when GPIOLIB
is selected.
Since PINCTRL_EXYNOS4 select PINCTRL_SAMSUNG, thus also make PINCTRL_EXYNOS4
depend on OF && GPIOLIB.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Thomas,

If I simply add "select OF_GPIO" for PINCTRL_SAMSUNG, I got below build warning:
warning: (PINCTRL_SAMSUNG) selects OF_GPIO which has unmet direct dependencies (GPIOLIB && OF && !SPARC)

So I make PINCTRL_SAMSUNG depend on OF && GPIOLIB.

Regards,
Axel

 drivers/pinctrl/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 6777a4c..6d5a50b 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -188,11 +188,13 @@ config PINCTRL_COH901
 
 config PINCTRL_SAMSUNG
 	bool "Samsung pinctrl driver"
+	depends on OF && GPIOLIB
 	select PINMUX
 	select PINCONF
 
 config PINCTRL_EXYNOS4
 	bool "Pinctrl driver data for Exynos4 SoC"
+	depends on OF && GPIOLIB
 	select PINCTRL_SAMSUNG
 
 source "drivers/pinctrl/mvebu/Kconfig"
-- 
1.7.9.5



