Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab1GLIEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:04:01 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:48011 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1GLIDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:03:54 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ACPI / Battery: propagate sysfs error in acpi_battery_add()
Date: Tue, 12 Jul 2011 09:03:29 +0100
Message-Id: <1310457809-2731-4-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
References: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure the error return from sysfs_add_battery() is checked and
propagated out from acpi_battery_add().

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 drivers/acpi/battery.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 6b3aeba..2ae2fca 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -626,8 +626,11 @@ static int acpi_battery_update(struct acpi_battery *battery)
 		acpi_battery_quirks(battery);
 		acpi_battery_init_alarm(battery);
 	}
-	if (!battery->bat.dev)
-		sysfs_add_battery(battery);
+	if (!battery->bat.dev) {
+		result = sysfs_add_battery(battery);
+		if (result)
+			return result;
+	}
 	result = acpi_battery_get_state(battery);
 	acpi_battery_quirks2(battery);
 	return result;
@@ -975,7 +978,9 @@ static int acpi_battery_add(struct acpi_device *device)
 	if (ACPI_SUCCESS(acpi_get_handle(battery->device->handle,
 			"_BIX", &handle)))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
-	acpi_battery_update(battery);
+	result = acpi_battery_update(battery);
+	if (result)
+		goto fail;
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	result = acpi_battery_add_fs(device);
 #endif
-- 
1.7.5.4

