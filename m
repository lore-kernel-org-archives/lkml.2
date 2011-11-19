Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab1KSOAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 09:00:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47378 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1KSOAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 09:00:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update 2x][PATCH 6/7] PM / Domains: Add default power off governor function (v4)
Date: Sat, 19 Nov 2011 15:01:56 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
References: <201111070101.33960.rjw@sisk.pl> <201111140122.27328.rjw@sisk.pl> <201111191456.40453.rjw@sisk.pl>
In-Reply-To: <201111191456.40453.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111191501.56519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a function deciding whether or not a given PM domain should
be powered off on the basis of the PM QoS constraints of devices
belonging to it and their PM QoS timing data.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c          |   12 +++
 drivers/base/power/domain_governor.c |  110 +++++++++++++++++++++++++++++++++++
 include/linux/pm_domain.h            |    7 ++
 3 files changed, 129 insertions(+)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -57,8 +57,13 @@ struct generic_pm_domain {
 	bool suspend_power_off;	/* Power status before system suspend */
 	bool dev_irq_safe;	/* Device callbacks are IRQ-safe */
 	int (*power_off)(struct generic_pm_domain *domain);
+	s64 power_off_latency_ns;
 	int (*power_on)(struct generic_pm_domain *domain);
+	s64 power_on_latency_ns;
 	struct gpd_dev_ops dev_ops;
+	s64 break_even_ns;	/* Power break even for the entire domain. */
+	s64 max_off_time_ns;	/* Maximum allowed "suspended" time. */
+	ktime_t power_off_time;
 };
 
 static inline struct generic_pm_domain *pd_to_genpd(struct dev_pm_domain *pd)
@@ -76,6 +81,8 @@ struct gpd_link {
 struct gpd_timing_data {
 	s64 stop_latency_ns;
 	s64 start_latency_ns;
+	s64 save_state_latency_ns;
+	s64 restore_state_latency_ns;
 	s64 break_even_ns;
 };
 
Index: linux/drivers/base/power/domain_governor.c
===================================================================
--- linux.orig/drivers/base/power/domain_governor.c
+++ linux/drivers/base/power/domain_governor.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_qos.h>
+#include <linux/hrtimer.h>
 
 /**
  * default_stop_ok - Default PM domain governor routine for stopping devices.
@@ -28,6 +29,115 @@ bool default_stop_ok(struct device *dev)
 		&& td->break_even_ns < dev->power.max_time_suspended_ns;
 }
 
+/**
+ * default_power_down_ok - Default generic PM domain power off governor routine.
+ * @pd: PM domain to check.
+ *
+ * This routine must be executed under the PM domain's lock.
+ */
+static bool default_power_down_ok(struct dev_pm_domain *pd)
+{
+	struct generic_pm_domain *genpd = pd_to_genpd(pd);
+	struct gpd_link *link;
+	struct pm_domain_data *pdd;
+	s64 min_dev_off_time_ns;
+	s64 off_on_time_ns;
+	ktime_t time_now = ktime_get();
+
+	off_on_time_ns = genpd->power_off_latency_ns +
+				genpd->power_on_latency_ns;
+	/*
+	 * It doesn't make sense to remove power from the domain if saving
+	 * the state of all devices in it and the power off/power on operations
+	 * take too much time.
+	 *
+	 * All devices in this domain have been stopped already at this point.
+	 */
+	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
+		if (pdd->dev->driver)
+			off_on_time_ns +=
+				to_gpd_data(pdd)->td.save_state_latency_ns;
+	}
+
+	/*
+	 * Check if subdomains can be off for enough time.
+	 *
+	 * All subdomains have been powered off already at this point.
+	 */
+	list_for_each_entry(link, &genpd->master_links, master_node) {
+		struct generic_pm_domain *sd = link->slave;
+		s64 sd_max_off_ns = sd->max_off_time_ns;
+
+		if (sd_max_off_ns < 0)
+			continue;
+
+		sd_max_off_ns -= ktime_to_ns(ktime_sub(time_now,
+						       sd->power_off_time));
+		/*
+		 * Check if the subdomain is allowed to be off long enough for
+		 * the current domain to turn off and on (that's how much time
+		 * it will have to wait worst case).
+		 */
+		if (sd_max_off_ns <= off_on_time_ns)
+			return false;
+	}
+
+	/*
+	 * Check if the devices in the domain can be off enough time.
+	 */
+	min_dev_off_time_ns = -1;
+	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
+		struct gpd_timing_data *td;
+		struct device *dev = pdd->dev;
+		s64 dev_off_time_ns;
+
+		if (!dev->driver || dev->power.max_time_suspended_ns < 0)
+			continue;
+
+		td = &to_gpd_data(pdd)->td;
+		dev_off_time_ns = dev->power.max_time_suspended_ns -
+			(td->start_latency_ns + td->restore_state_latency_ns +
+				ktime_to_ns(ktime_sub(time_now,
+						dev->power.suspend_time)));
+		if (dev_off_time_ns <= off_on_time_ns)
+			return false;
+
+		if (min_dev_off_time_ns > dev_off_time_ns
+		    || min_dev_off_time_ns < 0)
+			min_dev_off_time_ns = dev_off_time_ns;
+	}
+
+	if (min_dev_off_time_ns < 0) {
+		/*
+		 * There are no latency constraints, so the domain can spend
+		 * arbitrary time in the "off" state.
+		 */
+		genpd->max_off_time_ns = -1;
+		return true;
+	}
+
+	/*
+	 * The difference between the computed minimum delta and the time needed
+	 * to turn the domain on is the maximum theoretical time this domain can
+	 * spend in the "off" state.
+	 */
+	min_dev_off_time_ns -= genpd->power_on_latency_ns;
+
+	/*
+	 * If the difference between the computed minimum delta and the time
+	 * needed to turn the domain off and back on on is smaller than the
+	 * domain's power break even time, removing power from the domain is not
+	 * worth it.
+	 */
+	if (genpd->break_even_ns >
+	    min_dev_off_time_ns - genpd->power_off_latency_ns)
+		return false;
+
+	genpd->max_off_time_ns = min_dev_off_time_ns;
+	return true;
+}
+
 struct dev_power_governor simple_qos_governor = {
 	.stop_ok = default_stop_ok,
+	.power_down_ok = default_power_down_ok,
 };
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -398,6 +398,17 @@ static int pm_genpd_poweroff(struct gene
 	}
 
 	genpd->status = GPD_STATE_POWER_OFF;
+	genpd->power_off_time = ktime_get();
+
+	/* Update PM QoS information for devices in the domain. */
+	list_for_each_entry_reverse(pdd, &genpd->dev_list, list_node) {
+		struct gpd_timing_data *td = &to_gpd_data(pdd)->td;
+
+		pm_runtime_update_max_time_suspended(pdd->dev,
+					td->start_latency_ns +
+					td->restore_state_latency_ns +
+					genpd->power_on_latency_ns);
+	}
 
 	list_for_each_entry(link, &genpd->slave_links, slave_node) {
 		genpd_sd_counter_dec(link->master);
@@ -1417,6 +1428,7 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->resume_count = 0;
 	genpd->device_count = 0;
 	genpd->suspended_count = 0;
+	genpd->max_off_time_ns = -1;
 	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
 	genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;
 	genpd->domain.ops.runtime_idle = pm_generic_runtime_idle;

