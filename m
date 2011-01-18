Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1ARTHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:07:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:53136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab1ARTHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:07:30 -0500
Date: Tue, 18 Jan 2011 19:06:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix contexted inheritance
Message-ID: <tip-c5ed5145591774bd9a2960ba4ca45a02fc70aad1@git.kernel.org>
Git-Commit-ID: c5ed5145591774bd9a2960ba4ca45a02fc70aad1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:06:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5ed5145591774bd9a2960ba4ca45a02fc70aad1
Gitweb:     http://git.kernel.org/tip/c5ed5145591774bd9a2960ba4ca45a02fc70aad1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 17 Jan 2011 13:45:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 15:10:35 +0100

perf: Fix contexted inheritance

Linus reported that the RCU lockdep annotation bits triggered for this
rcu_dereference() because we're not holding rcu_read_lock().

Going over the code I cannot convince myself its correct:

 - holding a ref on the parent_ctx, doesn't avoid it being uncloned
   concurrently (as the comment says), so we can race with a free.

 - holding parent_ctx->mutex doesn't avoid the above free from taking
   place either, it would at best avoid parent_ctx from being freed.

I.e. the warning is correct. To fix the bug, serialize against the
unclone_ctx() call by extending the reach of the parent_ctx->lock.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b782b7a..76be4c7 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6494,7 +6494,6 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 
 	raw_spin_lock_irqsave(&parent_ctx->lock, flags);
 	parent_ctx->rotate_disable = 0;
-	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
 
 	child_ctx = child->perf_event_ctxp[ctxn];
 
@@ -6502,12 +6501,11 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 		/*
 		 * Mark the child context as a clone of the parent
 		 * context, or of whatever the parent is a clone of.
-		 * Note that if the parent is a clone, it could get
-		 * uncloned at any point, but that doesn't matter
-		 * because the list of events and the generation
-		 * count can't have changed since we took the mutex.
+		 *
+		 * Note that if the parent is a clone, the holding of
+		 * parent_ctx->lock avoids it from being uncloned.
 		 */
-		cloned_ctx = rcu_dereference(parent_ctx->parent_ctx);
+		cloned_ctx = parent_ctx->parent_ctx;
 		if (cloned_ctx) {
 			child_ctx->parent_ctx = cloned_ctx;
 			child_ctx->parent_gen = parent_ctx->parent_gen;
@@ -6518,6 +6516,7 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 		get_ctx(child_ctx->parent_ctx);
 	}
 
+	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
 	mutex_unlock(&parent_ctx->mutex);
 
 	perf_unpin_context(parent_ctx);
