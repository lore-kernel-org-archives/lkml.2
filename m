Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab1E0XTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:19:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550Ab1E0XTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:19:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/5] PM / Domains: Support for multiple generic power domain states
Date: Sat, 28 May 2011 01:18:52 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104290154.12966.rjw@sisk.pl> <201105160117.46927.rjw@sisk.pl> <201105280115.14556.rjw@sisk.pl>
In-Reply-To: <201105280115.14556.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105280118.52316.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Allow the generic power domains support code to handle power
domains with multiple states.  Replace the .power_down_ok()
callback in struct dev_power_governor with a new callback
.choose_state() that will return the number of the state to put the
power domain into.  Add new fields nr_states and current_state to
struct generic_power_domain with the assumption that state 0 will be
the full power state and states 1 through (nr_states - 1) will be low
power.  Replace power domain callbacks .power_off() and .power_on()
with a single .set_state() callback taking the number of the state
to put the power domain into as its second argument.  Add a new
generic power domain callback .power_off_state() (taking a state
number as its second argument) allowing the core to check if
device runtime PM callbacks need to be executed before putting the
given power domain into the given state.  Modify the core power
domains code and the ARM shmobile platform code to take all of the
above changes into account.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-shmobile/pm-sh7372.c |   11 ++++--
 drivers/base/power/domain.c        |   60 +++++++++++++++++++++++++++----------
 include/linux/pm_domain.h          |   16 ++++++---
 3 files changed, 63 insertions(+), 24 deletions(-)

Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -12,7 +12,7 @@
 #include <linux/device.h>
 
 struct dev_power_governor {
-	bool (*power_down_ok)(struct dev_power_domain *domain);
+	int (*choose_state)(struct dev_power_domain *domain);
 };
 
 struct generic_power_domain {
@@ -23,12 +23,14 @@ struct generic_power_domain {
 	struct list_head device_list;
 	struct mutex lock;
 	struct dev_power_governor *gov;
-	unsigned int in_progress;
+	int nr_states;
+	int current_state;
 	bool power_is_off;
+	unsigned int in_progress;
 	unsigned int device_count;
 	unsigned int suspended_count;
-	int (*power_off)(struct dev_power_domain *domain);
-	int (*power_on)(struct dev_power_domain *domain);
+	int (*set_state)(struct dev_power_domain *domain, int state);
+	bool (*power_off_state)(struct dev_power_domain *domain, int state);
 	int (*start_device)(struct device *dev);
 	int (*stop_device)(struct device *dev);
 };
@@ -48,7 +50,8 @@ extern int pm_genpd_add_subdomain(struct
 extern int pm_genpd_remove_subdomain(struct generic_power_domain *genpd,
 				     struct generic_power_domain *target);
 extern void pm_genpd_init(struct generic_power_domain *genpd,
-			  struct dev_power_governor *gov, bool is_off);
+			  struct dev_power_governor *gov, int nr_states,
+			  int cur_state);
 #else
 static inline int pm_genpd_add_device(struct generic_power_domain *genpd,
 				      struct device *dev)
@@ -71,7 +74,8 @@ static inline int pm_genpd_remove_subdom
 	return -ENOSYS;
 }
 static inline void pm_genpd_init(struct generic_power_domain *genpd,
-				 struct dev_power_governor *gov, bool is_off) {}
+				 struct dev_power_governor *gov,
+				 int nr_states, int cur_state) {}
 #endif
 
 #endif /* _LINUX_PM_DOMAIN_H */
Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -62,6 +62,7 @@ static int __pm_genpd_poweroff(struct ge
 	struct generic_power_domain *subdomain;
 	struct dev_list_entry *dle;
 	unsigned int not_suspended;
+	int new_state;
 	int ret;
 
 	if (genpd->power_is_off)
@@ -83,9 +84,23 @@ static int __pm_genpd_poweroff(struct ge
 			return ret;
 	}
 
-	if (genpd->gov && genpd->gov->power_down_ok) {
-		if (!genpd->gov->power_down_ok(&genpd->domain))
-			return -EAGAIN;
+	new_state = (genpd->gov && genpd->gov->choose_state) ?
+			genpd->gov->choose_state(&genpd->domain) : 1;
+	if (new_state < 0 || new_state >= genpd->nr_states)
+		return -EAGAIN;
+
+	if (new_state == genpd->current_state)
+		return 0;
+
+	if (genpd->power_off_state
+	    && !genpd->power_off_state(&genpd->domain, new_state)) {
+		if (genpd->set_state) {
+			ret = genpd->set_state(&genpd->domain, new_state);
+			if (ret)
+				return ret;
+		}
+		genpd->current_state = new_state;
+		return 0;
 	}
 
 	list_for_each_entry_reverse(dle, &genpd->device_list, node) {
@@ -105,9 +120,13 @@ static int __pm_genpd_poweroff(struct ge
 			goto err_dev;
 	}
 
-	if (genpd->power_off)
-		genpd->power_off(&genpd->domain);
+	if (genpd->set_state) {
+		ret = genpd->set_state(&genpd->domain, new_state);
+		if (ret)
+			goto err_dev;
+	}
 
+	genpd->current_state = new_state;
 	genpd->power_is_off = true;
 
 	return 0;
@@ -199,14 +218,17 @@ static int __pm_genpd_poweron(struct gen
 {
 	struct dev_list_entry *dle;
 
-	if (!genpd->power_is_off)
+	if (genpd->current_state == 0)
 		return 0;
 
-	if (genpd->power_on) {
-		int ret = genpd->power_on(&genpd->domain);
+	if (genpd->set_state) {
+		int ret = genpd->set_state(&genpd->domain, 0);
 		if (ret)
 			return ret;
 	}
+	genpd->current_state = 0;
+	if (!genpd->power_is_off)
+		return 0;
 
 	genpd->power_is_off = false;
 
@@ -363,8 +385,8 @@ static int pm_genpd_suspend_noirq(struct
 
 	mutex_lock(&genpd->lock);
 	if (++genpd->suspended_count == genpd->device_count) {
-		if (genpd->power_off)
-			genpd->power_off(&genpd->domain);
+		if (genpd->set_state)
+			genpd->set_state(&genpd->domain, genpd->nr_states - 1);
 	}
 	mutex_unlock(&genpd->lock);
 
@@ -395,8 +417,8 @@ static int pm_genpd_resume_noirq(struct
 
 	mutex_lock(&genpd->lock);
 	if (genpd->suspended_count == genpd->device_count) {
-		if (genpd->power_on) {
-			int ret = genpd->power_on(&genpd->domain);
+		if (genpd->set_state) {
+			int ret = genpd->set_state(&genpd->domain, 0);
 			if (ret) {
 				mutex_unlock(&genpd->lock);
 				return ret;
@@ -713,10 +735,12 @@ int pm_genpd_remove_subdomain(struct gen
  * pm_genpd_init - Initialize a generic I/O power domain object.
  * @genpd: Power domain object to initialize.
  * @gov: Power domain governor to associate with the domain (may be NULL).
- * @is_off: Initial value of the domain's power_is_off field.
+ * @nr_states: Number of power domain states (must be greater than 1).
+ * @cur_state: Initial state of the power domain.
  */
 void pm_genpd_init(struct generic_power_domain *genpd,
-		   struct dev_power_governor *gov, bool is_off)
+		   struct dev_power_governor *gov, int nr_states,
+		   int cur_state)
 {
 	if (IS_ERR_OR_NULL(genpd))
 		return;
@@ -727,8 +751,14 @@ void pm_genpd_init(struct generic_power_
 	INIT_LIST_HEAD(&genpd->subdomain_list);
 	mutex_init(&genpd->lock);
 	genpd->gov = gov;
+	genpd->nr_states = nr_states > 1 ? nr_states : 2;
+	if (cur_state < 0 || cur_state >= nr_states)
+		cur_state = 0;
+	genpd->current_state = cur_state;
+	genpd->power_is_off = genpd->power_off_state ?
+		genpd->power_off_state(&genpd->domain, cur_state) :
+			(cur_state > 0);
 	genpd->in_progress = 0;
-	genpd->power_is_off = is_off;
 	genpd->device_count = 0;
 	genpd->suspended_count = 0;
 	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -70,15 +70,20 @@ static int pd_power_up(struct dev_power_
 	return 0;
 }
 
+static int pd_set_state(struct dev_power_domain *domain, int state)
+{
+	return state > 0 ? pd_power_down(domain) : pd_power_up(domain);
+}
+
 static void sh7372_init_domain(struct generic_power_domain *domain,
 			       struct sh7372_domain_data *pdata)
 {
-	pm_genpd_init(domain, NULL, false);
 	domain->domain.platform_data = pdata;
 	domain->stop_device = pm_runtime_clk_suspend;
 	domain->start_device = pm_runtime_clk_resume;
-	domain->power_off = pd_power_down;
-	domain->power_on = pd_power_up;
+	domain->set_state = pd_set_state;
+	domain->power_off_state = NULL;
+	pm_genpd_init(domain, NULL, 2, 0);
 }
 
 void sh7372_add_device_to_domain(struct generic_power_domain *domain,

