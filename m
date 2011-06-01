Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162079Ab1FAJEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:04:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162033Ab1FAIRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:00 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:02 2011
Message-Id: <20110601081101.535971489@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:52 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [022/165] iwlagn: fix iwl_is_any_associated
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2312
Lines: 64

From: Johannes Berg <johannes.berg@intel.com>

commit 054ec924944912413e4ee927b8cf02f476d08783 upstream.

The function iwl_is_any_associated() was intended
to check both contexts, but due to an oversight
it only checks the BSS context. This leads to a
problem with scanning since the passive dwell
time isn't restricted appropriately and a scan
that includes passive channels will never finish
if only the PAN context is associated since the
default dwell time of 120ms won't fit into the
normal 100 TU DTIM interval.

Fix the function by using for_each_context() and
also reorganise the other functions a bit to take
advantage of each other making the code easier to
read.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-dev.h |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1658,21 +1658,24 @@ iwl_rxon_ctx_from_vif(struct ieee80211_v
 	     ctx < &priv->contexts[NUM_IWL_RXON_CTX]; ctx++)	\
 		if (priv->valid_contexts & BIT(ctx->ctxid))
 
-static inline int iwl_is_associated(struct iwl_priv *priv,
-				    enum iwl_rxon_context_id ctxid)
+static inline int iwl_is_associated_ctx(struct iwl_rxon_context *ctx)
 {
-	return (priv->contexts[ctxid].active.filter_flags &
-			RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+	return (ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
 
-static inline int iwl_is_any_associated(struct iwl_priv *priv)
+static inline int iwl_is_associated(struct iwl_priv *priv,
+				    enum iwl_rxon_context_id ctxid)
 {
-	return iwl_is_associated(priv, IWL_RXON_CTX_BSS);
+	return iwl_is_associated_ctx(&priv->contexts[ctxid]);
 }
 
-static inline int iwl_is_associated_ctx(struct iwl_rxon_context *ctx)
+static inline int iwl_is_any_associated(struct iwl_priv *priv)
 {
-	return (ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+	struct iwl_rxon_context *ctx;
+	for_each_context(priv, ctx)
+		if (iwl_is_associated_ctx(ctx))
+			return true;
+	return false;
 }
 
 static inline int is_channel_valid(const struct iwl_channel_info *ch_info)


