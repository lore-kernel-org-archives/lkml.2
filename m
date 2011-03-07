Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1CGSht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:37:49 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42901 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1CGShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:37:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6278"; a="78295961"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: davidb@codeaurora.org, bryanh@codeaurora.org, linux@arm.linux.org.uk,
        dwalker@fifo99.com
Cc: dima@android.com, Gregory Bean <gbean@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Rohit Vaswani <rvaswani@codeaurora.org>
Subject: [PATCHv2 3/3] msm: gpiomux: Remove GPIOMUX_VALID and merge config enums
Date: Mon,  7 Mar 2011 10:37:32 -0800
Message-Id: <1299523052-31454-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Bean <gbean@codeaurora.org>

Remove GPIOMUX_VALID, simplify the API, and absorb the complexity
of determining which gpiomux configs are used and which are
not back into the gpiomux implementation where it belongs.
Allow NULL settings to be represented appropriately.
The configuration enumerations represent a single abstraction
and were needlessly split. As such, collapse the conflicting
abstractions into a consistent one and move the implementation
complexity down into the implementation (where it belongs) and
away from the interface (where it doesn't belong).

Change-Id: If2dca97c4cf04f9af5c301e7d76605f09a9f30b8
Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
v2: Re-send

 arch/arm/mach-msm/board-msm7x30.c |   23 +++++++--
 arch/arm/mach-msm/board-qsd8x50.c |   17 +++++--
 arch/arm/mach-msm/gpiomux-v1.c    |    9 ++-
 arch/arm/mach-msm/gpiomux-v1.h    |   59 ----------------------
 arch/arm/mach-msm/gpiomux-v2.c    |    8 ++-
 arch/arm/mach-msm/gpiomux-v2.h    |   59 ----------------------
 arch/arm/mach-msm/gpiomux.c       |   77 +++++++++++++++++-------------
 arch/arm/mach-msm/gpiomux.h       |   96 +++++++++++++++++++++++-------------
 8 files changed, 145 insertions(+), 203 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-v1.h
 delete mode 100644 arch/arm/mach-msm/gpiomux-v2.h

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index 59b91de..4223329 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -39,8 +39,11 @@
 #include "gpiomux.h"
 #include "proc_comm.h"
 
-#define UART2_SUSPENDED (GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |\
-			GPIOMUX_FUNC_2 | GPIOMUX_VALID)
+static struct gpiomux_setting uart2_suspended = {
+	.func = GPIOMUX_FUNC_2,
+	.drv = GPIOMUX_DRV_2MA,
+	.pull = GPIOMUX_PULL_DOWN,
+};
 
 extern struct sys_timer msm_timer;
 
@@ -59,19 +62,27 @@ static struct msm_otg_platform_data msm_otg_pdata = {
 struct msm_gpiomux_config msm7x30_uart2_configs[] __initdata = {
 	{
 		.gpio = 49, /* UART2 RFR */
-		.suspended = UART2_SUSPENDED,
+		.settings = {
+			[GPIOMUX_SUSPENDED] = &uart2_suspended,
+		},
 	},
 	{
 		.gpio = 50, /* UART2 CTS */
-		.suspended = UART2_SUSPENDED,
+		.settings = {
+			[GPIOMUX_SUSPENDED] = &uart2_suspended,
+		},
 	},
 	{
 		.gpio = 51, /* UART2 RX */
-		.suspended = UART2_SUSPENDED,
+		.settings = {
+			[GPIOMUX_SUSPENDED] = &uart2_suspended,
+		},
 	},
 	{
 		.gpio = 52, /* UART2 TX */
-		.suspended = UART2_SUSPENDED,
+		.settings = {
+			[GPIOMUX_SUSPENDED] = &uart2_suspended,
+		},
 	},
 };
 
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 33ab1fe..d665b0e 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -38,19 +38,26 @@
 #include "devices.h"
 #include "gpiomux.h"
 
-#define UART3_SUSPENDED (GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |\
-			GPIOMUX_FUNC_1 | GPIOMUX_VALID)
+static struct gpiomux_setting uart3_suspended = {
+	.drv = GPIOMUX_DRV_2MA,
+	.pull = GPIOMUX_PULL_DOWN,
+	.func = GPIOMUX_FUNC_1,
+};
 
 extern struct sys_timer msm_timer;
 
-struct msm_gpiomux_config qsd8x50_uart3_configs[] __initdata = {
+struct msm_gpiomux_config qsd8x50_uart3_configs[] = {
 	{
 		.gpio = 86, /* UART3 RX */
-		.suspended = UART3_SUSPENDED,
+		.settings = {
+			[GPIOMUX_SUSPENDED] = &uart3_suspended,
+		},
 	},
 	{
 		.gpio = 87, /* UART3 TX */
-		.suspended = UART3_SUSPENDED,
+		.settings = {
+			[GPIOMUX_SUSPENDED] = &uart3_suspended,
+		},
 	},
 };
 
diff --git a/arch/arm/mach-msm/gpiomux-v1.c b/arch/arm/mach-msm/gpiomux-v1.c
index 27de2ab..a9525c2 100644
--- a/arch/arm/mach-msm/gpiomux-v1.c
+++ b/arch/arm/mach-msm/gpiomux-v1.c
@@ -18,13 +18,16 @@
 #include "gpiomux.h"
 #include "proc_comm.h"
 
-void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val)
+void __msm_gpiomux_write(unsigned gpio, struct gpiomux_setting val)
 {
-	unsigned tlmm_config  = (val & ~GPIOMUX_CTL_MASK) |
-				((gpio & 0x3ff) << 4);
+	unsigned tlmm_config;
 	unsigned tlmm_disable = 0;
 	int rc;
 
+	tlmm_config  = (val.drv << 17) |
+		(val.pull << 15) |
+		((gpio & 0x3ff) << 4) |
+		val.func;
 	rc = msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX,
 			   &tlmm_config, &tlmm_disable);
 	if (rc)
diff --git a/arch/arm/mach-msm/gpiomux-v1.h b/arch/arm/mach-msm/gpiomux-v1.h
deleted file mode 100644
index 96ad5fa..0000000
--- a/arch/arm/mach-msm/gpiomux-v1.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-#ifndef __ARCH_ARM_MACH_MSM_GPIOMUX_V1_H
-#define __ARCH_ARM_MACH_MSM_GPIOMUX_V1_H
-
-typedef u32 gpiomux_config_t;
-
-enum {
-	GPIOMUX_DRV_2MA  = 0UL << 17,
-	GPIOMUX_DRV_4MA  = 1UL << 17,
-	GPIOMUX_DRV_6MA  = 2UL << 17,
-	GPIOMUX_DRV_8MA  = 3UL << 17,
-	GPIOMUX_DRV_10MA = 4UL << 17,
-	GPIOMUX_DRV_12MA = 5UL << 17,
-	GPIOMUX_DRV_14MA = 6UL << 17,
-	GPIOMUX_DRV_16MA = 7UL << 17,
-};
-
-enum {
-	GPIOMUX_FUNC_GPIO = 0UL,
-	GPIOMUX_FUNC_1    = 1UL,
-	GPIOMUX_FUNC_2    = 2UL,
-	GPIOMUX_FUNC_3    = 3UL,
-	GPIOMUX_FUNC_4    = 4UL,
-	GPIOMUX_FUNC_5    = 5UL,
-	GPIOMUX_FUNC_6    = 6UL,
-	GPIOMUX_FUNC_7    = 7UL,
-	GPIOMUX_FUNC_8    = 8UL,
-	GPIOMUX_FUNC_9    = 9UL,
-	GPIOMUX_FUNC_A    = 10UL,
-	GPIOMUX_FUNC_B    = 11UL,
-	GPIOMUX_FUNC_C    = 12UL,
-	GPIOMUX_FUNC_D    = 13UL,
-	GPIOMUX_FUNC_E    = 14UL,
-	GPIOMUX_FUNC_F    = 15UL,
-};
-
-enum {
-	GPIOMUX_PULL_NONE   = 0UL << 15,
-	GPIOMUX_PULL_DOWN   = 1UL << 15,
-	GPIOMUX_PULL_KEEPER = 2UL << 15,
-	GPIOMUX_PULL_UP     = 3UL << 15,
-};
-
-#endif
diff --git a/arch/arm/mach-msm/gpiomux-v2.c b/arch/arm/mach-msm/gpiomux-v2.c
index 273396d..0a04d60 100644
--- a/arch/arm/mach-msm/gpiomux-v2.c
+++ b/arch/arm/mach-msm/gpiomux-v2.c
@@ -18,8 +18,10 @@
 #include <mach/msm_iomap.h>
 #include "gpiomux.h"
 
-void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val)
+void __msm_gpiomux_write(unsigned gpio, struct gpiomux_setting val)
 {
-	writel(val & ~GPIOMUX_CTL_MASK,
-	       MSM_TLMM_BASE + 0x1000 + (0x10 * gpio));
+	uint32_t bits;
+
+	bits = (val.drv << 6) | (val.func << 2) | val.pull;
+	writel(bits, MSM_TLMM_BASE + 0x1000 + (0x10 * gpio));
 }
diff --git a/arch/arm/mach-msm/gpiomux-v2.h b/arch/arm/mach-msm/gpiomux-v2.h
deleted file mode 100644
index a7dec1ea..0000000
--- a/arch/arm/mach-msm/gpiomux-v2.h
+++ /dev/null
@@ -1,59 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-#ifndef __ARCH_ARM_MACH_MSM_GPIOMUX_V2_H
-#define __ARCH_ARM_MACH_MSM_GPIOMUX_V2_H
-
-typedef u16 gpiomux_config_t;
-
-enum {
-	GPIOMUX_DRV_2MA  = 0UL << 6,
-	GPIOMUX_DRV_4MA  = 1UL << 6,
-	GPIOMUX_DRV_6MA  = 2UL << 6,
-	GPIOMUX_DRV_8MA  = 3UL << 6,
-	GPIOMUX_DRV_10MA = 4UL << 6,
-	GPIOMUX_DRV_12MA = 5UL << 6,
-	GPIOMUX_DRV_14MA = 6UL << 6,
-	GPIOMUX_DRV_16MA = 7UL << 6,
-};
-
-enum {
-	GPIOMUX_FUNC_GPIO = 0UL  << 2,
-	GPIOMUX_FUNC_1    = 1UL  << 2,
-	GPIOMUX_FUNC_2    = 2UL  << 2,
-	GPIOMUX_FUNC_3    = 3UL  << 2,
-	GPIOMUX_FUNC_4    = 4UL  << 2,
-	GPIOMUX_FUNC_5    = 5UL  << 2,
-	GPIOMUX_FUNC_6    = 6UL  << 2,
-	GPIOMUX_FUNC_7    = 7UL  << 2,
-	GPIOMUX_FUNC_8    = 8UL  << 2,
-	GPIOMUX_FUNC_9    = 9UL  << 2,
-	GPIOMUX_FUNC_A    = 10UL << 2,
-	GPIOMUX_FUNC_B    = 11UL << 2,
-	GPIOMUX_FUNC_C    = 12UL << 2,
-	GPIOMUX_FUNC_D    = 13UL << 2,
-	GPIOMUX_FUNC_E    = 14UL << 2,
-	GPIOMUX_FUNC_F    = 15UL << 2,
-};
-
-enum {
-	GPIOMUX_PULL_NONE   = 0UL,
-	GPIOMUX_PULL_DOWN   = 1UL,
-	GPIOMUX_PULL_KEEPER = 2UL,
-	GPIOMUX_PULL_UP     = 3UL,
-};
-
-#endif
diff --git a/arch/arm/mach-msm/gpiomux.c b/arch/arm/mach-msm/gpiomux.c
index 9ef9864..1ca26ec 100644
--- a/arch/arm/mach-msm/gpiomux.c
+++ b/arch/arm/mach-msm/gpiomux.c
@@ -20,21 +20,21 @@
 #include "gpiomux.h"
 
 struct msm_gpiomux_rec {
-	gpiomux_config_t active;
-	gpiomux_config_t suspended;
-	int              ref;
+	struct gpiomux_setting *sets[GPIOMUX_NSETTINGS];
+	int ref;
 };
 static DEFINE_SPINLOCK(gpiomux_lock);
 static struct msm_gpiomux_rec *msm_gpiomux_recs;
+static struct gpiomux_setting *msm_gpiomux_sets;
 static unsigned msm_gpiomux_ngpio;
 
-int msm_gpiomux_write(unsigned gpio,
-		      gpiomux_config_t active,
-		      gpiomux_config_t suspended)
+int msm_gpiomux_write(unsigned gpio, enum msm_gpiomux_setting which,
+	struct gpiomux_setting *setting)
 {
-	struct msm_gpiomux_rec *cfg = msm_gpiomux_recs + gpio;
+	struct msm_gpiomux_rec *rec = msm_gpiomux_recs + gpio;
+	unsigned set_slot = gpio * GPIOMUX_NSETTINGS + which;
 	unsigned long irq_flags;
-	gpiomux_config_t setting;
+	struct gpiomux_setting *new_set;
 
 	if (!msm_gpiomux_recs)
 		return -EFAULT;
@@ -44,15 +44,17 @@ int msm_gpiomux_write(unsigned gpio,
 
 	spin_lock_irqsave(&gpiomux_lock, irq_flags);
 
-	if (active & GPIOMUX_VALID)
-		cfg->active = active;
-
-	if (suspended & GPIOMUX_VALID)
-		cfg->suspended = suspended;
+	if (setting) {
+		msm_gpiomux_sets[set_slot] = *setting;
+		rec->sets[which] = &msm_gpiomux_sets[set_slot];
+	} else {
+		rec->sets[which] = NULL;
+	}
 
-	setting = cfg->ref ? active : suspended;
-	if (setting & GPIOMUX_VALID)
-		__msm_gpiomux_write(gpio, setting);
+	new_set = rec->ref ? rec->sets[GPIOMUX_ACTIVE] :
+		rec->sets[GPIOMUX_SUSPENDED];
+	if (new_set)
+		__msm_gpiomux_write(gpio, *new_set);
 
 	spin_unlock_irqrestore(&gpiomux_lock, irq_flags);
 	return 0;
@@ -61,7 +63,7 @@ EXPORT_SYMBOL(msm_gpiomux_write);
 
 int msm_gpiomux_get(unsigned gpio)
 {
-	struct msm_gpiomux_rec *cfg = msm_gpiomux_recs + gpio;
+	struct msm_gpiomux_rec *rec = msm_gpiomux_recs + gpio;
 	unsigned long irq_flags;
 
 	if (!msm_gpiomux_recs)
@@ -71,8 +73,8 @@ int msm_gpiomux_get(unsigned gpio)
 		return -EINVAL;
 
 	spin_lock_irqsave(&gpiomux_lock, irq_flags);
-	if (cfg->ref++ == 0 && cfg->active & GPIOMUX_VALID)
-		__msm_gpiomux_write(gpio, cfg->active);
+	if (rec->ref++ == 0 && rec->sets[GPIOMUX_ACTIVE])
+		__msm_gpiomux_write(gpio, *rec->sets[GPIOMUX_ACTIVE]);
 	spin_unlock_irqrestore(&gpiomux_lock, irq_flags);
 	return 0;
 }
@@ -80,7 +82,7 @@ EXPORT_SYMBOL(msm_gpiomux_get);
 
 int msm_gpiomux_put(unsigned gpio)
 {
-	struct msm_gpiomux_rec *cfg = msm_gpiomux_recs + gpio;
+	struct msm_gpiomux_rec *rec = msm_gpiomux_recs + gpio;
 	unsigned long irq_flags;
 
 	if (!msm_gpiomux_recs)
@@ -90,9 +92,9 @@ int msm_gpiomux_put(unsigned gpio)
 		return -EINVAL;
 
 	spin_lock_irqsave(&gpiomux_lock, irq_flags);
-	BUG_ON(cfg->ref == 0);
-	if (--cfg->ref == 0 && cfg->suspended & GPIOMUX_VALID)
-		__msm_gpiomux_write(gpio, cfg->suspended);
+	BUG_ON(rec->ref == 0);
+	if (--rec->ref == 0 && rec->sets[GPIOMUX_SUSPENDED])
+		__msm_gpiomux_write(gpio, *rec->sets[GPIOMUX_SUSPENDED]);
 	spin_unlock_irqrestore(&gpiomux_lock, irq_flags);
 	return 0;
 }
@@ -111,6 +113,17 @@ int msm_gpiomux_init(size_t ngpio)
 	if (!msm_gpiomux_recs)
 		return -ENOMEM;
 
+	/* There is no need to zero this memory, as clients will be blindly
+	 * installing settings on top of it.
+	 */
+	msm_gpiomux_sets = kmalloc(sizeof(struct gpiomux_setting) * ngpio *
+		GPIOMUX_NSETTINGS, GFP_KERNEL);
+	if (!msm_gpiomux_sets) {
+		kfree(msm_gpiomux_recs);
+		msm_gpiomux_recs = NULL;
+		return -ENOMEM;
+	}
+
 	msm_gpiomux_ngpio = ngpio;
 
 	return 0;
@@ -119,18 +132,16 @@ EXPORT_SYMBOL(msm_gpiomux_init);
 
 void msm_gpiomux_install(struct msm_gpiomux_config *configs, unsigned nconfigs)
 {
-	unsigned n;
+	unsigned c, s;
 	int rc;
 
-	if (!msm_gpiomux_recs)
-		return;
-
-	for (n = 0; n < nconfigs; ++n) {
-		rc = msm_gpiomux_write(configs[n].gpio,
-				       configs[n].active,
-				       configs[n].suspended);
-		if (rc)
-			pr_err("%s: write failure: %d\n", __func__, rc);
+	for (c = 0; c < nconfigs; ++c) {
+		for (s = 0; s < GPIOMUX_NSETTINGS; ++s) {
+			rc = msm_gpiomux_write(configs[c].gpio, s,
+				configs[c].settings[s]);
+			if (rc)
+				pr_err("%s: write failure: %d\n", __func__, rc);
+		}
 	}
 }
 EXPORT_SYMBOL(msm_gpiomux_install);
diff --git a/arch/arm/mach-msm/gpiomux.h b/arch/arm/mach-msm/gpiomux.h
index 38bf511..bd8d6c2 100644
--- a/arch/arm/mach-msm/gpiomux.h
+++ b/arch/arm/mach-msm/gpiomux.h
@@ -20,44 +20,73 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 
-#if defined(CONFIG_MSM_V2_TLMM)
-#include "gpiomux-v2.h"
-#else
-#include "gpiomux-v1.h"
-#endif
+enum msm_gpiomux_setting {
+	GPIOMUX_ACTIVE = 0,
+	GPIOMUX_SUSPENDED,
+	GPIOMUX_NSETTINGS
+};
+
+enum gpiomux_drv {
+	GPIOMUX_DRV_2MA = 0,
+	GPIOMUX_DRV_4MA,
+	GPIOMUX_DRV_6MA,
+	GPIOMUX_DRV_8MA,
+	GPIOMUX_DRV_10MA,
+	GPIOMUX_DRV_12MA,
+	GPIOMUX_DRV_14MA,
+	GPIOMUX_DRV_16MA,
+};
+
+enum gpiomux_func {
+	GPIOMUX_FUNC_GPIO = 0,
+	GPIOMUX_FUNC_1,
+	GPIOMUX_FUNC_2,
+	GPIOMUX_FUNC_3,
+	GPIOMUX_FUNC_4,
+	GPIOMUX_FUNC_5,
+	GPIOMUX_FUNC_6,
+	GPIOMUX_FUNC_7,
+	GPIOMUX_FUNC_8,
+	GPIOMUX_FUNC_9,
+	GPIOMUX_FUNC_A,
+	GPIOMUX_FUNC_B,
+	GPIOMUX_FUNC_C,
+	GPIOMUX_FUNC_D,
+	GPIOMUX_FUNC_E,
+	GPIOMUX_FUNC_F,
+};
+
+enum gpiomux_pull {
+	GPIOMUX_PULL_NONE = 0,
+	GPIOMUX_PULL_DOWN,
+	GPIOMUX_PULL_KEEPER,
+	GPIOMUX_PULL_UP,
+};
+
+struct gpiomux_setting {
+	enum gpiomux_func func;
+	enum gpiomux_drv  drv;
+	enum gpiomux_pull pull;
+};
 
 /**
  * struct msm_gpiomux_config: gpiomux settings for one gpio line.
  *
- * A complete gpiomux config is the bitwise-or of a drive-strength,
+ * A complete gpiomux setting is the combination of a drive-strength,
  * function, and pull.  For functions other than GPIO, the OE
  * is hard-wired according to the function.  For GPIO mode,
  * OE is controlled by gpiolib.
  *
- * Available settings differ by target; see the gpiomux header
- * specific to your target arch for available configurations.
- *
  * @gpio: The index number of the gpio being described.
- * @active: The configuration to be installed when the line is
- * active, or its reference count is > 0.
- * @suspended: The configuration to be installed when the line
- * is suspended, or its reference count is 0.
+ * @settings: The settings to be installed, specifically:
+ *           GPIOMUX_ACTIVE: The setting to be installed when the
+ *           line is active, or its reference count is > 0.
+ *           GPIOMUX_SUSPENDED: The setting to be installed when
+ *           the line is suspended, or its reference count is 0.
  */
 struct msm_gpiomux_config {
-	unsigned         gpio;
-	gpiomux_config_t active;
-	gpiomux_config_t suspended;
-};
-
-/**
- * @GPIOMUX_VALID:	If set, the config field contains 'good data'.
- *                      The absence of this bit will prevent the gpiomux
- *			system from applying the configuration under all
- *			circumstances.
- */
-enum {
-	GPIOMUX_VALID	 = BIT(sizeof(gpiomux_config_t) * BITS_PER_BYTE - 1),
-	GPIOMUX_CTL_MASK = GPIOMUX_VALID,
+	unsigned gpio;
+	struct gpiomux_setting *settings[GPIOMUX_NSETTINGS];
 };
 
 #ifdef CONFIG_MSM_GPIOMUX
@@ -79,12 +108,10 @@ int __must_check msm_gpiomux_get(unsigned gpio);
 /* Decrement a gpio's reference count, possibly suspending the line. */
 int msm_gpiomux_put(unsigned gpio);
 
-/* Install a new configuration to the gpio line.  To avoid overwriting
- * a configuration, leave the VALID bit out.
+/* Install a new setting in a gpio.  To erase a slot, use NULL.
  */
-int msm_gpiomux_write(unsigned gpio,
-		      gpiomux_config_t active,
-		      gpiomux_config_t suspended);
+int msm_gpiomux_write(unsigned gpio, enum msm_gpiomux_setting which,
+	struct gpiomux_setting *setting);
 
 /* Architecture-internal function for use by the framework only.
  * This function can assume the following:
@@ -94,7 +121,7 @@ int msm_gpiomux_write(unsigned gpio,
  * This function is not for public consumption.  External users
  * should use msm_gpiomux_write.
  */
-void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val);
+void __msm_gpiomux_write(unsigned gpio, struct gpiomux_setting val);
 #else
 static inline int msm_gpiomux_init(size_t ngpio)
 {
@@ -115,8 +142,7 @@ static inline int msm_gpiomux_put(unsigned gpio)
 }
 
 static inline int msm_gpiomux_write(unsigned gpio,
-				    gpiomux_config_t active,
-				    gpiomux_config_t suspended)
+	enum msm_gpiomux_setting which, struct gpiomux_setting *setting)
 {
 	return -ENOSYS;
 }
-- 
Sent by an employee of the Qualcomm Innovation Center,Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

