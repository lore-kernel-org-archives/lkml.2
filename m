Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2BMJMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:12:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:56546 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2BMJLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:11:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124653335"
From: Lin Ming <ming.m.lin@intel.com>
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [RFC PATCH 3/6] ACPI: Runtime resume all devices covered by a power resource
Date: Mon, 13 Feb 2012 17:11:08 +0800
Message-Id: <1329124271-29464-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

When an ACPI Power Resource is turned on, we should runtime
resume all the devices covered by this ACPI Power Resource.
So that they have a chance to runtime suspend again.
Or else, they will be in uninitialized state after powered on.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/power.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index a7e2305..86791e3 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -40,6 +40,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include "sleep.h"
@@ -201,6 +202,7 @@ static int acpi_power_get_list_state(struct acpi_handle_list *list, int *state)
 static int __acpi_power_on(struct acpi_power_resource *resource)
 {
 	acpi_status status = AE_OK;
+	struct acpi_powered_device *apd;
 
 	status = acpi_evaluate_object(resource->device->handle, "_ON", NULL, NULL);
 	if (ACPI_FAILURE(status))
@@ -212,6 +214,13 @@ static int __acpi_power_on(struct acpi_power_resource *resource)
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Power resource [%s] turned on\n",
 			  resource->name));
 
+	/* resume all the devices when power resource is turned on */
+	list_for_each_entry(apd, &resource->devices, node){
+		pm_request_resume(apd->dev);
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "resume device %s\n",
+						apd->dev->kobj.name));
+	}
+
 	return 0;
 }
 
-- 
1.7.2.5

