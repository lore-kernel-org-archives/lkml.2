Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab2LMOHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:07:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab2LMOHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 108/241] iwlwifi: fix monitor mode FCS flag
Date: Thu, 13 Dec 2012 11:57:53 -0200
Message-Id: <1355407206-17100-109-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 04baaa27b43d389879237b32f8bd194a94cf1ca7 upstream.

When the firmware is in SNIFFER mode, it leaves
the FCS at the end of frame. Not telling mac80211
means it won't add the right flag to the radiotap
header and that confuses wireshark.

Since mac80211 doesn't have a per-packet flag, set
the HW flag dynamically. This works as the monitor
vif can only be present in the driver by itself.

This fixes a regression introduced by my

commit 578977264199de9815ace51ade87cec4894cf010
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri May 11 10:53:18 2012 +0200

    iwlwifi: support explicit monitor interface

Reported-by: MARK PHILLIPS <mark.phillips@virgin.net>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ herton: adjust file name to be patched ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 0136803..a0b0b78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1343,6 +1343,20 @@ static int iwlagn_mac_add_interface(struct ieee80211_hw *hw,
 	vif_priv->ctx = ctx;
 	ctx->vif = vif;
 
+	/*
+	 * In SNIFFER device type, the firmware reports the FCS to
+	 * the host, rather than snipping it off. Unfortunately,
+	 * mac80211 doesn't (yet) provide a per-packet flag for
+	 * this, so that we have to set the hardware flag based
+	 * on the interfaces added. As the monitor interface can
+	 * only be present by itself, and will be removed before
+	 * other interfaces are added, this is safe.
+	 */
+	if (vif->type == NL80211_IFTYPE_MONITOR)
+		priv->hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
+	else
+		priv->hw->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
+
 	err = iwl_setup_interface(priv, ctx);
 	if (!err || reset)
 		goto out;
-- 
1.7.9.5

