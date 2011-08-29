Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1H2VFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:05:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59521 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1H2VFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:05:10 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/5] toshiba_acpi: Support SPFC as an HCI method
Date: Mon, 29 Aug 2011 16:04:54 -0500
Message-Id: <1314651895-24345-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314651895-24345-1-git-send-email-seth.forshee@canonical.com>
References: <1314651895-24345-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Toshiba models, notably those with the TOS1900 device, use
the SPFC method for HCI calls instead of GHCI. Test for this method
if GHCI isn't found, and if it exists use it for all HCI calls.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/toshiba_acpi.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 90018cf..2772e0e 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -892,11 +892,26 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev, int type)
 	return 0;
 }
 
+static const char * __devinit find_hci_method(acpi_handle handle)
+{
+	acpi_status status;
+	acpi_handle hci_handle;
+
+	status = acpi_get_handle(handle, "GHCI", &hci_handle);
+	if (ACPI_SUCCESS(status))
+		return "GHCI";
+
+	status = acpi_get_handle(handle, "SPFC", &hci_handle);
+	if (ACPI_SUCCESS(status))
+		return "SPFC";
+
+	return NULL;
+}
+
 static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
 {
 	struct toshiba_acpi_dev *dev;
-	acpi_status status;
-	acpi_handle handle;
+	const char *hci_method;
 	u32 hci_result;
 	bool bt_present;
 	int ret = 0;
@@ -905,16 +920,17 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
 	pr_info("Toshiba Laptop ACPI Extras version %s\n",
 	       TOSHIBA_ACPI_VERSION);
 
-	/* simple device detection: look for HCI method */
-	status = acpi_get_handle(acpi_dev->handle, "GHCI", &handle);
-	if (ACPI_FAILURE(status))
+	hci_method = find_hci_method(acpi_dev->handle);
+	if (!hci_method) {
+		pr_err("HCI interface not found\n");
 		return -ENODEV;
+	}
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 	dev->acpi_dev = acpi_dev;
-	dev->method_hci = "GHCI";
+	dev->method_hci = hci_method;
 	acpi_dev->driver_data = dev;
 
 	if (toshiba_acpi_setup_keyboard(dev))
-- 
1.7.4.1

