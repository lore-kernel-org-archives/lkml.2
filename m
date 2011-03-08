Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1CHHWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 02:22:35 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:60504 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab1CHHWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 02:22:30 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.07 with qID p287MHa9002842, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging: rts_pstor: MSXC card power class
Date: Tue, 8 Mar 2011 15:22:14 +0800
X-BOX-Message-Id: p287MHa9002842
Message-ID: <1299568934-16773-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

1, Initialize chip->ms_power_class_en in rtsx_init_options;
2, In reset_ms_pro, set different initial value of change_power_class
according to chip->ms_power_class_en.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/ms.c   |   14 +++++++++-----
 drivers/staging/rts_pstor/rtsx.c |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index c43f911..810e170 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -1099,7 +1099,14 @@ static int reset_ms_pro(struct rtsx_chip *chip)
 	struct ms_info *ms_card = &(chip->ms_card);
 	int retval;
 #ifdef XC_POWERCLASS
-	u8 change_power_class = 2;
+	u8 change_power_class;
+
+	if (chip->ms_power_class_en & 0x02)
+		change_power_class = 2;
+	else if (chip->ms_power_class_en & 0x01)
+		change_power_class = 1;
+	else
+		change_power_class = 0;
 #endif
 
 #ifdef XC_POWERCLASS
@@ -1128,10 +1135,7 @@ Retry:
 	}
 
 	if (change_power_class && CHK_MSXC(ms_card)) {
-		u8 power_class_en = 0x03;
-
-		if (CHECK_PID(chip, 0x5209))
-			power_class_en = chip->ms_power_class_en;
+		u8 power_class_en = chip->ms_power_class_en;
 
 		RTSX_DEBUGP("power_class_en = 0x%x\n", power_class_en);
 		RTSX_DEBUGP("change_power_class = %d\n", change_power_class);
diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index c3f33d1..6d84838 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -850,6 +850,7 @@ static void rtsx_init_options(struct rtsx_chip *chip)
 	chip->sd_default_rx_phase = 15;
 	chip->pmos_pwr_on_interval = 200;
 	chip->sd_voltage_switch_delay = 1000;
+	chip->ms_power_class_en = 3;
 
 	chip->sd_400mA_ocp_thd = 1;
 	chip->sd_800mA_ocp_thd = 5;
-- 
1.7.4.1

