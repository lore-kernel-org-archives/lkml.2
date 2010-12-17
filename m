Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0LQWoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:44:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22509 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab0LQWol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:44:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6200"; a="67297881"
From: Saravana Kannan <skannan@codeaurora.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-msm@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Update consumer state only after set voltage succeeds.
Date: Fri, 17 Dec 2010 14:44:28 -0800
Message-Id: <1292625868-26862-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the consumer state is updated but an error is returned due to
consumer constraint issues, then all set voltages by all consumers on
the regulator will fail till the "bad" consumer updates its voltage
range with a compatible value.  A bad consumer request that's rejected
shouldn't prevent other consumers from changing the voltage.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/regulator/core.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ab419f8..590ae0c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -148,11 +148,14 @@ static int regulator_check_voltage(struct regulator_dev *rdev,
  * regulator consumers
  */
 static int regulator_check_consumers(struct regulator_dev *rdev,
+				     struct regulator *ignore,
 				     int *min_uV, int *max_uV)
 {
 	struct regulator *regulator;
 
 	list_for_each_entry(regulator, &rdev->consumer_list, list) {
+		if (regulator  == ignore)
+			continue;
 		if (*max_uV > regulator->max_uV)
 			*max_uV = regulator->max_uV;
 		if (*min_uV < regulator->min_uV)
@@ -1719,14 +1722,15 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
-	regulator->min_uV = min_uV;
-	regulator->max_uV = max_uV;
-
-	ret = regulator_check_consumers(rdev, &min_uV, &max_uV);
+	ret = regulator_check_consumers(rdev, regulator, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
 
 	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
+	if (!ret) {
+		regulator->min_uV = min_uV;
+		regulator->max_uV = max_uV;
+	}
 
 out:
 	mutex_unlock(&rdev->mutex);
@@ -1769,7 +1773,7 @@ int regulator_sync_voltage(struct regulator *regulator)
 	if (ret < 0)
 		goto out;
 
-	ret = regulator_check_consumers(rdev, &min_uV, &max_uV);
+	ret = regulator_check_consumers(rdev, NULL, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
 
-- 
1.7.1.1
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
