Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2DSMah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:30:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44443 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab2DSMag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:30:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>, Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: core: Optimise enable/disable path for always on regulators
Date: Thu, 19 Apr 2012 13:30:18 +0100
Message-Id: <1334838618-27924-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a regulator is always on for any reason then cache that when the
consumer is created and use it to optimise away the need to take locks
or recurse up the supply tree when consumers do enable or disable calls.
The scheduling of asynchronous work for bulk enables is also skipped.

We don't actually check if the device physically supports control on the
basis that constraints allowing status changes on physically always on
regulators are nonsensical anyway.

This is a very common pattern in hardware - it's normal to have some
power supplies that have either no software control or are critical to
system function - so many systems should be able to benefit.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

I've only compile tested this so far, will do so later today or
tomorrow, but I'm fairly optimistic it'll be OK so pushing out now for
review.

 drivers/regulator/core.c |   54 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index db79987..1caada2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -75,6 +75,7 @@ struct regulator_map {
 struct regulator {
 	struct device *dev;
 	struct list_head list;
+	unsigned int always_on:1;
 	int uA_load;
 	int min_uV;
 	int max_uV;
@@ -156,6 +157,17 @@ static struct device_node *of_get_regulator(struct device *dev, const char *supp
 	return regnode;
 }
 
+static int _regulator_can_change_status(struct regulator_dev *rdev)
+{
+	if (!rdev->constraints)
+		return 0;
+
+	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_STATUS)
+		return 1;
+	else
+		return 0;
+}
+
 /* Platform voltage constraint check */
 static int regulator_check_voltage(struct regulator_dev *rdev,
 				   int *min_uV, int *max_uV)
@@ -1142,6 +1154,15 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 				   &regulator->max_uV);
 	}
 
+	/*
+	 * Check now if the regulator is an always on regulator - if
+	 * it is then we don't need to do nearly so much work for
+	 * enable/disable calls.
+	 */
+	if (!_regulator_can_change_status(rdev) &&
+	    _regulator_is_enabled(rdev))
+		regulator->always_on = true;
+
 	mutex_unlock(&rdev->mutex);
 	return regulator;
 link_name_err:
@@ -1444,17 +1465,6 @@ void devm_regulator_put(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(devm_regulator_put);
 
-static int _regulator_can_change_status(struct regulator_dev *rdev)
-{
-	if (!rdev->constraints)
-		return 0;
-
-	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_STATUS)
-		return 1;
-	else
-		return 0;
-}
-
 /* locks held by regulator_enable() */
 static int _regulator_enable(struct regulator_dev *rdev)
 {
@@ -1534,6 +1544,9 @@ int regulator_enable(struct regulator *regulator)
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret = 0;
 
+	if (regulator->always_on)
+		return 0;
+
 	if (rdev->supply) {
 		ret = regulator_enable(rdev->supply);
 		if (ret != 0)
@@ -1612,6 +1625,9 @@ int regulator_disable(struct regulator *regulator)
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret = 0;
 
+	if (regulator->always_on)
+		return 0;
+
 	mutex_lock(&rdev->mutex);
 	ret = _regulator_disable(rdev);
 	mutex_unlock(&rdev->mutex);
@@ -1720,6 +1736,9 @@ int regulator_disable_deferred(struct regulator *regulator, int ms)
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
 
+	if (regulator->always_on)
+		return 0;
+
 	mutex_lock(&rdev->mutex);
 	rdev->deferred_disables++;
 	mutex_unlock(&rdev->mutex);
@@ -1813,6 +1832,9 @@ int regulator_is_enabled(struct regulator *regulator)
 {
 	int ret;
 
+	if (regulator->always_on)
+		return 1;
+
 	mutex_lock(&regulator->rdev->mutex);
 	ret = _regulator_is_enabled(regulator->rdev);
 	mutex_unlock(&regulator->rdev->mutex);
@@ -2639,9 +2661,13 @@ int regulator_bulk_enable(int num_consumers,
 	int i;
 	int ret = 0;
 
-	for (i = 0; i < num_consumers; i++)
-		async_schedule_domain(regulator_bulk_enable_async,
-				      &consumers[i], &async_domain);
+	for (i = 0; i < num_consumers; i++) {
+		if (consumers[i].consumer->always_on)
+			consumers[i].ret = 0;
+		else
+			async_schedule_domain(regulator_bulk_enable_async,
+					      &consumers[i], &async_domain);
+	}
 
 	async_synchronize_full_domain(&async_domain);
 
-- 
1.7.10

