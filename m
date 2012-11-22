Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2KVWJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:09:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:49610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab2KVSkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Arik Nemtsov <arik@wizery.com>, Ido Yariv <ido@wizery.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 003/171] mac80211: sync acccess to tx_filtered/ps_tx_buf queues
Date: Wed, 21 Nov 2012 16:39:09 -0800
Message-Id: <20121122004033.648209810@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/sta_info.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -959,6 +959,7 @@ void ieee80211_sta_ps_deliver_wakeup(str
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff_head pending;
 	int filtered = 0, buffered = 0, ac;
+	unsigned long flags;
 
 	clear_sta_flag(sta, WLAN_STA_SP);
 
@@ -974,12 +975,16 @@ void ieee80211_sta_ps_deliver_wakeup(str
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


