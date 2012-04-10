Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2DJA2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:28:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55302 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2DJA2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:28:51 -0400
Message-ID: <1334017721.2862.1.camel@phoenix>
Subject: [PATCH v3] regulator: twl-regulator: Use DIV_ROUND_UP at
 appropriate places
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 08:28:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_UP ensures we set the voltage falls within the specified range.
Current code may set the voltage lower than the specified range.

For example:

vsel = (min_uV - 600000) / 125;
if (vsel % 100)
        vsel += 100;
vsel /= 100;
vsel++

In the case min_uV is 712599 uV, the vsel will be 10.  Then current code set
the voltage to 712500 uV which is lower than the specified range.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v3: Fix off-by-one for vsel, the vsel++ after DIV_ROUND_UP is required because
    current code does subtract index by 1 in the list_voltage callback.
v2: Remove braces {} for single statement blocks

 drivers/regulator/twl-regulator.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 964946f..5d19b42 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -806,10 +806,7 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 			vsel = 0;
 		else if ((min_uV >= 600000) && (min_uV <= 1300000)) {
 			int calc_uV;
-			vsel = (min_uV - 600000) / 125;
-			if (vsel % 100)
-				vsel += 100;
-			vsel /= 100;
+			vsel = DIV_ROUND_UP(min_uV - 600000, 12500);
 			vsel++;
 			calc_uV = twl6030smps_list_voltage(rdev, vsel);
 			if (calc_uV > max_uV)
@@ -836,10 +833,7 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 			vsel = 0;
 		else if ((min_uV >= 700000) && (min_uV <= 1420000)) {
 			int calc_uV;
-			vsel = (min_uV - 700000) / 125;
-			if (vsel % 100)
-				vsel += 100;
-			vsel /= 100;
+			vsel = DIV_ROUND_UP(min_uV - 700000, 12500);
 			vsel++;
 			calc_uV = twl6030smps_list_voltage(rdev, vsel);
 			if (calc_uV > max_uV)
@@ -865,10 +859,7 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		if (min_uV == 0)
 			vsel = 0;
 		else if ((min_uV >= 1852000) && (max_uV <= 4013600)) {
-			vsel = (min_uV - 1852000) / 386;
-			if (vsel % 100)
-				vsel += 100;
-			vsel /= 100;
+			vsel = DIV_ROUND_UP(min_uV - 1852000, 38600);
 			vsel++;
 		}
 		break;
@@ -876,10 +867,7 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		if (min_uV == 0)
 			vsel = 0;
 		else if ((min_uV >= 2161000) && (max_uV <= 4321000)) {
-			vsel = (min_uV - 2161000) / 386;
-			if (vsel % 100)
-				vsel += 100;
-			vsel /= 100;
+			vsel = DIV_ROUND_UP(min_uV - 2161000, 38600);
 			vsel++;
 		}
 		break;
-- 
1.7.5.4



