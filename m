Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1GXUKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 16:10:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56634 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1GXUJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 16:09:59 -0400
Date: Sun, 24 Jul 2011 13:08:40 -0700 (PDT)
Message-Id: <20110724.130840.1093555047179460794.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: johannes.berg@intel.com, wey-yi.w.guy@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlagn: wrap suspend/resume definitions in CONFIG_PM
 block
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311535150-28686-1-git-send-email-linville@tuxdriver.com>
References: <20110724.030949.1727841105144911931.davem@davemloft.net>
	<1311535150-28686-1-git-send-email-linville@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 24 Jul 2011 13:08:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 24 Jul 2011 15:19:10 -0400

> drivers/net/wireless/iwlwifi/iwl-agn.c:3464: error: unknown field 'suspend' specified in initializer
> drivers/net/wireless/iwlwifi/iwl-agn.c:3464: warning: initialization from incompatible pointer type
> drivers/net/wireless/iwlwifi/iwl-agn.c:3465: error: unknown field 'resume' specified in initializer
> drivers/net/wireless/iwlwifi/iwl-agn.c:3465: warning: initialization from incompatible pointer type
> 
> This was caused by commit c8ac61cf ("iwlagn: implement WoWLAN").
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Since I already minimally fixed up my build locally last night I know
that your patch leads to a set of warnings because the methods whose
hookup are now commented out become completely unused and they are all
marked "static".  And recursively functions that those methods use
become unused too.

Did you turn off CONFIG_PM and test the build of this file to see
what the compiler actually does with it?

I'm checking in the following, but I expect much better from you John.

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4b666b7..b0ae4de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2279,6 +2279,7 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
+#ifdef CONFIG_PM
 static int iwlagn_send_patterns(struct iwl_priv *priv,
 				struct cfg80211_wowlan *wowlan)
 {
@@ -2320,6 +2321,7 @@ static int iwlagn_send_patterns(struct iwl_priv *priv,
 	kfree(pattern_cmd);
 	return err;
 }
+#endif
 
 static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
@@ -2352,6 +2354,7 @@ struct wowlan_key_data {
 	bool error, use_rsc_tsc, use_tkip;
 };
 
+#ifdef CONFIG_PM
 static void iwlagn_convert_p1k(u16 *p1k, __le16 *out)
 {
 	int i;
@@ -2739,6 +2742,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 	return 1;
 }
+#endif
 
 static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
@@ -3461,8 +3465,10 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
 	.stop = iwlagn_mac_stop,
+#ifdef CONFIG_PM
 	.suspend = iwlagn_mac_suspend,
 	.resume = iwlagn_mac_resume,
+#endif
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
 	.change_interface = iwl_mac_change_interface,

