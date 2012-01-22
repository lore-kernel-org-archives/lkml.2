Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab2AVQMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 11:12:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56373 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897Ab2AVQMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 11:12:19 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Implement devm_regulator_free()
Date: Sun, 22 Jan 2012 16:12:12 +0000
Message-Id: <1327248733-26260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow consumers to free regulators allocated using devm_regulator_get()
if they need to. This will not normally be required.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |   28 ++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 214640d..88bcb11 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1421,6 +1421,34 @@ void regulator_put(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(regulator_put);
 
+static int devm_regulator_match(struct device *dev, void *res, void *data)
+{
+	struct regulator **r = res;
+	if (!r || !*r) {
+		WARN_ON(!r || !*r);
+		return 0;
+	}
+	return *r == data;
+}
+
+/**
+ * devm_regulator_put - Resource managed regulator_put()
+ * @regulator: regulator to free
+ *
+ * Deallocate a regulator allocated with devm_regulator_get(). Normally
+ * this function will not need to be called and the resource management
+ * code will ensure that the resource is freed.
+ */
+void devm_regulator_put(struct regulator *regulator)
+{
+	int rc;
+
+	rc = devres_destroy(regulator->dev, devm_regulator_release,
+			    devm_regulator_match, regulator);
+	WARN_ON(rc);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_put);
+
 static int _regulator_can_change_status(struct regulator_dev *rdev)
 {
 	if (!rdev->constraints)
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index bcfe106..60c2f99 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -137,6 +137,7 @@ struct regulator *__must_check devm_regulator_get(struct device *dev,
 struct regulator *__must_check regulator_get_exclusive(struct device *dev,
 						       const char *id);
 void regulator_put(struct regulator *regulator);
+void devm_regulator_free(struct regulator *regulator);
 
 /* regulator output control and status */
 int regulator_enable(struct regulator *regulator);
-- 
1.7.7.3

