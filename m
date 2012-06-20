Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab2FTSaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:30:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab2FTSX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:59 -0400
Message-Id: <20120620173026.081990180@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 60/61] iwlwifi: fix TX power antenna access
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a5fdde28b4f5fb756032e7ad2c6fcdcffde20958 upstream.

Since my commit
  iwlwifi: use valid TX/RX antenna from hw_params
the config values are pure overrides, not the
real values for all hardware. Therefore, the
EEPROM TX power reading code checks the wrong
values, it should check the hw_params values.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -513,28 +513,28 @@ static int iwl_find_otp_image(struct iwl
  * iwl_get_max_txpower_avg - get the highest tx power from all chains.
  *     find the highest tx power from all chains for the channel
  */
-static s8 iwl_get_max_txpower_avg(const struct iwl_cfg *cfg,
+static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
 		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
 		int element, s8 *max_txpower_in_half_dbm)
 {
 	s8 max_txpower_avg = 0; /* (dBm) */
 
 	/* Take the highest tx power from any valid chains */
-	if ((cfg->valid_tx_ant & ANT_A) &&
+	if ((hw_params(priv).valid_tx_ant & ANT_A) &&
 	    (enhanced_txpower[element].chain_a_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].chain_a_max;
-	if ((cfg->valid_tx_ant & ANT_B) &&
+	if ((hw_params(priv).valid_tx_ant & ANT_B) &&
 	    (enhanced_txpower[element].chain_b_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].chain_b_max;
-	if ((cfg->valid_tx_ant & ANT_C) &&
+	if ((hw_params(priv).valid_tx_ant & ANT_C) &&
 	    (enhanced_txpower[element].chain_c_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].chain_c_max;
-	if (((cfg->valid_tx_ant == ANT_AB) |
-	    (cfg->valid_tx_ant == ANT_BC) |
-	    (cfg->valid_tx_ant == ANT_AC)) &&
+	if (((hw_params(priv).valid_tx_ant == ANT_AB) |
+	    (hw_params(priv).valid_tx_ant == ANT_BC) |
+	    (hw_params(priv).valid_tx_ant == ANT_AC)) &&
 	    (enhanced_txpower[element].mimo2_max > max_txpower_avg))
 		max_txpower_avg =  enhanced_txpower[element].mimo2_max;
-	if ((cfg->valid_tx_ant == ANT_ABC) &&
+	if ((hw_params(priv).valid_tx_ant == ANT_ABC) &&
 	    (enhanced_txpower[element].mimo3_max > max_txpower_avg))
 		max_txpower_avg = enhanced_txpower[element].mimo3_max;
 
@@ -637,7 +637,7 @@ static void iwl_eeprom_enhanced_txpower(
 				 ((txp->delta_20_in_40 & 0xf0) >> 4),
 				 (txp->delta_20_in_40 & 0x0f));
 
-		max_txp_avg = iwl_get_max_txpower_avg(cfg(priv), txp_array, idx,
+		max_txp_avg = iwl_get_max_txpower_avg(priv, txp_array, idx,
 						      &max_txp_avg_halfdbm);
 
 		/*


