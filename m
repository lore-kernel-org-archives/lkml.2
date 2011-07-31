Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1GaRxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:53:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36730 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab1GaRwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:52:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 6/9] PM / Domains: Allow generic PM domains to have multiple masters
Date: Sun, 31 Jul 2011 19:50:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
References: <201107311946.06654.rjw@sisk.pl>
In-Reply-To: <201107311946.06654.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107311950.54867.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, for a given generic PM domain there may be only one parent
domain (i.e. a PM domain it depends on).  However, there is at least
one real-life case in which there should be two parents (masters) for
one PM domain (the A3RV domain on SH7372 turns out to depend on the
A4LC domain and it depends on the A4R domain and the same time). For
this reason, allow a PM domain to have multiple parents (masters) by
introducing objects representing links between PM domains.

The (logical) links between PM domains represent relationships in
which one domain is a master (i.e. it is depended on) and another
domain is a slave (i.e. it depends on the master) with the rule that
the slave cannot be powered on if the master is not powered on and
the master cannot be powered off if the slave is not powered off.
Each struct generic_pm_domain object representing a PM domain has
two lists of links, a list of links in which it is a master and
a list of links in which it is a slave.  The first of these lists
replaces the list of subdomains and the second one is used in place
of the parent pointer.

Each link is represented by struct gpd_link object containing
pointers to the master and the slave and two struct list_head
members allowing it to hook into two lists (the master's list
of "master" links and the slave's list of "slave" links).  This
allows the code to get to the link from each side (either from
the master or from the slave) and follow it in each direction.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   99 +++++++++++++++++++++++++-------------------
 include/linux/pm_domain.h   |   12 ++++-
 2 files changed, 67 insertions(+), 44 deletions(-)

Index: linux-2.6/include/linux/pm_domain.h
===================================================================
--- linux-2.6.orig/include/linux/pm_domain.h
+++ linux-2.6/include/linux/pm_domain.h
@@ -26,9 +26,8 @@ struct dev_power_governor {
 struct generic_pm_domain {
 	struct dev_pm_domain domain;	/* PM domain operations */
 	struct list_head gpd_list_node;	/* Node in the global PM domains list */
-	struct list_head sd_node;	/* Node in the parent's subdomain list */
-	struct generic_pm_domain *parent;	/* Parent PM domain */
-	struct list_head sd_list;	/* List of dubdomains */
+	struct list_head master_links;	/* Links with PM domain as a master */
+	struct list_head slave_links;	/* Links with PM domain as a slave */
 	struct list_head dev_list;	/* List of devices */
 	struct mutex lock;
 	struct dev_power_governor *gov;
@@ -55,6 +54,13 @@ static inline struct generic_pm_domain *
 	return container_of(pd, struct generic_pm_domain, domain);
 }
 
+struct gpd_link {
+	struct generic_pm_domain *master;
+	struct list_head master_node;
+	struct generic_pm_domain *slave;
+	struct list_head slave_node;
+};
+
 struct dev_list_entry {
 	struct list_head node;
 	struct device *dev;
Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -81,19 +81,20 @@ static void genpd_set_active(struct gene
 }
 
 /**
- * __pm_genpd_poweron - Restore power to a given PM domain and its parents.
+ * __pm_genpd_poweron - Restore power to a given PM domain and its masters.
  * @genpd: PM domain to power up.
  *
- * Restore power to @genpd and all of its parents so that it is possible to
+ * Restore power to @genpd and all of its masters so that it is possible to
  * resume a device belonging to it.
  */
 int __pm_genpd_poweron(struct generic_pm_domain *genpd)
 	__releases(&genpd->lock) __acquires(&genpd->lock)
 {
+	struct gpd_link *link;
 	DEFINE_WAIT(wait);
 	int ret = 0;
 
-	/* If the domain's parent is being waited for, we have to wait too. */
+	/* If the domain's master is being waited for, we have to wait too. */
 	for (;;) {
 		prepare_to_wait(&genpd->status_wait_queue, &wait,
 				TASK_UNINTERRUPTIBLE);
@@ -116,24 +117,31 @@ int __pm_genpd_poweron(struct generic_pm
 		return 0;
 	}
 
-	if (genpd->parent) {
-		genpd_sd_counter_inc(genpd->parent);
+	/*
+	 * The list is guaranteed not to change while the loop below is being
+	 * executed, unless one of the masters' .power_on() callbacks fiddles
+	 * with it.
+	 */
+	list_for_each_entry(link, &genpd->slave_links, slave_node) {
+		genpd_sd_counter_inc(link->master);
 		genpd->status = GPD_STATE_WAIT_PARENT;
 
 		mutex_unlock(&genpd->lock);
 
-		ret = pm_genpd_poweron(genpd->parent);
+		ret = pm_genpd_poweron(link->master);
 
 		mutex_lock(&genpd->lock);
 
 		/*
 		 * The "wait for parent" status is guaranteed not to change
-		 * while the parent is powering on.
+		 * while the master is powering on.
 		 */
 		genpd->status = GPD_STATE_POWER_OFF;
 		wake_up_all(&genpd->status_wait_queue);
-		if (ret)
+		if (ret) {
+			genpd_sd_counter_dec(link->master);
 			goto err;
+		}
 	}
 
 	if (genpd->power_on) {
@@ -147,14 +155,14 @@ int __pm_genpd_poweron(struct generic_pm
 	return 0;
 
  err:
-	if (genpd->parent)
-		genpd_sd_counter_dec(genpd->parent);
+	list_for_each_entry_continue_reverse(link, &genpd->slave_links, slave_node)
+		genpd_sd_counter_dec(link->master);
 
 	return ret;
 }
 
 /**
- * pm_genpd_poweron - Restore power to a given PM domain and its parents.
+ * pm_genpd_poweron - Restore power to a given PM domain and its masters.
  * @genpd: PM domain to power up.
  */
 int pm_genpd_poweron(struct generic_pm_domain *genpd)
@@ -278,8 +286,8 @@ void genpd_queue_power_off_work(struct g
 static int pm_genpd_poweroff(struct generic_pm_domain *genpd)
 	__releases(&genpd->lock) __acquires(&genpd->lock)
 {
-	struct generic_pm_domain *parent;
 	struct dev_list_entry *dle;
+	struct gpd_link *link;
 	unsigned int not_suspended;
 	int ret = 0;
 
@@ -287,7 +295,7 @@ static int pm_genpd_poweroff(struct gene
 	/*
 	 * Do not try to power off the domain in the following situations:
 	 * (1) The domain is already in the "power off" state.
-	 * (2) The domain is waiting for its parent to power up.
+	 * (2) The domain is waiting for its master to power up.
 	 * (3) One of the domain's devices is being resumed right now.
 	 * (4) System suspend is in progress.
 	 */
@@ -349,8 +357,8 @@ static int pm_genpd_poweroff(struct gene
 		}
 
 		/*
-		 * If sd_count > 0 at this point, one of the children hasn't
-		 * managed to call pm_genpd_poweron() for the parent yet after
+		 * If sd_count > 0 at this point, one of the subdomains hasn't
+		 * managed to call pm_genpd_poweron() for the master yet after
 		 * incrementing it.  In that case pm_genpd_poweron() will wait
 		 * for us to drop the lock, so we can call .power_off() and let
 		 * the pm_genpd_poweron() restore power for us (this shouldn't
@@ -365,9 +373,10 @@ static int pm_genpd_poweroff(struct gene
 
 	genpd->status = GPD_STATE_POWER_OFF;
 
-	parent = genpd->parent;
-	if (parent && genpd_sd_counter_dec(parent))
-		genpd_queue_power_off_work(parent);
+	list_for_each_entry(link, &genpd->slave_links, slave_node) {
+		genpd_sd_counter_dec(link->master);
+		genpd_queue_power_off_work(link->master);
+	}
 
  out:
 	genpd->poweroff_task = NULL;
@@ -512,11 +521,11 @@ static inline void __pm_genpd_runtime_re
 #ifdef CONFIG_PM_SLEEP
 
 /**
- * pm_genpd_sync_poweroff - Synchronously power off a PM domain and its parents.
+ * pm_genpd_sync_poweroff - Synchronously power off a PM domain and its masters.
  * @genpd: PM domain to power off, if possible.
  *
  * Check if the given PM domain can be powered off (during system suspend or
- * hibernation) and do that if so.  Also, in that case propagate to its parent.
+ * hibernation) and do that if so.  Also, in that case propagate to its masters.
  *
  * This function is only called in "noirq" stages of system power transitions,
  * so it need not acquire locks (all of the "noirq" callbacks are executed
@@ -524,7 +533,7 @@ static inline void __pm_genpd_runtime_re
  */
 static void pm_genpd_sync_poweroff(struct generic_pm_domain *genpd)
 {
-	struct generic_pm_domain *parent = genpd->parent;
+	struct gpd_link *link;
 
 	if (genpd->status == GPD_STATE_POWER_OFF)
 		return;
@@ -537,9 +546,10 @@ static void pm_genpd_sync_poweroff(struc
 		genpd->power_off(genpd);
 
 	genpd->status = GPD_STATE_POWER_OFF;
-	if (parent) {
-		genpd_sd_counter_dec(parent);
-		pm_genpd_sync_poweroff(parent);
+
+	list_for_each_entry(link, &genpd->slave_links, slave_node) {
+		genpd_sd_counter_dec(link->master);
+		pm_genpd_sync_poweroff(link->master);
 	}
 }
 
@@ -1158,7 +1168,7 @@ int pm_genpd_remove_device(struct generi
 int pm_genpd_add_subdomain(struct generic_pm_domain *genpd,
 			   struct generic_pm_domain *new_subdomain)
 {
-	struct generic_pm_domain *subdomain;
+	struct gpd_link *link;
 	int ret = 0;
 
 	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(new_subdomain))
@@ -1181,16 +1191,23 @@ int pm_genpd_add_subdomain(struct generi
 		goto out;
 	}
 
-	list_for_each_entry(subdomain, &genpd->sd_list, sd_node) {
-		if (subdomain == new_subdomain) {
+	list_for_each_entry(link, &genpd->slave_links, slave_node) {
+		if (link->slave == new_subdomain && link->master == genpd) {
 			ret = -EINVAL;
 			goto out;
 		}
 	}
 
-	list_add_tail(&new_subdomain->sd_node, &genpd->sd_list);
-	new_subdomain->parent = genpd;
-	if (subdomain->status != GPD_STATE_POWER_OFF)
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	link->master = genpd;
+	list_add_tail(&link->master_node, &genpd->master_links);
+	link->slave = new_subdomain;
+	list_add_tail(&link->slave_node, &new_subdomain->slave_links);
+	if (new_subdomain->status != GPD_STATE_POWER_OFF)
 		genpd_sd_counter_inc(genpd);
 
  out:
@@ -1203,22 +1220,22 @@ int pm_genpd_add_subdomain(struct generi
 /**
  * pm_genpd_remove_subdomain - Remove a subdomain from an I/O PM domain.
  * @genpd: Master PM domain to remove the subdomain from.
- * @target: Subdomain to be removed.
+ * @subdomain: Subdomain to be removed.
  */
 int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
-			      struct generic_pm_domain *target)
+			      struct generic_pm_domain *subdomain)
 {
-	struct generic_pm_domain *subdomain;
+	struct gpd_link *link;
 	int ret = -EINVAL;
 
-	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(target))
+	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(subdomain))
 		return -EINVAL;
 
  start:
 	genpd_acquire_lock(genpd);
 
-	list_for_each_entry(subdomain, &genpd->sd_list, sd_node) {
-		if (subdomain != target)
+	list_for_each_entry(link, &genpd->master_links, master_node) {
+		if (link->slave != subdomain)
 			continue;
 
 		mutex_lock_nested(&subdomain->lock, SINGLE_DEPTH_NESTING);
@@ -1230,8 +1247,9 @@ int pm_genpd_remove_subdomain(struct gen
 			goto start;
 		}
 
-		list_del(&subdomain->sd_node);
-		subdomain->parent = NULL;
+		list_del(&link->master_node);
+		list_del(&link->slave_node);
+		kfree(link);
 		if (subdomain->status != GPD_STATE_POWER_OFF)
 			genpd_sd_counter_dec(genpd);
 
@@ -1258,10 +1276,9 @@ void pm_genpd_init(struct generic_pm_dom
 	if (IS_ERR_OR_NULL(genpd))
 		return;
 
-	INIT_LIST_HEAD(&genpd->sd_node);
-	genpd->parent = NULL;
+	INIT_LIST_HEAD(&genpd->master_links);
+	INIT_LIST_HEAD(&genpd->slave_links);
 	INIT_LIST_HEAD(&genpd->dev_list);
-	INIT_LIST_HEAD(&genpd->sd_list);
 	mutex_init(&genpd->lock);
 	genpd->gov = gov;
 	INIT_WORK(&genpd->power_off_work, genpd_power_off_work_fn);

