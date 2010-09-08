Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0IHPb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:31:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51024 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0IHPbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:31:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6098"; a="53768826"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 2/2 v3] msm: gpio: Add gpiomux calls to request and free.
Date: Wed,  8 Sep 2010 08:31:47 -0700
Message-Id: <1283959907-8159-2-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283959907-8159-1-git-send-email-gbean@codeaurora.org>
References: <1283959907-8159-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpiomux get and put calls to msmgpio request and free,
in order to allow gpio lines to be properly reference-counted
and power-managed.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/gpio.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/gpio.c b/arch/arm/mach-msm/gpio.c
index 5040f1c..33051b5 100644
--- a/arch/arm/mach-msm/gpio.c
+++ b/arch/arm/mach-msm/gpio.c
@@ -21,6 +21,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include "gpio_hw.h"
+#include "gpiomux.h"
 
 #define FIRST_GPIO_IRQ MSM_GPIO_TO_INT(0)
 
@@ -44,6 +45,8 @@
 			.direction_input = msm_gpio_direction_input,	\
 			.direction_output = msm_gpio_direction_output,	\
 			.to_irq = msm_gpio_to_irq,			\
+			.request = msm_gpio_request,			\
+			.free = msm_gpio_free,				\
 		}							\
 	}
 
@@ -171,6 +174,21 @@ static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	return MSM_GPIO_TO_INT(chip->base + offset);
 }
 
+#ifdef CONFIG_MSM_GPIOMUX
+static int msm_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return msm_gpiomux_get(chip->base + offset);
+}
+
+static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	msm_gpiomux_put(chip->base + offset);
+}
+#else
+#define msm_gpio_request NULL
+#define msm_gpio_free NULL
+#endif
+
 struct msm_gpio_chip msm_gpio_chips[] = {
 #if defined(CONFIG_ARCH_MSM7X00A)
 	MSM_GPIO_BANK(0,   0,  15),
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
