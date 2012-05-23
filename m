Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab2EWTBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:01:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59972 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab2EWTBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:01:20 -0400
Date: Wed, 23 May 2012 21:01:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf updates
Message-ID: <20120523190106.GA18693@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

   HEAD: ab0cce560ef177bdc7a8f73e9962be9d829a7b2c Revert "sched, perf: Use a single callback into the scheduler"

These are late tools/perf/ changes that missed the first round: 

 - endianness fixes
 - event parsing improvements
 - libtraceevent fixes factored out from trace-cmd
 - perl scripting engine fixes related to libtraceevent,
 - testcase improvements
 - perf inject / pipe mode fixes
 - plus a kernel side fix

 Thanks,

	Ingo

------------------>
Anshuman Khandual (1):
      perf record: Fix documentation for branch stack sampling

Arnaldo Carvalho de Melo (2):
      perf tools: Bump default sample freq to 4 kHz
      perf evlist: Show event attribute details

Frederic Weisbecker (2):
      perf script: Explicitly handle known default print arg type
      perf script: Rename struct event to struct event_format in perl engine

Jiri Olsa (8):
      perf test: Move parse event automated tests to separated object
      perf tools: Add support for displaying event parser debug info
      perf tools: Use allocated list for each parsed event
      perf tools: Separate 'mem:' event scanner bits
      perf tools: Add hardcoded name term for pmu events
      perf tools: Carry perf_event_attr bitfield throught different endians
      perf tools: Add union u64_swap type for swapping u64 data
      Revert "sched, perf: Use a single callback into the scheduler"

Namhyung Kim (3):
      perf tools: Rename libparsevent to libtraceevent in Makefile
      perf tools: Always try to build libtraceevent
      perf target: Add cpu flag to sample_type if target has cpu

Stephane Eranian (4):
      perf tools: rename HEADER_TRACE_INFO to HEADER_TRACING_DATA
      perf inject: Fix broken perf inject -b
      perf tools: Fix piped mode read code
      perf buildid-list: Work better with pipe mode


 include/linux/perf_event.h                         |  24 +-
 kernel/events/core.c                               |  14 +-
 kernel/sched/core.c                                |   9 +-
 tools/perf/Documentation/perf-evlist.txt           |   8 +
 tools/perf/Documentation/perf-record.txt           |   2 +-
 tools/perf/Makefile                                |  37 +-
 tools/perf/builtin-buildid-list.c                  |   6 +-
 tools/perf/builtin-evlist.c                        | 103 +++-
 tools/perf/builtin-inject.c                        |   5 +
 tools/perf/builtin-record.c                        |   6 +-
 tools/perf/builtin-test.c                          | 552 +-----------------
 tools/perf/builtin-top.c                           |   5 +-
 tools/perf/util/build-id.c                         |   2 +
 tools/perf/util/evsel.c                            |  12 +-
 tools/perf/util/header.c                           |  10 +-
 tools/perf/util/header.h                           |   2 +-
 tools/perf/util/parse-events-test.c                | 625 +++++++++++++++++++++
 tools/perf/util/parse-events.c                     |  69 ++-
 tools/perf/util/parse-events.h                     |  20 +-
 tools/perf/util/parse-events.l                     |  26 +-
 tools/perf/util/parse-events.y                     |  77 ++-
 tools/perf/util/pmu.c                              |   4 +-
 .../perf/util/scripting-engines/trace-event-perl.c |  16 +-
 tools/perf/util/session.c                          |  68 ++-
 tools/perf/util/types.h                            |   5 +
 25 files changed, 1032 insertions(+), 675 deletions(-)
 create mode 100644 tools/perf/util/parse-events-test.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8adf70e..f325786 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1084,8 +1084,10 @@ extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
 extern const char *perf_pmu_name(void);
-extern void __perf_event_task_sched(struct task_struct *prev,
-				    struct task_struct *next);
+extern void __perf_event_task_sched_in(struct task_struct *prev,
+				       struct task_struct *task);
+extern void __perf_event_task_sched_out(struct task_struct *prev,
+					struct task_struct *next);
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
@@ -1205,13 +1207,20 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 
 extern struct static_key_deferred perf_sched_events;
 
-static inline void perf_event_task_sched(struct task_struct *prev,
+static inline void perf_event_task_sched_in(struct task_struct *prev,
 					    struct task_struct *task)
 {
+	if (static_key_false(&perf_sched_events.key))
+		__perf_event_task_sched_in(prev, task);
+}
+
+static inline void perf_event_task_sched_out(struct task_struct *prev,
+					     struct task_struct *next)
+{
 	perf_sw_event(PERF_COUNT_SW_CONTEXT_SWITCHES, 1, NULL, 0);
 
 	if (static_key_false(&perf_sched_events.key))
-		__perf_event_task_sched(prev, task);
+		__perf_event_task_sched_out(prev, next);
 }
 
 extern void perf_event_mmap(struct vm_area_struct *vma);
@@ -1286,8 +1295,11 @@ extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
 #else
 static inline void
-perf_event_task_sched(struct task_struct *prev,
-		      struct task_struct *task)				{ }
+perf_event_task_sched_in(struct task_struct *prev,
+			 struct task_struct *task)			{ }
+static inline void
+perf_event_task_sched_out(struct task_struct *prev,
+			  struct task_struct *next)			{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 91a4459..5b06cbb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2039,8 +2039,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
  * accessing the event control register. If a NMI hits, then it will
  * not restart the event.
  */
-static void __perf_event_task_sched_out(struct task_struct *task,
-					struct task_struct *next)
+void __perf_event_task_sched_out(struct task_struct *task,
+				 struct task_struct *next)
 {
 	int ctxn;
 
@@ -2279,8 +2279,8 @@ static void perf_branch_stack_sched_in(struct task_struct *prev,
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-static void __perf_event_task_sched_in(struct task_struct *prev,
-				       struct task_struct *task)
+void __perf_event_task_sched_in(struct task_struct *prev,
+				struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 	int ctxn;
@@ -2305,12 +2305,6 @@ static void __perf_event_task_sched_in(struct task_struct *prev,
 		perf_branch_stack_sched_in(prev, task);
 }
 
-void __perf_event_task_sched(struct task_struct *prev, struct task_struct *next)
-{
-	__perf_event_task_sched_out(prev, next);
-	__perf_event_task_sched_in(prev, next);
-}
-
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	u64 frequency = event->attr.sample_freq;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 13c3883..0533a68 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1913,7 +1913,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	sched_info_switch(prev, next);
-	perf_event_task_sched(prev, next);
+	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
@@ -1956,6 +1956,13 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_disable();
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
+	perf_event_task_sched_in(prev, current);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_enable();
+#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
 
diff --git a/tools/perf/Documentation/perf-evlist.txt b/tools/perf/Documentation/perf-evlist.txt
index 0507ec7..1521734 100644
--- a/tools/perf/Documentation/perf-evlist.txt
+++ b/tools/perf/Documentation/perf-evlist.txt
@@ -20,6 +20,14 @@ OPTIONS
 --input=::
         Input file name. (default: perf.data unless stdin is a fifo)
 
+-F::
+--freq=::
+	Show just the sample frequency used for each event.
+
+-v::
+--verbose=::
+	Show all fields.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-list[1],
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index a1386b2..b38a1f9 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -168,7 +168,7 @@ following filters are defined:
         - any:  any type of branches
         - any_call: any function call or system call
         - any_ret: any function return or system call return
-        - any_ind: any indirect branch
+        - ind_call: any indirect branch
         - u:  only when the branch target is at the user level
         - k: only when the branch target is in the kernel
         - hv: only when the target is at the hypervisor level
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index fa37cd5..1d3d513 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -83,7 +83,13 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+ifdef PARSER_DEBUG
+	PARSER_DEBUG_BISON  := -t
+	PARSER_DEBUG_FLEX   := -d
+	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
+endif
+
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
@@ -149,7 +155,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -I$(EVENT_PARSE_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
@@ -178,16 +184,16 @@ $(OUTPUT)python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
-EVENT_PARSE_DIR = ../lib/traceevent/
+TRACE_EVENT_DIR = ../lib/traceevent/
 
 ifeq ("$(origin O)", "command line")
-	EP_PATH=$(OUTPUT)/
+	TE_PATH=$(OUTPUT)/
 else
-	EP_PATH=$(EVENT_PARSE_DIR)/
+	TE_PATH=$(TRACE_EVENT_DIR)/
 endif
 
-LIBPARSEVENT = $(EP_PATH)libtraceevent.a
-EP_LIB := -L$(EP_PATH) -ltraceevent
+LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
+TE_LIB := -L$(TE_PATH) -ltraceevent
 
 #
 # Single 'perf' binary right now:
@@ -216,10 +222,10 @@ FLEX = flex
 BISON= bison
 
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l
-	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
+	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
 
 $(OUTPUT)util/pmu-flex.c: util/pmu.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
@@ -311,7 +317,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
-LIB_H += $(EVENT_PARSE_DIR)event-parse.h
+LIB_H += $(TRACE_EVENT_DIR)event-parse.h
 LIB_H += util/target.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
@@ -332,6 +338,7 @@ LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
+LIB_OBJS += $(OUTPUT)util/parse-events-test.o
 LIB_OBJS += $(OUTPUT)util/path.o
 LIB_OBJS += $(OUTPUT)util/rbtree.o
 LIB_OBJS += $(OUTPUT)util/bitmap.o
@@ -410,7 +417,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
-PERFLIBS = $(LIB_FILE) $(LIBPARSEVENT)
+PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 
 # Files needed for the python binding, perf.so
 # pyrf is just an internal name needed for all those wrappers.
@@ -819,9 +826,9 @@ $(sort $(dir $(DIRECTORY_DEPS))):
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
-# libparsevent.a
-$(LIBPARSEVENT):
-	make -C $(EVENT_PARSE_DIR) $(COMMAND_O) libtraceevent.a
+# libtraceevent.a
+$(LIBTRACEEVENT):
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) $(COMMAND_O) libtraceevent.a
 
 help:
 	@echo 'Perf make targets:'
@@ -969,6 +976,6 @@ clean:
 	$(RM) $(OUTPUT)util/*-{bison,flex}*
 	$(python-clean)
 
-.PHONY: all install clean strip
+.PHONY: all install clean strip $(LIBTRACEEVENT)
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 5248046..6b2bcfb 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -84,7 +84,11 @@ static int perf_session__list_build_ids(void)
 	if (filename__fprintf_build_id(session->filename, stdout))
 		goto out;
 
-	if (with_hits)
+	/*
+	 * in pipe-mode, the only way to get the buildids is to parse
+	 * the record stream. Buildids are stored as RECORD_HEADER_BUILD_ID
+	 */
+	if (with_hits || session->fd_pipe)
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 2676032..e52d77e 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -15,9 +15,40 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 
-static const char *input_name;
+struct perf_attr_details {
+	bool freq;
+	bool verbose;
+};
+
+static int comma_printf(bool *first, const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (!*first) {
+		ret += printf(",");
+	} else {
+		ret += printf(":");
+		*first = false;
+	}
+
+	va_start(args, fmt);
+	ret += vprintf(fmt, args);
+	va_end(args);
+	return ret;
+}
+
+static int __if_print(bool *first, const char *field, u64 value)
+{
+	if (value == 0)
+		return 0;
+
+	return comma_printf(first, " %s: %" PRIu64, field, value);
+}
+
+#define if_print(field) __if_print(&first, #field, pos->attr.field)
 
-static int __cmd_evlist(void)
+static int __cmd_evlist(const char *input_name, struct perf_attr_details *details)
 {
 	struct perf_session *session;
 	struct perf_evsel *pos;
@@ -26,8 +57,52 @@ static int __cmd_evlist(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	list_for_each_entry(pos, &session->evlist->entries, node)
-		printf("%s\n", event_name(pos));
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		bool first = true;
+
+		printf("%s", event_name(pos));
+
+		if (details->verbose || details->freq) {
+			comma_printf(&first, " sample_freq=%" PRIu64,
+				     (u64)pos->attr.sample_freq);
+		}
+
+		if (details->verbose) {
+			if_print(type);
+			if_print(config);
+			if_print(config1);
+			if_print(config2);
+			if_print(size);
+			if_print(sample_type);
+			if_print(read_format);
+			if_print(disabled);
+			if_print(inherit);
+			if_print(pinned);
+			if_print(exclusive);
+			if_print(exclude_user);
+			if_print(exclude_kernel);
+			if_print(exclude_hv);
+			if_print(exclude_idle);
+			if_print(mmap);
+			if_print(comm);
+			if_print(freq);
+			if_print(inherit_stat);
+			if_print(enable_on_exec);
+			if_print(task);
+			if_print(watermark);
+			if_print(precise_ip);
+			if_print(mmap_data);
+			if_print(sample_id_all);
+			if_print(exclude_host);
+			if_print(exclude_guest);
+			if_print(__reserved_1);
+			if_print(wakeup_events);
+			if_print(bp_type);
+			if_print(branch_sample_type);
+		}
+
+		putchar('\n');
+	}
 
 	perf_session__delete(session);
 	return 0;
@@ -38,17 +113,23 @@ static const char * const evlist_usage[] = {
 	NULL
 };
 
-static const struct option options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
-	OPT_END()
-};
-
 int cmd_evlist(int argc, const char **argv, const char *prefix __used)
 {
+	struct perf_attr_details details = { .verbose = false, };
+	const char *input_name;
+	const struct option options[] = {
+		OPT_STRING('i', "input", &input_name, "file",
+			    "Input file name"),
+		OPT_BOOLEAN('F', "freq", &details.freq,
+			    "Show the sample frequency"),
+		OPT_BOOLEAN('v', "verbose", &details.verbose,
+			    "Show all event attr details"),
+		OPT_END()
+	};
+
 	argc = parse_options(argc, argv, options, evlist_usage, 0);
 	if (argc)
 		usage_with_options(evlist_usage, options);
 
-	return __cmd_evlist();
+	return __cmd_evlist(input_name, &details);
 }
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 09c1061..3beab48 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -60,6 +60,11 @@ static int perf_event__repipe_tracing_data_synth(union perf_event *event,
 static int perf_event__repipe_attr(union perf_event *event,
 				   struct perf_evlist **pevlist __used)
 {
+	int ret;
+	ret = perf_event__process_attr(event, pevlist);
+	if (ret)
+		return ret;
+
 	return perf_event__repipe_synth(NULL, event, NULL);
 }
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8a3dfac..e5cb084 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -396,7 +396,7 @@ static void perf_record__mmap_read_all(struct perf_record *rec)
 			perf_record__mmap_read(rec, &rec->evlist->mmap[i]);
 	}
 
-	if (perf_header__has_feat(&rec->session->header, HEADER_TRACE_INFO))
+	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
 		write_output(rec, &finished_round_event, sizeof(finished_round_event));
 }
 
@@ -478,7 +478,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
 
 	if (!have_tracepoints(&evsel_list->entries))
-		perf_header__clear_feat(&session->header, HEADER_TRACE_INFO);
+		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
 
 	if (!rec->opts.branch_stack)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
@@ -753,7 +753,7 @@ static struct perf_record record = {
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
-		.freq		     = 1000,
+		.freq		     = 4000,
 		.target		     = {
 			.uses_mmap   = true,
 		},
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 6c47376..5a8727c 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -604,556 +604,6 @@ out_free_threads:
 #undef nsyscalls
 }
 
-#define TEST_ASSERT_VAL(text, cond) \
-do { \
-	if (!(cond)) { \
-		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
-		return -1; \
-	} \
-} while (0)
-
-static int test__checkevent_tracepoint(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
-		evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	return 0;
-}
-
-static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_TRACEPOINT == evsel->attr.type);
-		TEST_ASSERT_VAL("wrong sample_type",
-			(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU)
-			== evsel->attr.sample_type);
-		TEST_ASSERT_VAL("wrong sample_period",
-			1 == evsel->attr.sample_period);
-	}
-	return 0;
-}
-
-static int test__checkevent_raw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0x1a == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_numeric(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong period",
-			100000 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong config1",
-			0 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2",
-			1 == evsel->attr.config2);
-	return 0;
-}
-
-static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_genhw(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HW_CACHE == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", (1 << 16) == evsel->attr.config);
-	return 0;
-}
-
-static int test__checkevent_breakpoint(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
-					 evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_4 ==
-					evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_X == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len", sizeof(long) == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_R == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type",
-			PERF_TYPE_BREAKPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong bp_type",
-			HW_BREAKPOINT_W == evsel->attr.bp_type);
-	TEST_ASSERT_VAL("wrong bp_len",
-			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
-	return 0;
-}
-
-static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_tracepoint(evlist);
-}
-
-static int
-test__checkevent_tracepoint_multi_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		TEST_ASSERT_VAL("wrong exclude_user",
-				!evsel->attr.exclude_user);
-		TEST_ASSERT_VAL("wrong exclude_kernel",
-				evsel->attr.exclude_kernel);
-		TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-		TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-	}
-
-	return test__checkevent_tracepoint_multi(evlist);
-}
-
-static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_raw(evlist);
-}
-
-static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_numeric(evlist);
-}
-
-static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_exclude_host_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_exclude_guest_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
-	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
-
-	return test__checkevent_symbolic_name(evlist);
-}
-
-static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_symbolic_alias(evlist);
-}
-
-static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_genhw(evlist);
-}
-
-static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_breakpoint(evlist);
-}
-
-static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	return test__checkevent_breakpoint_x(evlist);
-}
-
-static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_breakpoint_r(evlist);
-}
-
-static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return test__checkevent_breakpoint_w(evlist);
-}
-
-static int test__checkevent_pmu(struct perf_evlist *evlist)
-{
-
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
-
-	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config",    10 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong config1",    1 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2",    3 == evsel->attr.config2);
-	TEST_ASSERT_VAL("wrong period",  1000 == evsel->attr.sample_period);
-
-	return 0;
-}
-
-static int test__checkevent_list(struct perf_evlist *evlist)
-{
-	struct perf_evsel *evsel;
-
-	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
-
-	/* r1 */
-	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
-	TEST_ASSERT_VAL("wrong config2", 0 == evsel->attr.config2);
-	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	/* syscalls:sys_enter_open:k */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong sample_type",
-		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
-		evsel->attr.sample_type);
-	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
-
-	/* 1:1:hp */
-	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
-	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
-	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
-	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
-
-	return 0;
-}
-
-static struct test__event_st {
-	const char *name;
-	__u32 type;
-	int (*check)(struct perf_evlist *evlist);
-} test__events[] = {
-	{
-		.name  = "syscalls:sys_enter_open",
-		.check = test__checkevent_tracepoint,
-	},
-	{
-		.name  = "syscalls:*",
-		.check = test__checkevent_tracepoint_multi,
-	},
-	{
-		.name  = "r1a",
-		.check = test__checkevent_raw,
-	},
-	{
-		.name  = "1:1",
-		.check = test__checkevent_numeric,
-	},
-	{
-		.name  = "instructions",
-		.check = test__checkevent_symbolic_name,
-	},
-	{
-		.name  = "cycles/period=100000,config2/",
-		.check = test__checkevent_symbolic_name_config,
-	},
-	{
-		.name  = "faults",
-		.check = test__checkevent_symbolic_alias,
-	},
-	{
-		.name  = "L1-dcache-load-miss",
-		.check = test__checkevent_genhw,
-	},
-	{
-		.name  = "mem:0",
-		.check = test__checkevent_breakpoint,
-	},
-	{
-		.name  = "mem:0:x",
-		.check = test__checkevent_breakpoint_x,
-	},
-	{
-		.name  = "mem:0:r",
-		.check = test__checkevent_breakpoint_r,
-	},
-	{
-		.name  = "mem:0:w",
-		.check = test__checkevent_breakpoint_w,
-	},
-	{
-		.name  = "syscalls:sys_enter_open:k",
-		.check = test__checkevent_tracepoint_modifier,
-	},
-	{
-		.name  = "syscalls:*:u",
-		.check = test__checkevent_tracepoint_multi_modifier,
-	},
-	{
-		.name  = "r1a:kp",
-		.check = test__checkevent_raw_modifier,
-	},
-	{
-		.name  = "1:1:hp",
-		.check = test__checkevent_numeric_modifier,
-	},
-	{
-		.name  = "instructions:h",
-		.check = test__checkevent_symbolic_name_modifier,
-	},
-	{
-		.name  = "faults:u",
-		.check = test__checkevent_symbolic_alias_modifier,
-	},
-	{
-		.name  = "L1-dcache-load-miss:kp",
-		.check = test__checkevent_genhw_modifier,
-	},
-	{
-		.name  = "mem:0:u",
-		.check = test__checkevent_breakpoint_modifier,
-	},
-	{
-		.name  = "mem:0:x:k",
-		.check = test__checkevent_breakpoint_x_modifier,
-	},
-	{
-		.name  = "mem:0:r:hp",
-		.check = test__checkevent_breakpoint_r_modifier,
-	},
-	{
-		.name  = "mem:0:w:up",
-		.check = test__checkevent_breakpoint_w_modifier,
-	},
-	{
-		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
-		.check = test__checkevent_pmu,
-	},
-	{
-		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
-		.check = test__checkevent_list,
-	},
-	{
-		.name  = "instructions:G",
-		.check = test__checkevent_exclude_host_modifier,
-	},
-	{
-		.name  = "instructions:H",
-		.check = test__checkevent_exclude_guest_modifier,
-	},
-};
-
-#define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
-
-static int test__parse_events(void)
-{
-	struct perf_evlist *evlist;
-	u_int i;
-	int ret = 0;
-
-	for (i = 0; i < TEST__EVENTS_CNT; i++) {
-		struct test__event_st *e = &test__events[i];
-
-		evlist = perf_evlist__new(NULL, NULL);
-		if (evlist == NULL)
-			break;
-
-		ret = parse_events(evlist, e->name, 0);
-		if (ret) {
-			pr_debug("failed to parse event '%s', err %d\n",
-				 e->name, ret);
-			break;
-		}
-
-		ret = e->check(evlist);
-		perf_evlist__delete(evlist);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
 static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t **maskp,
 					 size_t *sizep)
 {
@@ -1675,7 +1125,7 @@ static struct test {
 	},
 	{
 		.desc = "parse events tests",
-		.func = test__parse_events,
+		.func = parse_events__test,
 	},
 #if defined(__x86_64__) || defined(__i386__)
 	{
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3e981a7..6031dce 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -900,6 +900,9 @@ static void perf_top__start_counters(struct perf_top *top)
 			attr->read_format |= PERF_FORMAT_ID;
 		}
 
+		if (perf_target__has_cpu(&top->target))
+			attr->sample_type |= PERF_SAMPLE_CPU;
+
 		if (symbol_conf.use_callchain)
 			attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
 
@@ -1159,7 +1162,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	struct perf_top top = {
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
-		.freq		     = 1000, /* 1 KHz */
+		.freq		     = 4000, /* 4 KHz */
 		.mmap_pages	     = 128,
 		.sym_pcnt_filter     = 5,
 		.target		     = {
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index dff9c7a..fd9a594 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -65,6 +65,8 @@ struct perf_tool build_id__mark_dso_hit_ops = {
 	.mmap	= perf_event__process_mmap,
 	.fork	= perf_event__process_task,
 	.exit	= perf_event__exit_del_thread,
+	.attr		 = perf_event__process_attr,
+	.build_id	 = perf_event__process_build_id,
 };
 
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f4f427c..57e4ce5 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -108,7 +108,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 	if (opts->call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
-	if (opts->target.system_wide)
+	if (perf_target__has_cpu(&opts->target))
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
 	if (opts->period)
@@ -462,10 +462,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	 * used for cross-endian analysis. See git commit 65014ab3
 	 * for why this goofiness is needed.
 	 */
-	union {
-		u64 val64;
-		u32 val32[2];
-	} u;
+	union u64_swap u;
 
 	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
@@ -608,10 +605,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	 * used for cross-endian analysis. See git commit 65014ab3
 	 * for why this goofiness is needed.
 	 */
-	union {
-		u64 val64;
-		u32 val32[2];
-	} u;
+	union u64_swap u;
 
 	array = event->sample.array;
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5385980..2dd5edf 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -437,7 +437,7 @@ static bool perf_session__read_build_ids(struct perf_session *session, bool with
 	return ret;
 }
 
-static int write_trace_info(int fd, struct perf_header *h __used,
+static int write_tracing_data(int fd, struct perf_header *h __used,
 			    struct perf_evlist *evlist)
 {
 	return read_tracing_data(fd, &evlist->entries);
@@ -1472,7 +1472,7 @@ out:
 	return err;
 }
 
-static int process_trace_info(struct perf_file_section *section __unused,
+static int process_tracing_data(struct perf_file_section *section __unused,
 			      struct perf_header *ph __unused,
 			      int feat __unused, int fd)
 {
@@ -1508,11 +1508,11 @@ struct feature_ops {
 		.full_only = true }
 
 /* feature_ops not implemented: */
-#define print_trace_info		NULL
-#define print_build_id			NULL
+#define print_tracing_data	NULL
+#define print_build_id		NULL
 
 static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
-	FEAT_OPP(HEADER_TRACE_INFO,	trace_info),
+	FEAT_OPP(HEADER_TRACING_DATA,	tracing_data),
 	FEAT_OPP(HEADER_BUILD_ID,	build_id),
 	FEAT_OPA(HEADER_HOSTNAME,	hostname),
 	FEAT_OPA(HEADER_OSRELEASE,	osrelease),
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 21a6be0..2d42b3e 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -12,7 +12,7 @@
 enum {
 	HEADER_RESERVED		= 0,	/* always cleared */
 	HEADER_FIRST_FEATURE	= 1,
-	HEADER_TRACE_INFO	= 1,
+	HEADER_TRACING_DATA	= 1,
 	HEADER_BUILD_ID,
 
 	HEADER_HOSTNAME,
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
new file mode 100644
index 0000000..76b98e2
--- /dev/null
+++ b/tools/perf/util/parse-events-test.c
@@ -0,0 +1,625 @@
+
+#include "parse-events.h"
+#include "evsel.h"
+#include "evlist.h"
+#include "sysfs.h"
+#include "../../../include/linux/hw_breakpoint.h"
+
+#define TEST_ASSERT_VAL(text, cond) \
+do { \
+	if (!(cond)) { \
+		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
+		return -1; \
+	} \
+} while (0)
+
+static int test__checkevent_tracepoint(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong sample_type",
+		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
+		evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
+	return 0;
+}
+
+static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_TRACEPOINT == evsel->attr.type);
+		TEST_ASSERT_VAL("wrong sample_type",
+			(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU)
+			== evsel->attr.sample_type);
+		TEST_ASSERT_VAL("wrong sample_period",
+			1 == evsel->attr.sample_period);
+	}
+	return 0;
+}
+
+static int test__checkevent_raw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0x1a == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_numeric(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_symbolic_name(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_symbolic_name_config(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong period",
+			100000 == evsel->attr.sample_period);
+	TEST_ASSERT_VAL("wrong config1",
+			0 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2",
+			1 == evsel->attr.config2);
+	return 0;
+}
+
+static int test__checkevent_symbolic_alias(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_genhw(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HW_CACHE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", (1 << 16) == evsel->attr.config);
+	return 0;
+}
+
+static int test__checkevent_breakpoint(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
+					 evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_4 ==
+					evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_x(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_X == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", sizeof(long) == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_r(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_R == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_breakpoint_w(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type",
+			PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type",
+			HW_BREAKPOINT_W == evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len",
+			HW_BREAKPOINT_LEN_4 == evsel->attr.bp_len);
+	return 0;
+}
+
+static int test__checkevent_tracepoint_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_tracepoint(evlist);
+}
+
+static int
+test__checkevent_tracepoint_multi_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		TEST_ASSERT_VAL("wrong exclude_user",
+				!evsel->attr.exclude_user);
+		TEST_ASSERT_VAL("wrong exclude_kernel",
+				evsel->attr.exclude_kernel);
+		TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+		TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	}
+
+	return test__checkevent_tracepoint_multi(evlist);
+}
+
+static int test__checkevent_raw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_raw(evlist);
+}
+
+static int test__checkevent_numeric_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_numeric(evlist);
+}
+
+static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
+static int test__checkevent_exclude_host_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
+static int test__checkevent_exclude_guest_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+
+	return test__checkevent_symbolic_name(evlist);
+}
+
+static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_symbolic_alias(evlist);
+}
+
+static int test__checkevent_genhw_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_genhw(evlist);
+}
+
+static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint(evlist);
+}
+
+static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_x(evlist);
+}
+
+static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_r(evlist);
+}
+
+static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return test__checkevent_breakpoint_w(evlist);
+}
+
+static int test__checkevent_pmu(struct perf_evlist *evlist)
+{
+
+	struct perf_evsel *evsel = list_entry(evlist->entries.next,
+					      struct perf_evsel, node);
+
+	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",    10 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config1",    1 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2",    3 == evsel->attr.config2);
+	TEST_ASSERT_VAL("wrong period",  1000 == evsel->attr.sample_period);
+
+	return 0;
+}
+
+static int test__checkevent_list(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+
+	/* r1 */
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong config1", 0 == evsel->attr.config1);
+	TEST_ASSERT_VAL("wrong config2", 0 == evsel->attr.config2);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	/* syscalls:sys_enter_open:k */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong sample_type",
+		(PERF_SAMPLE_RAW | PERF_SAMPLE_TIME | PERF_SAMPLE_CPU) ==
+		evsel->attr.sample_type);
+	TEST_ASSERT_VAL("wrong sample_period", 1 == evsel->attr.sample_period);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+
+	/* 1:1:hp */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", 1 == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
+
+	return 0;
+}
+
+static int test__checkevent_pmu_name(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	/* cpu/config=1,name=krava1/u */
+	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong name", !strcmp(evsel->name, "krava"));
+
+	/* cpu/config=2/" */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong name", !strcmp(evsel->name, "raw 0x2"));
+
+	return 0;
+}
+
+struct test__event_st {
+	const char *name;
+	__u32 type;
+	int (*check)(struct perf_evlist *evlist);
+};
+
+static struct test__event_st test__events[] = {
+	[0] = {
+		.name  = "syscalls:sys_enter_open",
+		.check = test__checkevent_tracepoint,
+	},
+	[1] = {
+		.name  = "syscalls:*",
+		.check = test__checkevent_tracepoint_multi,
+	},
+	[2] = {
+		.name  = "r1a",
+		.check = test__checkevent_raw,
+	},
+	[3] = {
+		.name  = "1:1",
+		.check = test__checkevent_numeric,
+	},
+	[4] = {
+		.name  = "instructions",
+		.check = test__checkevent_symbolic_name,
+	},
+	[5] = {
+		.name  = "cycles/period=100000,config2/",
+		.check = test__checkevent_symbolic_name_config,
+	},
+	[6] = {
+		.name  = "faults",
+		.check = test__checkevent_symbolic_alias,
+	},
+	[7] = {
+		.name  = "L1-dcache-load-miss",
+		.check = test__checkevent_genhw,
+	},
+	[8] = {
+		.name  = "mem:0",
+		.check = test__checkevent_breakpoint,
+	},
+	[9] = {
+		.name  = "mem:0:x",
+		.check = test__checkevent_breakpoint_x,
+	},
+	[10] = {
+		.name  = "mem:0:r",
+		.check = test__checkevent_breakpoint_r,
+	},
+	[11] = {
+		.name  = "mem:0:w",
+		.check = test__checkevent_breakpoint_w,
+	},
+	[12] = {
+		.name  = "syscalls:sys_enter_open:k",
+		.check = test__checkevent_tracepoint_modifier,
+	},
+	[13] = {
+		.name  = "syscalls:*:u",
+		.check = test__checkevent_tracepoint_multi_modifier,
+	},
+	[14] = {
+		.name  = "r1a:kp",
+		.check = test__checkevent_raw_modifier,
+	},
+	[15] = {
+		.name  = "1:1:hp",
+		.check = test__checkevent_numeric_modifier,
+	},
+	[16] = {
+		.name  = "instructions:h",
+		.check = test__checkevent_symbolic_name_modifier,
+	},
+	[17] = {
+		.name  = "faults:u",
+		.check = test__checkevent_symbolic_alias_modifier,
+	},
+	[18] = {
+		.name  = "L1-dcache-load-miss:kp",
+		.check = test__checkevent_genhw_modifier,
+	},
+	[19] = {
+		.name  = "mem:0:u",
+		.check = test__checkevent_breakpoint_modifier,
+	},
+	[20] = {
+		.name  = "mem:0:x:k",
+		.check = test__checkevent_breakpoint_x_modifier,
+	},
+	[21] = {
+		.name  = "mem:0:r:hp",
+		.check = test__checkevent_breakpoint_r_modifier,
+	},
+	[22] = {
+		.name  = "mem:0:w:up",
+		.check = test__checkevent_breakpoint_w_modifier,
+	},
+	[23] = {
+		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
+		.check = test__checkevent_list,
+	},
+	[24] = {
+		.name  = "instructions:G",
+		.check = test__checkevent_exclude_host_modifier,
+	},
+	[25] = {
+		.name  = "instructions:H",
+		.check = test__checkevent_exclude_guest_modifier,
+	},
+};
+
+#define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
+
+static struct test__event_st test__events_pmu[] = {
+	[0] = {
+		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
+		.check = test__checkevent_pmu,
+	},
+	[1] = {
+		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
+		.check = test__checkevent_pmu_name,
+	},
+};
+
+#define TEST__EVENTS_PMU_CNT (sizeof(test__events_pmu) / \
+			      sizeof(struct test__event_st))
+
+static int test(struct test__event_st *e)
+{
+	struct perf_evlist *evlist;
+	int ret;
+
+	evlist = perf_evlist__new(NULL, NULL);
+	if (evlist == NULL)
+		return -ENOMEM;
+
+	ret = parse_events(evlist, e->name, 0);
+	if (ret) {
+		pr_debug("failed to parse event '%s', err %d\n",
+			 e->name, ret);
+		return ret;
+	}
+
+	ret = e->check(evlist);
+	perf_evlist__delete(evlist);
+
+	return ret;
+}
+
+static int test_events(struct test__event_st *events, unsigned cnt)
+{
+	int ret = 0;
+	unsigned i;
+
+	for (i = 0; i < cnt; i++) {
+		struct test__event_st *e = &events[i];
+
+		pr_debug("running test %d '%s'\n", i, e->name);
+		ret = test(e);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int test_pmu(void)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	int ret;
+
+	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/format/",
+		 sysfs_find_mountpoint());
+
+	ret = stat(path, &st);
+	if (ret)
+		pr_debug("ommiting PMU cpu tests\n");
+	return !ret;
+}
+
+int parse_events__test(void)
+{
+	int ret;
+
+	ret = test_events(test__events, TEST__EVENTS_CNT);
+	if (!ret && test_pmu())
+		ret = test_events(test__events_pmu, TEST__EVENTS_PMU_CNT);
+
+	return ret;
+}
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c7fc18a..fac7d59 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -23,8 +23,10 @@ struct event_symbol {
 	const char	*alias;
 };
 
-int parse_events_parse(struct list_head *list, struct list_head *list_tmp,
-		       int *idx);
+#ifdef PARSER_DEBUG
+extern int parse_events_debug;
+#endif
+int parse_events_parse(struct list_head *list, int *idx);
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
@@ -355,20 +357,30 @@ const char *__event_name(int type, u64 config)
 	return "unknown";
 }
 
-static int add_event(struct list_head *list, int *idx,
+static int add_event(struct list_head **_list, int *idx,
 		     struct perf_event_attr *attr, char *name)
 {
 	struct perf_evsel *evsel;
+	struct list_head *list = *_list;
+
+	if (!list) {
+		list = malloc(sizeof(*list));
+		if (!list)
+			return -ENOMEM;
+		INIT_LIST_HEAD(list);
+	}
 
 	event_attr_init(attr);
 
 	evsel = perf_evsel__new(attr, (*idx)++);
-	if (!evsel)
+	if (!evsel) {
+		free(list);
 		return -ENOMEM;
-
-	list_add_tail(&evsel->node, list);
+	}
 
 	evsel->name = strdup(name);
+	list_add_tail(&evsel->node, list);
+	*_list = list;
 	return 0;
 }
 
@@ -390,7 +402,7 @@ static int parse_aliases(char *str, const char *names[][MAX_ALIASES], int size)
 	return -1;
 }
 
-int parse_events_add_cache(struct list_head *list, int *idx,
+int parse_events_add_cache(struct list_head **list, int *idx,
 			   char *type, char *op_result1, char *op_result2)
 {
 	struct perf_event_attr attr;
@@ -451,7 +463,7 @@ int parse_events_add_cache(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-static int add_tracepoint(struct list_head *list, int *idx,
+static int add_tracepoint(struct list_head **list, int *idx,
 			  char *sys_name, char *evt_name)
 {
 	struct perf_event_attr attr;
@@ -488,7 +500,7 @@ static int add_tracepoint(struct list_head *list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-static int add_tracepoint_multi(struct list_head *list, int *idx,
+static int add_tracepoint_multi(struct list_head **list, int *idx,
 				char *sys_name, char *evt_name)
 {
 	char evt_path[MAXPATHLEN];
@@ -519,7 +531,7 @@ static int add_tracepoint_multi(struct list_head *list, int *idx,
 	return ret;
 }
 
-int parse_events_add_tracepoint(struct list_head *list, int *idx,
+int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event)
 {
 	int ret;
@@ -563,7 +575,7 @@ parse_breakpoint_type(const char *type, struct perf_event_attr *attr)
 	return 0;
 }
 
-int parse_events_add_breakpoint(struct list_head *list, int *idx,
+int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type)
 {
 	struct perf_event_attr attr;
@@ -622,6 +634,9 @@ do {								\
 		 * attr->branch_sample_type = term->val.num;
 		 */
 		break;
+	case PARSE_EVENTS__TERM_TYPE_NAME:
+		CHECK_TYPE_VAL(STR);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -642,7 +657,7 @@ static int config_attr(struct perf_event_attr *attr,
 	return 0;
 }
 
-int parse_events_add_numeric(struct list_head *list, int *idx,
+int parse_events_add_numeric(struct list_head **list, int *idx,
 			     unsigned long type, unsigned long config,
 			     struct list_head *head_config)
 {
@@ -660,7 +675,24 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 			 (char *) __event_name(type, config));
 }
 
-int parse_events_add_pmu(struct list_head *list, int *idx,
+static int parse_events__is_name_term(struct parse_events__term *term)
+{
+	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
+}
+
+static char *pmu_event_name(struct perf_event_attr *attr,
+			    struct list_head *head_terms)
+{
+	struct parse_events__term *term;
+
+	list_for_each_entry(term, head_terms, list)
+		if (parse_events__is_name_term(term))
+			return term->val.str;
+
+	return (char *) __event_name(PERF_TYPE_RAW, attr->config);
+}
+
+int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *name, struct list_head *head_config)
 {
 	struct perf_event_attr attr;
@@ -681,7 +713,8 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	if (perf_pmu__config(pmu, &attr, head_config))
 		return -EINVAL;
 
-	return add_event(list, idx, &attr, (char *) "pmu");
+	return add_event(list, idx, &attr,
+			 pmu_event_name(&attr, head_config));
 }
 
 void parse_events_update_lists(struct list_head *list_event,
@@ -693,7 +726,7 @@ void parse_events_update_lists(struct list_head *list_event,
 	 * list, for next event definition.
 	 */
 	list_splice_tail(list_event, list_all);
-	INIT_LIST_HEAD(list_event);
+	free(list_event);
 }
 
 int parse_events_modifier(struct list_head *list, char *str)
@@ -768,10 +801,14 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 
 	buffer = parse_events__scan_string(str);
 
-	ret = parse_events_parse(&list, &list_tmp, &idx);
+#ifdef PARSER_DEBUG
+	parse_events_debug = 1;
+#endif
+	ret = parse_events_parse(&list, &idx);
 
 	parse_events__flush_buffer(buffer);
 	parse_events__delete_buffer(buffer);
+	parse_events_lex_destroy();
 
 	if (!ret) {
 		int entries = idx - evlist->nr_entries;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 3fddd61..8cac57a 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,7 +4,9 @@
  * Parse symbolic events/counts passed in as options:
  */
 
+#include <linux/list.h>
 #include <stdbool.h>
+#include "types.h"
 #include "../../../include/linux/perf_event.h"
 #include "types.h"
 
@@ -45,6 +47,7 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_CONFIG,
 	PARSE_EVENTS__TERM_TYPE_CONFIG1,
 	PARSE_EVENTS__TERM_TYPE_CONFIG2,
+	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
 };
@@ -66,26 +69,23 @@ int parse_events__term_num(struct parse_events__term **_term,
 int parse_events__term_str(struct parse_events__term **_term,
 			   int type_term, char *config, char *str);
 void parse_events__free_terms(struct list_head *terms);
-int parse_events_modifier(struct list_head *list __used, char *str __used);
-int parse_events_add_tracepoint(struct list_head *list, int *idx,
+int parse_events_modifier(struct list_head *list, char *str);
+int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event);
-int parse_events_add_raw(struct perf_evlist *evlist, unsigned long config,
-			 unsigned long config1, unsigned long config2,
-			 char *mod);
-int parse_events_add_numeric(struct list_head *list, int *idx,
+int parse_events_add_numeric(struct list_head **list, int *idx,
 			     unsigned long type, unsigned long config,
 			     struct list_head *head_config);
-int parse_events_add_cache(struct list_head *list, int *idx,
+int parse_events_add_cache(struct list_head **list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
-int parse_events_add_breakpoint(struct list_head *list, int *idx,
+int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type);
-int parse_events_add_pmu(struct list_head *list, int *idx,
+int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *pmu , struct list_head *head_config);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
 void parse_events_error(struct list_head *list_all,
-			struct list_head *list_event,
 			int *idx, char const *msg);
+int parse_events__test(void);
 
 void print_events(const char *event_glob);
 void print_events_type(u8 type);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 1fcf1bb..618a8e7 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -1,5 +1,6 @@
 
 %option prefix="parse_events_"
+%option stack
 
 %{
 #include <errno.h>
@@ -50,6 +51,8 @@ static int term(int type)
 
 %}
 
+%x mem
+
 num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
@@ -102,16 +105,16 @@ misses|miss				{ return str(PE_NAME_CACHE_OP_RESULT); }
 config			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG); }
 config1			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG1); }
 config2			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG2); }
+name			{ return term(PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 
-mem:			{ return PE_PREFIX_MEM; }
+mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
 r{num_raw_hex}		{ return raw(); }
 {num_dec}		{ return value(10); }
 {num_hex}		{ return value(16); }
 
 {modifier_event}	{ return str(PE_MODIFIER_EVENT); }
-{modifier_bp}		{ return str(PE_MODIFIER_BP); }
 {name}			{ return str(PE_NAME); }
 "/"			{ return '/'; }
 -			{ return '-'; }
@@ -119,6 +122,25 @@ r{num_raw_hex}		{ return raw(); }
 :			{ return ':'; }
 =			{ return '='; }
 
+<mem>{
+{modifier_bp}		{ return str(PE_MODIFIER_BP); }
+:			{ return ':'; }
+{num_dec}		{ return value(10); }
+{num_hex}		{ return value(16); }
+	/*
+	 * We need to separate 'mem:' scanner part, in order to get specific
+	 * modifier bits parsed out. Otherwise we would need to handle PE_NAME
+	 * and we'd need to parse it manually. During the escape from <mem>
+	 * state we need to put the escaping char back, so we dont miss it.
+	 */
+.			{ unput(*parse_events_text); BEGIN(INITIAL); }
+	/*
+	 * We destroy the scanner after reaching EOF,
+	 * but anyway just to be sure get back to INIT state.
+	 */
+<<EOF>>			{ BEGIN(INITIAL); }
+}
+
 %%
 
 int parse_events_wrap(void)
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 936913e..362cc59 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -1,7 +1,6 @@
 
 %name-prefix "parse_events_"
 %parse-param {struct list_head *list_all}
-%parse-param {struct list_head *list_event}
 %parse-param {int *idx}
 
 %{
@@ -41,6 +40,14 @@ do { \
 %type <str> PE_MODIFIER_BP
 %type <head> event_config
 %type <term> event_term
+%type <head> event_pmu
+%type <head> event_legacy_symbol
+%type <head> event_legacy_cache
+%type <head> event_legacy_mem
+%type <head> event_legacy_tracepoint
+%type <head> event_legacy_numeric
+%type <head> event_legacy_raw
+%type <head> event_def
 
 %union
 {
@@ -62,13 +69,13 @@ event_def PE_MODIFIER_EVENT
 	 * (there could be more events added for multiple tracepoint
 	 * definitions via '*?'.
 	 */
-	ABORT_ON(parse_events_modifier(list_event, $2));
-	parse_events_update_lists(list_event, list_all);
+	ABORT_ON(parse_events_modifier($1, $2));
+	parse_events_update_lists($1, list_all);
 }
 |
 event_def
 {
-	parse_events_update_lists(list_event, list_all);
+	parse_events_update_lists($1, list_all);
 }
 
 event_def: event_pmu |
@@ -82,71 +89,102 @@ event_def: event_pmu |
 event_pmu:
 PE_NAME '/' event_config '/'
 {
-	ABORT_ON(parse_events_add_pmu(list_event, idx, $1, $3));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_pmu(&list, idx, $1, $3));
 	parse_events__free_terms($3);
+	$$ = list;
 }
 
 event_legacy_symbol:
 PE_VALUE_SYM '/' event_config '/'
 {
+	struct list_head *list = NULL;
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, $3));
+	ABORT_ON(parse_events_add_numeric(&list, idx, type, config, $3));
 	parse_events__free_terms($3);
+	$$ = list;
 }
 |
 PE_VALUE_SYM sep_slash_dc
 {
+	struct list_head *list = NULL;
 	int type = $1 >> 16;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events_add_numeric(list_event, idx, type, config, NULL));
+	ABORT_ON(parse_events_add_numeric(&list, idx, type, config, NULL));
+	$$ = list;
 }
 
 event_legacy_cache:
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT
 {
-	ABORT_ON(parse_events_add_cache(list_event, idx, $1, $3, $5));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_cache(&list, idx, $1, $3, $5));
+	$$ = list;
 }
 |
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT
 {
-	ABORT_ON(parse_events_add_cache(list_event, idx, $1, $3, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_cache(&list, idx, $1, $3, NULL));
+	$$ = list;
 }
 |
 PE_NAME_CACHE_TYPE
 {
-	ABORT_ON(parse_events_add_cache(list_event, idx, $1, NULL, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_cache(&list, idx, $1, NULL, NULL));
+	$$ = list;
 }
 
 event_legacy_mem:
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
-	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) $2, $4));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_breakpoint(&list, idx, (void *) $2, $4));
+	$$ = list;
 }
 |
 PE_PREFIX_MEM PE_VALUE sep_dc
 {
-	ABORT_ON(parse_events_add_breakpoint(list_event, idx, (void *) $2, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_breakpoint(&list, idx, (void *) $2, NULL));
+	$$ = list;
 }
 
 event_legacy_tracepoint:
 PE_NAME ':' PE_NAME
 {
-	ABORT_ON(parse_events_add_tracepoint(list_event, idx, $1, $3));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_tracepoint(&list, idx, $1, $3));
+	$$ = list;
 }
 
 event_legacy_numeric:
 PE_VALUE ':' PE_VALUE
 {
-	ABORT_ON(parse_events_add_numeric(list_event, idx, $1, $3, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_numeric(&list, idx, $1, $3, NULL));
+	$$ = list;
 }
 
 event_legacy_raw:
 PE_RAW
 {
-	ABORT_ON(parse_events_add_numeric(list_event, idx, PERF_TYPE_RAW, $1, NULL));
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_numeric(&list, idx, PERF_TYPE_RAW, $1, NULL));
+	$$ = list;
 }
 
 event_config:
@@ -199,6 +237,14 @@ PE_NAME
 	$$ = term;
 }
 |
+PE_TERM '=' PE_NAME
+{
+	struct parse_events__term *term;
+
+	ABORT_ON(parse_events__term_str(&term, $1, NULL, $3));
+	$$ = term;
+}
+|
 PE_TERM '=' PE_VALUE
 {
 	struct parse_events__term *term;
@@ -222,7 +268,6 @@ sep_slash_dc: '/' | ':' |
 %%
 
 void parse_events_error(struct list_head *list_all __used,
-			struct list_head *list_event __used,
 			int *idx __used,
 			char const *msg __used)
 {
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8ee219b..a119a53 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -258,9 +258,9 @@ static int pmu_config_term(struct list_head *formats,
 static int pmu_config(struct list_head *formats, struct perf_event_attr *attr,
 		      struct list_head *head_terms)
 {
-	struct parse_events__term *term, *h;
+	struct parse_events__term *term;
 
-	list_for_each_entry_safe(term, h, head_terms, list)
+	list_for_each_entry(term, head_terms, list)
 		if (pmu_config_term(formats, attr, term))
 			return -EINVAL;
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index e30749e..4c1b3d7 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -56,7 +56,7 @@ INTERP my_perl;
 #define FTRACE_MAX_EVENT				\
 	((1 << (sizeof(unsigned short) * 8)) - 1)
 
-struct event *events[FTRACE_MAX_EVENT];
+struct event_format *events[FTRACE_MAX_EVENT];
 
 extern struct scripting_context *scripting_context;
 
@@ -181,7 +181,7 @@ static void define_flag_field(const char *ev_name,
 	LEAVE;
 }
 
-static void define_event_symbols(struct event *event,
+static void define_event_symbols(struct event_format *event,
 				 const char *ev_name,
 				 struct print_arg *args)
 {
@@ -209,6 +209,8 @@ static void define_event_symbols(struct event *event,
 		define_symbolic_values(args->symbol.symbols, ev_name,
 				       cur_field_name);
 		break;
+	case PRINT_BSTRING:
+	case PRINT_DYNAMIC_ARRAY:
 	case PRINT_STRING:
 		break;
 	case PRINT_TYPE:
@@ -220,7 +222,9 @@ static void define_event_symbols(struct event *event,
 		define_event_symbols(event, ev_name, args->op.left);
 		define_event_symbols(event, ev_name, args->op.right);
 		break;
+	case PRINT_FUNC:
 	default:
+		pr_err("Unsupported print arg type\n");
 		/* we should warn... */
 		return;
 	}
@@ -229,10 +233,10 @@ static void define_event_symbols(struct event *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event *find_cache_event(int type)
+static inline struct event_format *find_cache_event(int type)
 {
 	static char ev_name[256];
-	struct event *event;
+	struct event_format *event;
 
 	if (events[type])
 		return events[type];
@@ -258,7 +262,7 @@ static void perl_process_tracepoint(union perf_event *pevent __unused,
 	static char handler[256];
 	unsigned long long val;
 	unsigned long s, ns;
-	struct event *event;
+	struct event_format *event;
 	int type;
 	int pid;
 	int cpu = sample->cpu;
@@ -446,7 +450,7 @@ static int perl_stop_script(void)
 
 static int perl_generate_script(const char *outfile)
 {
-	struct event *event = NULL;
+	struct event_format *event = NULL;
 	struct format_field *f;
 	char fname[PATH_MAX];
 	int not_first, count;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4dcc8f3..93d355d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -481,6 +481,38 @@ static void perf_event__read_swap(union perf_event *event)
 	event->read.id		 = bswap_64(event->read.id);
 }
 
+static u8 revbyte(u8 b)
+{
+	int rev = (b >> 4) | ((b & 0xf) << 4);
+	rev = ((rev & 0xcc) >> 2) | ((rev & 0x33) << 2);
+	rev = ((rev & 0xaa) >> 1) | ((rev & 0x55) << 1);
+	return (u8) rev;
+}
+
+/*
+ * XXX this is hack in attempt to carry flags bitfield
+ * throught endian village. ABI says:
+ *
+ * Bit-fields are allocated from right to left (least to most significant)
+ * on little-endian implementations and from left to right (most to least
+ * significant) on big-endian implementations.
+ *
+ * The above seems to be byte specific, so we need to reverse each
+ * byte of the bitfield. 'Internet' also says this might be implementation
+ * specific and we probably need proper fix and carry perf_event_attr
+ * bitfield flags in separate data file FEAT_ section. Thought this seems
+ * to work for now.
+ */
+static void swap_bitfield(u8 *p, unsigned len)
+{
+	unsigned i;
+
+	for (i = 0; i < len; i++) {
+		*p = revbyte(*p);
+		p++;
+	}
+}
+
 /* exported for swapping attributes in file header */
 void perf_event__attr_swap(struct perf_event_attr *attr)
 {
@@ -494,6 +526,8 @@ void perf_event__attr_swap(struct perf_event_attr *attr)
 	attr->bp_type		= bswap_32(attr->bp_type);
 	attr->bp_addr		= bswap_64(attr->bp_addr);
 	attr->bp_len		= bswap_64(attr->bp_len);
+
+	swap_bitfield((u8 *) (&attr->read_format + 1), sizeof(u64));
 }
 
 static void perf_event__hdr_attr_swap(union perf_event *event)
@@ -1064,8 +1098,9 @@ volatile int session_done;
 static int __perf_session__process_pipe_events(struct perf_session *self,
 					       struct perf_tool *tool)
 {
-	union perf_event event;
-	uint32_t size;
+	union perf_event *event;
+	uint32_t size, cur_size = 0;
+	void *buf = NULL;
 	int skip = 0;
 	u64 head;
 	int err;
@@ -1074,8 +1109,14 @@ static int __perf_session__process_pipe_events(struct perf_session *self,
 	perf_tool__fill_defaults(tool);
 
 	head = 0;
+	cur_size = sizeof(union perf_event);
+
+	buf = malloc(cur_size);
+	if (!buf)
+		return -errno;
 more:
-	err = readn(self->fd, &event, sizeof(struct perf_event_header));
+	event = buf;
+	err = readn(self->fd, event, sizeof(struct perf_event_header));
 	if (err <= 0) {
 		if (err == 0)
 			goto done;
@@ -1085,13 +1126,23 @@ more:
 	}
 
 	if (self->header.needs_swap)
-		perf_event_header__bswap(&event.header);
+		perf_event_header__bswap(&event->header);
 
-	size = event.header.size;
+	size = event->header.size;
 	if (size == 0)
 		size = 8;
 
-	p = &event;
+	if (size > cur_size) {
+		void *new = realloc(buf, size);
+		if (!new) {
+			pr_err("failed to allocate memory to read event\n");
+			goto out_err;
+		}
+		buf = new;
+		cur_size = size;
+		event = buf;
+	}
+	p = event;
 	p += sizeof(struct perf_event_header);
 
 	if (size - sizeof(struct perf_event_header)) {
@@ -1107,9 +1158,9 @@ more:
 		}
 	}
 
-	if ((skip = perf_session__process_event(self, &event, tool, head)) < 0) {
+	if ((skip = perf_session__process_event(self, event, tool, head)) < 0) {
 		pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
-		       head, event.header.size, event.header.type);
+		       head, event->header.size, event->header.type);
 		err = -EINVAL;
 		goto out_err;
 	}
@@ -1124,6 +1175,7 @@ more:
 done:
 	err = 0;
 out_err:
+	free(buf);
 	perf_session__warn_about_errors(self, tool);
 	perf_session_free_sample_buffers(self);
 	return err;
diff --git a/tools/perf/util/types.h b/tools/perf/util/types.h
index 5f3689a..c51fa6b 100644
--- a/tools/perf/util/types.h
+++ b/tools/perf/util/types.h
@@ -16,4 +16,9 @@ typedef signed short	   s16;
 typedef unsigned char	   u8;
 typedef signed char	   s8;
 
+union u64_swap {
+	u64 val64;
+	u32 val32[2];
+};
+
 #endif /* __PERF_TYPES_H */
