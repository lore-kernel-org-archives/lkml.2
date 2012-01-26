Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2AZQWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:22:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1547 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2AZQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:22:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 26 Jan 2012 08:22:30 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/3] ARM: tegra: assembler code for LP3
Date: Thu, 26 Jan 2012 18:22:02 +0200
Message-Id: <1327594923-21822-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure the flow controller for clockgating and enter WFI

Based on work by:

Colin Cross <ccross@android.com>
Gary King <gking@nvidia.com>

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/sleep.S |   91 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 91 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/sleep.S

diff --git a/arch/arm/mach-tegra/sleep.S b/arch/arm/mach-tegra/sleep.S
new file mode 100644
index 0000000..8f9fde1
--- /dev/null
+++ b/arch/arm/mach-tegra/sleep.S
@@ -0,0 +1,91 @@
+/*
+ * arch/arm/mach-tegra/sleep.S
+ *
+ * Copyright (c) 2010-2011, NVIDIA Corporation.
+ * Copyright (c) 2011, Google, Inc.
+ *
+ * Author: Colin Cross <ccross@android.com>
+ *         Gary King <gking@nvidia.com>
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
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/linkage.h>
+#include <mach/io.h>
+#include <mach/iomap.h>
+
+#include "flowctrl.h"
+
+#define TEGRA_FLOW_CTRL_VIRT (TEGRA_FLOW_CTRL_BASE - IO_PPSB_PHYS \
+					+ IO_PPSB_VIRT)
+
+/* returns the offset of the flow controller halt register for a cpu */
+.macro cpu_to_halt_reg rd, rcpu
+	cmp	\rcpu, #0
+	subne	\rd, \rcpu, #1
+	movne	\rd, \rd, lsl #3
+	addne	\rd, \rd, #0x14
+	moveq	\rd, #0
+.endm
+
+/* returns the offset of the flow controller csr register for a cpu */
+.macro cpu_to_csr_reg rd, rcpu
+	cmp	\rcpu, #0
+	subne	\rd, \rcpu, #1
+	movne	\rd, \rd, lsl #3
+	addne	\rd, \rd, #0x18
+	moveq	\rd, #8
+.endm
+
+/* returns the ID of the current processor */
+.macro cpu_id, rd
+	mrc	p15, 0, \rd, c0, c0, 5
+	and	\rd, \rd, #0xF
+.endm
+
+/* loads a 32-bit value into a register without a data access */
+.macro mov32, reg, val
+	movw	\reg, #:lower16:\val
+	movt	\reg, #:upper16:\val
+.endm
+
+/*
+ * tegra_cpu_wfi
+ *
+ * puts current CPU in clock-gated wfi using the flow controller
+ *
+ * corrupts r0-r3
+ * must be called with MMU on
+ */
+
+ENTRY(tegra_cpu_wfi)
+	cpu_id	r0
+	cpu_to_halt_reg r1, r0
+	cpu_to_csr_reg r2, r0
+	mov32	r0, TEGRA_FLOW_CTRL_VIRT
+	mov	r3, #FLOW_CTRL_CSR_INTR_FLAG | FLOW_CTRL_CSR_EVENT_FLAG
+	str	r3, [r0, r2]	@ clear event & interrupt status
+	mov	r3, #FLOW_CTRL_WAIT_FOR_INTERRUPT | FLOW_CTRL_JTAG_RESUME
+	str	r3, [r0, r1]	@ put flow controller in wait irq mode
+	dsb
+	wfi
+	mov	r3, #0
+	str	r3, [r0, r1]	@ clear flow controller halt status
+	mov	r3, #FLOW_CTRL_CSR_INTR_FLAG | FLOW_CTRL_CSR_EVENT_FLAG
+	str	r3, [r0, r2]	@ clear event & interrupt status
+	dsb
+	mov	pc, lr
+ENDPROC(tegra_cpu_wfi)
+
-- 
1.7.7.rc0.72.g4b5ea.dirty

