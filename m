Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1JJBv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 21:51:58 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:54422 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1JJBv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 21:51:57 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.15 with qID p9A1pjLn006301, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging:rts_pstor:Fix SDIO issue
Date: Mon, 10 Oct 2011 09:51:44 +0800
X-BOX-Message-Id: p9A1pjLn006301
Message-ID: <1318211504-22108-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Fix a bug that SDIO and SD normal card would appear simultaneously if a SDIO card inserted.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/sd.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index fb62eaf..ebf529a 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3134,14 +3134,15 @@ int reset_sd_card(struct rtsx_chip *chip)
 
 	if (chip->sd_ctl & RESET_MMC_FIRST) {
 		retval = reset_mmc(chip);
-		if ((retval != STATUS_SUCCESS) && !sd_check_err_code(chip, SD_NO_CARD)) {
+		if (retval != STATUS_SUCCESS) {
+			if (sd_check_err_code(chip, SD_NO_CARD))
+				TRACE_RET(chip, STATUS_FAIL);
+
 			retval = reset_sd(chip);
 			if (retval != STATUS_SUCCESS) {
 				if (CHECK_PID(chip, 0x5209)) {
-					retval = sd_change_bank_voltage(chip, SD_IO_3V3);
-					if (retval != STATUS_SUCCESS) {
-						TRACE_RET(chip, STATUS_FAIL);
-					}
+					sd_change_bank_voltage(chip, SD_IO_3V3);
+					TRACE_RET(chip, STATUS_FAIL);
 				}
 			}
 		}
@@ -3157,17 +3158,16 @@ int reset_sd_card(struct rtsx_chip *chip)
 				if (retval != STATUS_SUCCESS) {
 					TRACE_RET(chip, STATUS_FAIL);
 				}
+				retval = STATUS_FAIL;
 			}
 
-			if (!chip->sd_io) {
+			if (!chip->sd_io)
 				retval = reset_mmc(chip);
-			}
 		}
 	}
 
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
 	if (retval != STATUS_SUCCESS) {
-- 
1.7.7

