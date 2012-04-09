Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab2DIEQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 00:16:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2DIEQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 00:16:36 -0400
From: Olof Johansson <olof@lixom.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] video: exynos: fix build warning and bad pointer deref in dp driver
Date: Sun,  8 Apr 2012 21:16:22 -0700
Message-Id: <1333944982-15859-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.2.359.gebfc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not 100% sure if the fix for 'adjust_request' is correct, since
it's uncertain what the original intent was. But it's so clearly an
uninitialized pointer dereference that my resolution seems to make sense.

drivers/video/exynos/exynos_dp_core.c: In function 'exynos_dp_set_link_train':
drivers/video/exynos/exynos_dp_core.c:521:21: warning: 'adjust_request' may be used uninitialized in this function [-Wuninitialized]
drivers/video/exynos/exynos_dp_core.c:481:6: note: 'adjust_request' was declared here
drivers/video/exynos/exynos_dp_core.c:529:18: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]
drivers/video/exynos/exynos_dp_core.c:395:6: note: 'reg' was declared here

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/video/exynos/exynos_dp_core.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index 2a4481c..8973e18 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -392,24 +392,19 @@ static unsigned int exynos_dp_get_lane_link_training(
 				struct exynos_dp_device *dp,
 				int lane)
 {
-	u32 reg;
-
 	switch (lane) {
 	case 0:
-		reg = exynos_dp_get_lane0_link_training(dp);
-		break;
+		return exynos_dp_get_lane0_link_training(dp);
 	case 1:
-		reg = exynos_dp_get_lane1_link_training(dp);
-		break;
+		return exynos_dp_get_lane1_link_training(dp);
 	case 2:
-		reg = exynos_dp_get_lane2_link_training(dp);
-		break;
+		return exynos_dp_get_lane2_link_training(dp);
 	case 3:
-		reg = exynos_dp_get_lane3_link_training(dp);
-		break;
+		return exynos_dp_get_lane3_link_training(dp);
 	}
 
-	return reg;
+	WARN_ON(1);
+	return 0;
 }
 
 static void exynos_dp_reduce_link_rate(struct exynos_dp_device *dp)
@@ -489,13 +484,13 @@ static int exynos_dp_process_clock_recovery(struct exynos_dp_device *dp)
 				6, link_status);
 	lane_count = dp->link_train.lane_count;
 
+	adjust_request = link_status + (DPCD_ADDR_ADJUST_REQUEST_LANE0_1
+					- DPCD_ADDR_LANE0_1_STATUS);
+
 	if (exynos_dp_clock_recovery_ok(link_status, lane_count) == 0) {
 		/* set training pattern 2 for EQ */
 		exynos_dp_set_training_pattern(dp, TRAINING_PTN2);
 
-		adjust_request = link_status + (DPCD_ADDR_ADJUST_REQUEST_LANE0_1
-						- DPCD_ADDR_LANE0_1_STATUS);
-
 		exynos_dp_get_adjust_train(dp, adjust_request);
 
 		buf[0] = DPCD_SCRAMBLING_DISABLED |
-- 
1.7.9.2.359.gebfc2

