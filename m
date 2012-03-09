Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030729Ab2CIUWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:22:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63959 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030613Ab2CITrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:31 -0500
Message-Id: <20120309190205.313583246@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexander Schnaidt <alex.schnaidt@googlemail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 37/95] iwlwifi: fix key removal
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 5dcbf480473f6c3f06ad2426b7517038a2a18911 upstream.

When trying to remove a key, we always send key
flags just setting the key type, not including
the multicast flag and the key ID. As a result,
whenever any key was removed, the unicast key 0
would be removed, causing a complete connection
loss after the second rekey (the first doesn't
cause a key removal). Fix the key removal code
to include the key ID and multicast flag, thus
removing the correct key.

Reported-by: Alexander Schnaidt <alex.schnaidt@googlemail.com>
Tested-by: Alexander Schnaidt <alex.schnaidt@googlemail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1211,6 +1211,7 @@ int iwl_remove_dynamic_key(struct iwl_pr
 	unsigned long flags;
 	struct iwl_addsta_cmd sta_cmd;
 	u8 sta_id = iwlagn_key_sta_id(priv, ctx->vif, sta);
+	__le16 key_flags;
 
 	/* if station isn't there, neither is the key */
 	if (sta_id == IWL_INVALID_STATION)
@@ -1236,7 +1237,14 @@ int iwl_remove_dynamic_key(struct iwl_pr
 		IWL_ERR(priv, "offset %d not used in uCode key table.\n",
 			keyconf->hw_key_idx);
 
-	sta_cmd.key.key_flags = STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
+	key_flags = cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags |= STA_KEY_FLG_MAP_KEY_MSK | STA_KEY_FLG_NO_ENC |
+		     STA_KEY_FLG_INVALID;
+
+	if (!(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	sta_cmd.key.key_flags = key_flags;
 	sta_cmd.key.key_offset = WEP_INVALID_OFFSET;
 	sta_cmd.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	sta_cmd.mode = STA_CONTROL_MODIFY_MSK;


