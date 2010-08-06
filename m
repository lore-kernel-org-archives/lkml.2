Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147Ab0HFTAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:00:34 -0400
Received: from kroah.org ([198.145.64.141]:58563 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935694Ab0HFTAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:13 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:35 2010
Message-Id: <20100806185835.276191563@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [16/34] ath9k: fix TSF after reset on AR913x
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit f860d526eb2939a1c37128900b5af2b6f3ff7f20 upstream.

When issuing a reset, the TSF value is lost in the hardware because of
the 913x specific cold reset. As with some AR9280 cards, the TSF needs
to be preserved in software here.

Additionally, there's an issue that frequently prevents a successful
TSF write directly after the chip reset. In this case, repeating the
TSF write after the initval-writes usually works.

This patch detects failed TSF writes and recovers from them, taking
into account the delay caused by the initval writes.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Björn Smedman <bjorn.smedman@venatech.se>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2403,7 +2403,8 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	macStaId1 = REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_BASE_RATE_11B;
 
 	/* For chips on which RTC reset is done, save TSF before it gets cleared */
-	if (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+	if (AR_SREV_9100(ah) ||
+	    (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)))
 		tsf = ath9k_hw_gettsf64(ah);
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
@@ -2433,7 +2434,7 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	}
 
 	/* Restore TSF */
-	if (tsf && AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+	if (tsf)
 		ath9k_hw_settsf64(ah, tsf);
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
@@ -2453,6 +2454,17 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	if (r)
 		return r;
 
+	/*
+	 * Some AR91xx SoC devices frequently fail to accept TSF writes
+	 * right after the chip reset. When that happens, write a new
+	 * value after the initvals have been applied, with an offset
+	 * based on measured time difference
+	 */
+	if (AR_SREV_9100(ah) && (ath9k_hw_gettsf64(ah) < tsf)) {
+		tsf += 1500;
+		ath9k_hw_settsf64(ah, tsf);
+	}
+
 	/* Setup MFP options for CCMP */
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		/* Mask Retry(b11), PwrMgt(b12), MoreData(b13) to 0 in mgmt


