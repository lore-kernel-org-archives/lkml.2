Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2C0HvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:51:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:64470 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab2C0Hum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:50:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="133511160"
From: Lin Ming <ming.m.lin@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ACPI: Introduce ACPI D3_COLD state support
Date: Tue, 27 Mar 2012 15:50:23 +0800
Message-Id: <1332834624-29310-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1332834624-29310-1-git-send-email-ming.m.lin@intel.com>
References: <1332834624-29310-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

If a device has _PR3, it means the device supports D3_COLD.
Add the ability to validate and enter D3_COLD state in ACPI.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/power.c |    4 ++--
 drivers/acpi/scan.c  |    7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 9ac2a9f..0d681fb 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -500,14 +500,14 @@ int acpi_power_transition(struct acpi_device *device, int state)
 {
 	int result;
 
-	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3))
+	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
 		return -EINVAL;
 
 	if (device->power.state == state)
 		return 0;
 
 	if ((device->power.state < ACPI_STATE_D0)
-	    || (device->power.state > ACPI_STATE_D3))
+	    || (device->power.state > ACPI_STATE_D3_COLD))
 		return -ENODEV;
 
 	/* TBD: Resources must be ordered. */
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 8ab80ba..571396c 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -885,6 +885,13 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
 				acpi_bus_add_power_resource(ps->resources.handles[j]);
 		}
 
+		/* The exist of _PR3 indicates D3Cold support */
+		if (i == ACPI_STATE_D3) {
+			status = acpi_get_handle(device->handle, object_name, &handle);
+			if (ACPI_SUCCESS(status))
+				device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
+		}
+
 		/* Evaluate "_PSx" to see if we can do explicit sets */
 		object_name[2] = 'S';
 		status = acpi_get_handle(device->handle, object_name, &handle);
-- 
1.7.2.5

