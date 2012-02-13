Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2BMJNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:13:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:56546 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab2BMJLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:11:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124653298"
From: Lin Ming <ming.m.lin@intel.com>
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [RFC PATCH 1/6] ACPI: Introduce ACPI D3_COLD state support
Date: Mon, 13 Feb 2012 17:11:06 +0800
Message-Id: <1329124271-29464-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

If a device has _PR3._ON, it means the device supports D3_HOT.
If a device has _PR3._OFF, it means the device supports D3_COLD.
Add the ability to validate and enter D3_COLD state in ACPI.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/power.c |    4 ++--
 drivers/acpi/scan.c  |   10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

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
index 8ab80ba..a9d4391 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -881,8 +881,16 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
 
 			device->power.flags.power_resources = 1;
 			ps->flags.valid = 1;
-			for (j = 0; j < ps->resources.count; j++)
+			for (j = 0; j < ps->resources.count; j++) {
 				acpi_bus_add_power_resource(ps->resources.handles[j]);
+				/* Check for D3_COLD support. _PR3._OFF equals D3_COLD ? */
+				if (i == ACPI_STATE_D3) {
+					if (j == 0)
+						device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
+					status = acpi_get_handle(ps->resources.handles[j], "_OFF",  &handle);
+					device->power.states[ACPI_STATE_D3_COLD].flags.valid &= ACPI_SUCCESS(status);
+				}
+			}
 		}
 
 		/* Evaluate "_PSx" to see if we can do explicit sets */
-- 
1.7.2.5

