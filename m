Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab1HEVN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:13:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45326 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab1HEVNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:13:11 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=vhdKIqpQuCYA:10 a=tUHetEmO2DkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=YimlknLUPSSqWrFjD8sA:9 a=35JZ6TLa5EGcTK3IpucA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110805211302.119690302@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Aug 2011 16:59:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: [RFC][PATCH 6/8] perf/events: Add flag to produce nsec output
References: <20110805205921.909038487@goodmis.org>
Content-Disposition: inline; filename=0006-perf-events-Add-flag-to-produce-nsec-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

libparsevent library prints out in usecs but perf wants to print out
in nsecs. Add a flag that lets the user decide to print out in usec
or nsec times.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/events/event-parse.c      |   15 ++++++++++++---
 tools/lib/events/event-parse.h      |   12 ++++++++++++
 tools/perf/util/trace-event-parse.c |    1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/lib/events/event-parse.c b/tools/lib/events/event-parse.c
index 3b4fac3..dff66ad 100644
--- a/tools/lib/events/event-parse.c
+++ b/tools/lib/events/event-parse.c
@@ -3935,15 +3935,16 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 	struct event_format *event;
 	unsigned long secs;
 	unsigned long usecs;
+	unsigned long nsecs;
 	const char *comm;
 	void *data = record->data;
 	int type;
 	int pid;
 	int len;
+	int p;
 
 	secs = record->ts / NSECS_PER_SEC;
-	usecs = record->ts - secs * NSECS_PER_SEC;
-	usecs = (usecs + 500) / NSECS_PER_USEC;
+	nsecs = record->ts - secs * NSECS_PER_SEC;
 
 	if (record->size < 0) {
 		do_warning("ug! negative record size %d", record->size);
@@ -3968,7 +3969,15 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 	} else
 		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
 
-	trace_seq_printf(s, " %5lu.%06lu: %s: ", secs, usecs, event->name);
+	if (pevent->flags & PEVENT_NSEC_OUTPUT) {
+		usecs = nsecs;
+		p = 9;
+	} else {
+		usecs = (nsecs + 500) / NSECS_PER_USEC;
+		p = 6;
+	}
+
+	trace_seq_printf(s, " %5lu.%0*lu: %s: ", secs, p, usecs, event->name);
 
 	/* Space out the event names evenly. */
 	len = strlen(event->name);
diff --git a/tools/lib/events/event-parse.h b/tools/lib/events/event-parse.h
index 2e0222d..8852827 100644
--- a/tools/lib/events/event-parse.h
+++ b/tools/lib/events/event-parse.h
@@ -334,6 +334,10 @@ enum pevent_func_arg_type {
 	PEVENT_FUNC_ARG_MAX_TYPES
 };
 
+enum pevent_flag {
+	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
+};
+
 struct cmdline;
 struct cmdline_list;
 struct func_map;
@@ -373,6 +377,7 @@ struct pevent {
 	struct printk_list *printklist;
 	unsigned int printk_count;
 
+
 	struct event_format **events;
 	int nr_events;
 	struct event_format **sort_events;
@@ -397,6 +402,8 @@ struct pevent {
 
 	int test_filters;
 
+	int flags;
+
 	struct format_field *bprint_ip_field;
 	struct format_field *bprint_fmt_field;
 	struct format_field *bprint_buf_field;
@@ -408,6 +415,11 @@ struct pevent {
 	struct event_format *last_event;
 };
 
+static inline void pevent_set_flag(struct pevent *pevent, int flag)
+{
+	pevent->flags |= flag;
+}
+
 static inline unsigned short
 __data2host2(struct pevent *pevent, unsigned short data)
 {
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index ca3e5cd..f9604f1 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -47,6 +47,7 @@ int read_trace_init(int file_bigendian, int host_bigendian)
 	perf_pevent = pevent_alloc();
 	pevent = perf_pevent;
 
+	pevent_set_flag(pevent, PEVENT_NSEC_OUTPUT);
 	pevent_set_file_bigendian(pevent, file_bigendian);
 	pevent_set_host_bigendian(pevent, host_bigendian);
 
-- 
1.7.5.4


