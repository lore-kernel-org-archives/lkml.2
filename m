Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1DVMWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:22:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:57118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab1DVMWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:22:34 -0400
Date: Fri, 22 Apr 2011 12:22:12 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-e0944ee63f7249802be74454cef81c97630ae1cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110421014300.727863282@goodmis.org>
References: <20110421014300.727863282@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Remove cmpxchg to update nr_chain_hlocks
Git-Commit-ID: e0944ee63f7249802be74454cef81c97630ae1cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Apr 2011 12:22:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0944ee63f7249802be74454cef81c97630ae1cd
Gitweb:     http://git.kernel.org/tip/e0944ee63f7249802be74454cef81c97630ae1cd
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 20 Apr 2011 21:42:00 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Apr 2011 11:06:59 +0200

lockdep: Remove cmpxchg to update nr_chain_hlocks

For some reason nr_chain_hlocks is updated with cmpxchg, but
this is performed inside of the lockdep global "grab_lock()",
which also makes simple modification of this variable atomic.

Remove the cmpxchg logic for updating nr_chain_hlocks and
simplify the code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110421014300.727863282@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 27c609f..63437d0 100644
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
