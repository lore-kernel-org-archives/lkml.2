Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1LEASh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 19:18:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41329 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab1LEASg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 19:18:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [Update][PATCH] PM / sh7372: Make domain stay_on bit only affect system suspend
Date: Mon, 5 Dec 2011 01:21:31 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <201112042308.14255.rjw@sisk.pl> <201112050117.05214.rjw@sisk.pl>
In-Reply-To: <201112050117.05214.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112050121.31492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

SH7372 uses two independent mechanisms for ensuring that power
domains will never be turned off: the stay_on flag and the "always
on" domain governor.  However, the "always on" governor is only taken
into accout by runtime PM code paths, while the stay_on flag affects
all attempts to turn the given domain off.  This is a problem for
domains that only need to stay in the "power on" state during system
sleep, but may be turned off by runtime PM if specific conditions are
satisfied.

For this reason, make SH7372 register a PM notifier that will enable
the checking of the domain stay_on flag on during system suspend and
disable it during system resume.  This way, the stay_on flag will
only affect system sleep states, while the "always on" governor will
only affect runtime PM.

In addition to that, make sure that all domains which should be in
the "power on" state during system sleep are turned on beforehand, by
executing pm_genpd_poweron() for all of them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |   34 +++++++++++++++++++++++++++++++---
 drivers/base/power/domain.c        |   28 ++++++++++++++++++++--------
 include/linux/pm_domain.h          |    4 ++++
 3 files changed, 55 insertions(+), 11 deletions(-)

Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -77,6 +77,8 @@
 
 #ifdef CONFIG_PM
 
+static bool system_pm_transition;
+
 static int pd_power_down(struct generic_pm_domain *genpd)
 {
 	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
@@ -85,8 +87,8 @@ static int pd_power_down(struct generic_
 	if (sh7372_pd->suspend)
 		sh7372_pd->suspend();
 
-	if (sh7372_pd->stay_on)
-		return 0;
+	if (system_pm_transition && sh7372_pd->stay_on)
+		return -EBUSY;
 
 	if (__raw_readl(PSTR) & mask) {
 		unsigned int retry_count;
@@ -113,7 +115,7 @@ static int __pd_power_up(struct sh7372_p
 	unsigned int retry_count;
 	int ret = 0;
 
-	if (sh7372_pd->stay_on)
+	if (sh7372_pd->genpd.status != GPD_STATE_POWER_OFF)
 		goto out;
 
 	if (__raw_readl(PSTR) & mask)
@@ -506,9 +508,35 @@ static int sh7372_enter_suspend(suspend_
 	return 0;
 }
 
+static void sh7372_pm_power_on_for_suspend(struct generic_pm_domain *genpd)
+{
+	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
+
+	if (sh7372_pd->stay_on)
+		pm_genpd_poweron(genpd);
+}
+
+static int sh7372_pm_notifier_fn(struct notifier_block *notifier,
+				 unsigned long pm_event, void *unused)
+{
+	switch (pm_event) {
+	case PM_SUSPEND_PREPARE:
+		system_pm_transition = true;
+		pm_genpd_for_each_domain(sh7372_pm_power_on_for_suspend);
+		break;
+	case PM_POST_SUSPEND:
+		system_pm_transition = false;
+		pm_genpd_poweroff_unused();
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static void sh7372_suspend_init(void)
 {
 	shmobile_suspend_ops.enter = sh7372_enter_suspend;
+	pm_notifier(sh7372_pm_notifier_fn, 0);
 }
 #else
 static void sh7372_suspend_init(void) {}
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -243,6 +243,25 @@ int pm_genpd_poweron(struct generic_pm_d
 	return ret;
 }
 
+/**
+ * pm_genpd_for_each_domain - Execute function for each generic PM domain.
+ * @fun: Function to execute.
+ */
+void pm_genpd_for_each_domain(void (*fun)(struct generic_pm_domain *))
+{
+	struct generic_pm_domain *genpd;
+
+	if (!fun)
+		return;
+
+	mutex_lock(&gpd_list_lock);
+
+	list_for_each_entry(genpd, &gpd_list, gpd_list_node)
+		fun(genpd);
+
+	mutex_unlock(&gpd_list_lock);
+}
+
 #endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_RUNTIME
@@ -598,14 +617,7 @@ static int pm_genpd_runtime_resume(struc
  */
 void pm_genpd_poweroff_unused(void)
 {
-	struct generic_pm_domain *genpd;
-
-	mutex_lock(&gpd_list_lock);
-
-	list_for_each_entry(genpd, &gpd_list, gpd_list_node)
-		genpd_queue_power_off_work(genpd);
-
-	mutex_unlock(&gpd_list_lock);
+	pm_genpd_for_each_domain(genpd_queue_power_off_work);
 }
 
 #else
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -137,6 +137,7 @@ extern void pm_genpd_init(struct generic
 			  struct dev_power_governor *gov, bool is_off);
 
 extern int pm_genpd_poweron(struct generic_pm_domain *genpd);
+extern void pm_genpd_for_each_domain(void (*fun)(struct generic_pm_domain *));
 
 extern bool default_stop_ok(struct device *dev);
 
@@ -189,6 +190,9 @@ static inline int pm_genpd_poweron(struc
 {
 	return -ENOSYS;
 }
+static inline void pm_genpd_for_each_domain(void (*fun)(struct generic_pm_domain *))
+{
+}
 static inline bool default_stop_ok(struct device *dev)
 {
 	return false;

