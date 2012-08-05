Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2HEXtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:49:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42990 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab2HEXtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:49:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 5/15] sh: CMT: Introduce clocksource/clock events suspend/resume routines
Date: Mon, 6 Aug 2012 01:43:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201207291612.43138.rjw@sisk.pl> <201208060138.03950.rjw@sisk.pl>
In-Reply-To: <201208060138.03950.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201208060143.03787.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce suspend/resume routines for SH CMT clock event devices and
modify the suspend/resume routines for SH CMT clock sources such that
if those devices belong to a PM domain, the generic PM domains
framework will be notified that the given domain may be turned off
(during system suspend) or that it has to be turned on (during system
resume).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/clocksource/sh_cmt.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

Index: linux/drivers/clocksource/sh_cmt.c
===================================================================
--- linux.orig/drivers/clocksource/sh_cmt.c
+++ linux/drivers/clocksource/sh_cmt.c
@@ -464,9 +464,20 @@ static void sh_cmt_clocksource_disable(s
 	sh_cmt_stop(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
 }
 
+static void sh_cmt_clocksource_suspend(struct clocksource *cs)
+{
+	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+
+	sh_cmt_stop(p, FLAG_CLOCKSOURCE);
+	pm_genpd_syscore_poweroff(&p->pdev->dev);
+}
+
 static void sh_cmt_clocksource_resume(struct clocksource *cs)
 {
-	sh_cmt_start(cs_to_sh_cmt(cs), FLAG_CLOCKSOURCE);
+	struct sh_cmt_priv *p = cs_to_sh_cmt(cs);
+
+	pm_genpd_syscore_poweron(&p->pdev->dev);
+	sh_cmt_start(p, FLAG_CLOCKSOURCE);
 }
 
 static int sh_cmt_register_clocksource(struct sh_cmt_priv *p,
@@ -479,7 +490,7 @@ static int sh_cmt_register_clocksource(s
 	cs->read = sh_cmt_clocksource_read;
 	cs->enable = sh_cmt_clocksource_enable;
 	cs->disable = sh_cmt_clocksource_disable;
-	cs->suspend = sh_cmt_clocksource_disable;
+	cs->suspend = sh_cmt_clocksource_suspend;
 	cs->resume = sh_cmt_clocksource_resume;
 	cs->mask = CLOCKSOURCE_MASK(sizeof(unsigned long) * 8);
 	cs->flags = CLOCK_SOURCE_IS_CONTINUOUS;
@@ -562,6 +573,16 @@ static int sh_cmt_clock_event_next(unsig
 	return 0;
 }
 
+static void sh_cmt_clock_event_suspend(struct clock_event_device *ced)
+{
+	pm_genpd_syscore_poweroff(&ced_to_sh_cmt(ced)->pdev->dev);
+}
+
+static void sh_cmt_clock_event_resume(struct clock_event_device *ced)
+{
+	pm_genpd_syscore_poweron(&ced_to_sh_cmt(ced)->pdev->dev);
+}
+
 static void sh_cmt_register_clockevent(struct sh_cmt_priv *p,
 				       char *name, unsigned long rating)
 {
@@ -576,6 +597,8 @@ static void sh_cmt_register_clockevent(s
 	ced->cpumask = cpumask_of(0);
 	ced->set_next_event = sh_cmt_clock_event_next;
 	ced->set_mode = sh_cmt_clock_event_mode;
+	ced->suspend = sh_cmt_clock_event_suspend;
+	ced->resume = sh_cmt_clock_event_resume;
 
 	dev_info(&p->pdev->dev, "used for clock events\n");
 	clockevents_register_device(ced);
@@ -690,8 +713,12 @@ static int __devinit sh_cmt_probe(struct
 	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
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
