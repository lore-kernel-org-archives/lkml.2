Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab2DXXis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:38:48 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16905 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015Ab2DXXgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:36:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Apr 2012 16:36:11 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 2/8 v2] regulator: add node validation checks
Date: Tue, 24 Apr 2012 16:36:04 -0700
Message-ID: <1335310570-12455-3-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
References: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds some validation logic to the logic for parsing nodes for
regulator init data. The idea is to catch nodes that are defined but not used
which likely means invalid nodes.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 v2: split off some node validation checks from original patch which implemented
     them specifically for the tps65910

 drivers/regulator/of_regulator.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 45a5f85..4d5eb06 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -86,6 +86,12 @@ struct regulator_init_data *of_get_regulator_init_data(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(of_get_regulator_init_data);
 
+/* structure used for verifying regulator nodes */
+struct of_regulator_node_info {
+	struct device_node *np;
+	int count;
+};
+
 /**
  * of_find_regulator_init_data_from_device - extract all regulator_init_data
  * @dev: device requesting for regulator_init_data
@@ -103,13 +109,27 @@ int of_find_regulator_init_data_from_device(struct device *dev,
 	struct regulator_init_data **init_data, int num_regulators)
 {
 	struct device_node *child = NULL;
+	struct of_regulator_node_info *ninfo;
+	int node_cnt = 0;
 	int idx = 0;
 
 	if (!dev || !node)
 		return -EINVAL;
 
+	for_each_child_of_node(node, child)
+		node_cnt++;
+
+	ninfo = kzalloc(sizeof(*ninfo) * node_cnt, GFP_KERNEL);
+	if (!ninfo)
+		return -ENOMEM;
+
+	/* initialize list to have node addresses */
+	for_each_child_of_node(node, child)
+		ninfo[idx++].np = child;
+
 	for (idx = 0; idx < num_regulators; idx++) {
 		struct device_node *np = of_find_node_by_name(node, names[idx]);
+		int node_idx = 0;
 
 		/* didn't find a match, thats fine */
 		if (!np)
@@ -120,10 +140,28 @@ int of_find_regulator_init_data_from_device(struct device *dev,
 		if (!init_data[idx]) {
 			dev_err(dev, "failed to parse dt for regulator %s\n",
 				child->name);
+			kfree(ninfo);
 			return -EINVAL;
 		}
+
+		/* mark node as used for later checks */
+		for (node_idx = 0; node_idx < node_cnt; node_idx++) {
+			if (np == ninfo[node_idx].np) {
+				ninfo[node_idx].count++;
+				break;
+			}
+		}
+	}
+
+	/* look for unused nodes */
+	for (idx = 0; idx < node_cnt; idx++) {
+		if (ninfo[idx].count == 0)
+			dev_warn(dev, "unused regulator node found: %s\n",
+					ninfo[idx].np->name);
 	}
 
+	kfree(ninfo);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_find_regulator_init_data_from_device);
-- 
1.7.0.4

