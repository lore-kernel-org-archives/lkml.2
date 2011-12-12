Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1LLSmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:42:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41109 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1LLSmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:42:07 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, Jason.Wortham@maxim-ic.com,
        bruce.e.robertson@intel.com, Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH v3 4/5] max17042: Fix value scaling for VCELL and avgVCELL
Date: Mon, 12 Dec 2011 10:39:32 -0800
Message-Id: <1323715173-26974-5-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323715173-26974-1-git-send-email-dirk.brandewie@gmail.com>
References: <1323715173-26974-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Robertson <bruce.e.robertson@intel.com>

The bottom three bits of the register are don't care bits.  The LSB
value is 625 uV.  Adjust the returned values appropriately

Signed-off-by: Bruce Robertson <bruce.e.robertson@intel.com>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/max17042_battery.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index ac17d36..6f11210 100644
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

