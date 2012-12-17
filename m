Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2LQXX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 18:23:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34925 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2LQXXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:23:54 -0500
From: Paolo Pisati <paolo.pisati@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Paolo Pisati <paolo.pisati@canonical.com>, stable@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] [stable-resend] regulator: core: if voltage scaling fails, restore original voltage values
Date: Tue, 18 Dec 2012 00:23:38 +0100
Message-Id: <1355786618-12691-1-git-send-email-paolo.pisati@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20121217154512.GI4985@opensource.wolfsonmicro.com>
References: <20121217154512.GI4985@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
Tested-by: Robert Nelson <robertcnelson@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e872c8b..c347fd0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2250,6 +2250,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 {
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret = 0;
+	int old_min_uV, old_max_uV;
 
 	mutex_lock(&rdev->mutex);
 
@@ -2271,18 +2272,29 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
+	
+	/* restore original values in case of error */
+	old_min_uV = regulator->min_uV;
+	old_max_uV = regulator->max_uV;
 	regulator->min_uV = min_uV;
 	regulator->max_uV = max_uV;
 
 	ret = regulator_check_consumers(rdev, &min_uV, &max_uV);
 	if (ret < 0)
-		goto out;
+		goto out2;
 
 	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
-
+	if (ret < 0)
+		goto out2;
+	
 out:
 	mutex_unlock(&rdev->mutex);
 	return ret;
+out2:
+	regulator->min_uV = old_min_uV;
+	regulator->max_uV = old_max_uV;
+	mutex_unlock(&rdev->mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_voltage);
 
-- 
1.7.10.4

