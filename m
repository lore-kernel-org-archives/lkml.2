Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab0LLX74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:59:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36542 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab0LLXru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:50 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: rui.zhang@intel.com, sitsofe@yahoo.com, len.brown@intel.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [165/223] ACPI battery: support percentage battery remaining capacity
Message-Id: <20101212234749.58872B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Zhang Rui <rui.zhang@intel.com>

commit 557d58687dcdee6bc00c1a8f1fd4e0eac8fefce9 upstream.

According to the ACPI spec, some kinds of primary battery can
report percentage battery remaining capacity directly to OS.

In this case, it reports the LastFullChargedCapacity == 100,
BatteryPresentRate = 0xFFFFFFFF, and BatteryRemaingCapacity a
percentage value, which actually means RemainingBatteryPercentage.

Now we found some battery follows this rule even if it's a rechargeable.
https://bugzilla.kernel.org/show_bug.cgi?id=15979

Handle these batteries correctly in ACPI battery driver
so that they won't break userspace.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/acpi/battery.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

Index: linux/drivers/acpi/battery.c
===================================================================
--- linux.orig/drivers/acpi/battery.c
+++ linux/drivers/acpi/battery.c
@@ -98,6 +98,7 @@ enum {
 	 * due to bad math.
 	 */
 	ACPI_BATTERY_QUIRK_SIGNED16_CURRENT,
+	ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY,
 };
 
 struct acpi_battery {
@@ -413,6 +414,8 @@ static int acpi_battery_get_info(struct
 		result = extract_package(battery, buffer.pointer,
 				info_offsets, ARRAY_SIZE(info_offsets));
 	kfree(buffer.pointer);
+	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags))
+		battery->full_charge_capacity = battery->design_capacity;
 	return result;
 }
 
@@ -449,6 +452,10 @@ static int acpi_battery_get_state(struct
 	    battery->rate_now != -1)
 		battery->rate_now = abs((s16)battery->rate_now);
 
+	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags)
+	    && battery->capacity_now >= 0 && battery->capacity_now <= 100)
+		battery->capacity_now = (battery->capacity_now *
+				battery->full_charge_capacity) / 100;
 	return result;
 }
 
@@ -562,6 +569,33 @@ static void acpi_battery_quirks(struct a
 	}
 }
 
+/*
+ * According to the ACPI spec, some kinds of primary batteries can
+ * report percentage battery remaining capacity directly to OS.
+ * In this case, it reports the Last Full Charged Capacity == 100
+ * and BatteryPresentRate == 0xFFFFFFFF.
+ *
+ * Now we found some battery reports percentage remaining capacity
+ * even if it's rechargeable.
+ * https://bugzilla.kernel.org/show_bug.cgi?id=15979
+ *
+ * Handle this correctly so that they won't break userspace.
+ */
+static void acpi_battery_quirks2(struct acpi_battery *battery)
+{
+	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags))
+		return ;
+
+        if (battery->full_charge_capacity == 100 &&
+            battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN &&
+            battery->capacity_now >=0 && battery->capacity_now <= 100) {
+		set_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags);
+		battery->full_charge_capacity = battery->design_capacity;
+		battery->capacity_now = (battery->capacity_now *
+				battery->full_charge_capacity) / 100;
+	}
+}
+
 static int acpi_battery_update(struct acpi_battery *battery)
 {
 	int result, old_present = acpi_battery_present(battery);
@@ -587,7 +621,9 @@ static int acpi_battery_update(struct ac
 	if (!battery->bat.dev)
 		sysfs_add_battery(battery);
 #endif
-	return acpi_battery_get_state(battery);
+	result = acpi_battery_get_state(battery);
+	acpi_battery_quirks2(battery);
+	return result;
 }
 
 /* --------------------------------------------------------------------------
