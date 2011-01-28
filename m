Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1A1VFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 16:05:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:49945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1A1VFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 16:05:32 -0500
Date: Fri, 28 Jan 2011 21:04:55 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        chase.douglas@canonical.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        fbuihuu@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com,
        chase.douglas@canonical.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110120141545.25915.85930.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110120141545.25915.85930.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Add filters support for available functions
Message-ID: <tip-3c42258c9a4db70133fa6946a275b62a16792bb5@git.kernel.org>
Git-Commit-ID: 3c42258c9a4db70133fa6946a275b62a16792bb5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 21:04:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c42258c9a4db70133fa6946a275b62a16792bb5
Gitweb:     http://git.kernel.org/tip/3c42258c9a4db70133fa6946a275b62a16792bb5
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 20 Jan 2011 23:15:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 28 Jan 2011 09:20:25 -0200

perf probe: Add filters support for available functions

Add filters support for available function list.

Default filter is "!_*" for filtering out local-purpose symbols.

e.g.:
 # perf probe --filter="add*" -F
add_disk
add_disk_randomness
add_input_randomness
add_interrupt_randomness
add_memory
add_page_to_unevictable_list
add_page_wait_queue
...

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Chase Douglas <chase.douglas@canonical.com>
Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20110120141545.25915.85930.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    9 +++++----
 tools/perf/builtin-probe.c              |   19 +++++++++++++------
 tools/perf/util/probe-event.c           |   23 +++++++++++++----------
 tools/perf/util/probe-event.h           |    2 +-
 4 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 32fb18f..81c3220 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -78,10 +78,11 @@ OPTIONS
 	Show available functions in given module or kernel.
 
 --filter=FILTER::
-	(Only for --vars) Set filter for variables. FILTER is a combination of
-	glob pattern, see FILTER PATTERN for details.
-	Default FILTER is "!__k???tab_* & !__crc_*".
-	If several filters are specified, only the last filter is valid.
+	(Only for --vars and --funcs) Set filter. FILTER is a combination of glob
+	pattern, see FILTER PATTERN for detail.
+	Default FILTER is "!__k???tab_* & !__crc_*" for --vars, and "!_*"
+	for --funcs.
+	If several filters are specified, only the last filter is used.
 
 -f::
 --force::
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
index 077e051..9d237e3 100644
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
+	    strfilter__compare(available_func_filter, sym->name))
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
