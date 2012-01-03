Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2ACTDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:03:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab2ACTDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:03:07 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 4/4] toshiba_acpi: Add blacklist for models with hotkey problems
Date: Tue,  3 Jan 2012 13:02:38 -0600
Message-Id: <1325617358-8286-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several Satellite models have a buggy implementation of the INFO method
that causes ACPI exceptions when executed:

 ACPI Error: Result stack is empty! State=ffff88012d70f800 (20110413/dswstate-98)
 ACPI Exception: AE_AML_NO_RETURN_VALUE, Missing or null operand (20110413/dsutils-646)
 ACPI Exception: AE_AML_NO_RETURN_VALUE, While creating Arg 0 (20110413/dsutils-763)
 ACPI Error: Method parse/execution failed [\_SB_.VALZ.GETE] (Node ffff880131175eb0), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
 ACPI Error: Method parse/execution failed [\_SB_.VALZ.INFO] (Node ffff880131175ed8), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
 toshiba_acpi: ACPI INFO method execution failed
 toshiba_acpi: Failed to query hotkey event

To work around this, add a blacklist of models with hotkey problems and
disable the use of hotkeys on these machines.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/toshiba_acpi.c |   39 +++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 6824bf7..fbb8318 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -54,6 +54,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/i8042.h>
+#include <linux/dmi.h>
 
 #include <asm/uaccess.h>
 
@@ -174,6 +175,39 @@ static const struct key_entry toshiba_acpi_keymap[] __devinitconst = {
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
+	{
+		.ident = "Toshiba Satellite C670-12E",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE C670-12E"),
+		},
+	},
+	{
+		.ident = "Toshiba Satellite U500",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE U500"),
+		},
+	},
+	{
+		.ident = "Toshiba Satellite Pro L770-116",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE PRO L770-116"),
+		},
+	},
+	{}
+};
+
 /* utility
  */
 
@@ -935,6 +969,11 @@ static int __devinit toshiba_acpi_setup_keyboard(struct toshiba_acpi_dev *dev)
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

