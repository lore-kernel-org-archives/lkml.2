Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3ADAHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:07:55 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59166 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab3ADAHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/12] ACPI: Do not use device power states of power resources
Date: Fri, 04 Jan 2013 01:04:49 +0100
Message-ID: <26620799.HxovvlWMgm@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1418767.4KIZOTK1lk@vostro.rjw.lan>
References: <1418767.4KIZOTK1lk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

ACPI power resource objects have struct acpi_device components, but
they are only used for registering those resources in the device
hierarchy.  In particular, power state information stored in them is
completely useless (amnong other things, because the power resources
"devices" are not power manageable), so there is no reason for the
power resources management code to keep it up to date.

Remove the code updating device power states of power resources from
drivers/acpi/power.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/power.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

Index: linux/drivers/acpi/power.c
===================================================================
--- linux.orig/drivers/acpi/power.c
+++ linux/drivers/acpi/power.c
@@ -193,9 +193,6 @@ static int __acpi_power_on(struct acpi_p
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	/* Update the power resource's _device_ power state */
-	resource->device.power.state = ACPI_STATE_D0;
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Power resource [%s] turned on\n",
 			  resource->name));
 
@@ -261,16 +258,12 @@ static int acpi_power_off(acpi_handle ha
 	}
 
 	status = acpi_evaluate_object(resource->device.handle, "_OFF", NULL, NULL);
-	if (ACPI_FAILURE(status)) {
+	if (ACPI_FAILURE(status))
 		result = -ENODEV;
-	} else {
-		/* Update the power resource's _device_ power state */
-		resource->device.power.state = ACPI_STATE_D3;
-
+	else
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Power resource [%s] turned off\n",
 				  resource->name));
-	}
 
  unlock:
 	mutex_unlock(&resource->resource_lock);
@@ -659,6 +652,7 @@ void acpi_add_power_resource(acpi_handle
 	resource->name = device->pnp.bus_id;
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_POWER_CLASS);
+	device->power.state = ACPI_STATE_UNKNOWN;
 
 	/* Evalute the object to get the system level and resource order. */
 	status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
@@ -672,17 +666,6 @@ void acpi_add_power_resource(acpi_handle
 	if (result)
 		goto err;
 
-	switch (state) {
-	case ACPI_POWER_RESOURCE_STATE_ON:
-		device->power.state = ACPI_STATE_D0;
-		break;
-	case ACPI_POWER_RESOURCE_STATE_OFF:
-		device->power.state = ACPI_STATE_D3;
-		break;
-	default:
-		device->power.state = ACPI_STATE_UNKNOWN;
-	}
-
 	printk(KERN_INFO PREFIX "%s [%s] (%s)\n", acpi_device_name(device),
 	       acpi_device_bid(device), state ? "on" : "off");
 

