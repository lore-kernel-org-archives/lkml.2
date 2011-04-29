Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab1D2S7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:59:04 -0400
Received: from kroah.org ([198.145.64.141]:35126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933638Ab1D2S6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:57 2011
Message-Id: <20110429185657.539711427@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [51/55] iwlwifi: do not set tx power when channel is changing
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit f844a709a7d8f8be61a571afc31dfaca9e779621 upstream.

Mac80211 can request for tx power and channel change in one ->config
call. If that happens, *_send_tx_power functions will try to setup tx
power for old channel, what can be not correct because we already change
the band. I.e  error  "Failed to get channel info for channel 140 [0]",
can be printed frequently when operating in software scanning mode.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   13 ++++++++++---
 4 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1823,7 +1823,7 @@ int iwl3945_commit_rxon(struct iwl_priv
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	rc = priv->cfg->ops->lib->send_tx_power(priv);
+	rc = iwl_set_tx_power(priv, priv->tx_power_next, true);
 	if (rc) {
 		IWL_ERR(priv, "Error setting Tx power (%d).\n", rc);
 		return rc;
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1571,7 +1571,7 @@ static int iwl4965_commit_rxon(struct iw
 
 	/* If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames */
-	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	ret = iwl_set_tx_power(priv, priv->tx_power_next, true);
 	if (ret) {
 		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
 		return ret;
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -288,10 +288,9 @@ int iwlagn_commit_rxon(struct iwl_priv *
 	 * If we issue a new RXON command which required a tune then we must
 	 * send a new TXPOWER command or we won't be able to Tx any frames.
 	 *
-	 * FIXME: which RXON requires a tune? Can we optimise this out in
-	 *        some cases?
+	 * It's expected we set power here if channel is changing.
 	 */
-	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+	ret = iwl_set_tx_power(priv, priv->tx_power_next, true);
 	if (ret) {
 		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
 		return ret;
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1161,6 +1161,8 @@ int iwl_set_tx_power(struct iwl_priv *pr
 {
 	int ret;
 	s8 prev_tx_power;
+	bool defer;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
 	lockdep_assert_held(&priv->mutex);
 
@@ -1188,10 +1190,15 @@ int iwl_set_tx_power(struct iwl_priv *pr
 	if (!iwl_is_ready_rf(priv))
 		return -EIO;
 
-	/* scan complete use tx_power_next, need to be updated */
+	/* scan complete and commit_rxon use tx_power_next value,
+	 * it always need to be updated for newest request */
 	priv->tx_power_next = tx_power;
-	if (test_bit(STATUS_SCANNING, &priv->status) && !force) {
-		IWL_DEBUG_INFO(priv, "Deferring tx power set while scanning\n");
+
+	/* do not set tx power when scanning or channel changing */
+	defer = test_bit(STATUS_SCANNING, &priv->status) ||
+		memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
+	if (defer && !force) {
+		IWL_DEBUG_INFO(priv, "Deferring tx power set\n");
 		return 0;
 	}
 


