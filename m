Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1BVGm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:42:58 -0500
Received: from smtp-out-090.synserver.de ([212.40.185.90]:1055 "EHLO
	smtp-out-090.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1BVGmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:42:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 18504
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Pali Rohar <pali.rohar@gmail.com>, Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 13/16] bq27x00: Give more specific reports on battery status
Date: Tue, 22 Feb 2011 07:37:58 +0100
Message-Id: <1298356681-8317-14-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298356681-8317-1-git-send-email-lars@metafoo.de>
References: <1298356681-8317-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code only reports whether the battery is charging or
discharging. But the battery also reports whether it is fully charged,
furthermore by look at if the battery is supplied we can tell whether it
is discharging or not charging.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Tested-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 0e99d02..003be5f 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -54,6 +54,7 @@
 #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
 #define BQ27000_REG_ILMD		0x76 /* Initial last measured discharge */
 #define BQ27000_FLAG_CHGS		BIT(7)
+#define BQ27000_FLAG_FC			BIT(5)
 
 #define BQ27500_REG_SOC			0x2c
 #define BQ27500_REG_DCAP		0x3C /* Design capacity */
@@ -365,8 +366,12 @@ static int bq27x00_battery_status(struct bq27x00_device_info *di,
 		else
 			status = POWER_SUPPLY_STATUS_CHARGING;
 	} else {
-		if (di->cache.flags & BQ27000_FLAG_CHGS)
+		if (di->cache.flags & BQ27000_FLAG_FC)
+			status = POWER_SUPPLY_STATUS_FULL;
+		else if (di->cache.flags & BQ27000_FLAG_CHGS)
 			status = POWER_SUPPLY_STATUS_CHARGING;
+		else if (power_supply_am_i_supplied(&di->bat))
+			status = POWER_SUPPLY_STATUS_NOT_CHARGING;
 		else
 			status = POWER_SUPPLY_STATUS_DISCHARGING;
 	}
-- 
1.7.2.3

