Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1FCNjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:39:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:57916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1FCNjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:39:04 -0400
Date: Fri, 3 Jun 2011 13:38:51 GMT
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-610723f24eeb842025178a6722fa9108c4e157b6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1306528124-25861-3-git-send-email-dsahern@gmail.com>
References: <1306528124-25861-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Make printing of dso a separate field option
Git-Commit-ID: 610723f24eeb842025178a6722fa9108c4e157b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 13:38:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  610723f24eeb842025178a6722fa9108c4e157b6
Gitweb:     http://git.kernel.org/tip/610723f24eeb842025178a6722fa9108c4e157b6
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 27 May 2011 14:28:44 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 2 Jun 2011 13:29:14 -0300

perf script: Make printing of dso a separate field option

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
