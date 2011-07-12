Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1GLRXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:23:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35485 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab1GLRXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:23:37 -0400
Date: Tue, 12 Jul 2011 21:23:31 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Len Brown <lenb@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] power_supply: scrub device pointer if registration
 fails
Message-ID: <20110712172331.GA9557@oksana.dev.rtsoft.ru>
References: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <1310457809-2731-2-git-send-email-stefanha@linux.vnet.ibm.com>
 <20110712150942.GA1291@oksana.dev.rtsoft.ru>
 <20110712153017.GA4503@stefanha-thinkpad.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110712153017.GA4503@stefanha-thinkpad.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 04:30:17PM +0100, Stefan Hajnoczi wrote:
[...]
> > I believe the whole ACPI battery logic is overcomplicated, and
> > needs a bit of rework. In the meantime, we could move 'psy->dev =
> > dev;' assignment into the end of the function, where _register
> > could not fail, i.e. something like this:
> 
> Aha!  I didn't do this is because I don't know the code and was afraid
> some other function somewhere would use psy->dev.  If you think it is
> safer this way I'll resend the patch.

Neither is a proper fix, unfortunately. :-( Without some external lock
you can't use psy->dev as a flag to check if the registration was
successful. There is really no point trying to force core functions
to keep psy->dev in a sane state after registration has failed.

So, instead of patching power_supply core, I'd suggest the
following patch (on top of 2/3 and 3/3, so far only compile-
tested). How does it look?

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 2ae2fca..475e17c 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -101,6 +101,7 @@ enum {
 
 struct acpi_battery {
 	struct mutex lock;
+	struct mutex bat_lock;
 	struct power_supply bat;
 	struct acpi_device *device;
 	struct notifier_block pm_nb;
@@ -559,8 +560,10 @@ static int sysfs_add_battery(struct acpi_battery *battery)
 	battery->bat.get_property = acpi_battery_get_property;
 
 	result = power_supply_register(&battery->device->dev, &battery->bat);
-	if (result)
+	if (result) {
+		battery->bat.dev = NULL;
 		return result;
+	}
 	return device_create_file(battery->bat.dev, &alarm_attr);
 }
 
@@ -613,31 +616,40 @@ static int acpi_battery_update(struct acpi_battery *battery)
 	result = acpi_battery_get_status(battery);
 	if (result)
 		return result;
+
+	mutex_lock(&battery->bat_lock);
+
 	if (!acpi_battery_present(battery)) {
 		sysfs_remove_battery(battery);
 		battery->update_time = 0;
-		return 0;
+		result = 0;
+		goto out_unlock;
 	}
 	if (!battery->update_time ||
 	    old_present != acpi_battery_present(battery)) {
 		result = acpi_battery_get_info(battery);
 		if (result)
-			return result;
+			goto out_unlock;
 		acpi_battery_quirks(battery);
 		acpi_battery_init_alarm(battery);
 	}
 	if (!battery->bat.dev) {
 		result = sysfs_add_battery(battery);
 		if (result)
-			return result;
+			goto out_unlock;
 	}
 	result = acpi_battery_get_state(battery);
 	acpi_battery_quirks2(battery);
+
+out_unlock:
+	mutex_unlock(&battery->bat_lock);
 	return result;
 }
 
-static void acpi_battery_refresh(struct acpi_battery *battery)
+static void sysfs_readd_battery(struct acpi_battery *battery)
 {
+	mutex_lock(&battery->bat_lock);
+
 	if (!battery->bat.dev)
 		return;
 
@@ -645,6 +657,13 @@ static void acpi_battery_refresh(struct acpi_battery *battery)
 	/* The battery may have changed its reporting units. */
 	sysfs_remove_battery(battery);
 	sysfs_add_battery(battery);
+
+	mutex_unlock(&battery->bat_lock);
+}
+
+static void acpi_battery_refresh(struct acpi_battery *battery)
+{
+	sysfs_readd_battery(battery);
 }
 
 /* --------------------------------------------------------------------------
@@ -941,8 +960,10 @@ static void acpi_battery_notify(struct acpi_device *device, u32 event)
 					dev_name(&device->dev), event,
 					acpi_battery_present(battery));
 	/* acpi_battery_update could remove power_supply object */
+	mutex_lock(&battery->bat_lock);
 	if (old && battery->bat.dev)
 		power_supply_changed(&battery->bat);
+	mutex_unlock(&battery->bat_lock);
 }
 
 static int battery_notify(struct notifier_block *nb,
@@ -952,8 +973,7 @@ static int battery_notify(struct notifier_block *nb,
 						    pm_nb);
 	switch (mode) {
 	case PM_POST_SUSPEND:
-		sysfs_remove_battery(battery);
-		sysfs_add_battery(battery);
+		sysfs_readd_battery(battery);
 		break;
 	}
 
@@ -975,6 +995,7 @@ static int acpi_battery_add(struct acpi_device *device)
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
 	device->driver_data = battery;
 	mutex_init(&battery->lock);
+	mutex_init(&battery->bat_lock);
 	if (ACPI_SUCCESS(acpi_get_handle(battery->device->handle,
 			"_BIX", &handle)))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
@@ -1019,6 +1040,7 @@ static int acpi_battery_remove(struct acpi_device *device, int type)
 	acpi_battery_remove_fs(device);
 #endif
 	sysfs_remove_battery(battery);
+	mutex_destroy(&battery->bat_lock);
 	mutex_destroy(&battery->lock);
 	kfree(battery);
 	return 0;
