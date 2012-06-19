Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2FSOi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:38:28 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13301 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2FSOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:38:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 19 Jun 2012 07:38:17 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <arnd@arndb.de>, <linus.walleij@linaro.org>,
        <lrg@ti.com>, <lee.jones@linaro.org>, <swarren@wwwdotorg.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/3] regulator: dt: regulator match by regulator-compatible
Date: Tue, 19 Jun 2012 19:58:17 +0530
Message-ID: <1340116099-17629-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Match the device's regulators with the property of
"regulator-compatible" of each regulator node.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- In place of adding new api, modify the existing api of_regulator_match() to
look regulator-compatible for matching.

 drivers/regulator/of_regulator.c |   50 ++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index e2a7310..7621306 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -92,15 +92,17 @@ struct regulator_init_data *of_get_regulator_init_data(struct device *dev,
 EXPORT_SYMBOL_GPL(of_get_regulator_init_data);
 
 /**
- * of_regulator_match - extract regulator init data
+ * of_regulator_match - extract regulator init data when node
+ * property "regulator-compatible" matches with the regulator name.
  * @dev: device requesting the data
  * @node: parent device node of the regulators
  * @matches: match table for the regulators
  * @num_matches: number of entries in match table
  *
  * This function uses a match table specified by the regulator driver and
- * looks up the corresponding init data in the device tree. Note that the
- * match table is modified in place.
+ * looks up the corresponding init data in the device tree  if
+ * regulator-compatible matches. Note that the match table is modified
+ * in place.
  *
  * Returns the number of matches found or a negative error code on failure.
  */
@@ -110,27 +112,39 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 {
 	unsigned int count = 0;
 	unsigned int i;
+	const char *regulator_comp;
+	struct device_node *child;
 
 	if (!dev || !node)
 		return -EINVAL;
 
-	for (i = 0; i < num_matches; i++) {
-		struct of_regulator_match *match = &matches[i];
-		struct device_node *child;
-
-		child = of_find_node_by_name(node, match->name);
-		if (!child)
-			continue;
-
-		match->init_data = of_get_regulator_init_data(dev, child);
-		if (!match->init_data) {
-			dev_err(dev, "failed to parse DT for regulator %s\n",
+	for_each_child_of_node(node, child) {
+		regulator_comp = of_get_property(child,
+					"regulator-compatible", NULL);
+		if (!regulator_comp) {
+			dev_err(dev, "regulator-compatible is missing for node %s\n",
 				child->name);
-			return -EINVAL;
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
 		}
-
-		match->of_node = child;
-		count++;
 	}
 
 	return count;
-- 
1.7.1.1

