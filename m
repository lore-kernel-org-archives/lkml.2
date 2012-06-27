Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2F0OMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:12:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34616 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab2F0OML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:12:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/5] regulator: core: Factor out enable and disable operations some more
Date: Wed, 27 Jun 2012 15:12:02 +0100
Message-Id: <1340806326-30525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create new _regulator_do_enable() and _regulator_do_disable() operations
which deal with the mechanics of performing the enable and disable, partly
to cut down on the levels of indentation and partly to support some future
work.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |  110 ++++++++++++++++++++++++++++------------------
 1 file changed, 68 insertions(+), 42 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d19480b..60329fe 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1435,10 +1435,50 @@ void devm_regulator_put(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(devm_regulator_put);
 
+static int _regulator_do_enable(struct regulator_dev *rdev)
+{
+	int ret, delay;
+
+	/* Query before enabling in case configuration dependent.  */
+	ret = _regulator_get_enable_time(rdev);
+	if (ret >= 0) {
+		delay = ret;
+	} else {
+		rdev_warn(rdev, "enable_time() failed: %d\n", ret);
+		delay = 0;
+	}
+
+	trace_regulator_enable(rdev_get_name(rdev));
+
+	if (rdev->desc->ops->enable) {
+		ret = rdev->desc->ops->enable(rdev);
+		if (ret < 0)
+			return ret;
+	} else {
+		return -EINVAL;
+	}
+
+	/* Allow the regulator to ramp; it would be useful to extend
+	 * this for bulk operations so that the regulators can ramp
+	 * together.  */
+	trace_regulator_enable_delay(rdev_get_name(rdev));
+
+	if (delay >= 1000) {
+		mdelay(delay / 1000);
+		udelay(delay % 1000);
+	} else if (delay) {
+		udelay(delay);
+	}
+
+	trace_regulator_enable_complete(rdev_get_name(rdev));
+
+	return 0;
+}
+
 /* locks held by regulator_enable() */
 static int _regulator_enable(struct regulator_dev *rdev)
 {
-	int ret, delay;
+	int ret;
 
 	/* check voltage and requested load before enabling */
 	if (rdev->constraints &&
@@ -1452,40 +1492,10 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			if (!_regulator_can_change_status(rdev))
 				return -EPERM;
 
-			if (!rdev->desc->ops->enable)
-				return -EINVAL;
-
-			/* Query before enabling in case configuration
-			 * dependent.  */
-			ret = _regulator_get_enable_time(rdev);
-			if (ret >= 0) {
-				delay = ret;
-			} else {
-				rdev_warn(rdev, "enable_time() failed: %d\n",
-					   ret);
-				delay = 0;
-			}
-
-			trace_regulator_enable(rdev_get_name(rdev));
-
-			/* Allow the regulator to ramp; it would be useful
-			 * to extend this for bulk operations so that the
-			 * regulators can ramp together.  */
-			ret = rdev->desc->ops->enable(rdev);
+			ret = _regulator_do_enable(rdev);
 			if (ret < 0)
 				return ret;
 
-			trace_regulator_enable_delay(rdev_get_name(rdev));
-
-			if (delay >= 1000) {
-				mdelay(delay / 1000);
-				udelay(delay % 1000);
-			} else if (delay) {
-				udelay(delay);
-			}
-
-			trace_regulator_enable_complete(rdev_get_name(rdev));
-
 		} else if (ret < 0) {
 			rdev_err(rdev, "is_enabled() failed: %d\n", ret);
 			return ret;
@@ -1534,6 +1544,30 @@ int regulator_enable(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(regulator_enable);
 
+static int _regulator_do_disable(struct regulator_dev *rdev)
+{
+	int ret;
+
+	trace_regulator_disable(rdev_get_name(rdev));
+
+	if (rdev->ena_gpio) {
+		gpio_set_value_cansleep(rdev->ena_gpio,
+					rdev->ena_gpio_invert);
+		rdev->ena_gpio_state = 0;
+
+	} else if (rdev->desc->ops->disable) {
+		ret = rdev->desc->ops->disable(rdev);
+		if (ret != 0)
+			return ret;
+	}
+
+	trace_regulator_disable_complete(rdev_get_name(rdev));
+
+	_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
+			     NULL);
+	return 0;
+}
+
 /* locks held by regulator_disable() */
 static int _regulator_disable(struct regulator_dev *rdev)
 {
@@ -1548,20 +1582,12 @@ static int _regulator_disable(struct regulator_dev *rdev)
 	    (rdev->constraints && !rdev->constraints->always_on)) {
 
 		/* we are last user */
-		if (_regulator_can_change_status(rdev) &&
-		    rdev->desc->ops->disable) {
-			trace_regulator_disable(rdev_get_name(rdev));
-
-			ret = rdev->desc->ops->disable(rdev);
+		if (_regulator_can_change_status(rdev)) {
+			ret = _regulator_do_disable(rdev);
 			if (ret < 0) {
 				rdev_err(rdev, "failed to disable\n");
 				return ret;
 			}
-
-			trace_regulator_disable_complete(rdev_get_name(rdev));
-
-			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
-					     NULL);
 		}
 
 		rdev->use_count = 0;
-- 
1.7.10

