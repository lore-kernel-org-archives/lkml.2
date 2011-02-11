Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1BKOiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:38:21 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:34539 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab1BKOiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:38:19 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com> (supporter:TI DAVINCI
	MACHIN...),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 06/13] da850: pruss CAN board specific additions.
Date: Fri, 11 Feb 2011 20:21:25 +0530
Message-Id: <1297435892-28278-7-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the pruss CAN pin mux and registers the device
with the pruss mfd driver.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |   37 ++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 242d1ed..2ce5536 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1053,8 +1053,43 @@ static __init int da850_evm_init_cpufreq(void)
 static __init int da850_evm_init_cpufreq(void) { return 0; }
 #endif
 
+const short da850_evm_pruss_can_pins[] = {
+	DA850_PRUSS_PRU0_R31_0, DA850_PRUSS_PRU1_R30_15,
+	DA850_PRUSS_PRU1_R31_18,
+	-1
+};
+
+static int __init da850_evm_setup_pruss_can(void)
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
+	return ret;
+}
+
+static struct da8xx_pruss_can_data can_data = {
+	.version	= 1,
+};
+
 static struct da8xx_pruss_devices pruss_devices[] = {
-	{.dev_name = NULL,},
+	{
+		.dev_name	= "da8xx_pruss_can",
+		.pdata		= &can_data,
+		.pdata_size	= sizeof(can_data),
+		.setup		= da850_evm_setup_pruss_can,
+	},
+	{
+		.dev_name	= NULL,
+	},
 };
 
 static int __init da8xx_evm_setup_pruss(void)
-- 
1.7.2.3

