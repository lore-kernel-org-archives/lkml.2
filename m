Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab1BPAtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:49:00 -0500
Received: from kroah.org ([198.145.64.141]:45551 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000Ab1BPAsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:05 2011
Message-Id: <20110216002105.109687955@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Shaw <paul.shaw@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 060/176] ath9k_hw: disabled PAPRD for AR9003
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 6f4810101a629b31b5427872a09ea092cfc5c4bd upstream.

AR9003's PAPRD was enabled prematurely, and is causing some
large discrepancies on throughput and network connectivity.
For example downlink (RX) throughput against an AR9280 AP
can vary widlely from 43-73 Mbit/s while disabling this
gets AR9382 (2x2) up to around 93 Mbit/s in a 2.4 GHz HT20 setup.

Cc: Paul Shaw <paul.shaw@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c |    6 +++++-
 drivers/net/wireless/ath/ath9k/hw.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -387,6 +387,9 @@ static void ath9k_hw_init_config(struct
 	else
 		ah->config.ht_enable = 0;
 
+	/* PAPRD needs some more work to be enabled */
+	ah->config.paprd_disable = 1;
+
 	ah->config.rx_intr_mitigation = true;
 	ah->config.pcieSerDesWrite = true;
 
@@ -2264,7 +2267,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw
 		pCap->rx_status_len = sizeof(struct ar9003_rxs);
 		pCap->tx_desc_len = sizeof(struct ar9003_txc);
 		pCap->txs_len = sizeof(struct ar9003_txs);
-		if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
+		if (!ah->config.paprd_disable &&
+		    ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
 			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -240,6 +240,7 @@ struct ath9k_ops_config {
 	u32 pcie_waen;
 	u8 analog_shiftreg;
 	u8 ht_enable;
+	u8 paprd_disable;
 	u32 ofdm_trig_low;
 	u32 ofdm_trig_high;
 	u32 cck_trig_high;


