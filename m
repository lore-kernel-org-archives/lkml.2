Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2D0GcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:32:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44294 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2D0GcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:32:12 -0400
Date: Fri, 27 Apr 2012 08:32:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120427063206.GA19802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 724b6daa13e100067c30cfc4d1ad06629609dc4e perf: Fix perf_event_for_each() to use sibling

 Thanks,

	Ingo

------------------>
David Ahern (1):
      perf report: Fix crash showing warning related to kernel maps

Gleb Natapov (1):
      perf tools: Add 'G' and 'H' modifiers to event parsing

Jiri Olsa (1):
      perf symbols: Read plt symbols from proper symtab_type binary

Mark Brown (1):
      tracing: Fix build breakage without CONFIG_PERF_EVENTS (again)

Michael Ellerman (1):
      perf: Fix perf_event_for_each() to use sibling

Otavio Salvador (1):
      perf tools: Drop CROSS_COMPILE from flex and bison calls

Steven Rostedt (2):
      tracing: Fix regression with tracing_on
      tracing: Fix stacktrace of latency tracers (irqsoff and friends)


 kernel/events/core.c           |    2 +-
 kernel/trace/trace.c           |    8 +++++---
 kernel/trace/trace.h           |    4 ++--
 kernel/trace/trace_output.c    |    5 +++++
 tools/perf/Makefile            |    4 ++--
 tools/perf/builtin-report.c    |   17 ++++++++++++-----
 tools/perf/builtin-test.c      |   30 ++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.l |    2 +-
 tools/perf/util/symbol.c       |   13 ++++++-------
 9 files changed, 64 insertions(+), 21 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6a9ec4..fd126f8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3183,7 +3183,7 @@ static void perf_event_for_each(struct perf_event *event,
 	perf_event_for_each_child(event, func);
 	func(event);
 	list_for_each_entry(sibling, &event->sibling_list, group_entry)
-		perf_event_for_each_child(event, func);
+		perf_event_for_each_child(sibling, func);
 	mutex_unlock(&ctx->mutex);
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed7b5d1..2a22255 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4629,7 +4629,8 @@ static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
 {
-	struct ring_buffer *buffer = filp->private_data;
+	struct trace_array *tr = filp->private_data;
+	struct ring_buffer *buffer = tr->buffer;
 	char buf[64];
 	int r;
 
@@ -4647,7 +4648,8 @@ static ssize_t
 rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
-	struct ring_buffer *buffer = filp->private_data;
+	struct trace_array *tr = filp->private_data;
+	struct ring_buffer *buffer = tr->buffer;
 	unsigned long val;
 	int ret;
 
@@ -4734,7 +4736,7 @@ static __init int tracer_init_debugfs(void)
 			  &trace_clock_fops);
 
 	trace_create_file("tracing_on", 0644, d_tracer,
-			    global_trace.buffer, &rb_simple_fops);
+			    &global_trace, &rb_simple_fops);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 95059f0..f95d65d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -836,11 +836,11 @@ extern const char *__stop___trace_bprintk_fmt[];
 		     filter)
 #include "trace_entries.h"
 
-#ifdef CONFIG_FUNCTION_TRACER
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_FUNCTION_TRACER)
 int perf_ftrace_event_register(struct ftrace_event_call *call,
 			       enum trace_reg type, void *data);
 #else
 #define perf_ftrace_event_register NULL
-#endif /* CONFIG_FUNCTION_TRACER */
+#endif
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 859fae6..df611a0 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -652,6 +652,8 @@ int trace_print_lat_context(struct trace_iterator *iter)
 {
 	u64 next_ts;
 	int ret;
+	/* trace_find_next_entry will reset ent_size */
+	int ent_size = iter->ent_size;
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent,
 			   *next_entry = trace_find_next_entry(iter, NULL,
@@ -660,6 +662,9 @@ int trace_print_lat_context(struct trace_iterator *iter)
 	unsigned long abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
 	unsigned long rel_usecs;
 
+	/* Restore the original ent_size */
+	iter->ent_size = ent_size;
+
 	if (!next_entry)
 		next_ts = iter->ts;
 	rel_usecs = ns2usecs(next_ts - iter->ts);
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 03059e7..9bf3fc7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -234,8 +234,8 @@ endif
 
 export PERL_PATH
 
-FLEX = $(CROSS_COMPILE)flex
-BISON= $(CROSS_COMPILE)bison
+FLEX = flex
+BISON= bison
 
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2e31743..cdae9b2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -374,16 +374,23 @@ static int __cmd_report(struct perf_report *rep)
 	    (kernel_map->dso->hit &&
 	     (kernel_kmap->ref_reloc_sym == NULL ||
 	      kernel_kmap->ref_reloc_sym->addr == 0))) {
-		const struct dso *kdso = kernel_map->dso;
+		const char *desc =
+		    "As no suitable kallsyms nor vmlinux was found, kernel samples\n"
+		    "can't be resolved.";
+
+		if (kernel_map) {
+			const struct dso *kdso = kernel_map->dso;
+			if (!RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION])) {
+				desc = "If some relocation was applied (e.g. "
+				       "kexec) symbols may be misresolved.";
+			}
+		}
 
 		ui__warning(
 "Kernel address maps (/proc/{kallsyms,modules}) were restricted.\n\n"
 "Check /proc/sys/kernel/kptr_restrict before running 'perf record'.\n\n%s\n\n"
 "Samples in kernel modules can't be resolved as well.\n\n",
-			    RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION]) ?
-"As no suitable kallsyms nor vmlinux was found, kernel samples\n"
-"can't be resolved." :
-"If some relocation was applied (e.g. kexec) symbols may be misresolved.");
+		desc);
 	}
 
 	if (dump_trace) {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1c5b980..223ffdc 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -851,6 +851,28 @@ static int test__checkevent_symbolic_name_modifier(struct perf_evlist *evlist)
 	return test__checkevent_symbolic_name(evlist);
 }
 
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
 static int test__checkevent_symbolic_alias_modifier(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = list_entry(evlist->entries.next,
@@ -1091,6 +1113,14 @@ static struct test__event_st {
 		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
 		.check = test__checkevent_list,
 	},
+	{
+		.name  = "instructions:G",
+		.check = test__checkevent_exclude_host_modifier,
+	},
+	{
+		.name  = "instructions:H",
+		.check = test__checkevent_exclude_guest_modifier,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 05d766e..1fcf1bb 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -54,7 +54,7 @@ num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
-modifier_event	[ukhp]{1,5}
+modifier_event	[ukhpGH]{1,8}
 modifier_bp	[rwx]
 
 %%
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c0a028c..ab9867b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -977,8 +977,9 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
  * And always look at the original dso, not at debuginfo packages, that
  * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
  */
-static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
-				       symbol_filter_t filter)
+static int
+dso__synthesize_plt_symbols(struct dso *dso, char *name, struct map *map,
+			    symbol_filter_t filter)
 {
 	uint32_t nr_rel_entries, idx;
 	GElf_Sym sym;
@@ -993,10 +994,7 @@ static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
 	char sympltname[1024];
 	Elf *elf;
 	int nr = 0, symidx, fd, err = 0;
-	char name[PATH_MAX];
 
-	snprintf(name, sizeof(name), "%s%s",
-		 symbol_conf.symfs, dso->long_name);
 	fd = open(name, O_RDONLY);
 	if (fd < 0)
 		goto out;
@@ -1703,8 +1701,9 @@ restart:
 			continue;
 
 		if (ret > 0) {
-			int nr_plt = dso__synthesize_plt_symbols(dso, map,
-								 filter);
+			int nr_plt;
+
+			nr_plt = dso__synthesize_plt_symbols(dso, name, map, filter);
 			if (nr_plt > 0)
 				ret += nr_plt;
 			break;
