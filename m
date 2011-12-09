Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1LIGR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 01:17:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57630 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab1LIGRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 01:17:55 -0500
Date: Fri, 9 Dec 2011 07:16:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20111209061609.GA27542@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Andrew Vagin (1):
      perf header: Use event_name() to get an event name

Anton Blanchard (1):
      perf stat: Failure with "Operation not supported"

Gleb Natapov (1):
      perf: Do no try to schedule task events if there are none

Yong Zhang (1):
      lockdep, kmemcheck: Annotate ->lock in lockdep_init_map()


 kernel/events/core.c      |    4 ++--
 kernel/lockdep.c          |    8 +++++++-
 tools/perf/builtin-stat.c |    3 ++-
 tools/perf/util/header.c  |    2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 600c162..d3b9df5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2174,11 +2174,11 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	perf_event_sched_in(cpuctx, ctx, task);
-
 	if (ctx->nr_events)
 		cpuctx->task_ctx = ctx;
 
+	perf_event_sched_in(cpuctx, cpuctx->task_ctx, task);
+
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e69434b..b2e08c9 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -44,6 +44,7 @@
 #include <linux/stringify.h>
 #include <linux/bitops.h>
 #include <linux/gfp.h>
+#include <linux/kmemcheck.h>
 
 #include <asm/sections.h>
 
@@ -2948,7 +2949,12 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	memset(lock, 0, sizeof(*lock));
+	int i;
+
+	kmemcheck_mark_initialized(lock, sizeof(*lock));
+
+	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
+		lock->class_cache[i] = NULL;
 
 #ifdef CONFIG_LOCK_STAT
 	lock->cpu = raw_smp_processor_id();
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7d98676..955930e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -463,7 +463,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter, first) < 0) {
-			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT) {
+			if (errno == EINVAL || errno == ENOSYS ||
+			    errno == ENOENT || errno == EOPNOTSUPP) {
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
 						    event_name(counter));
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index bcd05d0..33c17a2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -388,7 +388,7 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 		/*
 		 * write event string as passed on cmdline
 		 */
-		ret = do_write_string(fd, attr->name);
+		ret = do_write_string(fd, event_name(attr));
 		if (ret < 0)
 			return ret;
 		/*
