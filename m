Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1DVLuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:50:08 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:36924 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1DVLuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:50:02 -0400
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@ti.com> (supporter:TI DAVINCI MACHIN...),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 11/11] da850: pruss CAN board specific additions.
Date: Fri, 22 Apr 2011 17:38:29 +0530
Message-Id: <1303474109-6212-12-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the pruss CAN pinmux and registers the device
with the pruss mfd driver.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |   46 +++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index e7fdf31..e1ff18c 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -48,6 +48,7 @@
 
 #define DA850_MMCSD_CD_PIN		GPIO_TO_PIN(4, 0)
 #define DA850_MMCSD_WP_PIN		GPIO_TO_PIN(4, 1)
+#define DA850_PRUSS_CAN_TRX_PIN		GPIO_TO_PIN(2, 0)
 
 #define DA850_MII_MDIO_CLKEN_PIN	GPIO_TO_PIN(2, 6)
 
@@ -1117,6 +1118,43 @@ static __init int da850_evm_init_cpufreq(void)
 static __init int da850_evm_init_cpufreq(void) { return 0; }
 #endif
 
+static const short da850_evm_pruss_can_pins[] = {
+	DA850_PRUSS_PRU0_R31_0, DA850_PRUSS_PRU1_R30_15,
+	DA850_PRUSS_PRU1_R31_18, DA850_GPIO2_0,
+	-1
+};
+
+static int __init da850_evm_pruss_can_setup(void)
+{
+	int ret, val = 0;
+	void __iomem *cfg_chip3_reg;
+
+	ret = davinci_cfg_reg_list(da850_evm_pruss_can_pins);
+	if (ret)
+		pr_warning("%s: da850_evm_pruss_can_pins mux setup "
+					"failed:%d\n", __func__, ret);
+	cfg_chip3_reg = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG);
+	val = __raw_readl(cfg_chip3_reg);
+	val |= BIT(3);
+	__raw_writel(val, cfg_chip3_reg);
+
+	/* value = 0 to enable the CAN transceiver */
+	ret = gpio_request_one(DA850_PRUSS_CAN_TRX_PIN,
+			GPIOF_OUT_INIT_LOW, "pruss_can_en");
+	if (ret) {
+		pr_warning("Cannot setup GPIO %d\n", DA850_PRUSS_CAN_TRX_PIN);
+		gpio_free(DA850_PRUSS_CAN_TRX_PIN);
+	}
+
+	return ret;
+}
+
+static struct da850_evm_pruss_can_data can_data = {
+	.version	= 1,
+	.setup		= da850_evm_pruss_can_setup,
+};
+
+
 static const short da850_evm_pruss_suart_pins[] = {
 	DA850_AHCLKX, DA850_ACLKX, DA850_AFSX,
 	DA850_AHCLKR, DA850_ACLKR, DA850_AFSR,
@@ -1161,6 +1199,14 @@ static struct mfd_cell cell[] = {
 		.resources	= da850_evm_pruss_suart_resource,
 	},
 	{
+		.id		= 1,
+		.name		= "da8xx_pruss_can",
+		.platform_data	= &can_data,
+		.data_size	= sizeof(can_data),
+		.num_resources  = 0,
+		.resources	= NULL,
+	},
+	{
 		.name		= NULL,
 	},
 };
-- 
1.7.2.3

