Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0CZUov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:44:51 -0400
Received: from fischerfamily.org ([71.216.156.246]:23883 "EHLO gw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753472Ab0CZUoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:44:44 -0400
From: Todd Fischer <todd.fischer@ridgerun.com>
To: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       todd.fischer@ridgerun.com
Subject: [PATCH 2/5]  Make room for other tps6507x drivers to have board specific initialization data.
Date: Fri, 26 Mar 2010 14:11:29 -0600
Message-Id: <1269634292-29686-3-git-send-email-todd.fischer@ridgerun.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1269634292-29686-2-git-send-email-todd.fischer@ridgerun.com>
References: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-2-git-send-email-todd.fischer@ridgerun.com>
Organization: RidgeRun
X-SA-Exim-Connect-IP: 10.0.0.3
X-SA-Exim-Mail-From: todd.fischer@ridgerun.com
X-SA-Exim-Scanned: No (on gw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need mfd structure that can hold pointers to sub-driver initialization
and run time data.

Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |    7 ++++++-
 drivers/regulator/tps6507x-regulator.c  |   12 +++++++++++-
 include/linux/mfd/tps6507x.h            |   11 +++++++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 411284d..d059924 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -17,6 +17,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c/at24.h>
 #include <linux/i2c/pca953x.h>
+#include <linux/mfd/tps6507x.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
@@ -533,10 +534,14 @@ struct regulator_init_data tps65070_regulator_data[] = {
 	},
 };
 
+static struct tps6507x_board tps_board = {
+	.tps6507x_pmic_init_data = &tps65070_regulator_data[0],
+};
+
 static struct i2c_board_info __initdata da850evm_tps65070_info[] = {
 	{
 		I2C_BOARD_INFO("tps6507x", 0x48),
-		.platform_data = &tps65070_regulator_data[0],
+		.platform_data = &tps_board,
 	},
 };
 
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 91172e3..27f4e7a 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -488,6 +488,7 @@ static int __devinit tps_6507x_probe(struct i2c_client *client,
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
 	struct tps_pmic *tps;
+	struct tps6507x_board *tps_board;
 	int i;
 	int error;
 
@@ -496,10 +497,19 @@ static int __devinit tps_6507x_probe(struct i2c_client *client,
 		return -EIO;
 
 	/**
+	 * tps_board points to pmic related constants
+	 * coming from the board-evm file.
+	 */
+
+	tps_board = (struct tps6507x_board *)client->dev.platform_data;
+	if (!tps_board)
+		return -EIO;
+
+	/**
 	 * init_data points to array of regulator_init structures
 	 * coming from the board-evm file.
 	 */
-	init_data = client->dev.platform_data;
+	init_data = tps_board->tps6507x_pmic_init_data;
 	if (!init_data)
 		return -EIO;
 
diff --git a/include/linux/mfd/tps6507x.h b/include/linux/mfd/tps6507x.h
index 155bee1..fd73af5 100644
--- a/include/linux/mfd/tps6507x.h
+++ b/include/linux/mfd/tps6507x.h
@@ -131,4 +131,15 @@
 /* VDCDC MASK */
 #define TPS6507X_DEFDCDCX_DCDC_MASK		0X3F
 
+/**
+ * struct tps6507x_board - packages regulator and touchscreen init data
+ * @tps6507x_regulator_data: regulator initialization values
+ *
+ * Board data may be used to initialize regulator and touchscreen.
+ */
+
+struct tps6507x_board {
+	struct regulator_init_data *tps6507x_pmic_init_data;
+};
+
 #endif /*  __LINUX_MFD_TPS6507X_H */
-- 
1.6.0.4

