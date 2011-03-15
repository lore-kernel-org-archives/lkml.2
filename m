Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1COIWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:22:50 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:40191 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab1COIWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:22:47 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.07 with qID p2F8MalI015106, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH 2/2] staging: rts_pstor: set lun_mode in a different place
Date: Tue, 15 Mar 2011 16:22:16 +0800
X-BOX-Message-Id: p2F8MalI015106
Message-ID: <1300177336-4486-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

In sony notebook, card reader will be configured as two-lun mode
through EFUSE. In this situation, MS card can't be recognized
properly because driver does only support single-lun mode in default.
In this patch, lun_mode is set in a different place, so driver can
detect the EFUSE configuation automatically.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/rtsx_chip.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_chip.c b/drivers/staging/rts_pstor/rtsx_chip.c
index f443d97..d2f1c71 100644
--- a/drivers/staging/rts_pstor/rtsx_chip.c
+++ b/drivers/staging/rts_pstor/rtsx_chip.c
@@ -684,6 +684,11 @@ static int rts5209_init(struct rtsx_chip *chip)
 	RTSX_DEBUGP("dw in 0x724: 0x%x\n", lval);
 	val = (u8)lval;
 	if (!(val & 0x80)) {
+		if (val & 0x08)
+			chip->lun_mode = DEFAULT_SINGLE;
+		else
+			chip->lun_mode = SD_MS_2LUN;
+
 		if (val & 0x04) {
 			SET_SDIO_EXIST(chip);
 		} else {
@@ -705,12 +710,6 @@ static int rts5209_init(struct rtsx_chip *chip)
 
 		chip->aspm_l0s_l1_en = (val >> 5) & 0x03;
 
-		if (val & 0x08) {
-			chip->lun_mode = DEFAULT_SINGLE;
-		} else {
-			chip->lun_mode = SD_MS_2LUN;
-		}
-
 		val = (u8)(lval >> 8);
 
 		clk = (val >> 5) & 0x07;
-- 
1.7.4.1

