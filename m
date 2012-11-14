Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2KNFyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:54:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55299 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459Ab2KNFvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:11 -0500
Message-Id: <20121114053937.358038488@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:58 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Javier Cardona <javier@cozybit.com>,
        Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 25/82] mac80211: Only process mesh config header on frames that RA_MATCH
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit 555cb715be8ef98b8ec362b23dfc254d432a35b1 upstream.

Doing otherwise is wrong, and may wreak havoc on the mpp tables,
specially if the frame is encrypted.

Reported-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.2: we have a large block conditional on
 IEEE80211_RX_RA_MATCH rather than a goto conditional on the opposite,
 so delete the condition]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1895,7 +1895,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 	    mesh_rmc_check(hdr->addr3, mesh_hdr, rx->sdata))
 		return RX_DROP_MONITOR;
 
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    !(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	if (!mesh_hdr->ttl)
@@ -1941,7 +1942,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 	mesh_hdr->ttl--;
 
-	if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
+	{
 		if (!mesh_hdr->ttl)
 			IEEE80211_IFSTA_MESH_CTR_INC(&rx->sdata->u.mesh,
 						     dropped_frames_ttl);


