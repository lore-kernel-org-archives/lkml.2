Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992752Ab2KOEuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:50:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:48281 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353Ab2KOEKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:10:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Javier Cardona <javier@cozybit.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 05/38] wireless: drop invalid mesh address extension frames
Date: Wed, 14 Nov 2012 20:10:02 -0800
Message-Id: <20121115040933.247418631@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040932.918082372@linuxfoundation.org>
References: <20121115040932.918082372@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 7dd111e8ee10cc6816669eabcad3334447673236 upstream.

The mesh header can have address extension by a 4th
or a 5th and 6th address, but never both. Drop such
frames in 802.11 -> 802.3 conversion along with any
frames that have the wrong extension.

Reviewed-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/util.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -298,18 +298,15 @@ EXPORT_SYMBOL(ieee80211_get_hdrlen_from_
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
 
@@ -359,6 +356,8 @@ int ieee80211_data_to_8023(struct sk_buf
 			/* make sure meshdr->flags is on the linear part */
 			if (!pskb_may_pull(skb, hdrlen + 1))
 				return -1;
+			if (meshdr->flags & MESH_FLAGS_AE_A4)
+				return -1;
 			if (meshdr->flags & MESH_FLAGS_AE_A5_A6) {
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),
@@ -383,6 +382,8 @@ int ieee80211_data_to_8023(struct sk_buf
 			/* make sure meshdr->flags is on the linear part */
 			if (!pskb_may_pull(skb, hdrlen + 1))
 				return -1;
+			if (meshdr->flags & MESH_FLAGS_AE_A5_A6)
+				return -1;
 			if (meshdr->flags & MESH_FLAGS_AE_A4)
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),


