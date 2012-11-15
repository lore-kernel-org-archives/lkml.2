Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993313Ab2KOEXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:23:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:49745 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993224Ab2KOEMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 18/57] mac80211: check management frame header length
Date: Wed, 14 Nov 2012 20:11:26 -0800
Message-Id: <20121115040934.340482888@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1473,7 +1473,6 @@ ieee80211_rx_h_defragment(struct ieee802
 	frag = sc & IEEE80211_SCTL_FRAG;
 
 	if (likely((!ieee80211_has_morefrags(fc) && frag == 0) ||
-		   (rx->skb)->len < 24 ||
 		   is_multicast_ether_addr(hdr->addr1))) {
 		/* not fragmented */
 		goto out;
@@ -2929,10 +2928,15 @@ static void __ieee80211_rx_handle_packet
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


