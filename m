Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2AaIq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:46:28 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12506 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab2AaIqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:46:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 31 Jan 2012 00:46:25 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        gg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V1] gpio: tps65910: Add sleep control support
Date: Tue, 31 Jan 2012 14:15:12 +0530
Message-Id: <1327999512-4935-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tps65910/tps65911 supports the sleep
functionality in some of gpios. If gpio is configured
in output mode and sleep is enabled then during device
sleep state, the output of gpio becomes LOW regardless
of non-sleep output value.
Such gpio can be used to control regulator switch such
that output of regulator is off in device sleep state.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpio-tps65910.c |   16 ++++++++++++++++
 include/linux/mfd/tps65910.h |    6 ++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
index 91f45b9..ec7323a 100644
--- a/drivers/gpio/gpio-tps65910.c
+++ b/drivers/gpio/gpio-tps65910.c
@@ -69,6 +69,7 @@ static int tps65910_gpio_input(struct gpio_chip *gc, unsigned offset)
 void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
 {
 	int ret;
+	struct tps65910_board *board_data;
 
 	if (!gpio_base)
 		return;
@@ -95,6 +96,21 @@ void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
 	tps65910->gpio.set		= tps65910_gpio_set;
 	tps65910->gpio.get		= tps65910_gpio_get;
 
+	/* Configure sleep control for gpios */
+	board_data = dev_get_platdata(tps65910->dev);
+	if (board_data) {
+		int i;
+		for (i = 0; i < tps65910->gpio.ngpio; ++i) {
+			if (board_data->en_gpio_sleep[i]) {
+				ret = tps65910_set_bits(tps65910,
+					TPS65910_GPIO0 + i, GPIO_SLEEP_MASK);
+				if (ret < 0)
+					dev_warn(tps65910->dev,
+						"GPIO Sleep setting failed\n");
+			}
+		}
+	}
+
 	ret = gpiochip_add(&tps65910->gpio);
 
 	if (ret)
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index fa6c6bf..b641690 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -657,6 +657,8 @@
 
 
 /*Register GPIO  (0x80) register.RegisterDescription */
+#define GPIO_SLEEP_MASK                         0x80
+#define GPIO_SLEEP_SHIFT                        7
 #define GPIO_DEB_MASK                           0x10
 #define GPIO_DEB_SHIFT                          4
 #define GPIO_PUEN_MASK                          0x08
@@ -740,6 +742,9 @@
 #define TPS65910_GPIO_STS				BIT(1)
 #define TPS65910_GPIO_SET				BIT(0)
 
+/* Max number of TPS65910/11 GPIOs */
+#define TPS65911_NUM_GPIO				9
+
 /* Regulator Index Definitions */
 #define TPS65910_REG_VRTC				0
 #define TPS65910_REG_VIO				1
@@ -786,6 +791,7 @@ struct tps65910_board {
 	int irq_base;
 	int vmbch_threshold;
 	int vmbch2_threshold;
+	int en_gpio_sleep[TPS65911_NUM_GPIO];
 	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
 	struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
 };
-- 
1.7.1.1

