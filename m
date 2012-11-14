Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab2KNFzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:55:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55267 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756463Ab2KNFvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:09 -0500
Message-Id: <20121114053938.328343724@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 32/82] mac80211: make sure data is accessible in EAPOL check
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

commit 6dbda2d00d466225f9db1dc695ff852443f28832 upstream.

The code to allow EAPOL frames even when the station
isn't yet marked associated needs to check that the
incoming frame is long enough and due to paged RX it
also can't assume skb->data contains the right data,
it must use skb_copy_bits(). Fix this to avoid using
data that doesn't really exist.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/rx.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -859,14 +859,16 @@ ieee80211_rx_h_check(struct ieee80211_rx
 		     (!rx->sta || !test_sta_flag(rx->sta, WLAN_STA_ASSOC)))) {
 		if (rx->sta && rx->sta->dummy &&
 		    ieee80211_is_data_present(hdr->frame_control)) {
-			u16 ethertype;
-			u8 *payload;
+			unsigned int hdrlen;
+			__be16 ethertype;
 
-			payload = rx->skb->data +
-				ieee80211_hdrlen(hdr->frame_control);
-			ethertype = (payload[6] << 8) | payload[7];
-			if (cpu_to_be16(ethertype) ==
-			    rx->sdata->control_port_protocol)
+			hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+			if (rx->skb->len < hdrlen + 8)
+				return RX_DROP_MONITOR;
+
+			skb_copy_bits(rx->skb, hdrlen + 6, &ethertype, 2);
+			if (ethertype == rx->sdata->control_port_protocol)
 				return RX_CONTINUE;
 		}
 		return RX_DROP_MONITOR;


