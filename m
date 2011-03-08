Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab1CHCEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 21:04:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17336 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab1CHCEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 21:04:01 -0500
Date: Tue, 08 Mar 2011 11:03:58 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] Regulator: add suspend-finish API for regulator core.
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1299549838-9821-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 08 Mar 2011 02:03:59.0744 (UTC)
 FILETIME=[16E71800:01CBDD35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator core had suspend-prepare that turns off the regulators
when entering a system-wide suspend. However, it did not have
suspend-finish that recovers the change made by suspend-prepare and
depends on machine pm code or the regulator device or driver
doing so.

This patch adds regulator_suspend_finish that pairs with the
previously-existed regulator_suspend_prepare. The function
regulator_suspend_finish turns on the regulators that have always_on set
or positive use_count so that we can recover the regulator states at
resume.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/core.c          |   24 ++++++++++++++++++++++++
 include/linux/regulator/machine.h |    1 +
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9fa2095..b1e71fd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2653,6 +2653,30 @@ out:
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
+		if ((rdev->use_count > 0  || rdev->constraints->always_on) &&
+				rdev->desc->ops->enable) {
+			error = rdev->desc->ops->enable(rdev);
+			if (error)
+				ret = error;
+		}
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

