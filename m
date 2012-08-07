Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab2HGW3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:29:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab2HGW3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel@quora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 050/122] iwlwifi: Check BSS ctx active before call mac80211
Date: Tue,  7 Aug 2012 15:25:38 -0700
Message-Id: <20120807221952.721102185@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

commit e19ebcab01cc130fa832764d453b263460ec3b91 upstream.

It is possible that the BSS context is not active (for example
when the current mode is set to GO), or that the vif->type is
different than station. In such a case we cannot
call mac80211 to report the average rssi for the interface
(the function assumes that the vif is valid and that the type
is station).

Reported-by: Daniel J Blueman <daniel@quora.org>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -617,6 +617,11 @@ static bool iwlagn_fill_txpower_mode(str
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	int ave_rssi;
 
+	if (!ctx->vif || (ctx->vif->type != NL80211_IFTYPE_STATION)) {
+		IWL_DEBUG_INFO(priv, "BSS ctx not active or not in sta mode\n");
+		return false;
+	}
+
 	ave_rssi = ieee80211_ave_rssi(ctx->vif);
 	if (!ave_rssi) {
 		/* no rssi data, no changes to reduce tx power */


