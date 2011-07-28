Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1G1XsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:48:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:29735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab1G1Xom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33352089"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: johannes.berg@intel.com, linville@tuxdriver.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [37/50] mac80211: fix TKIP replay vulnerability
Message-Id: <20110728234441.EDE5B2403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Johannes Berg <johannes.berg@intel.com>

[ upstream commit 34459512ffa7236c849466e3bd604801389734e1 ]

Unlike CCMP, the presence or absence of the QoS
field doesn't change the encryption, only the
TID is used. When no QoS field is present, zero
is used as the TID value. This means that it is
possible for an attacker to take a QoS packet
with TID 0 and replay it as a non-QoS packet.

Unfortunately, mac80211 uses different IVs for
checking the validity of the packet's TKIP IV
when it checks TID 0 and when it checks non-QoS
packets. This means it is vulnerable to this
replay attack.

To fix this, use the same replay counter for
TID 0 and non-QoS packets by overriding the
rx->queue value to 0 if it is 16 (non-QoS).

This is a minimal fix for now. I caused this
issue in

commit 1411f9b531f0a910cd1c85a337737c1e6ffbae6a
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu Jul 10 10:11:02 2008 +0200

    mac80211: fix RX sequence number check

while fixing a sequence number issue (there,
a separate counter needs to be used).

[AK: This was a non trivial backport. Johannes, John,
please double check]

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/net/mac80211/wpa.c
===================================================================
--- linux-2.6.35.y.orig/net/mac80211/wpa.c
+++ linux-2.6.35.y/net/mac80211/wpa.c
@@ -89,6 +89,11 @@ ieee80211_rx_h_michael_mic_verify(struct
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int authenticator = 1, wpa_test = 0;
+	int queue = rx->queue;
+
+	/* otherwise, TKIP is vulnerable to TID 0 vs. non-QoS replays */
+	if (rx->queue == NUM_RX_DATA_QUEUES - 1)
+		queue = 0;
 
 	/* No way to verify the MIC if the hardware stripped it */
 	if (status->flag & RX_FLAG_MMIC_STRIPPED)
@@ -130,8 +135,8 @@ ieee80211_rx_h_michael_mic_verify(struct
 	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.rx[rx->queue].iv32 = rx->tkip_iv32;
-	rx->key->u.tkip.rx[rx->queue].iv16 = rx->tkip_iv16;
+	rx->key->u.tkip.rx[queue].iv32 = rx->tkip_iv32;
+	rx->key->u.tkip.rx[queue].iv16 = rx->tkip_iv16;
 
 	return RX_CONTINUE;
 }
@@ -213,6 +218,11 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	struct ieee80211_key *key = rx->key;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	int queue = rx->queue;
+
+	/* otherwise, TKIP is vulnerable to TID 0 vs. non-QoS replays */
+	if (rx->queue == NUM_RX_DATA_QUEUES - 1)
+		queue = 0;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
@@ -239,7 +249,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->sta.addr,
-					  hdr->addr1, hwaccel, rx->queue,
+					  hdr->addr1, hwaccel, queue,
 					  &rx->tkip_iv32,
 					  &rx->tkip_iv16);
 	if (res != TKIP_DECRYPT_OK || wpa_test)
