Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1DUBnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:43:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38817 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1DUBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:43:03 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=vhdKIqpQuCYA:10 a=8uxOuijaIM0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ha317GOFRB7g1sy2eK8A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421014300.727863282@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 21:42:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 7/7] lockdep: Remove cmpxchg to update nr_chain_hlocks
References: <20110421014153.126662477@goodmis.org>
Content-Disposition: inline; filename=0007-lockdep-Remove-cmpxchg-to-update-nr_chain_hlocks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

For some reason nr_chain_hlocks is updated with cmpxchg, but this
is performed inside of the lockdep global "grab_lock()", which also
makes simple modification of this variable atomic.

Remove the cmpxchg logic for updating nr_chain_hlocks and simplify
the code.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/lockdep.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3b1ac92..60bce52 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1973,7 +1973,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
 	struct held_lock *hlock_curr, *hlock_next;
-	int i, j, n, cn;
+	int i, j;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
@@ -2033,15 +2033,9 @@ cache_hit:
 	}
 	i++;
 	chain->depth = curr->lockdep_depth + 1 - i;
-	cn = nr_chain_hlocks;
-	while (cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS) {
-		n = cmpxchg(&nr_chain_hlocks, cn, cn + chain->depth);
-		if (n == cn)
-			break;
-		cn = n;
-	}
-	if (likely(cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS)) {
-		chain->base = cn;
+	if (likely(nr_chain_hlocks + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS)) {
+		chain->base = nr_chain_hlocks;
+		nr_chain_hlocks += chain->depth;
 		for (j = 0; j < chain->depth - 1; j++, i++) {
 			int lock_id = curr->held_locks[i].class_idx - 1;
 			chain_hlocks[chain->base + j] = lock_id;
-- 
1.7.2.3


