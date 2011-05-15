Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1EOXiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:38:13 -0400
Received: from mail.df.lth.se ([194.47.250.12]:23000 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab1EOXiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:38:09 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/13] mach-ux500: move the DB8500 PRCMU driver to MFD
Date: Mon, 16 May 2011 01:38:06 +0200
Message-Id: <1305502686-32646-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have decided that this function arbiter fits better in the MFD
subsystem. Since we need to concatenate the split header files we move
it basically like this:

mv mach-ux500/prcmu-db8500.c drivers/mfd/db8500-prcmu.c
mv mach-ux500/include/mach/prcmu-defs.h include/linux/mfd/db8500-prcmu.h
mv mach-ux500/include/mach/prcmu-regs.h drivers/mfd/db8500-prcmu-regs.h
mach-ux500/include/mach/prcmu.h >> include/linux/mfd/db8500-prcmu.h
rm arch/arm/mach-ux500/include/mach/prcmu.h

Then we update different #include statements and Makefile orders etc
to make the PRCMU driver compile, link and boot in the new place
without really changing any code.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/Kconfig                        |    1 +
 arch/arm/mach-ux500/Makefile                       |    2 +-
 arch/arm/mach-ux500/cpu.c                          |    2 +-
 arch/arm/mach-ux500/cpufreq.c                      |    3 +-
 arch/arm/mach-ux500/include/mach/prcmu-defs.h      |   30 -----------------
 drivers/mfd/Kconfig                                |   12 ++++++-
 drivers/mfd/Makefile                               |    4 ++-
 drivers/mfd/ab8500-i2c.c                           |    3 +-
 .../mfd/db8500-prcmu-regs.h                        |    0
 .../prcmu-db8500.c => drivers/mfd/db8500-prcmu.c   |    5 ++-
 .../prcmu.h => include/linux/mfd/db8500-prcmu.h    |   34 ++++++++++++++++++-
 11 files changed, 54 insertions(+), 42 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/include/mach/prcmu-defs.h
 rename arch/arm/mach-ux500/include/mach/prcmu-regs.h => drivers/mfd/db8500-prcmu-regs.h (100%)
 rename arch/arm/mach-ux500/prcmu-db8500.c => drivers/mfd/db8500-prcmu.c (99%)
 rename arch/arm/mach-ux500/include/mach/prcmu.h => include/linux/mfd/db8500-prcmu.h (54%)

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 5862601..8071d27 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -15,6 +15,7 @@ config UX500_SOC_DB5500
 
 config UX500_SOC_DB8500
 	bool "DB8500"
+	select MFD_DB8500_PRCMU
 
 endmenu
 
diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 2a08a10..7a1d43e 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -5,7 +5,7 @@
 obj-y				:= clock.o cpu.o devices.o devices-common.o \
 				   id.o usb.o
 obj-$(CONFIG_UX500_SOC_DB5500)	+= cpu-db5500.o dma-db5500.o
-obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o prcmu-db8500.o
+obj-$(CONFIG_UX500_SOC_DB8500)	+= cpu-db8500.o devices-db8500.o
 obj-$(CONFIG_MACH_U8500)	+= board-mop500.o board-mop500-sdi.o \
 				board-mop500-regulators.o \
 				board-mop500-uib.o board-mop500-stuib.o \
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 0190e0e..11360f7 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -8,6 +8,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/mfd/db8500-prcmu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -19,7 +20,6 @@
 #include <mach/hardware.h>
 #include <mach/setup.h>
 #include <mach/devices.h>
-#include <mach/prcmu.h>
 
 #include "clock.h"
 
diff --git a/arch/arm/mach-ux500/cpufreq.c b/arch/arm/mach-ux500/cpufreq.c
index 5c5b747..d196939 100644
--- a/arch/arm/mach-ux500/cpufreq.c
+++ b/arch/arm/mach-ux500/cpufreq.c
@@ -17,10 +17,9 @@
 #include <linux/kernel.h>
 #include <linux/cpufreq.h>
 #include <linux/delay.h>
+#include <linux/mfd/db8500-prcmu.h>
 
 #include <mach/hardware.h>
-#include <mach/prcmu.h>
-#include <mach/prcmu-defs.h>
 
 #define DRIVER_NAME "cpufreq-u8500"
 #define CPUFREQ_NAME "u8500"
diff --git a/arch/arm/mach-ux500/include/mach/prcmu-defs.h b/arch/arm/mach-ux500/include/mach/prcmu-defs.h
deleted file mode 100644
index 848ba64..0000000
--- a/arch/arm/mach-ux500/include/mach/prcmu-defs.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (C) STMicroelectronics 2009
- * Copyright (C) ST-Ericsson SA 2010
- *
- * Author: Sundar Iyer <sundar.iyer@stericsson.com>
- * Author: Martin Persson <martin.persson@stericsson.com>
- *
- * License Terms: GNU General Public License v2
- *
- * PRCM Unit definitions
- */
-
-#ifndef __MACH_PRCMU_DEFS_H
-#define __MACH_PRCMU_DEFS_H
-
-enum prcmu_cpu_opp {
-	CPU_OPP_INIT	  = 0x00,
-	CPU_OPP_NO_CHANGE = 0x01,
-	CPU_OPP_100	  = 0x02,
-	CPU_OPP_50	  = 0x03,
-	CPU_OPP_MAX	  = 0x04,
-	CPU_OPP_EXT_CLK	  = 0x07
-};
-enum prcmu_ape_opp {
-	APE_OPP_NO_CHANGE = 0x00,
-	APE_OPP_100	  = 0x02,
-	APE_OPP_50	  = 0x03,
-};
-
-#endif /* __MACH_PRCMU_DEFS_H */
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3ed3ff0..7eaeb97 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -538,7 +538,7 @@ config AB8500_CORE
 
 config AB8500_I2C_CORE
 	bool "AB8500 register access via PRCMU I2C"
-	depends on AB8500_CORE && UX500_SOC_DB8500
+	depends on AB8500_CORE && MFD_DB8500_PRCMU
 	default y
 	help
 	  This enables register access to the AB8500 chip via PRCMU I2C.
@@ -575,6 +575,16 @@ config AB3550_CORE
 	  LEDs, vibrator, system power and temperature, power management
 	  and ALSA sound.
 
+config MFD_DB8500_PRCMU
+	bool "ST-Ericsson DB8500 Power Reset Control Management Unit"
+	depends on UX500_SOC_DB8500
+	select MFD_CORE
+	help
+	  Select this option to enable support for the DB8500 Power Reset
+	  and Control Management Unit. This is basically an autonomous
+	  system controller running an XP70 microprocessor, which is accessed
+	  through a register map.
+
 config MFD_CS5535
 	tristate "Support for CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 419caa9..814c57a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -74,9 +74,11 @@ obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
 obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB3550_CORE)	+= ab3550-core.o
 obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-sysctrl.o
-obj-$(CONFIG_AB8500_I2C_CORE)	+= ab8500-i2c.o
 obj-$(CONFIG_AB8500_DEBUG)	+= ab8500-debugfs.o
 obj-$(CONFIG_AB8500_GPADC)	+= ab8500-gpadc.o
+obj-$(CONFIG_MFD_DB8500_PRCMU)	+= db8500-prcmu.o
+# ab8500-i2c need to come after db8500-prcmu (which provides the channel)
+obj-$(CONFIG_AB8500_I2C_CORE)	+= ab8500-i2c.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
diff --git a/drivers/mfd/ab8500-i2c.c b/drivers/mfd/ab8500-i2c.c
index 821e6b8..9be541c 100644
--- a/drivers/mfd/ab8500-i2c.c
+++ b/drivers/mfd/ab8500-i2c.c
@@ -11,8 +11,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/ab8500.h>
-
-#include <mach/prcmu.h>
+#include <linux/mfd/db8500-prcmu.h>
 
 static int ab8500_i2c_write(struct ab8500 *ab8500, u16 addr, u8 data)
 {
diff --git a/arch/arm/mach-ux500/include/mach/prcmu-regs.h b/drivers/mfd/db8500-prcmu-regs.h
similarity index 100%
rename from arch/arm/mach-ux500/include/mach/prcmu-regs.h
rename to drivers/mfd/db8500-prcmu-regs.h
diff --git a/arch/arm/mach-ux500/prcmu-db8500.c b/drivers/mfd/db8500-prcmu.c
similarity index 99%
rename from arch/arm/mach-ux500/prcmu-db8500.c
rename to drivers/mfd/db8500-prcmu.c
index c522d26..31f18c8 100644
--- a/arch/arm/mach-ux500/prcmu-db8500.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -20,10 +20,11 @@
 #include <linux/jiffies.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
+#include <linux/mfd/db8500-prcmu.h>
 
 #include <mach/hardware.h>
-#include <mach/prcmu-regs.h>
-#include <mach/prcmu-defs.h>
+
+#include "db8500-prcmu-regs.h"
 
 /* Global var to runtime determine TCDM base for v2 or v1 */
 static __iomem void *tcdm_base;
diff --git a/arch/arm/mach-ux500/include/mach/prcmu.h b/include/linux/mfd/db8500-prcmu.h
similarity index 54%
rename from arch/arm/mach-ux500/include/mach/prcmu.h
rename to include/linux/mfd/db8500-prcmu.h
index c49e456..d591d79 100644
--- a/arch/arm/mach-ux500/include/mach/prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -2,6 +2,37 @@
  * Copyright (C) STMicroelectronics 2009
  * Copyright (C) ST-Ericsson SA 2010
  *
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ * Author: Martin Persson <martin.persson@stericsson.com>
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * PRCM Unit definitions
+ */
+
+#ifndef __MACH_PRCMU_DEFS_H
+#define __MACH_PRCMU_DEFS_H
+
+enum prcmu_cpu_opp {
+	CPU_OPP_INIT	  = 0x00,
+	CPU_OPP_NO_CHANGE = 0x01,
+	CPU_OPP_100	  = 0x02,
+	CPU_OPP_50	  = 0x03,
+	CPU_OPP_MAX	  = 0x04,
+	CPU_OPP_EXT_CLK	  = 0x07
+};
+enum prcmu_ape_opp {
+	APE_OPP_NO_CHANGE = 0x00,
+	APE_OPP_100	  = 0x02,
+	APE_OPP_50	  = 0x03,
+};
+
+#endif /* __MACH_PRCMU_DEFS_H */
+
+/*
+ * Copyright (C) STMicroelectronics 2009
+ * Copyright (C) ST-Ericsson SA 2010
+ *
  * Author: Kumar Sanghvi <kumar.sanghvi@stericsson.com>
  * Author: Sundar Iyer <sundar.iyer@stericsson.com>
  * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
@@ -12,7 +43,6 @@
  */
 #ifndef __MACH_PRCMU_H
 #define __MACH_PRCMU_H
-#include <mach/prcmu-defs.h>
 
 void __init prcmu_early_init(void);
 int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
@@ -21,7 +51,7 @@ int prcmu_set_ape_opp(enum prcmu_ape_opp opp);
 int prcmu_set_cpu_opp(enum prcmu_cpu_opp opp);
 int prcmu_set_ape_cpu_opps(enum prcmu_ape_opp ape_opp,
 			   enum prcmu_cpu_opp cpu_opp);
-int prcmu_get_ape_opp(void);
+enum prcmu_ape_opp prcmu_get_ape_opp(void);
 int prcmu_get_cpu_opp(void);
 bool prcmu_has_arm_maxopp(void);
 
-- 
1.7.4.4

