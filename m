Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1CREMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:12:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65167 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab1CREM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:12:29 -0400
Message-ID: <4D82DC17.2090106@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:14:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 35/36] net/mac80211,rcu: convert call_rcu(work_free_rcu) to
 kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:11:06,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:11:07,
	Serialize complete at 2011-03-18 12:11:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback work_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(work_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/mac80211/work.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 36305e0..dcc433e 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -66,17 +66,9 @@ static void run_again(struct ieee80211_local *local,
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
1.7.4
