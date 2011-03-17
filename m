Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1CQMZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:25:35 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:33291 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754341Ab1CQMZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:25:31 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 1/3] regulator: add set_voltage_time_sel infrastructure
Date: Thu, 17 Mar 2011 13:24:36 +0100
Message-ID: <1300364676-27563-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes it possible to set the stabilization time for voltage
regulators in the same manner as enable_time(). The interface
only supports regulators that implements fixed selectors.

Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/core.c         |   25 +++++++++++++++++++++++++
 include/linux/regulator/driver.h |   11 +++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9fa2095..569b198 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1629,6 +1629,7 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 				     int min_uV, int max_uV)
 {
 	int ret;
+	int delay = 0;
 	unsigned int selector;
 
 	trace_regulator_set_voltage(rdev_get_name(rdev), min_uV, max_uV);
@@ -1662,6 +1663,22 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 			}
 		}
 
+		/*
+		 * If we can't obtain the old selector there is not enough
+		 * info to call set_voltage_time_sel().
+		 */
+		if (rdev->desc->ops->set_voltage_time_sel &&
+		    rdev->desc->ops->get_voltage_sel) {
+			unsigned int old_selector = 0;
+
+			ret = rdev->desc->ops->get_voltage_sel(rdev);
+			if (ret < 0)
+				return ret;
+			old_selector = ret;
+			delay = rdev->desc->ops->set_voltage_time_sel(rdev,
+						old_selector, selector);
+		}
+
 		if (best_val != INT_MAX) {
 			ret = rdev->desc->ops->set_voltage_sel(rdev, selector);
 			selector = best_val;
@@ -1672,6 +1689,14 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 		ret = -EINVAL;
 	}
 
+	/* Insert any necessary delays */
+	if (delay >= 1000) {
+		mdelay(delay / 1000);
+		udelay(delay % 1000);
+	} else if (delay) {
+		udelay(delay);
+	}
+
 	if (ret == 0)
 		_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE,
 				     NULL);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index b8ed16a..6c433b8 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -63,7 +63,11 @@ enum regulator_status {
  *                    when running with the specified parameters.
  *
  * @enable_time: Time taken for the regulator voltage output voltage to
- *               stabalise after being enabled, in microseconds.
+ *               stabilise after being enabled, in microseconds.
+ * @set_voltage_time_sel: Time taken for the regulator voltage output voltage
+ *               to stabilise after being set to a new value, in microseconds.
+ *               The function provides the from and to voltage selector, the
+ *               function should return the worst case.
  *
  * @set_suspend_voltage: Set the voltage for the regulator when the system
  *                       is suspended.
@@ -103,8 +107,11 @@ struct regulator_ops {
 	int (*set_mode) (struct regulator_dev *, unsigned int mode);
 	unsigned int (*get_mode) (struct regulator_dev *);
 
-	/* Time taken to enable the regulator */
+	/* Time taken to enable or set voltage on the regulator */
 	int (*enable_time) (struct regulator_dev *);
+	int (*set_voltage_time_sel) (struct regulator_dev *,
+				     unsigned int old_selector,
+				     unsigned int new_selector);
 
 	/* report regulator status ... most other accessors report
 	 * control inputs, this reports results of combining inputs
-- 
1.7.3.2

