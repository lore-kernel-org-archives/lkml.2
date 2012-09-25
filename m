Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab2IYQNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab2IYQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:37 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 21/57] power: Overflow in current calculation
Date: Tue, 25 Sep 2012 10:12:18 -0600
Message-Id: <1348589574-25655-22-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>

When calculating the average current the nominator will
overflow when the charging current is high.

Signed-off-by: Henrik Sölver <henrik.solver@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Par-Olof HAKANSSON <par-olof.hakansson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 46010ec..7c42150 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -805,15 +805,13 @@ static void ab8500_fg_acc_cur_work(struct work_struct *work)
 
 	/*
 	 * Convert to unit value in mA
-	 * Full scale input voltage is
-	 * 66.660mV => LSB = 66.660mV/(4096*res) = 1.627mA
-	 * Given a 250ms conversion cycle time the LSB corresponds
-	 * to 112.9 nAh. Convert to current by dividing by the conversion
+	 * by dividing by the conversion
 	 * time in hours (= samples / (3600 * 4)h)
-	 * 112.9nAh assumes 10mOhm, but fg_res is in 0.1mOhm
+	 * and multiply with 1000
 	 */
-	di->avg_curr = (val * QLSB_NANO_AMP_HOURS_X10 * 36) /
-		(1000 * di->bat->fg_res * (di->fg_samples / 4));
+
+	di->avg_curr = (di->accu_charge * 36) /
+			((di->fg_samples / 4) * 10);
 
 	di->flags.conv_done = true;
 
@@ -821,6 +819,9 @@ static void ab8500_fg_acc_cur_work(struct work_struct *work)
 
 	queue_work(di->fg_wq, &di->fg_work);
 
+	dev_dbg(di->dev,
+		"fg_res: %d, fg_samples: %d, gasg: %d, accu_charge: %d\n",
+		di->bat->fg_res, di->fg_samples, val, di->accu_charge);
 	return;
 exit:
 	dev_err(di->dev,
-- 
1.7.5.4

