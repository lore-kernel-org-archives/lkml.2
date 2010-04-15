Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab0DOH22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:28:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:37982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab0DOH20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:28:26 -0400
Date: Thu, 15 Apr 2010 07:27:53 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100412171653.3790.74624.stgit@localhost6.localdomain6>
References: <20100412171653.3790.74624.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Support argument name
Message-ID: <tip-48481938b02471d505296d7557ed296eb093d496@git.kernel.org>
Git-Commit-ID: 48481938b02471d505296d7557ed296eb093d496
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:27:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48481938b02471d505296d7557ed296eb093d496
Gitweb:     http://git.kernel.org/tip/48481938b02471d505296d7557ed296eb093d496
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 12 Apr 2010 13:16:53 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:26:04 -0300

perf probe: Support argument name

Set given names to event arguments. The syntax is same as kprobe-tracer,
you can add 'NAME=' right before each argument.

e.g.
  ./perf probe vfs_read foo=file

 then, 'foo' is set to the argument name as below.

  ./perf probe -l
  probe:vfs_read       (on vfs_read@linux-2.6-tip/fs/read_write.c with foo)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100412171653.3790.74624.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |   10 ++++++++-
 tools/perf/builtin-probe.c              |    4 +-
 tools/perf/util/probe-event.c           |   34 +++++++++++++++++++++---------
 tools/perf/util/probe-event.h           |    1 +
 tools/perf/util/probe-finder.c          |   27 ++++++++++++++----------
 5 files changed, 52 insertions(+), 24 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index bb671b3..e36ed4d 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -79,7 +79,15 @@ Probe points are defined by following syntax.
 'EVENT' specifies the name of new event, if omitted, it will be set the name of the probed function. Currently, event group name is set as 'probe'.
 'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, ':RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. And ';PTN' means lazy matching pattern (see LAZY MATCHING). Note that ';PTN' must be the end of the probe point definition.  In addition, '@SRC' specifies a source file which has that function.
 It is also possible to specify a probe point by the source line number or lazy matching by using 'SRC:ALN' or 'SRC;PTN' syntax, where 'SRC' is the source file path, ':ALN' is the line number and ';PTN' is the lazy matching pattern.
-'ARG' specifies the arguments of this probe point. You can use the name of local variable, or kprobe-tracer argument format (e.g. $retval, %ax, etc).
+'ARG' specifies the arguments of this probe point, (see PROBE ARGUMENT).
+
+PROBE ARGUMENT
+--------------
+Each probe argument follows below syntax.
+
+ [NAME=]LOCALVAR|$retval|%REG|@SYMBOL
+
+'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), or kprobe-tracer argument format (e.g. $retval, %ax, etc).
 
 LINE SYNTAX
 -----------
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index bfc47ff..daf4668 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -142,9 +142,9 @@ static const struct option options[] = {
 	OPT_CALLBACK('a', "add", NULL,
 #ifdef DWARF_SUPPORT
 		"[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT"
-		" [ARG ...]",
+		" [[NAME=]ARG ...]",
 #else
-		"[EVENT=]FUNC[+OFF|%return] [ARG ...]",
+		"[EVENT=]FUNC[+OFF|%return] [[NAME=]ARG ...]",
 #endif
 		"probe point definition, where\n"
 		"\t\tGROUP:\tGroup name (optional)\n"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3fc0be7..ab6f53d 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -437,22 +437,28 @@ static void parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 /* Parse perf-probe event argument */
 static void parse_perf_probe_arg(const char *str, struct perf_probe_arg *arg)
 {
-	const char *tmp;
+	char *tmp;
 	struct perf_probe_arg_field **fieldp;
 
 	pr_debug("parsing arg: %s into ", str);
 
+	tmp = strchr(str, '=');
+	if (tmp) {
+		arg->name = xstrndup(str, tmp - str);
+		str = tmp + 1;
+	}
+
 	tmp = strpbrk(str, "-.");
 	if (!is_c_varname(str) || !tmp) {
 		/* A variable, register, symbol or special value */
-		arg->name = xstrdup(str);
-		pr_debug("%s\n", arg->name);
+		arg->var = xstrdup(str);
+		pr_debug("%s\n", arg->var);
 		return;
 	}
 
 	/* Structure fields */
-	arg->name = xstrndup(str, tmp - str);
-	pr_debug("%s, ", arg->name);
+	arg->var = xstrndup(str, tmp - str);
+	pr_debug("%s, ", arg->var);
 	fieldp = &arg->field;
 
 	do {
@@ -497,7 +503,7 @@ void parse_perf_probe_command(const char *cmd, struct perf_probe_event *pev)
 	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
 	for (i = 0; i < pev->nargs; i++) {
 		parse_perf_probe_arg(argv[i + 1], &pev->args[i]);
-		if (is_c_varname(pev->args[i].name) && pev->point.retprobe)
+		if (is_c_varname(pev->args[i].var) && pev->point.retprobe)
 			semantic_error("You can't specify local variable for"
 				       " kretprobe");
 	}
@@ -514,7 +520,7 @@ bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
 		return true;
 
 	for (i = 0; i < pev->nargs; i++)
-		if (is_c_varname(pev->args[i].name))
+		if (is_c_varname(pev->args[i].var))
 			return true;
 
 	return false;
@@ -575,7 +581,10 @@ int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf, size_t len)
 	int ret;
 	char *tmp = buf;
 
-	ret = e_snprintf(tmp, len, "%s", pa->name);
+	if (pa->name && pa->var)
+		ret = e_snprintf(tmp, len, "%s=%s", pa->name, pa->var);
+	else
+		ret = e_snprintf(tmp, len, "%s", pa->name ? pa->name : pa->var);
 	if (ret <= 0)
 		goto error;
 	tmp += ret;
@@ -803,6 +812,8 @@ void clear_perf_probe_event(struct perf_probe_event *pev)
 	for (i = 0; i < pev->nargs; i++) {
 		if (pev->args[i].name)
 			free(pev->args[i].name);
+		if (pev->args[i].var)
+			free(pev->args[i].var);
 		field = pev->args[i].field;
 		while (field) {
 			next = field->next;
@@ -1117,8 +1128,11 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 	if (tev->nargs) {
 		tev->args = xzalloc(sizeof(struct kprobe_trace_arg)
 				    * tev->nargs);
-		for (i = 0; i < tev->nargs; i++)
-			tev->args[i].value = xstrdup(pev->args[i].name);
+		for (i = 0; i < tev->nargs; i++) {
+			if (pev->args[i].name)
+				tev->args[i].name = xstrdup(pev->args[i].name);
+			tev->args[i].value = xstrdup(pev->args[i].var);
+		}
 	}
 
 	/* Currently just checking function name from symbol map */
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 9d99fc2..10411f5 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -55,6 +55,7 @@ struct perf_probe_arg_field {
 /* Perf probe probing argument */
 struct perf_probe_arg {
 	char				*name;	/* Argument name */
+	char				*var;	/* Variable name */
 	struct perf_probe_arg_field	*field;	/* Structure fields */
 };
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index a851377..105e95c 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -484,35 +484,40 @@ static void convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 	convert_location(expr, pf);
 
 	if (pf->pvar->field)
-		convert_variable_fields(vr_die, pf->pvar->name,
+		convert_variable_fields(vr_die, pf->pvar->var,
 					pf->pvar->field, &pf->tvar->ref);
 	/* *expr will be cached in libdw. Don't free it. */
 	return ;
 error:
 	/* TODO: Support const_value */
 	die("Failed to find the location of %s at this address.\n"
-	    " Perhaps, it has been optimized out.", pf->pvar->name);
+	    " Perhaps, it has been optimized out.", pf->pvar->var);
 }
 
 /* Find a variable in a subprogram die */
 static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	Dwarf_Die vr_die;
-	char buf[128];
+	char buf[32];
 
-	/* TODO: Support struct members and arrays */
-	if (!is_c_varname(pf->pvar->name)) {
+	/* TODO: Support arrays */
+	if (pf->pvar->name)
+		pf->tvar->name = xstrdup(pf->pvar->name);
+	else {
+		synthesize_perf_probe_arg(pf->pvar, buf, 32);
+		pf->tvar->name = xstrdup(buf);
+	}
+
+	if (!is_c_varname(pf->pvar->var)) {
 		/* Copy raw parameters */
-		pf->tvar->value = xstrdup(pf->pvar->name);
+		pf->tvar->value = xstrdup(pf->pvar->var);
 	} else {
-		synthesize_perf_probe_arg(pf->pvar, buf, 128);
-		pf->tvar->name = xstrdup(buf);
 		pr_debug("Searching '%s' variable in context.\n",
-			 pf->pvar->name);
+			 pf->pvar->var);
 		/* Search child die for local variables and parameters. */
-		if (!die_find_variable(sp_die, pf->pvar->name, &vr_die))
+		if (!die_find_variable(sp_die, pf->pvar->var, &vr_die))
 			die("Failed to find '%s' in this function.",
-			    pf->pvar->name);
+			    pf->pvar->var);
 		convert_variable(&vr_die, pf);
 	}
 }
