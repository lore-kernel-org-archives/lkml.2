Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2DJPID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:08:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49860 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758937Ab2DJPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:08:01 -0400
Message-ID: <1334070472.18312.4.camel@phoenix>
Subject: [PATCH] regulator: twl-regulator: Fix off-by-one vsel setting in
 twl6030smps_set_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 23:07:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 268a1 "regulator: twl-regulator: Use DIV_ROUND_UP at appropriate places"
introduced an off-by-one bug for setting vsel.

The linear calculation code in twl6030smps_list_voltage() does subtract index
by 1 so we need the vsel++ after DIV_ROUND_UP.

The original code use this trick to differentiate if we are going to set the
voltage to 0 or the voltage falls within the linear calculation range.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 7384d27..68d9a7b 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -788,6 +788,7 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		else if ((min_uV >= 600000) && (min_uV <= 1300000)) {
 			int calc_uV;
 			vsel = DIV_ROUND_UP(min_uV - 600000, 12500);
+			vsel++;
 			calc_uV = twl6030smps_list_voltage(rdev, vsel);
 			if (calc_uV > max_uV)
 				return -EINVAL;
@@ -814,6 +815,7 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		else if ((min_uV >= 700000) && (min_uV <= 1420000)) {
 			int calc_uV;
 			vsel = DIV_ROUND_UP(min_uV - 700000, 12500);
+			vsel++;
 			calc_uV = twl6030smps_list_voltage(rdev, vsel);
 			if (calc_uV > max_uV)
 				return -EINVAL;
@@ -835,16 +837,20 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 			return -EINVAL;
 		break;
 	case SMPS_EXTENDED_EN:
-		if (min_uV == 0)
+		if (min_uV == 0) {
 			vsel = 0;
-		else if ((min_uV >= 1852000) && (max_uV <= 4013600))
+		} else if ((min_uV >= 1852000) && (max_uV <= 4013600)) {
 			vsel = DIV_ROUND_UP(min_uV - 1852000, 38600);
+			vsel++;
+		}
 		break;
 	case SMPS_OFFSET_EN|SMPS_EXTENDED_EN:
-		if (min_uV == 0)
+		if (min_uV == 0) {
 			vsel = 0;
-		else if ((min_uV >= 2161000) && (max_uV <= 4321000))
+		} else if ((min_uV >= 2161000) && (max_uV <= 4321000)) {
 			vsel = DIV_ROUND_UP(min_uV - 2161000, 38600);
+			vsel++;
+		}
 		break;
 	}
 
-- 
1.7.5.4



