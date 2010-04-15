Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0DOH3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:38081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab0DOH3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:33 -0400
Date: Thu, 15 Apr 2010 07:29:02 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100412171722.3790.50372.stgit@localhost6.localdomain6>
References: <20100412171722.3790.50372.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Support basic type casting
Message-ID: <tip-11a1ca3554b377d2a8a318a3cbf8ce10a7a2a8e4@git.kernel.org>
Git-Commit-ID: 11a1ca3554b377d2a8a318a3cbf8ce10a7a2a8e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:29:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11a1ca3554b377d2a8a318a3cbf8ce10a7a2a8e4
Gitweb:     http://git.kernel.org/tip/11a1ca3554b377d2a8a318a3cbf8ce10a7a2a8e4
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 12 Apr 2010 13:17:22 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:28:09 -0300

perf probe: Support basic type casting

Add basic type casting for arguments to perf probe. This allows
users to specify the actual type of arguments. Of course, if
user sets invalid types, kprobe-tracer rejects that.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100412171722.3790.50372.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    3 ++-
 tools/perf/util/probe-event.c           |   23 ++++++++++++++++++++++-
 tools/perf/util/probe-event.h           |    1 +
 tools/perf/util/probe-finder.c          |   10 ++++++++--
 4 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 441324f..63c25d3 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -85,9 +85,10 @@ PROBE ARGUMENT
 --------------
 Each probe argument follows below syntax.
 
- [NAME=]LOCALVAR|$retval|%REG|@SYMBOL
+ [NAME=]LOCALVAR|$retval|%REG|@SYMBOL[:TYPE]
 
 'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
+'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo.
 
 LINE SYNTAX
 -----------
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 05ca4a9..bef2805 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -435,7 +435,7 @@ static void parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 }
 
 /* Parse perf-probe event argument */
-static void parse_perf_probe_arg(const char *str, struct perf_probe_arg *arg)
+static void parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 {
 	char *tmp;
 	struct perf_probe_arg_field **fieldp;
@@ -445,9 +445,17 @@ static void parse_perf_probe_arg(const char *str, struct perf_probe_arg *arg)
 	tmp = strchr(str, '=');
 	if (tmp) {
 		arg->name = xstrndup(str, tmp - str);
+		pr_debug("name:%s ", arg->name);
 		str = tmp + 1;
 	}
 
+	tmp = strchr(str, ':');
+	if (tmp) {	/* Type setting */
+		*tmp = '\0';
+		arg->type = xstrdup(tmp + 1);
+		pr_debug("type:%s ", arg->type);
+	}
+
 	tmp = strpbrk(str, "-.");
 	if (!is_c_varname(str) || !tmp) {
 		/* A variable, register, symbol or special value */
@@ -603,6 +611,15 @@ int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf, size_t len)
 		len -= ret;
 		field = field->next;
 	}
+
+	if (pa->type) {
+		ret = e_snprintf(tmp, len, ":%s", pa->type);
+		if (ret <= 0)
+			goto error;
+		tmp += ret;
+		len -= ret;
+	}
+
 	return tmp - buf;
 error:
 	die("Failed to synthesize perf probe argument: %s", strerror(-ret));
@@ -825,6 +842,8 @@ void clear_perf_probe_event(struct perf_probe_event *pev)
 			free(pev->args[i].name);
 		if (pev->args[i].var)
 			free(pev->args[i].var);
+		if (pev->args[i].type)
+			free(pev->args[i].type);
 		field = pev->args[i].field;
 		while (field) {
 			next = field->next;
@@ -1145,6 +1164,8 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 			if (pev->args[i].name)
 				tev->args[i].name = xstrdup(pev->args[i].name);
 			tev->args[i].value = xstrdup(pev->args[i].var);
+			if (pev->args[i].type)
+				tev->args[i].type = xstrdup(pev->args[i].type);
 		}
 	}
 
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index a393a3f..ff2f26b 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -57,6 +57,7 @@ struct perf_probe_arg_field {
 struct perf_probe_arg {
 	char				*name;	/* Argument name */
 	char				*var;	/* Variable name */
+	char				*type;	/* Type name */
 	struct perf_probe_arg_field	*field;	/* Structure fields */
 };
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index ebeb413..ab47673 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -547,7 +547,10 @@ static void convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 					&die_mem);
 		vr_die = &die_mem;
 	}
-	convert_variable_type(vr_die, pf->tvar);
+	if (pf->pvar->type)
+		pf->tvar->type = xstrdup(pf->pvar->type);
+	else
+		convert_variable_type(vr_die, pf->tvar);
 	/* *expr will be cached in libdw. Don't free it. */
 	return ;
 error:
@@ -560,13 +563,16 @@ error:
 static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	Dwarf_Die vr_die;
-	char buf[32];
+	char buf[32], *ptr;
 
 	/* TODO: Support arrays */
 	if (pf->pvar->name)
 		pf->tvar->name = xstrdup(pf->pvar->name);
 	else {
 		synthesize_perf_probe_arg(pf->pvar, buf, 32);
+		ptr = strchr(buf, ':');	/* Change type separator to _ */
+		if (ptr)
+			*ptr = '_';
 		pf->tvar->name = xstrdup(buf);
 	}
 
