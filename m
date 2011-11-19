Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1KSOA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 09:00:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129Ab1KSOAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 09:00:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update 2x][PATCH 7/7] PM / Domains: Automatically update overoptimistic latency information
Date: Sat, 19 Nov 2011 15:02:51 +0100
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
Message-Id: <201111191502.51686.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Measure the time of execution of the .stop(), .start(), .save_state()
and .restore_state() PM domain device callbacks and if the result
is greater than the corresponding latency value stored in the
device's struct generic_pm_domain_data object, replace the inaccurate
value with the measured time.

Do analogously for the PM domains' .power_off() and .power_off()
callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -33,6 +33,20 @@
 	__ret;							\
 })
 
+#define GENPD_DEV_TIMED_CALLBACK(genpd, type, callback, dev, field, name)	\
+({										\
+	ktime_t __start = ktime_get();						\
+	type __retval = GENPD_DEV_CALLBACK(genpd, type, callback, dev);		\
+	s64 __elapsed = ktime_to_ns(ktime_sub(ktime_get(), __start));		\
+	struct generic_pm_domain_data *__gpd_data = dev_gpd_data(dev);		\
+	if (__elapsed > __gpd_data->td.field) {					\
+		__gpd_data->td.field = __elapsed;				\
+		dev_warn(dev, name " latency exceeded, new value %lld ns\n",	\
+			__elapsed);						\
+	}									\
+	__retval;								\
+})
+
 static LIST_HEAD(gpd_list);
 static DEFINE_MUTEX(gpd_list_lock);
 
@@ -48,22 +62,27 @@ struct generic_pm_domain *dev_to_genpd(s
 
 static int genpd_stop_dev(struct generic_pm_domain *genpd, struct device *dev)
 {
-	return GENPD_DEV_CALLBACK(genpd, int, stop, dev);
+	return GENPD_DEV_TIMED_CALLBACK(genpd, int, stop, dev,
+					stop_latency_ns, "stop");
 }
 
 static int genpd_start_dev(struct generic_pm_domain *genpd, struct device *dev)
 {
-	return GENPD_DEV_CALLBACK(genpd, int, start, dev);
+	return GENPD_DEV_TIMED_CALLBACK(genpd, int, start, dev,
+					start_latency_ns, "start");
 }
 
 static int genpd_save_dev(struct generic_pm_domain *genpd, struct device *dev)
 {
-	return GENPD_DEV_CALLBACK(genpd, int, save_state, dev);
+	return GENPD_DEV_TIMED_CALLBACK(genpd, int, save_state, dev,
+					save_state_latency_ns, "state save");
 }
 
 static int genpd_restore_dev(struct generic_pm_domain *genpd, struct device *dev)
 {
-	return GENPD_DEV_CALLBACK(genpd, int, restore_state, dev);
+	return GENPD_DEV_TIMED_CALLBACK(genpd, int, restore_state, dev,
+					restore_state_latency_ns,
+					"state restore");
 }
 
 static bool genpd_sd_counter_dec(struct generic_pm_domain *genpd)
@@ -182,9 +201,16 @@ int __pm_genpd_poweron(struct generic_pm
 	}
 
 	if (genpd->power_on) {
+		ktime_t time_start = ktime_get();
+		s64 elapsed_ns;
+
 		ret = genpd->power_on(genpd);
 		if (ret)
 			goto err;
+
+		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
+		if (elapsed_ns > genpd->power_on_latency_ns)
+			genpd->power_on_latency_ns = elapsed_ns;
 	}
 
 	genpd_set_active(genpd);
@@ -377,11 +403,16 @@ static int pm_genpd_poweroff(struct gene
 	}
 
 	if (genpd->power_off) {
+		ktime_t time_start;
+		s64 elapsed_ns;
+
 		if (atomic_read(&genpd->sd_count) > 0) {
 			ret = -EBUSY;
 			goto out;
 		}
 
+		time_start = ktime_get();
+
 		/*
 		 * If sd_count > 0 at this point, one of the subdomains hasn't
 		 * managed to call pm_genpd_poweron() for the master yet after
@@ -395,6 +426,10 @@ static int pm_genpd_poweroff(struct gene
 			genpd_set_active(genpd);
 			goto out;
 		}
+
+		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
+		if (elapsed_ns > genpd->power_off_latency_ns)
+			genpd->power_off_latency_ns = elapsed_ns;
 	}
 
 	genpd->status = GPD_STATE_POWER_OFF;

