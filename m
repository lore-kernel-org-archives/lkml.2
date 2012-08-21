Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2HUIHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:07:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26543 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2HUIGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:06:41 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-0e-50334183bdd7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/5] charger-manager: Disable battery charging when charger
 cable is detached
Date: Tue, 21 Aug 2012 17:06:38 +0900
Message-id: <1345536398-25812-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAd1mR+MAg0XN/BaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj6403bAUTeSse/7vC1MB4i6uLkYNDQsBEomttQhcjJ5ApJnHh
	3nq2LkYuDiGBRYwS69ZOY4JwljJJTF77mwmkik1AS2L/ixtsILaIgJzE67V/wYqYBU4xSjy6
	eIIZJCEsEC/RvXMDmM0ioCpx5ckXsAZeAVeJnnMnmSHWKUi0LjvEPoGRewEjwypG0dSC5ILi
	pPRcI73ixNzi0rx0veT83E2MYB8+k97BuKrB4hCjAAejEg/vj0VGAUKsiWXFlbmHGCU4mJVE
	eKv1jQOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8/L3GQYICaQnlqRmp6YWpBbBZJk4OKUaGGe+
	sJaoPT45Lviv1f/nMVGC5h2zrj5J45HXEnhcut51wb2Cwo/Or9tdQ+sP7Ix7IC1tZ3Ey8uTp
	CQ7ffy16Xyxms/PKhAP6n2d3CKQfa7u3QtTq4/xjys12Z//+3mq56vvkU4F2x3dZ+u5U8TyS
	s6+y7apU/3U+OTXjlObZb/9Kfw44M4FX6awSS3FGoqEWc1FxIgDU1fJa3QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disable before stop chargint forcibly when charger cable
is detached and check return value of regulator_enable/disable() fucntion
to confirm correct opertion of enabling/disabling charger(regulator).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 526e5c9..f968301 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -271,9 +271,26 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 	if (enable) {
 		if (cm->emergency_stop)
 			return -EAGAIN;
-		for (i = 0 ; i < desc->num_charger_regulators ; i++)
-			regulator_enable(desc->charger_regulators[i].consumer);
+		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+			err = regulator_enable(
+				desc->charger_regulators[i].consumer);
+			if (err < 0) {
+				dev_warn(cm->dev,
+				"Cannot enable %s regulator\n",
+				desc->charger_regulators[i].regulator_name);
+			}
+		}
 	} else {
+		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
+			err = regulator_disable(
+				desc->charger_regulators[i].consumer);
+			if (err < 0) {
+				dev_warn(cm->dev,
+				"Cannot disable %s regulator\n",
+				desc->charger_regulators[i].regulator_name);
+			}
+		}
+
 		/*
 		 * Abnormal battery state - Stop charging forcibly,
 		 * even if charger was enabled at the other places
-- 
1.7.0.4

