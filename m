Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab1AMMwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:52:06 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40009 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab1AMMwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:52:00 -0500
X-AuditID: b753bd60-a1763ba000000f65-14-4d2ef56c26f5
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 6/6] perf probe: Add filters support for
	available functions
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Jan 2011 21:46:30 +0900
Message-ID: <20110113124630.22426.61744.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add filters support for available function list.
Default filter is "!_*" for filtering out local-purpose
symbols.

e.g.)
 # perf probe --filter="add*" -F
add_disk
add_disk_randomness
add_input_randomness
add_interrupt_randomness
add_memory
add_page_to_unevictable_list
add_page_wait_queue
...

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/Documentation/perf-probe.txt |    9 +++++----
 tools/perf/builtin-probe.c              |   19 +++++++++++++------
 tools/perf/util/probe-event.c           |   23 +++++++++++++----------
 tools/perf/util/probe-event.h           |    2 +-
 4 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 7542e8a..32d4af3 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -74,9 +74,10 @@ OPTIONS
 	variables.
 
 --filter=FILTER::
-	(Only for --vars) Set filter for variables. FILTER is a combination of
-	glob pattern, see FILTER PATTERN for detail.
-	Default FILTER is "!__k???tab_* & !__crc_*".
+	(Only for --vars and --funcs) Set filter for variables. FILTER is a
+	combination of glob pattern, see FILTER PATTERN for detail.
+	Default FILTER is "!__k???tab_* & !__crc_*" for --vars, and "!_*"
+	for --funcs.
 	If several filters are specified, only the last filter is valid.
 
 -f::
@@ -143,7 +144,7 @@ This provides some sort of flexibility and robustness to probe point definitions
 
 FILTER PATTERN
 --------------
- The filter pattern is glob matching pattern(s) to filter variables.
+ The filter pattern is glob matching pattern(s) to filter variables or functions.
  In addition, you can use "!" for specifying filter-out rule. You also can give several rules combined with "&" or "|", and fold those rules as one rule by using "(" ")".
 
 e.g.
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index abb423e..fcde003 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -45,6 +45,7 @@
 #include "util/probe-event.h"
 
 #define DEFAULT_VAR_FILTER "!__k???tab_* & !__crc_*"
+#define DEFAULT_FUNC_FILTER "!_*"
 #define MAX_PATH_LEN 256
 
 /* Session management structure */
@@ -159,6 +160,7 @@ static int opt_show_vars(const struct option *opt __used,
 
 	return ret;
 }
+#endif
 
 static int opt_set_filter(const struct option *opt __used,
 			  const char *str, int unset __used)
@@ -180,7 +182,6 @@ static int opt_set_filter(const struct option *opt __used,
 
 	return 0;
 }
-#endif
 
 static const char * const probe_usage[] = {
 	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
@@ -236,10 +237,6 @@ static const struct option options[] = {
 		     "Show accessible variables on PROBEDEF", opt_show_vars),
 	OPT_BOOLEAN('\0', "externs", &params.show_ext_vars,
 		    "Show external variables too (with --vars only)"),
-	OPT_CALLBACK('\0', "filter", NULL,
-		     "[!]FILTER", "Set a variable filter (with --vars only)\n"
-		     "\t\t\t(default: \"" DEFAULT_VAR_FILTER "\")",
-		     opt_set_filter),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_STRING('s', "source", &symbol_conf.source_prefix,
@@ -252,6 +249,11 @@ static const struct option options[] = {
 		 "Set how many probe points can be found for a probe."),
 	OPT_BOOLEAN('F', "funcs", &params.show_funcs,
 		    "Show potential probe-able functions."),
+	OPT_CALLBACK('\0', "filter", NULL,
+		     "[!]FILTER", "Set a filter (with --vars/funcs only)\n"
+		     "\t\t\t(default: \"" DEFAULT_VAR_FILTER "\" for --vars,\n"
+		     "\t\t\t \"" DEFAULT_FUNC_FILTER "\" for --funcs)",
+		     opt_set_filter),
 	OPT_END()
 };
 
@@ -322,7 +324,12 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			pr_err("  Error: Don't use --funcs with --vars.\n");
 			usage_with_options(probe_usage, options);
 		}
-		ret = show_available_funcs(params.target_module);
+		if (!params.filter)
+			params.filter = strfilter__new(DEFAULT_FUNC_FILTER,
+						       NULL);
+		ret = show_available_funcs(params.target_module,
+					   params.filter);
+		strfilter__delete(params.filter);
 		if (ret < 0)
 			pr_err("  Error: Failed to show functions."
 			       " (%d)\n", ret);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b231a20..ebf73ae 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1951,21 +1951,23 @@ int del_perf_probe_events(struct strlist *dellist)
 
 	return ret;
 }
+/* TODO: don't use a global variable for filter ... */
+static struct strfilter *available_func_filter;
 
 /*
- * If a symbol corresponds to a function with global binding return 0.
- * For all others return 1.
+ * If a symbol corresponds to a function with global binding and
+ * matches filter return 0. For all others return 1.
  */
-static int filter_non_global_functions(struct map *map __unused,
-					struct symbol *sym)
+static int filter_available_functions(struct map *map __unused,
+				      struct symbol *sym)
 {
-	if (sym->binding != STB_GLOBAL)
-		return 1;
-
-	return 0;
+	if (sym->binding == STB_GLOBAL &&
+	    strfilter__match(available_func_filter, sym->name))
+		return 0;
+	return 1;
 }
 
-int show_available_funcs(const char *module)
+int show_available_funcs(const char *module, struct strfilter *_filter)
 {
 	struct map *map;
 	int ret;
@@ -1981,7 +1983,8 @@ int show_available_funcs(const char *module)
 		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
 		return -EINVAL;
 	}
-	if (map__load(map, filter_non_global_functions)) {
+	available_func_filter = _filter;
+	if (map__load(map, filter_available_functions)) {
 		pr_err("Failed to load map.\n");
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 4e80b2b..3434fc9 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -128,7 +128,7 @@ extern int show_line_range(struct line_range *lr, const char *module);
 extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			       int max_probe_points, const char *module,
 			       struct strfilter *filter, bool externs);
-extern int show_available_funcs(const char *module);
+extern int show_available_funcs(const char *module, struct strfilter *filter);
 
 
 /* Maximum index number of event-name postfix */

