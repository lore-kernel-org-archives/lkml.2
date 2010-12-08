Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab0LHBDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:19 -0500
Received: from kroah.org ([198.145.64.141]:33643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab0LHBDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:15 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:43 2010
Message-Id: <20101208005743.453830621@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [220/289] ACPI battery: support percentage battery remaining capacity
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/acpi/battery.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -98,6 +98,7 @@ enum {
 	 * due to bad math.
 	 */
 	ACPI_BATTERY_QUIRK_SIGNED16_CURRENT,
+	ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY,
 };
 
 struct acpi_battery {
@@ -412,6 +413,8 @@ static int acpi_battery_get_info(struct
 		result = extract_package(battery, buffer.pointer,
 				info_offsets, ARRAY_SIZE(info_offsets));
 	kfree(buffer.pointer);
+	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags))
+		battery->full_charge_capacity = battery->design_capacity;
 	return result;
 }
 
@@ -448,6 +451,10 @@ static int acpi_battery_get_state(struct
 	    battery->rate_now != -1)
 		battery->rate_now = abs((s16)battery->rate_now);
 
+	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags)
+	    && battery->capacity_now >= 0 && battery->capacity_now <= 100)
+		battery->capacity_now = (battery->capacity_now *
+				battery->full_charge_capacity) / 100;
 	return result;
 }
 
@@ -561,6 +568,33 @@ static void acpi_battery_quirks(struct a
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
@@ -586,7 +620,9 @@ static int acpi_battery_update(struct ac
 	if (!battery->bat.dev)
 		sysfs_add_battery(battery);
 #endif
-	return acpi_battery_get_state(battery);
+	result = acpi_battery_get_state(battery);
+	acpi_battery_quirks2(battery);
+	return result;
 }
 
 /* --------------------------------------------------------------------------


