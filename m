Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1LISLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:11:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48025 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1LISK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:10:58 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        Bruce Robertson <bruce.e.robertson@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH v2 5/6] max17042: Fix value scaling for VCELL and avgVCELL
Date: Fri,  9 Dec 2011 10:08:48 -0800
Message-Id: <1323454129-7444-7-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323454129-7444-1-git-send-email-dirk.brandewie@gmail.com>
References: <1323454129-7444-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Robertson <bruce.e.robertson@intel.com>

The bottom three bits of the register are don't care bits.  The LSB
value is 625 uV.  Adjust the returned values appropriately

Signed-off-by: Bruce Robertson <bruce.e.robertson@intel.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/power/max17042_battery.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 001eca1..80a6ee7 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -148,11 +148,15 @@ static int max17042_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 		val->intval = max17042_read_reg(chip->client,
-				MAX17042_VCELL) * 83; /* 1000 / 12 = 83 */
+				MAX17042_VCELL);
+		val->intval >>= 3;
+		val->intval *= 625; /* Units of LSB = 625 uV */
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
 		val->intval = max17042_read_reg(chip->client,
-				MAX17042_AvgVCELL) * 83;
+				MAX17042_AvgVCELL);
+		val->intval >>= 3;
+		val->intval *= 625; /* Units of LSB = 625 uV */
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		val->intval = max17042_read_reg(chip->client,
-- 
1.7.7.3

