Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1E0U3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:29:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54860 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab1E0U2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wnMkLs9DwuMjyPq5XptJlyF+6Oa3mS91ZpzHHVwQ2342n/ZXzNnb1L1CsRAMXpjuKp
         /f6RIQnh1B5vMHvh16bNexKcWjjLE4TFXlNN97nxDFN0lIe+BS8hbj6YjLoFtaddis2V
         epUV2Cn3iYLe7CDTJwEcr2o2IykySAnSHXf0U=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/2] perf script: make printing of dso a separate field option
Date: Fri, 27 May 2011 14:28:44 -0600
Message-Id: <1306528124-25861-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1306528124-25861-1-git-send-email-dsahern@gmail.com>
References: <1306528124-25861-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'sym' option displays both the function name and the DSO it
comes from. Split the display of the dso into a separate option.
This allows display of the ip address and symbol without the dso,
thus shortening line lengths - and decluttering the output a bit.

Signed-off-by: David Ahern <dsahern@gmail.com>
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
index 75ecb4d..ea5bfed 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -33,6 +33,7 @@ enum perf_output_field {
 	PERF_OUTPUT_TRACE           = 1U << 6,
 	PERF_OUTPUT_IP              = 1U << 7,
 	PERF_OUTPUT_SYM             = 1U << 8,
+	PERF_OUTPUT_DSO             = 1U << 9,
 };
 
 struct output_option {
@@ -48,6 +49,7 @@ struct output_option {
 	{.str = "trace", .field = PERF_OUTPUT_TRACE},
 	{.str = "ip",    .field = PERF_OUTPUT_IP},
 	{.str = "sym",   .field = PERF_OUTPUT_SYM},
+	{.str = "dso",   .field = PERF_OUTPUT_DSO},
 };
 
 /* default set to maintain compatibility with current format */
@@ -64,7 +66,7 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM,
+				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -75,7 +77,7 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM,
+				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -94,7 +96,7 @@ static struct {
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 			      PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
 			      PERF_OUTPUT_EVNAME | PERF_OUTPUT_IP |
-				  PERF_OUTPUT_SYM,
+				  PERF_OUTPUT_SYM | PERF_OUTPUT_DSO,
 
 		.invalid_fields = PERF_OUTPUT_TRACE,
 	},
@@ -177,6 +179,11 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
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
@@ -305,7 +312,7 @@ static void process_event(union perf_event *event __unused,
 		else
 			printf("\n");
 		perf_session__print_ip(event, sample, session,
-					      PRINT_FIELD(SYM));
+					      PRINT_FIELD(SYM), PRINT_FIELD(DSO));
 	}
 
 	printf("\n");
@@ -997,7 +1004,7 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso",
 		     parse_output_fields),
 
 	OPT_END()
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 13e3892..9f8919c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1171,7 +1171,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 void perf_session__print_ip(union perf_event *event,
 			    struct perf_sample *sample,
 			    struct perf_session *session,
-			    int print_sym)
+			    int print_sym, int print_dso)
 {
 	struct addr_location al;
 	const char *symname, *dsoname;
@@ -1207,12 +1207,15 @@ void perf_session__print_ip(union perf_event *event,
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
 
@@ -1227,12 +1230,16 @@ void perf_session__print_ip(union perf_event *event,
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
index 0581e71..6e08b15 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -168,6 +168,6 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 void perf_session__print_ip(union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_session *session,
-				 int print_sym);
+				 int print_sym, int print_dso);
 
 #endif /* __PERF_SESSION_H */
-- 
1.7.5.1

