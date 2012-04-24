Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab2DXVr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:47:56 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35014 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289Ab2DXVrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:47:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/3] PM / Domains: Rework default device stop governor function
Date: Tue, 24 Apr 2012 23:50:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
References: <201204242349.26288.rjw@sisk.pl>
In-Reply-To: <201204242349.26288.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204242350.41844.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The existing default domain power down governor function for PM
domains, default_power_down_ok(), is supposed to check whether or not
the PM QoS latency constraints of the devices in the domain will be
violated if the domain is turned off by pm_genpd_poweroff().
However, the computations carried out by it don't reflect the
definition of the PM QoS latency constrait in
Documentation/ABI/testing/sysfs-devices-power.

Make default_power_down_ok() follow the definition of the PM QoS
latency constrait.  In particular, make it only take latencies into
account, because it doesn't matter how much time has elapsed since
the domain's devices were suspended for the computation.

Remove the break_even_ns and power_off_time fields from
struct generic_pm_domain, because they are not necessary any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c          |    1 
 drivers/base/power/domain_governor.c |   62 ++++++++++++++---------------------
 include/linux/pm_domain.h            |    2 -
 3 files changed, 25 insertions(+), 40 deletions(-)

Index: linux/drivers/base/power/domain_governor.c
===================================================================
--- linux.orig/drivers/base/power/domain_governor.c
+++ linux/drivers/base/power/domain_governor.c
@@ -80,8 +80,8 @@ static bool default_power_down_ok(struct
 	struct pm_domain_data *pdd;
 	s64 min_dev_off_time_ns;
 	s64 off_on_time_ns;
-	ktime_t time_now = ktime_get();
 
+	genpd->max_off_time_ns = -1;
 	off_on_time_ns = genpd->power_off_latency_ns +
 				genpd->power_on_latency_ns;
 	/*
@@ -109,8 +109,6 @@ static bool default_power_down_ok(struct
 		if (sd_max_off_ns < 0)
 			continue;
 
-		sd_max_off_ns -= ktime_to_ns(ktime_sub(time_now,
-						       sd->power_off_time));
 		/*
 		 * Check if the subdomain is allowed to be off long enough for
 		 * the current domain to turn off and on (that's how much time
@@ -125,53 +123,43 @@ static bool default_power_down_ok(struct
 	 */
 	min_dev_off_time_ns = -1;
 	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
-		struct gpd_timing_data *td;
-		struct device *dev = pdd->dev;
-		s64 dev_off_time_ns;
+		s64 constraint_ns;
 
-		if (!dev->driver || dev->power.max_time_suspended_ns < 0)
+		if (!pdd->dev->driver)
 			continue;
 
-		td = &to_gpd_data(pdd)->td;
-		dev_off_time_ns = dev->power.max_time_suspended_ns -
-			(td->start_latency_ns + td->restore_state_latency_ns +
-				ktime_to_ns(ktime_sub(time_now,
-						dev->power.suspend_time)));
-		if (dev_off_time_ns <= off_on_time_ns)
+		/*
+		 * Check if the device is allowed to be off long enough for the
+		 * domain to turn off and on (that's how much time it will
+		 * have to wait worst case).
+		 */
+		constraint_ns = to_gpd_data(pdd)->td.effective_constraint_ns;
+		if (constraint_ns == 0)
+			continue;
+
+		if (constraint_ns <= off_on_time_ns)
 			return false;
 
-		if (min_dev_off_time_ns > dev_off_time_ns
+		if (min_dev_off_time_ns > constraint_ns
 		    || min_dev_off_time_ns < 0)
-			min_dev_off_time_ns = dev_off_time_ns;
-	}
-
-	if (min_dev_off_time_ns < 0) {
-		/*
-		 * There are no latency constraints, so the domain can spend
-		 * arbitrary time in the "off" state.
-		 */
-		genpd->max_off_time_ns = -1;
-		return true;
+			min_dev_off_time_ns = constraint_ns;
 	}
 
 	/*
-	 * The difference between the computed minimum delta and the time needed
-	 * to turn the domain on is the maximum theoretical time this domain can
-	 * spend in the "off" state.
+	 * If the computed minimum device off time is negative, there are no
+	 * latency constraints, so the domain can spend arbitrary time in the
+	 * "off" state.
 	 */
-	min_dev_off_time_ns -= genpd->power_on_latency_ns;
+	if (min_dev_off_time_ns < 0)
+		return true;
 
 	/*
-	 * If the difference between the computed minimum delta and the time
-	 * needed to turn the domain off and back on on is smaller than the
-	 * domain's power break even time, removing power from the domain is not
-	 * worth it.
+	 * The difference between the computed minimum device off time and the
+	 * time needed to turn the domain on is the maximum theoretical time
+	 * this domain can spend in the "off" state.
 	 */
-	if (genpd->break_even_ns >
-	    min_dev_off_time_ns - genpd->power_off_latency_ns)
-		return false;
-
-	genpd->max_off_time_ns = min_dev_off_time_ns;
+	genpd->max_off_time_ns = min_dev_off_time_ns -
+					genpd->power_on_latency_ns;
 	return true;
 }
 
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -70,9 +70,7 @@ struct generic_pm_domain {
 	int (*power_on)(struct generic_pm_domain *domain);
 	s64 power_on_latency_ns;
 	struct gpd_dev_ops dev_ops;
-	s64 break_even_ns;	/* Power break even for the entire domain. */
 	s64 max_off_time_ns;	/* Maximum allowed "suspended" time. */
-	ktime_t power_off_time;
 	struct device_node *of_node; /* Node in device tree */
 };
 
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -443,7 +443,6 @@ static int pm_genpd_poweroff(struct gene
 	}
 
 	genpd->status = GPD_STATE_POWER_OFF;
-	genpd->power_off_time = ktime_get();
 
 	/* Update PM QoS information for devices in the domain. */
 	list_for_each_entry_reverse(pdd, &genpd->dev_list, list_node) {

