Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1HTTXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 15:23:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54773 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1HTTXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:23:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM / Domains: Preliminary support for devices with power.irq_safe set
Date: Sat, 20 Aug 2011 21:24:58 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108202124.58851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The generic PM domains framework currently doesn't work with devices
whose power.irq_safe flag is set, because runtime PM callbacks for
such devices are run with interrupts disabled and the callbacks
provided by the generic PM domains framework use domain mutexes
and may sleep.  However, such devices very well may belong to
power domains on some systems, so the generic PM domains framework
should take them into account.

For this reason, make modify the generic PM domains framework so
that the domain .power_off() and .power_on() callbacks are never
executed for a domain containing devices with power.irq_safe set,
although the .stop_device() and .start_device() callbacks are
still run for them.

Additionally, introduce a flag allowing the creator of a
struct generic_pm_domain object to indicate that its .stop_device()
and .start_device() callbacks may be run in interrupt context
(might_sleep_if() triggers if that flag is not set and one of those
callbacks is run in interrupt context).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |    1 +
 drivers/base/power/domain.c        |   19 ++++++++++++++++++-
 include/linux/pm_domain.h          |    1 +
 3 files changed, 20 insertions(+), 1 deletion(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -309,7 +309,8 @@ static int pm_genpd_poweroff(struct gene
 
 	not_suspended = 0;
 	list_for_each_entry(pdd, &genpd->dev_list, list_node)
-		if (pdd->dev->driver && !pm_runtime_suspended(pdd->dev))
+		if (pdd->dev->driver && (!pm_runtime_suspended(pdd->dev)
+		    || pdd->dev->power.irq_safe))
 			not_suspended++;
 
 	if (not_suspended > genpd->in_progress)
@@ -417,12 +418,21 @@ static int pm_genpd_runtime_suspend(stru
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
+	might_sleep_if(!genpd->dev_irq_safe);
+
 	if (genpd->stop_device) {
 		int ret = genpd->stop_device(dev);
 		if (ret)
 			return ret;
 	}
 
+	/*
+	 * If power.irq_safe is set, this routine will be run with interrupts
+	 * off, so it can't use mutexes.
+	 */
+	if (dev->power.irq_safe)
+		return 0;
+
 	mutex_lock(&genpd->lock);
 	genpd->in_progress++;
 	pm_genpd_poweroff(genpd);
@@ -452,6 +462,12 @@ static int pm_genpd_runtime_resume(struc
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
+	might_sleep_if(!genpd->dev_irq_safe);
+
+	/* If power.irq_safe, the PM domain is never powered off. */
+	if (dev->power.irq_safe)
+		goto out;
+
 	mutex_lock(&genpd->lock);
 	ret = __pm_genpd_poweron(genpd);
 	if (ret) {
@@ -483,6 +499,7 @@ static int pm_genpd_runtime_resume(struc
 	wake_up_all(&genpd->status_wait_queue);
 	mutex_unlock(&genpd->lock);
 
+ out:
 	if (genpd->start_device)
 		genpd->start_device(dev);
 
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -42,6 +42,7 @@ struct generic_pm_domain {
 	unsigned int suspended_count;	/* System suspend device counter */
 	unsigned int prepared_count;	/* Suspend counter of prepared devices */
 	bool suspend_power_off;	/* Power status before system suspend */
+	bool dev_irq_safe;	/* Device callbacks are IRQ-safe */
 	int (*power_off)(struct generic_pm_domain *domain);
 	int (*power_on)(struct generic_pm_domain *domain);
 	int (*start_device)(struct device *dev);
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -103,6 +103,7 @@ void sh7372_init_pm_domain(struct sh7372
 	pm_genpd_init(genpd, NULL, false);
 	genpd->stop_device = pm_clk_suspend;
 	genpd->start_device = pm_clk_resume;
+	genpd->dev_irq_safe = true;
 	genpd->active_wakeup = pd_active_wakeup;
 	genpd->power_off = pd_power_down;
 	genpd->power_on = pd_power_up;
