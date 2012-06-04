Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2FDFkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:40:24 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54747 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2FDFkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:16 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        <stable@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: [PATCH 01/15] ACPI battery: only refresh the sysfs files when pertinent information changes
Date: Mon,  4 Jun 2012 01:39:52 -0400
Message-Id: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

We only need to regenerate the sysfs files when the capacity units
change, avoid the update otherwise.

The origin of this issue is dates way back to 2.6.38:
da8aeb92d4853f37e281f11fddf61f9c7d84c3cd
(ACPI / Battery: Update information on info notification and resume)

cc: <stable@vger.kernel.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Tested-by: Ralf Jung <post@ralfj.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/battery.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 86933ca..7dd3f9f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -643,11 +643,19 @@ static int acpi_battery_update(struct acpi_battery *battery)
 
 static void acpi_battery_refresh(struct acpi_battery *battery)
 {
+	int power_unit;
+
 	if (!battery->bat.dev)
 		return;
 
+	power_unit = battery->power_unit;
+
 	acpi_battery_get_info(battery);
-	/* The battery may have changed its reporting units. */
+
+	if (power_unit == battery->power_unit)
+		return;
+
+	/* The battery has changed its reporting units. */
 	sysfs_remove_battery(battery);
 	sysfs_add_battery(battery);
 }
-- 
1.7.11.rc0.100.g5498c5f

