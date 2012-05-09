Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab2EIMli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:41:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42451 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759078Ab2EIMl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:41:27 -0400
Message-Id: <20120509055050.007415211@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 148/167] [PATCH] iwlwifi: do not nulify ctx->vif on reset
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 8db4c7e25d153fb049e81715d72fa3be3a0c3b69 upstream.

ctx->vif is dereferenced in different part of iwlwifi code, so do not
nullify it.

This should address at least one of the possible reasons of WARNING at
iwlagn_mac_remove_interface, and perhaps some random crashes when
firmware reset is performed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2:
 - Change filename iwl-mac80211.c to iwl-core.c
 - Change context in iwlagn_prepare_restart()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 ---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   10 +++++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

--- linux.orig/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ linux/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1504,7 +1504,6 @@
 
 static void iwlagn_prepare_restart(struct iwl_priv *priv)
 {
-	struct iwl_rxon_context *ctx;
 	bool bt_full_concurrent;
 	u8 bt_ci_compliance;
 	u8 bt_load;
@@ -1513,8 +1512,6 @@
 
 	lockdep_assert_held(&priv->shrd->mutex);
 
-	for_each_context(priv, ctx)
-		ctx->vif = NULL;
 	priv->is_open = 0;
 
 	/*
--- linux.orig/drivers/net/wireless/iwlwifi/iwl-core.c
+++ linux/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1228,6 +1228,7 @@
 	struct iwl_rxon_context *tmp, *ctx = NULL;
 	int err;
 	enum nl80211_iftype viftype = ieee80211_vif_type_p2p(vif);
+	bool reset = false;
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
 			   viftype, vif->addr);
@@ -1249,6 +1250,13 @@
 			tmp->interface_modes | tmp->exclusive_interface_modes;
 
 		if (tmp->vif) {
+			/* On reset we need to add the same interface again */
+			if (tmp->vif == vif) {
+				reset = true;
+				ctx = tmp;
+				break;
+			}
+
 			/* check if this busy context is exclusive */
 			if (tmp->exclusive_interface_modes &
 						BIT(tmp->vif->type)) {
@@ -1275,7 +1283,7 @@
 	ctx->vif = vif;
 
 	err = iwl_setup_interface(priv, ctx);
-	if (!err)
+	if (!err || reset)
 		goto out;
 
 	ctx->vif = NULL;


