Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2KVTym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:54:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32922 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab2KVTyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:54:37 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-de-50add7e207e9
From: y@samsung.com
To: anton.vorontsov@linaro.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/3] charger-manager: Fix bug when check dropped voltage after
 fullbatt event
Date: Thu, 22 Nov 2012 16:44:24 +0900
Message-id: <1353570264-18990-1-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <y@samsung.com>
References: <y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJMWRmVeSWpSXmKPExsVy+t9jAd3H19cGGDwvtLi8aw6bA6PH501y
	AYxRXDYpqTmZZalF+nYJXBl3Lh5jLbjGXdHzvq6B8S5nFyMnh4SAicTVhnssELaYxIV769m6
	GLk4hAQWMUp8uvOJGcJZyiSxd/FN1i5GDg42AWGJqQe0QBpEBOQkXq/9ywRiMwvUSuy71sQK
	YgsLxEvsXnwYbCiLgKrEjs7r7CA2r4CtxMyLp6GWKUi0LjsEFucUkJGYM3sVmC0kIC1xv7uH
	ZQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwd5+JrWDcWWDxSFGAQ5GJR5eTee1
	AUKsiWXFlbmHGCU4mJVEeBcVAIV4UxIrq1KL8uOLSnNSiw8xSnOwKInzNnukBAgJpCeWpGan
	phakFsFkmTg4pRoYQ6wqGU03xVi7rOo7GDjZumCe+tKWS9tW1KnMruGfcUPvUfjE4n2v/Xbf
	zLg5YdndiQYFbBV2KR+svA/91XO9HsiZwbHkkF1oidTBEhPJFanTfnAqViouqLGIvnvrih/3
	TgPbb4L7ivNesIRKPZE/0HanyDPs4D5tQ75nnH5b22cJu5b0NPApsRRnJBpqMRcVJwIAm6G7
	WfIBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patch check difference value between current voltage of battery
and desc->fullbatt_uV whether positve or negative number. If difference
value is negative number when current voltage of battery is larger than
desc->fullbatt_uV, charger-manager return immediately because battery
is fully charged.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index ee039b9..17130c7 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -468,7 +468,9 @@ static void fullbatt_vchk(struct work_struct *work)
 	struct charger_manager *cm = container_of(dwork,
 			struct charger_manager, fullbatt_vchk_work);
 	struct charger_desc *desc = cm->desc;
-	int batt_uV, err, diff;
+	int batt_uV;
+	int err;
+	int diff;
 
 	/* remove the appointment for fullbatt_vchk */
 	cm->fullbatt_vchk_jiffies_at = 0;
@@ -482,8 +484,9 @@ static void fullbatt_vchk(struct work_struct *work)
 		return;
 	}
 
-	diff = desc->fullbatt_uV;
-	diff -= batt_uV;
+	diff = desc->fullbatt_uV - batt_uV;
+	if (diff < 0)
+		return;
 
 	dev_info(cm->dev, "VBATT dropped %duV after full-batt.\n", diff);
 
-- 
1.7.0.4

