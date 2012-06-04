Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab2FDFkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:40:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56777 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab2FDFkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:24 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 05/15] ACPI / PM: Fix error messages in drivers/acpi/bus.c
Date: Mon,  4 Jun 2012 01:39:56 -0400
Message-Id: <63a1a765dffb1e59d82c7948638e56d5f4f2e3a1.1338786831.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
In-Reply-To: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
References: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>

After recent changes of the ACPI device low-power states definitions
kernel messages in drivers/acpi/bus.c need to be updated so that they
include the correct names of the states in question (currently is
"D3" for D3hot and "D4" for D3cold, which is incorrect).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/bus.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 3188da3..a41be56 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -182,6 +182,24 @@ EXPORT_SYMBOL(acpi_bus_get_private_data);
                                  Power Management
    -------------------------------------------------------------------------- */
 
+static const char *state_string(int state)
+{
+	switch (state) {
+	case ACPI_STATE_D0:
+		return "D0";
+	case ACPI_STATE_D1:
+		return "D1";
+	case ACPI_STATE_D2:
+		return "D2";
+	case ACPI_STATE_D3_HOT:
+		return "D3hot";
+	case ACPI_STATE_D3_COLD:
+		return "D3";
+	default:
+		return "(unknown)";
+	}
+}
+
 static int __acpi_bus_get_power(struct acpi_device *device, int *state)
 {
 	int result = 0;
@@ -215,8 +233,8 @@ static int __acpi_bus_get_power(struct acpi_device *device, int *state)
 			device->parent->power.state : ACPI_STATE_D0;
 	}
 
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] power state is D%d\n",
-			  device->pnp.bus_id, *state));
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device [%s] power state is %s\n",
+			  device->pnp.bus_id, state_string(*state)));
 
 	return 0;
 }
@@ -234,13 +252,14 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
 	/* Make sure this is a valid target state */
 
 	if (state == device->power.state) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at D%d\n",
-				  state));
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device is already at %s\n",
+				  state_string(state)));
 		return 0;
 	}
 
 	if (!device->power.states[state].flags.valid) {
-		printk(KERN_WARNING PREFIX "Device does not support D%d\n", state);
+		printk(KERN_WARNING PREFIX "Device does not support %s\n",
+		       state_string(state));
 		return -ENODEV;
 	}
 	if (device->parent && (state < device->parent->power.state)) {
@@ -294,13 +313,13 @@ static int __acpi_bus_set_power(struct acpi_device *device, int state)
       end:
 	if (result)
 		printk(KERN_WARNING PREFIX
-			      "Device [%s] failed to transition to D%d\n",
-			      device->pnp.bus_id, state);
+			      "Device [%s] failed to transition to %s\n",
+			      device->pnp.bus_id, state_string(state));
 	else {
 		device->power.state = state;
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Device [%s] transitioned to D%d\n",
-				  device->pnp.bus_id, state));
+				  "Device [%s] transitioned to %s\n",
+				  device->pnp.bus_id, state_string(state)));
 	}
 
 	return result;
-- 
1.7.11.rc0.100.g5498c5f

