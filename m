Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2CLROY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:14:24 -0400
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:43995 "EHLO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2CLRNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:13:16 -0400
From: Martyn Welch <martyn.welch@ge.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Martyn Welch <martyn.welch@ge.com>
Subject: [PATCH v3 2/4] gpio: Move GE GPIO driver to reside within GPIO subsystem
Date: Mon, 12 Mar 2012 17:12:58 +0000
Message-Id: <1331572380-1064-3-git-send-email-martyn.welch@ge.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GE GPIO driver provides basic support (set direction, read/write state)
for the GPIO provided on some GE single board computers. This patch moves
the driver from the 86xx specific platform directrory to the GPIO subsystem
so that it can be used on non-86xx boards.

Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

v3: Split out from patch moving PIC and GPIO driver. Moving to gpio subsystem
    instead of sysdev.

 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |    1 +
 arch/powerpc/configs/86xx/gef_sbc310_defconfig     |    1 +
 arch/powerpc/configs/86xx/gef_sbc610_defconfig     |    2 ++
 arch/powerpc/platforms/86xx/Makefile               |    3 +--
 drivers/gpio/Kconfig                               |   11 +++++++++++
 drivers/gpio/Makefile                              |    1 +
 .../86xx/gef_gpio.c => drivers/gpio/gpio-ge.c      |    2 +-
 7 files changed, 18 insertions(+), 3 deletions(-)
 rename arch/powerpc/platforms/86xx/gef_gpio.c => drivers/gpio/gpio-ge.c (98%)

diff --git a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
index d41857a..da731c2 100644
--- a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
+++ b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
@@ -131,6 +131,7 @@ CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_MPC=y
 CONFIG_GPIO_SYSFS=y
+CONFIG_GPIO_GE_FPGA=y
 CONFIG_SENSORS_LM90=y
 CONFIG_SENSORS_LM92=y
 CONFIG_WATCHDOG=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc310_defconfig b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
index 38303ec..2149360 100644
--- a/arch/powerpc/configs/86xx/gef_sbc310_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
@@ -132,6 +132,7 @@ CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_MPC=y
 CONFIG_GPIO_SYSFS=y
+CONFIG_GPIO_GE_FPGA=y
 CONFIG_SENSORS_LM90=y
 CONFIG_SENSORS_LM92=y
 CONFIG_WATCHDOG=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc610_defconfig b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
index 9853397..af2e8e1 100644
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -183,6 +183,8 @@ CONFIG_NVRAM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_MPC=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_GPIO_GE_FPGA=y
 CONFIG_SENSORS_LM90=y
 CONFIG_SENSORS_LM92=y
 CONFIG_WATCHDOG=y
diff --git a/arch/powerpc/platforms/86xx/Makefile b/arch/powerpc/platforms/86xx/Makefile
index ac6a50f..1ee6ca8 100644
--- a/arch/powerpc/platforms/86xx/Makefile
+++ b/arch/powerpc/platforms/86xx/Makefile
@@ -7,8 +7,7 @@ obj-$(CONFIG_SMP)		+= mpc86xx_smp.o
 obj-$(CONFIG_MPC8641_HPCN)	+= mpc86xx_hpcn.o
 obj-$(CONFIG_SBC8641D)		+= sbc8641d.o
 obj-$(CONFIG_MPC8610_HPCD)	+= mpc8610_hpcd.o
-gef-gpio-$(CONFIG_GPIOLIB)	+= gef_gpio.o
-obj-$(CONFIG_GE_FPGA)	+= gef_pic.o $(gef-gpio-y)
+obj-$(CONFIG_GE_FPGA)		+= gef_pic.o
 obj-$(CONFIG_GEF_SBC610)	+= gef_sbc610.o
 obj-$(CONFIG_GEF_SBC310)	+= gef_sbc310.o
 obj-$(CONFIG_GEF_PPC9A)		+= gef_ppc9a.o
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d0c4118..0409cf3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -190,6 +190,17 @@ config GPIO_VX855
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+config GPIO_GE_FPGA
+	bool "GE FPGA based GPIO"
+	depends on GE_FPGA
+	help
+	  Support for common GPIO functionality provided on some GE Single Board
+	  Computers.
+
+	  This driver provides basic support (configure as input or output, read
+	  and write pin state) for GPIO implemented in a number of GE single
+	  board computers.
+
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX7300
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index fa10df6..9a8fb54 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
+obj-$(CONFIG_GPIO_GE_FPGA)	+= gpio-ge.o
 obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
 obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
diff --git a/arch/powerpc/platforms/86xx/gef_gpio.c b/drivers/gpio/gpio-ge.c
similarity index 98%
rename from arch/powerpc/platforms/86xx/gef_gpio.c
rename to drivers/gpio/gpio-ge.c
index 2a70336..f8e6289 100644
--- a/arch/powerpc/platforms/86xx/gef_gpio.c
+++ b/drivers/gpio/gpio-ge.c
@@ -14,7 +14,7 @@
  *
  * Configuration of output modes (totem-pole/open-drain)
  * Interrupt configuration - interrupts are always generated the FPGA relies on
- * 	the I/O interrupt controllers mask to stop them propergating
+ * the I/O interrupt controllers mask to stop them propergating
  */
 
 #include <linux/kernel.h>
-- 
1.7.0.4

