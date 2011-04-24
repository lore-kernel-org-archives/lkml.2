Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1DXVpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 17:45:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47186 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab1DXVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 17:44:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 8/9] OMAP1 / PM: Use generic clock manipulation routines for runtime PM
Date: Sun, 24 Apr 2011 23:43:41 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104170135.19388.rjw@sisk.pl> <201104242330.13607.rjw@sisk.pl>
In-Reply-To: <201104242330.13607.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104242343.41456.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Convert OMAP1 to using the new generic clock manipulation routines
and a device power domain for runtime PM instead of overriding the
platform bus type's runtime PM callbacks.  This allows us to simplify
OMAP1-specific code and to share some code with other platforms
(shmobile in particular).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-omap1/pm_bus.c |   69 +++++++++++++------------------------------
 1 file changed, 22 insertions(+), 47 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/pm_bus.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/pm_bus.c
+++ linux-2.6/arch/arm/mach-omap1/pm_bus.c
@@ -24,75 +24,50 @@
 #ifdef CONFIG_PM_RUNTIME
 static int omap1_pm_runtime_suspend(struct device *dev)
 {
-	struct clk *iclk, *fclk;
-	int ret = 0;
+	int ret;
 
 	dev_dbg(dev, "%s\n", __func__);
 
 	ret = pm_generic_runtime_suspend(dev);
+	if (ret)
+		return ret;
 
-	fclk = clk_get(dev, "fck");
-	if (!IS_ERR(fclk)) {
-		clk_disable(fclk);
-		clk_put(fclk);
-	}
-
-	iclk = clk_get(dev, "ick");
-	if (!IS_ERR(iclk)) {
-		clk_disable(iclk);
-		clk_put(iclk);
+	ret = pm_runtime_clk_suspend(dev);
+	if (ret) {
+		pm_generic_runtime_resume(dev);
+		return ret;
 	}
 
 	return 0;
-};
+}
 
 static int omap1_pm_runtime_resume(struct device *dev)
 {
-	struct clk *iclk, *fclk;
-
 	dev_dbg(dev, "%s\n", __func__);
 
-	iclk = clk_get(dev, "ick");
-	if (!IS_ERR(iclk)) {
-		clk_enable(iclk);
-		clk_put(iclk);
-	}
+	pm_runtime_clk_resume(dev);
+	return pm_generic_runtime_resume(dev);
+}
 
-	fclk = clk_get(dev, "fck");
-	if (!IS_ERR(fclk)) {
-		clk_enable(fclk);
-		clk_put(fclk);
-	}
+static struct dev_power_domain default_power_domain = {
+	.ops = {
+		.runtime_suspend = omap1_pm_runtime_suspend,
+		.runtime_resume = omap1_pm_runtime_resume,
+		USE_PLATFORM_PM_SLEEP_OPS
+	},
+};
 
-	return pm_generic_runtime_resume(dev);
+static struct pm_clk_notifier_block platform_bus_notifier = {
+	.pwr_domain = &default_power_domain,
+	.con_ids = { "ick", "fck", NULL, },
 };
 
 static int __init omap1_pm_runtime_init(void)
 {
-	const struct dev_pm_ops *pm;
-	struct dev_pm_ops *omap_pm;
-
 	if (!cpu_class_is_omap1())
 		return -ENODEV;
 
-	pm = platform_bus_get_pm_ops();
-	if (!pm) {
-		pr_err("%s: unable to get dev_pm_ops from platform_bus\n",
-			__func__);
-		return -ENODEV;
-	}
-
-	omap_pm = kmemdup(pm, sizeof(struct dev_pm_ops), GFP_KERNEL);
-	if (!omap_pm) {
-		pr_err("%s: unable to alloc memory for new dev_pm_ops\n",
-			__func__);
-		return -ENOMEM;
-	}
-
-	omap_pm->runtime_suspend = omap1_pm_runtime_suspend;
-	omap_pm->runtime_resume = omap1_pm_runtime_resume;
-
-	platform_bus_set_pm_ops(omap_pm);
+	pm_runtime_clk_add_notifier(&platform_bus_type, &platform_bus_notifier);
 
 	return 0;
 }

