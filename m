Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2KVTX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:23:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48676 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2KVTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:23:19 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 1/3] CLK: get rid of HAVE_CLK_PREPARE
Date: Wed, 21 Nov 2012 21:34:40 -0800
Message-Id: <1353562482-12422-2-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353562482-12422-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353562482-12422-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HAVE_CLK_PREPARE is automatically selected by COMMON_CLK and the only
platform that explicitly selects HAVE_CLK_PREPARE is MXS which has been
switched to common clk framework, so we can delete this option now.

As part of this change we move declarations of clk_prepare() and
clk_unprepare() under HAVE_CLK and provide stubs if this option is not
enabled.

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 arch/arm/Kconfig    |  1 -
 drivers/clk/Kconfig |  4 ----
 include/linux/clk.h | 68 +++++++++++++++++++++++++----------------------------
 3 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ade7e92..ae6c1df 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -453,7 +453,6 @@ config ARCH_MXS
 	select CLKSRC_MMIO
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
-	select HAVE_CLK_PREPARE
 	select MULTI_IRQ_HANDLER
 	select PINCTRL
 	select SPARSE_IRQ
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index bace9e9..639ee9d 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -3,15 +3,11 @@ config CLKDEV_LOOKUP
 	bool
 	select HAVE_CLK
 
-config HAVE_CLK_PREPARE
-	bool
-
 config HAVE_MACH_CLKDEV
 	bool
 
 config COMMON_CLK
 	bool
-	select HAVE_CLK_PREPARE
 	select CLKDEV_LOOKUP
 	---help---
 	  The common clock framework is a single definition of struct
diff --git a/include/linux/clk.h b/include/linux/clk.h
index b3ac22d..f8204c3 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -84,42 +84,6 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
 
 #endif
 
-/**
- * clk_prepare - prepare a clock source
- * @clk: clock source
- *
- * This prepares the clock source for use.
- *
- * Must not be called from within atomic context.
- */
-#ifdef CONFIG_HAVE_CLK_PREPARE
-int clk_prepare(struct clk *clk);
-#else
-static inline int clk_prepare(struct clk *clk)
-{
-	might_sleep();
-	return 0;
-}
-#endif
-
-/**
- * clk_unprepare - undo preparation of a clock source
- * @clk: clock source
- *
- * This undoes a previously prepared clock.  The caller must balance
- * the number of prepare and unprepare calls.
- *
- * Must not be called from within atomic context.
- */
-#ifdef CONFIG_HAVE_CLK_PREPARE
-void clk_unprepare(struct clk *clk);
-#else
-static inline void clk_unprepare(struct clk *clk)
-{
-	might_sleep();
-}
-#endif
-
 #ifdef CONFIG_HAVE_CLK
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
@@ -159,6 +123,27 @@ struct clk *clk_get(struct device *dev, const char *id);
 struct clk *devm_clk_get(struct device *dev, const char *id);
 
 /**
+ * clk_prepare - prepare a clock source
+ * @clk: clock source
+ *
+ * This prepares the clock source for use.
+ *
+ * Must not be called from within atomic context.
+ */
+int clk_prepare(struct clk *clk);
+
+/**
+ * clk_unprepare - undo preparation of a clock source
+ * @clk: clock source
+ *
+ * This undoes a previously prepared clock.  The caller must balance
+ * the number of prepare and unprepare calls.
+ *
+ * Must not be called from within atomic context.
+ */
+void clk_unprepare(struct clk *clk);
+
+/**
  * clk_enable - inform the system when the clock source should be running.
  * @clk: clock source
  *
@@ -292,6 +277,17 @@ static inline void clk_put(struct clk *clk) {}
 
 static inline void devm_clk_put(struct device *dev, struct clk *clk) {}
 
+static inline int clk_prepare(struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+
+static inline void clk_unprepare(struct clk *clk)
+{
+	might_sleep();
+}
+
 static inline int clk_enable(struct clk *clk)
 {
 	return 0;
-- 
1.7.11.7

