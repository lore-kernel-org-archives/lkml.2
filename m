Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab1LOSHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:07:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34940 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759123Ab1LOSHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:07:15 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 4/4] toshiba_acpi: Add blacklist for devices with hotkey problems
Date: Thu, 15 Dec 2011 12:06:11 -0600
Message-Id: <1323972371-13189-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com>
References: <1323972371-13189-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Satellite C670-10V has buggy implementation of the INFO method that
causes ACPI exceptions when executed:

 ACPI Error: Result stack is empty! State=ffff88012d70f800 (20110413/dswstate-98)
 ACPI Exception: AE_AML_NO_RETURN_VALUE, Missing or null operand (20110413/dsutils-646)
 ACPI Exception: AE_AML_NO_RETURN_VALUE, While creating Arg 0 (20110413/dsutils-763)
 ACPI Error: Method parse/execution failed [\_SB_.VALZ.GETE] (Node ffff880131175eb0), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
 ACPI Error: Method parse/execution failed [\_SB_.VALZ.INFO] (Node ffff880131175ed8), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
 toshiba_acpi: ACPI INFO method execution failed
 toshiba_acpi: Failed to query hotkey event

To work around this, add a blacklist of models with hotkey problems and
add this model to that list.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/toshiba_acpi.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 6824bf7..a2f7cce 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -54,6 +54,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/i8042.h>
+#include <linux/dmi.h>
 
 #include <asm/uaccess.h>
 
@@ -174,6 +175,18 @@ static const struct key_entry toshiba_acpi_keymap[] __devinitconst = {
 	{ KE_END, 0 },
 };
 
+/* Machines for which hotkeys should not be enabled */
+static struct dmi_system_id __devinitdata toshiba_hotkey_blacklist[] = {
+	{
+		.ident = "Toshiba Satellite C670-10V",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE C670-10V"),
+		},
+	},
+	{}
+};
+
 /* utility
  */
 
@@ -935,6 +948,11 @@ static int __devinit toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
 	int error;
 	u32 hci_result;
 
+	if (dmi_check_system(toshiba_hotkey_blacklist)) {
+		pr_info("Model has known hotkey problems, hotkeys will be disabled\n");
+		return 0;
+	}
+
 	dev->hotkey_dev = input_allocate_device();
 	if (!dev->hotkey_dev) {
 		pr_info("Unable to register input device\n");
-- 
1.7.5.4

