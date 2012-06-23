Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2FWVSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:13 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36915 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab2FWVRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 12/21] toshiba_acpi: Use struct dev_pm_ops for power management
Date: Sat, 23 Jun 2012 23:15:39 +0200
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
Message-Id: <201206232315.40150.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the toshiba_acpi driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/platform/x86/toshiba_acpi.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

Index: linux/drivers/platform/x86/toshiba_acpi.c
===================================================================
--- linux.orig/drivers/platform/x86/toshiba_acpi.c
+++ linux/drivers/platform/x86/toshiba_acpi.c
@@ -1296,9 +1296,9 @@ static void toshiba_acpi_notify(struct a
 	}
 }
 
-static int toshiba_acpi_suspend(struct acpi_device *acpi_dev)
+static int toshiba_acpi_suspend(struct device *device)
 {
-	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
+	struct toshiba_acpi_dev *dev = acpi_driver_data(to_acpi_device(device));
 	u32 result;
 
 	if (dev->hotkey_dev)
@@ -1307,9 +1307,9 @@ static int toshiba_acpi_suspend(struct a
 	return 0;
 }
 
-static int toshiba_acpi_resume(struct acpi_device *acpi_dev)
+static int toshiba_acpi_resume(struct device *device)
 {
-	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
+	struct toshiba_acpi_dev *dev = acpi_driver_data(to_acpi_device(device));
 	u32 result;
 
 	if (dev->hotkey_dev)
@@ -1318,6 +1318,9 @@ static int toshiba_acpi_resume(struct ac
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(toshiba_acpi_pm,
+			 toshiba_acpi_suspend, toshiba_acpi_resume);
+
 static struct acpi_driver toshiba_acpi_driver = {
 	.name	= "Toshiba ACPI driver",
 	.owner	= THIS_MODULE,
@@ -1327,9 +1330,8 @@ static struct acpi_driver toshiba_acpi_d
 		.add		= toshiba_acpi_add,
 		.remove		= toshiba_acpi_remove,
 		.notify		= toshiba_acpi_notify,
-		.suspend	= toshiba_acpi_suspend,
-		.resume		= toshiba_acpi_resume,
 	},
+	.drv.pm	= &toshiba_acpi_pm,
 };
 
 static int __init toshiba_acpi_init(void)

