Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2GPTVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:21:45 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37372 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2GPTVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:21:38 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Paul Walmsley <paul@pwsan.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH 1/3] ARM: OMAP: hwmod: partially un-reset hwmods might not be properly enabled
Date: Mon, 16 Jul 2012 14:21:23 -0500
Message-Id: <1342466485-1050-2-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1342466485-1050-1-git-send-email-omar.luna@linaro.org>
References: <1342466485-1050-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IP blocks might not be using/controlling more than one
reset line, this check loosens the restriction to fully use
hwmod framework for those drivers.

E.g.: ipu has reset lines: mmu_cache, cpu0 and cpu1.
- cpu1 might not be used and hence (with previous check)
  won't be fully enabled by hwmod code.

While at it, prevent _omap4_module_disable if all the hardreset
lines on an IP block are not under reset.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 arch/arm/mach-omap2/omap_hwmod.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 3215dad..091c199 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -1558,25 +1558,28 @@ static int _read_hardreset(struct omap_hwmod *oh, const char *name)
 }
 
 /**
- * _are_any_hardreset_lines_asserted - return true if part of @oh is hard-reset
+ * _are_all_hardreset_lines_asserted - return true if the @oh is hard-reset
  * @oh: struct omap_hwmod *
  *
- * If any hardreset line associated with @oh is asserted, then return true.
- * Otherwise, if @oh has no hardreset lines associated with it, or if
- * no hardreset lines associated with @oh are asserted, then return false.
+ * If all hardreset lines associated with @oh are asserted, then return true.
+ * Otherwise, if part of @oh is out hardreset or if no hardreset lines
+ * associated with @oh are asserted, then return false.
  * This function is used to avoid executing some parts of the IP block
- * enable/disable sequence if a hardreset line is set.
+ * enable/disable sequence if its hardreset line is set.
  */
-static bool _are_any_hardreset_lines_asserted(struct omap_hwmod *oh)
+static bool _are_all_hardreset_lines_asserted(struct omap_hwmod *oh)
 {
-	int i;
+	int i, rst_cnt = 0;
 
 	if (oh->rst_lines_cnt == 0)
 		return false;
 
 	for (i = 0; i < oh->rst_lines_cnt; i++)
 		if (_read_hardreset(oh, oh->rst_lines[i].name) > 0)
-			return true;
+			rst_cnt++;
+
+	if (oh->rst_lines_cnt == rst_cnt)
+		return true;
 
 	return false;
 }
@@ -1595,6 +1598,13 @@ static int _omap4_disable_module(struct omap_hwmod *oh)
 	if (!oh->clkdm || !oh->prcm.omap4.modulemode)
 		return -EINVAL;
 
+	/*
+	 * Since integration code might still be doing something, only
+	 * disable if all lines are under hardreset.
+	 */
+	if (!_are_all_hardreset_lines_asserted(oh))
+		return 0;
+
 	pr_debug("omap_hwmod: %s: %s\n", oh->name, __func__);
 
 	omap4_cminst_module_disable(oh->clkdm->prcm_partition,
@@ -1602,9 +1612,6 @@ static int _omap4_disable_module(struct omap_hwmod *oh)
 				    oh->clkdm->clkdm_offs,
 				    oh->prcm.omap4.clkctrl_offs);
 
-	if (_are_any_hardreset_lines_asserted(oh))
-		return 0;
-
 	v = _omap4_wait_target_disable(oh);
 	if (v)
 		pr_warn("omap_hwmod: %s: _wait_target_disable failed\n",
@@ -1830,7 +1837,7 @@ static int _enable(struct omap_hwmod *oh)
 	}
 
 	/*
-	 * If an IP block contains HW reset lines and any of them are
+	 * If an IP block contains HW reset lines and all of them are
 	 * asserted, we let integration code associated with that
 	 * block handle the enable.  We've received very little
 	 * information on what those driver authors need, and until
@@ -1838,7 +1845,7 @@ static int _enable(struct omap_hwmod *oh)
 	 * posted to the public lists, this is probably the best we
 	 * can do.
 	 */
-	if (_are_any_hardreset_lines_asserted(oh))
+	if (_are_all_hardreset_lines_asserted(oh))
 		return 0;
 
 	/* Mux pins for device runtime if populated */
@@ -1918,7 +1925,7 @@ static int _idle(struct omap_hwmod *oh)
 		return -EINVAL;
 	}
 
-	if (_are_any_hardreset_lines_asserted(oh))
+	if (_are_all_hardreset_lines_asserted(oh))
 		return 0;
 
 	if (oh->class->sysc)
@@ -2006,7 +2013,7 @@ static int _shutdown(struct omap_hwmod *oh)
 		return -EINVAL;
 	}
 
-	if (_are_any_hardreset_lines_asserted(oh))
+	if (_are_all_hardreset_lines_asserted(oh))
 		return 0;
 
 	pr_debug("omap_hwmod: %s: disabling\n", oh->name);
-- 
1.7.4.1

