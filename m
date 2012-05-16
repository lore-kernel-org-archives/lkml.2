Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab2EPCd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:33:56 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47039 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759012Ab2EPCdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:33:52 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, u.kleine-koenig@pengutronix.de,
        richard.zhao@freescale.com, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v4 5/7] ARM: imx: Add common imx cpuidle init functionality.
Date: Tue, 15 May 2012 21:33:34 -0500
Message-Id: <1337135616-8988-6-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add common cpuidle init functionality that can be used by various
imx platforms.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/plat-mxc/Makefile               |    1 +
 arch/arm/plat-mxc/cpuidle.c              |   80 ++++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/cpuidle.h |   22 ++++++++
 3 files changed, 103 insertions(+)
 create mode 100644 arch/arm/plat-mxc/cpuidle.c
 create mode 100644 arch/arm/plat-mxc/include/mach/cpuidle.h

diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
index e81290c..63b064b 100644
--- a/arch/arm/plat-mxc/Makefile
+++ b/arch/arm/plat-mxc/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_MXC_ULPI) += ulpi.o
 obj-$(CONFIG_MXC_USE_EPIT) += epit.o
 obj-$(CONFIG_MXC_DEBUG_BOARD) += 3ds_debugboard.o
 obj-$(CONFIG_CPU_FREQ_IMX)    += cpufreq.o
+obj-$(CONFIG_CPU_IDLE) += cpuidle.o
 ifdef CONFIG_SND_IMX_SOC
 obj-y += ssi-fiq.o
 obj-y += ssi-fiq-ksym.o
diff --git a/arch/arm/plat-mxc/cpuidle.c b/arch/arm/plat-mxc/cpuidle.c
new file mode 100644
index 0000000..d4cb511
--- /dev/null
+++ b/arch/arm/plat-mxc/cpuidle.c
@@ -0,0 +1,80 @@
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
+#include <linux/err.h>
+#include <linux/hrtimer.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+static struct cpuidle_device __percpu * imx_cpuidle_devices;
+
+static void __init imx_cpuidle_devices_uninit(void)
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
+int __init imx_cpuidle_init(struct cpuidle_driver *drv)
+{
+	struct cpuidle_device *dev;
+	int cpu_id, ret;
+
+	if (drv->state_count > CPUIDLE_STATE_MAX) {
+		pr_err("%s: state_count exceeds maximum\n", __func__);
+		return -EINVAL;
+	}
+
+	ret = cpuidle_register_driver(drv);
+	if (ret) {
+		pr_err("%s: Failed to register cpuidle driver with error: %d\n",
+			 __func__, ret);
+		return ret;
+	}
+
+	imx_cpuidle_devices = alloc_percpu(struct cpuidle_device);
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
+			pr_err("%s: Failed to register cpu %u, error: %d\n",
+				__func__, cpu_id, ret);
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
+	return ret;
+}
diff --git a/arch/arm/plat-mxc/include/mach/cpuidle.h b/arch/arm/plat-mxc/include/mach/cpuidle.h
new file mode 100644
index 0000000..bc932d1
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/cpuidle.h
@@ -0,0 +1,22 @@
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
+#ifdef CONFIG_CPU_IDLE
+extern int imx_cpuidle_init(struct cpuidle_driver *drv);
+#else
+static inline int imx_cpuidle_init(struct cpuidle_driver *drv)
+{
+	return -ENODEV;
+}
+#endif
-- 
1.7.10

