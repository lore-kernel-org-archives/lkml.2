Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab1A1RNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:13:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43486 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab1A1RNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:13:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Chase Douglas <chase.douglas@canonical.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf probe: Add variable filter support
Date: Fri, 28 Jan 2011 15:13:01 -0200
Message-Id: <1296234783-17491-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296234783-17491-1-git-send-email-acme@infradead.org>
References: <1296234783-17491-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add filters support for available variable list.

Default filter is "!__k???tab_*&!__crc_*" for filtering out
automatically generated symbols.

The format of filter rule is "[!]GLOBPATTERN", so you can use wild
cards. If the filter rule starts with '!', matched variables are filter
out.

e.g.:
 # perf probe -V schedule --externs --filter=cpu*
Available variables at schedule
        @<schedule+0>
                cpumask_var_t   cpu_callout_mask
                cpumask_var_t   cpu_core_map
                cpumask_var_t   cpu_isolated_map
                cpumask_var_t   cpu_sibling_map
                int     cpu_number
                long unsigned int*      cpu_bit_bitmap
		...

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Chase Douglas <chase.douglas@canonical.com>
Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20110120141539.25915.43401.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
[ committer note: Removed the elf.h include as it was fixed up in e80711c]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |   14 +++++++
 tools/perf/builtin-probe.c              |   34 ++++++++++++++++
 tools/perf/util/probe-event.c           |   66 +++++++++++++++++++------------
 tools/perf/util/probe-event.h           |    3 +-
 4 files changed, 90 insertions(+), 27 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index fcc51fe..32fb18f 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -77,6 +77,12 @@ OPTIONS
 --funcs::
 	Show available functions in given module or kernel.
 
+--filter=FILTER::
+	(Only for --vars) Set filter for variables. FILTER is a combination of
+	glob pattern, see FILTER PATTERN for details.
+	Default FILTER is "!__k???tab_* & !__crc_*".
+	If several filters are specified, only the last filter is valid.
+
 -f::
 --force::
 	Forcibly add events with existing name.
@@ -139,6 +145,14 @@ e.g.
 
 This provides some sort of flexibility and robustness to probe point definitions against minor code changes. For example, actual 10th line of schedule() can be moved easily by modifying schedule(), but the same line matching 'rq=cpu_rq*' may still exist in the function.)
 
+FILTER PATTERN
+--------------
+ The filter pattern is a glob matching pattern(s) to filter variables.
+ In addition, you can use "!" for specifying filter-out rule. You also can give several rules combined with "&" or "|", and fold those rules as one rule by using "(" ")".
+
+e.g.
+ With --filter "foo* | bar*", perf probe -V shows variables which start with "foo" or "bar".
+ With --filter "!foo* & *bar", perf probe -V shows variables which don't start with "foo" and end with "bar", like "fizzbar". But "foobar" is filtered out.
 
 EXAMPLES
 --------
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 6cf708a..abb423e 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -36,6 +36,7 @@
 #include "builtin.h"
 #include "util/util.h"
 #include "util/strlist.h"
+#include "util/strfilter.h"
 #include "util/symbol.h"
 #include "util/debug.h"
 #include "util/debugfs.h"
@@ -43,6 +44,7 @@
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
 
+#define DEFAULT_VAR_FILTER "!__k???tab_* & !__crc_*"
 #define MAX_PATH_LEN 256
 
 /* Session management structure */
@@ -60,6 +62,7 @@ static struct {
 	struct line_range line_range;
 	const char *target_module;
 	int max_probe_points;
+	struct strfilter *filter;
 } params;
 
 /* Parse an event definition. Note that any error must die. */
@@ -156,6 +159,27 @@ static int opt_show_vars(const struct option *opt __used,
 
 	return ret;
 }
+
+static int opt_set_filter(const struct option *opt __used,
+			  const char *str, int unset __used)
+{
+	const char *err;
+
+	if (str) {
+		pr_debug2("Set filter: %s\n", str);
+		if (params.filter)
+			strfilter__delete(params.filter);
+		params.filter = strfilter__new(str, &err);
+		if (!params.filter) {
+			pr_err("Filter parse error at %ld.\n", err - str + 1);
+			pr_err("Source: \"%s\"\n", str);
+			pr_err("         %*c\n", (int)(err - str + 1), '^');
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
 #endif
 
 static const char * const probe_usage[] = {
@@ -212,6 +236,10 @@ static const struct option options[] = {
 		     "Show accessible variables on PROBEDEF", opt_show_vars),
 	OPT_BOOLEAN('\0', "externs", &params.show_ext_vars,
 		    "Show external variables too (with --vars only)"),
+	OPT_CALLBACK('\0', "filter", NULL,
+		     "[!]FILTER", "Set a variable filter (with --vars only)\n"
+		     "\t\t\t(default: \"" DEFAULT_VAR_FILTER "\")",
+		     opt_set_filter),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_STRING('s', "source", &symbol_conf.source_prefix,
@@ -324,10 +352,16 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			       " --add/--del.\n");
 			usage_with_options(probe_usage, options);
 		}
+		if (!params.filter)
+			params.filter = strfilter__new(DEFAULT_VAR_FILTER,
+						       NULL);
+
 		ret = show_available_vars(params.events, params.nevents,
 					  params.max_probe_points,
 					  params.target_module,
+					  params.filter,
 					  params.show_ext_vars);
+		strfilter__delete(params.filter);
 		if (ret < 0)
 			pr_err("  Error: Failed to show vars. (%d)\n", ret);
 		return ret;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 859d377..077e051 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -451,12 +451,14 @@ end:
 }
 
 static int show_available_vars_at(int fd, struct perf_probe_event *pev,
-				  int max_vls, bool externs)
+				  int max_vls, struct strfilter *_filter,
+				  bool externs)
 {
 	char *buf;
-	int ret, i;
+	int ret, i, nvars;
 	struct str_node *node;
 	struct variable_list *vls = NULL, *vl;
+	const char *var;
 
 	buf = synthesize_perf_probe_point(&pev->point);
 	if (!buf)
@@ -464,36 +466,45 @@ static int show_available_vars_at(int fd, struct perf_probe_event *pev,
 	pr_debug("Searching variables at %s\n", buf);
 
 	ret = find_available_vars_at(fd, pev, &vls, max_vls, externs);
-	if (ret > 0) {
-		/* Some variables were found */
-		fprintf(stdout, "Available variables at %s\n", buf);
-		for (i = 0; i < ret; i++) {
-			vl = &vls[i];
-			/*
-			 * A probe point might be converted to
-			 * several trace points.
-			 */
-			fprintf(stdout, "\t@<%s+%lu>\n", vl->point.symbol,
-				vl->point.offset);
-			free(vl->point.symbol);
-			if (vl->vars) {
-				strlist__for_each(node, vl->vars)
+	if (ret <= 0) {
+		pr_err("Failed to find variables at %s (%d)\n", buf, ret);
+		goto end;
+	}
+	/* Some variables are found */
+	fprintf(stdout, "Available variables at %s\n", buf);
+	for (i = 0; i < ret; i++) {
+		vl = &vls[i];
+		/*
+		 * A probe point might be converted to
+		 * several trace points.
+		 */
+		fprintf(stdout, "\t@<%s+%lu>\n", vl->point.symbol,
+			vl->point.offset);
+		free(vl->point.symbol);
+		nvars = 0;
+		if (vl->vars) {
+			strlist__for_each(node, vl->vars) {
+				var = strchr(node->s, '\t') + 1;
+				if (strfilter__compare(_filter, var)) {
 					fprintf(stdout, "\t\t%s\n", node->s);
-				strlist__delete(vl->vars);
-			} else
-				fprintf(stdout, "(No variables)\n");
+					nvars++;
+				}
+			}
+			strlist__delete(vl->vars);
 		}
-		free(vls);
-	} else
-		pr_err("Failed to find variables at %s (%d)\n", buf, ret);
-
+		if (nvars == 0)
+			fprintf(stdout, "\t\t(No matched variables)\n");
+	}
+	free(vls);
+end:
 	free(buf);
 	return ret;
 }
 
 /* Show available variables on given probe point */
 int show_available_vars(struct perf_probe_event *pevs, int npevs,
-			int max_vls, const char *module, bool externs)
+			int max_vls, const char *module,
+			struct strfilter *_filter, bool externs)
 {
 	int i, fd, ret = 0;
 
@@ -510,7 +521,8 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	setup_pager();
 
 	for (i = 0; i < npevs && ret >= 0; i++)
-		ret = show_available_vars_at(fd, &pevs[i], max_vls, externs);
+		ret = show_available_vars_at(fd, &pevs[i], max_vls, _filter,
+					     externs);
 
 	close(fd);
 	return ret;
@@ -556,7 +568,9 @@ int show_line_range(struct line_range *lr __unused, const char *module __unused)
 
 int show_available_vars(struct perf_probe_event *pevs __unused,
 			int npevs __unused, int max_vls __unused,
-			const char *module __unused, bool externs __unused)
+			const char *module __unused,
+			struct strfilter *filter __unused,
+			bool externs __unused)
 {
 	pr_warning("Debuginfo-analysis is not supported.\n");
 	return -ENOSYS;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 1fb4f18..4e80b2b 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 #include "strlist.h"
+#include "strfilter.h"
 
 extern bool probe_event_dry_run;
 
@@ -126,7 +127,7 @@ extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr, const char *module);
 extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			       int max_probe_points, const char *module,
-			       bool externs);
+			       struct strfilter *filter, bool externs);
 extern int show_available_funcs(const char *module);
 
 
-- 
1.6.2.5

