Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2KNFxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:53:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55284 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756474Ab2KNFvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:12 -0500
Message-Id: <20121114053937.902242540@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:02 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        Javier Cardona <javier@cozybit.com>
Subject: [ 29/82] wireless: drop invalid mesh address extension frames
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

commit 7dd111e8ee10cc6816669eabcad3334447673236 upstream.

The mesh header can have address extension by a 4th
or a 5th and 6th address, but never both. Drop such
frames in 802.11 -> 802.3 conversion along with any
frames that have the wrong extension.

Reviewed-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/util.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index ef35f4e..45a09de 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -312,18 +312,15 @@ EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 static int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 {
 	int ae = meshhdr->flags & MESH_FLAGS_AE;
-	/* 7.1.3.5a.2 */
+	/* 802.11-2012, 8.2.4.7.3 */
 	switch (ae) {
+	default:
 	case 0:
 		return 6;
 	case MESH_FLAGS_AE_A4:
 		return 12;
 	case MESH_FLAGS_AE_A5_A6:
 		return 18;
-	case (MESH_FLAGS_AE_A4 | MESH_FLAGS_AE_A5_A6):
-		return 24;
-	default:
-		return 6;
 	}
 }
 
@@ -373,6 +370,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 			/* make sure meshdr->flags is on the linear part */
 			if (!pskb_may_pull(skb, hdrlen + 1))
 				return -1;
+			if (meshdr->flags & MESH_FLAGS_AE_A4)
+				return -1;
 			if (meshdr->flags & MESH_FLAGS_AE_A5_A6) {
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),
@@ -397,6 +396,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 			/* make sure meshdr->flags is on the linear part */
 			if (!pskb_may_pull(skb, hdrlen + 1))
 				return -1;
+			if (meshdr->flags & MESH_FLAGS_AE_A5_A6)
+				return -1;
 			if (meshdr->flags & MESH_FLAGS_AE_A4)
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),


