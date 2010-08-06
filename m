Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964965Ab0HFSgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:36:14 -0400
Received: from kroah.org ([198.145.64.141]:48676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964927Ab0HFSf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:57 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:02 2010
Message-Id: <20100806183201.992421347@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [22/38] ath9k: fix TSF after reset on AR913x
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1268,7 +1268,8 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	macStaId1 = REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_BASE_RATE_11B;
 
 	/* For chips on which RTC reset is done, save TSF before it gets cleared */
-	if (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+	if (AR_SREV_9100(ah) ||
+	    (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)))
 		tsf = ath9k_hw_gettsf64(ah);
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
@@ -1300,7 +1301,7 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	}
 
 	/* Restore TSF */
-	if (tsf && AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+	if (tsf)
 		ath9k_hw_settsf64(ah, tsf);
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
@@ -1310,6 +1311,17 @@ int ath9k_hw_reset(struct ath_hw *ah, st
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


