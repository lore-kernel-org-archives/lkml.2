Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2LMOBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:01:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44004 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab2LMOBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 014/241] mac80211: make sure data is accessible in EAPOL check
Date: Thu, 13 Dec 2012 11:56:19 -0200
Message-Id: <1355407206-17100-15-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/rx.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4fd5369..064384c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -874,14 +874,16 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 		 */
 		if (rx->sta && rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
 		    ieee80211_is_data_present(hdr->frame_control)) {
-			u16 ethertype;
-			u8 *payload;
-
-			payload = rx->skb->data +
-				ieee80211_hdrlen(hdr->frame_control);
-			ethertype = (payload[6] << 8) | payload[7];
-			if (cpu_to_be16(ethertype) ==
-			    rx->sdata->control_port_protocol)
+			unsigned int hdrlen;
+			__be16 ethertype;
+
+			hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+			if (rx->skb->len < hdrlen + 8)
+				return RX_DROP_MONITOR;
+
+			skb_copy_bits(rx->skb, hdrlen + 6, &ethertype, 2);
+			if (ethertype == rx->sdata->control_port_protocol)
 				return RX_CONTINUE;
 		}
 
-- 
1.7.9.5

