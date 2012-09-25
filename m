Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab2IYQRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:17:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab2IYQOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:09 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 45/57] power: ab8500: defer btemp filtering while init
Date: Tue, 25 Sep 2012 10:12:42 -0600
Message-Id: <1348589574-25655-46-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rupesh Kumar <rupesh.kumar@stericsson.com>

Due to btemp filtering enabled during init, temp values
reported to charge algorithm driver started from 0.
As a result,charge algorithm was going into wrong
state and charging was stopped.
This patch defers btemp filtering till init is done.

Signed-off-by: Rupesh Kumar <rupesh.kumar@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Martin SJOBLOM <martin.w.sjoblom@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/power/ab8500_btemp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index b24835f..1f33122 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -613,7 +613,6 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
 		struct ab8500_btemp, btemp_periodic_work.work);
 
 	if (!di->initialized) {
-		di->initialized = true;
 		/* Identify the battery */
 		if (ab8500_btemp_id(di) < 0)
 			dev_warn(di->dev, "failed to identify the battery\n");
@@ -626,8 +625,9 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
 	 * same temperature. Else only allow 1 degree change from previous
 	 * reported value in the direction of the new measurement.
 	 */
-	if (bat_temp == di->prev_bat_temp || !di->initialized) {
-		if (di->bat_temp != di->prev_bat_temp || !di->initialized) {
+	if ((bat_temp == di->prev_bat_temp) || !di->initialized) {
+		if ((di->bat_temp != di->prev_bat_temp) || !di->initialized) {
+			di->initialized = true;
 			di->bat_temp = bat_temp;
 			power_supply_changed(&di->btemp_psy);
 		}
-- 
1.7.5.4

