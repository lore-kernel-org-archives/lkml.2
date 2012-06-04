Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2FDINc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:13:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:26493 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab2FDINJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:13:09 -0400
From: Andrew Vagin <avagin@openvz.org>
Cc: Arun Sharma <asharma@fb.com>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] perf: teach perf inject to merge sched_switch* events for profiling sleep times
Date: Mon,  4 Jun 2012 12:09:42 +0400
Message-Id: <1338797382-287275-6-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1338797382-287275-1-git-send-email-avagin@openvz.org>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time difference between sched_switch and sched_switch_finish is a time
when a task wasn't being executed on a cpu.

My code saves the time of sched_switch event for each process and
when it meets stat_switch_finish, it sets time difference in sample->period
and saves this new sample in the new perf.data.

As a result we can see where and how long task sleeps.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/builtin-inject.c |   88 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index bc30a40..631051e 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -13,6 +13,8 @@
 #include "util/debug.h"
 
 #include "util/parse-options.h"
+#include "util/trace-event.h"
+
 
 static char		const *input_name	= "-";
 static const char	*output_name		= "-";
@@ -21,6 +23,9 @@ static int		output;
 static u64		bytes_written		= 0;
 
 static bool		inject_build_ids;
+static bool		inject_sched_stat;
+
+struct perf_session	*session;
 
 static int perf_event__repipe_synth(struct perf_tool *tool __used,
 				    union perf_event *event,
@@ -47,7 +52,7 @@ static int perf_event__repipe_synth(struct perf_tool *tool __used,
 
 static int perf_event__repipe_op2_synth(struct perf_tool *tool,
 					union perf_event *event,
-					struct perf_session *session __used)
+					struct perf_session *s __used)
 {
 	return perf_event__repipe_synth(tool, event, NULL);
 }
@@ -59,7 +64,7 @@ static int perf_event__repipe_event_type_synth(struct perf_tool *tool,
 }
 
 static int perf_event__repipe_tracing_data_synth(union perf_event *event,
-						 struct perf_session *session __used)
+						 struct perf_session *s __used)
 {
 	return perf_event__repipe_synth(NULL, event, NULL);
 }
@@ -119,12 +124,12 @@ static int perf_event__repipe_task(struct perf_tool *tool,
 }
 
 static int perf_event__repipe_tracing_data(union perf_event *event,
-					   struct perf_session *session)
+					   struct perf_session *s)
 {
 	int err;
 
 	perf_event__repipe_synth(NULL, event, NULL);
-	err = perf_event__process_tracing_data(event, session);
+	err = perf_event__process_tracing_data(event, s);
 
 	return err;
 }
@@ -210,6 +215,75 @@ repipe:
 	return 0;
 }
 
+struct event_entry
+{
+	struct list_head list;
+	u32 pid;
+	u64 time;
+};
+
+static LIST_HEAD(samples);
+
+static int perf_event__sched_stat(struct perf_tool *tool,
+				      union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_evsel *evsel __used,
+				      struct machine *machine)
+{
+	int type;
+	struct event_format *e;
+	const char *evname = NULL;
+	struct event_entry *ent;
+
+	type = trace_parse_common_type(sample->raw_data);
+	e = trace_find_event(type);
+	if (e)
+		evname = e->name;
+
+	if (!strcmp(evname, "sched_switch")) {
+		list_for_each_entry(ent, &samples, list)
+			if (sample->pid == ent->pid)
+				break;
+
+		if (&ent->list != &samples) {
+			list_del(&ent->list);
+			free(ent);
+		}
+
+		ent = malloc(sizeof(struct event_entry));
+		ent->pid = sample->pid;
+		ent->time = sample->time;
+		list_add(&ent->list, &samples);
+		return 0;
+
+	} else if (!strcmp(evname, "sched_switch_finish")) {
+		union perf_event *event_sw;
+
+		list_for_each_entry(ent, &samples, list)
+			if (sample->pid == ent->pid)
+				break;
+
+		if (&ent->list == &samples) {
+			pr_debug("Could not find sched_switch for pid %u\n", sample->pid);
+			return 0;
+		}
+
+		event_sw = malloc(event->header.size);
+		if (event_sw == NULL)
+			return -1;
+
+		memcpy(event_sw, event, event->header.size);
+		sample->period = sample->time - ent->time;
+		perf_session__synthesize_sample(session, event_sw, sample);
+		perf_event__repipe(tool, event_sw, sample, machine);
+		free(event_sw);
+		return 0;
+	}
+
+	perf_event__repipe(tool, event, sample, machine);
+
+	return 0;
+}
 struct perf_tool perf_inject = {
 	.sample		= perf_event__repipe_sample,
 	.mmap		= perf_event__repipe,
@@ -235,7 +309,6 @@ static void sig_handler(int sig __attribute__((__unused__)))
 
 static int __cmd_inject(void)
 {
-	struct perf_session *session;
 	int ret = -EINVAL;
 
 	signal(SIGINT, sig_handler);
@@ -245,6 +318,9 @@ static int __cmd_inject(void)
 		perf_inject.mmap	 = perf_event__repipe_mmap;
 		perf_inject.fork	 = perf_event__repipe_task;
 		perf_inject.tracing_data = perf_event__repipe_tracing_data;
+	} else if (inject_sched_stat) {
+		perf_inject.sample	= perf_event__sched_stat;
+		perf_inject.ordered_samples = true;
 	}
 
 	session = perf_session__new(input_name, O_RDONLY, false, true, &perf_inject);
@@ -272,6 +348,8 @@ static const char * const report_usage[] = {
 static const struct option options[] = {
 	OPT_BOOLEAN('b', "build-ids", &inject_build_ids,
 		    "Inject build-ids into the output stream"),
+	OPT_BOOLEAN('s', "sched-switch", &inject_sched_stat,
+		    "merge sched-switch* for profiling sleep time"),
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_STRING('o', "output", &output_name, "file",
-- 
1.7.1

