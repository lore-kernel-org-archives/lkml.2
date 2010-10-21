Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0JUKMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:12:10 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42020 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab0JUKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:12:07 -0400
X-AuditID: b753bd60-a92d1ba000005dcc-c6-4cc011f41ff5
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  6/7] perf probe: Show accessible global variables
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 21 Oct 2010 19:13:35 +0900
Message-ID: <20101021101335.3542.31003.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --externs for allowing --vars to show accessible
global(externally defined) variables from a given probe
point too.
This will give you a hint which globals can be accessible
from the probe point.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/Documentation/perf-probe.txt |    6 +++++-
 tools/perf/builtin-probe.c              |    8 ++++++--
 tools/perf/util/probe-event.c           |    8 ++++----
 tools/perf/util/probe-event.h           |    2 +-
 tools/perf/util/probe-finder.c          |   26 +++++++++++++++++++++-----
 tools/perf/util/probe-finder.h          |    5 ++++-
 6 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 72f5d9e..148c178 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -18,7 +18,7 @@ or
 or
 'perf probe' --line='FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]'
 or
-'perf probe' --vars='PROBEPOINT'
+'perf probe' [--externs] --vars='PROBEPOINT'
 
 DESCRIPTION
 -----------
@@ -64,6 +64,10 @@ OPTIONS
 	Show available local variables at given probe point. The argument
 	syntax is same as PROBE SYNTAX, but NO ARGs.
 
+--externs::
+	(Only for --vars) Show external defined variables in addition to local
+	variables.
+
 -f::
 --force::
 	Forcibly add events with existing name.
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c777bec..bdf60cf 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -51,6 +51,7 @@ static struct {
 	bool force_add;
 	bool show_lines;
 	bool show_vars;
+	bool show_ext_vars;
 	bool mod_events;
 	int nevents;
 	struct perf_probe_event events[MAX_PROBES];
@@ -162,7 +163,7 @@ static const char * const probe_usage[] = {
 	"perf probe --list",
 #ifdef DWARF_SUPPORT
 	"perf probe --line 'LINEDESC'",
-	"perf probe --vars 'PROBEPOINT'",
+	"perf probe [--externs] --vars 'PROBEPOINT'",
 #endif
 	NULL
 };
@@ -207,6 +208,8 @@ static const struct option options[] = {
 	OPT_CALLBACK('V', "vars", NULL,
 		     "FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT",
 		     "Show accessible variables on PROBEDEF", opt_show_vars),
+	OPT_BOOLEAN('\0', "externs", &params.show_ext_vars,
+		    "Show external variables too (with --vars only)"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_STRING('s', "source", &symbol_conf.source_prefix,
@@ -287,7 +290,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(probe_usage, options);
 		}
 		ret = show_available_vars(params.events, params.nevents,
-					  params.max_probe_points);
+					  params.max_probe_points,
+					  params.show_ext_vars);
 		if (ret < 0)
 			pr_err("  Error: Failed to show vars. (%d)\n", ret);
 		return ret;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index cafddc9..1b462cc 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -379,7 +379,7 @@ end:
 }
 
 static int show_available_vars_at(int fd, struct perf_probe_event *pev,
-				  int max_vls)
+				  int max_vls, bool externs)
 {
 	char *buf;
 	int ret, i;
@@ -391,7 +391,7 @@ static int show_available_vars_at(int fd, struct perf_probe_event *pev,
 		return -EINVAL;
 	pr_debug("Searching variables at %s\n", buf);
 
-	ret = find_available_vars_at(fd, pev, &vls, max_vls);
+	ret = find_available_vars_at(fd, pev, &vls, max_vls, externs);
 	if (ret > 0) {
 		/* Some variables are found */
 		fprintf(stdout, "Available variables at %s\n", buf);
@@ -421,7 +421,7 @@ static int show_available_vars_at(int fd, struct perf_probe_event *pev,
 
 /* Show available variables on given probe point */
 int show_available_vars(struct perf_probe_event *pevs, int npevs,
-			int max_vls)
+			int max_vls, bool externs)
 {
 	int i, fd, ret = 0;
 
@@ -438,7 +438,7 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	setup_pager();
 
 	for (i = 0; i < npevs && ret >= 0; i++)
-		ret = show_available_vars_at(fd, &pevs[i], max_vls);
+		ret = show_available_vars_at(fd, &pevs[i], max_vls, externs);
 
 	close(fd);
 	return ret;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 83130f6..c74b1fd 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -122,7 +122,7 @@ extern int del_perf_probe_events(struct strlist *dellist);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
 extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
-			       int max_probe_points);
+			       int max_probe_points, bool externs);
 
 
 /* Maximum index number of event-name postfix */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 986027f..a274fd0 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1312,12 +1312,13 @@ static int collect_variables_cb(Dwarf_Die *die_mem, void *data)
 						af->pf.fb_ops, NULL);
 		if (ret == 0) {
 			ret = die_get_varname(die_mem, buf, MAX_VAR_LEN);
+			pr_debug2("Add new var: %s\n", buf);
 			if (ret > 0)
 				strlist__add(vl->vars, buf);
 		}
 	}
 
-	if (dwarf_haspc(die_mem, af->pf.addr))
+	if (af->child && dwarf_haspc(die_mem, af->pf.addr))
 		return DIE_FIND_CB_CONTINUE;
 	else
 		return DIE_FIND_CB_SIBLING;
@@ -1329,8 +1330,8 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
 	struct available_var_finder *af =
 			container_of(pf, struct available_var_finder, pf);
 	struct variable_list *vl;
-	Dwarf_Die die_mem;
-	int ret;
+	Dwarf_Die die_mem, *scopes = NULL;
+	int ret, nscopes;
 
 	/* Check number of tevs */
 	if (af->nvls == af->max_vls) {
@@ -1351,8 +1352,22 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
 	vl->vars = strlist__new(true, NULL);
 	if (vl->vars == NULL)
 		return -ENOMEM;
+	af->child = true;
 	die_find_child(sp_die, collect_variables_cb, (void *)af, &die_mem);
 
+	/* Find external variables */
+	if (!af->externs)
+		goto out;
+	/* Don't need to search child DIE for externs. */
+	af->child = false;
+	nscopes = dwarf_getscopes_die(sp_die, &scopes);
+	while (nscopes-- > 1)
+		die_find_child(&scopes[nscopes], collect_variables_cb,
+			       (void *)af, &die_mem);
+	if (scopes)
+		free(scopes);
+
+out:
 	if (strlist__empty(vl->vars)) {
 		strlist__delete(vl->vars);
 		vl->vars = NULL;
@@ -1363,11 +1378,12 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 /* Find available variables at given probe point */
 int find_available_vars_at(int fd, struct perf_probe_event *pev,
-			   struct variable_list **vls, int max_vls)
+			   struct variable_list **vls, int max_vls,
+			   bool externs)
 {
 	struct available_var_finder af = {
 			.pf = {.pev = pev, .callback = add_available_vars},
-			.max_vls = max_vls};
+			.max_vls = max_vls, .externs = externs};
 	int ret;
 
 	/* Allocate result vls array */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index baffd25..516912a 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -30,7 +30,8 @@ extern int find_line_range(int fd, struct line_range *lr);
 
 /* Find available variables */
 extern int find_available_vars_at(int fd, struct perf_probe_event *pev,
-				  struct variable_list **vls, int max_points);
+				  struct variable_list **vls, int max_points,
+				  bool externs);
 
 #include <dwarf.h>
 #include <libdw.h>
@@ -70,6 +71,8 @@ struct available_var_finder {
 	struct variable_list	*vls;		/* Found variable lists */
 	int			nvls;		/* Number of variable lists */
 	int			max_vls;	/* Max no. of variable lists */
+	bool			externs;	/* Find external vars too */
+	bool			child;		/* Search child scopes */
 };
 
 struct line_finder {

