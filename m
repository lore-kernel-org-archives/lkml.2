Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1EaJKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:10:42 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:35253 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1EaJKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:10:40 -0400
Date: Tue, 31 May 2011 11:09:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Len Brown <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rene Herman <rene.herman@gmail.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 2/3] thermal: Split hwmon lookup to a separate function
Message-ID: <20110531110913.2fac7094@endymion.delvare>
In-Reply-To: <20110531110016.7b232c85@endymion.delvare>
References: <20110531110016.7b232c85@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll soon need to reuse it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/thermal/thermal_sys.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- linux-2.6.39-rc4.orig/drivers/thermal/thermal_sys.c	2011-04-25 14:40:17.000000000 +0200
+++ linux-2.6.39-rc4/drivers/thermal/thermal_sys.c	2011-04-25 14:44:52.000000000 +0200
@@ -469,22 +469,35 @@ temp_crit_show(struct device *dev, struc
 }
 
 
-static int
-thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
+static struct thermal_hwmon_device *
+thermal_hwmon_lookup_by_type(const struct thermal_zone_device *tz)
 {
 	struct thermal_hwmon_device *hwmon;
-	int new_hwmon_device = 1;
-	int result;
 
 	mutex_lock(&thermal_list_lock);
 	list_for_each_entry(hwmon, &thermal_hwmon_list, node)
 		if (!strcmp(hwmon->type, tz->type)) {
-			new_hwmon_device = 0;
 			mutex_unlock(&thermal_list_lock);
-			goto register_sys_interface;
+			return hwmon;
 		}
 	mutex_unlock(&thermal_list_lock);
 
+	return NULL;
+}
+
+static int
+thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
+{
+	struct thermal_hwmon_device *hwmon;
+	int new_hwmon_device = 1;
+	int result;
+
+	hwmon = thermal_hwmon_lookup_by_type(tz);
+	if (hwmon) {
+		new_hwmon_device = 0;
+		goto register_sys_interface;
+	}
+
 	hwmon = kzalloc(sizeof(struct thermal_hwmon_device), GFP_KERNEL);
 	if (!hwmon)
 		return -ENOMEM;

-- 
Jean Delvare
