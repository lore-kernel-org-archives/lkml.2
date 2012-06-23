Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2FWVUG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:20:06 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36989 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab2FWVST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:18:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 18/21] acpi_power_meter: Use struct dev_pm_ops for power management
Date: Sat, 23 Jun 2012 23:19:31 +0200
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
Message-Id: <201206232319.31903.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the ACPI power meter driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/hwmon/acpi_power_meter.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux/drivers/hwmon/acpi_power_meter.c
===================================================================
--- linux.orig/drivers/hwmon/acpi_power_meter.c
+++ linux/drivers/hwmon/acpi_power_meter.c
@@ -929,20 +929,25 @@ static int acpi_power_meter_remove(struc
 	return 0;
 }
 
-static int acpi_power_meter_resume(struct acpi_device *device)
+static int acpi_power_meter_resume(struct device *dev)
 {
 	struct acpi_power_meter_resource *resource;
 
-	if (!device || !acpi_driver_data(device))
+	if (!dev)
+		return -EINVAL;
+
+	resource = acpi_driver_data(to_acpi_device(dev));
+	if (!resource)
 		return -EINVAL;
 
-	resource = acpi_driver_data(device);
 	free_capabilities(resource);
 	read_capabilities(resource);
 
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(acpi_power_meter_pm, NULL, acpi_power_meter_resume);
+
 static struct acpi_driver acpi_power_meter_driver = {
 	.name = "power_meter",
 	.class = ACPI_POWER_METER_CLASS,
@@ -950,9 +955,9 @@ static struct acpi_driver acpi_power_met
 	.ops = {
 		.add = acpi_power_meter_add,
 		.remove = acpi_power_meter_remove,
-		.resume = acpi_power_meter_resume,
 		.notify = acpi_power_meter_notify,
 		},
+	.drv.pm = &acpi_power_meter_pm,
 };
 
 /* Module init/exit routines */

