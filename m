Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2LMPWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:22:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38422 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2LMPWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:25 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Henrik=20S=C3=B6lver?= <henrik.solver@stericsson.com>
Subject: [PATCH 18/18] Power: ab8500_fg: Overflow in current calculation
Date: Thu, 13 Dec 2012 15:21:41 +0000
Message-Id: <1355412102-14265-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>

When calculating the average current the nominator will
overflow when the charging current is high.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Henrik Sölver <henrik.solver@stericsson.com>
Reviewed-by: Par-Olof HAKANSSON <par-olof.hakansson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Tested-by: Par-Olof HAKANSSON <par-olof.hakansson@stericsson.com>
---
 drivers/power/ab8500_fg.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index ec122d0..ba1a087 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -804,12 +804,9 @@ static void ab8500_fg_acc_cur_work(struct work_struct *work)
 
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
 	di->avg_curr = (val * QLSB_NANO_AMP_HOURS_X10 * 36) /
 		(1000 * di->bm->fg_res * (di->fg_samples / 4));
@@ -820,6 +817,8 @@ static void ab8500_fg_acc_cur_work(struct work_struct *work)
 
 	queue_work(di->fg_wq, &di->fg_work);
 
+	dev_dbg(di->dev, "fg_res: %d, fg_samples: %d, gasg: %d, accu_charge: %d \n",
+				di->bm->fg_res, di->fg_samples, val, di->accu_charge);
 	return;
 exit:
 	dev_err(di->dev,
-- 
1.7.9.5

