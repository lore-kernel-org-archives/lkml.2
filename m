Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab2LMOxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:53:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44323 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab2LMOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arik Nemtsov <arik@wizery.com>, Ido Yariv <ido@wizery.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 077/241] mac80211: sync acccess to tx_filtered/ps_tx_buf queues
Date: Thu, 13 Dec 2012 11:57:22 -0200
Message-Id: <1355407206-17100-78-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arik Nemtsov <arik@wizery.com>

commit 987c285c2ae2e4e32aca3a9b3252d28171c75711 upstream.

These are accessed without a lock when ending STA PSM. If the
sta_cleanup timer accesses these lists at the same time, we might crash.

This may fix some mysterious crashes we had during
ieee80211_sta_ps_deliver_wakeup.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/sta_info.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 277bd96..343484c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -959,6 +959,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff_head pending;
 	int filtered = 0, buffered = 0, ac;
+	unsigned long flags;
 
 	clear_sta_flag(sta, WLAN_STA_SP);
 
@@ -974,12 +975,16 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		int count = skb_queue_len(&pending), tmp;
 
+		spin_lock_irqsave(&sta->tx_filtered[ac].lock, flags);
 		skb_queue_splice_tail_init(&sta->tx_filtered[ac], &pending);
+		spin_unlock_irqrestore(&sta->tx_filtered[ac].lock, flags);
 		tmp = skb_queue_len(&pending);
 		filtered += tmp - count;
 		count = tmp;
 
+		spin_lock_irqsave(&sta->ps_tx_buf[ac].lock, flags);
 		skb_queue_splice_tail_init(&sta->ps_tx_buf[ac], &pending);
+		spin_unlock_irqrestore(&sta->ps_tx_buf[ac].lock, flags);
 		tmp = skb_queue_len(&pending);
 		buffered += tmp - count;
 	}
-- 
1.7.9.5

