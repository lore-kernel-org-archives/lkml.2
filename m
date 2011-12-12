Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab1LLWCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:02:21 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39072 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1LLWCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:02:19 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Mike Turquette <mturquette@ti.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC v2 1/9] arm/versatile*: merge all versatile struct clk definitions
Date: Mon, 12 Dec 2011 15:02:01 -0700
Message-Id: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no little value to each versatile type platform having it's own
struct clk definition.  Merge all of them into plat-versatile to eliminate
duplication.

This patch probably conflicts with the common struct clk work, but the
timeline for that larger work is still uncertain, and this patch can be
considered a step in that direction.  Also, a conflict with this patch
will be minor and easily resolved.

Note: I use a couple of #ifdef CONFIG_ARCH_INTEGRATOR block to avoid
including the module pointer for configurations that don't need it, but
that is only a space optimization.  I'd rather include the module
pointer unconditionally, and if other agree then I'll remove the #ifdef

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>
---
 arch/arm/mach-integrator/include/mach/clkdev.h |   19 ---------------
 arch/arm/mach-realview/include/mach/clkdev.h   |   10 --------
 arch/arm/mach-versatile/include/mach/clkdev.h  |   10 --------
 arch/arm/mach-vexpress/include/mach/clkdev.h   |    9 -------
 arch/arm/mach-zynq/include/mach/clkdev.h       |   10 --------
 arch/arm/plat-versatile/include/plat/clock.h   |   29 ++++++++++++++++++++++++
 6 files changed, 29 insertions(+), 58 deletions(-)

diff --git a/arch/arm/mach-integrator/include/mach/clkdev.h b/arch/arm/mach-integrator/include/mach/clkdev.h
index bfe0767..96ae8a4 100644
--- a/arch/arm/mach-integrator/include/mach/clkdev.h
+++ b/arch/arm/mach-integrator/include/mach/clkdev.h
@@ -4,23 +4,4 @@
 #include <linux/module.h>
 #include <plat/clock.h>
 
-struct clk {
-	unsigned long		rate;
-	const struct clk_ops	*ops;
-	struct module		*owner;
-	const struct icst_params *params;
-	void __iomem		*vcoreg;
-	void			*data;
-};
-
-static inline int __clk_get(struct clk *clk)
-{
-	return try_module_get(clk->owner);
-}
-
-static inline void __clk_put(struct clk *clk)
-{
-	module_put(clk->owner);
-}
-
 #endif
diff --git a/arch/arm/mach-realview/include/mach/clkdev.h b/arch/arm/mach-realview/include/mach/clkdev.h
index e58d077..629b0ef 100644
--- a/arch/arm/mach-realview/include/mach/clkdev.h
+++ b/arch/arm/mach-realview/include/mach/clkdev.h
@@ -3,14 +3,4 @@
 
 #include <plat/clock.h>
 
-struct clk {
-	unsigned long		rate;
-	const struct clk_ops	*ops;
-	const struct icst_params *params;
-	void __iomem		*vcoreg;
-};
-
-#define __clk_get(clk) ({ 1; })
-#define __clk_put(clk) do { } while (0)
-
 #endif
diff --git a/arch/arm/mach-versatile/include/mach/clkdev.h b/arch/arm/mach-versatile/include/mach/clkdev.h
index e58d077..629b0ef 100644
--- a/arch/arm/mach-versatile/include/mach/clkdev.h
+++ b/arch/arm/mach-versatile/include/mach/clkdev.h
@@ -3,14 +3,4 @@
 
 #include <plat/clock.h>
 
-struct clk {
-	unsigned long		rate;
-	const struct clk_ops	*ops;
-	const struct icst_params *params;
-	void __iomem		*vcoreg;
-};
-
-#define __clk_get(clk) ({ 1; })
-#define __clk_put(clk) do { } while (0)
-
 #endif
diff --git a/arch/arm/mach-vexpress/include/mach/clkdev.h b/arch/arm/mach-vexpress/include/mach/clkdev.h
index 3f8307d..629b0ef 100644
--- a/arch/arm/mach-vexpress/include/mach/clkdev.h
+++ b/arch/arm/mach-vexpress/include/mach/clkdev.h
@@ -3,13 +3,4 @@
 
 #include <plat/clock.h>
 
-struct clk {
-	const struct clk_ops	*ops;
-	unsigned long		rate;
-	const struct icst_params *params;
-};
-
-#define __clk_get(clk) ({ 1; })
-#define __clk_put(clk) do { } while (0)
-
 #endif
diff --git a/arch/arm/mach-zynq/include/mach/clkdev.h b/arch/arm/mach-zynq/include/mach/clkdev.h
index c6e73d8..bcce0e6 100644
--- a/arch/arm/mach-zynq/include/mach/clkdev.h
+++ b/arch/arm/mach-zynq/include/mach/clkdev.h
@@ -19,14 +19,4 @@
 
 #include <plat/clock.h>
 
-struct clk {
-	unsigned long		rate;
-	const struct clk_ops	*ops;
-	const struct icst_params *params;
-	void __iomem		*vcoreg;
-};
-
-#define __clk_get(clk) ({ 1; })
-#define __clk_put(clk) do { } while (0)
-
 #endif
diff --git a/arch/arm/plat-versatile/include/plat/clock.h b/arch/arm/plat-versatile/include/plat/clock.h
index 3cfb024..2117701 100644
--- a/arch/arm/plat-versatile/include/plat/clock.h
+++ b/arch/arm/plat-versatile/include/plat/clock.h
@@ -3,6 +3,19 @@
 
 #include <asm/hardware/icst.h>
 
+struct module;
+
+struct clk {
+	unsigned long		rate;
+	const struct clk_ops	*ops;
+	const struct icst_params *params;
+	void __iomem		*vcoreg;
+#ifdef CONFIG_ARCH_INTEGRATOR
+	struct module		*owner;
+	void			*data;
+#endif
+};
+
 struct clk_ops {
 	long	(*round)(struct clk *, unsigned long);
 	int	(*set)(struct clk *, unsigned long);
@@ -12,4 +25,20 @@ struct clk_ops {
 int icst_clk_set(struct clk *, unsigned long);
 long icst_clk_round(struct clk *, unsigned long);
 
+#ifdef CONFIG_ARCH_INTEGRATOR
+static inline int __clk_get(struct clk *clk)
+{
+	return try_module_get(clk->owner);
+}
+
+static inline void __clk_put(struct clk *clk)
+{
+	module_put(clk->owner);
+}
+#else
+#define __clk_get(clk) ({ 1; })
+#define __clk_put(clk) do { } while (0)
+#endif
+
+
 #endif
-- 
1.7.5.4

