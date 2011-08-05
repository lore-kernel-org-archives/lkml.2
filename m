Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1HEQkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:40:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48513 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1HEQkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:40:49 -0400
Date: Fri, 5 Aug 2011 19:39:44 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "lan,Tianyu" <tianyu.lan@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Battery: sysfs_remove_battery(): possible circular
 locking
Message-ID: <20110805163944.GA3132@swordfish.minsk.epam.com>
References: <20110805003322.GA8311@swordfish>
 <1312521008.2096.173.camel@lantianyu-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312521008.2096.173.camel@lantianyu-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/05/11 13:10), lan,Tianyu wrote:
> I think changing  'the marker' to 'battery->bat.name' will introduce
> problem.
> In the sysfs_add_battery(), when the 'battery->bat.name' is assigned,
> the power_supply_register() and device_create_file() have not been
> invoked. In this time, maybe sysfs_remove_battery() will be invoked and
> cause device_remove_file() and power_supply_unregister() invoked without
> device file created and power supply registered.
> 
> sysfs_remove_battery()  will be invoked in the battery_notify(),
> acpi_battery_refresh() and sysfs_remove_battery() which causes the
> situation. This is also the cause  of bug 35642.
> 

Well, how about using separate (independent lock) for sysfs_remove_battery()
case? Since we can't safely drop battery->lock in sysfs_remove_battery() before 
power_supply_unregister() call.

Not sure if it should be within struct acpi_battery, perhaps we could
have it as a 'global' battery lock. Anyway, here it is:

---

 drivers/acpi/battery.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 87c0a8d..7711d94 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -99,6 +99,7 @@ enum {
 
 struct acpi_battery {
 	struct mutex lock;
+	struct mutex sysfs_lock;
 	struct power_supply bat;
 	struct acpi_device *device;
 	struct notifier_block pm_nb;
@@ -573,16 +574,16 @@ static int sysfs_add_battery(struct acpi_battery *battery)
 
 static void sysfs_remove_battery(struct acpi_battery *battery)
 {
-	mutex_lock(&battery->lock);
+	mutex_lock(&battery->sysfs_lock);
 	if (!battery->bat.dev) {
-		mutex_unlock(&battery->lock);
+		mutex_unlock(&battery->sysfs_lock);
 		return;
 	}
 
 	device_remove_file(battery->bat.dev, &alarm_attr);
 	power_supply_unregister(&battery->bat);
 	battery->bat.dev = NULL;
-	mutex_unlock(&battery->lock);
+	mutex_unlock(&battery->sysfs_lock);
 }
 
 /*
@@ -982,6 +983,7 @@ static int acpi_battery_add(struct acpi_device *device)
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
 	device->driver_data = battery;
 	mutex_init(&battery->lock);
+	mutex_init(&battery->sysfs_lock);
 	if (ACPI_SUCCESS(acpi_get_handle(battery->device->handle,
 			"_BIX", &handle)))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
@@ -1010,6 +1012,7 @@ static int acpi_battery_add(struct acpi_device *device)
 fail:
 	sysfs_remove_battery(battery);
 	mutex_destroy(&battery->lock);
+	mutex_destroy(&battery->sysfs_lock);
 	kfree(battery);
 	return result;
 }
@@ -1027,6 +1030,7 @@ static int acpi_battery_remove(struct acpi_device *device, int type)
 #endif
 	sysfs_remove_battery(battery);
 	mutex_destroy(&battery->lock);
+	mutex_destroy(&battery->sysfs_lock);
 	kfree(battery);
 	return 0;
 }

