Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab2KOEYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:24:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:49705 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993195Ab2KOEM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
        Javier Cardona <javier@cozybit.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 14/57] mac80211: Only process mesh config header on frames that RA_MATCH
Date: Wed, 14 Nov 2012 20:11:22 -0800
Message-Id: <20121115040934.093170093@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit 555cb715be8ef98b8ec362b23dfc254d432a35b1 upstream.

Doing otherwise is wrong, and may wreak havoc on the mpp tables,
specially if the frame is encrypted.

Reported-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1900,7 +1900,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 	    mesh_rmc_check(hdr->addr3, mesh_hdr, rx->sdata))
 		return RX_DROP_MONITOR;
 
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    !(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	if (!mesh_hdr->ttl)
@@ -1944,9 +1945,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 	}
 	skb_set_queue_mapping(skb, q);
 
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-		goto out;
-
 	if (!--mesh_hdr->ttl) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
 		return RX_DROP_MONITOR;


