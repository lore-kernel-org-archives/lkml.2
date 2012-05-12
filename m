Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2ELTfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:35:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab2ELTfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:35:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update][RFC][PATCH 2/2] PM / Domains: Add preliminary cpuidle support
Date: Sat, 12 May 2012 21:40:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <201205092340.26561.rjw@sisk.pl> <201205092343.11050.rjw@sisk.pl>
In-Reply-To: <201205092343.11050.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205122140.07928.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

On some systems there are CPU cores located in the same power
domains as I/O devices.  Then, power can only be removed from the
domain if all I/O devices in it are not in use and the CPU core
is idle.  Add preliminary support for that to the generic PM domains
framework.

This assumes that all CPU cores in the system will be located in the
same power domain is supposed to be set up in the following way.

First, the platform is expected to provide a cpuidle driver with one
extra state designated for use with the generic PM domains code.
This state should be initially disabled and its exit_latency value
should be set to whatever time is needed to bring up the CPU core
itself after restoring power to it, not including the domain's
power on latency.  Its .enter() callback should point to a procedure
that will remove power from the domain containing the CPU core at
the end of the CPU power transition.

The remaining characteristics of the extra cpuidle state, referred to
as the "domain" cpuidle state below, (e.g. power usage, target
residency) should be populated in accordance with the properties of
the hardware.

Next, the platform should execute genpd_attach_cpuidle() on the PM
domain containing the CPU core.  That will cause the generic PM
domains framework to treat that domain in a special way such that:

 * When all devices in the domain have been suspended and it is about
   to be turned off, the states of the devices will be saved, but
   power will not be removed from the domain.  Instead, the "domain"
   cpuidle state will be enabled so that power can be removed from
   the domain when the CPU core is idle and the "domain" state has
   been chosen as the target by the cpuidle governor.  The "domain"
   state's .enter() callback is then reposible for removing power
   from the domain.

 * When the first I/O device in the domain is resumed and
   __pm_genpd_poweron(() is called for the first time after
   power has been removed from the domain, the "domain" cpuidle
   state will be disabled to avoid subsequent surprise power removals
   via cpuidle.

---
 drivers/base/power/domain.c |  115 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/pm_domain.h   |   17 ++++++
 2 files changed, 131 insertions(+), 1 deletion(-)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -15,6 +15,7 @@
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/notifier.h>
+#include <linux/cpuidle.h>
 
 enum gpd_status {
 	GPD_STATE_ACTIVE = 0,	/* PM domain is active */
@@ -45,6 +46,11 @@ struct gpd_dev_ops {
 	bool (*active_wakeup)(struct device *dev);
 };
 
+struct gpd_cpu_data {
+	unsigned int saved_exit_latency;
+	struct cpuidle_state *idle_state;
+};
+
 struct generic_pm_domain {
 	struct dev_pm_domain domain;	/* PM domain operations */
 	struct list_head gpd_list_node;	/* Node in the global PM domains list */
@@ -75,6 +81,7 @@ struct generic_pm_domain {
 	bool max_off_time_changed;
 	bool cached_power_down_ok;
 	struct device_node *of_node; /* Node in device tree */
+	struct gpd_cpu_data *cpu_data;
 };
 
 static inline struct generic_pm_domain *pd_to_genpd(struct dev_pm_domain *pd)
@@ -155,6 +162,8 @@ extern int pm_genpd_add_callbacks(struct
 				  struct gpd_dev_ops *ops,
 				  struct gpd_timing_data *td);
 extern int __pm_genpd_remove_callbacks(struct device *dev, bool clear_td);
+extern int genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state);
+extern int genpd_detach_cpuidle(struct generic_pm_domain *genpd);
 extern void pm_genpd_init(struct generic_pm_domain *genpd,
 			  struct dev_power_governor *gov, bool is_off);
 
@@ -211,6 +220,14 @@ static inline int __pm_genpd_remove_call
 {
 	return -ENOSYS;
 }
+static inline int genpd_attach_cpuidle(struct generic_pm_domain *genpd, int st)
+{
+	return -ENOSYS;
+}
+static inline int genpd_detach_cpuidle(struct generic_pm_domain *genpd)
+{
+	return -ENOSYS;
+}
 static inline void pm_genpd_init(struct generic_pm_domain *genpd,
 				 struct dev_power_governor *gov, bool is_off)
 {
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -139,6 +139,19 @@ static void genpd_set_active(struct gene
 		genpd->status = GPD_STATE_ACTIVE;
 }
 
+static void genpd_recalc_cpu_exit_latency(struct generic_pm_domain *genpd)
+{
+	s64 usecs64;
+
+	if (!genpd->cpu_data)
+		return;
+
+	usecs64 = genpd->power_on_latency_ns;
+	do_div(usecs64, NSEC_PER_USEC);
+	usecs64 += genpd->cpu_data->saved_exit_latency;
+	genpd->cpu_data->idle_state->exit_latency = usecs64;
+}
+
 /**
  * __pm_genpd_poweron - Restore power to a given PM domain and its masters.
  * @genpd: PM domain to power up.
@@ -203,7 +216,11 @@ int __pm_genpd_poweron(struct generic_pm
 		}
 	}
 
-	if (genpd->power_on) {
+	if (genpd->cpu_data) {
+		cpuidle_pause_and_lock();
+		genpd->cpu_data->idle_state->disable = true;
+		cpuidle_resume_and_unlock();
+	} else if (genpd->power_on) {
 		ktime_t time_start = ktime_get();
 		s64 elapsed_ns;
 
@@ -215,6 +232,7 @@ int __pm_genpd_poweron(struct generic_pm
 		if (elapsed_ns > genpd->power_on_latency_ns) {
 			genpd->power_on_latency_ns = elapsed_ns;
 			genpd->max_off_time_changed = true;
+			genpd_recalc_cpu_exit_latency(genpd);
 			if (genpd->name)
 				pr_warning("%s: Power-on latency exceeded, "
 					"new value %lld ns\n", genpd->name,
@@ -464,6 +482,21 @@ static int pm_genpd_poweroff(struct gene
 		}
 	}
 
+	if (genpd->cpu_data) {
+		/*
+		 * If cpu_data is set, cpuidle should turn the domain off when
+		 * the CPU in it is idle.  In that case we don't decrement the
+		 * subdomain counts of the master domains, so that power is not
+		 * removed from the current domain prematurely as a result of
+		 * cutting off the masters' power.
+		 */
+		genpd->status = GPD_STATE_POWER_OFF;
+		cpuidle_pause_and_lock();
+		genpd->cpu_data->idle_state->disable = false;
+		cpuidle_resume_and_unlock();
+		goto out;
+	}
+
 	if (genpd->power_off) {
 		ktime_t time_start;
 		s64 elapsed_ns;
@@ -1612,6 +1645,86 @@ int __pm_genpd_remove_callbacks(struct d
 }
 EXPORT_SYMBOL_GPL(__pm_genpd_remove_callbacks);
 
+int genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state)
+{
+	struct cpuidle_driver *cpuidle_drv;
+	struct gpd_cpu_data *cpu_data;
+	struct cpuidle_state *idle_state;
+	int ret = 0;
+
+	if (IS_ERR_OR_NULL(genpd) || state < 0)
+		return -EINVAL;
+
+	genpd_acquire_lock(genpd);
+
+	if (genpd->cpu_data) {
+		ret = -EEXIST;
+		goto out;
+	}
+	cpu_data = kzalloc(sizeof(*cpu_data), GFP_KERNEL);
+	if (!cpu_data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	cpuidle_drv = cpuidle_driver_ref();
+	if (!cpuidle_drv) {
+		ret = -ENODEV;
+		goto out;
+	}
+	if (cpuidle_drv->state_count <= state) {
+		ret = -EINVAL;
+		goto err;
+	}
+	idle_state = &cpuidle_drv->states[state];
+	if (!idle_state->disable) {
+		ret = -EAGAIN;
+		goto err;
+	}
+	cpu_data->idle_state = idle_state;
+	cpu_data->saved_exit_latency = idle_state->exit_latency;
+	genpd->cpu_data = cpu_data;
+	genpd_recalc_cpu_exit_latency(genpd);
+
+ out:
+	genpd_release_lock(genpd);
+	return ret;
+
+ err:
+	cpuidle_driver_unref();
+	goto out;
+}
+
+int genpd_detach_cpuidle(struct generic_pm_domain *genpd)
+{
+	struct gpd_cpu_data *cpu_data;
+	struct cpuidle_state *idle_state;
+	int ret = 0;
+
+	if (IS_ERR_OR_NULL(genpd))
+		return -EINVAL;
+
+	genpd_acquire_lock(genpd);
+
+	cpu_data = genpd->cpu_data;
+	if (!cpu_data) {
+		ret = -ENODEV;
+		goto out;
+	}
+	idle_state = cpu_data->idle_state;
+	if (!idle_state->disable) {
+		ret = -EAGAIN;
+		goto out;
+	}
+	idle_state->exit_latency = cpu_data->saved_exit_latency;
+	cpuidle_driver_unref();
+	genpd->cpu_data = NULL;
+	kfree(cpu_data);
+
+ out:
+	genpd_release_lock(genpd);
+	return ret;
+}
+
 /* Default device callbacks for generic PM domains. */
 
 /**
