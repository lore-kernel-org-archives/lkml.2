Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab1IWU2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:28:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:39409 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1IWU0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:26:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/12] perf record: Create events initially disabled and enable after init
Date: Fri, 23 Sep 2011 17:26:20 -0300
Message-Id: <1316809586-28529-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1316809586-28529-1-git-send-email-acme@infradead.org>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

perf-record currently creates events enabled. When doing a system wide
collection (-a arg) this causes data collection for perf's
initialization activities -- eg., perf_event__synthesize_threads().

For some events (e.g., context switch S/W event or tracepoints like
syscalls) perf's initialization causes a lot of events to be captured
frequently generating "Check IO/CPU overload!" warnings on larger
systems (e.g., 2 socket, quad core, hyperthreading).

perf's initialization phase can be skipped by creating events
disabled and then enabling them once the initialization is done.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1314289075-14706-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    3 +++
 tools/perf/util/evlist.c    |   13 +++++++++++++
 tools/perf/util/evlist.h    |    1 +
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6b0519f..f4c3fbe 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -161,6 +161,7 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
+	attr->disabled		= 1;
 	attr->inherit		= !no_inherit;
 	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
@@ -671,6 +672,8 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
+	perf_evlist__enable(evsel_list);
+
 	/*
 	 * Let the child rip
 	 */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c12bd47..72e9f48 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -113,6 +113,19 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 	}
 }
 
+void perf_evlist__enable(struct perf_evlist *evlist)
+{
+	int cpu, thread;
+	struct perf_evsel *pos;
+
+	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+		list_for_each_entry(pos, &evlist->entries, node) {
+			for (thread = 0; thread < evlist->threads->nr; thread++)
+				ioctl(FD(pos, cpu, thread), PERF_EVENT_IOC_ENABLE);
+		}
+	}
+}
+
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nfds = evlist->cpus->nr * evlist->threads->nr * evlist->nr_entries;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index ce85ae9..f349150 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -54,6 +54,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
 
 void perf_evlist__disable(struct perf_evlist *evlist);
+void perf_evlist__enable(struct perf_evlist *evlist);
 
 static inline void perf_evlist__set_maps(struct perf_evlist *evlist,
 					 struct cpu_map *cpus,
-- 
1.6.2.5

