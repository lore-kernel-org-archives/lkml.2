Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab2CEM2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:28:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42459 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab2CEM2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:28:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.130.233 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330950476.3853.4.camel@phoenix>
Subject: [PATCH RFC/RFT] regulator: da9052: Ensure the selected voltage
 falls within the specified range
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 05 Mar 2012 20:27:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integer division may truncate the result, use DIV_ROUND_UP to ensure the
selected voltage falls within the specified range.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 0689ad4..5e8813f 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -226,7 +226,7 @@ static int da9052_regulator_set_voltage_int(struct regulator_dev *rdev,
 	if (min_uV < info->min_uV)
 		min_uV = info->min_uV;
 
-	*selector = (min_uV - info->min_uV) / info->step_uV;
+	*selector = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
 
 	ret = da9052_list_voltage(rdev, *selector);
 	if (ret < 0)
@@ -318,10 +318,10 @@ static int da9052_set_buckperi_voltage(struct regulator_dev *rdev, int min_uV,
 	if ((regulator->da9052->chip_id == DA9052) &&
 	    (min_uV >= DA9052_CONST_3uV))
 		*selector = DA9052_BUCK_PERI_REG_MAP_UPTO_3uV +
-			    ((min_uV - DA9052_CONST_3uV) /
-			    (DA9052_BUCK_PERI_3uV_STEP));
+			    DIV_ROUND_UP(min_uV - DA9052_CONST_3uV,
+					 DA9052_BUCK_PERI_3uV_STEP);
 	else
-		*selector = (min_uV - info->min_uV) / info->step_uV;
+		*selector = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
 
 	ret = da9052_list_buckperi_voltage(rdev, *selector);
 	if (ret < 0)
-- 
1.7.5.4



