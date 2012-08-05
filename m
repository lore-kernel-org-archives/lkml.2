Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2HEXtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:49:36 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42985 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab2HEXtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:49:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 13/15] sh: CMT: Basic runtime PM support
Date: Mon, 6 Aug 2012 01:48:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201207291612.43138.rjw@sisk.pl> <201208060138.03950.rjw@sisk.pl>
In-Reply-To: <201208060138.03950.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208060148.57556.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify the SH CMT clock source/clock event device driver to support
runtime PM at a basic level (i.e. device clocks can be disabled and
enabled, but domain power must be on, because the devices have to
be marked as "irq safe").

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/clocksource/sh_cmt.c |   44 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

Index: linux/drivers/clocksource/sh_cmt.c
===================================================================
--- linux.orig/drivers/clocksource/sh_cmt.c
+++ linux/drivers/clocksource/sh_cmt.c
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/pm_domain.h>
+#include <linux/pm_runtime.h>
 
 struct sh_cmt_priv {
 	void __iomem *mapbase;
@@ -52,6 +53,7 @@ struct sh_cmt_priv {
 	struct clock_event_device ced;
 	struct clocksource cs;
 	unsigned long total_cycles;
+	bool cs_enabled;
 };
 
 static DEFINE_RAW_SPINLOCK(sh_cmt_lock);
@@ -155,6 +157,9 @@ static int sh_cmt_enable(struct sh_cmt_p
 {
 	int k, ret;
 
+	pm_runtime_get_sync(&p->pdev->dev);
+	dev_pm_syscore_device(&p->pdev->dev, true);
+
 	/* enable clock */
 	ret = clk_enable(p->clk);
 	if (ret) {
@@ -221,6 +226,9 @@ static void sh_cmt_disable(struct sh_cmt
 
 	/* stop clock */
 	clk_disable(p->clk);
+
+	dev_pm_syscore_device(&p->pdev->dev, false);
+	pm_runtime_put(&p->pdev->dev);
 }
 
 /* private flags */
@@ -451,17 +459,26 @@ static int sh_cmt_clocksource_enable(str
 	int ret;
 	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
 
+	WARN_ON(p->cs_enabled);
+
 	p->total_cycles = 0;
 
 	ret = sh_cmt_start(p, FLAG_CLOCKSOURCE);
-	if (!ret)
+	if (!ret) {
 		__clocksource_updatefreq_hz(cs, p->rate);
+		p->cs_enabled = true;
+	}
 	return ret;
 }
 
 static void sh_cmt_clocksource_disable(struct clocksource *cs)
 {
-	sh_cmt_stop(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
+	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+
+	WARN_ON(!p->cs_enabled);
+
+	sh_cmt_stop(p, FLAG_CLOCKSOURCE);
+	p->cs_enabled = false;
 }
 
 static void sh_cmt_clocksource_suspend(struct clocksource *cs)
@@ -693,6 +710,7 @@ static int sh_cmt_setup(struct sh_cmt_pr
 		dev_err(&p->pdev->dev, "registration failed\n");
 		goto err1;
 	}
+	p->cs_enabled = false;
 
 	ret = setup_irq(irq, &p->irqaction);
 	if (ret) {
@@ -711,18 +729,17 @@ err0:
 static int __devinit sh_cmt_probe(struct platform_device *pdev)
 {
 	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
+	struct sh_timer_config *cfg = pdev->dev.platform_data;
 	int ret;
 
 	if (!is_early_platform_device(pdev)) {
-		struct sh_timer_config *cfg = pdev->dev.platform_data;
-
-		if (cfg->clocksource_rating || cfg->clockevent_rating)
-			dev_pm_syscore_device(&pdev->dev, true);
+		pm_runtime_set_active(&pdev->dev);
+		pm_runtime_enable(&pdev->dev);
 	}
 
 	if (p) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
-		return 0;
+		goto out;
 	}
 
 	p = kmalloc(sizeof(*p), GFP_KERNEL);
@@ -735,8 +752,19 @@ static int __devinit sh_cmt_probe(struct
 	if (ret) {
 		kfree(p);
 		platform_set_drvdata(pdev, NULL);
+		pm_runtime_idle(&pdev->dev);
+		return ret;
 	}
-	return ret;
+	if (is_early_platform_device(pdev))
+		return 0;
+
+ out:
+	if (cfg->clockevent_rating || cfg->clocksource_rating)
+		pm_runtime_irq_safe(&pdev->dev);
+	else
+		pm_runtime_idle(&pdev->dev);
+
+	return 0;
 }
 
 static int __devexit sh_cmt_remove(struct platform_device *pdev)

