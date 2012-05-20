Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2ETMGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 08:06:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2ETMGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 08:06:05 -0400
From: Alex Hung <alex.hung@canonical.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.hung@canonical.com
Subject: [PATCH] ACPI: battery: fix battery->alarm is updated when it is not supported
Date: Sun, 20 May 2012 20:05:56 +0800
Message-Id: <1337515556-5232-1-git-send-email-alex.hung@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

battery alarm is checked whether BIOS supports it before past to BIOS;
however, the value is updatd without being checked. This causes alarm return
an incorrect value that never represents an actual state BIOS is in.

Signed-off-by: Alex Hung <alex.hung@canonical.com>
---
 drivers/acpi/battery.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 86933ca..14548e8 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -535,7 +535,8 @@ static ssize_t acpi_battery_alarm_store(struct device *dev,
 {
 	unsigned long x;
 	struct acpi_battery *battery = to_acpi_battery(dev_get_drvdata(dev));
-	if (sscanf(buf, "%ld\n", &x) == 1)
+	if (sscanf(buf, "%ld\n", &x) == 1 &&
+		test_bit(ACPI_BATTERY_ALARM_PRESENT, &battery->flags))
 		battery->alarm = x/1000;
 	if (acpi_battery_present(battery))
 		acpi_battery_set_alarm(battery);
@@ -805,7 +806,8 @@ static ssize_t acpi_battery_write_alarm(struct file *file,
 		goto end;
 	}
 	alarm_string[count] = '\0';
-	battery->alarm = simple_strtol(alarm_string, NULL, 0);
+	if (test_bit(ACPI_BATTERY_ALARM_PRESENT, &battery->flags))
+		battery->alarm = simple_strtol(alarm_string, NULL, 0);
 	result = acpi_battery_set_alarm(battery);
       end:
 	if (!result)
-- 
1.7.0.4

