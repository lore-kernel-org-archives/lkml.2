Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2FWVSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:15 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36925 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095Ab2FWVRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:17:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 9/21] ACPI: Use struct dev_pm_ops for power management in the button driver
Date: Sat, 23 Jun 2012 23:13:39 +0200
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
Message-Id: <201206232313.39574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the ACPI button driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/button.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux/drivers/acpi/button.c
===================================================================
--- linux.orig/drivers/acpi/button.c
+++ linux/drivers/acpi/button.c
@@ -76,19 +76,21 @@ MODULE_DEVICE_TABLE(acpi, button_device_
 
 static int acpi_button_add(struct acpi_device *device);
 static int acpi_button_remove(struct acpi_device *device, int type);
-static int acpi_button_resume(struct acpi_device *device);
 static void acpi_button_notify(struct acpi_device *device, u32 event);
 
+static int acpi_button_resume(struct device *dev);
+static SIMPLE_DEV_PM_OPS(acpi_button_pm, NULL, acpi_button_resume);
+
 static struct acpi_driver acpi_button_driver = {
 	.name = "button",
 	.class = ACPI_BUTTON_CLASS,
 	.ids = button_device_ids,
 	.ops = {
 		.add = acpi_button_add,
-		.resume = acpi_button_resume,
 		.remove = acpi_button_remove,
 		.notify = acpi_button_notify,
 	},
+	.drv.pm = &acpi_button_pm,
 };
 
 struct acpi_button {
@@ -308,8 +310,9 @@ static void acpi_button_notify(struct ac
 	}
 }
 
-static int acpi_button_resume(struct acpi_device *device)
+static int acpi_button_resume(struct device *dev)
 {
+	struct acpi_device *device = to_acpi_device(dev);
 	struct acpi_button *button = acpi_driver_data(device);
 
 	if (button->type == ACPI_BUTTON_TYPE_LID)

