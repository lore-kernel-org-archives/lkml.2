Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2DXXgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:36:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16900 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2DXXgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:36:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Apr 2012 16:36:09 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/8 v2] regulator: add generic of node parsing for regulators
Date: Tue, 24 Apr 2012 16:36:03 -0700
Message-ID: <1335310570-12455-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
References: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As more regulators are moved to support dt, more drivers are going to need
to do lookups to find nodes associated with specific regulators. Add this
helper function which will find all the regulator_init_data for a series of
regulators and do some minimal dt validation checks.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 v2: split off from tps65910 particular code to a more generic form based
     on initial reviews.

 drivers/regulator/of_regulator.c       |   42 ++++++++++++++++++++++++++++++++
 include/linux/regulator/of_regulator.h |    9 +++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 679734d..45a5f85 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -85,3 +85,45 @@ struct regulator_init_data *of_get_regulator_init_data(struct device *dev,
 	return init_data;
 }
 EXPORT_SYMBOL_GPL(of_get_regulator_init_data);
+
+/**
+ * of_find_regulator_init_data_from_device - extract all regulator_init_data
+ * @dev: device requesting for regulator_init_data
+ * @node: device node from which to look for the regulators
+ * @names: array of the names of the regulators for which to look for nodes
+ * @init_data: array of regulator_init_data structure pointers to populate
+ * @num_regulators: the max number of regulators expected
+ *
+ * This function populates the array of regulator_init_data structures by
+ * finding the device_nodes which respresent each regulator and extracting
+ * data. Returns 0 on success.
+ */
+int of_find_regulator_init_data_from_device(struct device *dev,
+	struct device_node *node, const char * const names[],
+	struct regulator_init_data **init_data, int num_regulators)
+{
+	struct device_node *child = NULL;
+	int idx = 0;
+
+	if (!dev || !node)
+		return -EINVAL;
+
+	for (idx = 0; idx < num_regulators; idx++) {
+		struct device_node *np = of_find_node_by_name(node, names[idx]);
+
+		/* didn't find a match, thats fine */
+		if (!np)
+			continue;
+
+		/* parse regulator init data from node */
+		init_data[idx] = of_get_regulator_init_data(dev, np);
+		if (!init_data[idx]) {
+			dev_err(dev, "failed to parse dt for regulator %s\n",
+				child->name);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_find_regulator_init_data_from_device);
diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
index 769704f..0c65dcb 100644
--- a/include/linux/regulator/of_regulator.h
+++ b/include/linux/regulator/of_regulator.h
@@ -10,6 +10,9 @@
 extern struct regulator_init_data
 	*of_get_regulator_init_data(struct device *dev,
 				    struct device_node *node);
+extern int of_find_regulator_init_data_from_device(struct device *dev,
+	struct device_node *node, const char * const names[],
+	struct regulator_init_data **init_data, int num_regulators);
 #else
 static inline struct regulator_init_data
 	*of_get_regulator_init_data(struct device *dev,
@@ -17,6 +20,12 @@ static inline struct regulator_init_data
 {
 	return NULL;
 }
+static inline int of_find_regulator_init_data_from_device(struct device *dev,
+	struct device_node *node, const char * const names[],
+	struct regulator_init_data **init_data, int num_regulators)
+{
+	return 0;
+}
 #endif /* CONFIG_OF */
 
 #endif /* __LINUX_OF_REG_H */
-- 
1.7.0.4

