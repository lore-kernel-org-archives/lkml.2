Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1CLNJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 08:09:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1CLNJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 08:09:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uK0XL7WKaouywAM5ZntFvUhu7xaDAp75XhJhrUVrG5FE/G0pshZiYSwKMXxrUfbDz3
         ULvYeqnbOtrCiqVWH7qmf2tQ0Z9Vs73qWXSSXm/JgJm4VuxAviy7vcD2oDBD2Y1mYn+K
         bSrozKI9epOHfzXrH4p17hCgZS0q3k85+H21U=
From: Richard Genoud <richard.genoud@gmail.com>
To: Michael Hennerich <michael.hennerich@analog.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        device-driver-devel@blackfin.uclinux.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] ad525x_dpot: [BUG] eeprom command send instead of dec/inc all commands
Date: Sat, 12 Mar 2011 14:08:21 +0100
Message-Id: <1299935301-3849-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a DEC_ALL or INC_ALL command is issued, an eeprom command is send.
This is because DPOT_DEC_ALL (DPOT_ADDR_CMD | 0x30) and DPOT_INC_ALL
(DPOT_ADDR_CMD | 0x58) defines overlap with DPOT_ADDR_EEPROM (0x20).

So, DPOT_ADDR_CMD bit should be tested before DPOT_ADDR_EEPROM bit.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/misc/ad525x_dpot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 7cb9110..b6c5391 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -289,8 +289,6 @@ static s32 dpot_write_spi(struct dpot_data *dpot, u8 reg, u16 value)
 			}
 			val = DPOT_SPI_RDAC | (reg & DPOT_RDAC_MASK);
 		}
-	} else if (reg & DPOT_ADDR_EEPROM) {
-		val = DPOT_SPI_EEPROM | (reg & DPOT_RDAC_MASK);
 	} else if (reg & DPOT_ADDR_CMD) {
 		switch (reg) {
 		case DPOT_DEC_ALL_6DB:
@@ -306,6 +304,8 @@ static s32 dpot_write_spi(struct dpot_data *dpot, u8 reg, u16 value)
 			val = DPOT_SPI_INC_ALL;
 			break;
 		}
+	} else if (reg & DPOT_ADDR_EEPROM) {
+		val = DPOT_SPI_EEPROM | (reg & DPOT_RDAC_MASK);
 	} else if (reg & DPOT_ADDR_OTP) {
 		if (dpot->uid == DPOT_UID(AD5291_ID) ||
 			dpot->uid == DPOT_UID(AD5292_ID)) {
-- 
1.7.1

