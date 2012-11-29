Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2K2INw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:13:52 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:34715 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab2K2INt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:13:49 -0500
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] asus-laptop: Do not call HWRS on init
Date: Thu, 29 Nov 2012 09:12:37 +0100
Message-Id: <1354176759-630-10-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1354176759-630-1-git-send-email-corentin.chary@gmail.com>
References: <1354176759-630-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

Since commit 8871e99f89b7 ('asus-laptop: HRWS/HWRS typo'), module
initialisation is very slow on the Asus UL30A.  The HWRS method takes
about 12 seconds to run, and subsequent initialisation also seems to
be delayed.  Since we don't really need the result, don't bother
calling it on init.  Those who are curious can still get the result
through the 'infos' device attribute.

Update the comment about HWRS in show_infos().

Reported-by: ryan <draziw+deb@gmail.com>
References: http://bugs.debian.org/692436
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 0d371d0..0fc4e30 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -883,8 +883,10 @@ static ssize_t show_infos(struct device *dev,
 	/*
 	 * The HWRS method return informations about the hardware.
 	 * 0x80 bit is for WLAN, 0x100 for Bluetooth.
+	 * 0x40 for WWAN, 0x10 for WIMAX.
 	 * The significance of others is yet to be found.
-	 * If we don't find the method, we assume the device are present.
+	 * We don't currently use this for device detection, and it
+	 * takes several seconds to run on some systems.
 	 */
 	rv = acpi_evaluate_integer(asus->handle, "HWRS", NULL, &temp);
 	if (!ACPI_FAILURE(rv))
@@ -1705,7 +1707,7 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *model = NULL;
-	unsigned long long bsts_result, hwrs_result;
+	unsigned long long bsts_result;
 	char *string = NULL;
 	acpi_status status;
 
@@ -1767,17 +1769,6 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 	if (*string)
 		pr_notice("  %s model detected\n", string);
 
-	/*
-	 * The HWRS method return informations about the hardware.
-	 * 0x80 bit is for WLAN, 0x100 for Bluetooth,
-	 * 0x40 for WWAN, 0x10 for WIMAX.
-	 * The significance of others is yet to be found.
-	 */
-	status =
-	    acpi_evaluate_integer(asus->handle, "HWRS", NULL, &hwrs_result);
-	if (!ACPI_FAILURE(status))
-		pr_notice("  HWRS returned %x", (int)hwrs_result);
-
 	if (!acpi_check_handle(asus->handle, METHOD_WL_STATUS, NULL))
 		asus->have_rsts = true;
 
-- 
1.7.8.6

