Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab0LMPil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:38:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46608 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752864Ab0LMPij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:38:39 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Graeme Gregory <dp@xora.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Factor out voltage set operation into a separate function
Date: Mon, 13 Dec 2010 15:38:26 +0000
Message-Id: <1292254707-776-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push all the callers of the chip set_voltage() operation out into a single
function to facilitiate future refactoring.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   63 ++++++++++++++++++++++++++++-----------------
 1 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index b362dbd..23c5f7c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -83,6 +83,8 @@ static int _regulator_get_current_limit(struct regulator_dev *rdev);
 static unsigned int _regulator_get_mode(struct regulator_dev *rdev);
 static void _notifier_call_chain(struct regulator_dev *rdev,
 				  unsigned long event, void *data);
+static int _regulator_do_set_voltage(struct regulator_dev *rdev,
+				     int min_uV, int max_uV);
 
 static const char *rdev_get_name(struct regulator_dev *rdev)
 {
@@ -745,22 +747,19 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 {
 	struct regulator_ops *ops = rdev->desc->ops;
 	int ret;
-	unsigned selector;
 
 	/* do we need to apply the constraint voltage */
 	if (rdev->constraints->apply_uV &&
-		rdev->constraints->min_uV == rdev->constraints->max_uV &&
-		ops->set_voltage) {
-		ret = ops->set_voltage(rdev,
-				       rdev->constraints->min_uV,
-				       rdev->constraints->max_uV,
-				       &selector);
-			if (ret < 0) {
-				rdev_err(rdev, "failed to apply %duV constraint\n",
-					 rdev->constraints->min_uV);
-				rdev->constraints = NULL;
-				return ret;
-			}
+	    rdev->constraints->min_uV == rdev->constraints->max_uV) {
+		ret = _regulator_do_set_voltage(rdev,
+						rdev->constraints->min_uV,
+						rdev->constraints->max_uV);
+		if (ret < 0) {
+			rdev_err(rdev, "failed to apply %duV constraint\n",
+				 rdev->constraints->min_uV);
+			rdev->constraints = NULL;
+			return ret;
+		}
 	}
 
 	/* constrain machine-level voltage specs to fit
@@ -1621,6 +1620,32 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 	return 0;
 }
 
+static int _regulator_do_set_voltage(struct regulator_dev *rdev,
+				     int min_uV, int max_uV)
+{
+	int ret;
+	unsigned int selector;
+
+	trace_regulator_set_voltage(rdev_get_name(rdev), min_uV, max_uV);
+
+	if (rdev->desc->ops->set_voltage) {
+		ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
+						   &selector);
+
+		if (rdev->desc->ops->list_voltage)
+			selector = rdev->desc->ops->list_voltage(rdev,
+								 selector);
+		else
+			selector = -1;
+	} else {
+		ret = -EINVAL;
+	}
+
+	trace_regulator_set_voltage_complete(rdev_get_name(rdev), selector);
+
+	return ret;
+}
+
 /**
  * regulator_set_voltage - set regulator output voltage
  * @regulator: regulator source
@@ -1643,7 +1668,6 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 {
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
-	unsigned selector;
 
 	mutex_lock(&rdev->mutex);
 
@@ -1664,16 +1688,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	if (ret < 0)
 		goto out;
 
-	trace_regulator_set_voltage(rdev_get_name(rdev), min_uV, max_uV);
-
-	ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV, &selector);
-
-	if (rdev->desc->ops->list_voltage)
-		selector = rdev->desc->ops->list_voltage(rdev, selector);
-	else
-		selector = -1;
-
-	trace_regulator_set_voltage_complete(rdev_get_name(rdev), selector);
+	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
 
 out:
 	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
-- 
1.7.1

