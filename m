Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab0F1KNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:13:01 -0400
Received: from www.tglx.de ([62.245.132.106]:58399 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0F1KNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:13:00 -0400
Date: Mon, 28 Jun 2010 12:12:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] perf fixes for 2.6.35
Message-ID: <alpine.LFD.2.00.1006281212030.2530@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

Thanks,

	tglx

------------------>
Arnaldo Carvalho de Melo (2):
      perf record: Don't call newt functions when not initialized
      perf session: Remove threads from tree on PERF_RECORD_EXIT

Ian Munsie (1):
      perf record: prevent kill(0, SIGTERM);

Stephane Eranian (1):
      perf_events: Fix Intel Westmere event constraints

Steven Rostedt (1):
      perf/tracing: Fix regression of perf losing kprobe events

Wu Zhangjin (1):
      tracing: Fix undeclared ENOSYS in include/linux/tracepoint.h


 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 include/linux/tracepoint.h             |    1 +
 kernel/trace/trace_event_perf.c        |    4 +++-
 tools/perf/builtin-record.c            |    2 +-
 tools/perf/util/event.c                |    4 +++-
 tools/perf/util/newt.c                 |   15 +++++++++++++--
 tools/perf/util/session.c              |   11 +++++++++++
 tools/perf/util/session.h              |    2 ++
 tools/perf/util/thread.h               |    5 ++++-
 9 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fdbc652..214ac86 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -72,6 +72,7 @@ static struct event_constraint intel_westmere_event_constraints[] =
 	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
 	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
 	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0xb3, 0x1), /* SNOOPQ_REQUEST_OUTSTANDING */
 	EVENT_CONSTRAINT_END
 };
 
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 9a59d1f..103d1b6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -14,6 +14,7 @@
  * See the file COPYING for more details.
  */
 
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/rcupdate.h>
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index e6f6588..8a2b73f 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -96,7 +96,9 @@ int perf_trace_init(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	list_for_each_entry(tp_event, &ftrace_events, list) {
 		if (tp_event->event.type == event_id &&
-		    tp_event->class && tp_event->class->perf_probe &&
+		    tp_event->class &&
+		    (tp_event->class->perf_probe ||
+		     tp_event->class->reg) &&
 		    try_module_get(tp_event->mod)) {
 			ret = perf_trace_event_init(tp_event, p_event);
 			break;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index dc3435e..711745f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -193,7 +193,7 @@ static void sig_handler(int sig)
 
 static void sig_atexit(void)
 {
-	if (child_pid != -1)
+	if (child_pid > 0)
 		kill(child_pid, SIGTERM);
 
 	if (signr == -1)
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1f08f00..2fbf6a4 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -538,8 +538,10 @@ int event__process_task(event_t *self, struct perf_session *session)
 	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
 		    self->fork.ppid, self->fork.ptid);
 
-	if (self->header.type == PERF_RECORD_EXIT)
+	if (self->header.type == PERF_RECORD_EXIT) {
+		perf_session__remove_thread(session, thread);
 		return 0;
+	}
 
 	if (thread == NULL || parent == NULL ||
 	    thread__fork(thread, parent) < 0) {
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index cf182ca..7537ca1 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -43,6 +43,9 @@ struct ui_progress *ui_progress__new(const char *title, u64 total)
 
 	if (self != NULL) {
 		int cols;
+
+		if (use_browser <= 0)	
+			return self;
 		newtGetScreenSize(&cols, NULL);
 		cols -= 4;
 		newtCenteredWindow(cols, 1, title);
@@ -67,14 +70,22 @@ out_free_self:
 
 void ui_progress__update(struct ui_progress *self, u64 curr)
 {
+	/*
+	 * FIXME: We should have a per UI backend way of showing progress,
+	 * stdio will just show a percentage as NN%, etc.
+	 */
+	if (use_browser <= 0)
+		return;
 	newtScaleSet(self->scale, curr);
 	newtRefresh();
 }
 
 void ui_progress__delete(struct ui_progress *self)
 {
-	newtFormDestroy(self->form);
-	newtPopWindow();
+	if (use_browser > 0) {
+		newtFormDestroy(self->form);
+		newtPopWindow();
+	}
 	free(self);
 }
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8f83a18..c422cd6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -90,6 +90,7 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 
 	memcpy(self->filename, filename, len);
 	self->threads = RB_ROOT;
+	INIT_LIST_HEAD(&self->dead_threads);
 	self->hists_tree = RB_ROOT;
 	self->last_match = NULL;
 	self->mmap_window = 32;
@@ -131,6 +132,16 @@ void perf_session__delete(struct perf_session *self)
 	free(self);
 }
 
+void perf_session__remove_thread(struct perf_session *self, struct thread *th)
+{
+	rb_erase(&th->rb_node, &self->threads);
+	/*
+	 * We may have references to this thread, for instance in some hist_entry
+	 * instances, so just move them to a separate list.
+	 */
+	list_add_tail(&th->node, &self->dead_threads);
+}
+
 static bool symbol__match_parent_regex(struct symbol *sym)
 {
 	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 55c6881..9fa0fc2 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -26,6 +26,7 @@ struct perf_session {
 	unsigned long		size;
 	unsigned long		mmap_window;
 	struct rb_root		threads;
+	struct list_head	dead_threads;
 	struct thread		*last_match;
 	struct machine		host_machine;
 	struct rb_root		machines;
@@ -99,6 +100,7 @@ int perf_session__create_kernel_maps(struct perf_session *self);
 
 int do_read(int fd, void *buf, size_t size);
 void perf_session__update_sample_type(struct perf_session *self);
+void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 
 static inline
 struct machine *perf_session__find_host_machine(struct perf_session *self)
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 1dfd9ff..ee6bbcf 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -6,7 +6,10 @@
 #include "symbol.h"
 
 struct thread {
-	struct rb_node		rb_node;
+	union {
+		struct rb_node	 rb_node;
+		struct list_head node;
+	};
 	struct map_groups	mg;
 	pid_t			pid;
 	char			shortname[3];
