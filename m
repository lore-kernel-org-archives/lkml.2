Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab1D0Nl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:41:28 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:42689 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393Ab1D0Nl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:41:27 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/10] gpio/nomadik-gpio: work with all machines
Date: Wed, 27 Apr 2011 15:14:20 +0200
Message-ID: <1303910060-3538-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The old NHK8815 machine does not have sleepmode, and it does not
have the magic machine-specific cpu_is_u8500v2() macro either.
Use platform data to pass in sleeping capability instead so we
can compile for NHK8815.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/cpu-db8500.c |    3 +++
 drivers/gpio/nomadik-gpio.c      |   13 +++++++++++--
 include/linux/gpio/nomadik.h     |    1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index f87f37c..69b4f00 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -152,6 +152,9 @@ static void __init db8500_add_gpios(void)
 		/* No custom data yet */
 	};
 
+	if (cpu_is_u8500v2())
+		pdata.supports_sleepmode = true;
+
 	dbx500_add_gpios(ARRAY_AND_SIZE(db8500_gpio_base),
 			 IRQ_DB8500_GPIO0, &pdata);
 }
diff --git a/drivers/gpio/nomadik-gpio.c b/drivers/gpio/nomadik-gpio.c
index dd2d728..b30b6a2 100644
--- a/drivers/gpio/nomadik-gpio.c
+++ b/drivers/gpio/nomadik-gpio.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2008,2009 STMicroelectronics
  * Copyright (C) 2009 Alessandro Rubini <rubini@unipv.it>
  *   Rewritten based on work by Prafulla WADASKAR <prafulla.wadaskar@st.com>
+ * Copyright (C) 2011 Linus Walleij <linus.walleij@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -48,6 +49,7 @@ struct nmk_gpio_chip {
 	u32 (*get_secondary_status)(unsigned int bank);
 	void (*set_ioforce)(bool enable);
 	spinlock_t lock;
+	bool sleepmode;
 	/* Keep track of configured edges */
 	u32 edge_rising;
 	u32 edge_falling;
@@ -568,6 +570,12 @@ static void __nmk_gpio_irq_modify(struct nmk_gpio_chip *nmk_chip,
 static void __nmk_gpio_set_wake(struct nmk_gpio_chip *nmk_chip,
 				int gpio, bool on)
 {
+	if (nmk_chip->sleepmode) {
+		__nmk_gpio_set_slpm(nmk_chip, gpio - nmk_chip->chip.base,
+				    on ? NMK_GPIO_SLPM_WAKEUP_ENABLE
+				    : NMK_GPIO_SLPM_WAKEUP_DISABLE);
+	}
+
 	__nmk_gpio_irq_modify(nmk_chip, gpio, WAKE, on);
 }
 
@@ -1001,7 +1009,7 @@ void nmk_gpio_wakeups_suspend(void)
 		writel(chip->fwimsc & chip->real_wake,
 		       chip->addr + NMK_GPIO_FWIMSC);
 
-		if (cpu_is_u8500v2()) {
+		if (chip->sleepmode) {
 			chip->slpm = readl(chip->addr + NMK_GPIO_SLPC);
 
 			/* 0 -> wakeup enable */
@@ -1027,7 +1035,7 @@ void nmk_gpio_wakeups_resume(void)
 		writel(chip->rwimsc, chip->addr + NMK_GPIO_RWIMSC);
 		writel(chip->fwimsc, chip->addr + NMK_GPIO_FWIMSC);
 
-		if (cpu_is_u8500v2())
+		if (chip->sleepmode)
 			writel(chip->slpm, chip->addr + NMK_GPIO_SLPC);
 
 		clk_disable(chip->clk);
@@ -1114,6 +1122,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 	nmk_chip->secondary_parent_irq = secondary_irq;
 	nmk_chip->get_secondary_status = pdata->get_secondary_status;
 	nmk_chip->set_ioforce = pdata->set_ioforce;
+	nmk_chip->sleepmode = pdata->supports_sleepmode;
 	spin_lock_init(&nmk_chip->lock);
 
 	chip = &nmk_chip->chip;
diff --git a/include/linux/gpio/nomadik.h b/include/linux/gpio/nomadik.h
index 539dda8..cc956d1 100644
--- a/include/linux/gpio/nomadik.h
+++ b/include/linux/gpio/nomadik.h
@@ -81,6 +81,7 @@ struct nmk_gpio_platform_data {
 	int num_gpio;
 	u32 (*get_secondary_status)(unsigned int bank);
 	void (*set_ioforce)(bool enable);
+	bool supports_sleepmode;
 };
 
 #endif
-- 
1.7.3.2

