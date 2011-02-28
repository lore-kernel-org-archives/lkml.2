Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1B1Dxc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:53:32 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:20613 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1B1Dw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:52:26 -0500
X-IronPort-AV: E=Sophos;i="4.62,237,1297036800"; 
   d="scan'208";a="266102173"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 2/6] perf events: plumbing for PERF_SAMPLE_READ and read_format
Date: Sun, 27 Feb 2011 20:52:27 -0700
Message-Id: <1298865151-23656-3-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298865151-23656-1-git-send-email-daahern@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-record.c |    5 +++++
 tools/perf/builtin-test.c   |    3 ++-
 tools/perf/util/event.h     |   10 +++++++++-
 tools/perf/util/evsel.c     |   24 +++++++++++++++++++++---
 tools/perf/util/header.c    |   18 ++++++++++++++++++
 tools/perf/util/header.h    |    1 +
 tools/perf/util/python.c    |    3 ++-
 tools/perf/util/session.c   |   12 ++++++++++++
 tools/perf/util/session.h   |    6 +++++-
 9 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index db4cd1e..e39883e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -41,6 +41,7 @@ enum write_mode_t {
 static u64			user_interval			= ULLONG_MAX;
 static u64			default_interval		=      0;
 static u64			sample_type;
+static u64			read_format;
 
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
@@ -218,6 +219,9 @@ static void create_counter(struct perf_evsel *evsel, int cpu)
 
 	if (!sample_type)
 		sample_type = attr->sample_type;
+
+	if (!read_format)
+		read_format = attr->read_format;
 }
 
 static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
@@ -595,6 +599,7 @@ static int __cmd_record(int argc, const char **argv)
 	open_counters(evsel_list);
 
 	perf_session__set_sample_type(session, sample_type);
+	perf_session__set_read_format(session, read_format);
 
 	/*
 	 * perf_session__delete(session) will be called at atexit_header()
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1b2106c..a243d51 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -558,7 +558,8 @@ static int test__basic_mmap(void)
 			goto out_munmap;
 		}
 
-		perf_event__parse_sample(event, attr.sample_type, false, &sample);
+		perf_event__parse_sample(event, attr.sample_type,
+				  attr.read_format, false, &sample);
 		evsel = perf_evlist__id2evsel(evlist, sample.id);
 		if (evsel == NULL) {
 			pr_debug("event with id %" PRIu64
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 9c35170..512a1ca 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -61,6 +61,13 @@ struct sample_event {
 	u64 array[];
 };
 
+struct read_format {
+	u64     value;
+	u64     time_enabled;
+	u64     time_running;
+	u64     id;
+};
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
@@ -69,6 +76,7 @@ struct perf_sample {
 	u64 id;
 	u64 stream_id;
 	u64 period;
+	struct read_format values;
 	u32 cpu;
 	u32 raw_size;
 	void *raw_data;
@@ -178,6 +186,6 @@ int perf_event__preprocess_sample(const union perf_event *self,
 const char *perf_event__name(unsigned int id);
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
-			     bool sample_id_all, struct perf_sample *sample);
+			     u64 read_format, bool sample_id_all, struct perf_sample *sample);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8083d51..98c8471 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -304,7 +304,7 @@ static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
 }
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
-			     bool sample_id_all, struct perf_sample *data)
+			     u64 read_format, bool sample_id_all, struct perf_sample *data)
 {
 	const u64 *array;
 
@@ -364,8 +364,26 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_READ) {
-		fprintf(stderr, "PERF_SAMPLE_READ is unsuported for now\n");
-		return -1;
+		if (read_format & PERF_FORMAT_GROUP) {
+			printf("READ_FORMAT_GROUP is unsuported for now\n");
+			return -1;
+		} else {
+			data->values.value = *array;
+			array++;
+
+			if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+				data->values.time_enabled = *array;
+				array++;
+			}
+			if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+				data->values.time_running = *array;
+				array++;
+			}
+			if (read_format & PERF_FORMAT_ID) {
+				data->values.id = *array;
+				array++;
+			}
+		}
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 72c124d..f48b0b1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -951,6 +951,23 @@ u64 perf_header__sample_type(struct perf_header *header)
 	return type;
 }
 
+u64 perf_header__read_format(struct perf_header *header)
+{
+	u64 read_format = 0;
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+
+		if (!read_format)
+			read_format = attr->attr.read_format;
+		else if (read_format != attr->attr.read_format)
+			die("non matching read_format");
+	}
+
+	return read_format;
+}
+
 bool perf_header__sample_id_all(const struct perf_header *header)
 {
 	bool value = false, first = true;
@@ -1079,6 +1096,7 @@ int perf_event__process_attr(union perf_event *event,
 	}
 
 	perf_session__update_sample_type(session);
+	perf_session__update_read_format(session);
 
 	return 0;
 }
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index f042ceb..5d89e7f 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -84,6 +84,7 @@ void perf_header_attr__delete(struct perf_header_attr *self);
 int perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
 
 u64 perf_header__sample_type(struct perf_header *header);
+u64 perf_header__read_format(struct perf_header *header);
 bool perf_header__sample_id_all(const struct perf_header *header);
 struct perf_event_attr *
 perf_header__find_attr(u64 id, struct perf_header *header);
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 5317ef2..b67c25f 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -684,7 +684,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 			return PyErr_NoMemory();
 
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
-		perf_event__parse_sample(event, first->attr.sample_type, sample_id_all,
+		perf_event__parse_sample(event, first->attr.sample_type,
+					 first->attr.read_format, sample_id_all,
 					 &pevent->sample);
 		return pyevent;
 	}
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index a3a871f..dc0235b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -110,6 +110,17 @@ void perf_session__update_sample_type(struct perf_session *self)
 	perf_session__id_header_size(self);
 }
 
+void perf_session__set_read_format(struct perf_session *session,
+		   	u64 read_format)
+{
+	session->read_format = read_format;
+}
+
+void perf_session__update_read_format(struct perf_session *self)
+{
+	self->read_format = perf_header__read_format(&self->header);
+}
+
 int perf_session__create_kernel_maps(struct perf_session *self)
 {
 	int ret = machine__create_kernel_maps(&self->host_machine);
@@ -172,6 +183,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	}
 
 	perf_session__update_sample_type(self);
+	perf_session__update_read_format(self);
 
 	if (ops && ops->ordering_requires_timestamps &&
 	    ops->ordered_samples && !self->sample_id_all) {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 977b3a1..212f810 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -43,6 +43,7 @@ struct perf_session {
 	 */
 	struct hists		hists;
 	u64			sample_type;
+	u64			read_format;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
@@ -115,6 +116,8 @@ void perf_session__update_sample_type(struct perf_session *self);
 void perf_session__set_sample_id_all(struct perf_session *session, bool value);
 void perf_session__set_sample_type(struct perf_session *session, u64 type);
 void perf_session__remove_thread(struct perf_session *self, struct thread *th);
+void perf_session__set_read_format(struct perf_session *session, u64 read_format);
+void perf_session__update_read_format(struct perf_session *self);
 
 static inline
 struct machine *perf_session__find_host_machine(struct perf_session *self)
@@ -162,7 +165,8 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					     struct perf_sample *sample)
 {
 	return perf_event__parse_sample(event, session->sample_type,
-					session->sample_id_all, sample);
+					session->read_format, session->sample_id_all,
+					sample);
 }
 
 #endif /* __PERF_SESSION_H */
-- 
1.7.4

