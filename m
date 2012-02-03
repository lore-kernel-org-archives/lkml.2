Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2BCH0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:26:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4562 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab2BCH0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:26:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 02 Feb 2012 23:26:04 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V1] regulator: twl6030: Fix voltage selection logic
Date: Fri,  3 Feb 2012 12:54:38 +0530
Message-Id: <1328253878-12609-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage selection logic for the twl6030 smps fails if
min:max is such that min < 1300mV and max > 1300mV although
this is in valid range for a regulator e.g. [x, 1350] where
x < 1300.
Fixing the voltage selection logic such that first it will
check for min_uV for a range and then calculated value will
be checked against max_uV.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/twl-regulator.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 181a2cf..e5d2223 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -755,12 +755,16 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 	case 0:
 		if (min_uV == 0)
 			vsel = 0;
-		else if ((min_uV >= 600000) && (max_uV <= 1300000)) {
+		else if ((min_uV >= 600000) && (min_uV <= 1300000)) {
+			int calc_uV;
 			vsel = (min_uV - 600000) / 125;
 			if (vsel % 100)
 				vsel += 100;
 			vsel /= 100;
 			vsel++;
+			calc_uV = twl6030smps_list_voltage(rdev, vsel);
+			if (calc_uV > max_uV)
+				return -EINVAL;
 		}
 		/* Values 1..57 for vsel are linear and can be calculated
 		 * values 58..62 are non linear.
@@ -781,12 +785,16 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 	case SMPS_OFFSET_EN:
 		if (min_uV == 0)
 			vsel = 0;
-		else if ((min_uV >= 700000) && (max_uV <= 1420000)) {
+		else if ((min_uV >= 700000) && (min_uV <= 1420000)) {
+			int calc_uV;
 			vsel = (min_uV - 700000) / 125;
 			if (vsel % 100)
 				vsel += 100;
 			vsel /= 100;
 			vsel++;
+			calc_uV = twl6030smps_list_voltage(rdev, vsel);
+			if (calc_uV > max_uV)
+				return -EINVAL;
 		}
 		/* Values 1..57 for vsel are linear and can be calculated
 		 * values 58..62 are non linear.
@@ -819,7 +827,7 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		if (min_uV == 0)
 			vsel = 0;
 		else if ((min_uV >= 2161000) && (max_uV <= 4321000)) {
-			vsel = (min_uV - 1852000) / 386;
+			vsel = (min_uV - 2161000) / 386;
 			if (vsel % 100)
 				vsel += 100;
 			vsel /= 100;
-- 
1.7.1.1

