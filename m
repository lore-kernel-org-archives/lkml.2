Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1HYQSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:18:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34321 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1HYQSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:18:01 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf record: create events initially disabled and enable after init
Date: Thu, 25 Aug 2011 10:17:55 -0600
Message-Id: <1314289075-14706-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-record currently creates events enabled. When doing a system wide
collection (-a arg) this causes data collection for perf's initialization
activities -- eg., perf_event__synthesize_threads(). For some events
(e.g., context switch S/W event or tracepoints like syscalls) perf's
initialization causes a lot of events to be captured frequently
generating "Check IO/CPU overload!" warnings on larger systems
(e.g., 2 socket, quad core, hyperthreading).

perf's initialization phase can be skipped by creating events
disabled and then enabling them once the initialization is done.

Signed-off-by: David Ahern <dsahern@gmail.com>
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
1.7.6

