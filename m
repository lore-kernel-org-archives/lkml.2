Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1BBBG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:06:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:45158 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1BBAni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418012"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: technoboy85@gmail.com, matteo@openwrt.org, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [33/139] ath9k: fix bug in tx power
Message-Id: <20110202004348.5A14B3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Matteo Croce <technoboy85@gmail.com>

commit 841051602e3fa18ea468fe5a177aa92b6eb44b56 upstream.

The ath9k driver subtracts 3 dBm to the txpower as with two radios the
signal power is doubled.
The resulting value is assigned in an u16 which overflows and makes
the card work at full power.

Signed-off-by: Matteo Croce <matteo@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/ath/ath9k/eeprom_def.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/ath/ath9k/eeprom_def.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ linux-2.6.35.y/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1064,15 +1064,19 @@ static void ath9k_hw_set_def_power_per_r
 	case 1:
 		break;
 	case 2:
-		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		else
+			scaledPower = 0;
 		break;
 	case 3:
-		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		else
+			scaledPower = 0;
 		break;
 	}
 
-	scaledPower = max((u16)0, scaledPower);
-
 	if (IS_CHAN_2GHZ(chan)) {
 		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
 			SUB_NUM_CTL_MODES_AT_2G_40;
