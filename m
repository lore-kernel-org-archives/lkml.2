Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab2ATLJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:09:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12791 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2ATLJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:09:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 20 Jan 2012 03:09:55 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: sameo@linux.intel.com, jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] mfd: tps65910: Add wakeup support
Date: Fri, 20 Jan 2012 16:39:30 +0530
Message-Id: <1327057770-6688-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding wakeup support for PMIC device 65910. This can be
selected through the board specific platform data.

The wakeup should enabled if PMIC need to be configure for
waking up system through RTC or ONKEY.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch will enable the wakeup functionality through
device tps65910/tps65911.

 drivers/mfd/tps65910-irq.c   |    9 +++++++++
 drivers/mfd/tps65910.c       |    1 +
 include/linux/mfd/tps65910.h |    2 ++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index a56be93..8b6f423 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -210,6 +210,15 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 	if (ret != 0)
 		dev_err(tps65910->dev, "Failed to request IRQ: %d\n", ret);
 
+	if (!ret && pdata->en_wakeup) {
+		device_init_wakeup(tps65910->dev, 1);
+		ret = enable_irq_wake(irq);
+		if (ret < 0)
+			dev_warn(tps65910->dev, "Can't enable IRQ as wake "
+				"source: %d\n", ret);
+		return 0;
+	}
+
 	return ret;
 }
 
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 8517481..88e3dec 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -169,6 +169,7 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	init_data->irq = pmic_plat_data->irq;
 	init_data->irq_base = pmic_plat_data->irq_base;
+	init_data->en_wakeup = pmic_plat_data->en_wakeup;
 
 	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index d0cb12e..ba8eb6a 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -777,6 +777,7 @@ struct tps65910_board {
 	int gpio_base;
 	int irq;
 	int irq_base;
+	int en_wakeup;
 	int vmbch_threshold;
 	int vmbch2_threshold;
 	struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
@@ -813,6 +814,7 @@ struct tps65910 {
 struct tps65910_platform_data {
 	int irq;
 	int irq_base;
+	int en_wakeup;
 };
 
 int tps65910_set_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
-- 
1.7.1.1

