Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab1LGQWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:22:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933527Ab1LGQWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:18 2011
Message-Id: <20111207161218.387461686@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:46 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [044/104] mac80211: dont stop a single aggregation session twice
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 24f50a9d165745fd0701c6e089d35f58a229ea69 upstream.

Nikolay noticed (by code review) that mac80211 can
attempt to stop an aggregation session while it is
already being stopped. So to fix it, check whether
stop is already being done and bail out if so.

Also move setting the STOPPING state into the lock
so things are properly atomic.

Reported-by: Nikolay Martynov <mar.kolya@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/agg-tx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -162,6 +162,12 @@ int ___ieee80211_stop_tx_ba_session(stru
 		return -ENOENT;
 	}
 
+	/* if we're already stopping ignore any new requests to stop */
+	if (test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
+		spin_unlock_bh(&sta->lock);
+		return -EALREADY;
+	}
+
 	if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/* not even started yet! */
 		ieee80211_assign_tid_tx(sta, tid, NULL);
@@ -170,6 +176,8 @@ int ___ieee80211_stop_tx_ba_session(stru
 		return 0;
 	}
 
+	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
+
 	spin_unlock_bh(&sta->lock);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -177,8 +185,6 @@ int ___ieee80211_stop_tx_ba_session(stru
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
-
 	del_timer_sync(&tid_tx->addba_resp_timer);
 
 	/*


