Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2EDVEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:04:44 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:61380 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab2EDUrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:43 -0400
Message-Id: <20120504204230.504925929@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 72/75] iwlwifi: do not nulify ctx->vif on reset
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 ---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   10 +++++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1403,7 +1403,6 @@ static void iwl_bg_run_time_calib_work(s
 
 void iwlagn_prepare_restart(struct iwl_priv *priv)
 {
-	struct iwl_rxon_context *ctx;
 	bool bt_full_concurrent;
 	u8 bt_ci_compliance;
 	u8 bt_load;
@@ -1412,8 +1411,6 @@ void iwlagn_prepare_restart(struct iwl_p
 
 	lockdep_assert_held(&priv->shrd->mutex);
 
-	for_each_context(priv, ctx)
-		ctx->vif = NULL;
 	priv->is_open = 0;
 
 	/*
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1226,6 +1226,7 @@ static int iwlagn_mac_add_interface(stru
 	struct iwl_rxon_context *tmp, *ctx = NULL;
 	int err;
 	enum nl80211_iftype viftype = ieee80211_vif_type_p2p(vif);
+	bool reset = false;
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
 			   viftype, vif->addr);
@@ -1247,6 +1248,13 @@ static int iwlagn_mac_add_interface(stru
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
@@ -1273,7 +1281,7 @@ static int iwlagn_mac_add_interface(stru
 	ctx->vif = vif;
 
 	err = iwl_setup_interface(priv, ctx);
-	if (!err)
+	if (!err || reset)
 		goto out;
 
 	ctx->vif = NULL;


