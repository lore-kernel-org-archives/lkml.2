Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2LGHfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:35:53 -0500
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:44421 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825Ab2LGHfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:35:51 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2012 02:35:51 EST
X-AuditID: 1209190d-b7f266d00000092b-b5-50c19b293f2b
Date: Fri, 7 Dec 2012 02:30:44 -0500
From: Greg Price <price@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20121207072726.GY22203@biohazard-cafe.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42IR4hTV1tWafTDA4OhWRouLbRfZLA48PsBi
	sXXvGxaLo2f/Mllc3jWHzeLSgQVMFmuOLGZ3YPe48pTD43SPnsfOWXfZPd7vu8rmMXdXH6PH
	501yAWxRXDYpqTmZZalF+nYJXBknryoXzHKpeHKok7mB8YdRFyMnh4SAicS8qYcZIWwxiQv3
	1rN1MXJxCAnsY5SYfuAnO4SznlFi7uxZrBDOD0aJTydnsYG0sAioSNz+8ooFxGYTUJD4MX8d
	M4gtAmRv7n0G1sAs8IdRorFpJVARB4ewQIjE9gZGEJNXwFqiYak1SDmvgKDEyZlPwMYwC2hJ
	3Pj3kgmkhFlAWmL5Pw6QsCjQpmv729kmMPLPQtIxC0nHLISOBYzMqxhlU3KrdHMTM3OKU5N1
	i5MT8/JSi3SN9HIzS/RSU0o3MYLDW5J3B+O7g0qHGAU4GJV4eAXOHwgQYk0sK67MPcQoycGk
	JMorPO1ggBBfUn5KZUZicUZ8UWlOavEhRgkOZiUR3o4+oBxvSmJlVWpRPkxKmoNFSZz3SspN
	fyGB9MSS1OzU1ILUIpisDAeHkgRv9kygRsGi1PTUirTMnBKENBMHJ8hwHqDhESA1vMUFibnF
	mekQ+VOMilLivMdBEgIgiYzSPLheWPp5xSgO9Iow7yaQKh5g6oLrfgU0mAlocBT7fpDBJYkI
	KakGRk+Og+ylzJ7lRjVqUs3MX158ur7rTLVGaMMHwevvlk/o3zynje2NWf+6niXO8x//y2tf
	ECzz6cHj6R/nbnIIVV+w8OiCN4t7ArtC9bSc/jWbuu/6/WLugoZrZ870ZN/ev/nOeTMFnZmL
	W1avXOex82zgWbMdkS1HFjVv9jUUfTTVUFGhW6BwnYQSS3FGoqEWc1FxIgDOH2s+GgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an application has an expensive function implemented with a large
tree of calls to helper functions, the default call-graph presentation
will be dominated by the many different call-chains within that
function.  By treating the function as a black box, we can collect the
call-chains leading into the function and compactly identify what to
blame for expensive calls.

For example, in this report the callers of garbage_collect() are
scattered across the tree:
$ perf report -d ruby 2>- | grep -m10 ^[^#]*[a-z]
    22.03%     ruby  [.] gc_mark
               --- gc_mark
                  |--59.40%-- mark_keyvalue
                  |          st_foreach
                  |          gc_mark_children
                  |          |--99.75%-- rb_gc_mark
                  |          |          rb_vm_mark
                  |          |          gc_mark_children
                  |          |          gc_marks
                  |          |          |--99.00%-- garbage_collect

If we make garbage_collect() a black box, its callers are coalesced:
$ perf report --blackbox garbage_collect -d ruby 2>- | grep -m10 ^[^#]*[a-z]
    72.92%     ruby  [.] garbage_collect
               --- garbage_collect
                   vm_xmalloc
                  |--47.08%-- ruby_xmalloc
                  |          st_insert2
                  |          rb_hash_aset
                  |          |--98.45%-- features_index_add
                  |          |          rb_provide_feature
                  |          |          rb_require_safe
                  |          |          vm_call_method

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Greg Price <price@mit.edu>
---
 tools/perf/builtin-report.c | 17 +++++++++++++++--
 tools/perf/builtin-top.c    |  3 +--
 tools/perf/util/map.h       |  4 +++-
 tools/perf/util/session.c   | 29 ++++++++++++++++++-----------
 tools/perf/util/session.h   |  5 +++++
 5 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a61725d..3bbda35 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -70,7 +70,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 	if ((sort__has_parent || symbol_conf.use_callchain)
 	    && sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent);
+						 sample, &parent, al);
 		if (err)
 			return err;
 	}
@@ -141,7 +141,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
 		err = machine__resolve_callchain(machine, evsel, al->thread,
-						 sample, &parent);
+						 sample, &parent, al);
 		if (err)
 			return err;
 	}
@@ -607,6 +607,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN('G', "inverted", &report.inverted_callchain,
 		    "alias for inverted call graph"),
+	OPT_STRING(0, "blackbox", &blackbox_pattern, "regex",
+		   "functions to treat as black boxes in call graphs, collapsing callees"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('c', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
@@ -687,6 +689,17 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	}
 
+	if (blackbox_pattern) {
+		int err = regcomp(&blackbox_regex, blackbox_pattern, REG_EXTENDED);
+		if (err) {
+			char buf[BUFSIZ];
+			regerror(err, &blackbox_regex, buf, sizeof(buf));
+			pr_err("Invalid blackbox regex: %s\n%s", blackbox_pattern, buf);
+			goto error;
+		}
+		have_blackbox = 1;
+	}
+
 	if (strcmp(report.input_name, "-") != 0)
 		setup_browser(true);
 	else {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ff6db80..ee969b5 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -786,8 +786,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		    sample->callchain) {
 			err = machine__resolve_callchain(machine, evsel,
 							 al.thread, sample,
-							 &parent);
-
+							 &parent, NULL);
 			if (err)
 				return;
 		}
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index d2250fc..6d1b8e1 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -23,6 +23,7 @@ struct ref_reloc_sym;
 struct map_groups;
 struct machine;
 struct perf_evsel;
+struct addr_location;
 
 struct map {
 	union {
@@ -163,7 +164,8 @@ int machine__resolve_callchain(struct machine *machine,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
 			       struct perf_sample *sample,
-			       struct symbol **parent);
+			       struct symbol **parent,
+			       struct addr_location *root_al);
 int maps__set_kallsyms_ref_reloc_sym(struct map **maps, const char *symbol_name,
 				     u64 addr);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8cdd232..9a8798c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -19,6 +19,10 @@
 #include "unwind.h"
 #include "vdso.h"
 
+regex_t blackbox_regex;
+const char *blackbox_pattern;
+int have_blackbox = 0;
+
 static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
@@ -226,11 +230,10 @@ void machine__remove_thread(struct machine *self, struct thread *th)
 	list_add_tail(&th->node, &self->dead_threads);
 }
 
-static bool symbol__match_parent_regex(struct symbol *sym)
+static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 {
-	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
+	if (sym->name && !regexec(regex, sym->name, 0, NULL, 0))
 		return 1;
-
 	return 0;
 }
 
@@ -295,8 +298,8 @@ struct branch_info *machine__resolve_bstack(struct machine *self,
 static int machine__resolve_callchain_sample(struct machine *machine,
 					     struct thread *thread,
 					     struct ip_callchain *chain,
-					     struct symbol **parent)
-
+					     struct symbol **parent,
+					     struct addr_location *root_al)
 {
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	unsigned int i;
@@ -347,8 +350,13 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 					   MAP__FUNCTION, ip, &al, NULL);
 		if (al.sym != NULL) {
 			if (sort__has_parent && !*parent &&
-			    symbol__match_parent_regex(al.sym))
+			    symbol__match_regex(al.sym, &parent_regex))
 				*parent = al.sym;
+			else if (have_blackbox && root_al &&
+			         symbol__match_regex(al.sym, &blackbox_regex)) {
+				*root_al = al;
+				callchain_cursor_reset(&callchain_cursor);
+			}
 			if (!symbol_conf.use_callchain)
 				break;
 		}
@@ -373,15 +381,15 @@ int machine__resolve_callchain(struct machine *machine,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
 			       struct perf_sample *sample,
-			       struct symbol **parent)
-
+			       struct symbol **parent,
+			       struct addr_location *root_al)
 {
 	int ret;
 
 	callchain_cursor_reset(&callchain_cursor);
 
 	ret = machine__resolve_callchain_sample(machine, thread,
-						sample->callchain, parent);
+	                                        sample->callchain, parent, root_al);
 	if (ret)
 		return ret;
 
@@ -1603,9 +1611,8 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 
 	if (symbol_conf.use_callchain && sample->callchain) {
 
-
 		if (machine__resolve_callchain(machine, evsel, al.thread,
-					       sample, NULL) != 0) {
+					       sample, NULL, NULL) != 0) {
 			if (verbose)
 				error("Failed to resolve callchain. Skipping\n");
 			return;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 0eae00a..6db3e55 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_SESSION_H
 #define __PERF_SESSION_H
 
+#include <regex.h>
 #include "hist.h"
 #include "event.h"
 #include "header.h"
@@ -9,6 +10,10 @@
 #include <linux/rbtree.h>
 #include <linux/perf_event.h>
 
+extern regex_t blackbox_regex;
+extern const char *blackbox_pattern;
+extern int have_blackbox;
+
 struct sample_queue;
 struct ip_callchain;
 struct thread;
-- 
1.7.11.3

