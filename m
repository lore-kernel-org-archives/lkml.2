Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1GLIEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:04:11 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:48257 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1GLIDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:03:54 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ACPI / Battery: avoid acpi_battery_add() use-after-free
Date: Tue, 12 Jul 2011 09:03:28 +0100
Message-Id: <1310457809-2731-3-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
References: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When acpi_battery_add_fs() fails the error handling code does not clean
up completely.  Moreover, it does not return resulting in a
use-after-free.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 drivers/acpi/battery.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index fcc13ac..6b3aeba 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -979,21 +979,27 @@ static int acpi_battery_add(struct acpi_device *device)
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	result = acpi_battery_add_fs(device);
 #endif
-	if (!result) {
-		printk(KERN_INFO PREFIX "%s Slot [%s] (battery %s)\n",
-			ACPI_BATTERY_DEVICE_NAME, acpi_device_bid(device),
-			device->status.battery_present ? "present" : "absent");
-	} else {
+	if (result) {
 #ifdef CONFIG_ACPI_PROCFS_POWER
 		acpi_battery_remove_fs(device);
 #endif
-		kfree(battery);
+		goto fail;
 	}
 
+	printk(KERN_INFO PREFIX "%s Slot [%s] (battery %s)\n",
+		ACPI_BATTERY_DEVICE_NAME, acpi_device_bid(device),
+		device->status.battery_present ? "present" : "absent");
+
 	battery->pm_nb.notifier_call = battery_notify;
 	register_pm_notifier(&battery->pm_nb);
 
 	return result;
+
+fail:
+	sysfs_remove_battery(battery);
+	mutex_destroy(&battery->lock);
+	kfree(battery);
+	return result;
 }
 
 static int acpi_battery_remove(struct acpi_device *device, int type)
-- 
1.7.5.4

