Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2FTQ47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:56:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab2FTQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:56:58 -0400
Date: Wed, 20 Jun 2012 09:56:28 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-e4f0vuy3283hmzfjjvkgm7fo@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Replace __event_name uses with perf_evsel__name
Git-Commit-ID: 5bff01f66db1753abcae03a06b21e56e7e9d9fa9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:56:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bff01f66db1753abcae03a06b21e56e7e9d9fa9
Gitweb:     http://git.kernel.org/tip/5bff01f66db1753abcae03a06b21e56e7e9d9fa9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 12 Jun 2012 13:35:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:21 -0300

perf script: Replace __event_name uses with perf_evsel__name

No logic change, just remove one more user of __event_name().

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-e4f0vuy3283hmzfjjvkgm7fo@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 8e395a5..8f9f9b6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -137,10 +137,11 @@ static const char *output_field2str(enum perf_output_field field)
 
 #define PRINT_FIELD(x)  (output[attr->type].fields & PERF_OUTPUT_##x)
 
-static int perf_event_attr__check_stype(struct perf_event_attr *attr,
-				  u64 sample_type, const char *sample_msg,
-				  enum perf_output_field field)
+static int perf_evsel__check_stype(struct perf_evsel *evsel,
+				   u64 sample_type, const char *sample_msg,
+				   enum perf_output_field field)
 {
+	struct perf_event_attr *attr = &evsel->attr;
 	int type = attr->type;
 	const char *evname;
 
@@ -148,7 +149,7 @@ static int perf_event_attr__check_stype(struct perf_event_attr *attr,
 		return 0;
 
 	if (output[type].user_set) {
-		evname = __event_name(attr->type, attr->config);
+		evname = perf_evsel__name(evsel);
 		pr_err("Samples for '%s' event do not have %s attribute set. "
 		       "Cannot print '%s' field.\n",
 		       evname, sample_msg, output_field2str(field));
@@ -157,7 +158,7 @@ static int perf_event_attr__check_stype(struct perf_event_attr *attr,
 
 	/* user did not ask for it explicitly so remove from the default list */
 	output[type].fields &= ~field;
-	evname = __event_name(attr->type, attr->config);
+	evname = perf_evsel__name(evsel);
 	pr_debug("Samples for '%s' event do not have %s attribute set. "
 		 "Skipping '%s' field.\n",
 		 evname, sample_msg, output_field2str(field));
@@ -175,8 +176,8 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		return -EINVAL;
 
 	if (PRINT_FIELD(IP)) {
-		if (perf_event_attr__check_stype(attr, PERF_SAMPLE_IP, "IP",
-					   PERF_OUTPUT_IP))
+		if (perf_evsel__check_stype(evsel, PERF_SAMPLE_IP, "IP",
+					    PERF_OUTPUT_IP))
 			return -EINVAL;
 
 		if (!no_callchain &&
@@ -185,8 +186,8 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 	}
 
 	if (PRINT_FIELD(ADDR) &&
-		perf_event_attr__check_stype(attr, PERF_SAMPLE_ADDR, "ADDR",
-				       PERF_OUTPUT_ADDR))
+		perf_evsel__check_stype(evsel, PERF_SAMPLE_ADDR, "ADDR",
+					PERF_OUTPUT_ADDR))
 		return -EINVAL;
 
 	if (PRINT_FIELD(SYM) && !PRINT_FIELD(IP) && !PRINT_FIELD(ADDR)) {
@@ -208,18 +209,18 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 	}
 
 	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
-		perf_event_attr__check_stype(attr, PERF_SAMPLE_TID, "TID",
-				       PERF_OUTPUT_TID|PERF_OUTPUT_PID))
+		perf_evsel__check_stype(evsel, PERF_SAMPLE_TID, "TID",
+					PERF_OUTPUT_TID|PERF_OUTPUT_PID))
 		return -EINVAL;
 
 	if (PRINT_FIELD(TIME) &&
-		perf_event_attr__check_stype(attr, PERF_SAMPLE_TIME, "TIME",
-				       PERF_OUTPUT_TIME))
+		perf_evsel__check_stype(evsel, PERF_SAMPLE_TIME, "TIME",
+					PERF_OUTPUT_TIME))
 		return -EINVAL;
 
 	if (PRINT_FIELD(CPU) &&
-		perf_event_attr__check_stype(attr, PERF_SAMPLE_CPU, "CPU",
-				       PERF_OUTPUT_CPU))
+		perf_evsel__check_stype(evsel, PERF_SAMPLE_CPU, "CPU",
+					PERF_OUTPUT_CPU))
 		return -EINVAL;
 
 	return 0;
@@ -258,9 +259,10 @@ static int perf_session__check_output_opt(struct perf_session *session)
 
 static void print_sample_start(struct perf_sample *sample,
 			       struct thread *thread,
-			       struct perf_event_attr *attr)
+			       struct perf_evsel *evsel)
 {
 	int type;
+	struct perf_event_attr *attr = &evsel->attr;
 	struct event_format *event;
 	const char *evname = NULL;
 	unsigned long secs;
@@ -305,7 +307,7 @@ static void print_sample_start(struct perf_sample *sample,
 			if (event)
 				evname = event->name;
 		} else
-			evname = __event_name(attr->type, attr->config);
+			evname = perf_evsel__name(evsel);
 
 		printf("%s: ", evname ? evname : "[unknown]");
 	}
@@ -412,7 +414,7 @@ static void process_event(union perf_event *event __unused,
 	if (output[attr->type].fields == 0)
 		return;
 
-	print_sample_start(sample, thread, attr);
+	print_sample_start(sample, thread, evsel);
 
 	if (is_bts_event(attr)) {
 		print_sample_bts(event, sample, evsel, machine, thread);
