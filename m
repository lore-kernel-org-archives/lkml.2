Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2LKWsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:48:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43844 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2LKWsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 28/37] perf evsel: Introduce method to request IDs be used
Date: Tue, 11 Dec 2012 19:48:14 -0300
Message-Id: <1355266103-17238-29-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When mmaping multiple events we need to find the right evsel that
matches an event in the ring buffer.

For that we need to set the PERF_FORMAT_ID bit in
perf_event_attr.read_format so that when we read the event fds we get
that id to then hash it and be able later to use perf_evlist__id2evsel
to find the right evsel.

We also need to set the PERF_SAMPLE_ID bit in
perf_event_attr.sample_type to ask for that id to be stashed in each
sample, so that we can demux it.

So add a perf_evsel__set_sample_id() method to do those two things in
one operation.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1z4xcmbud30lamklfe80oopu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c      |    6 ++----
 tools/perf/tests/mmap-basic.c |    3 +--
 tools/perf/util/evsel.c       |    6 ++++++
 tools/perf/util/evsel.h       |    2 ++
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 31a7c51..a306474 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -910,10 +910,8 @@ static void perf_top__start_counters(struct perf_top *top)
 			attr->sample_freq = top->freq;
 		}
 
-		if (evlist->nr_entries > 1) {
-			perf_evsel__set_sample_bit(counter, ID);
-			attr->read_format |= PERF_FORMAT_ID;
-		}
+		if (evlist->nr_entries > 1)
+			perf_evsel__set_sample_id(counter);
 
 		if (perf_target__has_cpu(&top->target))
 			perf_evsel__set_sample_bit(counter, CPU);
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index 4743b6d..cdd5075 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -70,8 +70,7 @@ int test__basic_mmap(void)
 		}
 
 		evsels[i]->attr.wakeup_events = 1;
-		evsels[i]->attr.read_format |= PERF_FORMAT_ID;
-		perf_evsel__set_sample_bit(evsels[i], ID);
+		perf_evsel__set_sample_id(evsels[i]);
 
 		perf_evlist__add(evlist, evsels[i]);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index fc80f5a..9dde7e9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -68,6 +68,12 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 	}
 }
 
+void perf_evsel__set_sample_id(struct perf_evsel *evsel)
+{
+	perf_evsel__set_sample_bit(evsel, ID);
+	evsel->attr.read_format |= PERF_FORMAT_ID;
+}
+
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7398539..5c08977 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -129,6 +129,8 @@ void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
 #define perf_evsel__reset_sample_bit(evsel, bit) \
 	__perf_evsel__reset_sample_bit(evsel, PERF_SAMPLE_##bit)
 
+void perf_evsel__set_sample_id(struct perf_evsel *evsel);
+
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter);
 
-- 
1.7.9.2.358.g22243

