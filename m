Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab1EAN1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:27:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38411 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 69/86] net/mac80211,rcu: convert call_rcu(work_free_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:49 -0700
Message-Id: <1304256126-26015-69-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback work_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(work_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/mac80211/work.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index e73c8ca..ac35496 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -65,17 +65,9 @@ static void run_again(struct ieee80211_local *local,
 		mod_timer(&local->work_timer, timeout);
 }
 
-static void work_free_rcu(struct rcu_head *head)
-{
-	struct ieee80211_work *wk =
-		container_of(head, struct ieee80211_work, rcu_head);
-
-	kfree(wk);
-}
-
 void free_work(struct ieee80211_work *wk)
 {
-	call_rcu(&wk->rcu_head, work_free_rcu);
+	kfree_rcu(wk, rcu_head);
 }
 
 static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
-- 
1.7.3.2

