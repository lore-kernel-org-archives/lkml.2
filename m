Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab1D2TEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:04:46 -0400
Received: from kroah.org ([198.145.64.141]:50314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177Ab1D2S6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:55 2011
Message-Id: <20110429185655.464042537@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kyle McMartin <kyle@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>
Subject: [30/55] ACPI battery: fribble sysfs files from a resume notifier
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kyle McMartin <kyle@redhat.com>

commit 25be5821521640eb00b7eb219ffe59664510d073 upstream.

Commit da8aeb92 re-poked the battery on resume, but Linus reports that
it broke his eee and partially reverted it in b23fffd7. Unfortunately
this also results in my x201s giving crack values until the sysfs files
are poked again. In the revert message, it was suggested that we poke it
from a PM notifier, so let's do that.

With this in place, I haven't noticed the units going nutty on my
gnome-power-manager across a dozen suspends or so...

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/battery.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -33,6 +33,7 @@
 #include <linux/async.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
 #include <linux/proc_fs.h>
@@ -102,6 +103,7 @@ struct acpi_battery {
 	struct mutex lock;
 	struct power_supply bat;
 	struct acpi_device *device;
+	struct notifier_block pm_nb;
 	unsigned long update_time;
 	int rate_now;
 	int capacity_now;
@@ -940,6 +942,21 @@ static void acpi_battery_notify(struct a
 		power_supply_changed(&battery->bat);
 }
 
+static int battery_notify(struct notifier_block *nb,
+			       unsigned long mode, void *_unused)
+{
+	struct acpi_battery *battery = container_of(nb, struct acpi_battery,
+						    pm_nb);
+	switch (mode) {
+	case PM_POST_SUSPEND:
+		sysfs_remove_battery(battery);
+		sysfs_add_battery(battery);
+		break;
+	}
+
+	return 0;
+}
+
 static int acpi_battery_add(struct acpi_device *device)
 {
 	int result = 0;
@@ -972,6 +989,10 @@ static int acpi_battery_add(struct acpi_
 #endif
 		kfree(battery);
 	}
+
+	battery->pm_nb.notifier_call = battery_notify;
+	register_pm_notifier(&battery->pm_nb);
+
 	return result;
 }
 
@@ -982,6 +1003,7 @@ static int acpi_battery_remove(struct ac
 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
 	battery = acpi_driver_data(device);
+	unregister_pm_notifier(&battery->pm_nb);
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	acpi_battery_remove_fs(device);
 #endif


