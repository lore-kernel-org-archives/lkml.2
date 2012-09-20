Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2ITSwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:52:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44704 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2ITStf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:49:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Dimitri Sivanich <sivanich@sgi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/23] rcu: Segregate rcu_state fields to improve cache locality
Date: Thu, 20 Sep 2012 11:48:05 -0700
Message-Id: <1348166900-18716-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-7606-0000-0000-000003D6EB8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dimitri Sivanich <sivanich@sgi.com>

The fields in the rcu_state structure that are protected by the
root rcu_node structure's ->lock can share a cache line with the
fields protected by ->onofflock.  This can result in excessive
memory contention on large systems, so this commit applies
____cacheline_internodealigned_in_smp to the ->onofflock field in
order to segregate them.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index effb273..5d92b80 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -394,7 +394,8 @@ struct rcu_state {
 
 	/* End of fields guarded by root rcu_node's lock. */
 
-	raw_spinlock_t onofflock;		/* exclude on/offline and */
+	raw_spinlock_t onofflock ____cacheline_internodealigned_in_smp;
+						/* exclude on/offline and */
 						/*  starting new GP. */
 	struct rcu_head *orphan_nxtlist;	/* Orphaned callbacks that */
 						/*  need a grace period. */
-- 
1.7.8

