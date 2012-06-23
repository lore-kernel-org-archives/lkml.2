Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2FWVUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:20:46 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36981 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab2FWVSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:18:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 15/21] panasonic-laptop: Use struct dev_pm_ops for power management
Date: Sat, 23 Jun 2012 23:17:39 +0200
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
Message-Id: <201206232317.40174.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the panasonic-laptop driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct acpi_device_ops.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/platform/x86/panasonic-laptop.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux/drivers/platform/x86/panasonic-laptop.c
===================================================================
--- linux.orig/drivers/platform/x86/panasonic-laptop.c
+++ linux/drivers/platform/x86/panasonic-laptop.c
@@ -177,7 +177,6 @@ enum SINF_BITS { SINF_NUM_BATTERIES = 0,
 
 static int acpi_pcc_hotkey_add(struct acpi_device *device);
 static int acpi_pcc_hotkey_remove(struct acpi_device *device, int type);
-static int acpi_pcc_hotkey_resume(struct acpi_device *device);
 static void acpi_pcc_hotkey_notify(struct acpi_device *device, u32 event);
 
 static const struct acpi_device_id pcc_device_ids[] = {
@@ -189,6 +188,9 @@ static const struct acpi_device_id pcc_d
 };
 MODULE_DEVICE_TABLE(acpi, pcc_device_ids);
 
+static int acpi_pcc_hotkey_resume(struct device *dev);
+static SIMPLE_DEV_PM_OPS(acpi_pcc_hotkey_pm, NULL, acpi_pcc_hotkey_resume);
+
 static struct acpi_driver acpi_pcc_driver = {
 	.name =		ACPI_PCC_DRIVER_NAME,
 	.class =	ACPI_PCC_CLASS,
@@ -196,9 +198,9 @@ static struct acpi_driver acpi_pcc_drive
 	.ops =		{
 				.add =		acpi_pcc_hotkey_add,
 				.remove =	acpi_pcc_hotkey_remove,
-				.resume =       acpi_pcc_hotkey_resume,
 				.notify =	acpi_pcc_hotkey_notify,
 			},
+	.drv.pm =	&acpi_pcc_hotkey_pm,
 };
 
 static const struct key_entry panasonic_keymap[] = {
@@ -538,11 +540,15 @@ static void acpi_pcc_destroy_input(struc
 
 /* kernel module interface */
 
-static int acpi_pcc_hotkey_resume(struct acpi_device *device)
+static int acpi_pcc_hotkey_resume(struct device *dev)
 {
-	struct pcc_acpi *pcc = acpi_driver_data(device);
+	struct pcc_acpi *pcc;
+
+	if (!dev)
+		return -EINVAL;
 
-	if (device == NULL || pcc == NULL)
+	pcc = acpi_driver_data(to_acpi_device(dev));
+	if (!pcc)
 		return -EINVAL;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Sticky mode restore: %d\n",

