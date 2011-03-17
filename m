Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1CQMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:25:28 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:46765 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290Ab1CQMZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:25:17 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 2/3] regulator: provide consumer interface for fall/rise time
Date: Thu, 17 Mar 2011 13:24:52 +0100
Message-ID: <1300364692-27596-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This exposes the functionality for rise/fall fime when setting
voltage to the consumers.

Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/core.c           |   45 ++++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |    2 +
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 569b198..ca398b4 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1765,6 +1765,51 @@ out:
 EXPORT_SYMBOL_GPL(regulator_set_voltage);
 
 /**
+ * regulator_set_voltage_time - get raise/fall time
+ * @regulator: regulator source
+ * @old_uV: starting voltage in microvolts
+ * @new_uV: target voltage in microvolts
+ *
+ * Provided with the starting and ending voltage, this function attempts to
+ * calculate the time in microseconds required to rise or fall to this new
+ * voltage.
+ */
+int regulator_set_voltage_time(struct regulator *regulator,
+			       int old_uV, int new_uV)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+	struct regulator_ops	*ops = rdev->desc->ops;
+	int old_sel = -1;
+	int new_sel = -1;
+	int voltage;
+	int i;
+
+	/* Currently requires operations to do this */
+	if (!ops->list_voltage || !ops->set_voltage_time_sel
+	    || !rdev->desc->n_voltages)
+		return -EINVAL;
+
+	for (i = 0; i < rdev->desc->n_voltages; i++) {
+		/* We only look for exact voltage matches here */
+		voltage = regulator_list_voltage(regulator, i);
+		if (voltage < 0)
+			return -EINVAL;
+		if (voltage == 0)
+			continue;
+		if (voltage == old_uV)
+			old_sel = i;
+		if (voltage == new_uV)
+			new_sel = i;
+	}
+
+	if (old_sel < 0 || new_sel < 0)
+		return -EINVAL;
+
+	return ops->set_voltage_time_sel(rdev, old_sel, new_sel);
+}
+EXPORT_SYMBOL_GPL(regulator_set_voltage_time);
+
+/**
  * regulator_sync_voltage - re-apply last regulator output voltage
  * @regulator: regulator source
  *
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 7954f6b..9e87c1c 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -153,6 +153,8 @@ int regulator_list_voltage(struct regulator *regulator, unsigned selector);
 int regulator_is_supported_voltage(struct regulator *regulator,
 				   int min_uV, int max_uV);
 int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV);
+int regulator_set_voltage_time(struct regulator *regulator,
+			       int old_uV, int new_uV);
 int regulator_get_voltage(struct regulator *regulator);
 int regulator_sync_voltage(struct regulator *regulator);
 int regulator_set_current_limit(struct regulator *regulator,
-- 
1.7.3.2

