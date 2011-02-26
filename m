Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab1BZEDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 23:03:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45557 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1BZEDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 23:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ILsDN9zKDJz1ox9wQN0jqe8tFKCMGbPKjM7LR6rR2u8kzjNpq7hiOiId5eEiDN4f+6
         aAeUO480dmR1j1SDQx2jYCc2E+nAFkBI7xa3z6LJJqi61x2FIZ0iTUUqOVJ0o8c+btkn
         SO/+Bv6tbyI44SA7Z+SwhQAh4CmDU6gID6rSA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf: Set filters before mmaping events
Date: Sat, 26 Feb 2011 05:03:41 +0100
Message-Id: <1298693021-23500-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently set the filters after we mmap the events, this is a
race that let undesired events record themselves in the buffer before
we had the time to set the filters.

So set the filters before they can be recorded. That also librarizes
the filters setting so that filtering can be done more easily
from other tools than perf record later.

(PS: This should fix most of the bugs Ingo has reported
about filters that weren't working with perf).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/builtin-record.c |   18 ++++++------------
 tools/perf/util/evlist.c    |   28 ++++++++++++++++++++++++++++
 tools/perf/util/evlist.h    |    1 +
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index db4cd1e..d40a81e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -180,12 +180,10 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 
 static void create_counter(struct perf_evsel *evsel, int cpu)
 {
-	char *filter = evsel->filter;
 	struct perf_event_attr *attr = &evsel->attr;
 	struct perf_header_attr *h_attr;
 	struct perf_sample_id *sid;
 	int thread_index;
-	int ret;
 
 	for (thread_index = 0; thread_index < evsel_list->threads->nr; thread_index++) {
 		h_attr = get_header_attr(attr, evsel->idx);
@@ -204,16 +202,6 @@ static void create_counter(struct perf_evsel *evsel, int cpu)
 			pr_warning("Not enough memory to add id\n");
 			exit(-1);
 		}
-
-		if (filter != NULL) {
-			ret = ioctl(FD(evsel, cpu, thread_index),
-				    PERF_EVENT_IOC_SET_FILTER, filter);
-			if (ret) {
-				error("failed to set filter with %d (%s)\n", errno,
-						strerror(errno));
-				exit(-1);
-			}
-		}
 	}
 
 	if (!sample_type)
@@ -367,6 +355,12 @@ try_again:
 		}
 	}
 
+	if (perf_evlist__set_filters(evlist)) {
+		error("failed to set filter with %d (%s)\n", errno,
+			strerror(errno));
+		exit(-1);
+	}
+
 	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 95b21fe..030ae7f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -348,3 +348,31 @@ void perf_evlist__delete_maps(struct perf_evlist *evlist)
 	evlist->cpus	= NULL;
 	evlist->threads = NULL;
 }
+
+int perf_evlist__set_filters(struct perf_evlist *evlist)
+{
+	const struct thread_map *threads = evlist->threads;
+	const struct cpu_map *cpus = evlist->cpus;
+	struct perf_evsel *evsel;
+	char *filter;
+	int thread;
+	int cpu;
+	int err;
+	int fd;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		filter = evsel->filter;
+		if (!filter)
+			continue;
+		for (cpu = 0; cpu < cpus->nr; cpu++) {
+			for (thread = 0; thread < threads->nr; thread++) {
+				fd = FD(evsel, cpu, thread);
+				err = ioctl(fd, PERF_EVENT_IOC_SET_FILTER, filter);
+				if (err)
+					return err;
+			}
+		}
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index c988405..b75805a 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -60,5 +60,6 @@ static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
 			     pid_t target_tid, const char *cpu_list);
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
+int perf_evlist__set_filters(struct perf_evlist *evlist);
 
 #endif /* __PERF_EVLIST_H */
-- 
1.7.3.2

