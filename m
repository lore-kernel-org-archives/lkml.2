Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2GJKUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:20:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:38121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2GJKUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:20:30 -0400
Message-ID: <1341915609.3462.113.camel@twins>
Subject: Re: [PATCH] trace: add ability to set a target task for events
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>
Date: Tue, 10 Jul 2012 12:20:09 +0200
In-Reply-To: <1341392911-1888300-1-git-send-email-avagin@openvz.org>
References: <1341392911-1888300-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 13:08 +0400, Andrew Vagin wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> A few events are interesting not only for a current task.
> For example, sched_stat_* are interesting to a task, which
> wake up. For this reason, it will be good, if such events will
> be delivered to a target task too.
> 
> Now a target task can be set by using __perf_task().

Right, I suspect you actually tested this and it works?

It would be good it you can expand the Changelog a bit to include your
entire use-case. IIRC you're wanting to measure task block latency and
need the time and place where it goes to sleep, provided by
trace_sched_switch + callchain, and the time when it gets woken up,
provided by trace_sched_wakeup().

Hmm.. you only add __perf_task() to sched_stat_template, should it also
be added to sched_wakeup_template?

ISTR us talking about dis-allowing callgraphs on such cross-task events,
since that would be nigh impossible to interpret, right?

So do we want something like this on top?

---
 kernel/events/callchain.c | 12 +++++++++---
 kernel/events/core.c      |  2 +-
 kernel/events/internal.h  |  3 ++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 6581a04..35de8b1 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -153,11 +153,11 @@ put_callchain_entry(int rctx)
 	put_recursion_context(__get_cpu_var(callchain_recursion), rctx);
 }
 
-struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
+struct perf_callchain_entry *
+perf_callchain(struct perf_event *event, struct pt_regs *regs)
 {
-	int rctx;
 	struct perf_callchain_entry *entry;
-
+	int rctx;
 
 	entry = get_callchain_entry(&rctx);
 	if (rctx == -1)
@@ -178,6 +178,12 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	}
 
 	if (regs) {
+		/*
+		 * Disallow cross-task user callchains.
+		 */
+		if (event->ctx->task && event->ctx->task != current)
+			goto exit_put;
+
 		perf_callchain_store(entry, PERF_CONTEXT_USER);
 		perf_callchain_user(entry, regs);
 	}
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f1cf0ed..74d22c9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4039,7 +4039,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
 
-		data->callchain = perf_callchain(regs);
+		data->callchain = perf_callchain(event, regs);
 
 		if (data->callchain)
 			size += data->callchain->nr;
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b0b107f..a096c19 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -101,7 +101,8 @@ __output_copy(struct perf_output_handle *handle,
 }
 
 /* Callchain handling */
-extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
+extern struct perf_callchain_entry *
+perf_callchain(struct perf_event *event, struct pt_regs *regs);
 extern int get_callchain_buffers(void);
 extern void put_callchain_buffers(void);
 

