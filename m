Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1C1Pet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:34:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27620 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab1C1Per (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:34:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6298"; a="82280574"
From: David Collins <collinsd@codeaurora.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: [PATCH 1/2] regulator: Remove possible deadlock from regulator_enable
Date: Mon, 28 Mar 2011 08:34:41 -0700
Message-Id: <1301326482-6547-2-git-send-email-collinsd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org>
References: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assume a regulator supply chain in which S1 supplies L2 (S1 --> L2).
It is possible to achieve deadlock using two threads if one thread
calls regulator_enable on a regulator L2 while the other thread calls
regulator_disable on S1.  This happens because _regulator_enable(L2)
holds a lock for L2 and then takes out a lock on S1.
_regulator_disable(S1) on the other hand, is called with a lock taken
for S1 and then it calls _notifier_call_chain which attempts to take a
lock for L2.  Because these locks are taken in opposite orders, deadlock
will result.

Change regulator_enable and _regulator_enable so that only one lock is
held at a time to avoid this deadlock scenario.

Signed-off-by: David Collins <collinsd@codeaurora.org>
---
 drivers/regulator/core.c |   78 +++++++++++++++++++++++++++++++---------------
 1 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9fa2095..425beba 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1279,38 +1279,54 @@ static int _regulator_can_change_status(struct regulator_dev *rdev)
 		return 0;
 }
 
-/* locks held by regulator_enable() */
+/* Locks are *not* held by regulator_enable(). */
 static int _regulator_enable(struct regulator_dev *rdev)
 {
-	int ret, delay;
+	struct regulator_dev *supply_rdev = NULL;
+	int ret = 0, delay;
 
+	mutex_lock(&rdev->mutex);
 	if (rdev->use_count == 0) {
+		/*
+		 * Incrementing here removes a race condition for simultaneous
+		 * regulator_enable calls with use_count == 0.
+		 */
+		rdev->use_count++;
+		mutex_unlock(&rdev->mutex);
+
 		/* do we need to enable the supply regulator first */
 		if (rdev->supply) {
-			mutex_lock(&rdev->supply->mutex);
 			ret = _regulator_enable(rdev->supply);
-			mutex_unlock(&rdev->supply->mutex);
 			if (ret < 0) {
 				rdev_err(rdev, "failed to enable: %d\n", ret);
+				mutex_lock(&rdev->mutex);
+				rdev->use_count--;
+				mutex_unlock(&rdev->mutex);
 				return ret;
 			}
+			supply_rdev = rdev->supply;
 		}
-	}
 
-	/* check voltage and requested load before enabling */
-	if (rdev->constraints &&
-	    (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS))
-		drms_uA_update(rdev);
+		mutex_lock(&rdev->mutex);
+		rdev->use_count--;
+
+		/* check voltage and requested load before enabling */
+		if (rdev->constraints &&
+		    (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS))
+			drms_uA_update(rdev);
 
-	if (rdev->use_count == 0) {
-		/* The regulator may on if it's not switchable or left on */
+		/* The regulator may be on if it's not switchable or left on */
 		ret = _regulator_is_enabled(rdev);
 		if (ret == -EINVAL || ret == 0) {
-			if (!_regulator_can_change_status(rdev))
-				return -EPERM;
+			if (!_regulator_can_change_status(rdev)) {
+				ret = -EPERM;
+				goto out;
+			}
 
-			if (!rdev->desc->ops->enable)
-				return -EINVAL;
+			if (!rdev->desc->ops->enable) {
+				ret = -EINVAL;
+				goto out;
+			}
 
 			/* Query before enabling in case configuration
 			 * dependant.  */
@@ -1330,7 +1346,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			 * regulators can ramp together.  */
 			ret = rdev->desc->ops->enable(rdev);
 			if (ret < 0)
-				return ret;
+				goto out;
 
 			trace_regulator_enable_delay(rdev_get_name(rdev));
 
@@ -1345,14 +1361,32 @@ static int _regulator_enable(struct regulator_dev *rdev)
 
 		} else if (ret < 0) {
 			rdev_err(rdev, "is_enabled() failed: %d\n", ret);
-			return ret;
+			goto out;
 		}
 		/* Fallthrough on positive return values - already enabled */
+	} else {
+		/* Check voltage and requested load. */
+		if (rdev->constraints &&
+		    (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS))
+			drms_uA_update(rdev);
 	}
 
 	rdev->use_count++;
+out:
+	mutex_unlock(&rdev->mutex);
 
-	return 0;
+	if (ret < 0) {
+		/* Enable has failed, disable supplies if necessary. */
+		while (supply_rdev != NULL) {
+			rdev = supply_rdev;
+
+			mutex_lock(&rdev->mutex);
+			_regulator_disable(rdev, &supply_rdev);
+			mutex_unlock(&rdev->mutex);
+		}
+	}
+
+	return ret;
 }
 
 /**
@@ -1368,13 +1402,7 @@ static int _regulator_enable(struct regulator_dev *rdev)
  */
 int regulator_enable(struct regulator *regulator)
 {
-	struct regulator_dev *rdev = regulator->rdev;
-	int ret = 0;
-
-	mutex_lock(&rdev->mutex);
-	ret = _regulator_enable(rdev);
-	mutex_unlock(&rdev->mutex);
-	return ret;
+	return _regulator_enable(regulator->rdev);
 }
 EXPORT_SYMBOL_GPL(regulator_enable);
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

