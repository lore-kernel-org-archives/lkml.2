Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0KXXSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:18:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52764 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab0KXXRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:17:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 11/13] ACPI / Fan: Rework the handling of power resources
Date: Thu, 25 Nov 2010 00:11:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201011250001.11297.rjw@sisk.pl>
In-Reply-To: <201011250001.11297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011250011.24389.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use the new function acpi_bus_update_power() for manipulating power
resources used by ACPI fan devices, which allows them to be put into
the right state during initialization and resume.  Consequently,
remove the flags.force_power_state field from struct acpi_device,
which is not necessary any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/bus.c      |    2 +-
 drivers/acpi/fan.c      |   27 +++++++--------------------
 drivers/acpi/thermal.c  |    5 +++--
 include/acpi/acpi_bus.h |    3 +--
 4 files changed, 12 insertions(+), 25 deletions(-)

Index: linux-2.6/drivers/acpi/fan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/fan.c
+++ linux-2.6/drivers/acpi/fan.c
@@ -86,7 +86,7 @@ static int fan_get_cur_state(struct ther
 	if (!device)
 		return -EINVAL;
 
-	result = acpi_bus_get_power(device->handle, &acpi_state);
+	result = acpi_bus_update_power(device->handle, &acpi_state);
 	if (result)
 		return result;
 
@@ -123,7 +123,6 @@ static struct thermal_cooling_device_ops
 static int acpi_fan_add(struct acpi_device *device)
 {
 	int result = 0;
-	int state = 0;
 	struct thermal_cooling_device *cdev;
 
 	if (!device)
@@ -132,16 +131,12 @@ static int acpi_fan_add(struct acpi_devi
 	strcpy(acpi_device_name(device), "Fan");
 	strcpy(acpi_device_class(device), ACPI_FAN_CLASS);
 
-	result = acpi_bus_get_power(device->handle, &state);
+	result = acpi_bus_update_power(device->handle, NULL);
 	if (result) {
-		printk(KERN_ERR PREFIX "Reading power state\n");
+		printk(KERN_ERR PREFIX "Setting initial power state\n");
 		goto end;
 	}
 
-	device->flags.force_power_state = 1;
-	acpi_bus_set_power(device->handle, state);
-	device->flags.force_power_state = 0;
-
 	cdev = thermal_cooling_device_register("Fan", device,
 						&fan_cooling_ops);
 	if (IS_ERR(cdev)) {
@@ -200,22 +195,14 @@ static int acpi_fan_suspend(struct acpi_
 
 static int acpi_fan_resume(struct acpi_device *device)
 {
-	int result = 0;
-	int power_state = 0;
+	int result;
 
 	if (!device)
 		return -EINVAL;
 
-	result = acpi_bus_get_power(device->handle, &power_state);
-	if (result) {
-		printk(KERN_ERR PREFIX
-				  "Error reading fan power state\n");
-		return result;
-	}
-
-	device->flags.force_power_state = 1;
-	acpi_bus_set_power(device->handle, power_state);
-	device->flags.force_power_state = 0;
+	result = acpi_bus_update_power(device->handle, NULL);
+	if (result)
+		printk(KERN_ERR PREFIX "Error updating fan power state\n");
 
 	return result;
 }
Index: linux-2.6/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_bus.h
+++ linux-2.6/include/acpi/acpi_bus.h
@@ -149,8 +149,7 @@ struct acpi_device_flags {
 	u32 power_manageable:1;
 	u32 performance_manageable:1;
 	u32 wake_capable:1;	/* Wakeup(_PRW) supported? */
-	u32 force_power_state:1;
-	u32 reserved:22;
+	u32 reserved:23;
 };
 
 /* File System */
Index: linux-2.6/drivers/acpi/thermal.c
===================================================================
--- linux-2.6.orig/drivers/acpi/thermal.c
+++ linux-2.6/drivers/acpi/thermal.c
@@ -1059,8 +1059,9 @@ static int acpi_thermal_resume(struct ac
 			break;
 		tz->trips.active[i].flags.enabled = 1;
 		for (j = 0; j < tz->trips.active[i].devices.count; j++) {
-			result = acpi_bus_get_power(tz->trips.active[i].devices.
-			    handles[j], &power_state);
+			result = acpi_bus_update_power(
+					tz->trips.active[i].devices.handles[j],
+					&power_state);
 			if (result || (power_state != ACPI_STATE_D0)) {
 				tz->trips.active[i].flags.enabled = 0;
 				break;
Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -266,7 +266,7 @@ static int __acpi_bus_set_power(struct a
 
 	/* Make sure this is a valid target state */
 
-	if ((state == device->power.state) && !device->flags.force_power_state) {
+	if (state == device->power.state) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at D%d\n",
 				  state));
 		return 0;

