Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2LCO50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:57:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43571 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932107Ab2LCOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:47 -0500
Message-Id: <20121203143147.274474404@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:31:50 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arik Nemtsov <arik@wizery.com>, Ido Yariv <ido@wizery.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 04/89] mac80211: sync acccess to tx_filtered/ps_tx_buf queues
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/sta_info.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 797dd36..89ccd3e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -961,6 +961,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff_head pending;
 	int filtered = 0, buffered = 0, ac;
+	unsigned long flags;
 
 	clear_sta_flag(sta, WLAN_STA_SP);
 
@@ -976,12 +977,16 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
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


