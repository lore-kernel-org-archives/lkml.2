Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1GPW7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 18:59:00 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:47091 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1GPW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 18:58:59 -0400
Date: Sat, 16 Jul 2011 18:58:55 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ACPI / Battery: propagate sysfs error in
 acpi_battery_add()
In-reply-to: <1310457809-2731-4-git-send-email-stefanha@linux.vnet.ibm.com>
Message-id: <alpine.LFD.2.02.1107161857420.11045@x980>
References: <1310457809-2731-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <1310457809-2731-4-git-send-email-stefanha@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied, after merging with acpi-test.

merged version appended below.

thanks,
Len Brown, Intel Open Source Technology Center

>From eb03cb02b74df6dd0b653d5f6d976f16a434dfaf Mon Sep 17 00:00:00 2001
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Date: Tue, 12 Jul 2011 09:03:29 +0100
Subject: [PATCH] ACPI / Battery: propagate sysfs error in acpi_battery_add()
X-Patchwork-Hint: ignore

Make sure the error return from sysfs_add_battery() is checked and
propagated out from acpi_battery_add().

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/battery.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index c771768..ffce2f0 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -630,8 +630,11 @@ static int acpi_battery_update(struct acpi_battery *battery)
 			return result;
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
 	acpi_battery_quirks(battery);
 	return result;
@@ -982,7 +985,9 @@ static int acpi_battery_add(struct acpi_device *device)
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
1.7.6.178.g55272

