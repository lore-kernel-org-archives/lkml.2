Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab1ERVwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:52:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42686 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1ERVvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:51:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6350"; a="91952566"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/7] msm: gpio: Remove ifdefs on gpio chip registers
Date: Wed, 18 May 2011 14:50:50 -0700
Message-Id: <1305755453-31112-5-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select the GPIO register configuration at runtime rather than through
idefs.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/gpio.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-msm/gpio.c b/arch/arm/mach-msm/gpio.c
index 335afbd..e96199d 100644
--- a/arch/arm/mach-msm/gpio.c
+++ b/arch/arm/mach-msm/gpio.c
@@ -20,6 +20,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <mach/cpu.h>
 #include "gpio_hw.h"
 #include "gpiomux.h"
 
@@ -189,15 +190,19 @@ static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
 #define msm_gpio_free NULL
 #endif
 
-struct msm_gpio_chip msm_gpio_chips[] = {
-#if defined(CONFIG_ARCH_MSM7X00A)
+static struct msm_gpio_chip *msm_gpio_chips;
+static int msm_gpio_count;
+
+static struct msm_gpio_chip msm_gpio_chips_msm7x01[] = {
 	MSM_GPIO_BANK(MSM7X00, 0,   0,  15),
 	MSM_GPIO_BANK(MSM7X00, 1,  16,  42),
 	MSM_GPIO_BANK(MSM7X00, 2,  43,  67),
 	MSM_GPIO_BANK(MSM7X00, 3,  68,  94),
 	MSM_GPIO_BANK(MSM7X00, 4,  95, 106),
 	MSM_GPIO_BANK(MSM7X00, 5, 107, 121),
-#elif defined(CONFIG_ARCH_MSM7X30)
+};
+
+static struct msm_gpio_chip msm_gpio_chips_msm7x30[] = {
 	MSM_GPIO_BANK(MSM7X30, 0,   0,  15),
 	MSM_GPIO_BANK(MSM7X30, 1,  16,  43),
 	MSM_GPIO_BANK(MSM7X30, 2,  44,  67),
@@ -206,7 +211,9 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 	MSM_GPIO_BANK(MSM7X30, 5, 107, 133),
 	MSM_GPIO_BANK(MSM7X30, 6, 134, 150),
 	MSM_GPIO_BANK(MSM7X30, 7, 151, 181),
-#elif defined(CONFIG_ARCH_QSD8X50)
+};
+
+static struct msm_gpio_chip msm_gpio_chips_qsd8x50[] = {
 	MSM_GPIO_BANK(QSD8X50, 0,   0,  15),
 	MSM_GPIO_BANK(QSD8X50, 1,  16,  42),
 	MSM_GPIO_BANK(QSD8X50, 2,  43,  67),
@@ -215,7 +222,6 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 	MSM_GPIO_BANK(QSD8X50, 5, 104, 121),
 	MSM_GPIO_BANK(QSD8X50, 6, 122, 152),
 	MSM_GPIO_BANK(QSD8X50, 7, 153, 164),
-#endif
 };
 
 static void msm_gpio_irq_ack(struct irq_data *d)
@@ -311,7 +317,7 @@ static void msm_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	int i, j, mask;
 	unsigned val;
 
-	for (i = 0; i < ARRAY_SIZE(msm_gpio_chips); i++) {
+	for (i = 0; i < msm_gpio_count; i++) {
 		struct msm_gpio_chip *msm_chip = &msm_gpio_chips[i];
 		val = readl(msm_chip->regs.int_status);
 		val &= msm_chip->int_enable[0];
@@ -342,6 +348,19 @@ static int __init msm_init_gpio(void)
 {
 	int i, j = 0;
 
+	if (cpu_is_msm7x01()) {
+		msm_gpio_chips = msm_gpio_chips_msm7x01;
+		msm_gpio_count = ARRAY_SIZE(msm_gpio_chips_msm7x01);
+	} else if (cpu_is_msm7x30()) {
+		msm_gpio_chips = msm_gpio_chips_msm7x30;
+		msm_gpio_count = ARRAY_SIZE(msm_gpio_chips_msm7x30);
+	} else if (cpu_is_qsd8x50()) {
+		msm_gpio_chips = msm_gpio_chips_qsd8x50;
+		msm_gpio_count = ARRAY_SIZE(msm_gpio_chips_qsd8x50);
+	} else {
+		return 0;
+	}
+
 	for (i = FIRST_GPIO_IRQ; i < FIRST_GPIO_IRQ + NR_GPIO_IRQS; i++) {
 		if (i - FIRST_GPIO_IRQ >=
 			msm_gpio_chips[j].chip.base +
@@ -353,7 +372,7 @@ static int __init msm_init_gpio(void)
 		set_irq_flags(i, IRQF_VALID);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(msm_gpio_chips); i++) {
+	for (i = 0; i < msm_gpio_count; i++) {
 		spin_lock_init(&msm_gpio_chips[i].lock);
 		writel(0, msm_gpio_chips[i].regs.int_en);
 		gpiochip_add(&msm_gpio_chips[i].chip);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
