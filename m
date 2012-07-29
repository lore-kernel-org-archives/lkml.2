Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2G2ONh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 10:13:37 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:33612 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab2G2OMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 10:12:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 2/6] PM / Domains: Add power off/on function for system core suspend stage
Date: Sun, 29 Jul 2012 16:14:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201207291612.43138.rjw@sisk.pl>
In-Reply-To: <201207291612.43138.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207291614.19792.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce function pm_genpd_syscore_switch() and two wrappers around
it, pm_genpd_syscore_poweroff() and pm_genpd_syscore_poweron(),
allowing the callers to let the generic PM domains framework know
that the given device is not necessary any more and its PM domain
can be turned off (the former) or that the given device will be
required immediately, so its PM domain has to be turned on (the
latter) during the system core (syscore) stage of system suspend
(or hibernation) and resume.

These functions will be used for handling devices registered as
clock sources and clock event devices that belong to PM domains.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   60 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/pm_domain.h   |   13 +++++++++
 2 files changed, 67 insertions(+), 6 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -63,6 +63,24 @@ struct generic_pm_domain *dev_to_genpd(s
 	return pd_to_genpd(dev->pm_domain);
 }
 
+/**
+ * pm_genpd_present - Check if the given PM domain has been initialized.
+ * @genpd: PM domain to check.
+ */
+static bool pm_genpd_present(struct generic_pm_domain *genpd)
+{
+	struct generic_pm_domain *gpd;
+
+	if (IS_ERR_OR_NULL(genpd))
+		return false;
+
+	list_for_each_entry(gpd, &gpd_list, gpd_list_node)
+		if (gpd == genpd)
+			return true;
+
+	return false;
+}
+
 static int genpd_stop_dev(struct generic_pm_domain *genpd, struct device *dev)
 {
 	return GENPD_DEV_TIMED_CALLBACK(genpd, int, stop, dev,
@@ -750,9 +768,10 @@ static int genpd_thaw_dev(struct generic
  * Check if the given PM domain can be powered off (during system suspend or
  * hibernation) and do that if so.  Also, in that case propagate to its masters.
  *
- * This function is only called in "noirq" stages of system power transitions,
- * so it need not acquire locks (all of the "noirq" callbacks are executed
- * sequentially, so it is guaranteed that it will never run twice in parallel).
+ * This function is only called in "noirq" and "syscore" stages of system power
+ * transitions, so it need not acquire locks (all of the "noirq" callbacks are
+ * executed sequentially, so it is guaranteed that it will never run twice in
+ * parallel).
  */
 static void pm_genpd_sync_poweroff(struct generic_pm_domain *genpd)
 {
@@ -780,9 +799,10 @@ static void pm_genpd_sync_poweroff(struc
  * pm_genpd_sync_poweron - Synchronously power on a PM domain and its masters.
  * @genpd: PM domain to power on.
  *
- * This function is only called in "noirq" stage of system power transitions, so
- * it need not acquire locks (all of the "noirq" callbacks are executed
- * sequentially, so it is guaranteed that it will never run twice in parallel).
+ * This function is only called in "noirq" and "syscore" stages of system power
+ * transitions, so it need not acquire locks (all of the "noirq" callbacks are
+ * executed sequentially, so it is guaranteed that it will never run twice in
+ * parallel).
  */
 static void pm_genpd_sync_poweron(struct generic_pm_domain *genpd)
 {
@@ -1272,6 +1292,34 @@ static void pm_genpd_complete(struct dev
 	}
 }
 
+/**
+ * pm_genpd_syscore_switch - Switch power during system core suspend or resume.
+ * @dev: Device that normally is marked as "always on" to switch power for.
+ *
+ * This routine may only be called during the system core (syscore) suspend or
+ * resume phase for devices whose "always on" flags are set.
+ */
+void pm_genpd_syscore_switch(struct device *dev, bool suspend)
+{
+	struct generic_pm_domain *genpd;
+
+	genpd = dev_to_genpd(dev);
+	if (!pm_genpd_present(genpd))
+		return;
+
+	if (!dev_gpd_data(dev)->always_on)
+		return;
+
+	if (suspend) {
+		genpd->suspended_count++;
+		pm_genpd_sync_poweroff(genpd);
+	} else {
+		pm_genpd_sync_poweron(genpd);
+		genpd->suspended_count--;
+	}
+}
+EXPORT_SYMBOL_GPL(pm_genpd_syscore_switch);
+
 #else
 
 #define pm_genpd_prepare		NULL
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -172,6 +172,8 @@ extern int pm_genpd_poweron(struct gener
 
 extern bool default_stop_ok(struct device *dev);
 
+extern void pm_genpd_syscore_switch(struct device *dev, bool suspend);
+
 extern struct dev_power_governor pm_domain_always_on_gov;
 #else
 
@@ -241,6 +243,7 @@ static inline bool default_stop_ok(struc
 {
 	return false;
 }
+static inline void pm_genpd_syscore_switch(struct device *dev, bool suspend) {}
 #define simple_qos_governor NULL
 #define pm_domain_always_on_gov NULL
 #endif
@@ -250,6 +253,16 @@ static inline int pm_genpd_remove_callba
 	return __pm_genpd_remove_callbacks(dev, true);
 }
 
+static inline void pm_genpd_syscore_poweroff(struct device *dev)
+{
+	pm_genpd_syscore_switch(dev, true);
+}
+
+static inline void pm_genpd_syscore_poweron(struct device *dev)
+{
+	pm_genpd_syscore_switch(dev, false);
+}
+
 #ifdef CONFIG_PM_GENERIC_DOMAINS_RUNTIME
 extern void genpd_queue_power_off_work(struct generic_pm_domain *genpd);
 extern void pm_genpd_poweroff_unused(void);

