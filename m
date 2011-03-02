Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab1CBKym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:54:42 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:47975 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756723Ab1CBKyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:54:41 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] MFD: pm poweroff moved to ab8500-sysctrl
Date: Wed, 2 Mar 2011 11:54:30 +0100
Message-ID: <1299063270-4096-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the machine pm power off hook from the platform
code to the ab8500-sysctrl driver.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-sysctrl.c |   22 ++++++++++++++++++++++
 include/linux/mfd/ab8500.h   |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 3921859..e6de6a2 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -6,12 +6,29 @@
 
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/signal.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/ab8500/sysctrl.h>
 
 static struct device *sysctrl_dev;
 
+void ab8500_power_off(void)
+{
+	sigset_t old;
+	sigset_t all;
+
+	sigfillset(&all);
+
+	if (!sigprocmask(SIG_BLOCK, &all, &old)) {
+		(void)ab8500_sysctrl_set(AB8500_STW4500CTRL1,
+					 AB8500_STW4500CTRL1_SWOFF |
+					 AB8500_STW4500CTRL1_SWRESET4500N);
+		(void)sigprocmask(SIG_SETMASK, &old, NULL);
+	}
+}
+
 static inline bool valid_bank(u8 bank)
 {
 	return ((bank == AB8500_SYS_CTRL1_BLOCK) ||
@@ -50,7 +67,12 @@ int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value)
 
 static int __devinit ab8500_sysctrl_probe(struct platform_device *pdev)
 {
+	struct ab8500_platform_data *plat;
+
 	sysctrl_dev = &pdev->dev;
+	plat = dev_get_platdata(pdev->dev.parent);
+	if (plat->pm_power_off)
+		pm_power_off = ab8500_power_off;
 	return 0;
 }
 
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index 56f8dea..279f9f3 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -144,11 +144,13 @@ struct regulator_init_data;
 /**
  * struct ab8500_platform_data - AB8500 platform data
  * @irq_base: start of AB8500 IRQs, AB8500_NR_IRQS will be used
+ * @pm_power_off: Should machine pm power off hook be registered or not
  * @init: board-specific initialization after detection of ab8500
  * @regulator: machine-specific constraints for regulators
  */
 struct ab8500_platform_data {
 	int irq_base;
+	bool pm_power_off;
 	void (*init) (struct ab8500 *);
 	int num_regulator;
 	struct regulator_init_data *regulator;
-- 
1.7.4.1

