Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768838Ab2K3TLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:11:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:59552 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992996Ab2K3TCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        MARK PHILLIPS <mark.phillips@virgin.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 07/54] iwlwifi: fix monitor mode FCS flag
Date: Fri, 30 Nov 2012 10:55:38 -0800
Message-Id: <20121130185208.629369744@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1352,6 +1352,20 @@ static int iwlagn_mac_add_interface(stru
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


