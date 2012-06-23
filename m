Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab2FWVSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:04 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36880 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab2FWVRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/21] ACPI / PM: Make acpi_bus_type use struct dev_pm_ops for PM handling
Date: Sat, 23 Jun 2012 23:08:36 +0200
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
Message-Id: <201206232308.37321.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the acpi_bus_type bus type define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct bus_type.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/scan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -290,7 +290,7 @@ static void acpi_device_release(struct d
 	kfree(acpi_dev);
 }
 
-static int acpi_device_suspend(struct device *dev, pm_message_t state)
+static int acpi_device_suspend(struct device *dev)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = acpi_dev->driver;
@@ -310,6 +310,8 @@ static int acpi_device_resume(struct dev
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(acpi_bus_pm, acpi_device_suspend, acpi_device_resume);
+
 static int acpi_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
@@ -441,12 +443,11 @@ static int acpi_device_remove(struct dev
 
 struct bus_type acpi_bus_type = {
 	.name		= "acpi",
-	.suspend	= acpi_device_suspend,
-	.resume		= acpi_device_resume,
 	.match		= acpi_bus_match,
 	.probe		= acpi_device_probe,
 	.remove		= acpi_device_remove,
 	.uevent		= acpi_device_uevent,
+	.pm		= &acpi_bus_pm,
 };
 
 static int acpi_device_register(struct acpi_device *device)

