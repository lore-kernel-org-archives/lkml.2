Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1A2WTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:19:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab1A2WTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:19:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/7] perf evlist: Support non overwrite mode in perf_evlist__read_on_cpu
Date: Sat, 29 Jan 2011 20:19:15 -0200
Message-Id: <1296339559-20914-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296339559-20914-1-git-send-email-acme@infradead.org>
References: <1296339559-20914-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

I.e. stash the overwrite mode in struct perf_evlist and act accordingly
in perf_evlist__read_on_cpu, not checking for overwrites and touching
the tail after consuming one event, like perf record does, for instance.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |   35 ++++++++++++++++++++---------------
 tools/perf/util/evlist.h |    1 +
 tools/perf/util/evsel.c  |    1 +
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index df0610e..b498eec 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -116,24 +116,25 @@ event_t *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
 	event_t *event = NULL;
-	int diff;
-
-	/*
-	 * If we're further behind than half the buffer, there's a chance
-	 * the writer will bite our tail and mess up the samples under us.
-	 *
-	 * If we somehow ended up ahead of the head, we got messed up.
-	 *
-	 * In either case, truncate and restart at head.
-	 */
-	diff = head - old;
-	if (diff > md->mask / 2 || diff < 0) {
-		fprintf(stderr, "WARNING: failed to keep up with mmap data.\n");
 
+	if (evlist->overwrite) {
 		/*
-		 * head points to a known good entry, start there.
+		 * If we're further behind than half the buffer, there's a chance
+		 * the writer will bite our tail and mess up the samples under us.
+		 *
+		 * If we somehow ended up ahead of the head, we got messed up.
+		 *
+		 * In either case, truncate and restart at head.
 		 */
-		old = head;
+		int diff = head - old;
+		if (diff > md->mask / 2 || diff < 0) {
+			fprintf(stderr, "WARNING: failed to keep up with mmap data.\n");
+
+			/*
+			 * head points to a known good entry, start there.
+			 */
+			old = head;
+		}
 	}
 
 	if (old != head) {
@@ -166,5 +167,9 @@ event_t *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
 	}
 
 	md->prev = old;
+
+	if (!evlist->overwrite)
+		perf_mmap__write_tail(md, old);
+
 	return event;
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index acbe48e..2706ae4 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -16,6 +16,7 @@ struct perf_evlist {
 	int		 nr_entries;
 	int		 nr_fds;
 	int		 mmap_len;
+	bool		 overwrite;
 	event_t		 event_copy;
 	struct perf_mmap *mmap;
 	struct pollfd	 *pollfd;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 76ab553..f98b3e5 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -327,6 +327,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, struct cpu_map *cpus,
 	    perf_evlist__alloc_pollfd(evlist, cpus->nr, threads->nr) < 0)
 		return -ENOMEM;
 
+	evlist->overwrite = overwrite;
 	evlist->mmap_len = (pages + 1) * page_size;
 	first_evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
 
-- 
1.6.2.5

