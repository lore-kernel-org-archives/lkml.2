Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1FPHBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41003 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069Ab1FPHBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:39 -0400
X-Sasl-enc: 5nB9a0Ezx3VwEyABlNBuDvSN9QkVNQg++DCm/uBQwljQ 1308207698
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:36 2011
Message-Id: <20110616000236.451697445@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [76/89] iwlagn: use cts-to-self protection on 5000 adapters series
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 42b70a5f6d18165a075d189d1bee82fad7cdbf29 upstream.

This patch fixes 802.11n stability and performance regression we have
since 2.6.35. It boost performance on my 5GHz N-only network from about
5MB/s to 8MB/s. Similar percentage boost can be observed on 2.4 GHz.

These are test results of 5x downloading of approximately 700MB iso
image:

vanilla: 5.27 5.22 4.94 4.47 5.31 ; avr 5.0420 std 0.35110
patched: 8.07 7.95 8.06 7.99 7.96 ; avr 8.0060 std 0.055946

This was achieved with NetworkManager configured to do not perform
periodical scans, by configuring constant BSSID. With periodical scans,
after some time, performance downgrade to unpatched driver level, like
in example below:

patched: 7.40 7.61 4.28 4.37 4.80 avr 5.6920 std 1.6683

However patch still make better here, since similar test on unpatched
driver make link disconnects with below messages after some time:

wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
wlan1: authenticate with 00:23:69:35:d1:3f (try 3)
wlan1: authentication with 00:23:69:35:d1:3f timed out

On 2.6.35 kernel patch helps against connection hangs with messages:

iwlagn 0000:20:00.0: queue 10 stuck 3 time. Fw reload.
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: Stopping AGG while state not ON or starting

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   12 ++----------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    8 ++++++++
 3 files changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -513,7 +513,6 @@ static struct iwl_base_params iwl5000_ba
 };
 static struct iwl_ht_params iwl5000_ht_params = {
 	.ht_greenfield_support = true,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
 };
 
 #define IWL_DEVICE_5000						\
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -217,17 +217,9 @@ static void iwlagn_tx_cmd_protection(str
 				     __le16 fc, __le32 *tx_flags)
 {
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS ||
-	    info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
+	    info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT ||
+	    info->flags & IEEE80211_TX_CTL_AMPDU)
 		*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
-		return;
-	}
-
-	if (priv->cfg->ht_params &&
-	    priv->cfg->ht_params->use_rts_for_aggregation &&
-	    info->flags & IEEE80211_TX_CTL_AMPDU) {
-		*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
-		return;
-	}
 }
 
 /* Calc max signal level (dBm) among 3 possible receivers */
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -173,6 +173,14 @@ int iwlagn_commit_rxon(struct iwl_priv *
 			return 0;
 	}
 
+	/*
+	 * force CTS-to-self frames protection if RTS-CTS is not preferred
+	 * one aggregation protection method
+	 */
+	if (!(priv->cfg->ht_params &&
+	      priv->cfg->ht_params->use_rts_for_aggregation))
+		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
 	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
 		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;


