Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1FBU4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 16:56:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:36239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab1FBU4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 16:56:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/9] perf script: Make printing of dso a separate field option
Date: Thu,  2 Jun 2011 17:56:35 -0300
Message-Id: <1307048196-16387-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1307048196-16387-1-git-send-email-acme@infradead.org>
References: <1307048196-16387-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The 'sym' option displays both the function name and the DSO it comes
from. Split the display of the dso into a separate option.  This allows
display of the ip address and symbol without the dso, thus shortening
line lengths - and decluttering the output a bit.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1306528124-25861-3-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |    2 +-
 tools/perf/builtin-script.c              |   17 ++++++++++++-----
 tools/perf/util/session.c                |   13 ++++++++++---
 tools/perf/util/session.h                |    2 +-
 4 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 67a4e5c..1e744c2 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,7 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, ip, sym. Field
+        comm, tid, pid, time, cpu, event, trace, ip, sym, dso. Field
         list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 0852db2..a8bd00f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -32,6 +32,7 @@ enum perf_output_field {
 	PERF_OUTPUT_TRACE           = 1U << 6,
 	PERF_OUTPUT_IP              = 1U << 7,
 	PERF_OUTPUT_SYM             = 1U << 8,
+	PERF_OUTPUT_DSO             = 1U << 9,
 };
 
 struct output_option {
@@ -47,6 +48,7 @@ struct output_option {
 	{.str = "trace", .field = PERF_OUTPUT_TRACE},
 	{.str = "ip",    .field = PERF_OUTPUT_IP},
 	{.str = "sym",   .field = PERF_OUTPUT_SYM},
+	{.str = "dso",   .field = PERF_OUTPUT_DSO},
 };
 
 /* default set to maintain compatibility with current format */
@@ -63,7 +65,7 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM,
+				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -74,7 +76,7 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM,
+				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -93,7 +95,7 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM,
+				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -176,6 +178,11 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		       "No addresses to convert to symbols.\n");
 		return -EINVAL;
 	}
+	if (PRINT_FIELD(DSO) && !PRINT_FIELD(IP)) {
+		pr_err("Display of DSO requested but IP is not selected.\n"
+		       "No addresses to convert to dso.\n");
+		return -EINVAL;
+	}
 
 	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
 		perf_event_attr__check_stype(attr, PERF_SAMPLE_TID, "TID",
@@ -304,7 +311,7 @@ static void process_event(union perf_event *event __unused,
 		else
 			printf("\n");
 		perf_session__print_ip(event, sample, session,
-					      PRINT_FIELD(SYM));
+					      PRINT_FIELD(SYM), PRINT_FIELD(DSO));
 	}
 
 	printf("\n");
@@ -996,7 +1003,7 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso",
 		     parse_output_fields),
 
 	OPT_END()
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ad33650..0dd4182 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1205,7 +1205,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 void perf_session__print_ip(union perf_event *event,
 			    struct perf_sample *sample,
 			    struct perf_session *session,
-			    int print_sym)
+			    int print_sym, int print_dso)
 {
 	struct addr_location al;
 	const char *symname, *dsoname;
@@ -1241,12 +1241,15 @@ void perf_session__print_ip(union perf_event *event,
 				else
 					symname = "";
 
+				printf(" %s", symname);
+			}
+			if (print_dso) {
 				if (node->map && node->map->dso && node->map->dso->name)
 					dsoname = node->map->dso->name;
 				else
 					dsoname = "";
 
-				printf(" %s (%s)", symname, dsoname);
+				printf(" (%s)", dsoname);
 			}
 			printf("\n");
 
@@ -1261,12 +1264,16 @@ void perf_session__print_ip(union perf_event *event,
 			else
 				symname = "";
 
+			printf(" %s", symname);
+		}
+
+		if (print_dso) {
 			if (al.map && al.map->dso && al.map->dso->name)
 				dsoname = al.map->dso->name;
 			else
 				dsoname = "";
 
-			printf(" %s (%s)", symname, dsoname);
+			printf(" (%s)", dsoname);
 		}
 	}
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index d76af0f..de4178d 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -170,6 +170,6 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 void perf_session__print_ip(union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_session *session,
-				 int print_sym);
+				 int print_sym, int print_dso);
 
 #endif /* __PERF_SESSION_H */
-- 
1.6.2.5

