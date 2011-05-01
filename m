Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab1EAN0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:26:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38421 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab1EANWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:38 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 66/86] perf,rcu: convert call_rcu(swevent_hlist_release_rcu) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:46 -0700
Message-Id: <1304256126-26015-66-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback swevent_hlist_release_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(swevent_hlist_release_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/perf_event.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 865c6f7..6536a03 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5311,14 +5311,6 @@ swevent_hlist_deref(struct swevent_htable *swhash)
 					 lockdep_is_held(&swhash->hlist_mutex));
 }
 
-static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
-{
-	struct swevent_hlist *hlist;
-
-	hlist = container_of(rcu_head, struct swevent_hlist, rcu_head);
-	kfree(hlist);
-}
-
 static void swevent_hlist_release(struct swevent_htable *swhash)
 {
 	struct swevent_hlist *hlist = swevent_hlist_deref(swhash);
@@ -5327,7 +5319,7 @@ static void swevent_hlist_release(struct swevent_htable *swhash)
 		return;
 
 	rcu_assign_pointer(swhash->swevent_hlist, NULL);
-	call_rcu(&hlist->rcu_head, swevent_hlist_release_rcu);
+	kfree_rcu(hlist, rcu_head);
 }
 
 static void swevent_hlist_put_cpu(struct perf_event *event, int cpu)
-- 
1.7.3.2

