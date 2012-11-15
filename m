Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993314Ab2KOEWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:22:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:49755 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993105Ab2KOEMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 19/57] mac80211: verify that skb data is present
Date: Wed, 14 Nov 2012 20:11:27 -0800
Message-Id: <20121115040934.403092268@linuxfoundation.org>
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

commit 9b395bc3be1cebf0144a127c7e67d56dbdac0930 upstream.

A number of places in the mesh code don't check that
the frame data is present and in the skb header when
trying to access. Add those checks and the necessary
pskb_may_pull() calls. This prevents accessing data
that doesn't actually exist.

To do this, export ieee80211_get_mesh_hdrlen() to be
able to use it in mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/cfg80211.h |    9 +++++++++
 net/mac80211/rx.c      |   32 +++++++++++++++++++++++++++++++-
 net/wireless/util.c    |    3 ++-
 3 files changed, 42 insertions(+), 2 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2480,6 +2480,15 @@ unsigned int ieee80211_get_hdrlen_from_s
 unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc);
 
 /**
+ * ieee80211_get_mesh_hdrlen - get mesh extension header length
+ * @meshhdr: the mesh extension header, only the flags field
+ *	(first byte) will be accessed
+ * Returns the length of the extension header, which is always at
+ * least 6 bytes and at most 18 if address 5 and 6 are present.
+ */
+unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
+
+/**
  * DOC: Data path helpers
  *
  * In addition to generic utilities, cfg80211 also offers
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -513,6 +513,11 @@ ieee80211_rx_mesh_check(struct ieee80211
 
 		if (ieee80211_is_action(hdr->frame_control)) {
 			u8 category;
+
+			/* make sure category field is present */
+			if (rx->skb->len < IEEE80211_MIN_ACTION_SIZE)
+				return RX_DROP_MONITOR;
+
 			mgmt = (struct ieee80211_mgmt *)hdr;
 			category = mgmt->u.action.category;
 			if (category != WLAN_CATEGORY_MESH_ACTION &&
@@ -1895,6 +1900,20 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	/* make sure fixed part of mesh header is there, also checks skb len */
+	if (!pskb_may_pull(rx->skb, hdrlen + 6))
+		return RX_DROP_MONITOR;
+
+	mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
+
+	/* make sure full mesh header is there, also checks skb len */
+	if (!pskb_may_pull(rx->skb,
+			   hdrlen + ieee80211_get_mesh_hdrlen(mesh_hdr)))
+		return RX_DROP_MONITOR;
+
+	/* reload pointers */
+	hdr = (struct ieee80211_hdr *) skb->data;
 	mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
 
 	/* frame is in RMC, don't forward */
@@ -1918,9 +1937,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 		if (is_multicast_ether_addr(hdr->addr1)) {
 			mpp_addr = hdr->addr3;
 			proxied_addr = mesh_hdr->eaddr1;
-		} else {
+		} else if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
+			/* has_a4 already checked in ieee80211_rx_mesh_check */
 			mpp_addr = hdr->addr4;
 			proxied_addr = mesh_hdr->eaddr2;
+		} else {
+			return RX_DROP_MONITOR;
 		}
 
 		rcu_read_lock();
@@ -2362,6 +2384,10 @@ ieee80211_rx_h_action(struct ieee80211_r
 		}
 		break;
 	case WLAN_CATEGORY_SELF_PROTECTED:
+		if (len < (IEEE80211_MIN_ACTION_SIZE +
+			   sizeof(mgmt->u.action.u.self_prot.action_code)))
+			break;
+
 		switch (mgmt->u.action.u.self_prot.action_code) {
 		case WLAN_SP_MESH_PEERING_OPEN:
 		case WLAN_SP_MESH_PEERING_CLOSE:
@@ -2380,6 +2406,10 @@ ieee80211_rx_h_action(struct ieee80211_r
 		}
 		break;
 	case WLAN_CATEGORY_MESH_ACTION:
+		if (len < (IEEE80211_MIN_ACTION_SIZE +
+			   sizeof(mgmt->u.action.u.mesh_action.action_code)))
+			break;
+
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
 		if (mesh_action_is_path_sel(mgmt) &&
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -290,7 +290,7 @@ unsigned int ieee80211_get_hdrlen_from_s
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
-static int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
+unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 {
 	int ae = meshhdr->flags & MESH_FLAGS_AE;
 	/* 802.11-2012, 8.2.4.7.3 */
@@ -304,6 +304,7 @@ static int ieee80211_get_mesh_hdrlen(str
 		return 18;
 	}
 }
+EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen);
 
 int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 			   enum nl80211_iftype iftype)


