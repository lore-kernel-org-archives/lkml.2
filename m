Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2HCOBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:01:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48838 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2HCOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:01:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/18] perf evsel: Adopt parse_sample method from perf_event
Date: Fri,  3 Aug 2012 11:01:01 -0300
Message-Id: <1344002470-5965-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344002470-5965-1-git-send-email-acme@infradead.org>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since we need evsel->{attr.{sample_{id_all,type}},sample_size},
reducing the number of parameters tools have to pass.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-wdtmgak0ihgsmw1brb54a8h4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h  |    3 ---
 tools/perf/util/evlist.c |    6 ++----
 tools/perf/util/evlist.h |    3 +--
 tools/perf/util/evsel.c  |   12 ++++++------
 tools/perf/util/evsel.h  |    2 ++
 5 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1b19728..d84870b 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -197,9 +197,6 @@ int perf_event__preprocess_sample(const union perf_event *self,
 
 const char *perf_event__name(unsigned int id);
 
-int perf_event__parse_sample(const union perf_event *event, u64 type,
-			     int sample_size, bool sample_id_all,
-			     struct perf_sample *sample, bool swapped);
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  const struct perf_sample *sample,
 				  bool swapped);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1a560e0..9b38681 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -882,11 +882,9 @@ int perf_evlist__start_workload(struct perf_evlist *evlist)
 	return 0;
 }
 
-int perf_evlist__parse_sample(struct perf_evlist *evlist,
-			      const union perf_event *event,
+int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
 			      struct perf_sample *sample, bool swapped)
 {
 	struct perf_evsel *e = list_entry(evlist->entries.next, struct perf_evsel, node);
-	return perf_event__parse_sample(event, e->attr.sample_type, e->sample_size,
-					e->attr.sample_id_all, sample, swapped);
+	return perf_evsel__parse_sample(e, event, sample, swapped);
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index a5a4911..528c1ac 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -122,8 +122,7 @@ u64 perf_evlist__sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__sample_id_all(const const struct perf_evlist *evlist);
 u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
 
-int perf_evlist__parse_sample(struct perf_evlist *evlist,
-			      const union perf_event *event,
+int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *event,
 			      struct perf_sample *sample, bool swapped);
 
 bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8feec40..2eaae14 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -729,10 +729,10 @@ static bool sample_overlap(const union perf_event *event,
 	return false;
 }
 
-int perf_event__parse_sample(const union perf_event *event, u64 type,
-			     int sample_size, bool sample_id_all,
+int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *data, bool swapped)
 {
+	u64 type = evsel->attr.sample_type;
 	const u64 *array;
 
 	/*
@@ -747,14 +747,14 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	data->period = 1;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
-		if (!sample_id_all)
+		if (!evsel->attr.sample_id_all)
 			return 0;
 		return perf_event__parse_id_sample(event, type, data, swapped);
 	}
 
 	array = event->sample.array;
 
-	if (sample_size + sizeof(event->header) > event->header.size)
+	if (evsel->sample_size + sizeof(event->header) > event->header.size)
 		return -EFAULT;
 
 	if (type & PERF_SAMPLE_IP) {
@@ -896,7 +896,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		u.val32[1] = sample->tid;
 		if (swapped) {
 			/*
-			 * Inverse of what is done in perf_event__parse_sample
+			 * Inverse of what is done in perf_evsel__parse_sample
 			 */
 			u.val32[0] = bswap_32(u.val32[0]);
 			u.val32[1] = bswap_32(u.val32[1]);
@@ -931,7 +931,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		u.val32[0] = sample->cpu;
 		if (swapped) {
 			/*
-			 * Inverse of what is done in perf_event__parse_sample
+			 * Inverse of what is done in perf_evsel__parse_sample
 			 */
 			u.val32[0] = bswap_32(u.val32[0]);
 			u.val64 = bswap_64(u.val64);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 894bd77..b559929 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -180,4 +180,6 @@ static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
 
 void hists__init(struct hists *hists);
 
+int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
+			     struct perf_sample *sample, bool swapped);
 #endif /* __PERF_EVSEL_H */
-- 
1.7.1

