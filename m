Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993301Ab2KOEMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:12:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:49849 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993282Ab2KOEMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 20/57] mac80211: make sure data is accessible in EAPOL check
Date: Wed, 14 Nov 2012 20:11:28 -0800
Message-Id: <20121115040934.479070696@linuxfoundation.org>
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

commit 6dbda2d00d466225f9db1dc695ff852443f28832 upstream.

The code to allow EAPOL frames even when the station
isn't yet marked associated needs to check that the
incoming frame is long enough and due to paged RX it
also can't assume skb->data contains the right data,
it must use skb_copy_bits(). Fix this to avoid using
data that doesn't really exist.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -874,14 +874,16 @@ ieee80211_rx_h_check(struct ieee80211_rx
 		 */
 		if (rx->sta && rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
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
 


