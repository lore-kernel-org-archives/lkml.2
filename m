Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab1D2TAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:00:00 -0400
Received: from kroah.org ([198.145.64.141]:35142 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624Ab1D2S6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:57 2011
Message-Id: <20110429185657.837298710@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [54/55] iwlegacy: fix tx_power initialization
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 332704a51498a7e29aa92c19dc03f11f80b71bfe upstream.

priv->tx_power_next is not initialized to max supported power,
but instead default value is used, what cause errors like

[   58.597834] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[   58.597839] iwl3945 0000:03:00.0: Error setting Tx power (-22).

if maximum tx power read from the eeprom is smaller than default.
In consequence card is unable to initialize properly. Fix the problem
and cleanup tx power initialization.

Reported-and-tested-by: Robin Dong <hao.bigrat@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 ------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    9 +++++++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    7 -------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ----
 5 files changed, 7 insertions(+), 21 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -74,8 +74,6 @@
 /* RSSI to dBm */
 #define IWL39_RSSI_OFFSET	95
 
-#define IWL_DEFAULT_TX_POWER	0x0F
-
 /*
  * EEPROM related constants, enums, and structures.
  */
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3841,12 +3841,6 @@ static int iwl_init_drv(struct iwl_priv
 		priv->dynamic_frag_thresh = BT_FRAG_THRESHOLD_DEF;
 	}
 
-	/* Set the tx_power_user_lmt to the lowest power level
-	 * this value will get overwritten by channel max power avg
-	 * from eeprom */
-	priv->tx_power_user_lmt = IWLAGN_TX_POWER_TARGET_POWER_MIN;
-	priv->tx_power_next = IWLAGN_TX_POWER_TARGET_POWER_MIN;
-
 	ret = iwl_init_channel_map(priv);
 	if (ret) {
 		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -168,6 +168,7 @@ int iwlcore_init_geos(struct iwl_priv *p
 	struct ieee80211_channel *geo_ch;
 	struct ieee80211_rate *rates;
 	int i = 0;
+	s8 max_tx_power = 0;
 
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
 	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
@@ -244,8 +245,8 @@ int iwlcore_init_geos(struct iwl_priv *p
 
 			geo_ch->flags |= ch->ht40_extension_channel;
 
-			if (ch->max_power_avg > priv->tx_power_device_lmt)
-				priv->tx_power_device_lmt = ch->max_power_avg;
+			if (ch->max_power_avg > max_tx_power)
+				max_tx_power = ch->max_power_avg;
 		} else {
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
 		}
@@ -258,6 +259,10 @@ int iwlcore_init_geos(struct iwl_priv *p
 				 geo_ch->flags);
 	}
 
+	priv->tx_power_device_lmt = max_tx_power;
+	priv->tx_power_user_lmt = max_tx_power;
+	priv->tx_power_next = max_tx_power;
+
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     priv->cfg->sku & IWL_SKU_A) {
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -724,13 +724,6 @@ int iwl_init_channel_map(struct iwl_priv
 					     flags & EEPROM_CHANNEL_RADAR))
 				       ? "" : "not ");
 
-			/* Set the tx_power_user_lmt to the highest power
-			 * supported by any channel */
-			if (eeprom_ch_info[ch].max_power_avg >
-						priv->tx_power_user_lmt)
-				priv->tx_power_user_lmt =
-				    eeprom_ch_info[ch].max_power_avg;
-
 			ch_info++;
 		}
 	}
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3859,10 +3859,6 @@ static int iwl3945_init_drv(struct iwl_p
 	priv->force_reset[IWL_FW_RESET].reset_duration =
 		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
 
-
-	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
-	priv->tx_power_next = IWL_DEFAULT_TX_POWER;
-
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
 		IWL_WARN(priv, "Unsupported EEPROM version: 0x%04X\n",
 			 eeprom->version);


