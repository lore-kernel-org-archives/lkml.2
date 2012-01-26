Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2AZRIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:08:18 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2765 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2AZRIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:08:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jan 2012 09:07:55 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/8] ARM: tegra: functions to access the flowcontroller
Date: Thu, 26 Jan 2012 19:07:07 +0200
Message-Id: <1327597641-7519-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce some functions to write to the flowcontroller registers.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Makefile   |    1 +
 arch/arm/mach-tegra/flowctrl.c |   62 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/flowctrl.h |    5 +++
 3 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/flowctrl.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index b78bda8..60c286e 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -6,6 +6,7 @@ obj-y                                   += irq.o
 obj-y                                   += clock.o
 obj-y                                   += timer.o
 obj-y					+= fuse.o
+obj-y					+= flowctrl.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= powergate.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
diff --git a/arch/arm/mach-tegra/flowctrl.c b/arch/arm/mach-tegra/flowctrl.c
new file mode 100644
index 0000000..fef66a7
--- /dev/null
+++ b/arch/arm/mach-tegra/flowctrl.c
@@ -0,0 +1,62 @@
+/*
+ * arch/arm/mach-tegra/flowctrl.c
+ *
+ * functions and macros to control the flowcontroller
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+
+#include <mach/iomap.h>
+
+#include "flowctrl.h"
+
+u8 flowctrl_offset_halt_cpu[] = {
+	FLOW_CTRL_HALT_CPU0_EVENTS,
+	FLOW_CTRL_HALT_CPU1_EVENTS,
+	FLOW_CTRL_HALT_CPU1_EVENTS + 8,
+	FLOW_CTRL_HALT_CPU1_EVENTS + 16,
+};
+
+u8 flowctrl_offset_cpu_csr[] = {
+	FLOW_CTRL_CPU0_CSR,
+	FLOW_CTRL_CPU1_CSR,
+	FLOW_CTRL_CPU1_CSR + 8,
+	FLOW_CTRL_CPU1_CSR + 16,
+};
+
+static void flowctrl_update(u8 offset, u32 value)
+{
+	void __iomem *addr = IO_ADDRESS(TEGRA_FLOW_CTRL_BASE) + offset;
+
+	writel(value, addr);
+
+	/* ensure the update has reached the flow controller */
+	wmb();
+	readl_relaxed(addr);
+}
+
+void flowctrl_write_cpu_csr(unsigned int cpuid, u32 value)
+{
+	return flowctrl_update(flowctrl_offset_halt_cpu[cpuid], value);
+}
+
+void flowctrl_write_cpu_halt(unsigned int cpuid, u32 value)
+{
+	return flowctrl_update(flowctrl_offset_cpu_csr[cpuid], value);
+}
diff --git a/arch/arm/mach-tegra/flowctrl.h b/arch/arm/mach-tegra/flowctrl.h
index 74c6efb..1942817 100644
--- a/arch/arm/mach-tegra/flowctrl.h
+++ b/arch/arm/mach-tegra/flowctrl.h
@@ -34,4 +34,9 @@
 #define FLOW_CTRL_HALT_CPU1_EVENTS	0x14
 #define FLOW_CTRL_CPU1_CSR		0x18
 
+#ifndef __ASSEMBLY__
+void flowctrl_write_cpu_csr(unsigned int cpuid, u32 value);
+void flowctrl_write_cpu_halt(unsigned int cpuid, u32 value);
+#endif
+
 #endif
-- 
1.7.7.rc0.72.g4b5ea.dirty

