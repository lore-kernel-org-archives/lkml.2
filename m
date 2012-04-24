Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2DXVry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:47:54 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127Ab2DXVrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:47:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/3] PM / Domains: Rework default device stop governor function
Date: Tue, 24 Apr 2012 23:50:04 +0200
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
Message-Id: <201204242350.04667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The existing default device stop governor function for PM domains,
default_stop_ok(), is supposed to check whether or not the device's
PM QoS latency constraint will be violated if the device is stopped
by pm_genpd_runtime_suspend().  However, the computations carried out
by it don't reflect the definition of the PM QoS latency constrait in
Documentation/ABI/testing/sysfs-devices-power.

Make default_stop_ok() follow the definition of the PM QoS latency
constrait.  In particular, make it take the device's start and stop
latencies correctly.

Add a new field, effective_constraint_ns, to struct gpd_timing_data
and use it to store the difference between the device's PM QoS
constraint and its resume latency for use by the device's parent
(the effective_constraint_ns values for the children are used for
computing the parent's one along with its PM QoS constraint).

Remove the break_even_ns field from struct gpd_timing_data, because
it's not used any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain_governor.c |   46 +++++++++++++++++++++++++++++++----
 include/linux/pm_domain.h            |    2 -
 2 files changed, 42 insertions(+), 6 deletions(-)

Index: linux/drivers/base/power/domain_governor.c
===================================================================
--- linux.orig/drivers/base/power/domain_governor.c
+++ linux/drivers/base/power/domain_governor.c
@@ -14,6 +14,21 @@
 
 #ifdef CONFIG_PM_RUNTIME
 
+static int dev_update_qos_constraint(struct device *dev, void *data)
+{
+	s64 *constraint_ns_p = data;
+	struct gpd_timing_data *td;
+
+	if (!(dev->power.subsys_data && dev->power.subsys_data->domain_data))
+		return 0;
+
+	td = &dev_gpd_data(dev)->td;
+	if (!*constraint_ns_p || td->effective_constraint_ns < *constraint_ns_p)
+		*constraint_ns_p = td->effective_constraint_ns;
+
+	return 0;
+}
+
 /**
  * default_stop_ok - Default PM domain governor routine for stopping devices.
  * @dev: Device to check.
@@ -21,14 +36,35 @@
 bool default_stop_ok(struct device *dev)
 {
 	struct gpd_timing_data *td = &dev_gpd_data(dev)->td;
+	s64 constraint_ns;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	if (dev->power.max_time_suspended_ns < 0 || td->break_even_ns == 0)
-		return true;
-
-	return td->stop_latency_ns + td->start_latency_ns < td->break_even_ns
-		&& td->break_even_ns < dev->power.max_time_suspended_ns;
+	td->effective_constraint_ns = -1;
+	constraint_ns = __dev_pm_qos_read_value(dev);
+	if (constraint_ns < 0)
+		return false;
+
+	constraint_ns *= NSEC_PER_USEC;
+	/*
+	 * We can walk the children without any additional locking, because
+	 * they all have been suspended at this point.
+	 */
+	if (!dev->power.ignore_children)
+		device_for_each_child(dev, &constraint_ns,
+				      dev_update_qos_constraint);
+
+	if (constraint_ns > 0) {
+		constraint_ns -= td->start_latency_ns;
+		if (constraint_ns == 0)
+			return false;
+	}
+	td->effective_constraint_ns = constraint_ns;
+	/*
+	 * The children have been suspended already, so we don't need to take
+	 * their stop latencies into account here.
+	 */
+	return constraint_ns > td->stop_latency_ns;
 }
 
 /**
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -93,7 +93,7 @@ struct gpd_timing_data {
 	s64 start_latency_ns;
 	s64 save_state_latency_ns;
 	s64 restore_state_latency_ns;
-	s64 break_even_ns;
+	s64 effective_constraint_ns;
 };
 
 struct generic_pm_domain_data {

