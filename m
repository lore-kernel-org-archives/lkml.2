Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0KXXR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:17:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52774 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab0KXXRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:17:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 10/13] ACPI / PM: Register power resource devices as soon as they are needed
Date: Thu, 25 Nov 2010 00:10:44 +0100
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
Message-Id: <201011250010.44306.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Depending on the organization of the ACPI namespace, power resource
device objects may generally be scanned after the "regular" device
objects that they are referred from through _PRn.  This, in turn, may
cause acpi_bus_get_power_flags() to attempt to access them through
acpi_bus_init_power() before they are registered (and initialized by
acpi_power_driver).  [This is not a theoretical issue, it actually
happens for one PnP device on my testbed HP nx6325.]

To fix this problem, make acpi_bus_get_power_flags() attempt to
register power resource devices as soon as they have been found in
the _PRn output for any other devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/scan.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux-2.6/drivers/acpi/scan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/scan.c
+++ linux-2.6/drivers/acpi/scan.c
@@ -827,6 +827,8 @@ end:
 	return 0;
 }
 
+static void acpi_bus_add_power_resource(acpi_handle handle);
+
 static int acpi_bus_get_power_flags(struct acpi_device *device)
 {
 	acpi_status status = 0;
@@ -855,8 +857,12 @@ static int acpi_bus_get_power_flags(stru
 		acpi_evaluate_reference(device->handle, object_name, NULL,
 					&ps->resources);
 		if (ps->resources.count) {
+			int j;
+
 			device->power.flags.power_resources = 1;
 			ps->flags.valid = 1;
+			for (j = 0; j < ps->resources.count; j++)
+				acpi_bus_add_power_resource(ps->resources.handles[j]);
 		}
 
 		/* Evaluate "_PSx" to see if we can do explicit sets */
@@ -1303,6 +1309,20 @@ end:
 #define ACPI_STA_DEFAULT (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED | \
 			  ACPI_STA_DEVICE_UI      | ACPI_STA_DEVICE_FUNCTIONING)
 
+static void acpi_bus_add_power_resource(acpi_handle handle)
+{
+	struct acpi_bus_ops ops = {
+		.acpi_op_add = 1,
+		.acpi_op_start = 1,
+	};
+	struct acpi_device *device = NULL;
+
+	acpi_bus_get_device(handle, &device);
+	if (!device)
+		acpi_add_single_object(&device, handle, ACPI_BUS_TYPE_POWER,
+					ACPI_STA_DEFAULT, &ops);
+}
+
 static int acpi_bus_type_and_status(acpi_handle handle, int *type,
 				    unsigned long long *sta)
 {

