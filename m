Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1ARTAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:00:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42897 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab1ARTAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:00:12 -0500
Date: Tue, 18 Jan 2011 19:59:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110118185949.GA9382@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Oleg Nesterov (2):
      perf: Find_get_context: fix the per-cpu-counter check
      perf: Validate cpu early in perf_event_alloc()

Peter Zijlstra (1):
      perf: Fix contexted inheritance


 kernel/perf_event.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b782b7a..67d9bd7 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2228,14 +2228,11 @@ find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 	unsigned long flags;
 	int ctxn, err;
 
-	if (!task && cpu != -1) {
+	if (!task) {
 		/* Must be root to operate on a CPU event: */
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
-		if (cpu < 0 || cpu >= nr_cpumask_bits)
-			return ERR_PTR(-EINVAL);
-
 		/*
 		 * We could be clever and allow to attach a event to an
 		 * offline CPU and activate it when the CPU comes up, but
@@ -5541,6 +5538,11 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	struct hw_perf_event *hwc;
 	long err;
 
+	if ((unsigned)cpu >= nr_cpu_ids) {
+		if (!task || cpu != -1)
+			return ERR_PTR(-EINVAL);
+	}
+
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)
 		return ERR_PTR(-ENOMEM);
@@ -5589,7 +5591,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	if (!overflow_handler && parent_event)
 		overflow_handler = parent_event->overflow_handler;
-	
+
 	event->overflow_handler	= overflow_handler;
 
 	if (attr->disabled)
@@ -6494,7 +6496,6 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 
 	raw_spin_lock_irqsave(&parent_ctx->lock, flags);
 	parent_ctx->rotate_disable = 0;
-	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
 
 	child_ctx = child->perf_event_ctxp[ctxn];
 
@@ -6502,12 +6503,11 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
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
@@ -6518,6 +6518,7 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 		get_ctx(child_ctx->parent_ctx);
 	}
 
+	raw_spin_unlock_irqrestore(&parent_ctx->lock, flags);
 	mutex_unlock(&parent_ctx->mutex);
 
 	perf_unpin_context(parent_ctx);
