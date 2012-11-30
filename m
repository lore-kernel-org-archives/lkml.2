Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030401Ab2K3MFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:05:07 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65133 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab2K3MFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:05:02 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 07:04:38 EST
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/12] ab8500_fg: Don't clear the CCMuxOffset bit
Date: Fri, 30 Nov 2012 11:57:24 +0000
Message-Id: <1354276654-590-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kalle Komierowski <karl.komierowski@stericsson.com>

The CCMuxOffset bit is not kept set. This will force the
columb counter of the AB8500 to use the measure offset
calibration. This should increase the accuracy of the fuel
gauge.

Signed-off-by: Kalle Komierowski <karl.komierowski@stericsson.com>
Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index ed62ef7..5a9f58d 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -484,8 +484,9 @@ static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
 		di->flags.fg_enabled = true;
 	} else {
 		/* Clear any pending read requests */
-		ret = abx500_set_register_interruptible(di->dev,
-			AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG, 0);
+		ret = abx500_mask_and_set_register_interruptible(di->dev,
+			AB8500_GAS_GAUGE, AB8500_GASG_CC_CTRL_REG,
+			(RESET_ACCU | READ_REQ), 0);
 		if (ret)
 			goto cc_err;
 
@@ -1403,8 +1404,7 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 		sleep_time = di->bat->fg_params->init_timer;
 
 		/* Discard the first [x] seconds */
-		if (di->init_cnt >
-			di->bat->fg_params->init_discard_time) {
+		if (di->init_cnt > di->bat->fg_params->init_discard_time) {
 			ab8500_fg_calc_cap_discharge_voltage(di, true);
 
 			ab8500_fg_check_capacity_limits(di, true);
-- 
1.7.9.5

