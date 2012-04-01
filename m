Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab2DALdC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 07:33:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56048 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736Ab2DALcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 07:32:47 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <linux@arm.linux.org.uk>, Mike Turquette <mturquette@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] clkdev: Implement managed clk_get()
Date: Sun,  1 Apr 2012 12:32:40 +0100
Message-Id: <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow clk API users to simplify their cleanup paths by providing a
managed version of clk_get().

Due to the lack of a standard struct clk to look up the device from a
managed clk_put() is not provided, it would be very unusual to use this
function so it's not a big loss.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/driver-model/devres.txt |    3 +++
 drivers/clk/clkdev.c                  |   25 +++++++++++++++++++++++++
 include/linux/clk.h                   |   20 ++++++++++++++++++++
 3 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 2a596a4..3a10848 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -276,3 +276,6 @@ REGULATOR
   devm_regulator_get()
   devm_regulator_put()
   devm_regulator_bulk_get()
+
+CLOCK
+  devm_clk_get()
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 6db161f..8af1d2c 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -89,6 +89,31 @@ void clk_put(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_put);
 
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
+EXPORT_SYMBOL_GPL(devm_clk_get);
+
 void clkdev_add(struct clk_lookup *cl)
 {
 	mutex_lock(&clocks_mutex);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 4b27d15..fd96e4a 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -101,6 +101,26 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
 struct clk *clk_get(struct device *dev, const char *id);
 
 /**
+ * devm_clk_get - lookup and obtain a managed reference to a clock producer.
+ * @dev: device for clock "consumer"
+ * @id: clock comsumer ID
+ *
+ * Returns a struct clk corresponding to the clock producer, or
+ * valid IS_ERR() condition containing errno.  The implementation
+ * uses @dev and @id to determine the clock consumer, and thereby
+ * the clock producer.  (IOW, @id may be identical strings, but
+ * clk_get may return different clock producers depending on @dev.)
+ *
+ * Drivers must assume that the clock source is not enabled.
+ *
+ * devm_clk_get should not be called from within interrupt context.
+ *
+ * The clock will automatically be freed when the device is unbound
+ * from the bus.
+ */
+struct clk *devm_clk_get(struct device *dev, const char *id);
+
+/**
  * clk_prepare - prepare a clock source
  * @clk: clock source
  *
-- 
1.7.9.1

