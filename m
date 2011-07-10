Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1GJUrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:47:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43413 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636Ab1GJUr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:47:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/2] ARM / shmobile: Use pm_genpd_poweroff_unused()
Date: Sun, 10 Jul 2011 22:47:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "Linux-SH" <linux-sh@vger.kernel.org>
References: <201107102246.05107.rjw@sisk.pl>
In-Reply-To: <201107102246.05107.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107102247.45034.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make shmobile use pm_genpd_poweroff_unused() instead of the
open-coded powering off PM domains without devices in use.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/include/mach/common.h |    1 -
 arch/arm/mach-shmobile/pm-sh7372.c           |   13 -------------
 arch/arm/mach-shmobile/pm_runtime.c          |    6 ++----
 3 files changed, 2 insertions(+), 18 deletions(-)

Index: linux-2.6/arch/arm/mach-shmobile/include/mach/common.h
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/include/mach/common.h
+++ linux-2.6/arch/arm/mach-shmobile/include/mach/common.h
@@ -12,7 +12,6 @@ extern struct platform_suspend_ops shmob
 struct cpuidle_device;
 extern void (*shmobile_cpuidle_modes[])(void);
 extern void (*shmobile_cpuidle_setup)(struct cpuidle_device *dev);
-extern void (*shmobile_runtime_pm_late_init)(void);
 
 extern void sh7367_init_irq(void);
 extern void sh7367_add_early_devices(void);
Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -126,17 +126,6 @@ static bool pd_active_wakeup(struct devi
 	return true;
 }
 
-static void sh7372_late_pm_domain_off(void)
-{
-	/* request power down of unused pm domains */
-	queue_work(pm_wq, &sh7372_a4lc.genpd.power_off_work);
-	queue_work(pm_wq, &sh7372_a4mp.genpd.power_off_work);
-	queue_work(pm_wq, &sh7372_d4.genpd.power_off_work);
-	queue_work(pm_wq, &sh7372_a3rv.genpd.power_off_work);
-	queue_work(pm_wq, &sh7372_a3ri.genpd.power_off_work);
-	queue_work(pm_wq, &sh7372_a3sg.genpd.power_off_work);
-}
-
 void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd)
 {
 	struct generic_pm_domain *genpd = &sh7372_pd->genpd;
@@ -157,8 +146,6 @@ void sh7372_init_pm_domain(struct sh7372
 		genpd->power_on = pd_power_up;
 	}
 	genpd->power_on(&sh7372_pd->genpd);
-
-	shmobile_runtime_pm_late_init = sh7372_late_pm_domain_off;
 }
 
 void sh7372_add_device_to_domain(struct sh7372_pm_domain *sh7372_pd,
Index: linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm_runtime.c
+++ linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_domain.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/sh_clk.h>
@@ -57,12 +58,9 @@ static int __init sh_pm_runtime_init(voi
 }
 core_initcall(sh_pm_runtime_init);
 
-void (*shmobile_runtime_pm_late_init)(void);
-
 static int __init sh_pm_runtime_late_init(void)
 {
-	if (shmobile_runtime_pm_late_init)
-		shmobile_runtime_pm_late_init();
+	pm_genpd_poweroff_unused();
 	return 0;
 }
 late_initcall(sh_pm_runtime_late_init);

