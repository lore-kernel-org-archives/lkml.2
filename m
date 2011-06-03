Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1FCNih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:38:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:57888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab1FCNif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:38:35 -0400
Date: Fri, 3 Jun 2011 13:38:24 GMT
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-787bef174f055343c69a9639e6e05a564980ed4c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306528124-25861-2-git-send-email-dsahern@gmail.com>
References: <1306528124-25861-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: "sym" field really means show IP data
Git-Commit-ID: 787bef174f055343c69a9639e6e05a564980ed4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 13:38:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  787bef174f055343c69a9639e6e05a564980ed4c
Gitweb:     http://git.kernel.org/tip/787bef174f055343c69a9639e6e05a564980ed4c
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 27 May 2011 14:28:43 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 2 Jun 2011 13:28:34 -0300

perf script: "sym" field really means show IP data

Currently the "sym" output field is used to dump instruction pointers
and callchain stack. Sample addresses can also be converted to symbols,
so the meaning of "sym" needs to be fixed. This patch adds an "ip"
option and if it is selected the user can also opt to dump symbols for
them. If the user opts to dump IP without syms only the address is
shown.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1306528124-25861-2-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |   10 +++---
 tools/perf/builtin-script.c              |   31 ++++++++++++------
 tools/perf/util/session.c                |   50 +++++++++++++++++------------
 tools/perf/util/session.h                |    5 ++-
 4 files changed, 58 insertions(+), 38 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 86c87e2..67a4e5c 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,10 +115,10 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, sym. Field
+        comm, tid, pid, time, cpu, event, trace, ip, sym. Field
         list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
-        e.g., -f sw:comm,tid,time,sym  and -f trace:time,cpu,trace
+        e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
 
 		perf script -f <fields>
 
@@ -132,17 +132,17 @@ OPTIONS
 	The arguments are processed in the order received. A later usage can
 	reset a prior request. e.g.:
     
-		-f trace: -f comm,tid,time,sym
+		-f trace: -f comm,tid,time,ip,sym
     
 	The first -f suppresses trace events (field list is ""), but then the
-	second invocation sets the fields to comm,tid,time,sym. In this case a
+	second invocation sets the fields to comm,tid,time,ip,sym. In this case a
 	warning is given to the user:
     
 		"Overriding previous field request for all events."
     
 	Alternativey, consider the order:
     
-		-f comm,tid,time,sym -f trace:
+		-f comm,tid,time,ip,sym -f trace:
     
 	The first -f sets the fields for all events and the second -f
 	suppresses trace events. The user is given a warning message about
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 22747de..0852db2 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -30,7 +30,8 @@ enum perf_output_field {
 	PERF_OUTPUT_CPU             = 1U << 4,
 	PERF_OUTPUT_EVNAME          = 1U << 5,
 	PERF_OUTPUT_TRACE           = 1U << 6,
-	PERF_OUTPUT_SYM             = 1U << 7,
+	PERF_OUTPUT_IP              = 1U << 7,
+	PERF_OUTPUT_SYM             = 1U << 8,
 };
 
 struct output_option {
@@ -44,6 +45,7 @@ struct output_option {
 	{.str = "cpu",   .field = PERF_OUTPUT_CPU},
 	{.str = "event", .field = PERF_OUTPUT_EVNAME},
 	{.str = "trace", .field = PERF_OUTPUT_TRACE},
+	{.str = "ip",    .field = PERF_OUTPUT_IP},
 	{.str = "sym",   .field = PERF_OUTPUT_SYM},
 };
 
@@ -60,7 +62,8 @@ static struct {
 
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
-			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
+				  PERF_OUTPUT_SYM,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -70,7 +73,8 @@ static struct {
 
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
-			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
+				  PERF_OUTPUT_SYM,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -88,7 +92,8 @@ static struct {
 
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
-			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_SYM,
+			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
+				  PERF_OUTPUT_SYM,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -157,15 +162,20 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		!perf_session__has_traces(session, "record -R"))
 		return -EINVAL;
 
-	if (PRINT_FIELD(SYM)) {
+	if (PRINT_FIELD(IP)) {
 		if (perf_event_attr__check_stype(attr, PERF_SAMPLE_IP, "IP",
-					   PERF_OUTPUT_SYM))
+					   PERF_OUTPUT_IP))
 			return -EINVAL;
 
 		if (!no_callchain &&
 		    !(attr->sample_type & PERF_SAMPLE_CALLCHAIN))
 			symbol_conf.use_callchain = false;
 	}
+	if (PRINT_FIELD(SYM) && !PRINT_FIELD(IP)) {
+		pr_err("Display of symbols requested but IP is not selected.\n"
+		       "No addresses to convert to symbols.\n");
+		return -EINVAL;
+	}
 
 	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
 		perf_event_attr__check_stype(attr, PERF_SAMPLE_TID, "TID",
@@ -230,7 +240,7 @@ static void print_sample_start(struct perf_sample *sample,
 	if (PRINT_FIELD(COMM)) {
 		if (latency_format)
 			printf("%8.8s ", thread->comm);
-		else if (PRINT_FIELD(SYM) && symbol_conf.use_callchain)
+		else if (PRINT_FIELD(IP) && symbol_conf.use_callchain)
 			printf("%s ", thread->comm);
 		else
 			printf("%16s ", thread->comm);
@@ -288,12 +298,13 @@ static void process_event(union perf_event *event __unused,
 		print_trace_event(sample->cpu, sample->raw_data,
 				  sample->raw_size);
 
-	if (PRINT_FIELD(SYM)) {
+	if (PRINT_FIELD(IP)) {
 		if (!symbol_conf.use_callchain)
 			printf(" ");
 		else
 			printf("\n");
-		perf_session__print_symbols(event, sample, session);
+		perf_session__print_ip(event, sample, session,
+					      PRINT_FIELD(SYM));
 	}
 
 	printf("\n");
@@ -985,7 +996,7 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym",
 		     parse_output_fields),
 
 	OPT_END()
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f5a8fbd..ad33650 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1202,9 +1202,10 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 	return NULL;
 }
 
-void perf_session__print_symbols(union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_session *session)
+void perf_session__print_ip(union perf_event *event,
+			    struct perf_sample *sample,
+			    struct perf_session *session,
+			    int print_sym)
 {
 	struct addr_location al;
 	const char *symname, *dsoname;
@@ -1233,32 +1234,39 @@ void perf_session__print_symbols(union perf_event *event,
 			if (!node)
 				break;
 
-			if (node->sym && node->sym->name)
-				symname = node->sym->name;
-			else
-				symname = "";
+			printf("\t%16" PRIx64, node->ip);
+			if (print_sym) {
+				if (node->sym && node->sym->name)
+					symname = node->sym->name;
+				else
+					symname = "";
 
-			if (node->map && node->map->dso && node->map->dso->name)
-				dsoname = node->map->dso->name;
-			else
-				dsoname = "";
+				if (node->map && node->map->dso && node->map->dso->name)
+					dsoname = node->map->dso->name;
+				else
+					dsoname = "";
 
-			printf("\t%16" PRIx64 " %s (%s)\n", node->ip, symname, dsoname);
+				printf(" %s (%s)", symname, dsoname);
+			}
+			printf("\n");
 
 			callchain_cursor_advance(cursor);
 		}
 
 	} else {
-		if (al.sym && al.sym->name)
-			symname = al.sym->name;
-		else
-			symname = "";
+		printf("%16" PRIx64, al.addr);
+		if (print_sym) {
+			if (al.sym && al.sym->name)
+				symname = al.sym->name;
+			else
+				symname = "";
 
-		if (al.map && al.map->dso && al.map->dso->name)
-			dsoname = al.map->dso->name;
-		else
-			dsoname = "";
+			if (al.map && al.map->dso && al.map->dso->name)
+				dsoname = al.map->dso->name;
+			else
+				dsoname = "";
 
-		printf("%16" PRIx64 " %s (%s)", al.addr, symname, dsoname);
+			printf(" %s (%s)", symname, dsoname);
+		}
 	}
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 66d4e14..d76af0f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -167,8 +167,9 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
-void perf_session__print_symbols(union perf_event *event,
+void perf_session__print_ip(union perf_event *event,
 				 struct perf_sample *sample,
-				 struct perf_session *session);
+				 struct perf_session *session,
+				 int print_sym);
 
 #endif /* __PERF_SESSION_H */
