Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2EEUgi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 16:36:38 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55404 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab2EEUgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 16:36:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Domains: Fix computation of maximum domain off time
Date: Sat, 5 May 2012 22:41:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205052241.25311.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The default domain power off governor function for generic PM
domains, default_power_down_ok(), may violate subdomain maximum
off time limit by allowing the master domain to be off for too
long.  Namely, it only finds the minium of all device maximum
off times over the domain's devices and uses that to compute the
domain's maximum off time, but it should do the same for the
subdomains.

Fix this problem by modifying default_power_down_ok() to compute
the given domain's maximum off time as the difference between the
minimum off time over all devices and subdomains in the domain and
its power on latency.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

This patch is on top of the pm-domains branch of the linux-pm tree.

Thanks,
Rafael

---
 drivers/base/power/domain_governor.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

Index: linux/drivers/base/power/domain_governor.c
===================================================================
--- linux.orig/drivers/base/power/domain_governor.c
+++ linux/drivers/base/power/domain_governor.c
@@ -105,7 +105,7 @@ static bool default_power_down_ok(struct
 	struct generic_pm_domain *genpd = pd_to_genpd(pd);
 	struct gpd_link *link;
 	struct pm_domain_data *pdd;
-	s64 min_dev_off_time_ns;
+	s64 min_off_time_ns;
 	s64 off_on_time_ns;
 
 	if (genpd->max_off_time_changed) {
@@ -142,6 +142,7 @@ static bool default_power_down_ok(struct
 				to_gpd_data(pdd)->td.save_state_latency_ns;
 	}
 
+	min_off_time_ns = -1;
 	/*
 	 * Check if subdomains can be off for enough time.
 	 *
@@ -161,12 +162,14 @@ static bool default_power_down_ok(struct
 		 */
 		if (sd_max_off_ns <= off_on_time_ns)
 			return false;
+
+		if (min_off_time_ns > sd_max_off_ns || min_off_time_ns < 0)
+			min_off_time_ns = sd_max_off_ns;
 	}
 
 	/*
 	 * Check if the devices in the domain can be off enough time.
 	 */
-	min_dev_off_time_ns = -1;
 	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
 		struct gpd_timing_data *td;
 		s64 constraint_ns;
@@ -197,9 +200,8 @@ static bool default_power_down_ok(struct
 		if (constraint_ns <= off_on_time_ns)
 			return false;
 
-		if (min_dev_off_time_ns > constraint_ns
-		    || min_dev_off_time_ns < 0)
-			min_dev_off_time_ns = constraint_ns;
+		if (min_off_time_ns > constraint_ns || min_off_time_ns < 0)
+			min_off_time_ns = constraint_ns;
 	}
 
 	genpd->cached_power_down_ok = true;
@@ -209,16 +211,15 @@ static bool default_power_down_ok(struct
 	 * latency constraints, so the domain can spend arbitrary time in the
 	 * "off" state.
 	 */
-	if (min_dev_off_time_ns < 0)
+	if (min_off_time_ns < 0)
 		return true;
 
 	/*
-	 * The difference between the computed minimum device off time and the
-	 * time needed to turn the domain on is the maximum theoretical time
-	 * this domain can spend in the "off" state.
+	 * The difference between the computed minimum subdomain or device off
+	 * time and the time needed to turn the domain on is the maximum
+	 * theoretical time this domain can spend in the "off" state.
 	 */
-	genpd->max_off_time_ns = min_dev_off_time_ns -
-					genpd->power_on_latency_ns;
+	genpd->max_off_time_ns = min_off_time_ns - genpd->power_on_latency_ns;
 	return true;
 }
 
