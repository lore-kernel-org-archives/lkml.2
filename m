Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab1DNRpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:45:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:37544 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662Ab1DNRpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 002/209] ath9k_hw: fix antenna diversity on AR9285
Date: Thu, 14 Apr 2011 13:40:32 -0400
Message-Id: <1302803039-9400-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 601e0cb165e65dc185b31fe7ebd2c0169ea47306 upstream.

On AR9285, the antenna switch configuration register uses more than just
16 bits. Because of an arbitrary mask applied to the EEPROM value that
stores this configuration, diversity was broken in some cases, leading
to a significant degradation in signal strength.
Fix this by changing the callback to return a 32 bit value and remove
the arbitrary mask.

[PG: drop ar9003_eeprom.c change; v2.6.34 doesn't have it yet]

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h      |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 104e3ea..b64b3e5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -670,7 +670,7 @@ struct eeprom_ops {
 	int (*get_eeprom_ver)(struct ath_hw *hw);
 	int (*get_eeprom_rev)(struct ath_hw *hw);
 	u8 (*get_num_ant_config)(struct ath_hw *hw, enum ieee80211_band band);
-	u16 (*get_eeprom_antenna_cfg)(struct ath_hw *hw,
+	u32 (*get_eeprom_antenna_cfg)(struct ath_hw *hw,
 				      struct ath9k_channel *chan);
 	void (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
 	void (*set_addac)(struct ath_hw *hw, struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 68db166..73cd4db 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -1138,13 +1138,13 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 	}
 }
 
-static u16 ath9k_hw_4k_get_eeprom_antenna_cfg(struct ath_hw *ah,
+static u32 ath9k_hw_4k_get_eeprom_antenna_cfg(struct ath_hw *ah,
 					      struct ath9k_channel *chan)
 {
 	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 
-	return pModal->antCtrlCommon & 0xFFFF;
+	return pModal->antCtrlCommon;
 }
 
 static u8 ath9k_hw_4k_get_num_ant_config(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 839d05a..c6f77ce 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -1130,13 +1130,13 @@ static u8 ath9k_hw_AR9287_get_num_ant_config(struct ath_hw *ah,
 	return 1;
 }
 
-static u16 ath9k_hw_AR9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
+static u32 ath9k_hw_AR9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
 						  struct ath9k_channel *chan)
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
 
-	return pModal->antCtrlCommon & 0xFFFF;
+	return pModal->antCtrlCommon;
 }
 
 static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 1644b1a..e61823e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1431,14 +1431,14 @@ static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
 	return num_ant_config;
 }
 
-static u16 ath9k_hw_def_get_eeprom_antenna_cfg(struct ath_hw *ah,
+static u32 ath9k_hw_def_get_eeprom_antenna_cfg(struct ath_hw *ah,
 					       struct ath9k_channel *chan)
 {
 	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
 
-	return pModal->antCtrlCommon & 0xFFFF;
+	return pModal->antCtrlCommon;
 }
 
 static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
-- 
1.7.4.4

