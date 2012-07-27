Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2G0FCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 01:02:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40852 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab2G0FBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 01:01:54 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-70-501220af0a1a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/2] charger-manager: Disable regulator for charging when
 charger cable is detached
Date: Fri, 27 Jul 2012 14:01:34 +0900
Message-id: <1343365294-3496-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd31CkIBBj+uyFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MY7u2sBcc5q048OwzawNjB3cXIyeHhICJxOp7x9ghbDGJC/fW
	s3UxcnEICUxnlDjadJQFwlnKJHHzdhMzSBWbgJbE/hc32EBsEQE5iddr/zKBFDELnGKUeHTx
	BFiRsECqxOnDF4G6OThYBFQl+g8HgIR5BVwkPn59wAqxTUGiddkh9gmM3AsYGVYxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBPvwmfQOxlUNFocYBTgYlXh4Z4gIBQixJpYVV+YeYpTgYFYS
	4X3OBxTiTUmsrEotyo8vKs1JLT7EKM3BoiTOa+L91V9IID2xJDU7NbUgtQgmy8TBKdXAmF6j
	/v+Sbxu3+ebp35Klpq3kvTPPQ6/2TcrOB/O+FrG1XtBf5/As7fnkrhMmrw/yfhf7OsNr3z+G
	Fx8+fFi4adcyr+DZq28pXOf4Oft1UMXusLDbr28rbVn0UeDxr0vdJXemr26qj2xZqX6UhX9p
	2J5PxjN/5Zcuf//RLlq4/C/jqcU7zkhpNSYrsRRnJBpqMRcVJwIA20zzVt0BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disable regulator for charging when charger cable is detached
before stopping charging forcibly on abnormal battery state and check
return value of regulator_enable/disable() function to confirm correct
operation of enabling or disabling regulator for charging.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 526e5c9..240de49 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -271,9 +271,24 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 	if (enable) {
 		if (cm->emergency_stop)
 			return -EAGAIN;
-		for (i = 0 ; i < desc->num_charger_regulators ; i++)
-			regulator_enable(desc->charger_regulators[i].consumer);
+		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+			err = regulator_enable(desc->charger_regulators[i].consumer);
+			if (err < 0) {
+				dev_warn(cm->dev,
+					"Cannot enable %s regulator\n",
+					desc->charger_regulators[i].regulator_name);
+			}
+		}
 	} else {
+		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+			err = regulator_disable(desc->charger_regulators[i].consumer);
+			if (err < 0) {
+				dev_warn(cm->dev,
+					"Cannot disable %s regulator\n",
+					desc->charger_regulators[i].regulator_name);
+			}
+		}
+
 		/*
 		 * Abnormal battery state - Stop charging forcibly,
 		 * even if charger was enabled at the other places
-- 
1.7.0.4

