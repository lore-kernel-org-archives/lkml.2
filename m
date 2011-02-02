Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1BBAqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:46:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:35951 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab1BBAp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382961104"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: sgruszka@redhat.com, johannes.berg@intel.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [136/139] [PATCH 2.6.35] mac80211: fix hard lockup in
Message-Id: <20110202004536.12F023E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Problem is 2.6.35 specific, bug was introduced in backport
of upstream 44271488b91c9eecf249e075a1805dd887e222d2 commit.

We can not call del_timer_sync(addba_resp_timer) from
___ieee80211_stop_tx_ba_session(), as this function can be called from
that timer callback. To fix, simply use not synchronous del_timer().

Resolve https://bugzilla.redhat.com/show_bug.cgi?id=667459

Reported-and-tested-by: Mathieu Chouquet-Stringer <mathieu-acct@csetco.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/agg-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: linux-2.6.35.y/net/mac80211/agg-tx.c
===================================================================
--- linux-2.6.35.y.orig/net/mac80211/agg-tx.c
+++ linux-2.6.35.y/net/mac80211/agg-tx.c
@@ -138,7 +138,7 @@ int ___ieee80211_stop_tx_ba_session(stru
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	del_timer_sync(&tid_tx->addba_resp_timer);
+	del_timer(&tid_tx->addba_resp_timer);
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
