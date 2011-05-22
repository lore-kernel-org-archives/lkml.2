Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1EVBqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 21:46:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54688 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1EVBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 21:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UwPALQ5bZwF+nIlYrAvdwh/bIhpbSxULhnDW8B20aa2lnH2dMkW/29dsijj3eqB1do
         L0KRoXkG41N0yYdfxyKnolhqqhoRLPYVJMfXJFuoa9iaH7pO73iYGKvzMyBm66LG85X9
         yHTAeX0gQQIEfbHLl42sJNznl6YLXac6p6JcE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/6] perf tools: Propagate event parse error handling
Date: Sun, 22 May 2011 03:45:44 +0200
Message-Id: <1306028744-10603-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
References: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better handle event parsing error by propagating the details
in upper layers or by dumping some failure message. So that
the user knows he has some crazy events in the batch.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-test.c |    9 +++++++--
 tools/perf/builtin-top.c  |    7 ++++++-
 tools/perf/util/python.c  |   14 ++++++++++----
 tools/perf/util/session.c |   14 ++++++++++----
 4 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 44d7df2..1fa9f58 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -559,8 +559,13 @@ static int test__basic_mmap(void)
 			goto out_munmap;
 		}
 
-		perf_event__parse_sample(event, attr.sample_type, sample_size,
-					 false, &sample);
+		err = perf_event__parse_sample(event, attr.sample_type, sample_size,
+					       false, &sample);
+		if (err) {
+			pr_err("Can't parse sample, err = %d\n", err);
+			goto out_munmap;
+		}
+
 		evsel = perf_evlist__id2evsel(evlist, sample.id);
 		if (evsel == NULL) {
 			pr_debug("event with id %" PRIu64
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7e3d6e3..74f533c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -805,9 +805,14 @@ static void perf_session__mmap_read_cpu(struct perf_session *self, int cpu)
 {
 	struct perf_sample sample;
 	union perf_event *event;
+	int ret;
 
 	while ((event = perf_evlist__read_on_cpu(top.evlist, cpu)) != NULL) {
-		perf_session__parse_sample(self, event, &sample);
+		ret = perf_session__parse_sample(self, event, &sample);
+		if (ret) {
+			pr_err("Can't parse sample, err = %d\n", ret);
+			continue;
+		}
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
 			perf_event__process_sample(event, &sample, self);
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 4174c09..3344d6e 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -675,6 +675,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	union perf_event *event;
 	int sample_id_all = 1, cpu;
 	static char *kwlist[] = {"sample_id_all", NULL, NULL};
+	int err;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "i|i", kwlist,
 					 &cpu, &sample_id_all))
@@ -690,12 +691,17 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 			return PyErr_NoMemory();
 
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
-		perf_event__parse_sample(event, first->attr.sample_type,
-					 perf_sample_size(first->attr.sample_type),
-					 sample_id_all, &pevent->sample);
+		err = perf_event__parse_sample(event, first->attr.sample_type,
+					       perf_sample_size(first->attr.sample_type),
+					       sample_id_all, &pevent->sample);
+		if (err) {
+			pr_err("Can't parse sample, err = %d\n", err);
+			goto end;
+		}
+
 		return pyevent;
 	}
-
+end:
 	Py_INCREF(Py_None);
 	return Py_None;
 }
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8940fd8..948327d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -480,6 +480,7 @@ static void flush_sample_queue(struct perf_session *s,
 	struct perf_sample sample;
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
+	int ret;
 
 	if (!ops->ordered_samples || !limit)
 		return;
@@ -488,9 +489,12 @@ static void flush_sample_queue(struct perf_session *s,
 		if (iter->timestamp > limit)
 			break;
 
-		perf_session__parse_sample(s, iter->event, &sample);
-		perf_session_deliver_event(s, iter->event, &sample, ops,
-					   iter->file_offset);
+		ret = perf_session__parse_sample(s, iter->event, &sample);
+		if (ret)
+			pr_err("Can't parse sample, err = %d\n", ret);
+		else
+			perf_session_deliver_event(s, iter->event, &sample, ops,
+						   iter->file_offset);
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -806,7 +810,9 @@ static int perf_session__process_event(struct perf_session *session,
 	/*
 	 * For all kernel events we get the sample data
 	 */
-	perf_session__parse_sample(session, event, &sample);
+	ret = perf_session__parse_sample(session, event, &sample);
+	if (ret)
+		return ret;
 
 	/* Preprocess sample records - precheck callchains */
 	if (perf_session__preprocess_sample(session, event, &sample))
-- 
1.7.3.2

