Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1BFM2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:28:37 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:37752 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab1BFM2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:28:35 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.40
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] asus-laptop: let WLED alone on L1400B
Date: Sun,  6 Feb 2011 13:27:30 +0100
Message-Id: <1296995251-5306-1-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

Asus took the DSDT from another model (L84F), made some change
to make it work, but forgot to remove WLED method (the laptop
doesn't have a wireless card). They even didn't change the model
name.

ref: https://bugzilla.kernel.org/show_bug.cgi?id=25712

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index d235f44..1909685 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -50,6 +50,7 @@
 #include <linux/input/sparse-keymap.h>
 #include <linux/rfkill.h>
 #include <linux/slab.h>
+#include <linux/dmi.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_bus.h>
 
@@ -1556,6 +1557,20 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	return result;
 }
 
+static void __devinit asus_dmi_check(void)
+{
+	const char *model;
+
+	model = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!model)
+		return;
+
+	/* On L1400B WLED control the sound card, don't mess with it ... */
+	if (strncmp(model, "L1400B", 6) == 0) {
+		wlan_status = -1;
+	}
+}
+
 static bool asus_device_present;
 
 static int __devinit asus_acpi_add(struct acpi_device *device)
@@ -1574,6 +1589,8 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 	device->driver_data = asus;
 	asus->device = device;
 
+	asus_dmi_check();
+
 	result = asus_acpi_init(asus);
 	if (result)
 		goto fail_platform;
-- 
1.7.4.rc3

