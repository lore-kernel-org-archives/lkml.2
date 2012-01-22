Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2AVQMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 11:12:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56374 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab2AVQMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 11:12:19 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Provide devm_regulator_bulk_get()
Date: Sun, 22 Jan 2012 16:12:13 +0000
Message-Id: <1327248733-26260-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327248733-26260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1327248733-26260-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow drivers to benefit from both the bulk APIs and managed resources
simultaneously.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |   46 ++++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |    2 +
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 88bcb11..1432c22 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2463,6 +2463,52 @@ err:
 }
 EXPORT_SYMBOL_GPL(regulator_bulk_get);
 
+/**
+ * devm_regulator_bulk_get - managed get multiple regulator consumers
+ *
+ * @dev:           Device to supply
+ * @num_consumers: Number of consumers to register
+ * @consumers:     Configuration of consumers; clients are stored here.
+ *
+ * @return 0 on success, an errno on failure.
+ *
+ * This helper function allows drivers to get several regulator
+ * consumers in one operation with management, the regulators will
+ * automatically be freed when the device is unbound.  If any of the
+ * regulators cannot be acquired then any regulators that were
+ * allocated will be freed before returning to the caller.
+ */
+int devm_regulator_bulk_get(struct device *dev, int num_consumers,
+			    struct regulator_bulk_data *consumers)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < num_consumers; i++)
+		consumers[i].consumer = NULL;
+
+	for (i = 0; i < num_consumers; i++) {
+		consumers[i].consumer = devm_regulator_get(dev,
+							   consumers[i].supply);
+		if (IS_ERR(consumers[i].consumer)) {
+			ret = PTR_ERR(consumers[i].consumer);
+			dev_err(dev, "Failed to get supply '%s': %d\n",
+				consumers[i].supply, ret);
+			consumers[i].consumer = NULL;
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	for (i = 0; i < num_consumers && consumers[i].consumer; i++)
+		devm_regulator_put(consumers[i].consumer);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_bulk_get);
+
 static void regulator_bulk_enable_async(void *data, async_cookie_t cookie)
 {
 	struct regulator_bulk_data *bulk = data;
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 60c2f99..35c4283 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -148,6 +148,8 @@ int regulator_disable_deferred(struct regulator *regulator, int ms);
 
 int regulator_bulk_get(struct device *dev, int num_consumers,
 		       struct regulator_bulk_data *consumers);
+int devm_regulator_bulk_get(struct device *dev, int num_consumers,
+			    struct regulator_bulk_data *consumers);
 int regulator_bulk_enable(int num_consumers,
 			  struct regulator_bulk_data *consumers);
 int regulator_bulk_disable(int num_consumers,
-- 
1.7.7.3

