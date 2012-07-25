Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab2GYDnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:43:51 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62253 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab2GYDnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:37 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        stable@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 49/52] ACPI/AC: prevent OOPS on some boxes due to missing check power_supply_register() return value check
Date: Tue, 24 Jul 2012 23:41:45 -0400
Message-Id: <f197ac13f6eeb351b31250b9ab7d0da17434ea36.1343187618.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

In the ac.c, power_supply_register()'s return value is not checked.

As a result, the driver's add() ops may return success
even though the device failed to initialize.

For example, some BIOS may describe two ACADs in the same DSDT.
The second ACAD device will fail to register,
but ACPI driver's add() ops returns sucessfully.
The ACPI device will receive ACPI notification and cause OOPS.

https://bugzilla.redhat.com/show_bug.cgi?id=772730

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/ac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 6512b20..d1fcbc0 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -292,7 +292,9 @@ static int acpi_ac_add(struct acpi_device *device)
 	ac->charger.properties = ac_props;
 	ac->charger.num_properties = ARRAY_SIZE(ac_props);
 	ac->charger.get_property = get_ac_property;
-	power_supply_register(&ac->device->dev, &ac->charger);
+	result = power_supply_register(&ac->device->dev, &ac->charger);
+	if (result)
+		goto end;
 
 	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
-- 
1.7.12.rc0

