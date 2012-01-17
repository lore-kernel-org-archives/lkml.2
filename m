Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab2AQDkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 22:40:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37148 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2AQDkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 22:40:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6591"; a="155528643"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] regulator: Add devm_regulator_get()
Date: Mon, 16 Jan 2012 19:39:58 -0800
Message-Id: <1326771598-28124-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a resource managed regulator_get() to simplify regulator
usage in drivers. This allows driver authors to "get and forget"
about their regulators by automatically calling regulator_put()
when the driver is detached.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/driver-model/devres.txt |    3 +++
 drivers/regulator/core.c              |   33 +++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h    |    7 +++++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 10c64c8..016fd2b 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -267,3 +267,6 @@ IOMAP
   pcim_iounmap()
   pcim_iomap_table()	: array of mapped addresses indexed by BAR
   pcim_iomap_regions()	: do request_region() and iomap() on multiple BARs
+
+REGULATOR
+  devm_regulator_get()
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ca86f39..b05b058 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1320,6 +1320,39 @@ struct regulator *regulator_get(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(regulator_get);
 
+static void devm_regulator_release(struct device *dev, void *res)
+{
+	regulator_put(*(struct regulator **)res);
+}
+
+/**
+ * devm_regulator_get - Resource managed regulator_get()
+ * @dev: device for regulator "consumer"
+ * @id: Supply name or regulator ID.
+ *
+ * Managed regulator_get(). Regulators returned from this function are
+ * automatically regulator_put() on driver detach. See regulator_get() for more
+ * information.
+ */
+struct regulator *devm_regulator_get(struct device *dev, const char *id)
+{
+	struct regulator **ptr, *regulator;
+
+	ptr = devres_alloc(devm_regulator_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	regulator = regulator_get(dev, id);
+	if (!IS_ERR(regulator)) {
+		*ptr = regulator;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return regulator;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_get);
+
 /**
  * regulator_get_exclusive - obtain exclusive access to a regulator.
  * @dev: device for regulator "consumer"
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f2698a0..bbe45b0 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -132,6 +132,8 @@ struct regulator_bulk_data {
 /* regulator get and put */
 struct regulator *__must_check regulator_get(struct device *dev,
 					     const char *id);
+struct regulator *__must_check devm_regulator_get(struct device *dev,
+					     const char *id);
 struct regulator *__must_check regulator_get_exclusive(struct device *dev,
 						       const char *id);
 void regulator_put(struct regulator *regulator);
@@ -200,6 +202,11 @@ static inline struct regulator *__must_check regulator_get(struct device *dev,
 	 */
 	return NULL;
 }
+static inline struct regulator *__must_check
+devm_regulator_get(struct device *dev, const char *id)
+{
+	return NULL;
+}
 static inline void regulator_put(struct regulator *regulator)
 {
 }
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

