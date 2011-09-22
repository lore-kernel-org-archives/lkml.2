Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1IVNaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:30:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46598 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab1IVN3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:29:45 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        <sameo@linux.intel.com>, <santosh.shilimkar@ti.com>, <premi@ti.com>,
        <david.woodhouse@intel.com>, <christian.gmeiner@gmail.com>,
        Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH v3 2/3] OMAP3: Add support for TPS65023 (AM35x only)
Date: Thu, 22 Sep 2011 18:59:14 +0530
Message-ID: <1316698155-954-3-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1316698155-954-2-git-send-email-abhilash.kv@ti.com>
References: <1316698155-954-1-git-send-email-abhilash.kv@ti.com>
 <1316698155-954-2-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sanjeev Premi <premi@ti.com>

This patch adds support for TPS65023 used with
OMAP3 devices. The PMIC is currently hooked to
AM35x devices, but can easily be extended for
other OMAP3 devices.

Signed-off-by: Sanjeev Premi <premi@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/Makefile        |    3 +-
 arch/arm/mach-omap2/pm.c            |    1 +
 arch/arm/mach-omap2/pm.h            |    9 ++++
 arch/arm/mach-omap2/pmic_tps65023.c |   84 +++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-omap2/pmic_tps65023.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 46a3497..e71e4bc 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -18,7 +18,8 @@ obj-$(CONFIG_ARCH_OMAP4) += prm44xx.o $(hwmod-common)
 
 obj-$(CONFIG_OMAP_MCBSP) += mcbsp.o
 
-obj-$(CONFIG_TWL4030_CORE) += omap_twl.o
+obj-$(CONFIG_TWL4030_CORE)		+= omap_twl.o
+obj-$(CONFIG_REGULATOR_TPS65023)	+= pmic_tps65023.o
 
 # SMP support ONLY available for OMAP4
 obj-$(CONFIG_SMP)			+= omap-smp.o omap-headsmp.o
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index da71abc..bb64383 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -255,6 +255,7 @@ static int __init omap2_common_pm_late_init(void)
 	if (omap3_has_sr())
 		omap3_twl_init();
 	omap4_twl_init();
+	omap3_tps65023_init();
 
 	/* Init the voltage layer */
 	omap_voltage_late_init();
diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
index 4e166ad..ce028f6 100644
--- a/arch/arm/mach-omap2/pm.h
+++ b/arch/arm/mach-omap2/pm.h
@@ -133,5 +133,14 @@ static inline int omap4_twl_init(void)
 	return -EINVAL;
 }
 #endif
+#ifdef CONFIG_REGULATOR_TPS65023
+extern int omap3_tps65023_init(void);
+#else
+static inline int omap3_tps65023_init(void)
+{
+	return -EINVAL;
+}
+#endif
+
 
 #endif
diff --git a/arch/arm/mach-omap2/pmic_tps65023.c b/arch/arm/mach-omap2/pmic_tps65023.c
new file mode 100644
index 0000000..415d804
--- /dev/null
+++ b/arch/arm/mach-omap2/pmic_tps65023.c
@@ -0,0 +1,84 @@
+/**
+ * Implements support for TPS65023
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/i2c/twl.h>
+
+#include "voltage.h"
+
+#include "pm.h"
+
+#define	TPS65023_VDCDC1_MIN		800000	/* 0.8V		*/
+#define	TPS65023_VDCDC1_STEP		25000	/* 0.025V	*/
+
+
+/*
+ * Get voltage corresponding to specified vsel value using this formula:
+ *	Vout = 0.8V + (25mV x Vsel)
+ */
+static unsigned long tps65023_vsel_to_uv(const u8 vsel)
+{
+	return TPS65023_VDCDC1_MIN + (TPS65023_VDCDC1_STEP * vsel);
+}
+
+/*
+ * Get vsel value corresponding to specified voltage using this formula:
+ *	Vsel = (Vout - 0.8V)/ 25mV
+ */
+static u8 tps65023_uv_to_vsel(unsigned long uv)
+{
+	return DIV_ROUND_UP(uv - TPS65023_VDCDC1_MIN, TPS65023_VDCDC1_STEP);
+}
+
+/*
+ * TPS65023 is currently supported only for AM35x devices.
+ * Therefore, implementation below is specific to this device pair.
+ */
+
+/**
+ * Voltage information related to the MPU voltage domain of the
+ * AM35x processors - in relation to the TPS65023.
+ */
+static struct omap_voltdm_pmic tps65023_am35xx_mpu_volt_info = {
+	.step_size		= 25000,
+	.on_volt                = 1200000,
+	.vsel_to_uv		= tps65023_vsel_to_uv,
+	.uv_to_vsel		= tps65023_uv_to_vsel,
+};
+
+int __init omap3_tps65023_init(void)
+{
+	struct voltagedomain *voltdm;
+
+	if (!cpu_is_omap34xx())
+		return -ENODEV;
+
+	if (cpu_is_omap3505() || cpu_is_omap3517()) {
+		voltdm = voltdm_lookup("mpu");
+		omap_voltage_register_pmic(voltdm,
+					&tps65023_am35xx_mpu_volt_info);
+		voltdm = voltdm_lookup("core");
+		omap_voltage_register_pmic(voltdm,
+					&tps65023_am35xx_mpu_volt_info);
+	} else {
+		/* TODO:
+		 * Support for other devices that support TPS65023
+		 */
+	}
+
+	return 0;
+}
-- 
1.7.1

