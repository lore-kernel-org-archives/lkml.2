Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0LFWQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:16:22 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52725 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab0LFWQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:16:18 -0500
From: David Sin <davidsin@ti.com>
To: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: David Sin <davidsin@ti.com>, Hari Kanigeri <h-kanigeri2@ti.com>
Subject: [PATCH 9/9] TILER-DMM: Device support for OMAP
Date: Mon,  6 Dec 2010 16:27:26 -0600
Message-Id: <1291674446-10766-10-git-send-email-davidsin@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291674446-10766-1-git-send-email-davidsin@ti.com>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DMM device support for OMAP utilizing the
OMAP HWMOD framework.

Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
Signed-off-by: David Sin <davidsin@ti.com>
---
 arch/arm/mach-omap2/Makefile       |    2 +
 arch/arm/mach-omap2/dmm-omap44xx.c |   80 ++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/dmm-omap44xx.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 60e51bc..fc682ea 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -194,3 +194,5 @@ obj-y					+= $(smc91x-m) $(smc91x-y)
 
 smsc911x-$(CONFIG_SMSC911X)		:= gpmc-smsc911x.o
 obj-y					+= $(smsc911x-m) $(smsc911x-y)
+
+obj-$(CONFIG_ARCH_OMAP4)		+= dmm-omap44xx.o
diff --git a/arch/arm/mach-omap2/dmm-omap44xx.c b/arch/arm/mach-omap2/dmm-omap44xx.c
new file mode 100644
index 0000000..a84490c
--- /dev/null
+++ b/arch/arm/mach-omap2/dmm-omap44xx.c
@@ -0,0 +1,80 @@
+/*
+ * DMM driver support functions for TI OMAP processors.
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <mach/dmm.h>
+#include <plat/omap_device.h>
+#include <plat/omap_hwmod.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+
+static struct dmm *plat_data;
+static int pdata;
+
+#ifdef CONFIG_ARCH_OMAP4
+static struct dmm omap4_plat_data[] = {
+	{
+		.oh_name = "dmm",
+	},
+};
+#define NUM_PDATA ARRAY_SIZE(omap4_plat_data)
+#else
+#define omap4_plat_data NULL
+#define NUM_PDATA 0
+#endif
+
+static struct omap_device_pm_latency omap_dmm_latency[] = {
+	[0] = {
+		.deactivate_func = omap_device_idle_hwmods,
+		.activate_func = omap_device_enable_hwmods,
+		.flags = OMAP_DEVICE_LATENCY_AUTO_ADJUST,
+	},
+};
+
+static s32 __init dmm_omap_init(void)
+{
+	struct omap_hwmod *oh = NULL;
+	struct omap_device *od = NULL;
+	struct omap_device_pm_latency *ohl = NULL;
+	int ohlc = 0, i = 0;
+
+	plat_data = omap4_plat_data;
+	pdata = NUM_PDATA;
+
+	for (i = 0; i < pdata; i++) {
+		struct dmm *data = &plat_data[i];
+
+		oh = omap_hwmod_lookup(data->oh_name);
+		if (!oh)
+			goto error;
+
+		data->base = oh->_mpu_rt_va;
+		ohl = omap_dmm_latency;
+		ohlc = ARRAY_SIZE(omap_dmm_latency);
+
+		od = omap_device_build(data->oh_name, i, oh, data,
+					 sizeof(*data), ohl, ohlc, false);
+		if (IS_ERR(od))
+			goto error;
+	}
+	return 0;
+error:
+	return -ENODEV;
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("David Sin <davidsin@ti.com>");
+device_initcall(dmm_omap_init);
-- 
1.7.0.4

