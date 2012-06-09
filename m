Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2FIJDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 05:03:51 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51813 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896Ab2FIJDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 05:03:47 -0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] perf sched replay: fix event lookup
Date: Sat,  9 Jun 2012 13:05:58 +0400
Message-Id: <1339232758-920-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new function trace_find_event_by_name to lookup events before
looking through /sys files. This helps 'perf sched replay' to map
event names to IDs correctly when processing perf.data recorded
on another machine.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 tools/perf/util/evlist.c            |   18 ++++++++++++++++--
 tools/perf/util/trace-event-parse.c |    4 ++++
 tools/perf/util/trace-event.h       |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4ac5f5a..7ebb9c5 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -17,6 +17,7 @@
 #include <unistd.h>
 
 #include "parse-events.h"
+#include "trace-event.h"
 
 #include <sys/mman.h>
 
@@ -231,12 +232,25 @@ int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
 					  const struct perf_evsel_str_handler *assocs,
 					  size_t nr_assocs)
 {
+	struct event_format *event;
 	struct perf_evsel *evsel;
+	char *p, *sys, *name;
 	int err;
-	size_t i;
+	size_t i, off;
 
 	for (i = 0; i < nr_assocs; i++) {
-		err = trace_event__id(assocs[i].name);
+		err = -ENOENT;
+		p = strchr(assocs[i].name, ':');
+		if (!p)
+			goto out;
+		off = p - assocs[i].name;
+		sys = malloc(off + 1);
+		memcpy(sys, assocs[i].name, off);
+		sys[off] = '\0';
+		name = p + 1;
+		event = trace_find_event_by_name(sys, name);
+		err = event ? event->id : trace_event__id(assocs[i].name);
+		free(sys);
 		if (err < 0)
 			goto out;
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index df2fddb..44cbb40 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -176,6 +176,10 @@ struct event_format *trace_find_event(int type)
 	return pevent_find_event(pevent, type);
 }
 
+struct event_format *trace_find_event_by_name(const char *sys, const char *name)
+{
+	return pevent_find_event_by_name(pevent, sys, name);
+}
 
 void print_trace_event(int cpu, void *data, int size)
 {
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 639852a..66f83a0 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -40,6 +40,7 @@ int parse_event_file(char *buf, unsigned long size, char *sys);
 
 struct pevent_record *trace_peek_data(int cpu);
 struct event_format *trace_find_event(int type);
+struct event_format *trace_find_event_by_name(const char *sys, const char *name);
 
 unsigned long long
 raw_field_value(struct event_format *event, const char *name, void *data);
-- 
1.7.7.6

