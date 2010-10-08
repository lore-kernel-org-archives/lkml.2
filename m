Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab0JHSoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:44:17 -0400
Received: from mail153.messagelabs.com ([216.82.253.51]:52208 "EHLO
	mail153.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0JHSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:44:16 -0400
X-VirusChecked: Checked
X-Env-Sender: jcarlyle@motorola.com
X-Msg-Ref: server-12.tower-153.messagelabs.com!1286563453!23570186!1
X-StarScan-Version: 6.2.4; banners=-,-,-
X-Originating-IP: [129.188.136.8]
From: Jeffrey Carlyle <jeff.carlyle@motorola.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Lun Chang <L.chang@motorola.com>, <linux-kernel@vger.kernel.org>,
        Jeffrey Carlyle <jeff.carlyle@motorola.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: avoid deadlock when disabling regulator with supply
Date: Fri,  8 Oct 2010 13:43:54 -0500
Message-Id: <1286563435-31239-1-git-send-email-jeff.carlyle@motorola.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20101008163033.GA5092@opensource.wolfsonmicro.com>
References: <20101008163033.GA5092@opensource.wolfsonmicro.com>
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a regulator A that sets regulator B as its supply. When I call
set_supply to add B as the supply for A, regulator A gets added to the
supply_list for regulator B.

When I call regulator_disable(A), I end up with a call chain like this:

regulator_disable(A)
- mutex_lock(A)
- _regulator_disable(A)
-- _regulator_disable(B)
--- _notifier_call_chain(B)
---- mutex_lock(A)

Which results in dead lock since we are trying to acquire the mutex lock
for regulator A which we already hold.

This patch addresses this issue by moving the call to disable regulator
B outside of the lock aquired inside the initial call to
regulator_disable.

This change also addresses the issue of not acquiring the mutex for
regulator B before calling _regulator_disable(B).

Change-Id: I769669452b9e1b59b252298d589738aabb03529c
Signed-off-by: Jeffrey Carlyle <jeff.carlyle@motorola.com>
---
 drivers/regulator/core.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cc8b337..e40e656 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -63,7 +63,8 @@ struct regulator {
 };
 
 static int _regulator_is_enabled(struct regulator_dev *rdev);
-static int _regulator_disable(struct regulator_dev *rdev);
+static int _regulator_disable(struct regulator_dev *rdev,
+		struct regulator_dev **supply_rdev_ptr);
 static int _regulator_get_voltage(struct regulator_dev *rdev);
 static int _regulator_get_current_limit(struct regulator_dev *rdev);
 static unsigned int _regulator_get_mode(struct regulator_dev *rdev);
@@ -1343,12 +1344,14 @@ int regulator_enable(struct regulator *regulator)
 	mutex_lock(&rdev->mutex);
 	ret = _regulator_enable(rdev);
 	mutex_unlock(&rdev->mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_enable);
 
 /* locks held by regulator_disable() */
-static int _regulator_disable(struct regulator_dev *rdev)
+static int _regulator_disable(struct regulator_dev *rdev,
+		struct regulator_dev **supply_rdev_ptr)
 {
 	int ret = 0;
 
@@ -1376,8 +1379,7 @@ static int _regulator_disable(struct regulator_dev *rdev)
 		}
 
 		/* decrease our supplies ref count and disable if required */
-		if (rdev->supply)
-			_regulator_disable(rdev->supply);
+		*supply_rdev_ptr = rdev->supply;
 
 		rdev->use_count = 0;
 	} else if (rdev->use_count > 1) {
@@ -1407,17 +1409,29 @@ static int _regulator_disable(struct regulator_dev *rdev)
 int regulator_disable(struct regulator *regulator)
 {
 	struct regulator_dev *rdev = regulator->rdev;
+	struct regulator_dev *supply_rdev = NULL;
 	int ret = 0;
 
 	mutex_lock(&rdev->mutex);
-	ret = _regulator_disable(rdev);
+	ret = _regulator_disable(rdev, &supply_rdev);
 	mutex_unlock(&rdev->mutex);
+
+	/* decrease our supplies ref count and disable if required */
+	while (supply_rdev != NULL) {
+		rdev = supply_rdev;
+
+		mutex_lock(&rdev->mutex);
+		_regulator_disable(rdev, &supply_rdev);
+		mutex_unlock(&rdev->mutex);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_disable);
 
 /* locks held by regulator_force_disable() */
-static int _regulator_force_disable(struct regulator_dev *rdev)
+static int _regulator_force_disable(struct regulator_dev *rdev,
+		struct regulator_dev **supply_rdev_ptr)
 {
 	int ret = 0;
 
@@ -1436,8 +1450,7 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
 	}
 
 	/* decrease our supplies ref count and disable if required */
-	if (rdev->supply)
-		_regulator_disable(rdev->supply);
+	*supply_rdev_ptr = rdev->supply;
 
 	rdev->use_count = 0;
 	return ret;
@@ -1454,12 +1467,19 @@ static int _regulator_force_disable(struct regulator_dev *rdev)
  */
 int regulator_force_disable(struct regulator *regulator)
 {
+	struct regulator_dev *supply_rdev = NULL;
 	int ret;
 
 	mutex_lock(&regulator->rdev->mutex);
 	regulator->uA_load = 0;
-	ret = _regulator_force_disable(regulator->rdev);
+	ret = _regulator_force_disable(regulator->rdev, &supply_rdev);
 	mutex_unlock(&regulator->rdev->mutex);
+
+	if (supply_rdev)
+		regulator_disable(
+				get_device_regulator(rdev_get_dev(supply_rdev))
+				);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_force_disable);
-- 
1.6.3.3

