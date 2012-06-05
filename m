Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab2FEMY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:24:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57038 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178Ab2FEMY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:24:56 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] clk: Move devm_ APIs out of clkdev into HAVE_CLK
Date: Tue,  5 Jun 2012 13:24:52 +0100
Message-Id: <1338899092-7918-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the devm_ versions of the clock APIs out of clkdev into a separate
file built when HAVE_CLK is enabled so that we don't need to update all
the myriad clock API implementations.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/clk/Makefile     |    2 +-
 drivers/clk/clk-devres.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clkdev.c     |   45 ----------------------------------
 3 files changed, 62 insertions(+), 46 deletions(-)
 create mode 100644 drivers/clk/clk-devres.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index b679f11..40e6207 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,4 +1,4 @@
-
+obj-$(CONFIG_HAVE_CLK)		+= clk-devres.o
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
 				   clk-mux.o clk-divider.o clk-fixed-factor.o
diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
new file mode 100644
index 0000000..612db83
--- /dev/null
+++ b/drivers/clk/clk-devres.c
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2012 Wolfson Microelectronics plc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * devres functionality layered on top of the standard clock API.
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+static void devm_clk_release(struct device *dev, void *res)
+{
+	clk_put(*(struct clk **)res);
+}
+
+struct clk *devm_clk_get(struct device *dev, const char *id)
+{
+	struct clk **ptr, *clk;
+
+	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	clk = clk_get(dev, id);
+	if (!IS_ERR(clk)) {
+		*ptr = clk;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return clk;
+}
+EXPORT_SYMBOL(devm_clk_get);
+
+static int devm_clk_match(struct device *dev, void *res, void *data)
+{
+	struct clk **c = res;
+	if (!c || !*c) {
+		WARN_ON(!c || !*c);
+		return 0;
+	}
+	return *c == data;
+}
+
+void devm_clk_put(struct device *dev, struct clk *clk)
+{
+	int ret;
+
+	ret = devres_release(dev, devm_clk_release, devm_clk_match, clk);
+
+	WARN_ON(ret);
+}
+EXPORT_SYMBOL(devm_clk_put);
+
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index c7a4eee..16543af 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -94,51 +94,6 @@ void clk_put(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_put);
 
-static void devm_clk_release(struct device *dev, void *res)
-{
-	clk_put(*(struct clk **)res);
-}
-
-struct clk *devm_clk_get(struct device *dev, const char *id)
-{
-	struct clk **ptr, *clk;
-
-	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return ERR_PTR(-ENOMEM);
-
-	clk = clk_get(dev, id);
-	if (!IS_ERR(clk)) {
-		*ptr = clk;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
-	}
-
-	return clk;
-}
-EXPORT_SYMBOL(devm_clk_get);
-
-static int devm_clk_match(struct device *dev, void *res, void *data)
-{
-	struct clk **c = res;
-	if (!c || !*c) {
-		WARN_ON(!c || !*c);
-		return 0;
-	}
-	return *c == data;
-}
-
-void devm_clk_put(struct device *dev, struct clk *clk)
-{
-	int ret;
-
-	ret = devres_release(dev, devm_clk_release, devm_clk_match, clk);
-
-	WARN_ON(ret);
-}
-EXPORT_SYMBOL(devm_clk_put);
-
 void clkdev_add(struct clk_lookup *cl)
 {
 	mutex_lock(&clocks_mutex);
-- 
1.7.10

