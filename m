Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0DOHbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:31:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:38229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab0DOHay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:30:54 -0400
Date: Thu, 15 Apr 2010 07:30:25 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100412171756.3790.89607.stgit@localhost6.localdomain6>
References: <20100412171756.3790.89607.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Remove xstrdup()/xstrndup() from util/probe-{event, finder}.c
Message-ID: <tip-02b95dadc8a1d2c302513e5fa24c492380d26e93@git.kernel.org>
Git-Commit-ID: 02b95dadc8a1d2c302513e5fa24c492380d26e93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:30:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02b95dadc8a1d2c302513e5fa24c492380d26e93
Gitweb:     http://git.kernel.org/tip/02b95dadc8a1d2c302513e5fa24c492380d26e93
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 12 Apr 2010 13:17:56 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:28:52 -0300

perf probe: Remove xstrdup()/xstrndup() from util/probe-{event, finder}.c

Remove all xstr*dup() calls from util/probe-{event,finder}.c since
it may cause 'sudden death' in utility functions and it makes
reusing it from other code difficult.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100412171756.3790.89607.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |  159 ++++++++++++++++++++++++++++------------
 tools/perf/util/probe-finder.c |   58 +++++++++++----
 2 files changed, 156 insertions(+), 61 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index aacbf73..ca108b2 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -133,7 +133,9 @@ static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
 	if (ret <= 0) {
 		pr_debug("Failed to find corresponding probes from "
 			 "debuginfo. Use kprobe event information.\n");
-		pp->function = xstrdup(tp->symbol);
+		pp->function = strdup(tp->symbol);
+		if (pp->function == NULL)
+			return -ENOMEM;
 		pp->offset = tp->offset;
 	}
 	pp->retprobe = tp->retprobe;
@@ -300,7 +302,9 @@ end:
 static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
 					struct perf_probe_point *pp)
 {
-	pp->function = xstrdup(tp->symbol);
+	pp->function = strdup(tp->symbol);
+	if (pp->function == NULL)
+		return -ENOMEM;
 	pp->offset = tp->offset;
 	pp->retprobe = tp->retprobe;
 
@@ -355,9 +359,12 @@ int parse_line_range_desc(const char *arg, struct line_range *lr)
 				       *tmp);
 			return -EINVAL;
 		}
-		tmp = xstrndup(arg, (ptr - arg));
+		tmp = strndup(arg, (ptr - arg));
 	} else
-		tmp = xstrdup(arg);
+		tmp = strdup(arg);
+
+	if (tmp == NULL)
+		return -ENOMEM;
 
 	if (strchr(tmp, '.'))
 		lr->file = tmp;
@@ -406,7 +413,9 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 				       "follow C symbol-naming rule.\n", arg);
 			return -EINVAL;
 		}
-		pev->event = xstrdup(arg);
+		pev->event = strdup(arg);
+		if (pev->event == NULL)
+			return -ENOMEM;
 		pev->group = NULL;
 		arg = tmp;
 	}
@@ -417,18 +426,24 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 		*ptr++ = '\0';
 	}
 
+	tmp = strdup(arg);
+	if (tmp == NULL)
+		return -ENOMEM;
+
 	/* Check arg is function or file and copy it */
-	if (strchr(arg, '.'))	/* File */
-		pp->file = xstrdup(arg);
+	if (strchr(tmp, '.'))	/* File */
+		pp->file = tmp;
 	else			/* Function */
-		pp->function = xstrdup(arg);
+		pp->function = tmp;
 
 	/* Parse other options */
 	while (ptr) {
 		arg = ptr;
 		c = nc;
 		if (c == ';') {	/* Lazy pattern must be the last part */
-			pp->lazy_line = xstrdup(arg);
+			pp->lazy_line = strdup(arg);
+			if (pp->lazy_line == NULL)
+				return -ENOMEM;
 			break;
 		}
 		ptr = strpbrk(arg, ";:+@%");
@@ -458,7 +473,9 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 				semantic_error("SRC@SRC is not allowed.\n");
 				return -EINVAL;
 			}
-			pp->file = xstrdup(arg);
+			pp->file = strdup(arg);
+			if (pp->file == NULL)
+				return -ENOMEM;
 			break;
 		case '%':	/* Probe places */
 			if (strcmp(arg, "return") == 0) {
@@ -530,7 +547,9 @@ static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 
 	tmp = strchr(str, '=');
 	if (tmp) {
-		arg->name = xstrndup(str, tmp - str);
+		arg->name = strndup(str, tmp - str);
+		if (arg->name == NULL)
+			return -ENOMEM;
 		pr_debug("name:%s ", arg->name);
 		str = tmp + 1;
 	}
@@ -538,20 +557,26 @@ static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 	tmp = strchr(str, ':');
 	if (tmp) {	/* Type setting */
 		*tmp = '\0';
-		arg->type = xstrdup(tmp + 1);
+		arg->type = strdup(tmp + 1);
+		if (arg->type == NULL)
+			return -ENOMEM;
 		pr_debug("type:%s ", arg->type);
 	}
 
 	tmp = strpbrk(str, "-.");
 	if (!is_c_varname(str) || !tmp) {
 		/* A variable, register, symbol or special value */
-		arg->var = xstrdup(str);
+		arg->var = strdup(str);
+		if (arg->var == NULL)
+			return -ENOMEM;
 		pr_debug("%s\n", arg->var);
 		return 0;
 	}
 
 	/* Structure fields */
-	arg->var = xstrndup(str, tmp - str);
+	arg->var = strndup(str, tmp - str);
+	if (arg->var == NULL)
+		return -ENOMEM;
 	pr_debug("%s, ", arg->var);
 	fieldp = &arg->field;
 
@@ -572,18 +597,24 @@ static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 
 		tmp = strpbrk(str, "-.");
 		if (tmp) {
-			(*fieldp)->name = xstrndup(str, tmp - str);
+			(*fieldp)->name = strndup(str, tmp - str);
+			if ((*fieldp)->name == NULL)
+				return -ENOMEM;
 			pr_debug("%s(%d), ", (*fieldp)->name, (*fieldp)->ref);
 			fieldp = &(*fieldp)->next;
 		}
 	} while (tmp);
-	(*fieldp)->name = xstrdup(str);
+	(*fieldp)->name = strdup(str);
+	if ((*fieldp)->name == NULL)
+		return -ENOMEM;
 	pr_debug("%s(%d)\n", (*fieldp)->name, (*fieldp)->ref);
 
 	/* If no name is specified, set the last field name */
-	if (!arg->name)
-		arg->name = xstrdup((*fieldp)->name);
-
+	if (!arg->name) {
+		arg->name = strdup((*fieldp)->name);
+		if (arg->name == NULL)
+			return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -697,9 +728,13 @@ int parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 			*p++ = '\0';
 		else
 			p = argv[i + 2];
-		tev->args[i].name = xstrdup(argv[i + 2]);
+		tev->args[i].name = strdup(argv[i + 2]);
 		/* TODO: parse regs and offset */
-		tev->args[i].value = xstrdup(p);
+		tev->args[i].value = strdup(p);
+		if (tev->args[i].name == NULL || tev->args[i].value == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 	ret = 0;
 out:
@@ -933,12 +968,14 @@ error:
 int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 				struct perf_probe_event *pev)
 {
-	char buf[64];
+	char buf[64] = "";
 	int i, ret;
 
 	/* Convert event/group name */
-	pev->event = xstrdup(tev->event);
-	pev->group = xstrdup(tev->group);
+	pev->event = strdup(tev->event);
+	pev->group = strdup(tev->group);
+	if (pev->event == NULL || pev->group == NULL)
+		return -ENOMEM;
 
 	/* Convert trace_point to probe_point */
 	ret = convert_to_perf_probe_point(&tev->point, &pev->point);
@@ -950,14 +987,17 @@ int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 	pev->args = zalloc(sizeof(struct perf_probe_arg) * pev->nargs);
 	if (pev->args == NULL)
 		return -ENOMEM;
-	for (i = 0; i < tev->nargs && ret >= 0; i++)
+	for (i = 0; i < tev->nargs && ret >= 0; i++) {
 		if (tev->args[i].name)
-			pev->args[i].name = xstrdup(tev->args[i].name);
+			pev->args[i].name = strdup(tev->args[i].name);
 		else {
 			ret = synthesize_kprobe_trace_arg(&tev->args[i],
 							  buf, 64);
-			pev->args[i].name = xstrdup(buf);
+			pev->args[i].name = strdup(buf);
 		}
+		if (pev->args[i].name == NULL && ret >= 0)
+			ret = -ENOMEM;
+	}
 
 	if (ret < 0)
 		clear_perf_probe_event(pev);
@@ -1282,7 +1322,7 @@ static int __add_kprobe_trace_events(struct perf_probe_event *pev,
 
 	ret = 0;
 	printf("Add new event%s\n", (ntevs > 1) ? "s:" : ":");
-	for (i = 0; i < ntevs && ret >= 0; i++) {
+	for (i = 0; i < ntevs; i++) {
 		tev = &tevs[i];
 		if (pev->event)
 			event = pev->event;
@@ -1303,8 +1343,12 @@ static int __add_kprobe_trace_events(struct perf_probe_event *pev,
 			break;
 		event = buf;
 
-		tev->event = xstrdup(event);
-		tev->group = xstrdup(group);
+		tev->event = strdup(event);
+		tev->group = strdup(group);
+		if (tev->event == NULL || tev->group == NULL) {
+			ret = -ENOMEM;
+			break;
+		}
 		ret = write_kprobe_trace_event(fd, tev);
 		if (ret < 0)
 			break;
@@ -1360,23 +1404,40 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 		return -ENOMEM;
 
 	/* Copy parameters */
-	tev->point.symbol = xstrdup(pev->point.function);
+	tev->point.symbol = strdup(pev->point.function);
+	if (tev->point.symbol == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
 	tev->point.offset = pev->point.offset;
 	tev->nargs = pev->nargs;
 	if (tev->nargs) {
 		tev->args = zalloc(sizeof(struct kprobe_trace_arg)
 				   * tev->nargs);
 		if (tev->args == NULL) {
-			free(tev);
-			*tevs = NULL;
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto error;
 		}
 		for (i = 0; i < tev->nargs; i++) {
-			if (pev->args[i].name)
-				tev->args[i].name = xstrdup(pev->args[i].name);
-			tev->args[i].value = xstrdup(pev->args[i].var);
-			if (pev->args[i].type)
-				tev->args[i].type = xstrdup(pev->args[i].type);
+			if (pev->args[i].name) {
+				tev->args[i].name = strdup(pev->args[i].name);
+				if (tev->args[i].name == NULL) {
+					ret = -ENOMEM;
+					goto error;
+				}
+			}
+			tev->args[i].value = strdup(pev->args[i].var);
+			if (tev->args[i].value == NULL) {
+				ret = -ENOMEM;
+				goto error;
+			}
+			if (pev->args[i].type) {
+				tev->args[i].type = strdup(pev->args[i].type);
+				if (tev->args[i].type == NULL) {
+					ret = -ENOMEM;
+					goto error;
+				}
+			}
 		}
 	}
 
@@ -1386,13 +1447,15 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 	if (!sym) {
 		pr_warning("Kernel symbol \'%s\' not found.\n",
 			   tev->point.symbol);
-		clear_kprobe_trace_event(tev);
-		free(tev);
-		*tevs = NULL;
-		return -ENOENT;
-	} else
-		ret = 1;
+		ret = -ENOENT;
+		goto error;
+	}
 
+	return 1;
+error:
+	clear_kprobe_trace_event(tev);
+	free(tev);
+	*tevs = NULL;
 	return ret;
 }
 
@@ -1528,7 +1591,11 @@ int del_perf_probe_events(struct strlist *dellist)
 		return -EINVAL;
 
 	strlist__for_each(ent, dellist) {
-		str = xstrdup(ent->s);
+		str = strdup(ent->s);
+		if (str == NULL) {
+			ret = -ENOMEM;
+			break;
+		}
 		pr_debug("Parsing: %s\n", str);
 		p = strchr(str, ':');
 		if (p) {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index ce1ac82..e443e69 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -424,7 +424,10 @@ static int convert_location(Dwarf_Op *op, struct probe_finder *pf)
 		return -ERANGE;
 	}
 
-	tvar->value = xstrdup(regs);
+	tvar->value = strdup(regs);
+	if (tvar->value == NULL)
+		return -ENOMEM;
+
 	if (ref) {
 		tvar->ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
 		if (tvar->ref == NULL)
@@ -466,7 +469,9 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 				   strerror(-ret));
 			return ret;
 		}
-		targ->type = xstrdup(buf);
+		targ->type = strdup(buf);
+		if (targ->type == NULL)
+			return -ENOMEM;
 	}
 	return 0;
 }
@@ -576,9 +581,11 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 		vr_die = &die_mem;
 	}
 	if (ret == 0) {
-		if (pf->pvar->type)
-			pf->tvar->type = xstrdup(pf->pvar->type);
-		else
+		if (pf->pvar->type) {
+			pf->tvar->type = strdup(pf->pvar->type);
+			if (pf->tvar->type == NULL)
+				ret = -ENOMEM;
+		} else
 			ret = convert_variable_type(vr_die, pf->tvar);
 	}
 	/* *expr will be cached in libdw. Don't free it. */
@@ -595,22 +602,30 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	Dwarf_Die vr_die;
 	char buf[32], *ptr;
+	int ret;
 
 	/* TODO: Support arrays */
 	if (pf->pvar->name)
-		pf->tvar->name = xstrdup(pf->pvar->name);
+		pf->tvar->name = strdup(pf->pvar->name);
 	else {
-		synthesize_perf_probe_arg(pf->pvar, buf, 32);
+		ret = synthesize_perf_probe_arg(pf->pvar, buf, 32);
+		if (ret < 0)
+			return ret;
 		ptr = strchr(buf, ':');	/* Change type separator to _ */
 		if (ptr)
 			*ptr = '_';
-		pf->tvar->name = xstrdup(buf);
+		pf->tvar->name = strdup(buf);
 	}
+	if (pf->tvar->name == NULL)
+		return -ENOMEM;
 
 	if (!is_c_varname(pf->pvar->var)) {
 		/* Copy raw parameters */
-		pf->tvar->value = xstrdup(pf->pvar->var);
-		return 0;
+		pf->tvar->value = strdup(pf->pvar->var);
+		if (pf->tvar->value == NULL)
+			return -ENOMEM;
+		else
+			return 0;
 	}
 
 	pr_debug("Searching '%s' variable in context.\n",
@@ -660,7 +675,9 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 				   dwarf_diename(sp_die));
 			return -ENOENT;
 		}
-		tev->point.symbol = xstrdup(name);
+		tev->point.symbol = strdup(name);
+		if (tev->point.symbol == NULL)
+			return -ENOMEM;
 		tev->point.offset = (unsigned long)(pf->addr - eaddr);
 	} else
 		/* This function has no name. */
@@ -1028,7 +1045,11 @@ int find_perf_probe_point(int fd, unsigned long addr,
 			tmp = dwarf_linesrc(line, NULL, NULL);
 			if (tmp) {
 				ppt->line = lineno;
-				ppt->file = xstrdup(tmp);
+				ppt->file = strdup(tmp);
+				if (ppt->file == NULL) {
+					ret = -ENOMEM;
+					goto end;
+				}
 				found = true;
 			}
 		}
@@ -1064,7 +1085,11 @@ int find_perf_probe_point(int fd, unsigned long addr,
 		/* We don't have a line number, let's use offset */
 		ppt->offset = addr - (unsigned long)eaddr;
 found:
-		ppt->function = xstrdup(tmp);
+		ppt->function = strdup(tmp);
+		if (ppt->function == NULL) {
+			ret = -ENOMEM;
+			goto end;
+		}
 		found = true;
 	}
 
@@ -1116,8 +1141,11 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 			continue;
 
 		/* Copy real path */
-		if (!lf->lr->path)
-			lf->lr->path = xstrdup(src);
+		if (!lf->lr->path) {
+			lf->lr->path = strdup(src);
+			if (lf->lr->path == NULL)
+				return -ENOMEM;
+		}
 		line_list__add_line(&lf->lr->line_list, (unsigned int)lineno);
 	}
 	/* Update status */
