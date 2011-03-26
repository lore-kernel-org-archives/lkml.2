Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1CZSSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:18:41 -0400
Received: from unix.wroclaw.pl ([94.23.28.62]:41529 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab1CZSSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:18:39 -0400
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Len Brown <lenb@kernel.org>
Cc: Kyle McMartin <kyle@redhat.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] ACPI battery: fix possible use after free in acpi_battery_add()
Date: Sat, 26 Mar 2011 19:18:26 +0100
Message-Id: <1301163506-7236-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When acpi_battery_add_fs() fails 'battery' will be kfreed and then
used again.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 drivers/acpi/battery.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index fcc13ac..27375e7 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -978,18 +978,15 @@ static int acpi_battery_add(struct acpi_device *device)
 	acpi_battery_update(battery);
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	result = acpi_battery_add_fs(device);
-#endif
-	if (!result) {
-		printk(KERN_INFO PREFIX "%s Slot [%s] (battery %s)\n",
-			ACPI_BATTERY_DEVICE_NAME, acpi_device_bid(device),
-			device->status.battery_present ? "present" : "absent");
-	} else {
-#ifdef CONFIG_ACPI_PROCFS_POWER
+	if (result) {
 		acpi_battery_remove_fs(device);
-#endif
 		kfree(battery);
+		return result;
 	}
-
+#endif
+	printk(KERN_INFO PREFIX "%s Slot [%s] (battery %s)\n",
+		ACPI_BATTERY_DEVICE_NAME, acpi_device_bid(device),
+		device->status.battery_present ? "present" : "absent");
 	battery->pm_nb.notifier_call = battery_notify;
 	register_pm_notifier(&battery->pm_nb);
 
-- 
1.7.0.4

