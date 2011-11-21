Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1KUTss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:48:48 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:35170 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756005Ab1KUTsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:48:47 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/8] pinctrl: move the U300 GPIO driver to pinctrl
Date: Mon, 21 Nov 2011 20:48:17 +0100
Message-ID: <1321904897-32344-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This driver will be converted to a dual GPIO + pinctrl driver
since it supports biasing and driving control options. Hopefully
it can serve as an example.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/Kconfig                         |    2 +-
 arch/arm/mach-u300/include/mach/irqs.h             |    2 +-
 drivers/gpio/Kconfig                               |    9 ---------
 drivers/gpio/Makefile                              |    1 -
 drivers/pinctrl/Kconfig                            |    9 +++++++++
 drivers/pinctrl/Makefile                           |    1 +
 .../gpio-u300.c => pinctrl/pinctrl-coh901xxx.c}    |    0
 7 files changed, 12 insertions(+), 12 deletions(-)
 rename drivers/{gpio/gpio-u300.c => pinctrl/pinctrl-coh901xxx.c} (100%)

diff --git a/arch/arm/mach-u300/Kconfig b/arch/arm/mach-u300/Kconfig
index 1cbcd4f..147fade 100644
--- a/arch/arm/mach-u300/Kconfig
+++ b/arch/arm/mach-u300/Kconfig
@@ -8,7 +8,7 @@ config MACH_U300
 	bool "U300"
 	select PINCTRL
 	select PINMUX_U300
-	select GPIO_U300
+	select PINCTRL_COH901XXX
 
 comment "ST-Ericsson U300/U330/U335/U365 Feature Selections"
 
diff --git a/arch/arm/mach-u300/include/mach/irqs.h b/arch/arm/mach-u300/include/mach/irqs.h
index db3fbfa..6281316 100644
--- a/arch/arm/mach-u300/include/mach/irqs.h
+++ b/arch/arm/mach-u300/include/mach/irqs.h
@@ -110,7 +110,7 @@
 #endif
 
 /* Maximum 8*7 GPIO lines */
-#ifdef CONFIG_GPIO_U300
+#ifdef CONFIG_PINCTRL_COH901XXX
 #define IRQ_U300_GPIO_BASE		(U300_VIC_IRQS_END)
 #define IRQ_U300_GPIO_END		(IRQ_U300_GPIO_BASE + 56)
 #else
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 8482a23..0f82aa8 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -170,15 +170,6 @@ config GPIO_SCH
 	  The Intel Tunnel Creek processor has 5 GPIOs powered by the
 	  core power rail and 9 from suspend power supply.
 
-config GPIO_U300
-	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
-	depends on GPIOLIB && ARCH_U300
-	help
-	  Say yes here to support GPIO interface on ST-Ericsson U300.
-	  The names of the two IP block variants supported are
-	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
-	  ports of 8 GPIO pins each.
-
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
 	depends on PCI
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index dbcb0bc..7f20316 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -54,7 +54,6 @@ obj-$(CONFIG_ARCH_DAVINCI_TNETV107X) += gpio-tnetv107x.o
 obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
 obj-$(CONFIG_GPIO_TPS65912)	+= gpio-tps65912.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
-obj-$(CONFIG_MACH_U300)		+= gpio-u300.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
 obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
 obj-$(CONFIG_GPIO_VX855)	+= gpio-vx855.o
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 2c9be64..0efe702 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -33,6 +33,15 @@ config PINMUX_U300
 	depends on ARCH_U300
 	select PINMUX
 
+config PINCTRL_COH901XXX
+	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
+	depends on GPIOLIB && ARCH_U300
+	help
+	  Say yes here to support GPIO interface on ST-Ericsson U300.
+	  The names of the two IP block variants supported are
+	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
+	  ports of 8 GPIO pins each.
+
 endmenu
 
 endif
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index dfc145b..c50206f 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_PINMUX)		+= pinmux.o
 obj-$(CONFIG_PINCONF)		+= pinconf.o
 obj-$(CONFIG_PINMUX_SIRF)	+= pinmux-sirf.o
 obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
+obj-$(CONFIG_PINCTRL_COH901XXX)	+= pinctrl-coh901xxx.o
diff --git a/drivers/gpio/gpio-u300.c b/drivers/pinctrl/pinctrl-coh901xxx.c
similarity index 100%
rename from drivers/gpio/gpio-u300.c
rename to drivers/pinctrl/pinctrl-coh901xxx.c
-- 
1.7.3.2

