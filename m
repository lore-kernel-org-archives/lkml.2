Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395Ab2J2ViH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:38:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:47919 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761356Ab2J2Vhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 080/101] mac80211: use ieee80211_free_txskb in a few more places
Date: Mon, 29 Oct 2012 14:35:33 -0700
Message-Id: <20121029213249.188623266@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit d4fa14cd62bd078c8e3ef39283b9f237e5b2ff0f upstream.

Free tx status skbs when draining power save buffers, pending frames, or
when tearing down a vif.
Fixes remaining conditions that can lead to hostapd/wpa_supplicant hangs when
running out of socket write memory.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/iface.c    |    2 +-
 net/mac80211/sta_info.c |    4 ++--
 net/mac80211/util.c     |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -822,7 +822,7 @@ static void ieee80211_do_stop(struct iee
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 			if (info->control.vif == &sdata->vif) {
 				__skb_unlink(skb, &local->pending[i]);
-				dev_kfree_skb_irq(skb);
+				ieee80211_free_txskb(&local->hw, skb);
 			}
 		}
 	}
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -585,7 +585,7 @@ static bool sta_info_cleanup_expire_buff
 		 */
 		if (!skb)
 			break;
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 	}
 
 	/*
@@ -614,7 +614,7 @@ static bool sta_info_cleanup_expire_buff
 		local->total_ps_buffered--;
 		ps_dbg(sta->sdata, "Buffered frame expired (STA %pM)\n",
 		       sta->sta.addr);
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 	}
 
 	/*
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -400,7 +400,7 @@ void ieee80211_add_pending_skb(struct ie
 	int queue = info->hw_queue;
 
 	if (WARN_ON(!info->control.vif)) {
-		kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 		return;
 	}
 
@@ -425,7 +425,7 @@ void ieee80211_add_pending_skbs_fn(struc
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		if (WARN_ON(!info->control.vif)) {
-			kfree_skb(skb);
+			ieee80211_free_txskb(&local->hw, skb);
 			continue;
 		}
 


