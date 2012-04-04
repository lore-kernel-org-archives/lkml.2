Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2DDCcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 22:32:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44452 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab2DDCcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 22:32:19 -0400
Message-ID: <1333506730.15318.2.camel@phoenix>
Subject: [PATCH] regulator: Support set_voltage_time_sel for drivers
 implement set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 04 Apr 2012 10:32:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In currently implementation of _regulator_do_set_voltage, set_voltage_time_sel will
only be called if set_voltage_sel is implemented.

set_voltage_time_sel actually only needs get_voltage_sel to get old_selector.

This patch makes regulator core support set_voltage_time_sel for drivers
implement either set_voltage or set_voltage_sel.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |   59 ++++++++++++++++++++++++---------------------
 1 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e70dd38..09ffa84 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1843,23 +1843,35 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 	int ret;
 	int delay = 0;
 	unsigned int selector;
+	int old_selector = -1;
+	int best_val = INT_MAX;
 
 	trace_regulator_set_voltage(rdev_get_name(rdev), min_uV, max_uV);
 
 	min_uV += rdev->constraints->uV_offset;
 	max_uV += rdev->constraints->uV_offset;
 
+	/*
+	 * If we can't obtain the old selector there is not enough
+	 * info to call set_voltage_time_sel().
+	 */
+	if (rdev->desc->ops->set_voltage_time_sel &&
+	    rdev->desc->ops->get_voltage_sel) {
+		old_selector = rdev->desc->ops->get_voltage_sel(rdev);
+		if (old_selector < 0)
+			return old_selector;
+	}
+
 	if (rdev->desc->ops->set_voltage) {
 		ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
 						   &selector);
 
 		if (rdev->desc->ops->list_voltage)
-			selector = rdev->desc->ops->list_voltage(rdev,
+			best_val = rdev->desc->ops->list_voltage(rdev,
 								 selector);
 		else
-			selector = -1;
+			best_val = -1;
 	} else if (rdev->desc->ops->set_voltage_sel) {
-		int best_val = INT_MAX;
 		int i;
 
 		selector = 0;
@@ -1878,36 +1890,27 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 			}
 		}
 
-		/*
-		 * If we can't obtain the old selector there is not enough
-		 * info to call set_voltage_time_sel().
-		 */
-		if (rdev->desc->ops->set_voltage_time_sel &&
-		    rdev->desc->ops->get_voltage_sel) {
-			unsigned int old_selector = 0;
-
-			ret = rdev->desc->ops->get_voltage_sel(rdev);
-			if (ret < 0)
-				return ret;
-			old_selector = ret;
-			ret = rdev->desc->ops->set_voltage_time_sel(rdev,
-						old_selector, selector);
-			if (ret < 0)
-				rdev_warn(rdev, "set_voltage_time_sel() failed: %d\n", ret);
-			else
-				delay = ret;
-		}
-
-		if (best_val != INT_MAX) {
+		if (best_val != INT_MAX)
 			ret = rdev->desc->ops->set_voltage_sel(rdev, selector);
-			selector = best_val;
-		} else {
+		else
 			ret = -EINVAL;
-		}
 	} else {
 		ret = -EINVAL;
 	}
 
+	/* Call set_voltage_time_sel if successfully obtained old_selector */
+	if (ret == 0 && old_selector >= 0 &&
+	    rdev->desc->ops->set_voltage_time_sel) {
+
+		delay = rdev->desc->ops->set_voltage_time_sel(rdev,
+						old_selector, selector);
+		if (delay < 0) {
+			rdev_warn(rdev, "set_voltage_time_sel() failed: %d\n",
+				  delay);
+			delay = 0;
+		}
+	}
+
 	/* Insert any necessary delays */
 	if (delay >= 1000) {
 		mdelay(delay / 1000);
@@ -1920,7 +1923,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
 				     NULL);
 
-	trace_regulator_set_voltage_complete(rdev_get_name(rdev), selector);
+	trace_regulator_set_voltage_complete(rdev_get_name(rdev), best_val);
 
 	return ret;
 }
-- 
1.7.5.4



