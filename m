Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab1GMV4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:56:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52448 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1GMV4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:56:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/3] ARM / shmobile: Use genpd_queue_power_off_work()
Date: Wed, 13 Jul 2011 23:54:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201107132352.59801.rjw@sisk.pl>
In-Reply-To: <201107132352.59801.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107132354.18324.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make pd_power_down_a3rv() use genpd_queue_power_off_work() to queue
up the powering off of the A4LC domain to avoid queuing it up when
it is pending.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |    2 +-
 drivers/base/power/domain.c        |    2 +-
 include/linux/pm_domain.h          |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -107,7 +107,7 @@ static int pd_power_down_a3rv(struct gen
 
 	/* try to power down A4LC after A3RV is requested off */
 	pm_genpd_poweron(&sh7372_a4lc.genpd);
-	queue_work(pm_wq, &sh7372_a4lc.genpd.power_off_work);
+	genpd_queue_power_off_work(&sh7372_a4lc.genpd);
 
 	return ret;
 }
Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -222,7 +222,7 @@ static bool genpd_abort_poweroff(struct
  * Queue up the execution of pm_genpd_poweroff() unless it's already been done
  * before.
  */
-static void genpd_queue_power_off_work(struct generic_pm_domain *genpd)
+void genpd_queue_power_off_work(struct generic_pm_domain *genpd)
 {
 	if (!work_pending(&genpd->power_off_work))
 		queue_work(pm_wq, &genpd->power_off_work);
Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -73,6 +73,7 @@ extern void pm_genpd_init(struct generic
 			  struct dev_power_governor *gov, bool is_off);
 extern int pm_genpd_poweron(struct generic_pm_domain *genpd);
 extern void pm_genpd_poweroff_unused(void);
+extern void genpd_queue_power_off_work(struct generic_pm_domain *genpd);
 #else
 static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
 				      struct device *dev)
@@ -101,6 +102,7 @@ static inline int pm_genpd_poweron(struc
 	return -ENOSYS;
 }
 static inline void pm_genpd_poweroff_unused(void) {}
+static inline void genpd_queue_power_off_work(struct generic_pm_domain *gpd) {}
 #endif
 
 #endif /* _LINUX_PM_DOMAIN_H */

