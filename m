Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab2ACHWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:22:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22690 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2ACHWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:22:22 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-bb-4f02acabf3f8
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Subject: [PATCH] regulator: add regulator_bulk_force_disable function
Date: Tue, 03 Jan 2012 16:22:03 +0900
Message-id: <1325575323-15500-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows consumers to forcibly disable multiple regulator
clients in a single API call.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/core.c           |   37 ++++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |    8 +++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 938398f..31a5d29 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2429,6 +2429,43 @@ err:
 EXPORT_SYMBOL_GPL(regulator_bulk_disable);
 
 /**
+ * regulator_bulk_force_disable - force disable multiple regulator consumers
+ *
+ * @num_consumers: Number of consumers
+ * @consumers:     Consumer data; clients are stored here.
+ * @return         0 on success, an errno on failure
+ *
+ * This convenience API allows consumers to forcibly disable multiple regulator
+ * clients in a single API call.
+ * NOTE: This should be used for situations when device damage will
+ * likely occur if the regulators are not disabled (e.g. over temp).
+ * Although regulator_force_disable function call for some consumers can
+ * return error numbers, the function is called for all consumers.
+ */
+int regulator_bulk_force_disable(int num_consumers,
+			   struct regulator_bulk_data *consumers)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < num_consumers; i++)
+		consumers[i].ret =
+			    regulator_force_disable(consumers[i].consumer);
+
+	for (i = 0; i < num_consumers; i++) {
+		if (consumers[i].ret != 0) {
+			ret = consumers[i].ret;
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_bulk_force_disable);
+
+/**
  * regulator_bulk_free - free multiple regulator consumers
  *
  * @num_consumers: Number of consumers
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f7756d1..442c7f5 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -149,6 +149,8 @@ int regulator_bulk_enable(int num_consumers,
 			  struct regulator_bulk_data *consumers);
 int regulator_bulk_disable(int num_consumers,
 			   struct regulator_bulk_data *consumers);
+int regulator_bulk_force_disable(int num_consumers,
+			   struct regulator_bulk_data *consumers);
 void regulator_bulk_free(int num_consumers,
 			 struct regulator_bulk_data *consumers);
 
@@ -242,6 +244,12 @@ static inline int regulator_bulk_disable(int num_consumers,
 	return 0;
 }
 
+static inline int regulator_bulk_force_disable(int num_consumers,
+					struct regulator_bulk_data *consumers)
+{
+	return 0;
+}
+
 static inline void regulator_bulk_free(int num_consumers,
 				       struct regulator_bulk_data *consumers)
 {
-- 
1.7.4.1

