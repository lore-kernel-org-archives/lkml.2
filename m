Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1CHJpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:45:13 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:54928 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab1CHJpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:45:09 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: [PATCH 3/3] mach-ux500: configure board for the TPS61052 regulator
Date: Tue, 8 Mar 2011 10:44:04 +0100
Message-ID: <1299577444-31480-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This registers the TPS61052 regulator to the ux500 MOP/HREF boards.

Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ola Lilja <ola.o.lilja@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   26 +++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500-regulators.h |    1 +
 arch/arm/mach-ux500/board-mop500.c            |   14 +++++++++++++
 3 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 533967c..a2cb353 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -11,6 +11,32 @@
 #include <linux/kernel.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
+#include "board-mop500-regulators.h"
+
+/*
+ * TPS61052 regulator
+ */
+static struct regulator_consumer_supply tps61052_vaudio_consumers[] = {
+	/*
+	 * Boost converter supply to raise voltage on audio speaker, this
+	 * is actually connected to three pins, VInVhfL (left amplifier)
+	 * VInVhfR (right amplifier) and VIntDClassInt - all three must
+	 * be connected to the same voltage.
+	 */
+	REGULATOR_SUPPLY("vintdclassint", "ab8500-codec.0"),
+};
+
+struct regulator_init_data tps61052_regulator = {
+	.constraints = {
+		.name = "vaudio-hf",
+		.min_uV = 4500000,
+		.max_uV = 4500000,
+		.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
+		REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = ARRAY_SIZE(tps61052_vaudio_consumers),
+	.consumer_supplies = tps61052_vaudio_consumers,
+};
 
 /* AB8500 regulators */
 struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS] = {
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 2675fae..a795cec 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -15,5 +15,6 @@
 #include <linux/regulator/ab8500.h>
 
 extern struct regulator_init_data ab8500_regulators[AB8500_NUM_REGULATORS];
+extern struct regulator_init_data tps61052_regulator;
 
 #endif
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index a393f57..1e75d7e 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -20,6 +20,7 @@
 #include <linux/spi/spi.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/tc3589x.h>
+#include <linux/mfd/tps6105x.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -114,6 +115,15 @@ static struct pl022_ssp_controller ssp0_platform_data = {
 };
 
 /*
+ * TPS61052
+ */
+
+static struct tps6105x_platform_data mop500_tps61052_data = {
+	.mode = TPS6105X_MODE_VOLTAGE,
+	.regulator_data = &tps61052_regulator,
+};
+
+/*
  * TC35892
  */
 
@@ -135,6 +145,10 @@ static struct tc3589x_platform_data mop500_tc35892_data = {
 
 static struct i2c_board_info mop500_i2c0_devices[] = {
 	{
+		I2C_BOARD_INFO("tps61052", 0x33),
+		.platform_data  = &mop500_tps61052_data,
+	},
+	{
 		I2C_BOARD_INFO("tc3589x", 0x42),
 		.irq            = NOMADIK_GPIO_TO_IRQ(217),
 		.platform_data  = &mop500_tc35892_data,
-- 
1.7.3.2

