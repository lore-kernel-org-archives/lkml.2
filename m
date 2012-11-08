Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2KHLzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:55:55 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:54968 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893Ab2KHLzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:55:53 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <arm@kernel.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] ARM: ux500: add PRCM register base for pinctrl
Date: Thu, 8 Nov 2012 12:55:31 +0100
Message-ID: <1352375731-29570-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

This adds the PRCM register range base as a resource to
the pinctrl driver do we can break the dependency to the
PRCMU driver and handle these registers in the driver
alone.

Cc: arm@kernel.org
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ARM SoC guys: this patch is better contained in the
pinctrl tree, can I have your ACK to push it through
pinctrl? Thanks.
---
 arch/arm/mach-ux500/cpu-db8500.c     | 2 +-
 arch/arm/mach-ux500/devices-common.h | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 87a8f9f..113d9c4 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -158,7 +158,7 @@ static void __init db8500_add_gpios(struct device *parent)
 
 	dbx500_add_gpios(parent, ARRAY_AND_SIZE(db8500_gpio_base),
 			 IRQ_DB8500_GPIO0, &pdata);
-	dbx500_add_pinctrl(parent, "pinctrl-db8500");
+	dbx500_add_pinctrl(parent, "pinctrl-db8500", U8500_PRCMU_BASE);
 }
 
 static int usb_db8500_rx_dma_cfg[] = {
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 7fbf0ba..96fa4ac 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -129,12 +129,18 @@ void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
 		      int irq, struct nmk_gpio_platform_data *pdata);
 
 static inline void
-dbx500_add_pinctrl(struct device *parent, const char *name)
+dbx500_add_pinctrl(struct device *parent, const char *name,
+		   resource_size_t base)
 {
+	struct resource res[] = {
+		DEFINE_RES_MEM(base, SZ_8K),
+	};
 	struct platform_device_info pdevinfo = {
 		.parent = parent,
 		.name = name,
 		.id = -1,
+		.res = res,
+		.num_res = ARRAY_SIZE(res),
 	};
 
 	platform_device_register_full(&pdevinfo);
-- 
1.7.11.3

