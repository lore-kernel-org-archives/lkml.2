Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab2I0FgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:36:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54066 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2I0FgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:36:00 -0400
Date: Wed, 26 Sep 2012 22:35:34 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-bcbd004020bf0d725722be75da35fd326ff63ef4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, irina.tirdea@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1348173470-4936-1-git-send-email-irina.tirdea@gmail.com>
References: <1348173470-4936-1-git-send-email-irina.tirdea@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: remove sscanf extension %as
Git-Commit-ID: bcbd004020bf0d725722be75da35fd326ff63ef4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:35:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcbd004020bf0d725722be75da35fd326ff63ef4
Gitweb:     http://git.kernel.org/tip/bcbd004020bf0d725722be75da35fd326ff63ef4
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Thu, 20 Sep 2012 23:37:50 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 11:49:31 -0300

perf tools: remove sscanf extension %as

perf uses sscanf extension %as to read and allocate a string in the same
step.  This is a non-standard extension only present in new versions of
glibc.

Replacing the use of sscanf and %as with strtok_r calls in order to
parse a given string into its components.  This is needed in Android
since bionic does not support
%as extension for sscanf.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Tested-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1348173470-4936-1-git-send-email-irina.tirdea@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c       |   36 ++++++++++++++++++++++++++++------
 tools/perf/util/trace-event-parse.c |   18 +++++++---------
 2 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 4ce04c2..49a256e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1100,6 +1100,7 @@ static int parse_probe_trace_command(const char *cmd,
 	struct probe_trace_point *tp = &tev->point;
 	char pr;
 	char *p;
+	char *argv0_str = NULL, *fmt, *fmt1_str, *fmt2_str, *fmt3_str;
 	int ret, i, argc;
 	char **argv;
 
@@ -1116,14 +1117,27 @@ static int parse_probe_trace_command(const char *cmd,
 	}
 
 	/* Scan event and group name. */
-	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
-		     &pr, (float *)(void *)&tev->group,
-		     (float *)(void *)&tev->event);
-	if (ret != 3) {
+	argv0_str = strdup(argv[0]);
+	if (argv0_str == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	fmt1_str = strtok_r(argv0_str, ":", &fmt);
+	fmt2_str = strtok_r(NULL, "/", &fmt);
+	fmt3_str = strtok_r(NULL, " \t", &fmt);
+	if (fmt1_str == NULL || strlen(fmt1_str) != 1 || fmt2_str == NULL
+	    || fmt3_str == NULL) {
 		semantic_error("Failed to parse event name: %s\n", argv[0]);
 		ret = -EINVAL;
 		goto out;
 	}
+	pr = fmt1_str[0];
+	tev->group = strdup(fmt2_str);
+	tev->event = strdup(fmt3_str);
+	if (tev->group == NULL || tev->event == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	pr_debug("Group:%s Event:%s probe:%c\n", tev->group, tev->event, pr);
 
 	tp->retprobe = (pr == 'r');
@@ -1135,10 +1149,17 @@ static int parse_probe_trace_command(const char *cmd,
 		p++;
 	} else
 		p = argv[1];
-	ret = sscanf(p, "%a[^+]+%lu", (float *)(void *)&tp->symbol,
-		     &tp->offset);
-	if (ret == 1)
+	fmt1_str = strtok_r(p, "+", &fmt);
+	tp->symbol = strdup(fmt1_str);
+	if (tp->symbol == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	fmt2_str = strtok_r(NULL, "", &fmt);
+	if (fmt2_str == NULL)
 		tp->offset = 0;
+	else
+		tp->offset = strtoul(fmt2_str, NULL, 10);
 
 	tev->nargs = argc - 2;
 	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
@@ -1162,6 +1183,7 @@ static int parse_probe_trace_command(const char *cmd,
 	}
 	ret = 0;
 out:
+	free(argv0_str);
 	argv_free(argv);
 	return ret;
 }
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index aa4c860..3aabcd6 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -229,24 +229,22 @@ void parse_proc_kallsyms(struct pevent *pevent,
 	char *next = NULL;
 	char *addr_str;
 	char *mod;
-	char ch;
+	char *fmt;
 
 	line = strtok_r(file, "\n", &next);
 	while (line) {
 		mod = NULL;
-		sscanf(line, "%as %c %as\t[%as",
-		       (float *)(void *)&addr_str, /* workaround gcc warning */
-		       &ch, (float *)(void *)&func, (float *)(void *)&mod);
+		addr_str = strtok_r(line, " ", &fmt);
 		addr = strtoull(addr_str, NULL, 16);
-		free(addr_str);
-
-		/* truncate the extra ']' */
+		/* skip character */
+		strtok_r(NULL, " ", &fmt);
+		func = strtok_r(NULL, "\t", &fmt);
+		mod = strtok_r(NULL, "]", &fmt);
+		/* truncate the extra '[' */
 		if (mod)
-			mod[strlen(mod) - 1] = 0;
+			mod = mod + 1;
 
 		pevent_register_function(pevent, func, addr, mod);
-		free(func);
-		free(mod);
 
 		line = strtok_r(NULL, "\n", &next);
 	}
