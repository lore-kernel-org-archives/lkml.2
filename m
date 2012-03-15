Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab2COAr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:47:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35103 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965202Ab2COAr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:47:56 -0400
Message-ID: <1331772468.2981.1.camel@phoenix>
Subject: [PATCH] regulator: max8952: Simplify the logic to get vid[0|1]
 status
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Thu, 15 Mar 2012 08:47:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syntax "(((vid >> 1) % 2) == 1)" is inefficient and also hard to read.
Use bitwidse AND operator instead.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 75d8940..e9c0a0e 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -152,8 +152,8 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
 	}
 
 	if (vid >= 0 && vid < MAX8952_NUM_DVS_MODE) {
-		max8952->vid0 = (vid % 2 == 1);
-		max8952->vid1 = (((vid >> 1) % 2) == 1);
+		max8952->vid0 = vid & 0x1;
+		max8952->vid1 = (vid >> 1) & 0x1;
 		*selector = vid;
 		gpio_set_value(max8952->pdata->gpio_vid0, max8952->vid0);
 		gpio_set_value(max8952->pdata->gpio_vid1, max8952->vid1);
@@ -217,8 +217,8 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 	}
 
 	max8952->en = !!(pdata->reg_data.constraints.boot_on);
-	max8952->vid0 = (pdata->default_mode % 2) == 1;
-	max8952->vid1 = ((pdata->default_mode >> 1) % 2) == 1;
+	max8952->vid0 = pdata->default_mode & 0x1;
+	max8952->vid1 = (pdata->default_mode >> 1) & 0x1;
 
 	if (gpio_is_valid(pdata->gpio_en)) {
 		if (!gpio_request(pdata->gpio_en, "MAX8952 EN"))
@@ -241,13 +241,13 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 			gpio_is_valid(pdata->gpio_vid1)) {
 		if (!gpio_request(pdata->gpio_vid0, "MAX8952 VID0"))
 			gpio_direction_output(pdata->gpio_vid0,
-					(pdata->default_mode) % 2);
+					(pdata->default_mode) & 0x1);
 		else
 			err = 1;
 
 		if (!gpio_request(pdata->gpio_vid1, "MAX8952 VID1"))
 			gpio_direction_output(pdata->gpio_vid1,
-				(pdata->default_mode >> 1) % 2);
+				(pdata->default_mode >> 1) & 0x1);
 		else {
 			if (!err)
 				gpio_free(pdata->gpio_vid0);
-- 
1.7.5.4



