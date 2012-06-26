Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab2FZK03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:26:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41151 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756363Ab2FZK01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:26:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: core: Check that the selector from map_voltage() is valid
Date: Tue, 26 Jun 2012 11:26:22 +0100
Message-Id: <1340706382-27297-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340706382-27297-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340706382-27297-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of regulator drivers have checks in their map_voltage() functions
to verify that the result of the mapping is in the range originally
specified. Factor these out in the core and provide a bit of extra
defensiveness for other drivers by doing the check in the core.

Since we're now doing a list_voltage() earlier move the current mapping
back to a voltage out into the set_voltage() call to save redoing it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9f28f2f..0ba27c2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2071,7 +2071,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 {
 	int ret;
 	int delay = 0;
-	int best_val;
+	int best_val = 0;
 	unsigned int selector;
 	int old_selector = -1;
 
@@ -2095,6 +2095,15 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 	if (rdev->desc->ops->set_voltage) {
 		ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
 						   &selector);
+
+		if (ret >= 0) {
+			if (rdev->desc->ops->list_voltage)
+				best_val = rdev->desc->ops->list_voltage(rdev,
+									 selector);
+			else
+				best_val = _regulator_get_voltage(rdev);
+		}
+
 	} else if (rdev->desc->ops->set_voltage_sel) {
 		if (rdev->desc->ops->map_voltage) {
 			ret = rdev->desc->ops->map_voltage(rdev, min_uV,
@@ -2110,10 +2119,8 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		}
 
 		if (ret >= 0) {
-			if (min_uV < rdev->desc->ops->list_voltage(rdev,
-								   ret) &&
-			    max_uV > rdev->desc->ops->list_voltage(rdev,
-								   ret)) {
+			best_val = rdev->desc->ops->list_voltage(rdev, ret);
+			if (min_uV <= best_val && max_uV >= best_val) {
 				selector = ret;
 				ret = rdev->desc->ops->set_voltage_sel(rdev,
 								       ret);
@@ -2125,11 +2132,6 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		ret = -EINVAL;
 	}
 
-	if (rdev->desc->ops->list_voltage)
-		best_val = rdev->desc->ops->list_voltage(rdev, selector);
-	else
-		best_val = _regulator_get_voltage(rdev);
-
 	/* Call set_voltage_time_sel if successfully obtained old_selector */
 	if (ret == 0 &&
 	    _regulator_is_enabled(rdev) && ret == 0 && old_selector >= 0 &&
-- 
1.7.10

