Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0LJR2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:28:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55345 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752499Ab0LJR2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:28:11 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regulator: Use _regulator_get_voltage() consistently
Date: Fri, 10 Dec 2010 17:28:06 +0000
Message-Id: <1292002088-9644-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than referencing the get_voltage() operation directly in the
ops struct use the internal _regulator_get_voltage() API call to do
so, facilitating refactoring.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5d07e5d..671eb53 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -581,14 +581,15 @@ static void drms_uA_update(struct regulator_dev *rdev)
 		return;
 
 	/* get output voltage */
-	output_uV = rdev->desc->ops->get_voltage(rdev);
+	output_uV = _regulator_get_voltage(rdev);
 	if (output_uV <= 0)
 		return;
 
 	/* get input voltage */
-	if (rdev->supply && rdev->supply->desc->ops->get_voltage)
-		input_uV = rdev->supply->desc->ops->get_voltage(rdev->supply);
-	else
+	input_uV = 0;
+	if (rdev->supply)
+		input_uV = _regulator_get_voltage(rdev);
+	if (input_uV <= 0)
 		input_uV = rdev->constraints->input_uV;
 	if (input_uV <= 0)
 		return;
@@ -1908,16 +1909,17 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 		goto out;
 
 	/* get output voltage */
-	output_uV = rdev->desc->ops->get_voltage(rdev);
+	output_uV = _regulator_get_voltage(rdev);
 	if (output_uV <= 0) {
 		rdev_err(rdev, "invalid output voltage found\n");
 		goto out;
 	}
 
 	/* get input voltage */
-	if (rdev->supply && rdev->supply->desc->ops->get_voltage)
-		input_uV = rdev->supply->desc->ops->get_voltage(rdev->supply);
-	else
+	input_uV = 0;
+	if (rdev->supply)
+		input_uV = _regulator_get_voltage(rdev->supply);
+	if (input_uV <= 0)
 		input_uV = rdev->constraints->input_uV;
 	if (input_uV <= 0) {
 		rdev_err(rdev, "invalid input voltage found\n");
-- 
1.7.1

