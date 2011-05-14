Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab1ENSTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 14:19:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58975 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751881Ab1ENSTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 14:19:44 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        David Collins <collinsd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: If we can't configure optimum mode we're always in the best one
Date: Sat, 14 May 2011 11:19:45 -0700
Message-Id: <1305397185-22024-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If either a regulator driver can't tell us what the optimum mode is (or
doesn't have modes in the first place) or the system doesn't allow DRMS
changes then it's more helpful for users to just say that we're in the
optimal mode, even if it's from a selection of one.

Still report errors if the process of picking and setting a mode changes as
this may indicate that we're stuck in a low power mode and unable to deliver
a higher current that the consumer just asked for.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 9f18131..051a45d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2078,16 +2078,26 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 
 	mutex_lock(&rdev->mutex);
 
+	/*
+	 * first check to see if we can set modes at all, otherwise just
+	 * tell the consumer everything is OK.
+	 */
 	regulator->uA_load = uA_load;
 	ret = regulator_check_drms(rdev);
-	if (ret < 0)
+	if (ret < 0) {
+		ret = 0;
 		goto out;
-	ret = -EINVAL;
+	}
 
-	/* sanity check */
 	if (!rdev->desc->ops->get_optimum_mode)
 		goto out;
 
+	/*
+	 * we can actually do this so any errors are indicators of
+	 * potential real failure.
+	 */
+	ret = -EINVAL;
+
 	/* get output voltage */
 	output_uV = _regulator_get_voltage(rdev);
 	if (output_uV <= 0) {
-- 
1.7.5.1

