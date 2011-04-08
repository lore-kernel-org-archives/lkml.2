Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab1DHLAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 07:00:45 -0400
Received: from smtp206.alice.it ([82.57.200.102]:34981 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1DHLAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 07:00:43 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-wireless@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
Subject: [PATCH v2] rfkill: Regulator consumer driver for rfkill
Date: Fri,  8 Apr 2011 12:59:55 +0200
Message-Id: <1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a regulator consumer driver for rfkill to enable controlling radio
transmitters connected to voltage regulators using the regulator
framework.

A new "vrfkill" virtual supply is provided to use in platform code.

Signed-off-by: Guiming Zhuo <gmzhuo@gmail.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Changes since v1:

  - changed "voltage regulator" to "voltage regulators" in the commit
    message

  - drop rfkill_init_sw_state() as requested by Johannes Berg

  - moved assignment fields of rfkill_data _before_ rfkill_register(),
    as the latter will call .set_block (via schedule_work()) which would
    find NULL pointers for the .vcc and .rf_kill fields otherwise.

    This issue was masked when I was using rfkill_init_sw_state() which
    was setting the persistent flag: rfkill_register() does not call
    schedule_work() immediately when the persistent flag is set.

    So please take another look at this part of rfkill_regulator_probe().

Mark, I left in the RFKILL || !RFKILL part.

If there are no more comments, who is going to merge the driver, Johannes?

Thanks,
   Antonio Ospite
   http://ao2.it

 include/linux/rfkill-regulator.h |   48 +++++++++++
 net/rfkill/Kconfig               |   11 +++
 net/rfkill/Makefile              |    1 +
 net/rfkill/rfkill-regulator.c    |  164 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 224 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/rfkill-regulator.h
 create mode 100644 net/rfkill/rfkill-regulator.c

diff --git a/include/linux/rfkill-regulator.h b/include/linux/rfkill-regulator.h
new file mode 100644
index 0000000..4aaef9c
--- /dev/null
+++ b/include/linux/rfkill-regulator.h
@@ -0,0 +1,48 @@
+/*
+ * rfkill-regulator.c - Regulator consumer driver for rfkill
+ *
+ * Copyright (C) 2009  Guiming Zhuo <gmzhuo@gmail.com>
+ * Copyright (C) 2011  Antonio Ospite <ospite@studenti.unina.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __LINUX_RFKILL_REGULATOR_H
+#define __LINUX_RFKILL_REGULATOR_H
+
+/*
+ * Use "vrfkill" as supply id when declaring the regulator consumer:
+ *
+ * static struct regulator_consumer_supply pcap_regulator_V6_consumers [] = {
+ * 	{ .dev_name = "rfkill-regulator.0", supply = "vrfkill" },
+ * };
+ *
+ * If you have several regulator driven rfkill, you can append a numerical id to
+ * .dev_name as done above, and use the same id when declaring the platform
+ * device:
+ *
+ * static struct rfkill_regulator_platform_data ezx_rfkill_bt_data = {
+ * 	.name  = "ezx-bluetooth",
+ * 	.type  = RFKILL_TYPE_BLUETOOTH,
+ * };
+ *
+ * static struct platform_device a910_rfkill = {
+ * 	.name  = "rfkill-regulator",
+ * 	.id    = 0,
+ * 	.dev   = {
+ * 		.platform_data = &ezx_rfkill_bt_data,
+ * 	},
+ * };
+ */
+
+#include <linux/rfkill.h>
+
+struct rfkill_regulator_platform_data {
+	char *name;             /* the name for the rfkill switch */
+	enum rfkill_type type;  /* the type as specified in rfkill.h */
+};
+
+#endif /* __LINUX_RFKILL_REGULATOR_H */
diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
index 7fce6df..48464ca 100644
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -22,3 +22,14 @@ config RFKILL_INPUT
 	depends on RFKILL
 	depends on INPUT = y || RFKILL = INPUT
 	default y if !EXPERT
+
+config RFKILL_REGULATOR
+	tristate "Generic rfkill regulator driver"
+	depends on RFKILL || !RFKILL
+	depends on REGULATOR
+	help
+          This options enable controlling radio transmitters connected to
+          voltage regulator using the regulator framework.
+
+          To compile this driver as a module, choose M here: the module will
+          be called rfkill-regulator.
diff --git a/net/rfkill/Makefile b/net/rfkill/Makefile
index 6621053..d9a5a58 100644
--- a/net/rfkill/Makefile
+++ b/net/rfkill/Makefile
@@ -5,3 +5,4 @@
 rfkill-y			+= core.o
 rfkill-$(CONFIG_RFKILL_INPUT)	+= input.o
 obj-$(CONFIG_RFKILL)		+= rfkill.o
+obj-$(CONFIG_RFKILL_REGULATOR)	+= rfkill-regulator.o
diff --git a/net/rfkill/rfkill-regulator.c b/net/rfkill/rfkill-regulator.c
new file mode 100644
index 0000000..e99567f
--- /dev/null
+++ b/net/rfkill/rfkill-regulator.c
@@ -0,0 +1,164 @@
+/*
+ * rfkill-regulator.c - Regulator consumer driver for rfkill
+ *
+ * Copyright (C) 2009  Guiming Zhuo <gmzhuo@gmail.com>
+ * Copyright (C) 2011  Antonio Ospite <ospite@studenti.unina.it>
+ *
+ * Implementation inspired by leds-regulator driver.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/rfkill.h>
+#include <linux/rfkill-regulator.h>
+
+struct rfkill_regulator_data {
+	struct rfkill *rf_kill;
+	bool reg_enabled;
+
+	struct regulator *vcc;
+};
+
+static int rfkill_regulator_set_block(void *data, bool blocked)
+{
+	struct rfkill_regulator_data *rfkill_data = data;
+
+	pr_debug("%s: blocked: %d\n", __func__, blocked);
+
+	if (blocked) {
+		if (rfkill_data->reg_enabled) {
+			regulator_disable(rfkill_data->vcc);
+			rfkill_data->reg_enabled = 0;
+		}
+	} else {
+		if (!rfkill_data->reg_enabled) {
+			regulator_enable(rfkill_data->vcc);
+			rfkill_data->reg_enabled = 1;
+		}
+	}
+
+	pr_debug("%s: regulator_is_enabled after set_block: %d\n", __func__,
+		regulator_is_enabled(rfkill_data->vcc));
+
+	return 0;
+}
+
+struct rfkill_ops rfkill_regulator_ops = {
+	.set_block = rfkill_regulator_set_block,
+};
+
+static int __devinit rfkill_regulator_probe(struct platform_device *pdev)
+{
+	struct rfkill_regulator_platform_data *pdata = pdev->dev.platform_data;
+	struct rfkill_regulator_data *rfkill_data;
+	struct regulator *vcc;
+	struct rfkill *rf_kill;
+	int ret = 0;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "no platform data\n");
+		return -ENODEV;
+	}
+
+	if (pdata->name == NULL || pdata->type == 0) {
+		dev_err(&pdev->dev, "invalid name or type in platform data\n");
+		return -EINVAL;
+	}
+
+	vcc = regulator_get_exclusive(&pdev->dev, "vrfkill");
+	if (IS_ERR(vcc)) {
+		dev_err(&pdev->dev, "Cannot get vcc for %s\n", pdata->name);
+		ret = PTR_ERR(vcc);
+		goto out;
+	}
+
+	rfkill_data = kzalloc(sizeof(*rfkill_data), GFP_KERNEL);
+	if (rfkill_data == NULL) {
+		ret = -ENOMEM;
+		goto err_data_alloc;
+	}
+
+	rf_kill = rfkill_alloc(pdata->name, &pdev->dev,
+				pdata->type,
+				&rfkill_regulator_ops, rfkill_data);
+	if (rf_kill == NULL) {
+		dev_err(&pdev->dev, "Cannot alloc rfkill device\n");
+		ret = -ENOMEM;
+		goto err_rfkill_alloc;
+	}
+
+	if (regulator_is_enabled(vcc)) {
+		dev_dbg(&pdev->dev, "Regulator already enabled\n");
+		rfkill_data->reg_enabled = 1;
+	}
+	rfkill_data->vcc = vcc;
+	rfkill_data->rf_kill = rf_kill;
+
+	ret = rfkill_register(rf_kill);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot register rfkill device\n");
+		goto err_rfkill_register;
+	}
+
+	platform_set_drvdata(pdev, rfkill_data);
+	dev_info(&pdev->dev, "initialized\n");
+
+	return 0;
+
+err_rfkill_register:
+	rfkill_destroy(rf_kill);
+err_rfkill_alloc:
+	kfree(rfkill_data);
+err_data_alloc:
+	regulator_put(vcc);
+out:
+	return ret;
+}
+
+static int __devexit rfkill_regulator_remove(struct platform_device *pdev)
+{
+	struct rfkill_regulator_data *rfkill_data = platform_get_drvdata(pdev);
+	struct rfkill *rf_kill = rfkill_data->rf_kill;
+
+	rfkill_unregister(rf_kill);
+	rfkill_destroy(rf_kill);
+	regulator_put(rfkill_data->vcc);
+	kfree(rfkill_data);
+
+	return 0;
+}
+
+static struct platform_driver rfkill_regulator_driver = {
+	.probe = rfkill_regulator_probe,
+	.remove = __devexit_p(rfkill_regulator_remove),
+	.driver = {
+		.name = "rfkill-regulator",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init rfkill_regulator_init(void)
+{
+	return platform_driver_register(&rfkill_regulator_driver);
+}
+module_init(rfkill_regulator_init);
+
+static void __exit rfkill_regulator_exit(void)
+{
+	platform_driver_unregister(&rfkill_regulator_driver);
+}
+module_exit(rfkill_regulator_exit);
+
+MODULE_AUTHOR("Guiming Zhuo <gmzhuo@gmail.com>");
+MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
+MODULE_DESCRIPTION("Regulator consumer driver for rfkill");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rfkill-regulator");
-- 
1.7.4.1

