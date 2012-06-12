Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2FLIfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:35:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2FLIfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:35:04 -0400
Message-ID: <1339490095.6743.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: wm8400: Use wm8400_ldo_list_voltage instead
 of open code to verify selected voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 12 Jun 2012 16:34:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call wm8400_ldo_list_voltage() instead of open code to verify selected voltage
falls within specified range.
Use wm8400_ldo_list_voltage() here is less error prone.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8400-regulator.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index f365795..9f9df8e 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -35,27 +35,19 @@ static int wm8400_ldo_map_voltage(struct regulator_dev *dev,
 				  int min_uV, int max_uV)
 {
 	u16 val;
+	int volt;
 
 	if (min_uV < 900000 || min_uV > 3300000)
 		return -EINVAL;
 
-	if (min_uV < 1700000) {
-		/* Steps of 50mV from 900mV;  */
+	if (min_uV < 1700000) /* Steps of 50mV from 900mV;  */
 		val = DIV_ROUND_UP(min_uV - 900000, 50000);
+	else /* Steps of 100mV from 1700mV */
+		val = DIV_ROUND_UP(min_uV - 1700000, 100000) + 15;
 
-		if ((val * 50000) + 900000 > max_uV)
-			return -EINVAL;
-		BUG_ON((val * 50000) + 900000 < min_uV);
-	} else {
-		/* Steps of 100mV from 1700mV */
-		val = DIV_ROUND_UP(min_uV - 1700000, 100000);
-
-		if ((val * 100000) + 1700000 > max_uV)
-			return -EINVAL;
-		BUG_ON((val * 100000) + 1700000 < min_uV);
-
-		val += 0xf;
-	}
+	volt = wm8400_ldo_list_voltage(dev, val);
+	if (volt < min_uV || volt > max_uV)
+		return -EINVAL;
 
 	return val;
 }
-- 
1.7.9.5



