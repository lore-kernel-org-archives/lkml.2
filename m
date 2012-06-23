Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2FWVSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:17 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36932 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab2FWVRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 8/21] ACPI: Use struct dev_pm_ops for power management in the battery driver
Date: Sat, 23 Jun 2012 23:13:04 +0200
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
Message-Id: <201206232313.04330.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the ACPI battery driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/battery.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux/drivers/acpi/battery.c
===================================================================
--- linux.orig/drivers/acpi/battery.c
+++ linux/drivers/acpi/battery.c
@@ -1044,17 +1044,24 @@ static int acpi_battery_remove(struct ac
 }
 
 /* this is needed to learn about changes made in suspended state */
-static int acpi_battery_resume(struct acpi_device *device)
+static int acpi_battery_resume(struct device *dev)
 {
 	struct acpi_battery *battery;
-	if (!device)
+
+	if (!dev)
+		return -EINVAL;
+
+	battery = acpi_driver_data(to_acpi_device(dev));
+	if (!battery)
 		return -EINVAL;
-	battery = acpi_driver_data(device);
+
 	battery->update_time = 0;
 	acpi_battery_update(battery);
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(acpi_battery_pm, NULL, acpi_battery_resume);
+
 static struct acpi_driver acpi_battery_driver = {
 	.name = "battery",
 	.class = ACPI_BATTERY_CLASS,
@@ -1062,10 +1069,10 @@ static struct acpi_driver acpi_battery_d
 	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
 	.ops = {
 		.add = acpi_battery_add,
-		.resume = acpi_battery_resume,
 		.remove = acpi_battery_remove,
 		.notify = acpi_battery_notify,
 		},
+	.drv.pm = &acpi_battery_pm,
 };
 
 static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)

