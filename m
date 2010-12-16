Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0LPPtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:49:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46661 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753338Ab0LPPtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:49:50 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Add API to re-apply voltage to hardware
Date: Thu, 16 Dec 2010 15:49:36 +0000
Message-Id: <1292514577-13144-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cooperating with an external control source the regulator setup
may be changed underneath the API. Currently consumers can just redo
the regulator_set_voltage() to restore a previously set configuration
but provide an explicit API for doing this as optimsations in the
regulator_set_voltage() implementation will shortly prevent that.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c           |   47 ++++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |    1 +
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3d72cc8..a12cba3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1727,6 +1727,53 @@ out:
 }
 EXPORT_SYMBOL_GPL(regulator_set_voltage);
 
+/**
+ * regulator_sync_voltage - re-apply last regulator output voltage
+ * @regulator: regulator source
+ *
+ * Re-apply the last configured voltage.  This is intended to be used
+ * where some external control source the consumer is cooperating with
+ * has caused the configured voltage to change.
+ */
+int regulator_sync_voltage(struct regulator *regulator)
+{
+	struct regulator_dev *rdev = regulator->rdev;
+	int ret, min_uV, max_uV;
+
+	mutex_lock(&rdev->mutex);
+
+	if (!rdev->desc->ops->set_voltage &&
+	    !rdev->desc->ops->set_voltage_sel) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* This is only going to work if we've had a voltage configured. */
+	if (!regulator->min_uV && !regulator->max_uV) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	min_uV = regulator->min_uV;
+	max_uV = regulator->max_uV;
+
+	/* This should be a paranoia check... */
+	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
+	if (ret < 0)
+		goto out;
+
+	ret = regulator_check_consumers(rdev, &min_uV, &max_uV);
+	if (ret < 0)
+		goto out;
+
+	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
+
+out:
+	mutex_unlock(&rdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_sync_voltage);
+
 static int _regulator_get_voltage(struct regulator_dev *rdev)
 {
 	int sel;
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index ebd7472..7954f6b 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -154,6 +154,7 @@ int regulator_is_supported_voltage(struct regulator *regulator,
 				   int min_uV, int max_uV);
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV);
 int regulator_get_voltage(struct regulator *regulator);
+int regulator_sync_voltage(struct regulator *regulator);
 int regulator_set_current_limit(struct regulator *regulator,
 			       int min_uA, int max_uA);
 int regulator_get_current_limit(struct regulator *regulator);
-- 
1.7.1

