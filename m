Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1HLIbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:31:23 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:37351 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282Ab1HLIbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:31:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 22/23] regulator/dbx500-prcmu: factor out common code
Date: Fri, 12 Aug 2011 10:30:33 +0200
Message-ID: <1313137833-31314-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

Before we add the DB5500 PRCMU voltage domain regulator, let's
factor out the pieces of code that are common between both
drivers.

Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Jonas Aberg <jonas.aberg@stericsson.com>
Sugned-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Philippe Langlais <philippe.langlais@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/Kconfig        |   12 +++++++
 drivers/regulator/Makefile       |    2 +
 drivers/regulator/db8500-prcmu.c |   43 +-------------------------
 drivers/regulator/dbx500-prcmu.c |   62 ++++++++++++++++++++++++++++++++++++++
 drivers/regulator/dbx500-prcmu.h |   18 +++++++++++
 5 files changed, 95 insertions(+), 42 deletions(-)
 create mode 100644 drivers/regulator/dbx500-prcmu.c
 create mode 100644 drivers/regulator/dbx500-prcmu.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c7fd2c0..d564e8d 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -281,9 +281,21 @@ config REGULATOR_AB8500
 	  This driver supports the regulators found on the ST-Ericsson mixed
 	  signal AB8500 PMIC
 
+config REGULATOR_DBX500_PRCMU
+	bool
+
+config REGULATOR_DB5500_PRCMU
+	bool "ST-Ericsson DB5500 Voltage Domain Regulators"
+	depends on MFD_DB5500_PRCMU
+	select REGULATOR_DBX500_PRCMU
+	help
+	  This driver supports the voltage domain regulators controlled by the
+	  DB5500 PRCMU
+
 config REGULATOR_DB8500_PRCMU
 	bool "ST-Ericsson DB8500 Voltage Domain Regulators"
 	depends on MFD_DB8500_PRCMU
+	select REGULATOR_DBX500_PRCMU
 	help
 	  This driver supports the voltage domain regulators controlled by the
 	  DB8500 PRCMU
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 040d5aa..6011de0 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -42,6 +42,8 @@ obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
+obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
+obj-$(CONFIG_REGULATOR_DB5500_PRCMU) += db5500-prcmu.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index 2d014a1..a615649 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -17,48 +17,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/db8500-prcmu.h>
-
-/*
- * power state reference count
- */
-static int power_state_active_cnt; /* will initialize to zero */
-static DEFINE_SPINLOCK(power_state_active_lock);
-
-static void power_state_active_enable(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&power_state_active_lock, flags);
-	power_state_active_cnt++;
-	spin_unlock_irqrestore(&power_state_active_lock, flags);
-}
-
-static int power_state_active_disable(void)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&power_state_active_lock, flags);
-	if (power_state_active_cnt <= 0) {
-		pr_err("power state: unbalanced enable/disable calls\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	power_state_active_cnt--;
-out:
-	spin_unlock_irqrestore(&power_state_active_lock, flags);
-	return ret;
-}
-
-/*
- * Exported interface for CPUIdle only. This function is called when interrupts
- * are turned off. Hence, no locking.
- */
-int power_state_active_is_enabled(void)
-{
-	return (power_state_active_cnt > 0);
-}
+#include "dbx500-prcmu.h"
 
 /**
  * struct db8500_regulator_info - db8500 regulator information
diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
new file mode 100644
index 0000000..409cb85
--- /dev/null
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ * Authors: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ *          Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
+ *
+ * UX500 common part of Power domain regulators
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/regulator/driver.h>
+#include "dbx500-prcmu.h"
+
+/*
+ * power state reference count
+ */
+static int power_state_active_cnt; /* will initialize to zero */
+static DEFINE_SPINLOCK(power_state_active_lock);
+
+void power_state_active_enable(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&power_state_active_lock, flags);
+	power_state_active_cnt++;
+	spin_unlock_irqrestore(&power_state_active_lock, flags);
+}
+
+int power_state_active_disable(void)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&power_state_active_lock, flags);
+	if (power_state_active_cnt <= 0) {
+		pr_err("power state: unbalanced enable/disable calls\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	power_state_active_cnt--;
+out:
+	spin_unlock_irqrestore(&power_state_active_lock, flags);
+	return ret;
+}
+
+/*
+ * Exported interface for CPUIdle only. This function is called when interrupts
+ * are turned off. Hence, no locking.
+ */
+int power_state_active_is_enabled(void)
+{
+	return (power_state_active_cnt > 0);
+}
+
+struct ux500_regulator {
+	char *name;
+	void (*enable)(void);
+	int (*disable)(void);
+};
diff --git a/drivers/regulator/dbx500-prcmu.h b/drivers/regulator/dbx500-prcmu.h
new file mode 100644
index 0000000..5f015b8
--- /dev/null
+++ b/drivers/regulator/dbx500-prcmu.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Bengt Jonsson <bengt.jonsson@stericsson.com> for ST-Ericsson,
+ *	   Jonas Aaberg <jonas.aberg@stericsson.com> for ST-Ericsson
+ *
+ * License Terms: GNU General Public License v2
+ *
+ */
+
+#ifndef DBX500_REGULATOR_H
+#define DBX500_REGULATOR_H
+
+void power_state_active_enable(void);
+int power_state_active_disable(void);
+
+#endif
+
-- 
1.7.3.2

