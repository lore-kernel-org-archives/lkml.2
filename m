Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2JTOdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab2JTOdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:33:44 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 04/11] perf tool: Add support for parsing PERF_SAMPLE_READ sample type
Date: Sat, 20 Oct 2012 16:33:12 +0200
Message-Id: <1350743599-4805-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse out the PERF_SAMPLE_READ sample bits.
The code contains both single and group format specification.

This code parse out and prepare prepare PERF_SAMPLE_READ data
into the perf_sample struct. It will be used for group leader
sampling feature comming in shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/event.h   | 18 ++++++++++++++++++
 tools/perf/util/evlist.c  | 20 ++++++++++++++++++++
 tools/perf/util/evlist.h  |  2 ++
 tools/perf/util/evsel.c   | 29 +++++++++++++++++++++++++++--
 tools/perf/util/session.c | 38 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index da97aff..5948d7a 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -79,6 +79,23 @@ struct stack_dump {
 	char *data;
 };
 
+struct sample_read_value {
+	u64 value;
+	u64 id;
+};
+
+struct sample_read {
+	u64 time_enabled;
+	u64 time_running;
+	union {
+		struct {
+			u64 nr;
+			struct sample_read_value *values;
+		} group;
+		struct sample_read_value one;
+	};
+};
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
@@ -94,6 +111,7 @@ struct perf_sample {
 	struct branch_stack *branch_stack;
 	struct regs_dump  user_regs;
 	struct stack_dump user_stack;
+	struct sample_read read;
 };
 
 #define BUILD_ID_SIZE 20
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ef13aab..b1c8f35 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -668,6 +668,26 @@ u64 perf_evlist__sample_type(struct perf_evlist *evlist)
 	return first->attr.sample_type;
 }
 
+bool perf_evlist__valid_read_format(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *pos, *first;
+
+	pos = first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
+	list_for_each_entry_continue(pos, &evlist->entries, node) {
+		if (first->attr.read_format != pos->attr.read_format)
+			return false;
+	}
+
+	return true;
+}
+
+u64 perf_evlist__read_format(struct perf_evlist *evlist)
+{
+	struct perf_evsel *first = perf_evlist__first(evlist);
+	return first->attr.read_format;
+}
+
 u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist)
 {
 	struct perf_evsel *first = perf_evlist__first(evlist);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index fa76bf9..a6c74bd 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -111,6 +111,7 @@ int perf_evlist__apply_filters(struct perf_evlist *evlist);
 void __perf_evlist__set_leader(struct list_head *list);
 void perf_evlist__set_leader(struct perf_evlist *evlist);
 
+u64 perf_evlist__read_format(struct perf_evlist *evlist);
 u64 perf_evlist__sample_type(struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(struct perf_evlist *evlist);
 u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist);
@@ -120,6 +121,7 @@ int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *even
 
 bool perf_evlist__valid_sample_type(struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(struct perf_evlist *evlist);
+bool perf_evlist__valid_read_format(const struct perf_evlist *evlist);
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 919b4d2..f37bec0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -967,8 +967,33 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_READ) {
-		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
-		return -1;
+		u64 read_format = evsel->attr.read_format;
+
+		if (read_format & PERF_FORMAT_GROUP)
+			data->read.group.nr = *array;
+		else
+			data->read.one.value = *array;
+
+		array++;
+
+		if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+			data->read.time_enabled = *array;
+			array++;
+		}
+
+		if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+			data->read.time_running = *array;
+			array++;
+		}
+
+		if (read_format & PERF_FORMAT_GROUP) {
+			data->read.group.values = (struct sample_read_value *) array;
+			array = (void *) array + data->read.group.nr *
+				sizeof(struct sample_read_value);
+		} else {
+			data->read.one.id = *array;
+			array++;
+		}
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 15abe40..ceb3fe2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -74,6 +74,11 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
+	if (!perf_evlist__valid_read_format(self->evlist)) {
+		pr_err("non matching read_format");
+		goto out_close;
+	}
+
 	self->size = input_stat.st_size;
 	return 0;
 
@@ -963,6 +968,36 @@ static void perf_session__print_tstamp(struct perf_session *session,
 		printf("%" PRIu64 " ", sample->time);
 }
 
+static void sample_read__printf(struct perf_sample *sample, u64 read_format)
+{
+	printf("... sample_read:\n");
+
+	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+		printf("...... time enabled %016" PRIx64 "\n",
+		       sample->read.time_enabled);
+
+	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+		printf("...... time running %016" PRIx64 "\n",
+		       sample->read.time_running);
+
+	if (read_format & PERF_FORMAT_GROUP) {
+		u64 i;
+
+		printf(".... group nr %" PRIu64 "\n", sample->read.group.nr);
+
+		for (i = 0; i < sample->read.group.nr; i++) {
+			struct sample_read_value *value;
+
+			value = &sample->read.group.values[i];
+			printf("..... id %016" PRIx64
+			       ", value %016" PRIx64 "\n",
+			       value->id, value->value);
+		}
+	} else
+		printf("..... id %016" PRIx64 ", value %016" PRIx64 "\n",
+			sample->read.one.id, sample->read.one.value);
+}
+
 static void dump_event(struct perf_session *session, union perf_event *event,
 		       u64 file_offset, struct perf_sample *sample)
 {
@@ -1006,6 +1041,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
+
+	if (sample_type & PERF_SAMPLE_READ)
+		sample_read__printf(sample, evsel->attr.read_format);
 }
 
 static struct machine *
-- 
1.7.11.4

