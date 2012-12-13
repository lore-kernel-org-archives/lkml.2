Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2LMOBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:01:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2LMOB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 012/241] mac80211: check management frame header length
Date: Thu, 13 Dec 2012 11:56:17 -0200
Message-Id: <1355407206-17100-13-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 4a4f1a5808c8bb0b72a4f6e5904c53fb8c9cd966 upstream.

Due to pskb_may_pull() checking the skb length, all
non-management frames are checked on input whether
their 802.11 header is fully present. Also add that
check for management frames and remove a check that
is now duplicate. This prevents accessing skb data
beyond the frame end.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ herton: unfuzz patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/rx.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4e4fc93..38800d3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1473,7 +1473,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	frag = sc & IEEE80211_SCTL_FRAG;
 
 	if (likely((!ieee80211_has_morefrags(fc) && frag == 0) ||
-		   (rx->skb)->len < 24 ||
 		   is_multicast_ether_addr(hdr->addr1))) {
 		/* not fragmented */
 		goto out;
@@ -2923,10 +2922,15 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
 		status->rx_flags |= IEEE80211_RX_IN_SCAN;
 
-	if (ieee80211_is_mgmt(fc))
-		err = skb_linearize(skb);
-	else
+	if (ieee80211_is_mgmt(fc)) {
+		/* drop frame if too short for header */
+		if (skb->len < ieee80211_hdrlen(fc))
+			err = -ENOBUFS;
+		else
+			err = skb_linearize(skb);
+	} else {
 		err = !pskb_may_pull(skb, ieee80211_hdrlen(fc));
+	}
 
 	if (err) {
 		dev_kfree_skb(skb);
-- 
1.7.9.5

