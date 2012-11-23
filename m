Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab2KWQx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:53:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62702 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2KWQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 11:53:28 -0500
Message-ID: <1353689602.3260.7.camel@phoenix>
Subject: [PATCH 2/2] regulator: as3711: Fix the logic in as3711_sel_check
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 24 Nov 2012 00:53:22 +0800
In-Reply-To: <1353689452.3260.4.camel@phoenix>
References: <1353689452.3260.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below equation means the "voltage" is the "smallest" voltage within specific
range.

ret = DIV_ROUND_UP(min - bottom) / step;
voltage = ret * step + bottom;

If we do try 1 down when (voltage > max), new voltage is then less than min
voltage. Which means the new voltage is not in the requested voltage range.

This patch also includes below cleanups:
- Use DIV_ROUND_UP
- rename variable 'ret' to 'sel' for better readability because as3711_sel_check
  returns the selector.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/as3711-regulator.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index 5e813b9..2f1341d 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -93,24 +93,17 @@ static int as3711_bound_check(struct regulator_dev *rdev,
 
 static int as3711_sel_check(int min, int max, int bottom, int step)
 {
-	int ret, voltage;
+	int sel, voltage;
 
 	/* Round up min, when dividing: keeps us within the range */
-	ret = (min - bottom + step - 1) / step;
-	voltage = ret * step + bottom;
+	sel = DIV_ROUND_UP(min - bottom, step);
+	voltage = sel * step + bottom;
 	pr_debug("%s(): select %d..%d in %d+N*%d: %d\n", __func__,
-	       min, max, bottom, step, ret);
-	if (voltage > max) {
-		/*
-		 * Try 1 down. It will take us below min, but as long we stay
-		 * above bottom, we're fine.
-		 */
-		ret--;
-		voltage = ret * step + bottom;
-		if (voltage < bottom)
-			return -EINVAL;
-	}
-	return ret;
+	       min, max, bottom, step, sel);
+	if (voltage > max)
+		return -EINVAL;
+
+	return sel;
 }
 
 static int as3711_map_voltage_sd(struct regulator_dev *rdev,
-- 
1.7.9.5



