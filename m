Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab1FGX40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:56:26 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61697 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1FGX4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tKc5GoglWeKSIejNqxocnGAL4LfLtKZwXnyWpplVy7UXjoOpAPMEaV0Y+ryBcvp75b
         mC9vvYhOWIcHegbBf1ZvSNwWSif8h8ui7xvqpfvVOixJSEBFWnOw1gCoD82G3njibMwd
         hO5cEvZ9Ltwnz0f7VvSnNsTwNljZNl9E30gFA=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 5/6] perf script: pass trace event to print_trace_event
Date: Tue,  7 Jun 2011 17:56:19 -0600
Message-Id: <1307490979-24754-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next patch needs parsed trace event in perf-script. No since
extracting it twice.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-script.c         |   16 ++++++++++++++--
 tools/perf/util/trace-event-parse.c |   12 +-----------
 tools/perf/util/trace-event.h       |    2 +-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3056b45..c61ae26 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -362,14 +362,26 @@ static void process_event(union perf_event *event __unused,
 			  struct thread *thread)
 {
 	struct perf_event_attr *attr = &evsel->attr;
+	struct event *tr_event = NULL;
 
 	if (output[attr->type].fields == 0)
 		return;
 
+	if (attr->type == PERF_TYPE_TRACEPOINT) {
+		int type;
+
+		type = trace_parse_common_type(sample->raw_data);
+		tr_event = trace_find_event(type);
+		if (!tr_event) {
+			warning("ug! no event found for type %d", type);
+			return;
+		}
+	}
+
 	print_sample_start(sample, thread, attr);
 
-	if (PRINT_FIELD(TRACE))
-		print_trace_event(sample->cpu, sample->raw_data,
+	if ((attr->type == PERF_TYPE_TRACEPOINT) && PRINT_FIELD(TRACE))
+		print_trace_event(tr_event, sample->cpu, sample->raw_data,
 				  sample->raw_size);
 
 	if (PRINT_FIELD(ADDR))
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 1e88485..1f4dccd 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2912,20 +2912,10 @@ pretty_print_func_graph(void *data, int size, struct event *event,
 	printf("\n");
 }
 
-void print_trace_event(int cpu, void *data, int size)
+void print_trace_event(struct event *event, int cpu, void *data, int size)
 {
-	struct event *event;
-	int type;
 	int pid;
 
-	type = trace_parse_common_type(data);
-
-	event = trace_find_event(type);
-	if (!event) {
-		warning("ug! no event found for type %d", type);
-		return;
-	}
-
 	pid = trace_parse_common_pid(data);
 
 	if (event->flags & (EVENT_FL_ISFUNCENT | EVENT_FL_ISFUNCRET))
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index f674dda..34ec9f3 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -177,7 +177,7 @@ void print_printk(void);
 
 int parse_ftrace_file(char *buf, unsigned long size);
 int parse_event_file(char *buf, unsigned long size, char *sys);
-void print_trace_event(int cpu, void *data, int size);
+void print_trace_event(struct event *event, int cpu, void *data, int size);
 
 extern int file_bigendian;
 extern int host_bigendian;
-- 
1.7.5.2

