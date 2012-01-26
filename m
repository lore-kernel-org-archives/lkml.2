Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2AZQWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:22:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15672 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab2AZQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:22:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 26 Jan 2012 08:22:32 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/3] ARM: tegra: cpuidle driver for tegra
Date: Thu, 26 Jan 2012 18:22:03 +0200
Message-Id: <1327594923-21822-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUidle driver for tegra. In this version only LP3 (clockgating) is supported.

Based on work by:

Colin Cross <ccross@android.com>
Gary King <gking@nvidia.com>

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Makefile  |    2 +
 arch/arm/mach-tegra/cpuidle.c |  107 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/cpuidle.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index b78bda8..c06c280 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -6,6 +6,8 @@ obj-y                                   += irq.o
 obj-y                                   += clock.o
 obj-y                                   += timer.o
 obj-y					+= fuse.o
+obj-y					+= cpuidle.o
+obj-y					+= sleep.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= powergate.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
diff --git a/arch/arm/mach-tegra/cpuidle.c b/arch/arm/mach-tegra/cpuidle.c
new file mode 100644
index 0000000..d83a8c0
--- /dev/null
+++ b/arch/arm/mach-tegra/cpuidle.c
@@ -0,0 +1,107 @@
+/*
+ * arch/arm/mach-tegra/cpuidle.c
+ *
+ * CPU idle driver for Tegra CPUs
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ * Copyright (c) 2011 Google, Inc.
+ * Author: Colin Cross <ccross@android.com>
+ *         Gary King <gking@nvidia.com>
+ *
+ * Rework for 3.3 by Peter De Schrijver <pdeschrijver@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/cpu.h>
+#include <linux/cpuidle.h>
+#include <linux/hrtimer.h>
+
+#include <mach/iomap.h>
+
+extern void tegra_cpu_wfi(void);
+
+static int tegra_idle_enter_lp3(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv, int index);
+
+struct cpuidle_driver tegra_idle_driver = {
+	.name = "tegra_idle",
+	.owner = THIS_MODULE,
+	.state_count = 1,
+	.states = {
+		[0] = {
+			.enter			= tegra_idle_enter_lp3,
+			.exit_latency		= 10,
+			.target_residency	= 10,
+			.power_usage		= 600,
+			.flags			= CPUIDLE_FLAG_TIME_VALID,
+			.name			= "LP3",
+			.desc			= "CPU flow-controlled",
+		},
+	},
+};
+
+static DEFINE_PER_CPU(struct cpuidle_device, tegra_idle_device);
+
+static int tegra_idle_enter_lp3(struct cpuidle_device *dev,
+	struct cpuidle_driver *drv, int index)
+{
+	ktime_t enter, exit;
+	s64 us;
+
+	local_irq_disable();
+	local_fiq_disable();
+
+	enter = ktime_get();
+
+	tegra_cpu_wfi();
+
+	exit = ktime_sub(ktime_get(), enter);
+	us = ktime_to_us(exit);
+
+	local_fiq_enable();
+	local_irq_enable();
+
+	dev->last_residency = us;
+
+	return index;
+}
+
+static int __init tegra_cpuidle_init(void)
+{
+	int ret;
+	unsigned int cpu;
+	struct cpuidle_device *dev;
+	struct cpuidle_driver *drv = &tegra_idle_driver;
+
+	ret = cpuidle_register_driver(&tegra_idle_driver);
+	if (ret) {
+		pr_err("CPUidle driver registration failed\n");
+		return ret;
+	}
+
+	for_each_possible_cpu(cpu) {
+		dev = &per_cpu(tegra_idle_device, cpu);
+		dev->cpu = cpu;
+
+		dev->state_count = drv->state_count;
+		ret = cpuidle_register_device(dev);
+		if (ret) {
+			pr_err("CPU%u: CPUidle device registration failed\n",
+				cpu);
+			return ret;
+		}
+	}
+	return 0;
+}
+device_initcall(tegra_cpuidle_init);
-- 
1.7.7.rc0.72.g4b5ea.dirty

