Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695Ab2KZRLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:11:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933680Ab2KZRLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 185/270] mac80211: use ieee80211_free_txskb in a few more places
Date: Mon, 26 Nov 2012 14:57:55 -0200
Message-Id: <1353949160-26803-186-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit d4fa14cd62bd078c8e3ef39283b9f237e5b2ff0f upstream.

Free tx status skbs when draining power save buffers, pending frames, or
when tearing down a vif.
Fixes remaining conditions that can lead to hostapd/wpa_supplicant hangs when
running out of socket write memory.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/iface.c    |    2 +-
 net/mac80211/sta_info.c |    4 ++--
 net/mac80211/util.c     |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8664111..4b4d9c5 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -711,7 +711,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 			if (info->control.vif == &sdata->vif) {
 				__skb_unlink(skb, &local->pending[i]);
-				dev_kfree_skb_irq(skb);
+				ieee80211_free_txskb(&local->hw, skb);
 			}
 		}
 	}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index de455f8..277bd96 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -591,7 +591,7 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 		 */
 		if (!skb)
 			break;
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 	}
 
 	/*
@@ -622,7 +622,7 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 		printk(KERN_DEBUG "Buffered frame expired (STA %pM)\n",
 		       sta->sta.addr);
 #endif
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 	}
 
 	/*
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f564b5e..92d84f5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -400,7 +400,7 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 	int queue = info->hw_queue;
 
 	if (WARN_ON(!info->control.vif)) {
-		kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 		return;
 	}
 
@@ -425,7 +425,7 @@ void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		if (WARN_ON(!info->control.vif)) {
-			kfree_skb(skb);
+			ieee80211_free_txskb(&local->hw, skb);
 			continue;
 		}
 
-- 
1.7.9.5

