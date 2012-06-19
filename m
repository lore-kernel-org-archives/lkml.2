Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2FSGBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:01:45 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4040 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab2FSGBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:01:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 18 Jun 2012 23:01:35 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <swarren@wwwdotorg.org>
CC: <sameo@linux.intel.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] regulator: support for regulator match by regulator-compatible
Date: Tue, 19 Jun 2012 11:21:26 +0530
Message-ID: <1340085087-6608-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340085087-6608-1-git-send-email-ldewangan@nvidia.com>
References: <1340085087-6608-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add API to match the chip regulator's id by the
property of "regulator-compatible" on regulator node.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/of_regulator.c       |   61 ++++++++++++++++++++++++++++++++
 include/linux/regulator/of_regulator.h |   13 +++++++
 2 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index e2a7310..3dc9be1 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -136,3 +136,64 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 	return count;
 }
 EXPORT_SYMBOL_GPL(of_regulator_match);
+
+/**
+ * of_regulator_match_by_compatible - extract regulator init data when
+ * regulator-compatible matches.
+ * @dev: device requesting the data
+ * @node: parent device node of the regulators
+ * @matches: match table for the regulators
+ * @num_matches: number of entries in match table
+ *
+ * This function uses a match table specified by the regulator
+ * driver and looks up the corresponding init data in the device
+ * tree if regulator-compatible matches. Note that the match
+ * table is modified in place.
+ *
+ * Returns the number of matches found or a negative error code on failure.
+ */
+int of_regulator_match_by_compatible(struct device *dev,
+			struct device_node *node,
+			struct of_regulator_match *matches,
+			unsigned int num_matches)
+{
+	unsigned int count = 0;
+	unsigned int i;
+	const char *regulator_comp;
+	struct device_node *child;
+
+	if (!dev || !node)
+		return -EINVAL;
+
+	for_each_child_of_node(node, child) {
+		regulator_comp = of_get_property(child,
+					"regulator-compatible", NULL);
+		if (!regulator_comp) {
+			dev_err(dev, "regulator-compatible is missing for node %s\n",
+				child->name);
+			continue;
+		}
+		for (i = 0; i < num_matches; i++) {
+			struct of_regulator_match *match = &matches[i];
+			if (match->of_node)
+				continue;
+
+			if (strcmp(match->name, regulator_comp))
+				continue;
+
+			match->init_data =
+				of_get_regulator_init_data(dev, child);
+			if (!match->init_data) {
+				dev_err(dev,
+					"failed to parse DT for regulator %s\n",
+					child->name);
+				return -EINVAL;
+			}
+			match->of_node = child;
+			count++;
+		}
+	}
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(of_regulator_match_by_compatible);
diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
index f921796..e3469a0 100644
--- a/include/linux/regulator/of_regulator.h
+++ b/include/linux/regulator/of_regulator.h
@@ -20,6 +20,11 @@ extern struct regulator_init_data
 extern int of_regulator_match(struct device *dev, struct device_node *node,
 			      struct of_regulator_match *matches,
 			      unsigned int num_matches);
+extern int of_regulator_match_by_compatible(struct device *dev,
+			struct device_node *node,
+			struct of_regulator_match *matches,
+			unsigned int num_matches);
+
 #else
 static inline struct regulator_init_data
 	*of_get_regulator_init_data(struct device *dev,
@@ -35,6 +40,14 @@ static inline int of_regulator_match(struct device *dev,
 {
 	return 0;
 }
+
+static inline int of_regulator_match_by_compatible(struct device *dev,
+			struct device_node *node,
+			struct of_regulator_match *matches,
+			unsigned int num_matches)
+{
+	return 0;
+}
 #endif /* CONFIG_OF */
 
 #endif /* __LINUX_OF_REG_H */
-- 
1.7.1.1

