Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab0JFCS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:18:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48764 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752109Ab0JFCSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:18:25 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Add option for machine drivers to enable the dummy regulator
Date: Tue,  5 Oct 2010 19:18:32 -0700
Message-Id: <1286331512-4608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow machine drivers to explicitly enable the use of the dummy regulator,
enabling simpler support for systems with only a few specific supplies
visible to software.

It is strongly recommended that this is not used on systems with
substantial software control over their PMICs, for maximum functionality
constrints should be as fully specified as possible.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Makefile        |    3 +--
 drivers/regulator/core.c          |   22 ++++++++++++++++++++++
 include/linux/regulator/machine.h |    5 +++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 8285fd8..f58bfdb 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -3,14 +3,13 @@
 #
 
 
-obj-$(CONFIG_REGULATOR) += core.o
+obj-$(CONFIG_REGULATOR) += core.o dummy.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
-obj-$(CONFIG_REGULATOR_DUMMY) += dummy.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 422a709..bf82d01 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -33,6 +33,7 @@ static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
 static int has_full_constraints;
+static bool board_wants_dummy_regulator;
 
 /*
  * struct regulator_map
@@ -1108,6 +1109,11 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 		}
 	}
 
+	if (board_wants_dummy_regulator) {
+		rdev = dummy_regulator_rdev;
+		goto found;
+	}
+
 #ifdef CONFIG_REGULATOR_DUMMY
 	if (!devname)
 		devname = "deviceless";
@@ -2461,6 +2467,22 @@ void regulator_has_full_constraints(void)
 EXPORT_SYMBOL_GPL(regulator_has_full_constraints);
 
 /**
+ * regulator_use_dummy_regulator - Provide a dummy regulator when none is found
+ *
+ * Calling this function will cause the regulator API to provide a
+ * dummy regulator to consumers if no physical regulator is found,
+ * allowing most consumers to proceed as though a regulator were
+ * configured.  This allows systems such as those with software
+ * controllable regulators for the CPU core only to be brought up more
+ * readily.
+ */
+void regulator_use_dummy_regulator(void)
+{
+	board_wants_dummy_regulator = true;
+}
+EXPORT_SYMBOL_GPL(regulator_use_dummy_regulator);
+
+/**
  * rdev_get_drvdata - get rdev regulator driver data
  * @rdev: regulator
  *
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index e298028..761c745 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -189,10 +189,15 @@ int regulator_suspend_prepare(suspend_state_t state);
 
 #ifdef CONFIG_REGULATOR
 void regulator_has_full_constraints(void);
+void regulator_use_dummy_regulator(void);
 #else
 static inline void regulator_has_full_constraints(void)
 {
 }
+
+static inline void regulator_use_dummy_regulator(void)
+{
+}
 #endif
 
 #endif
-- 
1.7.1

