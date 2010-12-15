Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504Ab0LODu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:50:26 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30954 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386Ab0LODt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:49:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66872370"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 4/7] msm: Board file for MSM8960 simulator
Date: Tue, 14 Dec 2010 19:49:18 -0800
Message-Id: <1292384961-8851-5-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a basic board file needed to boot the kernel on the
MSM8960 simulator.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8960.c |   71 +++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-msm8960.c

diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
new file mode 100644
index 0000000..7a1b80a
--- /dev/null
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -0,0 +1,71 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/hardware/gic.h>
+
+#include <mach/board.h>
+#include <mach/msm_iomap.h>
+
+void __iomem *gic_cpu_base_addr;
+
+static void __init msm8960_map_io(void)
+{
+	msm_map_msm8960_io();
+}
+
+static void __init msm8960_init_irq(void)
+{
+	unsigned int i;
+
+	gic_dist_init(0, MSM_QGIC_DIST_BASE, GIC_PPI_START);
+	gic_cpu_base_addr = (void *)MSM_QGIC_CPU_BASE;
+	gic_cpu_init(0, MSM_QGIC_CPU_BASE);
+
+	/* Edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
+	writel(0xFFFFD7FF, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
+
+	/* FIXME: Not installing AVS_SVICINT and AVS_SVICINTSWDONE yet
+	 * as they are configured as level, which does not play nice with
+	 * handle_percpu_irq.
+	 */
+	for (i = GIC_PPI_START; i < GIC_SPI_START; i++) {
+		if (i != AVS_SVICINT && i != AVS_SVICINTSWDONE)
+			set_irq_handler(i, handle_percpu_irq);
+	}
+}
+
+static void __init msm8960_sim_init(void)
+{
+}
+
+MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
+#ifdef CONFIG_MSM_DEBUG_UART
+	.phys_io  = MSM_DEBUG_UART_PHYS,
+	.io_pg_offst = ((MSM_DEBUG_UART_BASE) >> 18) & 0xfffc,
+#endif
+	.map_io = msm8960_map_io,
+	.init_irq = msm8960_init_irq,
+	.init_machine = msm8960_sim_init,
+	.timer = &msm_timer,
+MACHINE_END
--
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

