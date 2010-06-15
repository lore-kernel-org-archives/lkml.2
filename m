Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0FOW3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 18:29:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46134 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab0FOW3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 18:29:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 3/3] idr: fix RCU lockdep splat in idr_get_next()
Date: Tue, 15 Jun 2010 15:29:43 -0700
Message-Id: <1276640983-14641-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100615222923.GA14571@linux.vnet.ibm.com>
References: <20100615222923.GA14571@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to rcu_dereference_raw() given that many callers may have many
different locking models.

Located-by: Miles Lane <miles.lane@gmail.com>
Tested-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 lib/idr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index c1a2069..7f1a4f0 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -602,7 +602,7 @@ void *idr_get_next(struct idr *idp, int *nextidp)
 	/* find first ent */
 	n = idp->layers * IDR_BITS;
 	max = 1 << n;
-	p = rcu_dereference(idp->top);
+	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
 
@@ -610,7 +610,7 @@ void *idr_get_next(struct idr *idp, int *nextidp)
 		while (n > 0 && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
-			p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
+			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
 		}
 
 		if (p) {
-- 
1.7.0.6

