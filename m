Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2HOTvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:36974 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843Ab2HOTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lan Tianyu <tianyu.lan@intel.com>, Len Brown <len.brown@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 108/165] ACPI/AC: prevent OOPS on some boxes due to missing check power_supply_register() return value check
Date: Wed, 15 Aug 2012 15:47:32 -0400
Message-ID: <1345060109-9187-109-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f197ac13f6eeb351b31250b9ab7d0da17434ea36 upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/acpi/ac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 56205a0..4ea5daf 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -288,7 +288,9 @@ static int acpi_ac_add(struct acpi_device *device)
 	ac->charger.properties = ac_props;
 	ac->charger.num_properties = ARRAY_SIZE(ac_props);
 	ac->charger.get_property = get_ac_property;
-	power_supply_register(&ac->device->dev, &ac->charger);
+	result = power_supply_register(&ac->device->dev, &ac->charger);
+	if (result)
+		goto end;
 #endif
 
 	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
-- 
1.7.12.rc2

