Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2DSJvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:51:51 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59890 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab2DSJvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:51:50 -0400
From: Jassi Brar <jaswinder.singh@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH] regulator: Provide a check for dummy regulator
Date: Thu, 19 Apr 2012 15:21:37 +0530
Message-Id: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually changing the regulator output involves delays before/after the
operation.
There are consumer drivers shared by platforms, where some may
not really have a regulator in the path. Which causes the consumer
to unnecessarily (sometimes disruptively) incur delays for the
"dummy" regulator.
Since the 'struct regulator' is opaque outside of the core,
provide a function to check if the given regulator is a dummy one.

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/regulator/core.c           |    9 +++++++++
 include/linux/regulator/consumer.h |    6 ++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e70dd38..2fb6e5b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3115,6 +3115,15 @@ void regulator_use_dummy_regulator(void)
 EXPORT_SYMBOL_GPL(regulator_use_dummy_regulator);
 
 /**
+ * regulator_is_dummy - Check if the regulator is the placeholder 'dummy'
+ */
+bool regulator_is_dummy(struct regulator *regulator)
+{
+	return !strcmp(regulator->rdev->desc->name, "dummy");
+}
+EXPORT_SYMBOL_GPL(regulator_is_dummy);
+
+/**
  * rdev_get_drvdata - get rdev regulator driver data
  * @rdev: regulator
  *
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 4ed1b30..7b0360c 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -141,6 +141,7 @@ void regulator_put(struct regulator *regulator);
 void devm_regulator_put(struct regulator *regulator);
 
 /* regulator output control and status */
+bool regulator_is_dummy(struct regulator *regulator);
 int regulator_enable(struct regulator *regulator);
 int regulator_disable(struct regulator *regulator);
 int regulator_force_disable(struct regulator *regulator);
@@ -221,6 +222,11 @@ static inline void devm_regulator_put(struct regulator *regulator)
 {
 }
 
+static bool regulator_is_dummy(struct regulator *regulator)
+{
+	return true;
+}
+
 static inline int regulator_enable(struct regulator *regulator)
 {
 	return 0;
-- 
1.7.4.1

