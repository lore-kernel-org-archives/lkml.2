Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2GQD3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:29:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64161 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GQD3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:29:13 -0400
Message-ID: <1342495743.16433.1.camel@phoenix>
Subject: [PATCH RFT] regulator: palmas: Fix calcuating selector in
 palmas_map_voltage_smps
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 17 Jul 2012 11:29:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic of calculating selector in palmas_map_voltage_smps() does not match
the logic to list voltage in palmas_list_voltage_smps().

We use below equation to calculate voltage when selector > 0:
        voltage = (0.49V + (selector * 0.01V)) * RANGE
RANGE is either x1 or x2

So we need to take into account with the multiplier set in VSEL register when
calculating selector in palmas_map_voltage_smps()

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/palmas-regulator.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 7540c95..17d19fb 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -373,11 +373,22 @@ static int palmas_set_voltage_smps_sel(struct regulator_dev *dev,
 static int palmas_map_voltage_smps(struct regulator_dev *rdev,
 		int min_uV, int max_uV)
 {
+	struct palmas_pmic *pmic = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
 	int ret, voltage;
 
-	ret = ((min_uV - 500000) / 10000) + 1;
-	if (ret < 0)
-		return ret;
+	if (min_uV == 0)
+		return 0;
+
+	if (pmic->range[id]) { /* RANGE is x2 */
+		if (min_uV < 1000000)
+			min_uV = 1000000;
+		ret = DIV_ROUND_UP(min_uV - 1000000, 20000) + 1;
+	} else {		/* RANGE is x1 */
+		if (min_uV < 500000)
+			min_uV = 500000;
+		ret = DIV_ROUND_UP(min_uV - 500000, 10000) + 1;
+	}
 
 	/* Map back into a voltage to verify we're still in bounds */
 	voltage = palmas_list_voltage_smps(rdev, ret);
-- 
1.7.9.5



