Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab1EVBqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 21:46:48 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61446 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1EVBqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 21:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s7mCiSn3lYOyoYdJX+hlDBALG7L95EYF94nM8gDVUBpqOgsznGzx647S/WPrgGIV0t
         X00FzIk5jEMxQWVXyw1Uarx4JivmmHfrsrduM+r5Mx7Afa4XVnf7toMFMTWcjf+jd2IM
         amdOOwpscqGpBB92Nd3dh5qz37X0PQgEBRpWE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/6] perf tools: Pre-check sample size before parsing
Date: Sun, 22 May 2011 03:45:42 +0200
Message-Id: <1306028744-10603-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
References: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check that the total size of the sample fields having a fixed
size do not exceed the one of the whole event. This robustifies
the sample parsing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-test.c |    4 +++-
 tools/perf/util/event.c   |   16 ++++++++++++++++
 tools/perf/util/event.h   |   12 +++++++++++-
 tools/perf/util/evsel.c   |    6 +++++-
 tools/perf/util/python.c  |    5 +++--
 tools/perf/util/session.c |    1 +
 tools/perf/util/session.h |    2 ++
 7 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 11e3c84..44d7df2 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -474,6 +474,7 @@ static int test__basic_mmap(void)
 	unsigned int nr_events[nsyscalls],
 		     expected_nr_events[nsyscalls], i, j;
 	struct perf_evsel *evsels[nsyscalls], *evsel;
+	int sample_size = perf_sample_size(attr.sample_type);
 
 	for (i = 0; i < nsyscalls; ++i) {
 		char name[64];
@@ -558,7 +559,8 @@ static int test__basic_mmap(void)
 			goto out_munmap;
 		}
 
-		perf_event__parse_sample(event, attr.sample_type, false, &sample);
+		perf_event__parse_sample(event, attr.sample_type, sample_size,
+					 false, &sample);
 		evsel = perf_evlist__id2evsel(evlist, sample.id);
 		if (evsel == NULL) {
 			pr_debug("event with id %" PRIu64
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1023f67..17c1c3c 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -35,6 +35,22 @@ const char *perf_event__name(unsigned int id)
 	return perf_event__names[id];
 }
 
+int perf_sample_size(u64 sample_type)
+{
+	u64 mask = sample_type & PERF_SAMPLE_MASK;
+	int size = 0;
+	int i;
+
+	for (i = 0; i < 64; i++) {
+		if ((mask << i) & 1)
+			size++;
+	}
+
+	size *= sizeof(u64);
+
+	return size;
+}
+
 static struct perf_sample synth_sample = {
 	.pid	   = -1,
 	.tid	   = -1,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 9c35170..c083328 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -56,6 +56,13 @@ struct read_event {
 	u64 id;
 };
 
+
+#define PERF_SAMPLE_MASK				\
+	(PERF_SAMPLE_IP | PERF_SAMPLE_TID |		\
+	 PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR |		\
+	PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |	\
+	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
+
 struct sample_event {
 	struct perf_event_header        header;
 	u64 array[];
@@ -75,6 +82,8 @@ struct perf_sample {
 	struct ip_callchain *callchain;
 };
 
+int perf_sample_size(u64 sample_type);
+
 #define BUILD_ID_SIZE 20
 
 struct build_id_event {
@@ -178,6 +187,7 @@ int perf_event__preprocess_sample(const union perf_event *self,
 const char *perf_event__name(unsigned int id);
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
-			     bool sample_id_all, struct perf_sample *sample);
+			     int sample_size, bool sample_id_all,
+			     struct perf_sample *sample);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d6fd59b..bfce8bf 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -304,7 +304,8 @@ static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
 }
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
-			     bool sample_id_all, struct perf_sample *data)
+			     int sample_size, bool sample_id_all,
+			     struct perf_sample *data)
 {
 	const u64 *array;
 
@@ -319,6 +320,9 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 
 	array = event->sample.array;
 
+	if (sample_size + sizeof(event->header) > event->header.size)
+		return -EFAULT;
+
 	if (type & PERF_SAMPLE_IP) {
 		data->ip = event->ip.ip;
 		array++;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 8b0eff8..4174c09 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -690,8 +690,9 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 			return PyErr_NoMemory();
 
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
-		perf_event__parse_sample(event, first->attr.sample_type, sample_id_all,
-					 &pevent->sample);
+		perf_event__parse_sample(event, first->attr.sample_type,
+					 perf_sample_size(first->attr.sample_type),
+					 sample_id_all, &pevent->sample);
 		return pyevent;
 	}
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index db65206..8940fd8 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -97,6 +97,7 @@ out:
 void perf_session__update_sample_type(struct perf_session *self)
 {
 	self->sample_type = perf_evlist__sample_type(self->evlist);
+	self->sample_size = perf_sample_size(self->sample_type);
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	perf_session__id_header_size(self);
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8daaa2d..66d4e14 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -43,6 +43,7 @@ struct perf_session {
 	 */
 	struct hists		hists;
 	u64			sample_type;
+	int			sample_size;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
@@ -159,6 +160,7 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					     struct perf_sample *sample)
 {
 	return perf_event__parse_sample(event, session->sample_type,
+					session->sample_size,
 					session->sample_id_all, sample);
 }
 
-- 
1.7.3.2

