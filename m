Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1FUOjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:39:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37729 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1FUOjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:39:49 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 01/18] OMAP: New twl-common for common TWL configuration
Date: Tue, 21 Jun 2011 16:38:59 +0300
Message-ID: <1308663556-29120-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new file, which will be used to configure
common pmic (TWL) devices, regulators, and TWL audio.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/Makefile               |    2 +-
 arch/arm/mach-omap2/common-board-devices.c |   21 -------------
 arch/arm/mach-omap2/common-board-devices.h |   26 +--------------
 arch/arm/mach-omap2/twl-common.c           |   46 ++++++++++++++++++++++++++++
 arch/arm/mach-omap2/twl-common.h           |   28 +++++++++++++++++
 5 files changed, 77 insertions(+), 46 deletions(-)
 create mode 100644 arch/arm/mach-omap2/twl-common.c
 create mode 100644 arch/arm/mach-omap2/twl-common.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index b148077..fee192e 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -269,4 +269,4 @@ obj-$(CONFIG_ARCH_OMAP4)		+= hwspinlock.o
 disp-$(CONFIG_OMAP2_DSS)		:= display.o
 obj-y					+= $(disp-m) $(disp-y)
 
-obj-y					+= common-board-devices.o
+obj-y					+= common-board-devices.o twl-common.o
diff --git a/arch/arm/mach-omap2/common-board-devices.c b/arch/arm/mach-omap2/common-board-devices.c
index 94ccf46..5e03b2e 100644
--- a/arch/arm/mach-omap2/common-board-devices.c
+++ b/arch/arm/mach-omap2/common-board-devices.c
@@ -20,36 +20,15 @@
  *
  */
 
-#include <linux/i2c.h>
-#include <linux/i2c/twl.h>
-
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
 
-#include <plat/i2c.h>
 #include <plat/mcspi.h>
 #include <plat/nand.h>
 
 #include "common-board-devices.h"
 
-static struct i2c_board_info __initdata pmic_i2c_board_info = {
-	.addr		= 0x48,
-	.flags		= I2C_CLIENT_WAKE,
-};
-
-void __init omap_pmic_init(int bus, u32 clkrate,
-			   const char *pmic_type, int pmic_irq,
-			   struct twl4030_platform_data *pmic_data)
-{
-	strncpy(pmic_i2c_board_info.type, pmic_type,
-		sizeof(pmic_i2c_board_info.type));
-	pmic_i2c_board_info.irq = pmic_irq;
-	pmic_i2c_board_info.platform_data = pmic_data;
-
-	omap_register_i2c_bus(bus, clkrate, &pmic_i2c_board_info, 1);
-}
-
 #if defined(CONFIG_TOUCHSCREEN_ADS7846) || \
 	defined(CONFIG_TOUCHSCREEN_ADS7846_MODULE)
 static struct omap2_mcspi_device_config ads7846_mcspi_config = {
diff --git a/arch/arm/mach-omap2/common-board-devices.h b/arch/arm/mach-omap2/common-board-devices.h
index 6797190..a0b4a428 100644
--- a/arch/arm/mach-omap2/common-board-devices.h
+++ b/arch/arm/mach-omap2/common-board-devices.h
@@ -1,33 +1,11 @@
 #ifndef __OMAP_COMMON_BOARD_DEVICES__
 #define __OMAP_COMMON_BOARD_DEVICES__
 
+#include "twl-common.h"
+
 #define NAND_BLOCK_SIZE	SZ_128K
 
-struct twl4030_platform_data;
 struct mtd_partition;
-
-void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int pmic_irq,
-		    struct twl4030_platform_data *pmic_data);
-
-static inline void omap2_pmic_init(const char *pmic_type,
-				   struct twl4030_platform_data *pmic_data)
-{
-	omap_pmic_init(2, 2600, pmic_type, INT_24XX_SYS_NIRQ, pmic_data);
-}
-
-static inline void omap3_pmic_init(const char *pmic_type,
-				   struct twl4030_platform_data *pmic_data)
-{
-	omap_pmic_init(1, 2600, pmic_type, INT_34XX_SYS_NIRQ, pmic_data);
-}
-
-static inline void omap4_pmic_init(const char *pmic_type,
-				   struct twl4030_platform_data *pmic_data)
-{
-	/* Phoenix Audio IC needs I2C1 to start with 400 KHz or less */
-	omap_pmic_init(1, 400, pmic_type, OMAP44XX_IRQ_SYS_1N, pmic_data);
-}
-
 struct ads7846_platform_data;
 
 void omap_ads7846_init(int bus_num, int gpio_pendown, int gpio_debounce,
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
new file mode 100644
index 0000000..4f7b24c
--- /dev/null
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -0,0 +1,46 @@
+/*
+ * twl-common.c
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc..
+ * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/i2c.h>
+#include <linux/i2c/twl.h>
+#include <linux/gpio.h>
+
+#include <plat/i2c.h>
+
+#include "twl-common.h"
+
+static struct i2c_board_info __initdata pmic_i2c_board_info = {
+	.addr		= 0x48,
+	.flags		= I2C_CLIENT_WAKE,
+};
+
+void __init omap_pmic_init(int bus, u32 clkrate,
+			   const char *pmic_type, int pmic_irq,
+			   struct twl4030_platform_data *pmic_data)
+{
+	strncpy(pmic_i2c_board_info.type, pmic_type,
+		sizeof(pmic_i2c_board_info.type));
+	pmic_i2c_board_info.irq = pmic_irq;
+	pmic_i2c_board_info.platform_data = pmic_data;
+
+	omap_register_i2c_bus(bus, clkrate, &pmic_i2c_board_info, 1);
+}
diff --git a/arch/arm/mach-omap2/twl-common.h b/arch/arm/mach-omap2/twl-common.h
new file mode 100644
index 0000000..e9fe2ab
--- /dev/null
+++ b/arch/arm/mach-omap2/twl-common.h
@@ -0,0 +1,28 @@
+#ifndef __OMAP_PMIC_COMMON__
+#define __OMAP_PMIC_COMMON__
+
+struct twl4030_platform_data;
+
+void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int pmic_irq,
+		    struct twl4030_platform_data *pmic_data);
+
+static inline void omap2_pmic_init(const char *pmic_type,
+				   struct twl4030_platform_data *pmic_data)
+{
+	omap_pmic_init(2, 2600, pmic_type, INT_24XX_SYS_NIRQ, pmic_data);
+}
+
+static inline void omap3_pmic_init(const char *pmic_type,
+				   struct twl4030_platform_data *pmic_data)
+{
+	omap_pmic_init(1, 2600, pmic_type, INT_34XX_SYS_NIRQ, pmic_data);
+}
+
+static inline void omap4_pmic_init(const char *pmic_type,
+				   struct twl4030_platform_data *pmic_data)
+{
+	/* Phoenix Audio IC needs I2C1 to start with 400 KHz or less */
+	omap_pmic_init(1, 400, pmic_type, OMAP44XX_IRQ_SYS_1N, pmic_data);
+}
+
+#endif /* __OMAP_PMIC_COMMON__ */
-- 
1.7.5.3

