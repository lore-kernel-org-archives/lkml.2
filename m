Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2FWVSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:20 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab2FWVRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 11/21] ACPI: Use struct dev_pm_ops for power management in the SBS driver
Date: Sat, 23 Jun 2012 23:14:51 +0200
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
Message-Id: <201206232314.52169.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the ACPI Smart Battery System driver define its PM callbacks
through a struct dev_pm_ops object rather than by using legacy PM
hooks in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/sbs.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux/drivers/acpi/sbs.c
===================================================================
--- linux.orig/drivers/acpi/sbs.c
+++ linux/drivers/acpi/sbs.c
@@ -988,16 +988,18 @@ static void acpi_sbs_rmdirs(void)
 #endif
 }
 
-static int acpi_sbs_resume(struct acpi_device *device)
+static int acpi_sbs_resume(struct device *dev)
 {
 	struct acpi_sbs *sbs;
-	if (!device)
+	if (!dev)
 		return -EINVAL;
-	sbs = device->driver_data;
+	sbs = to_acpi_device(dev)->driver_data;
 	acpi_sbs_callback(sbs);
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(acpi_sbs_pm, NULL, acpi_sbs_resume);
+
 static struct acpi_driver acpi_sbs_driver = {
 	.name = "sbs",
 	.class = ACPI_SBS_CLASS,
@@ -1005,8 +1007,8 @@ static struct acpi_driver acpi_sbs_drive
 	.ops = {
 		.add = acpi_sbs_add,
 		.remove = acpi_sbs_remove,
-		.resume = acpi_sbs_resume,
 		},
+	.drv.pm = &acpi_sbs_pm,
 };
 
 static int __init acpi_sbs_init(void)

