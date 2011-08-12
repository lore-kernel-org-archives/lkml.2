Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1HNQRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:17:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab1HNQJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:57 2011
Message-Id: <20110812210557.459336494@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Devin J. Pohly" <djpohly+iwl@gmail.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [61/90] iwlagn: 5000 do not support idle mode
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit f35291082294ca6737953bbe4e9491ede04ab822 upstream.

5000 series has issue supporting power save idle mode:
commit	9dc2153315650eae220898668b6aa56a25c130be

iwlwifi: always support idle mode for agn devices

For agn devices, always support idle mode which help power
consumption in idle unassociated state.

the above changes cause 5000 become not stable when power management is "on"

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2312

Reported-by: Devin J. Pohly <djpohly+iwl@gmail.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Devin J. Pohly <djpohly+iwl@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-5000.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h  |    2 ++
 drivers/net/wireless/iwlwifi/iwl-power.c |    3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -421,6 +421,7 @@ static struct iwl_base_params iwl5000_ba
 	.chain_noise_scale = 1000,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
+	.no_idle_support = true,
 };
 static struct iwl_ht_params iwl5000_ht_params = {
 	.ht_greenfield_support = true,
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -195,6 +195,7 @@ struct iwl_mod_params {
  * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logging
  * @shadow_reg_enable: HW shadhow register bit
+ * @no_idle_support: do not support idle mode
  */
 struct iwl_base_params {
 	int eeprom_size;
@@ -216,6 +217,7 @@ struct iwl_base_params {
 	bool temperature_kelvin;
 	u32 max_event_log_size;
 	const bool shadow_reg_enable;
+	const bool no_idle_support;
 };
 /*
  * @advanced_bt_coexist: support advanced bt coexist
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -355,7 +355,8 @@ static void iwl_power_build_cmd(struct i
 
 	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
 
-	if (priv->hw->conf.flags & IEEE80211_CONF_IDLE)
+	if (!priv->cfg->base_params->no_idle_support &&
+		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
 	else if (iwl_tt_is_low_power_state(priv)) {
 		/* in thermal throttling low power state */


