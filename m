Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2HEXta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:49:30 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42969 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab2HEXsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:48:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 4/15] sh: TMU: Introduce clocksource/clock events suspend/resume routines
Date: Mon, 6 Aug 2012 01:41:20 +0200
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
Message-Id: <201208060141.21064.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce suspend/resume routines for SH TMU clock source and
clock event device such that if those devices belong to a PM domain,
the generic PM domains framework will be notified that the given
domain may be turned off (during system suspend) or that it has to
be turned on (during system resume).

This change allows the A4R domain on SH7372 to be turned off during
system suspend (tested on the Mackerel board) if the TMU clock source
and/or clock event device is in use.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/clocksource/sh_tmu.c |   54 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 50 insertions(+), 4 deletions(-)

Index: linux/drivers/clocksource/sh_tmu.c
===================================================================
--- linux.orig/drivers/clocksource/sh_tmu.c
+++ linux/drivers/clocksource/sh_tmu.c
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/pm_domain.h>
+#include <linux/pm_runtime.h>
 
 struct sh_tmu_priv {
 	void __iomem *mapbase;
@@ -43,6 +44,7 @@ struct sh_tmu_priv {
 	unsigned long periodic;
 	struct clock_event_device ced;
 	struct clocksource cs;
+	bool cs_enabled;
 };
 
 static DEFINE_RAW_SPINLOCK(sh_tmu_lock);
@@ -204,14 +206,40 @@ static int sh_tmu_clocksource_enable(str
 	int ret;
 
 	ret = sh_tmu_enable(p);
-	if (!ret)
+	if (!ret) {
 		__clocksource_updatefreq_hz(cs, p->rate);
+		p->cs_enabled = true;
+	}
 	return ret;
 }
 
 static void sh_tmu_clocksource_disable(struct clocksource *cs)
 {
-	sh_tmu_disable(cs_to_sh_tmu(cs));
+	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
+
+	WARN_ON(!p->cs_enabled);
+
+	sh_tmu_disable(p);
+	p->cs_enabled = false;
+}
+
+static void sh_tmu_clocksource_suspend(struct clocksource *cs)
+{
+	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
+
+	if (p->cs_enabled)
+		sh_tmu_disable(p);
+
+	pm_genpd_syscore_poweroff(&p->pdev->dev);
+}
+
+static void sh_tmu_clocksource_resume(struct clocksource *cs)
+{
+	struct sh_tmu_priv *p = cs_to_sh_tmu(cs);
+
+	pm_genpd_syscore_poweron(&p->pdev->dev);
+	if (p->cs_enabled)
+		sh_tmu_enable(p);
 }
 
 static int sh_tmu_register_clocksource(struct sh_tmu_priv *p,
@@ -224,6 +252,8 @@ static int sh_tmu_register_clocksource(s
 	cs->read = sh_tmu_clocksource_read;
 	cs->enable = sh_tmu_clocksource_enable;
 	cs->disable = sh_tmu_clocksource_disable;
+	cs->suspend = sh_tmu_clocksource_suspend;
+	cs->resume = sh_tmu_clocksource_resume;
 	cs->mask = CLOCKSOURCE_MASK(32);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
@@ -301,6 +331,16 @@ static int sh_tmu_clock_event_next(unsig
 	return 0;
 }
 
+static void sh_tmu_clock_event_suspend(struct clock_event_device *ced)
+{
+	pm_genpd_syscore_poweroff(&ced_to_sh_tmu(ced)->pdev->dev);
+}
+
+static void sh_tmu_clock_event_resume(struct clock_event_device *ced)
+{
+	pm_genpd_syscore_poweron(&ced_to_sh_tmu(ced)->pdev->dev);
+}
+
 static void sh_tmu_register_clockevent(struct sh_tmu_priv *p,
 				       char *name, unsigned long rating)
 {
@@ -316,6 +356,8 @@ static void sh_tmu_register_clockevent(s
 	ced->cpumask = cpumask_of(0);
 	ced->set_next_event = sh_tmu_clock_event_next;
 	ced->set_mode = sh_tmu_clock_event_mode;
+	ced->suspend = sh_tmu_clock_event_suspend;
+	ced->resume = sh_tmu_clock_event_resume;
 
 	dev_info(&p->pdev->dev, "used for clock events\n");
 
@@ -407,8 +449,12 @@ static int __devinit sh_tmu_probe(struct
 	struct sh_tmu_priv *p = platform_get_drvdata(pdev);
 	int ret;
 
-	if (!is_early_platform_device(pdev))
-		pm_genpd_dev_always_on(&pdev->dev, true);
+	if (!is_early_platform_device(pdev)) {
+		struct sh_timer_config *cfg = pdev->dev.platform_data;
+
+		if (cfg->clocksource_rating || cfg->clockevent_rating)
+			pm_genpd_dev_always_on(&pdev->dev, true);
+	}
 
 	if (p) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");

