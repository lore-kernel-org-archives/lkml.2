Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab2I1Q2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:28:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41838 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab2I1Q2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:28:01 -0400
Date: Fri, 28 Sep 2012 09:27:32 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-qa67ikv2sm49cwa7dyjhhp6g@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Know if byte swap is needed
Git-Commit-ID: 0807d2d8a381f4fc600ad481c3e77e5cdb624eed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 09:27:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0807d2d8a381f4fc600ad481c3e77e5cdb624eed
Gitweb:     http://git.kernel.org/tip/0807d2d8a381f4fc600ad481c3e77e5cdb624eed
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 26 Sep 2012 12:48:18 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 26 Sep 2012 12:48:18 -0300

perf evsel: Know if byte swap is needed

Instead of passing it around for parsing as an explicit parameter, will
help with reading tracepoint fields when not using a perf session or
pevent structure, i.e. for non perf.data centered workflows.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-qa67ikv2sm49cwa7dyjhhp6g@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    4 ++--
 tools/perf/builtin-top.c  |    2 +-
 tools/perf/util/evlist.c  |    4 ++--
 tools/perf/util/evlist.h  |    2 +-
 tools/perf/util/evsel.c   |   13 ++++++++-----
 tools/perf/util/evsel.h   |    3 ++-
 tools/perf/util/header.c  |    6 +++++-
 tools/perf/util/python.c  |    2 +-
 tools/perf/util/session.c |    6 ++----
 9 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 78b47a7..2fd2c03 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -564,7 +564,7 @@ static int test__basic_mmap(void)
 			goto out_munmap;
 		}
 
-		err = perf_evlist__parse_sample(evlist, event, &sample, false);
+		err = perf_evlist__parse_sample(evlist, event, &sample);
 		if (err) {
 			pr_err("Can't parse sample, err = %d\n", err);
 			goto out_munmap;
@@ -781,7 +781,7 @@ static int test__PERF_RECORD(void)
 				if (type < PERF_RECORD_MAX)
 					nr_events[type]++;
 
-				err = perf_evlist__parse_sample(evlist, event, &sample, false);
+				err = perf_evlist__parse_sample(evlist, event, &sample);
 				if (err < 0) {
 					if (verbose)
 						perf_event__fprintf(event, stderr);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5550754..e434a16 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -823,7 +823,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 	int ret;
 
 	while ((event = perf_evlist__mmap_read(top->evlist, idx)) != NULL) {
-		ret = perf_evlist__parse_sample(top->evlist, event, &sample, false);
+		ret = perf_evlist__parse_sample(top->evlist, event, &sample);
 		if (ret) {
 			pr_err("Can't parse sample, err = %d\n", ret);
 			continue;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 27f6de3..704bd91 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -884,10 +884,10 @@ int perf_evlist__start_workload(struct perf_evlist *evlist)
 }
 
 int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
-			      struct perf_sample *sample, bool swapped)
+			      struct perf_sample *sample)
 {
 	struct perf_evsel *evsel = perf_evlist__first(evlist);
-	return perf_evsel__parse_sample(evsel, event, sample, swapped);
+	return perf_evsel__parse_sample(evsel, event, sample);
 }
 
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 3f2e1e4..008a957 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -125,7 +125,7 @@ bool perf_evlist__sample_id_all(struct perf_evlist *evlist);
 u16 perf_evlist__id_hdr_size(struct perf_evlist *evlist);
 
 int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
-			      struct perf_sample *sample, bool swapped);
+			      struct perf_sample *sample);
 
 bool perf_evlist__valid_sample_type(struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(struct perf_evlist *evlist);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2467eaf..fe9581b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -767,11 +767,13 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads);
 }
 
-static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
-				       struct perf_sample *sample,
-				       bool swapped)
+static int perf_evsel__parse_id_sample(const struct perf_evsel *evsel,
+				       const union perf_event *event,
+				       struct perf_sample *sample)
 {
+	u64 type = evsel->attr.sample_type;
 	const u64 *array = event->sample.array;
+	bool swapped = evsel->needs_swap;
 	union u64_swap u;
 
 	array += ((event->header.size -
@@ -832,10 +834,11 @@ static bool sample_overlap(const union perf_event *event,
 }
 
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
-			     struct perf_sample *data, bool swapped)
+			     struct perf_sample *data)
 {
 	u64 type = evsel->attr.sample_type;
 	u64 regs_user = evsel->attr.sample_regs_user;
+	bool swapped = evsel->needs_swap;
 	const u64 *array;
 
 	/*
@@ -852,7 +855,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!evsel->attr.sample_id_all)
 			return 0;
-		return perf_event__parse_id_sample(event, type, data, swapped);
+		return perf_evsel__parse_id_sample(evsel, event, data);
 	}
 
 	array = event->sample.array;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index bb445d1..60d2885 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -69,6 +69,7 @@ struct perf_evsel {
 	struct cpu_map		*cpus;
 	unsigned int		sample_size;
 	bool 			supported;
+	bool 			needs_swap;
 	/* parse modifier helper */
 	int			exclude_GH;
 	struct perf_evsel	*leader;
@@ -205,7 +206,7 @@ static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
 void hists__init(struct hists *hists);
 
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
-			     struct perf_sample *sample, bool swapped);
+			     struct perf_sample *sample);
 
 static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6aae329..7daad23 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1256,8 +1256,10 @@ read_event_desc(struct perf_header *ph, int fd)
 		if (ret != (ssize_t)sizeof(nr))
 			goto error;
 
-		if (ph->needs_swap)
+		if (ph->needs_swap) {
 			nr = bswap_32(nr);
+			evsel->needs_swap = true;
+		}
 
 		evsel->name = do_read_string(fd, ph);
 
@@ -2626,6 +2628,8 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 		if (evsel == NULL)
 			goto out_delete_evlist;
+
+		evsel->needs_swap = header->needs_swap;
 		/*
 		 * Do it before so that if perf_evsel__alloc_id fails, this
 		 * entry gets purged too at perf_evlist__delete().
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index ca85444..9181bf2 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -805,7 +805,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		if (pyevent == NULL)
 			return PyErr_NoMemory();
 
-		err = perf_evlist__parse_sample(evlist, event, &pevent->sample, false);
+		err = perf_evlist__parse_sample(evlist, event, &pevent->sample);
 		if (err)
 			return PyErr_Format(PyExc_OSError,
 					    "perf: can't parse sample, err=%d", err);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3049b0a..8cdd232 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -722,8 +722,7 @@ static int flush_sample_queue(struct perf_session *s,
 		if (iter->timestamp > limit)
 			break;
 
-		ret = perf_evlist__parse_sample(s->evlist, iter->event, &sample,
-						s->header.needs_swap);
+		ret = perf_evlist__parse_sample(s->evlist, iter->event, &sample);
 		if (ret)
 			pr_err("Can't parse sample, err = %d\n", ret);
 		else {
@@ -1174,8 +1173,7 @@ static int perf_session__process_event(struct perf_session *session,
 	/*
 	 * For all kernel events we get the sample data
 	 */
-	ret = perf_evlist__parse_sample(session->evlist, event, &sample,
-					session->header.needs_swap);
+	ret = perf_evlist__parse_sample(session->evlist, event, &sample);
 	if (ret)
 		return ret;
 
