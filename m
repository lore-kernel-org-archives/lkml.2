Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1AYRZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:25:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1AYRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 28/29] perf tools: Move event__parse_sample to evsel.c
Date: Tue, 25 Jan 2011 15:21:51 -0200
Message-Id: <1295976112-2796-29-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To avoid linking more stuff in the python binding I'm working on, future
csets will make the sample type be taken from the evsel itself, but for
that we need to first have one file per cpu and per sample_type, not a
single perf.data file.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   11 +----
 tools/perf/builtin-top.c  |    2 +-
 tools/perf/util/event.c   |  125 ---------------------------------------------
 tools/perf/util/event.h   |    5 +-
 tools/perf/util/evsel.c   |  118 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.c |    4 +-
 tools/perf/util/session.h |    9 +++
 7 files changed, 134 insertions(+), 140 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index dc91ee0..231e3e2 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -10,7 +10,6 @@
 #include "util/evlist.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
-#include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread_map.h"
 
@@ -457,7 +456,6 @@ static int test__basic_mmap(void)
 	int err = -1;
 	event_t *event;
 	struct thread_map *threads;
-	struct perf_session session;
 	struct cpu_map *cpus;
 	struct perf_evlist *evlist;
 	struct perf_event_attr attr = {
@@ -521,13 +519,6 @@ static int test__basic_mmap(void)
 	attr.wakeup_events = 1;
 	attr.sample_period = 1;
 
-	/*
- 	 * FIXME: use evsel->attr.sample_type in event__parse_sample.
- 	 * 	  This will nicely remove the requirement that we have
- 	 * 	  all the events with the same sample_type.
- 	 */
-	session.sample_type = attr.sample_type;
-
 	for (i = 0; i < nsyscalls; ++i) {
 		attr.config = ids[i];
 		evsels[i] = perf_evsel__new(&attr, i);
@@ -567,7 +558,7 @@ static int test__basic_mmap(void)
 			goto out_munmap;
 		}
 
-		event__parse_sample(event, &session, &sample);
+		event__parse_sample(event, attr.sample_type, false, &sample);
 		evsel = perf_evlist__id2evsel(evlist, sample.id);
 		if (evsel == NULL) {
 			pr_debug("event with id %" PRIu64
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d0b16d9..ce2e50c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1106,7 +1106,7 @@ static void perf_session__mmap_read_cpu(struct perf_session *self, int cpu)
 	event_t *event;
 
 	while ((event = perf_evlist__read_on_cpu(evsel_list, cpu)) != NULL) {
-		event__parse_sample(event, self, &sample);
+		perf_session__parse_sample(self, event, &sample);
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
 			event__process_sample(event, &sample, self);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1478ab4..e4db8b8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -826,128 +826,3 @@ out_filtered:
 	al->filtered = true;
 	return 0;
 }
-
-static int event__parse_id_sample(const event_t *event,
-				  struct perf_session *session,
-				  struct sample_data *sample)
-{
-	const u64 *array;
-	u64 type;
-
-	sample->cpu = sample->pid = sample->tid = -1;
-	sample->stream_id = sample->id = sample->time = -1ULL;
-
-	if (!session->sample_id_all)
-		return 0;
-
-	array = event->sample.array;
-	array += ((event->header.size -
-		   sizeof(event->header)) / sizeof(u64)) - 1;
-	type = session->sample_type;
-
-	if (type & PERF_SAMPLE_CPU) {
-		u32 *p = (u32 *)array;
-		sample->cpu = *p;
-		array--;
-	}
-
-	if (type & PERF_SAMPLE_STREAM_ID) {
-		sample->stream_id = *array;
-		array--;
-	}
-
-	if (type & PERF_SAMPLE_ID) {
-		sample->id = *array;
-		array--;
-	}
-
-	if (type & PERF_SAMPLE_TIME) {
-		sample->time = *array;
-		array--;
-	}
-
-	if (type & PERF_SAMPLE_TID) {
-		u32 *p = (u32 *)array;
-		sample->pid = p[0];
-		sample->tid = p[1];
-	}
-
-	return 0;
-}
-
-int event__parse_sample(const event_t *event, struct perf_session *session,
-			struct sample_data *data)
-{
-	const u64 *array;
-	u64 type;
-
-	if (event->header.type != PERF_RECORD_SAMPLE)
-		return event__parse_id_sample(event, session, data);
-
-	array = event->sample.array;
-	type = session->sample_type;
-
-	if (type & PERF_SAMPLE_IP) {
-		data->ip = event->ip.ip;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_TID) {
-		u32 *p = (u32 *)array;
-		data->pid = p[0];
-		data->tid = p[1];
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_TIME) {
-		data->time = *array;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_ADDR) {
-		data->addr = *array;
-		array++;
-	}
-
-	data->id = -1ULL;
-	if (type & PERF_SAMPLE_ID) {
-		data->id = *array;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_STREAM_ID) {
-		data->stream_id = *array;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_CPU) {
-		u32 *p = (u32 *)array;
-		data->cpu = *p;
-		array++;
-	} else
-		data->cpu = -1;
-
-	if (type & PERF_SAMPLE_PERIOD) {
-		data->period = *array;
-		array++;
-	}
-
-	if (type & PERF_SAMPLE_READ) {
-		pr_debug("PERF_SAMPLE_READ is unsuported for now\n");
-		return -1;
-	}
-
-	if (type & PERF_SAMPLE_CALLCHAIN) {
-		data->callchain = (struct ip_callchain *)array;
-		array += 1 + data->callchain->nr;
-	}
-
-	if (type & PERF_SAMPLE_RAW) {
-		u32 *p = (u32 *)array;
-		data->raw_size = *p;
-		p++;
-		data->raw_data = p;
-	}
-
-	return 0;
-}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 2b7e919..d79e4ed 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -169,9 +169,10 @@ struct addr_location;
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
 			     struct addr_location *al, struct sample_data *data,
 			     symbol_filter_t filter);
-int event__parse_sample(const event_t *event, struct perf_session *session,
-			struct sample_data *sample);
 
 const char *event__get_event_name(unsigned int id);
 
+int event__parse_sample(const event_t *event, u64 type, bool sample_id_all,
+			struct sample_data *sample);
+
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9a6d942..a85ae12 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -355,3 +355,121 @@ out_unmap:
 	}
 	return -1;
 }
+
+static int event__parse_id_sample(const event_t *event, u64 type,
+				  struct sample_data *sample)
+{
+	const u64 *array = event->sample.array;
+
+	array += ((event->header.size -
+		   sizeof(event->header)) / sizeof(u64)) - 1;
+
+	if (type & PERF_SAMPLE_CPU) {
+		u32 *p = (u32 *)array;
+		sample->cpu = *p;
+		array--;
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		sample->stream_id = *array;
+		array--;
+	}
+
+	if (type & PERF_SAMPLE_ID) {
+		sample->id = *array;
+		array--;
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		sample->time = *array;
+		array--;
+	}
+
+	if (type & PERF_SAMPLE_TID) {
+		u32 *p = (u32 *)array;
+		sample->pid = p[0];
+		sample->tid = p[1];
+	}
+
+	return 0;
+}
+
+int event__parse_sample(const event_t *event, u64 type, bool sample_id_all,
+			struct sample_data *data)
+{
+	const u64 *array;
+
+	data->cpu = data->pid = data->tid = -1;
+	data->stream_id = data->id = data->time = -1ULL;
+
+	if (event->header.type != PERF_RECORD_SAMPLE) {
+		if (!sample_id_all)
+			return 0;
+		return event__parse_id_sample(event, type, data);
+	}
+
+	array = event->sample.array;
+
+	if (type & PERF_SAMPLE_IP) {
+		data->ip = event->ip.ip;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TID) {
+		u32 *p = (u32 *)array;
+		data->pid = p[0];
+		data->tid = p[1];
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_TIME) {
+		data->time = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_ADDR) {
+		data->addr = *array;
+		array++;
+	}
+
+	data->id = -1ULL;
+	if (type & PERF_SAMPLE_ID) {
+		data->id = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_STREAM_ID) {
+		data->stream_id = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_CPU) {
+		u32 *p = (u32 *)array;
+		data->cpu = *p;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_PERIOD) {
+		data->period = *array;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_READ) {
+		fprintf(stderr, "PERF_SAMPLE_READ is unsuported for now\n");
+		return -1;
+	}
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		data->callchain = (struct ip_callchain *)array;
+		array += 1 + data->callchain->nr;
+	}
+
+	if (type & PERF_SAMPLE_RAW) {
+		u32 *p = (u32 *)array;
+		data->raw_size = *p;
+		p++;
+		data->raw_data = p;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b58a48a..e6a0740 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -496,7 +496,7 @@ static void flush_sample_queue(struct perf_session *s,
 		if (iter->timestamp > limit)
 			break;
 
-		event__parse_sample(iter->event, s, &sample);
+		perf_session__parse_sample(s, iter->event, &sample);
 		perf_session_deliver_event(s, iter->event, &sample, ops,
 					   iter->file_offset);
 
@@ -806,7 +806,7 @@ static int perf_session__process_event(struct perf_session *session,
 	/*
 	 * For all kernel events we get the sample data
 	 */
-	event__parse_sample(event, session, &sample);
+	perf_session__parse_sample(session, event, &sample);
 
 	/* Preprocess sample records - precheck callchains */
 	if (perf_session__preprocess_sample(session, event, &sample))
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index e815468..7823976 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -155,4 +155,13 @@ size_t perf_session__fprintf_nr_events(struct perf_session *self, FILE *fp)
 {
 	return hists__fprintf_nr_events(&self->hists, fp);
 }
+
+static inline int perf_session__parse_sample(struct perf_session *session,
+					     const event_t *event,
+					     struct sample_data *sample)
+{
+	return event__parse_sample(event, session->sample_type,
+				   session->sample_id_all, sample);
+}
+
 #endif /* __PERF_SESSION_H */
-- 
1.6.2.5

