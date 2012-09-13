Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab2IMWJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:09:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60022 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab2IMWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:09:46 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 1/4] perf tools: remove sscanf extension %as
Date: Fri, 14 Sep 2012 01:07:40 +0300
Message-Id: <1347574063-22521-2-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
References: <1347574063-22521-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

perf uses sscanf extension %as to read and allocate a
string in the same step. This is a non-standard extension
only present in new versions of glibc.

Replacing the use of sscanf and %as with strtok_r calls
in order to parse a given string into its components.
This is needed in Android since bionic does not support
%as extension for sscanf.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/util/probe-event.c       |   25 ++++++++++++++++++-------
 tools/perf/util/trace-event-parse.c |   18 ++++++++----------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 4ce04c2..685ddcf 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1100,6 +1100,7 @@ static int parse_probe_trace_command(const char *cmd,
 	struct probe_trace_point *tp = &tev->point;
 	char pr;
 	char *p;
+	char *argv0_str = NULL, *fmt, *fmt1_str, *fmt2_str, *fmt3_str;
 	int ret, i, argc;
 	char **argv;
 
@@ -1116,14 +1117,19 @@ static int parse_probe_trace_command(const char *cmd,
 	}
 
 	/* Scan event and group name. */
-	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
-		     &pr, (float *)(void *)&tev->group,
-		     (float *)(void *)&tev->event);
-	if (ret != 3) {
+	argv0_str = strdup(argv[0]);
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
 	pr_debug("Group:%s Event:%s probe:%c\n", tev->group, tev->event, pr);
 
 	tp->retprobe = (pr == 'r');
@@ -1135,10 +1141,13 @@ static int parse_probe_trace_command(const char *cmd,
 		p++;
 	} else
 		p = argv[1];
-	ret = sscanf(p, "%a[^+]+%lu", (float *)(void *)&tp->symbol,
-		     &tp->offset);
-	if (ret == 1)
+	fmt1_str = strtok_r(p, "+", &fmt);
+	tp->symbol = strdup(fmt1_str);
+	fmt2_str = strtok_r(NULL, "", &fmt);
+	if (fmt2_str == NULL)
 		tp->offset = 0;
+	else
+		tp->offset = strtoul(fmt2_str, NULL, 10);
 
 	tev->nargs = argc - 2;
 	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
@@ -1162,6 +1171,8 @@ static int parse_probe_trace_command(const char *cmd,
 	}
 	ret = 0;
 out:
+	if (argv0_str)
+		free(argv0_str);
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
-- 
1.7.9.5

