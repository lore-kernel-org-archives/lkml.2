Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab2HOXou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:44:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55547 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2HOXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:44:21 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <shawn.guo@linaro.org>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <viresh.kumar@linaro.org>, <rnayak@ti.com>,
        <paul@pwsan.com>, <broonie@opensource.wolfsonmicro.com>,
        <ccross@android.com>, <linux-arm-kernel@lists.infradead.org>,
        <myungjoo.ham@samsung.com>, <rajagopal.venkat@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 2/4] [RFC] clk: notifier handler for dynamic voltage scaling
Date: Wed, 15 Aug 2012 16:43:32 -0700
Message-ID: <1345074214-17531-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
References: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic voltage and frequency scaling (dvfs) is a common power saving
technique in many of today's modern processors.  This patch introduces a
common clk rate-change notifier handler which scales voltage
appropriately whenever clk_set_rate is called on an affected clock.

There are three prerequisites to using this feature:

1) the affected clocks must be using the common clk framework
2) voltage must be scaled using the regulator framework
3) clock frequency and regulator voltage values must be paired via the
OPP library

If your platform or device meets these requirements then using the
notifier handler is easy.  A struct device is used as the basis for
performing initial look-ups for clocks via clk_get and regulators via
regulator_get.  This means that notifiers and subscribed on a per-device
basis and multiple devices can have notifiers subscribed to the same
clock.  Put another way, the voltage chosen for a rail during a call to
clk_set_rate is a function of the device, not the clock.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Makefile |    3 +-
 drivers/clk/dvfs.c   |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h  |   27 +++++++++++-
 3 files changed, 144 insertions(+), 2 deletions(-)
 create mode 100644 drivers/clk/dvfs.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 02ffdf6..8f1faa0 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,7 +1,8 @@
 # common clock types
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
-				   clk-mux.o clk-divider.o clk-fixed-factor.o
+				   clk-mux.o clk-divider.o clk-fixed-factor.o \
+				   dvfs.o
 # SoCs specific
 obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs/
diff --git a/drivers/clk/dvfs.c b/drivers/clk/dvfs.c
new file mode 100644
index 0000000..9f5d1ba
--- /dev/null
+++ b/drivers/clk/dvfs.c
@@ -0,0 +1,116 @@
+/*
+ * Copyright (C) 2011-2012 Linaro Ltd <mturquette@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Helper functions for dynamic voltage & frequency transitions using
+ * the OPP library.
+ */
+
+#include <linux/clk.h>
+#include <linux/regulator/consumer.h>
+#include <linux/opp.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+/*
+ * XXX clk, regulator & tolerance should be stored in the OPP table?
+ */
+struct dvfs_info {
+	struct device *dev;
+	struct clk *clk;
+	struct regulator *reg;
+	int tol;
+	/* FIXME struct device_opp *dev_opp */
+	struct notifier_block nb;
+};
+
+#define to_dvfs_info(_nb) container_of(_nb, struct dvfs_info, nb)
+
+static int dvfs_clk_notifier_handler(struct notifier_block *nb,
+		unsigned long flags, void *data)
+{
+	struct clk_notifier_data *cnd = data;
+	struct dvfs_info *di = to_dvfs_info(nb);
+	int ret, volt_new, volt_old;
+	struct opp *opp;
+
+	volt_old = regulator_get_voltage(di->reg);
+	opp = opp_find_freq_floor(di->dev, &cnd->new_rate);
+	volt_new = opp_get_voltage(opp);
+
+	/* scaling up?  scale voltage before frequency */
+	if (flags & PRE_RATE_CHANGE && cnd->new_rate > cnd->old_rate) {
+		dev_dbg(di->dev, "%s: %d mV --> %d mV\n",
+				__func__, volt_old, volt_new);
+
+		ret = regulator_set_voltage_tol(di->reg, volt_new, di->tol);
+
+		if (ret) {
+			dev_warn(di->dev, "%s: unable to scale voltage up.\n",
+				 __func__);
+			return notifier_from_errno(ret);
+		}
+	}
+
+	/* scaling down?  scale voltage after frequency */
+	if (flags & POST_RATE_CHANGE && cnd->new_rate < cnd->old_rate) {
+		dev_dbg(di->dev, "%s: %d mV --> %d mV\n",
+				__func__, volt_old, volt_new);
+
+		ret = regulator_set_voltage_tol(di->reg, volt_new, di->tol);
+
+		if (ret) {
+			dev_warn(di->dev, "%s: unable to scale voltage down.\n",
+				 __func__);
+			return notifier_from_errno(ret);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+struct dvfs_info *dvfs_clk_notifier_register(struct dvfs_info_init *dii)
+{
+	struct dvfs_info *di;
+	int ret = 0;
+
+	if (!dii)
+		return ERR_PTR(-EINVAL);
+
+	di = kzalloc(sizeof(struct dvfs_info), GFP_KERNEL);
+	if (!di)
+		return ERR_PTR(-ENOMEM);
+
+	di->dev = dii->dev;
+	di->clk = clk_get(di->dev, dii->con_id);
+	if (IS_ERR(di->clk))
+		return ERR_PTR(-ENOMEM);
+	di->reg = regulator_get(di->dev, dii->reg_id);
+	if (IS_ERR(di->reg))
+		return ERR_PTR(-ENOMEM);
+	di->tol = dii->tol;
+	di->nb.notifier_call = dvfs_clk_notifier_handler;
+
+	ret = clk_notifier_register(di->clk, &di->nb);
+
+	if (ret) {
+		kfree(di);
+		return ERR_PTR(ret);
+	}
+
+	return di;
+}
+EXPORT_SYMBOL_GPL(dvfs_clk_notifier_register);
+
+void dvfs_clk_notifier_unregister(struct dvfs_info *di)
+{
+	clk_notifier_unregister(di->clk, &di->nb);
+	clk_put(di->clk);
+	regulator_put(di->reg);
+	kfree(di);
+}
+EXPORT_SYMBOL_GPL(dvfs_clk_notifier_unregister);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 6587b52..643376b 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -78,9 +78,34 @@ struct clk_notifier_data {
 	unsigned long		new_rate;
 };
 
-int clk_notifier_register(struct clk *clk, struct notifier_block *nb);
+/**
+ * struct dvfs_info_init - data needs to initialize struct dvfs_info
+ * @dev:	device related to this frequency-voltage pair
+ * @con_id:	string name of clock connection
+ * @reg_id:	string name of regulator
+ * @tol:	voltage tolerance for this device
+ *
+ * Provides the data needed to register a common dvfs sequence in a clk
+ * notifier handler.  The clk and regulator lookups are stored in a
+ * private struct and the notifier handler is registered with the clk
+ * framework with a call to dvfs_clk_notifier_register.
+ *
+ * FIXME stuffing @tol here is a hack.  It belongs in the opp table.
+ * Maybe clk & regulator will also live in the opp table some day.
+ */
+struct dvfs_info_init {
+	struct device *dev;
+	const char *con_id;
+	const char *reg_id;
+	int tol;
+};
+
+struct dvfs_info;
 
+int clk_notifier_register(struct clk *clk, struct notifier_block *nb);
 int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
+struct dvfs_info *dvfs_clk_notifier_register(struct dvfs_info_init *dii);
+void dvfs_clk_notifier_unregister(struct dvfs_info *di);
 
 #endif
 
-- 
1.7.9.5

