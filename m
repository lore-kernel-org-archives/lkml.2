Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab2JTA45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:56:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39040 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab2JTA4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:56:55 -0400
Date: Sat, 20 Oct 2012 02:56:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20121020005647.GA24106@gmail.com>
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

   HEAD: 45bff41a9a6f22af28e4ba22f83c87f619e573a8 perf python: Properly link with libtraceevent

Assorted small fixes.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (4):
      perf python: Initialize 'page_size' variable
      perf python: Link with libtraceevent
      perf hists browser: Add back callchain folding symbol
      perf python: Properly link with libtraceevent

David Ahern (1):
      perf tool: Precise mode requires exclude_guest

David Miller (1):
      perf tools: Fix build on sparc.

Namhyung Kim (3):
      perf tools: Fix segfault when using srcline sort key
      perf tools: Remove warnings on JIT samples for srcline sort key
      perf hists browser: Fix off-by-two bug on the first column

Peter Zijlstra (1):
      perf: Require exclude_guest to use PEBS - kernel side enforcement

Steven Rostedt (2):
      lib tools traceevent: Add back pevent assignment in __pevent_parse_format()
      tools lib traceevent: Fix missed freeing of subargs in free_arg() in filter


 arch/x86/kernel/cpu/perf_event.c    |  6 ++++++
 tools/lib/traceevent/event-parse.c  |  9 ++++++---
 tools/lib/traceevent/parse-filter.c | 15 +++++++++++++++
 tools/perf/Makefile                 | 24 +++++++++++++-----------
 tools/perf/perf.h                   |  2 +-
 tools/perf/ui/browsers/hists.c      |  6 ++++--
 tools/perf/util/parse-events.c      |  3 +++
 tools/perf/util/setup.py            |  2 ++
 tools/perf/util/sort.c              |  6 ++++++
 9 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 915b876..3373f84 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -338,6 +338,9 @@ int x86_setup_perfctr(struct perf_event *event)
 		/* BTS is currently only allowed for user-mode. */
 		if (!attr->exclude_kernel)
 			return -EOPNOTSUPP;
+
+		if (!attr->exclude_guest)
+			return -EOPNOTSUPP;
 	}
 
 	hwc->config |= config;
@@ -380,6 +383,9 @@ int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip) {
 		int precise = 0;
 
+		if (!event->attr.exclude_guest)
+			return -EOPNOTSUPP;
+
 		/* Support for constant skid */
 		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 47264b4..f2989c5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2602,6 +2602,9 @@ find_func_handler(struct pevent *pevent, char *func_name)
 {
 	struct pevent_function_handler *func;
 
+	if (!pevent)
+		return NULL;
+
 	for (func = pevent->func_handlers; func; func = func->next) {
 		if (strcmp(func->name, func_name) == 0)
 			break;
@@ -4938,6 +4941,9 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 		goto event_alloc_failed;
 	}
 
+	/* Add pevent to event so that it can be referenced */
+	event->pevent = pevent;
+
 	ret = event_read_format(event);
 	if (ret < 0) {
 		ret = PEVENT_ERRNO__READ_FORMAT_FAILED;
@@ -5041,9 +5047,6 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	if (event == NULL)
 		return ret;
 
-	/* Add pevent to event so that it can be referenced */
-	event->pevent = pevent;
-
 	if (add_event(pevent, event)) {
 		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
 		goto event_add_failed;
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index ad17855..5ea4326 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -209,7 +209,16 @@ static void free_arg(struct filter_arg *arg)
 	switch (arg->type) {
 	case FILTER_ARG_NONE:
 	case FILTER_ARG_BOOLEAN:
+		break;
+
 	case FILTER_ARG_NUM:
+		free_arg(arg->num.left);
+		free_arg(arg->num.right);
+		break;
+
+	case FILTER_ARG_EXP:
+		free_arg(arg->exp.left);
+		free_arg(arg->exp.right);
 		break;
 
 	case FILTER_ARG_STR:
@@ -218,6 +227,12 @@ static void free_arg(struct filter_arg *arg)
 		free(arg->str.buffer);
 		break;
 
+	case FILTER_ARG_VALUE:
+		if (arg->value.type == FILTER_STRING ||
+		    arg->value.type == FILTER_CHAR)
+			free(arg->value.str);
+		break;
+
 	case FILTER_ARG_OP:
 		free_arg(arg->op.left);
 		free_arg(arg->op.right);
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f7c968a..00deed4d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -184,9 +184,22 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
+TRACE_EVENT_DIR = ../lib/traceevent/
+
+ifneq ($(OUTPUT),)
+	TE_PATH=$(OUTPUT)
+else
+	TE_PATH=$(TRACE_EVENT_DIR)
+endif
+
+LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
+TE_LIB := -L$(TE_PATH) -ltraceevent
+
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
 PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
 
+export LIBTRACEEVENT
+
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
@@ -198,17 +211,6 @@ $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
-TRACE_EVENT_DIR = ../lib/traceevent/
-
-ifneq ($(OUTPUT),)
-	TE_PATH=$(OUTPUT)
-else
-	TE_PATH=$(TRACE_EVENT_DIR)
-endif
-
-LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
-TE_LIB := -L$(TE_PATH) -ltraceevent
-
 #
 # Single 'perf' binary right now:
 #
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2762877..c50985e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -57,7 +57,7 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __sparc__
-#include "../../arch/sparc/include/asm/unistd.h"
+#include "../../arch/sparc/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
 #define CPUINFO_PROC	"cpu"
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0568536..ef2f93c 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -610,6 +610,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
 	off_t row_offset = entry->row_offset;
+	bool first = true;
 
 	if (current_entry) {
 		browser->he_selection = entry;
@@ -633,10 +634,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			if (!perf_hpp__format[i].cond)
 				continue;
 
-			if (i) {
+			if (!first) {
 				slsmg_printf("  ");
 				width -= 2;
 			}
+			first = false;
 
 			if (perf_hpp__format[i].color) {
 				hpp.ptr = &percent;
@@ -645,7 +647,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 
 				ui_browser__set_percent_color(&browser->b, percent, current_entry);
 
-				if (i == 0 && symbol_conf.use_callchain) {
+				if (i == PERF_HPP__OVERHEAD && symbol_conf.use_callchain) {
 					slsmg_printf("%c ", folded_sign);
 					width -= 2;
 				}
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index aed38e4..75c7b0f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -690,6 +690,9 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 			eH = 0;
 		} else if (*str == 'p') {
 			precise++;
+			/* use of precise requires exclude_guest */
+			if (!exclude_GH)
+				eG = 1;
 		} else
 			break;
 
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index d0f9f29..73d5102 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -23,6 +23,7 @@ cflags += getenv('CFLAGS', '').split()
 
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
 build_tmp = getenv('PYTHON_EXTBUILD_TMP')
+libtraceevent = getenv('LIBTRACEEVENT')
 
 ext_sources = [f.strip() for f in file('util/python-ext-sources')
 				if len(f.strip()) > 0 and f[0] != '#']
@@ -31,6 +32,7 @@ perf = Extension('perf',
 		  sources = ext_sources,
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
+		  extra_objects = [libtraceevent],
                  )
 
 setup(name='perf',
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b5b1b92..cfd1c0f 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -260,6 +260,12 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (path != NULL)
 		goto out_path;
 
+	if (!self->ms.map)
+		goto out_ip;
+
+	if (!strncmp(self->ms.map->dso->long_name, "/tmp/perf-", 10))
+		goto out_ip;
+
 	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
 		 self->ms.map->dso->long_name, self->ip);
 	fp = popen(cmd, "r");
