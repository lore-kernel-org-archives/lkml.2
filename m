Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1KGAIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 19:08:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53740 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab1KGAIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 19:08:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 6/7] PM / Domains: Add default power off governor function (v3)
Date: Mon, 7 Nov 2011 01:09:29 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
References: <201111070101.33960.rjw@sisk.pl>
In-Reply-To: <201111070101.33960.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111070109.29640.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a function deciding whether or not a given PM domain should
be powered off on the basis of the PM QoS constraints of devices
belonging to it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c          |    2 
 drivers/base/power/domain_governor.c |  125 +++++++++++++++++++++++++++++++++++
 include/linux/pm_domain.h            |    9 ++
 3 files changed, 136 insertions(+)

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
@@ -74,6 +79,9 @@ struct gpd_link {
 };
 
 struct gpd_timing_data {
+	s64 start_latency_ns;
+	s64 save_state_latency_ns;
+	s64 restore_state_latency_ns;
 	s64 break_even_ns;
 };
 
@@ -81,6 +89,7 @@ struct generic_pm_domain_data {
 	struct pm_domain_data base;
 	struct gpd_dev_ops ops;
 	struct gpd_timing_data td;
+	ktime_t stop_time;
 	bool need_restore;
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
@@ -34,6 +35,130 @@ bool default_stop_ok(struct device *dev)
 	return constraint_ns > dev_gpd_data(dev)->td.break_even_ns;
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
+	s64 delta_ns, min_delta_ns;
+	s64 max_save_time_ns;
+	ktime_t time_now = ktime_get();
+
+	/*
+	 * Check if subdomains can be off for enough time.
+	 *
+	 * All subdomains have been powered off already at this point.
+	 */
+	delta_ns = genpd->power_off_latency_ns + genpd->power_on_latency_ns;
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
+		if (sd_max_off_ns <= delta_ns)
+			return false;
+	}
+
+	/*
+	 * If the "domain power off" operation is aborted, it may be necessary
+	 * to wait for the slowest "save device state operation to complete.
+	 *
+	 * All devices in this domain have been stopped already at this point.
+	 */
+	max_save_time_ns = 0;
+	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
+		s64 save_time_ns;
+
+		if (!pdd->dev->driver)
+			continue;
+
+		save_time_ns = to_gpd_data(pdd)->td.save_state_latency_ns;
+		if (save_time_ns > max_save_time_ns)
+			max_save_time_ns = save_time_ns;
+	}
+
+	/*
+	 * For each device in the domain compute the difference between the
+	 * QoS latency constraint and the time already spent in the "stopped"
+	 * state plus the total time required to bring the device back to the
+	 * full power state (after the domain has been turned on).  Compute the
+	 * minimum of these values.
+	 */
+	min_delta_ns = -1;
+	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
+		struct generic_pm_domain_data *gpd_data;
+		struct device *dev = pdd->dev;
+		s32 constraint;
+
+		if (!dev->driver)
+			continue;
+
+		constraint = dev_pm_qos_read_value(dev);
+		if (constraint < 0) /* negative means "never stop" */
+			return false;
+		else if (constraint == 0) /* 0 means "don't care" */
+			continue;
+
+		delta_ns = constraint;
+		delta_ns *= NSEC_PER_USEC;
+
+		gpd_data = to_gpd_data(pdd);
+		delta_ns -= gpd_data->td.start_latency_ns +
+			ktime_to_ns(ktime_sub(time_now, gpd_data->stop_time));
+		if (delta_ns <= max_save_time_ns)
+			return false;
+
+		delta_ns -= gpd_data->td.restore_state_latency_ns;
+		if (delta_ns <= 0)
+			return false;
+
+		if (delta_ns < min_delta_ns)
+			min_delta_ns = delta_ns;
+	}
+
+	if (min_delta_ns < 0) {
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
+	min_delta_ns -= genpd->power_on_latency_ns;
+	genpd->max_off_time_ns = min_delta_ns;
+
+	/*
+	 * If the difference between the computed minimum delta and the time
+	 * needed to turn the domain off and back on on is smaller than the
+	 * domain's power break even time, removing power from the domain is not
+	 * worth it.
+	 */
+	min_delta_ns -= genpd->power_off_latency_ns;
+	return min_delta_ns > genpd->break_even_ns;
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
@@ -47,6 +47,7 @@ struct generic_pm_domain *dev_to_genpd(s
 
 static int genpd_stop_dev(struct generic_pm_domain *genpd, struct device *dev)
 {
+	dev_gpd_data(dev)->stop_time = ktime_get();
 	return GENPD_DEV_CALLBACK(genpd, int, stop, dev);
 }
 
@@ -397,6 +398,7 @@ static int pm_genpd_poweroff(struct gene
 	}
 
 	genpd->status = GPD_STATE_POWER_OFF;
+	genpd->power_off_time = ktime_get();
 
 	list_for_each_entry(link, &genpd->slave_links, slave_node) {
 		genpd_sd_counter_dec(link->master);

