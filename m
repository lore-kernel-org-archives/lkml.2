Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1CIC6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:58:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56788 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab1CIC6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:58:40 -0500
Date: Wed, 09 Mar 2011 11:37:05 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2] Regulator: add suspend-finish API for regulator core.
In-reply-to: <20110308133817.GE20944@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1299638225-29162-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20110308133817.GE20944@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 09 Mar 2011 02:37:05.0328 (UTC)
 FILETIME=[E0D0EB00:01CBDE02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator core had suspend-prepare that turns off the regulators
when entering a system-wide suspend. However, it did not have
suspend-finish that pairs with suspend-prepare and the regulator core
has assumed that the regulator devices and their drivers support
autonomous recover at resume.

This patch adds regulator_suspend_finish that pairs with the
previously-existed regulator_suspend_prepare. The function
regulator_suspend_finish turns on the regulators that have always_on set
or positive use_count so that we can reset the regulator states
appropriately at resume.

In regulator_suspend_finish, if has_full_constraints, it disables
unnecessary regulators.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/core.c          |   40 +++++++++++++++++++++++++++++++++++++
 include/linux/regulator/machine.h |    1 +
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9fa2095..4d34cc0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2653,6 +2653,46 @@ out:
 EXPORT_SYMBOL_GPL(regulator_suspend_prepare);
 
 /**
+ * regulator_suspend_prepare - resume regulators from system wide suspend
+ *
+ * Turn on regulators that might be turned off by regulator_suspend_prepare.
+ */
+int regulator_suspend_finish(void)
+{
+	struct regulator_dev *rdev;
+	int ret = 0, error;
+
+	mutex_lock(&regulator_list_mutex);
+	list_for_each_entry(rdev, &regulator_list, list) {
+		struct regulator_ops *ops = rdev->desc->ops;
+
+		mutex_lock(&rdev->mutex);
+		if ((rdev->use_count > 0  || rdev->constraints->always_on) &&
+				ops->enable) {
+			error = ops->enable(rdev);
+			if (error)
+				ret = error;
+		} else {
+			if (!has_full_constraints)
+				goto unlock;
+			if (!ops->disable)
+				goto unlock;
+			if (ops->is_enabled && !ops->is_enabled(rdev))
+				goto unlock;
+
+			error = ops->disable(rdev);
+			if (error)
+				ret = error;
+		}
+unlock:
+		mutex_unlock(&rdev->mutex);
+	}
+	mutex_unlock(&regulator_list_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_suspend_finish);
+
+/**
  * regulator_has_full_constraints - the system has fully specified constraints
  *
  * Calling this function will cause the regulator API to disable all
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 761c745..c4c4fc4 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -186,6 +186,7 @@ struct regulator_init_data {
 };
 
 int regulator_suspend_prepare(suspend_state_t state);
+int regulator_suspend_finish(void);
 
 #ifdef CONFIG_REGULATOR
 void regulator_has_full_constraints(void);
-- 
1.7.1

