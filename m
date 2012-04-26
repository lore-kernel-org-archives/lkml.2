Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2DZRlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:41:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40734 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523Ab2DZRll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:41:41 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <khilman@ti.com>, <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
CC: <j-pihet@ti.com>, <j-keerthy@ti.com>
Subject: [PATCH V3 10/10] ARM: OMAP: SmartReflex: Move smartreflex driver to drivers/
Date: Thu, 26 Apr 2012 23:10:41 +0530
Message-ID: <1335462041-4949-11-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com> 

After a clean-up of the interfaces the OMAP Smartreflex IP driver is now a
generic driver. Move it to drivers/power/avs/.

The build is controlled by the following Kconfig options:
 . CONFIG_POWER_AVS: general knob for Adaptive Voltage Scaling support,
 . CONFIG_POWER_AVS_OMAP: AVS(Adaptive Voltage Scaling)
   support on OMAP containing the version 1 or version 2 of the SmartReflex IP,
 . CONFIG_POWER_AVS_OMAP_CLASS3: Class 3 implementation of Smartreflex.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/mach-omap2/Makefile                       |    4 +-
 arch/arm/plat-omap/Kconfig                         |   22 ++-----------------
 drivers/power/Kconfig                              |    2 +
 drivers/power/Makefile                             |    1 +
 drivers/power/avs/Kconfig                          |   12 ++++++++++
 drivers/power/avs/Makefile                         |    1 +
 .../mach-omap2 => drivers/power/avs}/smartreflex.c |    5 +---
 7 files changed, 22 insertions(+), 25 deletions(-)
 create mode 100644 drivers/power/avs/Kconfig
 create mode 100644 drivers/power/avs/Makefile
 rename {arch/arm/mach-omap2 => drivers/power/avs}/smartreflex.c (99%)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 85ca797..43ffde4 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -70,8 +70,8 @@ obj-$(CONFIG_ARCH_OMAP4)		+= pm44xx.o omap-mpuss-lowpower.o \
 					   cpuidle44xx.o
 obj-$(CONFIG_PM_DEBUG)			+= pm-debug.o
 
-obj-$(CONFIG_POWER_AVS_OMAP)		+= sr_device.o smartreflex.o
-obj-$(CONFIG_POWER_AVS_OMAP_CLASS3)	+= smartreflex-class3.o
+obj-$(CONFIG_POWER_AVS_OMAP)		+= sr_device.o
+obj-$(CONFIG_POWER_AVS_OMAP_CLASS3)    += smartreflex-class3.o
 
 AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
 AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a$(plus_sec)
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index bba384d..816dec0 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -45,26 +45,12 @@ config OMAP_DEBUG_LEDS
 	depends on OMAP_DEBUG_DEVICES
 	default y if LEDS_CLASS
 
-menuconfig POWER_AVS
-	tristate "Adaptive Voltage Scaling class support"
-	help
-	  AVS(Adaptive Voltage Scaling) is a power management technique which
-	  finely controls the operating voltage of a device in order to optimize
-	   (i.e. reduce) its power consumption.
-	  At a given operating point the voltage is adapted depending on
-	  static factors (chip manufacturing process) and dynamic factors
-	  (temperature depending performance).
-	  AVS is also called SmartReflex on OMAP devices.
-
-	  Say Y here to enable Adaptive Voltage Scaling class support.
-
-if POWER_AVS
-
 config POWER_AVS_OMAP
 	bool "AVS(Adaptive Voltage Scaling) support for OMAP IP versions 1&2"
-	depends on (ARCH_OMAP3 || ARCH_OMAP4) && PM
+	depends on POWER_AVS && (ARCH_OMAP3 || ARCH_OMAP4) && PM
 	help
-	  Say Y to enable AVS support on OMAP containing the version 1 or
+	  Say Y to enable AVS(Adaptive Voltage Scaling)
+	  support on OMAP containing the version 1 or
 	  version 2 of the SmartReflex IP.
 	  V1 is the 65nm version used in OMAP3430.
 	  V2 is the update for the 45nm version of the IP used in OMAP3630
@@ -89,8 +75,6 @@ config POWER_AVS_OMAP_CLASS3
 	  Class 3 implementation of Smartreflex employs continuous hardware
 	  voltage calibration.
 
-endif # POWER_AVS
-
 config OMAP_RESET_CLOCKS
 	bool "Reset unused clocks during boot"
 	depends on ARCH_OMAP
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 99dc29f..d416773 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -308,3 +308,5 @@ config AB8500_BATTERY_THERM_ON_BATCTRL
 	  Say Y to enable battery temperature measurements using
 	  thermistor connected on BATCTRL ADC.
 endif # POWER_SUPPLY
+
+source "drivers/power/avs/Kconfig"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b6b2434..ee58afb 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -43,4 +43,5 @@ obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
 obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
+obj-$(CONFIG_POWER_AVS)		+= avs/
 obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
diff --git a/drivers/power/avs/Kconfig b/drivers/power/avs/Kconfig
new file mode 100644
index 0000000..18493f7
--- /dev/null
+++ b/drivers/power/avs/Kconfig
@@ -0,0 +1,12 @@
+menuconfig POWER_AVS
+	tristate "Adaptive Voltage Scaling class support"
+	help
+	  AVS is a power management technique which finely controls the
+	  operating voltage of a device in order to optimize (i.e. reduce)
+	  its power consumption.
+	  At a given operating point the voltage is adapted depending on
+	  static factors (chip manufacturing process) and dynamic factors
+	  (temperature depending performance).
+	  AVS is also called SmartReflex on OMAP devices.
+
+	  Say Y here to enable Adaptive Voltage Scaling class support.
diff --git a/drivers/power/avs/Makefile b/drivers/power/avs/Makefile
new file mode 100644
index 0000000..0843386
--- /dev/null
+++ b/drivers/power/avs/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_POWER_AVS_OMAP)		+= smartreflex.o
diff --git a/arch/arm/mach-omap2/smartreflex.c b/drivers/power/avs/smartreflex.c
similarity index 99%
rename from arch/arm/mach-omap2/smartreflex.c
rename to drivers/power/avs/smartreflex.c
index 515041c..44efc6e 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -3,7 +3,7 @@
  *
  * Author: Thara Gopinath	<thara@ti.com>
  *
- * Copyright (C) 2010 Texas Instruments, Inc.
+ * Copyright (C) 2012 Texas Instruments, Inc.
  * Thara Gopinath <thara@ti.com>
  *
  * Copyright (C) 2008 Nokia Corporation
@@ -27,9 +27,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/power/smartreflex.h>
 
-#include "common.h"
-#include "pm.h"
-
 #define SMARTREFLEX_NAME_LEN	16
 #define NVALUE_NAME_LEN		40
 #define SR_DISABLE_TIMEOUT	200
-- 
1.7.5.4

