Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab1DPKEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 06:04:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42257 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1DPKEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 06:04:01 -0400
Date: Sat, 16 Apr 2011 12:03:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110416100342.GA10034@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
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
Eric Dumazet (1):
      perf: Fix a build error with some GCC versions

Stephane Eranian (1):
      perf_event: Fix cgrp event scheduling bug in perf_enable_on_exec()


 kernel/perf_event.c      |   12 ++++++++++++
 tools/perf/util/cgroup.c |    2 +-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 27960f1..8e81a98 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -364,6 +364,7 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 			}
 
 			if (mode & PERF_CGROUP_SWIN) {
+				WARN_ON_ONCE(cpuctx->cgrp);
 				/* set cgrp before ctxsw in to
 				 * allow event_filter_match() to not
 				 * have to pass task around
@@ -2423,6 +2424,14 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	if (!ctx || !ctx->nr_events)
 		goto out;
 
+	/*
+	 * We must ctxsw out cgroup events to avoid conflict
+	 * when invoking perf_task_event_sched_in() later on
+	 * in this function. Otherwise we end up trying to
+	 * ctxswin cgroup events which are already scheduled
+	 * in.
+	 */
+	perf_cgroup_sched_out(current);
 	task_ctx_sched_out(ctx, EVENT_ALL);
 
 	raw_spin_lock(&ctx->lock);
@@ -2447,6 +2456,9 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 
 	raw_spin_unlock(&ctx->lock);
 
+	/*
+	 * Also calls ctxswin for cgroup events, if any:
+	 */
 	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 9fea755..96bee5c 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -13,7 +13,7 @@ cgroupfs_find_mountpoint(char *buf, size_t maxlen)
 {
 	FILE *fp;
 	char mountpoint[MAX_PATH+1], tokens[MAX_PATH+1], type[MAX_PATH+1];
-	char *token, *saved_ptr;
+	char *token, *saved_ptr = NULL;
 	int found = 0;
 
 	fp = fopen("/proc/mounts", "r");
