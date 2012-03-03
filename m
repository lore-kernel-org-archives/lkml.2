Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab2CCLk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:40:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50124 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab2CCLkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:40:19 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        Estevam Fabio-R49496 <r49496@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/4] regulator: provide a helper for registering a fixed regulator
Date: Sat,  3 Mar 2012 12:40:02 +0100
Message-Id: <1330774804-7310-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices require a regulator to work, but boards may not have
a software controllable regulator for this device. Provide a helper
function to make it simpler for these boards to register a fixed
regulator as a dummy regulator.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/regulator/Makefile       |    2 +-
 drivers/regulator/fixed-helper.c |   53 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/fixed.h  |   13 +++++++++
 3 files changed, 67 insertions(+), 1 deletions(-)
 create mode 100644 drivers/regulator/fixed-helper.c

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 503bac8..f76deb9 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -3,7 +3,7 @@
 #
 
 
-obj-$(CONFIG_REGULATOR) += core.o dummy.o
+obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o
 obj-$(CONFIG_OF) += of_regulator.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
diff --git a/drivers/regulator/fixed-helper.c b/drivers/regulator/fixed-helper.c
new file mode 100644
index 0000000..30d0a15
--- /dev/null
+++ b/drivers/regulator/fixed-helper.c
@@ -0,0 +1,53 @@
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
+
+struct fixed_regulator_data {
+	struct fixed_voltage_config cfg;
+	struct regulator_init_data init_data;
+	struct platform_device pdev;
+};
+
+static void regulator_fixed_release(struct device *dev)
+{
+	struct fixed_regulator_data *data = container_of(dev,
+			struct fixed_regulator_data, pdev.dev);
+	kfree(data);
+}
+
+/**
+ * regulator_register_fixed - register a no-op fixed regulator
+ * @name: supply name
+ * @id: platform device id
+ * @supplies: consumers for this regulator
+ * @num_supplies: number of consumers
+ */
+struct platform_device *regulator_register_fixed(int id,
+		struct regulator_consumer_supply *supplies, int num_supplies)
+{
+	struct fixed_regulator_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	data->cfg.supply_name = "dummy";
+	data->cfg.microvolts = 0;
+	data->cfg.gpio = -EINVAL;
+	data->cfg.enabled_at_boot = 1;
+	data->cfg.init_data = &data->init_data;
+
+	data->init_data.constraints.always_on = 1;
+	data->init_data.consumer_supplies = supplies;
+	data->init_data.num_consumer_supplies = num_supplies;
+
+	data->pdev.name = "reg-fixed-voltage";
+	data->pdev.id = id;
+	data->pdev.dev.platform_data = &data->cfg;
+	data->pdev.dev.release = regulator_fixed_release;
+
+	platform_device_register(&data->pdev);
+
+	return &data->pdev;
+}
diff --git a/include/linux/regulator/fixed.h b/include/linux/regulator/fixed.h
index ffd7d50..936a7d8 100644
--- a/include/linux/regulator/fixed.h
+++ b/include/linux/regulator/fixed.h
@@ -48,4 +48,17 @@ struct fixed_voltage_config {
 	struct regulator_init_data *init_data;
 };
 
+struct regulator_consumer_supply;
+
+#if IS_ENABLED(CONFIG_REGULATOR)
+struct platform_device *regulator_register_fixed(int id,
+		struct regulator_consumer_supply *supplies, int num_supplies);
+#else
+static inline struct platform_device *regulator_register_fixed(int id,
+		struct regulator_consumer_supply *supplies, int num_supplies)
+{
+	return NULL;
+}
+#endif
+
 #endif
-- 
1.7.9.1

