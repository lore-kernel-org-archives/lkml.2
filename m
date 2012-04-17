Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab2DQLTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:19:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab2DQLTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:19:31 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 13/16] perf, tool: Support for dwarf cfi unwinding on post processing
Date: Tue, 17 Apr 2012 13:17:18 +0200
Message-Id: <1334661441-4420-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings the support for dwarf cfi unwinding on perf post
processing. Call frame informations are retrieved and then passed
to libunwind that requests memory and register content from the
applications.

Adding unwind object to handle the user stack backtrace based
on the user register values and user stack dump.

The unwind object access the libunwind via remote interface
and provides to it all the necessary data to unwind the stack.

The unwind interface provides following function:
	unwind__get_entries

And callback (specified in above function) to retrieve
the backtrace entries:
	typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry,
					 void *arg);

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile                                |    2 +
 tools/perf/arch/x86/Makefile                       |    3 +
 tools/perf/arch/x86/util/unwind.c                  |  111 ++++
 tools/perf/builtin-report.c                        |   24 +-
 tools/perf/builtin-script.c                        |   56 ++-
 tools/perf/builtin-top.c                           |    5 +-
 tools/perf/util/include/linux/compiler.h           |    1 +
 tools/perf/util/map.h                              |    7 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    3 +-
 .../util/scripting-engines/trace-event-python.c    |    3 +-
 tools/perf/util/session.c                          |  100 +++-
 tools/perf/util/session.h                          |    3 +-
 tools/perf/util/trace-event-scripting.c            |    3 +-
 tools/perf/util/trace-event.h                      |    5 +-
 tools/perf/util/unwind.c                           |  565 ++++++++++++++++++++
 tools/perf/util/unwind.h                           |   34 ++
 16 files changed, 872 insertions(+), 53 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/unwind.c
 create mode 100644 tools/perf/util/unwind.c
 create mode 100644 tools/perf/util/unwind.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 01d67ec..3614b1a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -307,6 +307,7 @@ LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
 LIB_H += util/vdso.h
 LIB_H += util/perf_regs.h
+LIB_H += util/unwind.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -491,6 +492,7 @@ else
 	EXTLIBS += $(LIBUNWIND_LIBS)
 	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
 	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
+	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
 ifdef NO_NEWT
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 744e629..815841c 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -2,4 +2,7 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
+ifndef NO_LIBUNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
+endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/arch/x86/util/unwind.c b/tools/perf/arch/x86/util/unwind.c
new file mode 100644
index 0000000..aed7f5a
--- /dev/null
+++ b/tools/perf/arch/x86/util/unwind.c
@@ -0,0 +1,111 @@
+
+#include <errno.h>
+#include <libunwind.h>
+#include "perf_regs.h"
+#include "../../util/unwind.h"
+
+#ifdef ARCH_X86_64
+int unwind__arch_reg_id(int regnum)
+{
+	int id;
+
+	switch (regnum) {
+	case UNW_X86_64_RAX:
+		id = PERF_X86_64_REG_RAX;
+		break;
+	case UNW_X86_64_RDX:
+		id = PERF_X86_64_REG_RDX;
+		break;
+	case UNW_X86_64_RCX:
+		id = PERF_X86_64_REG_RCX;
+		break;
+	case UNW_X86_64_RBX:
+		id = PERF_X86_64_REG_RBX;
+		break;
+	case UNW_X86_64_RSI:
+		id = PERF_X86_64_REG_RSI;
+		break;
+	case UNW_X86_64_RDI:
+		id = PERF_X86_64_REG_RDI;
+		break;
+	case UNW_X86_64_RBP:
+		id = PERF_X86_64_REG_RBP;
+		break;
+	case UNW_X86_64_RSP:
+		id = PERF_X86_64_REG_RSP;
+		break;
+	case UNW_X86_64_R8:
+		id = PERF_X86_64_REG_R8;
+		break;
+	case UNW_X86_64_R9:
+		id = PERF_X86_64_REG_R9;
+		break;
+	case UNW_X86_64_R10:
+		id = PERF_X86_64_REG_R10;
+		break;
+	case UNW_X86_64_R11:
+		id = PERF_X86_64_REG_R11;
+		break;
+	case UNW_X86_64_R12:
+		id = PERF_X86_64_REG_R12;
+		break;
+	case UNW_X86_64_R13:
+		id = PERF_X86_64_REG_R13;
+		break;
+	case UNW_X86_64_R14:
+		id = PERF_X86_64_REG_R14;
+		break;
+	case UNW_X86_64_R15:
+		id = PERF_X86_64_REG_R15;
+		break;
+	case UNW_X86_64_RIP:
+		id = PERF_X86_64_REG_RIP;
+		break;
+	default:
+		pr_err("unwind: invalid reg id %d\n", regnum);
+		return -EINVAL;
+	}
+
+	return id;
+}
+#else
+int unwind__arch_reg_id(int regnum)
+{
+	int id;
+
+	switch (regnum) {
+	case UNW_X86_EAX:
+		id = PERF_X86_32_REG_EAX;
+		break;
+	case UNW_X86_EDX:
+		id = PERF_X86_32_REG_EDX;
+		break;
+	case UNW_X86_ECX:
+		id = PERF_X86_32_REG_ECX;
+		break;
+	case UNW_X86_EBX:
+		id = PERF_X86_32_REG_EBX;
+		break;
+	case UNW_X86_ESI:
+		id = PERF_X86_32_REG_ESI;
+		break;
+	case UNW_X86_EDI:
+		id = PERF_X86_32_REG_EDI;
+		break;
+	case UNW_X86_EBP:
+		id = PERF_X86_32_REG_EBP;
+		break;
+	case UNW_X86_ESP:
+		id = PERF_X86_32_REG_ESP;
+		break;
+	case UNW_X86_EIP:
+		id = PERF_X86_32_REG_EIP;
+		break;
+	default:
+		pr_err("unwind: invalid reg id %d\n", regnum);
+		return -EINVAL;
+	}
+
+	return id;
+}
+#endif /* ARCH_X86_64 */
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cec2b8c..3753820 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -69,8 +69,8 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 
 	if ((sort__has_parent || symbol_conf.use_callchain)
 	    && sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample->callchain, &parent);
+		err = machine__resolve_callchain(rep->session, machine, evsel,
+						 al->thread, sample, &parent);
 		if (err)
 			return err;
 	}
@@ -130,7 +130,8 @@ out:
 	return err;
 }
 
-static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
+static int perf_evsel__add_hist_entry(struct perf_session *session,
+				      struct perf_evsel *evsel,
 				      struct addr_location *al,
 				      struct perf_sample *sample,
 				      struct machine *machine)
@@ -140,8 +141,8 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	struct hist_entry *he;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
-		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample->callchain, &parent);
+		err = machine__resolve_callchain(session, machine, evsel,
+						 al->thread, sample, &parent);
 		if (err)
 			return err;
 	}
@@ -213,7 +214,8 @@ static int process_sample_event(struct perf_tool *tool,
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
 
-		if (perf_evsel__add_hist_entry(evsel, &al, sample, machine)) {
+		if (perf_evsel__add_hist_entry(rep->session, evsel, &al,
+					       sample, machine)) {
 			pr_debug("problem incrementing symbol period, skipping event\n");
 			return -1;
 		}
@@ -389,17 +391,17 @@ static int __cmd_report(struct perf_report *rep)
 "If some relocation was applied (e.g. kexec) symbols may be misresolved.");
 	}
 
-	if (dump_trace) {
-		perf_session__fprintf_nr_events(session, stdout);
-		goto out_delete;
-	}
-
 	if (verbose > 3)
 		perf_session__fprintf(session, stdout);
 
 	if (verbose > 2)
 		perf_session__fprintf_dsos(session, stdout);
 
+	if (dump_trace) {
+		perf_session__fprintf_nr_events(session, stdout);
+		goto out_delete;
+	}
+
 	nr_samples = 0;
 	list_for_each_entry(pos, &session->evlist->entries, node) {
 		struct hists *hists = &pos->hists;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index d4ce733..0967c97 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -28,6 +28,11 @@ static bool			system_wide;
 static const char		*cpu_list;
 static DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 
+struct perf_script {
+	struct perf_tool tool;
+	struct perf_session *session;
+};
+
 enum perf_output_field {
 	PERF_OUTPUT_COMM            = 1U << 0,
 	PERF_OUTPUT_TID             = 1U << 1,
@@ -373,7 +378,8 @@ static void print_sample_addr(union perf_event *event,
 	}
 }
 
-static void print_sample_bts(union perf_event *event,
+static void print_sample_bts(struct perf_session *session,
+			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct perf_evsel *evsel,
 			     struct machine *machine,
@@ -387,7 +393,7 @@ static void print_sample_bts(union perf_event *event,
 			printf(" ");
 		else
 			printf("\n");
-		perf_event__print_ip(event, sample, machine, evsel,
+		perf_event__print_ip(session, event, sample, machine, evsel,
 				     PRINT_FIELD(SYM), PRINT_FIELD(DSO),
 				     PRINT_FIELD(SYMOFFSET));
 	}
@@ -401,7 +407,8 @@ static void print_sample_bts(union perf_event *event,
 	printf("\n");
 }
 
-static void process_event(union perf_event *event __unused,
+static void process_event(struct perf_session *session,
+			  union perf_event *event __unused,
 			  struct perf_sample *sample,
 			  struct perf_evsel *evsel,
 			  struct machine *machine,
@@ -415,7 +422,8 @@ static void process_event(union perf_event *event __unused,
 	print_sample_start(sample, thread, attr);
 
 	if (is_bts_event(attr)) {
-		print_sample_bts(event, sample, evsel, machine, thread);
+		print_sample_bts(session, event, sample, evsel,
+				 machine, thread);
 		return;
 	}
 
@@ -431,7 +439,7 @@ static void process_event(union perf_event *event __unused,
 			printf(" ");
 		else
 			printf("\n");
-		perf_event__print_ip(event, sample, machine, evsel,
+		perf_event__print_ip(session, event, sample, machine, evsel,
 				     PRINT_FIELD(SYM), PRINT_FIELD(DSO),
 				     PRINT_FIELD(SYMOFFSET));
 	}
@@ -488,6 +496,8 @@ static int process_sample_event(struct perf_tool *tool __used,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
+	struct perf_script *script = container_of(tool, struct perf_script,
+						  tool);
 	struct addr_location al;
 	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
 
@@ -520,24 +530,27 @@ static int process_sample_event(struct perf_tool *tool __used,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, sample, evsel, machine, thread);
+	scripting_ops->process_event(script->session, event, sample, evsel,
+				     machine, thread);
 
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
 
-static struct perf_tool perf_script = {
-	.sample		 = process_sample_event,
-	.mmap		 = perf_event__process_mmap,
-	.comm		 = perf_event__process_comm,
-	.exit		 = perf_event__process_task,
-	.fork		 = perf_event__process_task,
-	.attr		 = perf_event__process_attr,
-	.event_type	 = perf_event__process_event_type,
-	.tracing_data	 = perf_event__process_tracing_data,
-	.build_id	 = perf_event__process_build_id,
-	.ordered_samples = true,
-	.ordering_requires_timestamps = true,
+static struct perf_script perf_script = {
+	.tool = {
+		.sample		 = process_sample_event,
+		.mmap		 = perf_event__process_mmap,
+		.comm		 = perf_event__process_comm,
+		.exit		 = perf_event__process_task,
+		.fork		 = perf_event__process_task,
+		.attr		 = perf_event__process_attr,
+		.event_type	 = perf_event__process_event_type,
+		.tracing_data	 = perf_event__process_tracing_data,
+		.build_id	 = perf_event__process_build_id,
+		.ordered_samples = true,
+		.ordering_requires_timestamps = true,
+	},
 };
 
 extern volatile int session_done;
@@ -553,7 +566,7 @@ static int __cmd_script(struct perf_session *session)
 
 	signal(SIGINT, sig_handler);
 
-	ret = perf_session__process_events(session, &perf_script);
+	ret = perf_session__process_events(session, &perf_script.tool);
 
 	if (debug_mode)
 		pr_err("Misordered timestamps: %" PRIu64 "\n", nr_unordered);
@@ -1335,10 +1348,13 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (!script_name)
 		setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_script);
+	session = perf_session__new(input_name, O_RDONLY, 0, false,
+				    &perf_script.tool);
 	if (session == NULL)
 		return -ENOMEM;
 
+	perf_script.session = session;
+
 	if (cpu_list) {
 		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
 			return -1;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 10184f6..1a4d9b5 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -774,8 +774,9 @@ static void perf_event__process_sample(struct perf_tool *tool,
 
 		if ((sort__has_parent || symbol_conf.use_callchain) &&
 		    sample->callchain) {
-			err = machine__resolve_callchain(machine, evsel, al.thread,
-							 sample->callchain, &parent);
+			err = machine__resolve_callchain(top->session,
+						machine, evsel, al.thread,
+						sample, &parent);
 			if (err)
 				return;
 		}
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 547628e..2dc8671 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -10,5 +10,6 @@
 #endif
 
 #define __used		__attribute__((__unused__))
+#define __packed	__attribute__((__packed__))
 
 #endif
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 81371ba..a27a0a1 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -156,9 +156,12 @@ int machine__init(struct machine *self, const char *root_dir, pid_t pid);
 void machine__exit(struct machine *self);
 void machine__delete(struct machine *self);
 
-int machine__resolve_callchain(struct machine *machine,
+struct perf_session;
+struct perf_sample;
+int machine__resolve_callchain(struct perf_session *session,
+			       struct machine *machine,
 			       struct perf_evsel *evsel, struct thread *thread,
-			       struct ip_callchain *chain,
+			       struct perf_sample *sample,
 			       struct symbol **parent);
 int maps__set_kallsyms_ref_reloc_sym(struct map **maps, const char *symbol_name,
 				     u64 addr);
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index e30749e..ae07098 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -364,7 +364,8 @@ static void perl_process_event_generic(union perf_event *pevent __unused,
 	LEAVE;
 }
 
-static void perl_process_event(union perf_event *pevent,
+static void perl_process_event(struct perf_session *session __used,
+			       union perf_event *pevent,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index c2623c6..c593ba9 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -205,7 +205,8 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-static void python_process_event(union perf_event *pevent __unused,
+static void python_process_event(struct perf_session *session,
+				 union perf_event *pevent __unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel __unused,
 				 struct machine *machine __unused,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a2e1c1b..4920e21 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,8 @@
 #include "util.h"
 #include "cpumap.h"
 #include "vdso.h"
+#include "unwind.h"
+#include "perf_regs.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -292,17 +294,17 @@ struct branch_info *machine__resolve_bstack(struct machine *self,
 	return bi;
 }
 
-int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
-			       struct thread *thread,
-			       struct ip_callchain *chain,
-			       struct symbol **parent)
+static int
+resolve_callchain_sample(struct machine *machine,
+			 struct perf_evsel *evsel,
+			 struct thread *thread,
+			 struct ip_callchain *chain,
+			 struct symbol **parent)
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	unsigned int i;
 	int err;
 
-	callchain_cursor_reset(&evsel->hists.callchain_cursor);
-
 	for (i = 0; i < chain->nr; i++) {
 		u64 ip;
 		struct addr_location al;
@@ -315,11 +317,14 @@ int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
 		if (ip >= PERF_CONTEXT_MAX) {
 			switch (ip) {
 			case PERF_CONTEXT_HV:
-				cpumode = PERF_RECORD_MISC_HYPERVISOR;	break;
+				cpumode = PERF_RECORD_MISC_HYPERVISOR;
+				break;
 			case PERF_CONTEXT_KERNEL:
-				cpumode = PERF_RECORD_MISC_KERNEL;	break;
+				cpumode = PERF_RECORD_MISC_KERNEL;
+				break;
 			case PERF_CONTEXT_USER:
-				cpumode = PERF_RECORD_MISC_USER;	break;
+				cpumode = PERF_RECORD_MISC_USER;
+				break;
 			default:
 				break;
 			}
@@ -327,7 +332,7 @@ int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
 		}
 
 		al.filtered = false;
-		thread__find_addr_location(thread, self, cpumode,
+		thread__find_addr_location(thread, machine, cpumode,
 					   MAP__FUNCTION, ip, &al, NULL);
 		if (al.sym != NULL) {
 			if (sort__has_parent && !*parent &&
@@ -346,6 +351,38 @@ int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
 	return 0;
 }
 
+static int unwind_entry(struct unwind_entry *entry, void *arg)
+{
+	struct callchain_cursor *cursor = arg;
+	return callchain_cursor_append(cursor, entry->ip,
+				       entry->map, entry->sym);
+}
+
+int machine__resolve_callchain(struct perf_session *session,
+			       struct machine *self,
+			       struct perf_evsel *evsel,
+			       struct thread *thread,
+			       struct perf_sample *sample,
+			       struct symbol **parent)
+{
+	int ret;
+
+	callchain_cursor_reset(&evsel->hists.callchain_cursor);
+
+	ret = resolve_callchain_sample(self, evsel, thread,
+				       sample->callchain, parent);
+	if (ret)
+		return ret;
+
+	if (!session->sample_uregs || !session->sample_ustack)
+		return 0;
+
+	return unwind__get_entries(unwind_entry,
+				   &evsel->hists.callchain_cursor,
+				   self, thread,
+				   session->sample_uregs, sample);
+}
+
 static int process_event_synth_tracing_data_stub(union perf_event *event __used,
 						 struct perf_session *session __used)
 {
@@ -772,6 +809,36 @@ static void branch_stack__printf(struct perf_sample *sample)
 			sample->branch_stack->entries[i].to);
 }
 
+static void uregs_printf(struct perf_sample *sample, u64 sample_uregs)
+{
+	struct user_regs *uregs = &sample->uregs;
+	int i = 0, rid = 0;
+
+	if (!uregs->version)
+		return;
+
+	printf("... uregs: mask 0x%" PRIx64 "\n", sample_uregs);
+
+	do {
+		u64 val;
+
+		if (sample_uregs & 1) {
+			val = uregs->regs[i++];
+			printf(".... %-5s 0x%" PRIx64 "\n",
+			       perf_reg_name(rid), val);
+		}
+
+		rid++;
+		sample_uregs >>= 1;
+
+	} while (sample_uregs);
+}
+
+static void ustack_printf(struct perf_sample *sample)
+{
+	printf("... ustack: size %" PRIu64 "\n", sample->stack.size);
+}
+
 static void perf_session__print_tstamp(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_sample *sample)
@@ -822,6 +889,12 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 
 	if (session->sample_type & PERF_SAMPLE_BRANCH_STACK)
 		branch_stack__printf(sample);
+
+	if (session->sample_uregs)
+		uregs_printf(sample, session->sample_uregs);
+
+	if (session->sample_ustack)
+		ustack_printf(sample);
 }
 
 static struct machine *
@@ -1387,7 +1460,8 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 	return NULL;
 }
 
-void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
+void perf_event__print_ip(struct perf_session *session,
+			  union perf_event *event, struct perf_sample *sample,
 			  struct machine *machine, struct perf_evsel *evsel,
 			  int print_sym, int print_dso, int print_symoffset)
 {
@@ -1404,8 +1478,8 @@ void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
 
 	if (symbol_conf.use_callchain && sample->callchain) {
 
-		if (machine__resolve_callchain(machine, evsel, al.thread,
-						sample->callchain, NULL) != 0) {
+		if (machine__resolve_callchain(session, machine, evsel,
+					al.thread, sample, NULL) != 0) {
 			if (verbose)
 				error("Failed to resolve callchain. Skipping\n");
 			return;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 182c0e5..090563a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -154,7 +154,8 @@ static inline int perf_session__synthesize_sample(struct perf_session *session,
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
-void perf_event__print_ip(union perf_event *event, struct perf_sample *sample,
+void perf_event__print_ip(struct perf_session *session,
+			  union perf_event *event, struct perf_sample *sample,
 			  struct machine *machine, struct perf_evsel *evsel,
 			  int print_sym, int print_dso, int print_symoffset);
 
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 18ae6c1..496c8d2 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -35,7 +35,8 @@ static int stop_script_unsupported(void)
 	return 0;
 }
 
-static void process_event_unsupported(union perf_event *event __unused,
+static void process_event_unsupported(struct perf_session *session __used,
+				      union perf_event *event __unused,
 				      struct perf_sample *sample __unused,
 				      struct perf_evsel *evsel __unused,
 				      struct machine *machine __unused,
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 58ae14c..15b3133 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -289,11 +289,14 @@ enum trace_flag_type {
 	TRACE_FLAG_SOFTIRQ		= 0x10,
 };
 
+struct perf_session;
+
 struct scripting_ops {
 	const char *name;
 	int (*start_script) (const char *script, int argc, const char **argv);
 	int (*stop_script) (void);
-	void (*process_event) (union perf_event *event,
+	void (*process_event) (struct perf_session *session,
+			       union perf_event *event,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
new file mode 100644
index 0000000..d1bdcda
--- /dev/null
+++ b/tools/perf/util/unwind.c
@@ -0,0 +1,565 @@
+/*
+ * Post mortem Dwarf CFI based unwinding on top of regs and stack dumps.
+ *
+ * Lots of this code have been borrowed or heavily inspired from parts of
+ * the libunwind 0.99 code which are (amongst other contributors I may have
+ * forgotten):
+ *
+ * Copyright (C) 2002-2007 Hewlett-Packard Co
+ *	Contributed by David Mosberger-Tang <davidm@hpl.hp.com>
+ *
+ * And the bugs have been added by:
+ *
+ * Copyright (C) 2010, Frederic Weisbecker <fweisbec@gmail.com>
+ * Copyright (C) 2012, Jiri Olsa <jolsa@redhat.com>
+ *
+ */
+
+#include <elf.h>
+#include <gelf.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <linux/list.h>
+#include <libunwind.h>
+#include <libunwind-ptrace.h>
+#include "thread.h"
+#include "session.h"
+#include "perf_regs.h"
+#include "unwind.h"
+#include "util.h"
+
+extern int
+UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
+				    unw_word_t ip,
+				    unw_dyn_info_t *di,
+				    unw_proc_info_t *pi,
+				    int need_unwind_info, void *arg);
+
+#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
+
+#define DW_EH_PE_FORMAT_MASK	0x0f	/* format of the encoded value */
+#define DW_EH_PE_APPL_MASK	0x70	/* how the value is to be applied */
+
+/* Pointer-encoding formats: */
+#define DW_EH_PE_omit		0xff
+#define DW_EH_PE_ptr		0x00	/* pointer-sized unsigned value */
+#define DW_EH_PE_udata4		0x03	/* unsigned 32-bit value */
+#define DW_EH_PE_udata8		0x04	/* unsigned 64-bit value */
+#define DW_EH_PE_sdata4		0x0b	/* signed 32-bit value */
+#define DW_EH_PE_sdata8		0x0c	/* signed 64-bit value */
+
+/* Pointer-encoding application: */
+#define DW_EH_PE_absptr		0x00	/* absolute value */
+#define DW_EH_PE_pcrel		0x10	/* rel. to addr. of encoded value */
+
+/*
+ * The following are not documented by LSB v1.3, yet they are used by
+ * GCC, presumably they aren't documented by LSB since they aren't
+ * used on Linux:
+ */
+#define DW_EH_PE_funcrel	0x40	/* start-of-procedure-relative */
+#define DW_EH_PE_aligned	0x50	/* aligned pointer */
+
+/* Flags intentionaly not handled, since they're not needed:
+ * #define DW_EH_PE_indirect      0x80
+ * #define DW_EH_PE_uleb128       0x01
+ * #define DW_EH_PE_udata2        0x02
+ * #define DW_EH_PE_sleb128       0x09
+ * #define DW_EH_PE_sdata2        0x0a
+ * #define DW_EH_PE_textrel       0x20
+ * #define DW_EH_PE_datarel       0x30
+ */
+
+struct unwind_info {
+	struct perf_sample	*sample;
+	struct machine		*machine;
+	struct thread		*thread;
+	u64			sample_uregs;
+};
+
+#define dw_read(ptr, type, end) ({	\
+	type *__p = (type *) ptr;	\
+	type  __v;			\
+	if ((__p + 1) > (type *) end)	\
+		return -EINVAL;		\
+	__v = *__p++;			\
+	ptr = (typeof(ptr)) __p;	\
+	__v;				\
+	})
+
+static int __dw_read_encoded_value(u8 **p, u8 *end, u64 *val,
+				   u8 encoding)
+{
+	u8 *cur = *p;
+	*val = 0;
+
+	switch (encoding) {
+	case DW_EH_PE_omit:
+		*val = 0;
+		goto out;
+	case DW_EH_PE_ptr:
+		*val = dw_read(cur, unsigned long, end);
+		goto out;
+	default:
+		break;
+	}
+
+	switch (encoding & DW_EH_PE_APPL_MASK) {
+	case DW_EH_PE_absptr:
+		break;
+	case DW_EH_PE_pcrel:
+		*val = (unsigned long) cur;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if ((encoding & 0x07) == 0x00)
+		encoding |= DW_EH_PE_udata4;
+
+	switch (encoding & DW_EH_PE_FORMAT_MASK) {
+	case DW_EH_PE_sdata4:
+		*val += dw_read(cur, s32, end);
+		break;
+	case DW_EH_PE_udata4:
+		*val += dw_read(cur, u32, end);
+		break;
+	case DW_EH_PE_sdata8:
+		*val += dw_read(cur, s64, end);
+		break;
+	case DW_EH_PE_udata8:
+		*val += dw_read(cur, u64, end);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+ out:
+	*p = cur;
+	return 0;
+}
+
+#define dw_read_encoded_value(ptr, end, enc) ({			\
+	u64 __v;						\
+	if (__dw_read_encoded_value(&ptr, end, &__v, enc)) {	\
+		return -EINVAL;                                 \
+	}                                                       \
+	__v;                                                    \
+	})
+
+static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
+				    GElf_Shdr *shp, const char *name)
+{
+	Elf_Scn *sec = NULL;
+
+	while ((sec = elf_nextscn(elf, sec)) != NULL) {
+		char *str;
+
+		gelf_getshdr(sec, shp);
+		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
+		if (!strcmp(name, str))
+			break;
+	}
+
+	return sec;
+}
+
+static u64 elf_section_offset(int fd, const char *name)
+{
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	u64 offset = 0;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		return 0;
+
+	do {
+		if (gelf_getehdr(elf, &ehdr) == NULL)
+			break;
+
+		if (!elf_section_by_name(elf, &ehdr, &shdr, name))
+			break;
+
+		offset = shdr.sh_offset;
+	} while (0);
+
+	elf_end(elf);
+	return offset;
+}
+
+struct table_entry {
+	u32 start_ip_offset;
+	u32 fde_offset;
+};
+
+struct eh_frame_hdr {
+	unsigned char version;
+	unsigned char eh_frame_ptr_enc;
+	unsigned char fde_count_enc;
+	unsigned char table_enc;
+
+	/*
+	 * The rest of the header is variable-length and consists of the
+	 * following members:
+	 *
+	 *	encoded_t eh_frame_ptr;
+	 *	encoded_t fde_count;
+	 */
+
+	/* A single encoded pointer should not be more than 8 bytes. */
+	u64 enc[2];
+
+	/*
+	 * struct {
+	 *    encoded_t start_ip;
+	 *    encoded_t fde_addr;
+	 * } binary_search_table[fde_count];
+	 */
+	char data[0];
+} __packed;
+
+static int unwind_spec_ehframe(struct dso *dso, struct machine *machine,
+			       u64 offset, u64 *table_data, u64 *segbase,
+			       u64 *fde_count)
+{
+	struct eh_frame_hdr hdr;
+	u8 *enc = (u8 *) &hdr.enc;
+	u8 *end = (u8 *) &hdr.data;
+	ssize_t r;
+
+	r = dso__data_read_offset(dso, machine, offset,
+				  (u8 *) &hdr, sizeof(hdr));
+	if (r != sizeof(hdr))
+		return -EINVAL;
+
+	/* We dont need eh_frame_ptr, just skip it. */
+	dw_read_encoded_value(enc, end, hdr.eh_frame_ptr_enc);
+
+	*fde_count  = dw_read_encoded_value(enc, end, hdr.fde_count_enc);
+	*segbase    = offset;
+	*table_data = (enc - (u8 *) &hdr) + offset;
+	return 0;
+}
+
+static int read_unwind_spec(struct dso *dso, struct machine *machine,
+			    u64 *table_data, u64 *segbase, u64 *fde_count)
+{
+	int ret = -EINVAL, fd;
+	u64 offset;
+
+	fd = dso__data_fd(dso, machine);
+	if (fd < 0)
+		return -EINVAL;
+
+	offset = elf_section_offset(fd, ".eh_frame_hdr");
+	close(fd);
+
+	if (offset)
+		ret = unwind_spec_ehframe(dso, machine, offset,
+					  table_data, segbase,
+					  fde_count);
+
+	/* TODO .debug_frame check if eh_frame_hdr fails */
+	return ret;
+}
+
+static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
+{
+	struct addr_location al;
+
+	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
+			      MAP__FUNCTION, ip, &al);
+	return al.map;
+}
+
+static int
+find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
+	       int need_unwind_info, void *arg)
+{
+	struct unwind_info *ui = arg;
+	struct map *map;
+	unw_dyn_info_t di;
+	u64 table_data, segbase, fde_count;
+
+	map = find_map(ip, ui);
+	if (!map || !map->dso)
+		return -EINVAL;
+
+	if (read_unwind_spec(map->dso, ui->machine,
+			     &table_data, &segbase, &fde_count))
+		return -EINVAL;
+
+	memset(&di, 0, sizeof(di));
+	di.format   = UNW_INFO_FORMAT_REMOTE_TABLE;
+	di.start_ip = map->start;
+	di.end_ip   = map->end;
+	di.u.rti.segbase    = map->start + segbase;
+	di.u.rti.table_data = map->start + table_data;
+	di.u.rti.table_len  = fde_count * sizeof(struct table_entry)
+			      / sizeof(unw_word_t);
+	return dwarf_search_unwind_table(as, ip, &di, pi,
+					 need_unwind_info, arg);
+}
+
+static int access_fpreg(unw_addr_space_t __used as, unw_regnum_t __used num,
+			unw_fpreg_t __used *val, int __used __write,
+			void __used *arg)
+{
+	pr_err("unwind: access_fpreg unsupported\n");
+	return -UNW_EINVAL;
+}
+
+static int get_dyn_info_list_addr(unw_addr_space_t __used as,
+				  unw_word_t __used *dil_addr,
+				  void __used *arg)
+{
+	return -UNW_ENOINFO;
+}
+
+static int resume(unw_addr_space_t __used as, unw_cursor_t __used *cu,
+		  void __used *arg)
+{
+	pr_err("unwind: resume unsupported\n");
+	return -UNW_EINVAL;
+}
+
+static int
+get_proc_name(unw_addr_space_t __used as, unw_word_t __used addr,
+		char __used *bufp, size_t __used buf_len,
+		unw_word_t __used *offp, void __used *arg)
+{
+	pr_err("unwind: get_proc_name unsupported\n");
+	return -UNW_EINVAL;
+}
+
+static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
+			  unw_word_t *data)
+{
+	struct addr_location al;
+	ssize_t size;
+
+	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
+			      MAP__FUNCTION, addr, &al);
+	if (!al.map) {
+		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
+		return -1;
+	}
+
+	if (!al.map->dso)
+		return -1;
+
+	size = dso__data_read_addr(al.map->dso, al.map, ui->machine,
+				   addr, (u8 *) data, sizeof(*data));
+
+	return !(size == sizeof(*data));
+}
+
+static int reg_value(unw_word_t *valp, struct user_regs *regs, int id,
+		     u64 sample_regs)
+{
+	int i, idx = 0;
+
+	if (!(sample_regs & (1 << id)))
+		return -EINVAL;
+
+	for (i = 0; i < id; i++) {
+		if (sample_regs & (1 << i))
+			idx++;
+	}
+
+	*valp = regs->regs[idx];
+	return 0;
+}
+
+static int access_mem(unw_addr_space_t __used as,
+		      unw_word_t addr, unw_word_t *valp,
+		      int __write, void *arg)
+{
+	struct unwind_info *ui = arg;
+	struct user_stack_dump *stack = &ui->sample->stack;
+	unw_word_t start, end;
+	int offset;
+	int ret;
+
+	/* Don't support write, probably not needed. */
+	if (__write || !stack || !ui->sample->uregs.version) {
+		*valp = 0;
+		return 0;
+	}
+
+	ret = reg_value(&start, &ui->sample->uregs, PERF_REG_SP,
+			ui->sample_uregs);
+	if (ret)
+		return ret;
+
+	end = start + stack->size;
+
+	/* Check overflow. */
+	if (addr + sizeof(unw_word_t) < addr)
+		return -EINVAL;
+
+	if (addr < start || addr + sizeof(unw_word_t) >= end) {
+		ret = access_dso_mem(ui, addr, valp);
+		if (ret) {
+			pr_debug("unwind: access_mem %p not inside range %p-%p\n",
+				(void *)addr, (void *)start, (void *)end);
+			*valp = 0;
+			return ret;
+		}
+		return 0;
+	}
+
+	offset = addr - start;
+	*valp  = *(unw_word_t *)&stack->data[offset];
+	pr_debug("unwind: access_mem %p %lx\n",
+		 (void *)addr, (unsigned long)*valp);
+	return 0;
+}
+
+static int access_reg(unw_addr_space_t __used as,
+		      unw_regnum_t regnum, unw_word_t *valp,
+		      int __write, void *arg)
+{
+	struct unwind_info *ui = arg;
+	int id, ret;
+
+	/* Don't support write, I suspect we don't need it. */
+	if (__write) {
+		pr_err("unwind: access_reg w %d\n", regnum);
+		return 0;
+	}
+
+	if (!ui->sample->uregs.version) {
+		*valp = 0;
+		return 0;
+	}
+
+	id = unwind__arch_reg_id(regnum);
+	if (id < 0)
+		return -EINVAL;
+
+	ret = reg_value(valp, &ui->sample->uregs, id, ui->sample_uregs);
+	if (ret) {
+		pr_err("unwind: can't read reg %d\n", regnum);
+		return ret;
+	}
+
+	pr_debug("unwind: reg %d, val %lx\n", regnum, (unsigned long)*valp);
+	return 0;
+}
+
+static void put_unwind_info(unw_addr_space_t __used as,
+			    unw_proc_info_t *pi __used,
+			    void *arg __used)
+{
+	pr_debug("unwind: put_unwind_info called\n");
+}
+
+static int entry(u64 ip, struct thread *thread, struct machine *machine,
+		 unwind_entry_cb_t cb, void *arg)
+{
+	struct unwind_entry e;
+	struct addr_location al;
+
+	thread__find_addr_location(thread, machine,
+				   PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, ip, &al, NULL);
+
+	e.ip = ip;
+	e.map = al.map;
+	e.sym = al.sym;
+
+	pr_debug("unwind: %s:ip = 0x%" PRIx64 " (0x%" PRIx64 "\n",
+		 al.sym ? al.sym->name : "[]",
+		 ip,
+		 al.map ? al.map->map_ip(al.map, ip) : (u64) 0);
+
+	return cb(&e, arg);
+}
+
+static void display_error(int err)
+{
+	switch (err) {
+	case UNW_EINVAL:
+		pr_err("unwind: Only supports local.\n");
+		break;
+	case UNW_EUNSPEC:
+		pr_err("unwind: Unspecified error.\n");
+		break;
+	case UNW_EBADREG:
+		pr_err("unwind: Register unavailable.\n");
+		break;
+	default:
+		break;
+	}
+}
+
+static unw_accessors_t accessors = {
+	.find_proc_info		= find_proc_info,
+	.put_unwind_info	= put_unwind_info,
+	.get_dyn_info_list_addr	= get_dyn_info_list_addr,
+	.access_mem		= access_mem,
+	.access_reg		= access_reg,
+	.access_fpreg		= access_fpreg,
+	.resume			= resume,
+	.get_proc_name		= get_proc_name,
+};
+
+static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
+		       void *arg)
+{
+	unw_addr_space_t addr_space;
+	unw_cursor_t c;
+	int ret;
+
+	addr_space = unw_create_addr_space(&accessors, 0);
+	if (!addr_space) {
+		pr_err("unwind: Can't create unwind address space.\n");
+		return -ENOMEM;
+	}
+
+	ret = unw_init_remote(&c, addr_space, ui);
+	if (ret)
+		display_error(ret);
+
+	while (!ret && (unw_step(&c) > 0)) {
+		unw_word_t ip;
+
+		unw_get_reg(&c, UNW_REG_IP, &ip);
+		ret = entry(ip, ui->thread, ui->machine, cb, arg);
+	}
+
+	unw_destroy_addr_space(addr_space);
+	return ret;
+}
+
+int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
+			struct machine *machine, struct thread *thread,
+			u64 sample_uregs, struct perf_sample *data)
+{
+	unw_word_t ip;
+	struct unwind_info ui = {
+		.sample       = data,
+		.sample_uregs = sample_uregs,
+		.thread       = thread,
+		.machine      = machine,
+	};
+	int ret;
+
+	if (!data->uregs.version)
+		return -EINVAL;
+
+	ret = reg_value(&ip, &data->uregs, PERF_REG_IP, sample_uregs);
+	if (ret)
+		return ret;
+
+	ret = entry(ip, thread, machine, cb, arg);
+	if (ret)
+		return -ENOMEM;
+
+	return get_entries(&ui, cb, arg);
+}
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
new file mode 100644
index 0000000..919bd6a
--- /dev/null
+++ b/tools/perf/util/unwind.h
@@ -0,0 +1,34 @@
+#ifndef __UNWIND_H
+#define __UNWIND_H
+
+#include "types.h"
+#include "event.h"
+#include "symbol.h"
+
+struct unwind_entry {
+	struct map	*map;
+	struct symbol	*sym;
+	u64		ip;
+};
+
+typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
+
+#ifndef NO_LIBUNWIND_SUPPORT
+int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
+			struct machine *machine,
+			struct thread *thread,
+			u64 sample_uregs,
+			struct perf_sample *data);
+int unwind__arch_reg_id(int regnum);
+#else
+static inline int
+unwind__get_entries(unwind_entry_cb_t cb __used, void *arg __used,
+		    struct machine *machine __used,
+		    struct thread *thread __used,
+		    u64 sample_uregs __used,
+		    struct perf_sample *data __used)
+{
+	return 0;
+}
+#endif /* NO_LIBUNWIND_SUPPORT */
+#endif /* __UNWIND_H */
-- 
1.7.7.6

