Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0LMAaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:30:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44694 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab0LLXpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:23 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: johannes.berg@intel.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [26/223] mac80211: delete AddBA response timer
Message-Id: <20101212234522.3A42BB27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Johannes Berg <johannes.berg@intel.com>

commit 44271488b91c9eecf249e075a1805dd887e222d2 upstream.

We never delete the addBA response timer, which
is typically fine, but if the station it belongs
to is deleted very quickly after starting the BA
session, before the peer had a chance to reply,
the timer may fire after the station struct has
been freed already. Therefore, we need to delete
the timer in a suitable spot -- best when the
session is being stopped (which will happen even
then) in which case the delete will be a no-op
most of the time.

I've reproduced the scenario and tested the fix.

This fixes the crash reported at
http://mid.gmane.org/4CAB6F96.6090701@candelatech.com

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/agg-tx.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/net/mac80211/agg-tx.c
===================================================================
--- linux.orig/net/mac80211/agg-tx.c
+++ linux/net/mac80211/agg-tx.c
@@ -128,6 +128,7 @@ void ieee80211_send_bar(struct ieee80211
 int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_back_parties initiator)
 {
+	struct tid_ampdu_tx *tid_tx = sta->ampdu_mlme.tid_tx[tid];
 	struct ieee80211_local *local = sta->local;
 	int ret;
 	u8 *state;
@@ -137,6 +138,8 @@ int ___ieee80211_stop_tx_ba_session(stru
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
+	del_timer_sync(&tid_tx->addba_resp_timer);
+
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
 	if (*state == HT_AGG_STATE_OPERATIONAL)
