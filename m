Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2CZBVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:21:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2CZBVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:21:08 -0400
Message-ID: <1332724858.7078.1.camel@phoenix>
Subject: [PATCH] regulator: Convert max8952 to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Mon, 26 Mar 2012 09:20:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index e9c0a0e..c35236a 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -130,11 +130,10 @@ static int max8952_get_voltage(struct regulator_dev *rdev)
 	return max8952_voltage(max8952, vid);
 }
 
-static int max8952_set_voltage(struct regulator_dev *rdev,
-			       int min_uV, int max_uV, unsigned *selector)
+static int max8952_set_voltage_sel(struct regulator_dev *rdev,
+				   unsigned selector)
 {
 	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-	s8 vid = -1, i;
 
 	if (!gpio_is_valid(max8952->pdata->gpio_vid0) ||
 			!gpio_is_valid(max8952->pdata->gpio_vid1)) {
@@ -142,23 +141,10 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
 		return -EPERM;
 	}
 
-	for (i = 0; i < MAX8952_NUM_DVS_MODE; i++) {
-		int volt = max8952_voltage(max8952, i);
-
-		/* Set the voltage as low as possible within the range */
-		if (volt <= max_uV && volt >= min_uV)
-			if (vid == -1 || max8952_voltage(max8952, vid) > volt)
-				vid = i;
-	}
-
-	if (vid >= 0 && vid < MAX8952_NUM_DVS_MODE) {
-		max8952->vid0 = vid & 0x1;
-		max8952->vid1 = (vid >> 1) & 0x1;
-		*selector = vid;
-		gpio_set_value(max8952->pdata->gpio_vid0, max8952->vid0);
-		gpio_set_value(max8952->pdata->gpio_vid1, max8952->vid1);
-	} else
-		return -EINVAL;
+	max8952->vid0 = selector & 0x1;
+	max8952->vid1 = (selector >> 1) & 0x1;
+	gpio_set_value(max8952->pdata->gpio_vid0, max8952->vid0);
+	gpio_set_value(max8952->pdata->gpio_vid1, max8952->vid1);
 
 	return 0;
 }
@@ -169,7 +155,7 @@ static struct regulator_ops max8952_ops = {
 	.enable			= max8952_enable,
 	.disable		= max8952_disable,
 	.get_voltage		= max8952_get_voltage,
-	.set_voltage		= max8952_set_voltage,
+	.set_voltage_sel	= max8952_set_voltage_sel,
 	.set_suspend_disable	= max8952_disable,
 };
 
-- 
1.7.5.4



