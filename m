Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2ANUwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:52:21 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14894 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab2ANUwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:52:18 -0500
Date: Sat, 14 Jan 2012 21:52:17 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: netdev@vger.kernel.org
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] Net, mac80211: Fix resource leak in
 ieee80211_rx_h_mesh_fwding()
Message-ID: <alpine.LNX.2.00.1201142149250.11547@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We may leak the 'fwd_skb' we skb_copy() in ieee80211_rx_h_mesh_fwding() if 
we take the 'else' branch in the 'if' statement just below. If we take 
that branch we'll end up returning from the function and since we've not 
assigned 'fwd_skb' to anything at that point, we leak it when the variable 
goes out of scope.

The simple fix seems to be to just kfree_skb(fwd_skb); just before we
return. That is what this patch does.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 net/mac80211/rx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

 note: patch is only compile tested.

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f407427..7514091 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1979,6 +1979,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		mesh_path_error_tx(ifmsh->mshcfg.element_ttl, fwd_hdr->addr3,
 				    0, reason, fwd_hdr->addr2, sdata);
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_no_route);
+		kfree_skb(fwd_skb);
 		return RX_DROP_MONITOR;
 	}
 
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

