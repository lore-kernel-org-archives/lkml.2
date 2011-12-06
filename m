Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1LFRTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:19:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46513 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab1LFRTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:19:12 -0500
Date: Tue, 6 Dec 2011 18:17:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf/tracing fixes
Message-ID: <20111206171725.GA23328@elte.hu>
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
Gleb Natapov (1):
      jump_label: jump_label_inc may return before the code is patched

Ilya Dryomov (1):
      tracing: fix event_subsystem ref counting

Li Zefan (1):
      tracing: Restore system filter behavior

Steven Rostedt (3):
      ftrace: Remove force undef config value left for testing
      perf: Fix parsing of __print_flags() in TP_printk()
      ftrace: Fix hash record accounting bug


 include/linux/ftrace_event.h        |    2 ++
 kernel/jump_label.c                 |    3 ++-
 kernel/trace/ftrace.c               |    5 +++--
 kernel/trace/trace_events.c         |    1 -
 kernel/trace/trace_events_filter.c  |    7 ++++++-
 tools/perf/util/trace-event-parse.c |    2 ++
 6 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 96efa67..c3da42d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -172,6 +172,7 @@ enum {
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_RECORDED_CMD_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
+	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
 };
 
 enum {
@@ -179,6 +180,7 @@ enum {
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
 	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
 	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
+	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
 };
 
 struct ftrace_event_call {
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index bbdfe2a..66ff710 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -66,8 +66,9 @@ void jump_label_inc(struct jump_label_key *key)
 		return;
 
 	jump_label_lock();
-	if (atomic_add_return(1, &key->enabled) == 1)
+	if (atomic_read(&key->enabled) == 0)
 		jump_label_update(key, JUMP_LABEL_ENABLE);
+	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 900b409..b1e8943 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -152,7 +152,6 @@ void clear_ftrace_function(void)
 	ftrace_pid_function = ftrace_stub;
 }
 
-#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
  * For those archs that do not test ftrace_trace_stop in their
@@ -1212,7 +1211,9 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	if (!src->count) {
 		free_ftrace_hash_rcu(*dst);
 		rcu_assign_pointer(*dst, EMPTY_HASH);
-		return 0;
+		/* still need to update the function records */
+		ret = 0;
+		goto out;
 	}
 
 	/*
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 581876f..c212a7f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1078,7 +1078,6 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	/* First see if we did not already create this dir */
 	list_for_each_entry(system, &event_subsystems, list) {
 		if (strcmp(system->name, name) == 0) {
-			__get_system(system);
 			system->nr_events++;
 			return system->entry;
 		}
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index d6e7926..95dc31e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1649,7 +1649,9 @@ static int replace_system_preds(struct event_subsystem *system,
 		 */
 		err = replace_preds(call, NULL, ps, filter_string, true);
 		if (err)
-			goto fail;
+			call->flags |= TRACE_EVENT_FL_NO_SET_FILTER;
+		else
+			call->flags &= ~TRACE_EVENT_FL_NO_SET_FILTER;
 	}
 
 	list_for_each_entry(call, &ftrace_events, list) {
@@ -1658,6 +1660,9 @@ static int replace_system_preds(struct event_subsystem *system,
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
+		if (call->flags & TRACE_EVENT_FL_NO_SET_FILTER)
+			continue;
+
 		filter_item = kzalloc(sizeof(*filter_item), GFP_KERNEL);
 		if (!filter_item)
 			goto fail_mem;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a7ed5b..6c164dc 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1537,6 +1537,8 @@ process_flags(struct event *event, struct print_arg *arg, char **tok)
 	field = malloc_or_die(sizeof(*field));
 
 	type = process_arg(event, field, &token);
+	while (type == EVENT_OP)
+		type = process_op(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
 
