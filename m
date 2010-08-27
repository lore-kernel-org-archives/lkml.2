Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0H0QU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:20:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6502 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0H0QTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:19:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52339605"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 5/5 v3] msm: gpio: Remove tlmm routines obsoleted by gpiomux.
Date: Fri, 27 Aug 2010 09:19:35 -0700
Message-Id: <1282925975-26367-5-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282925975-26367-1-git-send-email-gbean@codeaurora.org>
References: <1282925975-26367-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all supported gpio_tlmm_config-using boards
are using gpiomux, remove the deprecated code.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/Makefile            |    1 -
 arch/arm/mach-msm/gpio.c              |   85 -----------------------
 arch/arm/mach-msm/include/mach/gpio.h |  123 ---------------------------------
 3 files changed, 0 insertions(+), 209 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpio.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 1850942..faeb1f9 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -3,7 +3,6 @@ obj-y += io.o idle.o timer.o dma.o
 obj-y += vreg.o
 obj-y += acpuclock-arm11.o
 obj-y += clock.o clock-pcom.o
-obj-y += gpio.o
 
 ifdef CONFIG_MSM_VIC
 obj-y += irq-vic.o
diff --git a/arch/arm/mach-msm/gpio.c b/arch/arm/mach-msm/gpio.c
deleted file mode 100644
index bc32c84..0000000
--- a/arch/arm/mach-msm/gpio.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/* linux/arch/arm/mach-msm/gpio.c
- *
- * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2009, Code Aurora Forum. All rights reserved.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/module.h>
-#include <mach/gpio.h>
-#include "proc_comm.h"
-
-int gpio_tlmm_config(unsigned config, unsigned disable)
-{
-	return msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX, &config, &disable);
-}
-EXPORT_SYMBOL(gpio_tlmm_config);
-
-int msm_gpios_enable(const struct msm_gpio *table, int size)
-{
-	int rc;
-	int i;
-	const struct msm_gpio *g;
-	for (i = 0; i < size; i++) {
-		g = table + i;
-		rc = gpio_tlmm_config(g->gpio_cfg, GPIO_ENABLE);
-		if (rc) {
-			pr_err("gpio_tlmm_config(0x%08x, GPIO_ENABLE)"
-			       " <%s> failed: %d\n",
-			       g->gpio_cfg, g->label ?: "?", rc);
-			pr_err("pin %d func %d dir %d pull %d drvstr %d\n",
-			       GPIO_PIN(g->gpio_cfg), GPIO_FUNC(g->gpio_cfg),
-			       GPIO_DIR(g->gpio_cfg), GPIO_PULL(g->gpio_cfg),
-			       GPIO_DRVSTR(g->gpio_cfg));
-			goto err;
-		}
-	}
-	return 0;
-err:
-	msm_gpios_disable(table, i);
-	return rc;
-}
-EXPORT_SYMBOL(msm_gpios_enable);
-
-void msm_gpios_disable(const struct msm_gpio *table, int size)
-{
-	int rc;
-	int i;
-	const struct msm_gpio *g;
-	for (i = size-1; i >= 0; i--) {
-		g = table + i;
-		rc = gpio_tlmm_config(g->gpio_cfg, GPIO_DISABLE);
-		if (rc) {
-			pr_err("gpio_tlmm_config(0x%08x, GPIO_DISABLE)"
-			       " <%s> failed: %d\n",
-			       g->gpio_cfg, g->label ?: "?", rc);
-			pr_err("pin %d func %d dir %d pull %d drvstr %d\n",
-			       GPIO_PIN(g->gpio_cfg), GPIO_FUNC(g->gpio_cfg),
-			       GPIO_DIR(g->gpio_cfg), GPIO_PULL(g->gpio_cfg),
-			       GPIO_DRVSTR(g->gpio_cfg));
-		}
-	}
-}
-EXPORT_SYMBOL(msm_gpios_disable);
-
-int msm_gpios_request_enable(const struct msm_gpio *table, int size)
-{
-	int rc = msm_gpios_enable(table, size);
-	return rc;
-}
-EXPORT_SYMBOL(msm_gpios_request_enable);
-
-void msm_gpios_disable_free(const struct msm_gpio *table, int size)
-{
-	msm_gpios_disable(table, size);
-}
-EXPORT_SYMBOL(msm_gpios_disable_free);
diff --git a/arch/arm/mach-msm/include/mach/gpio.h b/arch/arm/mach-msm/include/mach/gpio.h
index 83e47c0..36ad50d 100644
--- a/arch/arm/mach-msm/include/mach/gpio.h
+++ b/arch/arm/mach-msm/include/mach/gpio.h
@@ -23,127 +23,4 @@
 #define gpio_cansleep   __gpio_cansleep
 #define gpio_to_irq     __gpio_to_irq
 
-/**
- * struct msm_gpio - GPIO pin description
- * @gpio_cfg - configuration bitmap, as per gpio_tlmm_config()
- * @label - textual label
- *
- * Usually, GPIO's are operated by sets.
- * This struct accumulate all GPIO information in single source
- * and facilitete group operations provided by msm_gpios_xxx()
- */
-struct msm_gpio {
-	u32 gpio_cfg;
-	const char *label;
-};
-
-/**
- * msm_gpios_request_enable() - request and enable set of GPIOs
- *
- * Request and configure set of GPIO's
- * In case of error, all operations rolled back.
- * Return error code.
- *
- * @table: GPIO table
- * @size:  number of entries in @table
- */
-int msm_gpios_request_enable(const struct msm_gpio *table, int size);
-
-/**
- * msm_gpios_disable_free() - disable and free set of GPIOs
- *
- * @table: GPIO table
- * @size:  number of entries in @table
- */
-void msm_gpios_disable_free(const struct msm_gpio *table, int size);
-
-/**
- * msm_gpios_request() - request set of GPIOs
- * In case of error, all operations rolled back.
- * Return error code.
- *
- * @table: GPIO table
- * @size:  number of entries in @table
- */
-int msm_gpios_request(const struct msm_gpio *table, int size);
-
-/**
- * msm_gpios_free() - free set of GPIOs
- *
- * @table: GPIO table
- * @size:  number of entries in @table
- */
-void msm_gpios_free(const struct msm_gpio *table, int size);
-
-/**
- * msm_gpios_enable() - enable set of GPIOs
- * In case of error, all operations rolled back.
- * Return error code.
- *
- * @table: GPIO table
- * @size:  number of entries in @table
- */
-int msm_gpios_enable(const struct msm_gpio *table, int size);
-
-/**
- * msm_gpios_disable() - disable set of GPIOs
- *
- * @table: GPIO table
- * @size:  number of entries in @table
- */
-void msm_gpios_disable(const struct msm_gpio *table, int size);
-
-/* GPIO TLMM (Top Level Multiplexing) Definitions */
-
-/* GPIO TLMM: Function -- GPIO specific */
-
-/* GPIO TLMM: Direction */
-enum {
-	GPIO_INPUT,
-	GPIO_OUTPUT,
-};
-
-/* GPIO TLMM: Pullup/Pulldown */
-enum {
-	GPIO_NO_PULL,
-	GPIO_PULL_DOWN,
-	GPIO_KEEPER,
-	GPIO_PULL_UP,
-};
-
-/* GPIO TLMM: Drive Strength */
-enum {
-	GPIO_2MA,
-	GPIO_4MA,
-	GPIO_6MA,
-	GPIO_8MA,
-	GPIO_10MA,
-	GPIO_12MA,
-	GPIO_14MA,
-	GPIO_16MA,
-};
-
-enum {
-	GPIO_ENABLE,
-	GPIO_DISABLE,
-};
-
-#define GPIO_CFG(gpio, func, dir, pull, drvstr) \
-	((((gpio) & 0x3FF) << 4)        |	  \
-	 ((func) & 0xf)                  |	  \
-	 (((dir) & 0x1) << 14)           |	  \
-	 (((pull) & 0x3) << 15)          |	  \
-	 (((drvstr) & 0xF) << 17))
-
-/**
- * extract GPIO pin from bit-field used for gpio_tlmm_config
- */
-#define GPIO_PIN(gpio_cfg)    (((gpio_cfg) >>  4) & 0x3ff)
-#define GPIO_FUNC(gpio_cfg)   (((gpio_cfg) >>  0) & 0xf)
-#define GPIO_DIR(gpio_cfg)    (((gpio_cfg) >> 14) & 0x1)
-#define GPIO_PULL(gpio_cfg)   (((gpio_cfg) >> 15) & 0x3)
-#define GPIO_DRVSTR(gpio_cfg) (((gpio_cfg) >> 17) & 0xf)
-
-int gpio_tlmm_config(unsigned config, unsigned disable);
-
 #endif /* __ASM_ARCH_MSM_GPIO_H */
-- 
1.7.0.4

/usr2/gbean/.signature.codeaurora.org
