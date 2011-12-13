Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1LMAnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:43:42 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60306 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab1LMAmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:42:35 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 5/6] rcu: Apply ACCESS_ONCE() to rcu_boost() return value
Date: Mon, 12 Dec 2011 16:42:23 -0800
Message-Id: <1323736944-32575-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20111213004144.GA32120@linux.vnet.ibm.com>
 <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
x-cbid: 11121300-1780-0000-0000-0000019582D7
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000240; HX=3.00000179; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00095600; UDB=6.00024991; UTC=2011-12-13
 00:42:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Both TINY_RCU's and TREE_RCU's implementations of rcu_boost() access
the ->boost_tasks and ->exp_tasks fields without preventing concurrent
changes to these fields.  This commit therefore applies ACCESS_ONCE in
order to prevent compiler mischief.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny_plugin.h |    4 ++--
 kernel/rcutree_plugin.h |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index dfa97cb..9cb1ae4 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -312,8 +312,8 @@ static int rcu_boost(void)
 	rt_mutex_lock(&mtx);
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 
-	return rcu_preempt_ctrlblk.boost_tasks != NULL ||
-	       rcu_preempt_ctrlblk.exp_tasks != NULL;
+	return ACCESS_ONCE(rcu_preempt_ctrlblk.boost_tasks) != NULL ||
+	       ACCESS_ONCE(rcu_preempt_ctrlblk.exp_tasks) != NULL;
 }
 
 /*
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f55f10b..8bb35d7 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1232,7 +1232,8 @@ static int rcu_boost(struct rcu_node *rnp)
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 
-	return rnp->exp_tasks != NULL || rnp->boost_tasks != NULL;
+	return ACCESS_ONCE(rnp->exp_tasks) != NULL ||
+	       ACCESS_ONCE(rnp->boost_tasks) != NULL;
 }
 
 /*
-- 
1.7.8

