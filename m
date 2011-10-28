Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab1J1U1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:27:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33652 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab1J1U1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:27:18 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, Tony Lindgren <tony@atomide.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
        linux-omap@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] regulator: Provide dummy supply support
Date: Fri, 28 Oct 2011 22:26:58 +0200
Message-Id: <1319833618-25190-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de>
References: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have CONFIG_REGULATOR_DUMMY which provides a fallback
dummy regulator if none is found. Enabling this option shadows
real regulator_get errors though and can't be used in production.
Also there is regulator_use_dummy_regulator() which has the
same behaviour but can be used during runtime.

This patch allows a board to register dummy supplies for devices
which need a regulator but which is not software controllable
on this board.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/regulator/Makefile        |    2 +-
 drivers/regulator/dummy-supply.c  |   88 +++++++++++++++++++++++++++++++++++++
 include/linux/regulator/machine.h |   18 ++++++++
 3 files changed, 107 insertions(+), 1 deletions(-)
 create mode 100644 drivers/regulator/dummy-supply.c

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 040d5aa..ff618b9 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -3,7 +3,7 @@
 #
 
 
-obj-$(CONFIG_REGULATOR) += core.o dummy.o
+obj-$(CONFIG_REGULATOR) += core.o dummy.o dummy-supply.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
diff --git a/drivers/regulator/dummy-supply.c b/drivers/regulator/dummy-supply.c
new file mode 100644
index 0000000..4e62b1f
--- /dev/null
+++ b/drivers/regulator/dummy-supply.c
@@ -0,0 +1,88 @@
+/*
+ * dummy-supply.c
+ *
+ * Copyright 2011 Sascha Hauer <s.hauer@pengutronix.de>, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This is useful for systems with mixed controllable and
+ * non-controllable regulators, as well as for allowing testing on
+ * systems with no controllable regulators.
+ */
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+
+struct dummy_regulator {
+	struct regulator_desc desc;
+	struct regulator_init_data initdata;
+	struct regulator_dev *rdev;
+};
+
+static struct regulator_ops dummy_ops;
+
+/**
+ * regulator_register_dummy - register a dummy supply
+ *
+ * Calling this function will register a dummy regulator
+ * for devices for which no software controllable regulator
+ * is available.
+ */
+struct dummy_regulator *regulator_register_dummy(
+		struct regulator_consumer_supply *__supply,
+		int num_supplies)
+{
+	struct dummy_regulator *dummy;
+	struct regulator_consumer_supply *supply;
+
+	dummy = kzalloc(sizeof(*dummy), GFP_KERNEL);
+	if (!dummy)
+		return NULL;
+
+	dummy->desc.name = "dummy";
+	dummy->desc.id = -1;
+	dummy->desc.type = REGULATOR_VOLTAGE;
+	dummy->desc.owner = THIS_MODULE;
+	dummy->desc.ops = &dummy_ops;
+
+	supply = kzalloc(sizeof(*supply) * num_supplies, GFP_KERNEL);
+	if (!supply)
+		goto err_alloc;
+	memcpy(supply, __supply, sizeof(*supply) * num_supplies);
+
+	dummy->initdata.num_consumer_supplies = num_supplies;
+	dummy->initdata.consumer_supplies = supply,
+
+	dummy->rdev = regulator_register(&dummy->desc, NULL,
+						  &dummy->initdata, NULL);
+	if (!dummy->rdev)
+		goto err_register;
+
+	return dummy;
+
+err_register:
+	kfree(supply);
+err_alloc:
+	kfree(dummy);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(regulator_register_dummy);
+
+/**
+ * regulator_unregister_dummy - unregister a dummy supply
+ *
+ * This function unregisters a supply previously registered
+ * with regulator_register_dummy.
+ */
+void regulator_unregister_dummy(struct dummy_regulator *dummy)
+{
+	regulator_unregister(dummy->rdev);
+	kfree(dummy->initdata.consumer_supplies);
+	kfree(dummy);
+}
+EXPORT_SYMBOL_GPL(regulator_unregister_dummy);
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index ce3127a..13245cb 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -186,12 +186,20 @@ struct regulator_init_data {
 	void *driver_data;	/* core does not touch this */
 };
 
+/**
+ * cookie for regulator_register_dummy
+ */
+struct dummy_regulator;
+
 int regulator_suspend_prepare(suspend_state_t state);
 int regulator_suspend_finish(void);
 
 #ifdef CONFIG_REGULATOR
 void regulator_has_full_constraints(void);
 void regulator_use_dummy_regulator(void);
+struct dummy_regulator *regulator_register_dummy(
+		struct regulator_consumer_supply *, int);
+void regulator_unregister_dummy(struct dummy_regulator *);
 #else
 static inline void regulator_has_full_constraints(void)
 {
@@ -200,6 +208,16 @@ static inline void regulator_has_full_constraints(void)
 static inline void regulator_use_dummy_regulator(void)
 {
 }
+
+static inline struct dummy_regulator *regulator_register_dummy(
+		struct regulator_consumer_supply *, int)
+{
+	return (void *)-1;
+};
+
+void regulator_unregister_dummy(struct dummy_regulator *)
+{
+}
 #endif
 
 #endif
-- 
1.7.7

