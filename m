Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0H1RFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 13:05:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15597 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0H1RFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 13:05:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6088"; a="52580096"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 1/5 v4] msm: add gpiomux api for gpio multiplex & configuration.
Date: Sat, 28 Aug 2010 10:05:44 -0700
Message-Id: <1283015148-10747-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the 'gpiomux' api, which addresses the following shortcomings
of existing tlmm api:

- gpio power-collapse, which is managed by a peripheral processor on
  other targets, must be managed by the application processor on the 8x60.
- The enable/disable flag of the legacy gpio_tlmm_config api
  is not applicable on the 8x60, and causes confusion.
- The gpio 'direction' bits are meaningless for all func_sel
  configurations except for generic-gpio mode (func_sel 0), in which
  case the gpio_direction_* functions should be used.  Having these
  bits in the tlmm api leads to confusion and misuse of the gpiolib
  api, and they have been removed in gpiomux.
- The functional api of the legacy system ran contrary to the typical
  use-case, which is a single massive configuration at boot.  Rather
  than forcing hundreds of 'config' function calls, the new api
  allows data to be configured with a single table.

gpiomux_get and gpiomux_put are meant to be called automatically
when gpio_request and gpio_free are called, giving automatic
gpiomux/tlmm control to those drivers/lines with simple
power profiles - in the simplest cases, an entry in the gpiomux table
and the correct usage of gpiolib is all that is required to get proper
gpio power control.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig                       |    2 +
 arch/arm/mach-msm/Makefile                      |    3 +
 arch/arm/mach-msm/gpiomux-7x30.c                |   19 +++++
 arch/arm/mach-msm/gpiomux-8x50.c                |   19 +++++
 arch/arm/mach-msm/gpiomux-8x60.c                |   19 +++++
 arch/arm/mach-msm/gpiomux-v1.c                  |   33 ++++++++
 arch/arm/mach-msm/gpiomux-v1.h                  |   67 ++++++++++++++++
 arch/arm/mach-msm/gpiomux-v2.c                  |   25 ++++++
 arch/arm/mach-msm/gpiomux-v2.h                  |   61 ++++++++++++++
 arch/arm/mach-msm/gpiomux.c                     |   96 +++++++++++++++++++++++
 arch/arm/mach-msm/gpiomux.h                     |   94 ++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |   42 ++++++++++
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    2 +
 13 files changed, 482 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/gpiomux-7x30.c
 create mode 100644 arch/arm/mach-msm/gpiomux-8x50.c
 create mode 100644 arch/arm/mach-msm/gpiomux-8x60.c
 create mode 100644 arch/arm/mach-msm/gpiomux-v1.c
 create mode 100644 arch/arm/mach-msm/gpiomux-v1.h
 create mode 100644 arch/arm/mach-msm/gpiomux-v2.c
 create mode 100644 arch/arm/mach-msm/gpiomux-v2.h
 create mode 100644 arch/arm/mach-msm/gpiomux.c
 create mode 100644 arch/arm/mach-msm/gpiomux.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 47264a7..4e79580 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -106,4 +106,6 @@ config MSM_SMD_PKG3
 config MSM_SMD
 	bool
 
+config MSM_V2_TLMM
+	bool
 endif
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 7046106..78424e3 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -20,3 +20,6 @@ obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 
+obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-v1.o gpiomux.o
+obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
+obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
diff --git a/arch/arm/mach-msm/gpiomux-7x30.c b/arch/arm/mach-msm/gpiomux-7x30.c
new file mode 100644
index 0000000..7b380b3
--- /dev/null
+++ b/arch/arm/mach-msm/gpiomux-7x30.c
@@ -0,0 +1,19 @@
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
+ */
+#include "gpiomux.h"
+
+struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
diff --git a/arch/arm/mach-msm/gpiomux-8x50.c b/arch/arm/mach-msm/gpiomux-8x50.c
new file mode 100644
index 0000000..7b380b3
--- /dev/null
+++ b/arch/arm/mach-msm/gpiomux-8x50.c
@@ -0,0 +1,19 @@
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
+ */
+#include "gpiomux.h"
+
+struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
diff --git a/arch/arm/mach-msm/gpiomux-8x60.c b/arch/arm/mach-msm/gpiomux-8x60.c
new file mode 100644
index 0000000..7b380b3
--- /dev/null
+++ b/arch/arm/mach-msm/gpiomux-8x60.c
@@ -0,0 +1,19 @@
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
+ */
+#include "gpiomux.h"
+
+struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
diff --git a/arch/arm/mach-msm/gpiomux-v1.c b/arch/arm/mach-msm/gpiomux-v1.c
new file mode 100644
index 0000000..27de2ab
--- /dev/null
+++ b/arch/arm/mach-msm/gpiomux-v1.c
@@ -0,0 +1,33 @@
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
+ */
+#include <linux/kernel.h>
+#include "gpiomux.h"
+#include "proc_comm.h"
+
+void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val)
+{
+	unsigned tlmm_config  = (val & ~GPIOMUX_CTL_MASK) |
+				((gpio & 0x3ff) << 4);
+	unsigned tlmm_disable = 0;
+	int rc;
+
+	rc = msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX,
+			   &tlmm_config, &tlmm_disable);
+	if (rc)
+		pr_err("%s: unexpected proc_comm failure %d: %08x %08x\n",
+		       __func__, rc, tlmm_config, tlmm_disable);
+}
diff --git a/arch/arm/mach-msm/gpiomux-v1.h b/arch/arm/mach-msm/gpiomux-v1.h
new file mode 100644
index 0000000..71d86fe
--- /dev/null
+++ b/arch/arm/mach-msm/gpiomux-v1.h
@@ -0,0 +1,67 @@
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
+ */
+#ifndef __ARCH_ARM_MACH_MSM_GPIOMUX_V1_H
+#define __ARCH_ARM_MACH_MSM_GPIOMUX_V1_H
+
+#if defined(CONFIG_ARCH_MSM7X30)
+#define GPIOMUX_NGPIOS 182
+#elif defined(CONFIG_ARCH_QSD8X50)
+#define GPIOMUX_NGPIOS 165
+#else
+#define GPIOMUX_NGPIOS 133
+#endif
+
+typedef u32 gpiomux_config_t;
+
+enum {
+	GPIOMUX_DRV_2MA  = 0UL << 17,
+	GPIOMUX_DRV_4MA  = 1UL << 17,
+	GPIOMUX_DRV_6MA  = 2UL << 17,
+	GPIOMUX_DRV_8MA  = 3UL << 17,
+	GPIOMUX_DRV_10MA = 4UL << 17,
+	GPIOMUX_DRV_12MA = 5UL << 17,
+	GPIOMUX_DRV_14MA = 6UL << 17,
+	GPIOMUX_DRV_16MA = 7UL << 17,
+};
+
+enum {
+	GPIOMUX_FUNC_GPIO = 0UL,
+	GPIOMUX_FUNC_1    = 1UL,
+	GPIOMUX_FUNC_2    = 2UL,
+	GPIOMUX_FUNC_3    = 3UL,
+	GPIOMUX_FUNC_4    = 4UL,
+	GPIOMUX_FUNC_5    = 5UL,
+	GPIOMUX_FUNC_6    = 6UL,
+	GPIOMUX_FUNC_7    = 7UL,
+	GPIOMUX_FUNC_8    = 8UL,
+	GPIOMUX_FUNC_9    = 9UL,
+	GPIOMUX_FUNC_A    = 10UL,
+	GPIOMUX_FUNC_B    = 11UL,
+	GPIOMUX_FUNC_C    = 12UL,
+	GPIOMUX_FUNC_D    = 13UL,
+	GPIOMUX_FUNC_E    = 14UL,
+	GPIOMUX_FUNC_F    = 15UL,
+};
+
+enum {
+	GPIOMUX_PULL_NONE   = 0UL << 15,
+	GPIOMUX_PULL_DOWN   = 1UL << 15,
+	GPIOMUX_PULL_KEEPER = 2UL << 15,
+	GPIOMUX_PULL_UP     = 3UL << 15,
+};
+
+#endif
diff --git a/arch/arm/mach-msm/gpiomux-v2.c b/arch/arm/mach-msm/gpiomux-v2.c
new file mode 100644
index 0000000..273396d
--- /dev/null
+++ b/arch/arm/mach-msm/gpiomux-v2.c
@@ -0,0 +1,25 @@
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
+ */
+#include <linux/io.h>
+#include <mach/msm_iomap.h>
+#include "gpiomux.h"
+
+void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val)
+{
+	writel(val & ~GPIOMUX_CTL_MASK,
+	       MSM_TLMM_BASE + 0x1000 + (0x10 * gpio));
+}
diff --git a/arch/arm/mach-msm/gpiomux-v2.h b/arch/arm/mach-msm/gpiomux-v2.h
new file mode 100644
index 0000000..3bf10e7
--- /dev/null
+++ b/arch/arm/mach-msm/gpiomux-v2.h
@@ -0,0 +1,61 @@
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
+ */
+#ifndef __ARCH_ARM_MACH_MSM_GPIOMUX_V2_H
+#define __ARCH_ARM_MACH_MSM_GPIOMUX_V2_H
+
+#define GPIOMUX_NGPIOS 173
+
+typedef u16 gpiomux_config_t;
+
+enum {
+	GPIOMUX_DRV_2MA  = 0UL << 6,
+	GPIOMUX_DRV_4MA  = 1UL << 6,
+	GPIOMUX_DRV_6MA  = 2UL << 6,
+	GPIOMUX_DRV_8MA  = 3UL << 6,
+	GPIOMUX_DRV_10MA = 4UL << 6,
+	GPIOMUX_DRV_12MA = 5UL << 6,
+	GPIOMUX_DRV_14MA = 6UL << 6,
+	GPIOMUX_DRV_16MA = 7UL << 6,
+};
+
+enum {
+	GPIOMUX_FUNC_GPIO = 0UL  << 2,
+	GPIOMUX_FUNC_1    = 1UL  << 2,
+	GPIOMUX_FUNC_2    = 2UL  << 2,
+	GPIOMUX_FUNC_3    = 3UL  << 2,
+	GPIOMUX_FUNC_4    = 4UL  << 2,
+	GPIOMUX_FUNC_5    = 5UL  << 2,
+	GPIOMUX_FUNC_6    = 6UL  << 2,
+	GPIOMUX_FUNC_7    = 7UL  << 2,
+	GPIOMUX_FUNC_8    = 8UL  << 2,
+	GPIOMUX_FUNC_9    = 9UL  << 2,
+	GPIOMUX_FUNC_A    = 10UL << 2,
+	GPIOMUX_FUNC_B    = 11UL << 2,
+	GPIOMUX_FUNC_C    = 12UL << 2,
+	GPIOMUX_FUNC_D    = 13UL << 2,
+	GPIOMUX_FUNC_E    = 14UL << 2,
+	GPIOMUX_FUNC_F    = 15UL << 2,
+};
+
+enum {
+	GPIOMUX_PULL_NONE   = 0UL,
+	GPIOMUX_PULL_DOWN   = 1UL,
+	GPIOMUX_PULL_KEEPER = 2UL,
+	GPIOMUX_PULL_UP     = 3UL,
+};
+
+#endif
diff --git a/arch/arm/mach-msm/gpiomux.c b/arch/arm/mach-msm/gpiomux.c
new file mode 100644
index 0000000..53af21a
--- /dev/null
+++ b/arch/arm/mach-msm/gpiomux.c
@@ -0,0 +1,96 @@
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
+ */
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include "gpiomux.h"
+
+static DEFINE_SPINLOCK(gpiomux_lock);
+
+int msm_gpiomux_write(unsigned gpio,
+		      gpiomux_config_t active,
+		      gpiomux_config_t suspended)
+{
+	struct msm_gpiomux_config *cfg = msm_gpiomux_configs + gpio;
+	unsigned long irq_flags;
+	gpiomux_config_t setting;
+
+	if (gpio >= GPIOMUX_NGPIOS)
+		return -EINVAL;
+
+	spin_lock_irqsave(&gpiomux_lock, irq_flags);
+
+	if (active & GPIOMUX_VALID)
+		cfg->active = active;
+
+	if (suspended & GPIOMUX_VALID)
+		cfg->suspended = suspended;
+
+	setting = cfg->ref ? active : suspended;
+	if (setting & GPIOMUX_VALID)
+		__msm_gpiomux_write(gpio, setting);
+
+	spin_unlock_irqrestore(&gpiomux_lock, irq_flags);
+	return 0;
+}
+EXPORT_SYMBOL(msm_gpiomux_write);
+
+int msm_gpiomux_get(unsigned gpio)
+{
+	struct msm_gpiomux_config *cfg = msm_gpiomux_configs + gpio;
+	unsigned long irq_flags;
+
+	if (gpio >= GPIOMUX_NGPIOS)
+		return -EINVAL;
+
+	spin_lock_irqsave(&gpiomux_lock, irq_flags);
+	if (cfg->ref++ == 0 && cfg->active & GPIOMUX_VALID)
+		__msm_gpiomux_write(gpio, cfg->active);
+	spin_unlock_irqrestore(&gpiomux_lock, irq_flags);
+	return 0;
+}
+EXPORT_SYMBOL(msm_gpiomux_get);
+
+int msm_gpiomux_put(unsigned gpio)
+{
+	struct msm_gpiomux_config *cfg = msm_gpiomux_configs + gpio;
+	unsigned long irq_flags;
+
+	if (gpio >= GPIOMUX_NGPIOS)
+		return -EINVAL;
+
+	spin_lock_irqsave(&gpiomux_lock, irq_flags);
+	BUG_ON(cfg->ref == 0);
+	if (--cfg->ref == 0 && cfg->suspended & GPIOMUX_VALID)
+		__msm_gpiomux_write(gpio, cfg->suspended);
+	spin_unlock_irqrestore(&gpiomux_lock, irq_flags);
+	return 0;
+}
+EXPORT_SYMBOL(msm_gpiomux_put);
+
+static int __init gpiomux_init(void)
+{
+	unsigned n;
+
+	for (n = 0; n < GPIOMUX_NGPIOS; ++n) {
+		msm_gpiomux_configs[n].ref = 0;
+		if (!(msm_gpiomux_configs[n].suspended & GPIOMUX_VALID))
+			continue;
+		__msm_gpiomux_write(n, msm_gpiomux_configs[n].suspended);
+	}
+	return 0;
+}
+postcore_initcall(gpiomux_init);
diff --git a/arch/arm/mach-msm/gpiomux.h b/arch/arm/mach-msm/gpiomux.h
new file mode 100644
index 0000000..bb0acf0
--- /dev/null
+++ b/arch/arm/mach-msm/gpiomux.h
@@ -0,0 +1,94 @@
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
+ */
+#ifndef __ARCH_ARM_MACH_MSM_GPIOMUX_H
+#define __ARCH_ARM_MACH_MSM_GPIOMUX_H
+
+#include <linux/bitops.h>
+
+#if defined(CONFIG_MSM_V2_TLMM)
+#include "gpiomux-v2.h"
+#else
+#include "gpiomux-v1.h"
+#endif
+
+/**
+ * struct msm_gpiomux_config: gpiomux settings for one gpio line.
+ *
+ * A complete gpiomux config is the bitwise-or of a drive-strength,
+ * function, and pull.  For functions other than GPIO, the OE
+ * is hard-wired according to the function.  For GPIO mode,
+ * OE is controlled by gpiolib.
+ *
+ * Available settings differ by target; see the gpiomux header
+ * specific to your target arch for available configurations.
+ *
+ * @active: The configuration to be installed when the line is
+ * active, or its reference count is > 0.
+ * @suspended: The configuration to be installed when the line
+ * is suspended, or its reference count is 0.
+ * @ref: The reference count of the line.  For internal use of
+ * the gpiomux framework only.
+ */
+struct msm_gpiomux_config {
+	gpiomux_config_t active;
+	gpiomux_config_t suspended;
+	unsigned         ref;
+};
+
+/**
+ * @GPIOMUX_VALID:	If set, the config field contains 'good data'.
+ *                      The absence of this bit will prevent the gpiomux
+ *			system from applying the configuration under all
+ *			circumstances.
+ */
+enum {
+	GPIOMUX_VALID	 = BIT(sizeof(gpiomux_config_t) * BITS_PER_BYTE - 1),
+	GPIOMUX_CTL_MASK = GPIOMUX_VALID,
+};
+
+/* Each architecture must provide its own instance of this table.
+ * To avoid having gpiomux manage any given gpio, one or both of
+ * the entries can avoid setting GPIOMUX_VALID - the absence
+ * of that flag will prevent the configuration from being applied
+ * during state transitions.
+ */
+extern struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS];
+
+/* Increment a gpio's reference count, possibly activating the line. */
+int __must_check msm_gpiomux_get(unsigned gpio);
+
+/* Decrement a gpio's reference count, possibly suspending the line. */
+int msm_gpiomux_put(unsigned gpio);
+
+/* Install a new configuration to the gpio line.  To avoid overwriting
+ * a configuration, leave the VALID bit out.
+ */
+int msm_gpiomux_write(unsigned gpio,
+		      gpiomux_config_t active,
+		      gpiomux_config_t suspended);
+
+/* Architecture-internal function for use by the framework only.
+ * This function can assume the following:
+ * - the gpio value has passed a bounds-check
+ * - the gpiomux spinlock has been obtained
+ *
+ * This function is not for public consumption.  External users
+ * should use msm_gpiomux_write.
+ */
+void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val);
+
+#endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
new file mode 100644
index 0000000..17209f7
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Author: Brian Swetland <swetland@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ *
+ * The MSM peripherals are spread all over across 768MB of physical
+ * space, which makes just having a simple IO_ADDRESS macro to slide
+ * them into the right virtual location rough.  Instead, we will
+ * provide a master phys->virt mapping for peripherals here.
+ *
+ */
+
+#ifndef __ASM_ARCH_MSM_IOMAP_8X60_H
+#define __ASM_ARCH_MSM_IOMAP_8X60_H
+
+/* Physical base address and size of peripherals.
+ * Ordered by the virtual base addresses they will be mapped at.
+ *
+ * MSM_VIC_BASE must be an value that can be loaded via a "mov"
+ * instruction, otherwise entry-macro.S will not compile.
+ *
+ * If you add or remove entries here, you'll want to edit the
+ * msm_io_desc array in arch/arm/mach-msm/io.c to reflect your
+ * changes.
+ *
+ */
+
+#define MSM_TLMM_BASE		IOMEM(0xF0004000)
+#define MSM_TLMM_PHYS		0x00800000
+#define MSM_TLMM_SIZE		SZ_16K
+
+#endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index e6b1821..39c8fbc 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -47,6 +47,8 @@
 #include "msm_iomap-7x30.h"
 #elif defined(CONFIG_ARCH_QSD8X50)
 #include "msm_iomap-8x50.h"
+#elif defined(CONFIG_ARCH_MSM8X60)
+#include "msm_iomap-8x60.h"
 #else
 #include "msm_iomap-7x00.h"
 #endif
-- 
1.7.0.4

/usr2/gbean/.signature.codeaurora.org
