Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab2KNFzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:55:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756470Ab2KNFvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:09 -0500
Message-Id: <20121114053938.038709059@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 30/82] mac80211: check management frame header length
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/rx.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1457,7 +1457,6 @@ ieee80211_rx_h_defragment(struct ieee802
 	frag = sc & IEEE80211_SCTL_FRAG;
 
 	if (likely((!ieee80211_has_morefrags(fc) && frag == 0) ||
-		   (rx->skb)->len < 24 ||
 		   is_multicast_ether_addr(hdr->addr1))) {
 		/* not fragmented */
 		goto out;
@@ -2875,10 +2874,15 @@ static void __ieee80211_rx_handle_packet
 		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
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


