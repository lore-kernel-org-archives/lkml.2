Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2DPXud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:50:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52516 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2DPXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:50:31 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
Date: Mon, 16 Apr 2012 18:50:12 -0500
Message-Id: <1334620214-25803-2-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
References: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add common cpuidle init functionality that can be used by various
imx platforms.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/plat-mxc/Makefile               |    2 +
 arch/arm/plat-mxc/cpuidle.c              |   89 ++++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/cpuidle.h |   26 +++++++++
 3 files changed, 117 insertions(+)
 create mode 100644 arch/arm/plat-mxc/cpuidle.c
 create mode 100644 arch/arm/plat-mxc/include/mach/cpuidle.h

diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
index e81290c..7c9e05f 100644
--- a/arch/arm/plat-mxc/Makefile
+++ b/arch/arm/plat-mxc/Makefile
@@ -16,6 +16,8 @@ obj-$(CONFIG_MXC_ULPI) += ulpi.o
 obj-$(CONFIG_MXC_USE_EPIT) += epit.o
 obj-$(CONFIG_MXC_DEBUG_BOARD) += 3ds_debugboard.o
 obj-$(CONFIG_CPU_FREQ_IMX)    += cpufreq.o
+obj-$(CONFIG_CPU_IDLE)    += cpuidle.o
+
 ifdef CONFIG_SND_IMX_SOC
 obj-y += ssi-fiq.o
 obj-y += ssi-fiq-ksym.o
diff --git a/arch/arm/plat-mxc/cpuidle.c b/arch/arm/plat-mxc/cpuidle.c
new file mode 100644
index 0000000..d1c9301
--- /dev/null
+++ b/arch/arm/plat-mxc/cpuidle.c
@@ -0,0 +1,89 @@
+/*
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2012 Linaro Ltd.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/cpuidle.h>
+#include <linux/hrtimer.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+
+static struct cpuidle_device __percpu * imx_cpuidle_devices;
+static struct cpuidle_driver *drv;
+
+void __init imx_cpuidle_set_driver(struct cpuidle_driver *p)
+{
+	drv = p;
+}
+
+void imx_cpuidle_devices_uninit(void)
+{
+	int cpu_id;
+	struct cpuidle_device *dev;
+
+	for_each_possible_cpu(cpu_id) {
+		dev = per_cpu_ptr(imx_cpuidle_devices, cpu_id);
+		cpuidle_unregister_device(dev);
+	}
+
+	free_percpu(imx_cpuidle_devices);
+}
+
+static int __init imx_cpuidle_init(void)
+{
+	struct cpuidle_device *dev;
+	int cpu_id, ret;
+
+	if (!drv || drv->state_count > CPUIDLE_STATE_MAX) {
+		pr_err("%s: Invalid Input\n", __func__);
+		return -EINVAL;
+	}
+
+	ret = cpuidle_register_driver(drv);
+
+	if (ret) {
+		pr_err("%s: Failed to register cpuidle driver\n", __func__);
+		return ret;
+	}
+
+	imx_cpuidle_devices = alloc_percpu(struct cpuidle_device);
+
+	if (imx_cpuidle_devices == NULL) {
+		ret = -ENOMEM;
+		goto unregister_drv;
+	}
+
+	/* initialize state data for each cpuidle_device */
+	for_each_possible_cpu(cpu_id) {
+		dev = per_cpu_ptr(imx_cpuidle_devices, cpu_id);
+		dev->cpu = cpu_id;
+		dev->state_count = drv->state_count;
+
+		ret = cpuidle_register_device(dev);
+		if (ret) {
+			pr_err("%s: Failed to register cpu %u\n",
+				__func__, cpu_id);
+			goto uninit;
+		}
+	}
+
+	return 0;
+
+uninit:
+	imx_cpuidle_devices_uninit();
+
+unregister_drv:
+	cpuidle_unregister_driver(drv);
+
+	return ret;
+}
+late_initcall(imx_cpuidle_init);
diff --git a/arch/arm/plat-mxc/include/mach/cpuidle.h b/arch/arm/plat-mxc/include/mach/cpuidle.h
new file mode 100644
index 0000000..6509f19
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/cpuidle.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright 2012 Freescale Semiconductor, Inc.
+ * Copyright 2012 Linaro Ltd.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/cpuidle.h>
+
+extern int imx5_cpuidle_init(void);
+extern int imx6q_cpuidle_init(void);
+
+#ifdef CONFIG_CPU_IDLE
+extern void imx_cpuidle_devices_uninit(void);
+extern void imx_cpuidle_set_driver(struct cpuidle_driver *p);
+extern int imx5_cpuidle_init(void);
+extern int imx6q_cpuidle_init(void);
+#else
+static inline void imx_cpuidle_devices_uninit(void) {}
+static inline void imx_cpuidle_set_driver(struct cpuidle_driver *p) {}
+#endif
-- 
1.7.10

