Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0FXVlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:41:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56624 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab0FXVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Hu9un9B46ParMvew1qYLWtJybUJe5ze+bNlMAkKZbaux6PZ1aX+RdSDyVvXaTy6vFs
         fhIJgQGHuroTMashPg2X9074VvsFjIC7hbs0GmNgl4HOV1E93f84DP1opHGw9C5jOmoS
         X3dhl9BBVR2itHIWwFLPd90FFfvXCOGhtr1Pc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 7/7] perf: Report lost events in perf trace debug mode
Date: Thu, 24 Jun 2010 23:40:58 +0200
Message-Id: <1277415658-10036-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
References: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account and report lost events in perf trace debugging mode,
useful to check the reliability of the traces.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 83df8db..294da72 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -11,7 +11,7 @@
 
 static char const		*script_name;
 static char const		*generate_script_lang;
-static bool			debug_ordering;
+static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
 
@@ -92,7 +92,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	}
 
 	if (session->sample_type & PERF_SAMPLE_RAW) {
-		if (debug_ordering) {
+		if (debug_mode) {
 			if (data.time < last_timestamp) {
 				pr_err("Samples misordered, previous: %llu "
 					"this: %llu\n", last_timestamp,
@@ -116,6 +116,15 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
+static u64 nr_lost;
+
+static int process_lost_event(event_t *event, struct perf_session *session __used)
+{
+	nr_lost += event->lost.lost;
+
+	return 0;
+}
+
 static struct perf_event_ops event_ops = {
 	.sample	= process_sample_event,
 	.comm	= event__process_comm,
@@ -123,6 +132,7 @@ static struct perf_event_ops event_ops = {
 	.event_type = event__process_event_type,
 	.tracing_data = event__process_tracing_data,
 	.build_id = event__process_build_id,
+	.lost = process_lost_event,
 	.ordered_samples = true,
 };
 
@@ -141,8 +151,10 @@ static int __cmd_trace(struct perf_session *session)
 
 	ret = perf_session__process_events(session, &event_ops);
 
-	if (debug_ordering)
+	if (debug_mode) {
 		pr_err("Misordered timestamps: %llu\n", nr_unordered);
+		pr_err("Lost events: %llu\n", nr_lost);
+	}
 
 	return ret;
 }
@@ -554,8 +566,8 @@ static const struct option options[] = {
 		   "generate perf-trace.xx script in specified language"),
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
-	OPT_BOOLEAN('d', "debug-ordering", &debug_ordering,
-		   "check that samples time ordering is monotonic"),
+	OPT_BOOLEAN('d', "debug-mode", &debug_mode,
+		   "do various checks like samples ordering and lost events"),
 
 	OPT_END()
 };
-- 
1.6.2.3

