Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2LMPLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:11:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43965 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2LMOBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Javier Cardona <javier@cozybit.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 006/241] mac80211: Only process mesh config header on frames that RA_MATCH
Date: Thu, 13 Dec 2012 11:56:11 -0200
Message-Id: <1355407206-17100-7-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit 555cb715be8ef98b8ec362b23dfc254d432a35b1 upstream.

Doing otherwise is wrong, and may wreak havoc on the mpp tables,
specially if the frame is encrypted.

Reported-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/rx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 965e6ec..33c49d5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1900,7 +1900,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    mesh_rmc_check(hdr->addr3, mesh_hdr, rx->sdata))
 		return RX_DROP_MONITOR;
 
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    !(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	if (!mesh_hdr->ttl)
@@ -1944,9 +1945,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	}
 	skb_set_queue_mapping(skb, q);
 
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-		goto out;
-
 	if (!--mesh_hdr->ttl) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
 		return RX_DROP_MONITOR;
-- 
1.7.9.5

