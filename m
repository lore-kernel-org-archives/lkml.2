Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2FWVSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36911 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092Ab2FWVRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 5/21] ACPI: Use struct dev_pm_ops for power management in the thermal driver
Date: Sat, 23 Jun 2012 23:11:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>
References: <201206232306.06602.rjw@sisk.pl>
In-Reply-To: <201206232306.06602.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206232311.15849.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the ACPI thermal driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/thermal.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux/drivers/acpi/thermal.c
===================================================================
--- linux.orig/drivers/acpi/thermal.c
+++ linux/drivers/acpi/thermal.c
@@ -98,7 +98,6 @@ MODULE_PARM_DESC(psv, "Disable or overri
 
 static int acpi_thermal_add(struct acpi_device *device);
 static int acpi_thermal_remove(struct acpi_device *device, int type);
-static int acpi_thermal_resume(struct acpi_device *device);
 static void acpi_thermal_notify(struct acpi_device *device, u32 event);
 
 static const struct acpi_device_id  thermal_device_ids[] = {
@@ -107,6 +106,9 @@ static const struct acpi_device_id  ther
 };
 MODULE_DEVICE_TABLE(acpi, thermal_device_ids);
 
+static int acpi_thermal_resume(struct device *dev);
+static SIMPLE_DEV_PM_OPS(acpi_thermal_pm, NULL, acpi_thermal_resume);
+
 static struct acpi_driver acpi_thermal_driver = {
 	.name = "thermal",
 	.class = ACPI_THERMAL_CLASS,
@@ -114,9 +116,9 @@ static struct acpi_driver acpi_thermal_d
 	.ops = {
 		.add = acpi_thermal_add,
 		.remove = acpi_thermal_remove,
-		.resume = acpi_thermal_resume,
 		.notify = acpi_thermal_notify,
 		},
+	.drv.pm = &acpi_thermal_pm,
 };
 
 struct acpi_thermal_state {
@@ -1041,16 +1043,17 @@ static int acpi_thermal_remove(struct ac
 	return 0;
 }
 
-static int acpi_thermal_resume(struct acpi_device *device)
+static int acpi_thermal_resume(struct device *dev)
 {
-	struct acpi_thermal *tz = NULL;
+	struct acpi_thermal *tz;
 	int i, j, power_state, result;
 
-
-	if (!device || !acpi_driver_data(device))
+	if (!dev)
 		return -EINVAL;
 
-	tz = acpi_driver_data(device);
+	tz = acpi_driver_data(to_acpi_device(dev));
+	if (!tz)
+		return -EINVAL;
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
 		if (!(&tz->trips.active[i]))

