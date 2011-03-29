Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1C2V3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:29:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56155 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754025Ab1C2V3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:29:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        David Collins <collinsd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: When constraining modes fall back to higher power modes
Date: Wed, 30 Mar 2011 06:29:12 +0900
Message-Id: <1301434152-16393-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a mode requested by a consumer is not allowed by constraints
automatically fall back to a higher power mode if possible. This
ensures that consumers get at least the output they requested while
allowing machine drivers to transparently limit lower power modes
if required.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

I've not actually had a chance to test this but throwing it out there
for comment and testing now; someone with an OMAP board can probably
test fairly quickly as the OMAP HSMMC driver is using set_mode().

 drivers/regulator/core.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3ffc697..a634946 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -197,9 +197,9 @@ static int regulator_check_current_limit(struct regulator_dev *rdev,
 }
 
 /* operating mode constraint check */
-static int regulator_check_mode(struct regulator_dev *rdev, int mode)
+static int regulator_mode_constrain(struct regulator_dev *rdev, int *mode)
 {
-	switch (mode) {
+	switch (*mode) {
 	case REGULATOR_MODE_FAST:
 	case REGULATOR_MODE_NORMAL:
 	case REGULATOR_MODE_IDLE:
@@ -217,11 +217,17 @@ static int regulator_check_mode(struct regulator_dev *rdev, int mode)
 		rdev_err(rdev, "operation not allowed\n");
 		return -EPERM;
 	}
-	if (!(rdev->constraints->valid_modes_mask & mode)) {
-		rdev_err(rdev, "invalid mode %x\n", mode);
-		return -EINVAL;
+
+	/* The modes are bitmasks, the most power hungry modes having
+	 * the lowest values. If the requested mode isn't supported
+	 * try higher modes. */
+	while (*mode) {
+		if (rdev->constraints->valid_modes_mask & *mode)
+			return 0;
+		*mode /= 2;
 	}
-	return 0;
+
+	return -EINVAL;
 }
 
 /* dynamic regulator mode switching constraint check */
@@ -612,7 +618,7 @@ static void drms_uA_update(struct regulator_dev *rdev)
 						  output_uV, current_uA);
 
 	/* check the new mode is allowed */
-	err = regulator_check_mode(rdev, mode);
+	err = regulator_mode_constrain(rdev, &mode);
 	if (err == 0)
 		rdev->desc->ops->set_mode(rdev, mode);
 }
@@ -2005,7 +2011,7 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
 	}
 
 	/* constraints check */
-	ret = regulator_check_mode(rdev, mode);
+	ret = regulator_mode_constrain(rdev, mode);
 	if (ret < 0)
 		goto out;
 
@@ -2116,7 +2122,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	mode = rdev->desc->ops->get_optimum_mode(rdev,
 						 input_uV, output_uV,
 						 total_uA_load);
-	ret = regulator_check_mode(rdev, mode);
+	ret = regulator_mode_constrain(rdev, &mode);
 	if (ret < 0) {
 		rdev_err(rdev, "failed to get optimum mode @ %d uA %d -> %d uV\n",
 			 total_uA_load, input_uV, output_uV);
-- 
1.7.4.1

