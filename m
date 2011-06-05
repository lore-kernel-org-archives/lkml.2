Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1FEPvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 11:51:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61490 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab1FEPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 11:51:01 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: [PATCH v4 1/3] gpio/mxs: Move Freescale mxs gpio driver to drivers/gpio
Date: Sun,  5 Jun 2011 23:59:03 +0800
Message-Id: <1307289545-6993-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307289545-6993-1-git-send-email-shawn.guo@linaro.org>
References: <1307289545-6993-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

GPIO drivers are getting moved to drivers/gpio for cleanup and
consolidation.  This patch moves the mxs driver.  Follow up patches
will clean it up and make it a fine upstanding example of a gpio
driver.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/mach-mxs/Makefile                         |    2 +-
 .../mach-mxs/{gpio.h => include/mach/gpio-mxs.h}   |    0
 arch/arm/mach-mxs/mach-mx28evk.c                   |    1 -
 drivers/gpio/Kconfig                               |    4 ++++
 drivers/gpio/Makefile                              |    1 +
 .../arm/mach-mxs/gpio.c => drivers/gpio/gpio-mxs.c |    3 +--
 6 files changed, 7 insertions(+), 4 deletions(-)
 rename arch/arm/mach-mxs/{gpio.h => include/mach/gpio-mxs.h} (100%)
 rename arch/arm/mach-mxs/gpio.c => drivers/gpio/gpio-mxs.c (99%)

diff --git a/arch/arm/mach-mxs/Makefile b/arch/arm/mach-mxs/Makefile
index 58e8923..6c38262 100644
--- a/arch/arm/mach-mxs/Makefile
+++ b/arch/arm/mach-mxs/Makefile
@@ -1,5 +1,5 @@
 # Common support
-obj-y := clock.o devices.o gpio.o icoll.o iomux.o system.o timer.o
+obj-y := clock.o devices.o icoll.o iomux.o system.o timer.o
 
 obj-$(CONFIG_MXS_OCOTP) += ocotp.o
 obj-$(CONFIG_PM) += pm.o
diff --git a/arch/arm/mach-mxs/gpio.h b/arch/arm/mach-mxs/include/mach/gpio-mxs.h
similarity index 100%
rename from arch/arm/mach-mxs/gpio.h
rename to arch/arm/mach-mxs/include/mach/gpio-mxs.h
diff --git a/arch/arm/mach-mxs/mach-mx28evk.c b/arch/arm/mach-mxs/mach-mx28evk.c
index eacdc6b..56767a5 100644
--- a/arch/arm/mach-mxs/mach-mx28evk.c
+++ b/arch/arm/mach-mxs/mach-mx28evk.c
@@ -26,7 +26,6 @@
 #include <mach/iomux-mx28.h>
 
 #include "devices-mx28.h"
-#include "gpio.h"
 
 #define MX28EVK_FLEXCAN_SWITCH	MXS_GPIO_NR(2, 13)
 #define MX28EVK_FEC_PHY_POWER	MXS_GPIO_NR(2, 15)
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 18c0b31..daaef0f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -93,6 +93,10 @@ config GPIO_EXYNOS4
 	help
 	  Say yes here to support Samsung Exynos4 series SoCs GPIO library
 
+config GPIO_MXS
+	def_bool y
+	depends on ARCH_MXS
+
 config GPIO_PLAT_SAMSUNG
 	bool "Samsung SoCs GPIO library support"
 	default y
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 4ac7cb3..6056249 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_GPIO_BASIC_MMIO_CORE)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_EXYNOS4)	+= gpio-exynos4.o
 obj-$(CONFIG_GPIO_I801)		+= gpio-i801.o
+obj-$(CONFIG_GPIO_MXS)		+= gpio-mxs.o
 obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
 obj-$(CONFIG_GPIO_S5PC100)	+= gpio-s5pc100.o
 obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
diff --git a/arch/arm/mach-mxs/gpio.c b/drivers/gpio/gpio-mxs.c
similarity index 99%
rename from arch/arm/mach-mxs/gpio.c
rename to drivers/gpio/gpio-mxs.c
index 2c950fe..bac7b6b 100644
--- a/arch/arm/mach-mxs/gpio.c
+++ b/drivers/gpio/gpio-mxs.c
@@ -27,10 +27,9 @@
 #include <linux/gpio.h>
 #include <mach/mx23.h>
 #include <mach/mx28.h>
+#include <mach/gpio-mxs.h>
 #include <asm-generic/bug.h>
 
-#include "gpio.h"
-
 static struct mxs_gpio_port *mxs_gpio_ports;
 static int gpio_table_size;
 
-- 
1.7.4.1

