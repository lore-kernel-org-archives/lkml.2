Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2DDVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:16:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab2DDVQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:56 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/8] perf, tool: Add support for parsing PERF_SAMPLE_READ
Date: Wed,  4 Apr 2012 23:16:15 +0200
Message-Id: <1333574176-11388-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse out the PERF_SAMPLE_READ sample bits.
The code contains both single and group format specification.

this code parse out and prepare prepare PERF_SAMPLE_READ data
into the perf_sample struct. It will be used for group leader
sampling feature comming in shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c |    4 ++--
 tools/perf/util/event.h   |   21 ++++++++++++++++++++-
 tools/perf/util/evlist.c  |   22 ++++++++++++++++++++++
 tools/perf/util/evlist.h  |    2 ++
 tools/perf/util/evsel.c   |   30 +++++++++++++++++++++++++++---
 tools/perf/util/python.c  |    3 ++-
 tools/perf/util/session.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |    5 ++++-
 8 files changed, 121 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index c19d2d7..7acc689 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -564,7 +564,7 @@ static int test__basic_mmap(void)
 		}
 
 		err = perf_event__parse_sample(event, attr.sample_type, sample_size,
-					       false, &sample, false);
+					       false, 0, &sample, false);
 		if (err) {
 			pr_err("Can't parse sample, err = %d\n", err);
 			goto out_munmap;
@@ -786,7 +786,7 @@ static int test__PERF_RECORD(void)
 					nr_events[type]++;
 
 				err = perf_event__parse_sample(event, sample_type,
-							       sample_size, true,
+							       sample_size, true, 0,
 							       &sample, false);
 				if (err < 0) {
 					if (verbose)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1b19728..221266a 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -69,6 +69,23 @@ struct sample_event {
 	u64 array[];
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
@@ -82,6 +99,7 @@ struct perf_sample {
 	void *raw_data;
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
+	struct sample_read read;
 };
 
 #define BUILD_ID_SIZE 20
@@ -199,7 +217,8 @@ const char *perf_event__name(unsigned int id);
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *sample, bool swapped);
+			     u64 read_format, struct perf_sample *sample,
+			     bool swapped);
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  const struct perf_sample *sample,
 				  bool swapped);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0ffae44..bd48bb3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -693,6 +693,28 @@ u64 perf_evlist__sample_type(const struct perf_evlist *evlist)
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
+u64 perf_evlist__read_format(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.read_format;
+}
+
 u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist)
 {
 	struct perf_evsel *first;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 863789a..c2fe77b 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -111,12 +111,14 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, const char *target_pid,
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__set_filters(struct perf_evlist *evlist);
 
+u64 perf_evlist__read_format(const const struct perf_evlist *evlist);
 u64 perf_evlist__sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(const const struct perf_evlist *evlist);
 u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
 
 bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
+bool perf_evlist__valid_read_format(const struct perf_evlist *evlist);
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 445ba60..42f5256 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -465,7 +465,8 @@ static bool sample_overlap(const union perf_event *event,
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *data, bool swapped)
+			     u64 read_format, struct perf_sample *data,
+			     bool swapped)
 {
 	const u64 *array;
 
@@ -554,8 +555,31 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_READ) {
-		fprintf(stderr, "PERF_SAMPLE_READ is unsupported for now\n");
-		return -1;
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
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 419c29e..477f9a8 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -807,7 +807,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
 		err = perf_event__parse_sample(event, first->attr.sample_type,
 					       perf_evsel__sample_size(first),
-					       sample_id_all, &pevent->sample, false);
+					       sample_id_all, first->attr.read_format,
+					       &pevent->sample, false);
 		if (err)
 			return PyErr_Format(PyExc_OSError,
 					    "perf: can't parse sample, err=%d", err);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9412e3b..b64f017 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -70,6 +70,11 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
+	if (!perf_evlist__valid_read_format(self->evlist)) {
+		pr_err("non matching read_format");
+		goto out_close;
+	}
+
 	self->size = input_stat.st_size;
 	return 0;
 
@@ -86,6 +91,7 @@ void perf_session__update_sample_type(struct perf_session *self)
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
 	self->host_machine.id_hdr_size = self->id_hdr_size;
+	self->read_format = perf_evlist__read_format(self->evlist);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
@@ -785,6 +791,39 @@ static void perf_session__print_tstamp(struct perf_session *session,
 		printf("%" PRIu64 " ", sample->time);
 }
 
+static void sample_read__printf(struct perf_session *session,
+				struct perf_sample *sample)
+{
+	u64 read_format = session->read_format;
+
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
@@ -818,6 +857,9 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 
 	if (session->sample_type & PERF_SAMPLE_BRANCH_STACK)
 		branch_stack__printf(sample);
+
+	if (session->sample_type & PERF_SAMPLE_READ)
+		sample_read__printf(session, sample);
 }
 
 static struct machine *
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7a5434c..8d2ea3c 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -42,6 +42,7 @@ struct perf_session {
 	struct hists		hists;
 	u64			sample_type;
 	int			sample_size;
+	u64			read_format;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
@@ -134,7 +135,9 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 {
 	return perf_event__parse_sample(event, session->sample_type,
 					session->sample_size,
-					session->sample_id_all, sample,
+					session->sample_id_all,
+					session->read_format,
+					sample,
 					session->header.needs_swap);
 }
 
-- 
1.7.7.6

