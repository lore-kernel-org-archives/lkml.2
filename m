Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1GJUrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:47:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43412 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab1GJUr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:47:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/2] PM / Domains: Introduce function to power off all unused PM domains
Date: Sun, 10 Jul 2011 22:46:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "Linux-SH" <linux-sh@vger.kernel.org>
References: <201107102246.05107.rjw@sisk.pl>
In-Reply-To: <201107102246.05107.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107102246.56059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a new function pm_genpd_poweroff_unused() queuing up the
execution of pm_genpd_poweroff() for every initialized generic PM
domain.  Calling it will cause every generic PM domain without
devices in use to be powered off.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   21 +++++++++++++++++++++
 include/linux/pm_domain.h   |    3 +++
 2 files changed, 24 insertions(+)

Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -24,6 +24,7 @@ struct dev_power_governor {
 
 struct generic_pm_domain {
 	struct dev_pm_domain domain;	/* PM domain operations */
+	struct list_head gpd_list_node;	/* Node in the global PM domains list */
 	struct list_head sd_node;	/* Node in the parent's subdomain list */
 	struct generic_pm_domain *parent;	/* Parent PM domain */
 	struct list_head sd_list;	/* List of dubdomains */
@@ -71,6 +72,7 @@ extern int pm_genpd_remove_subdomain(str
 extern void pm_genpd_init(struct generic_pm_domain *genpd,
 			  struct dev_power_governor *gov, bool is_off);
 extern int pm_genpd_poweron(struct generic_pm_domain *genpd);
+extern void pm_genpd_poweroff_unused(void);
 #else
 static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
 				      struct device *dev)
@@ -98,6 +100,7 @@ static inline int pm_genpd_poweron(struc
 {
 	return -ENOSYS;
 }
+static inline void pm_genpd_poweroff_unused(void) {}
 #endif
 
 #endif /* _LINUX_PM_DOMAIN_H */
Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -16,6 +16,9 @@
 #include <linux/sched.h>
 #include <linux/suspend.h>
 
+static LIST_HEAD(gpd_list);
+static DEFINE_MUTEX(gpd_list_lock);
+
 #ifdef CONFIG_PM
 
 static struct generic_pm_domain *dev_to_genpd(struct device *dev)
@@ -1241,4 +1244,22 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->domain.ops.restore_noirq = pm_genpd_restore_noirq;
 	genpd->domain.ops.restore = pm_genpd_restore;
 	genpd->domain.ops.complete = pm_genpd_complete;
+	mutex_lock(&gpd_list_lock);
+	list_add(&genpd->gpd_list_node, &gpd_list);
+	mutex_unlock(&gpd_list_lock);
+}
+
+/**
+ * pm_genpd_poweroff_unused - Power off all PM domains with no devices in use.
+ */
+void pm_genpd_poweroff_unused(void)
+{
+	struct generic_pm_domain *genpd;
+
+	mutex_lock(&gpd_list_lock);
+
+	list_for_each_entry(genpd, &gpd_list, gpd_list_node)
+		genpd_queue_power_off_work(genpd);
+
+	mutex_unlock(&gpd_list_lock);
 }

