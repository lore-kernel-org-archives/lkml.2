Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2FWVSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36937 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab2FWVRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 7/21] ACPI: Use struct dev_pm_ops for power management in the AC driver
Date: Sat, 23 Jun 2012 23:12:31 +0200
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
Message-Id: <201206232312.31395.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the ACPI AC adapter driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/ac.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

Index: linux/drivers/acpi/ac.c
===================================================================
--- linux.orig/drivers/acpi/ac.c
+++ linux/drivers/acpi/ac.c
@@ -61,7 +61,6 @@ static int acpi_ac_open_fs(struct inode
 
 static int acpi_ac_add(struct acpi_device *device);
 static int acpi_ac_remove(struct acpi_device *device, int type);
-static int acpi_ac_resume(struct acpi_device *device);
 static void acpi_ac_notify(struct acpi_device *device, u32 event);
 
 static const struct acpi_device_id ac_device_ids[] = {
@@ -70,6 +69,9 @@ static const struct acpi_device_id ac_de
 };
 MODULE_DEVICE_TABLE(acpi, ac_device_ids);
 
+static int acpi_ac_resume(struct device *dev);
+static SIMPLE_DEV_PM_OPS(acpi_ac_pm, NULL, acpi_ac_resume);
+
 static struct acpi_driver acpi_ac_driver = {
 	.name = "ac",
 	.class = ACPI_AC_CLASS,
@@ -78,9 +80,9 @@ static struct acpi_driver acpi_ac_driver
 	.ops = {
 		.add = acpi_ac_add,
 		.remove = acpi_ac_remove,
-		.resume = acpi_ac_resume,
 		.notify = acpi_ac_notify,
 		},
+	.drv.pm = &acpi_ac_pm,
 };
 
 struct acpi_ac {
@@ -309,13 +311,18 @@ static int acpi_ac_add(struct acpi_devic
 	return result;
 }
 
-static int acpi_ac_resume(struct acpi_device *device)
+static int acpi_ac_resume(struct device *dev)
 {
 	struct acpi_ac *ac;
 	unsigned old_state;
-	if (!device || !acpi_driver_data(device))
+
+	if (!dev)
+		return -EINVAL;
+
+	ac = acpi_driver_data(to_acpi_device(dev));
+	if (!ac)
 		return -EINVAL;
-	ac = acpi_driver_data(device);
+
 	old_state = ac->state;
 	if (acpi_ac_get_state(ac))
 		return 0;

