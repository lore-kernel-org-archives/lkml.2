Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0LLKzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 05:55:54 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49030 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0LLKzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 05:55:53 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6194"; a="66293208"
From: Saravana Kannan <skannan@codeaurora.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-arm-msm@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Call into regulator driver only when voltage min/max really changes.
Date: Sun, 12 Dec 2010 02:55:40 -0800
Message-Id: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even in cases where the consumer driver calls the regulator core with
different voltage min/max values, the application of the various
voltage constraints could result in the min/max voltage values passed
to the regulator driver to be unchanged since the previous invocation.

Optimize these cases by not calling into the regulator driver and not
sending incorrect/unnecessary voltage change notifications.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/regulator/core.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ba521f0..c2e67bb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1640,12 +1640,18 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
-	regulator->min_uV = min_uV;
-	regulator->max_uV = max_uV;
+
+	if (regulator->min_uV == min_uV && regulator->max_uV == max_uV)
+		goto unlock;
 	ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV);
+	if (!ret) {
+		regulator->min_uV = min_uV;
+		regulator->max_uV = max_uV;
+	}
 
 out:
 	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
+unlock:
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
-- 
1.7.1.1
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
