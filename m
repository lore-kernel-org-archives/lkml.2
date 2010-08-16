Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0HPUce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:32:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab0HPUcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:32:33 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] acpi: Update battery information on notification 0x81
Date: Mon, 16 Aug 2010 16:32:19 -0400
Message-Id: <1281990739-17912-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.57.107
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A notification event 0x81 from an ACPI battery device requires us to
re-read the battery information structure. Do so, and if the battery's
reporting units have changed (as is the case on some Thinkpads) destroy
and recreate the battery in order to populate the fields correctly.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/battery.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index dc58402..69638c4 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -562,9 +562,10 @@ static void acpi_battery_quirks(struct acpi_battery *battery)
 	}
 }
 
-static int acpi_battery_update(struct acpi_battery *battery)
+static int acpi_battery_update(struct acpi_battery *battery, bool get_info)
 {
 	int result, old_present = acpi_battery_present(battery);
+	int old_power_unit = battery->power_unit;
 	result = acpi_battery_get_status(battery);
 	if (result)
 		return result;
@@ -587,6 +588,16 @@ static int acpi_battery_update(struct acpi_battery *battery)
 	if (!battery->bat.dev)
 		sysfs_add_battery(battery);
 #endif
+	if (get_info) {
+		acpi_battery_get_info(battery);
+#ifdef CONFIG_ACPI_SYSFS_POWER
+		if (old_power_unit != battery->power_unit) {
+			/* The battery has changed its reporting units */
+			sysfs_remove_battery(battery);
+			sysfs_add_battery(battery);
+		}
+#endif
+	}
 	return acpi_battery_get_state(battery);
 }
 
@@ -762,7 +773,7 @@ static print_func acpi_print_funcs[ACPI_BATTERY_NUMFILES] = {
 static int acpi_battery_read(int fid, struct seq_file *seq)
 {
 	struct acpi_battery *battery = seq->private;
-	int result = acpi_battery_update(battery);
+	int result = acpi_battery_update(battery, false);
 	return acpi_print_funcs[fid](seq, result);
 }
 
@@ -877,7 +888,8 @@ static void acpi_battery_notify(struct acpi_device *device, u32 event)
 #ifdef CONFIG_ACPI_SYSFS_POWER
 	old = battery->bat.dev;
 #endif
-	acpi_battery_update(battery);
+	acpi_battery_update(battery, (event == ACPI_BATTERY_NOTIFY_INFO ? true
+				      : false));
 	acpi_bus_generate_proc_event(device, event,
 				     acpi_battery_present(battery));
 	acpi_bus_generate_netlink_event(device->pnp.device_class,
@@ -908,7 +920,7 @@ static int acpi_battery_add(struct acpi_device *device)
 	if (ACPI_SUCCESS(acpi_get_handle(battery->device->handle,
 			"_BIX", &handle)))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
-	acpi_battery_update(battery);
+	acpi_battery_update(battery, false);
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	result = acpi_battery_add_fs(device);
 #endif
@@ -951,7 +963,7 @@ static int acpi_battery_resume(struct acpi_device *device)
 		return -EINVAL;
 	battery = acpi_driver_data(device);
 	battery->update_time = 0;
-	acpi_battery_update(battery);
+	acpi_battery_update(battery, true);
 	return 0;
 }
 
-- 
1.7.2.1

