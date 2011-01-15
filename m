Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1AOPoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:44:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:37072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab1AOPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:41:03 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 15/16] perf evlist: Steal mmap reading routine from 'perf top'
Date: Sat, 15 Jan 2011 13:40:44 -0200
Message-Id: <1295106045-31192-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295106045-31192-1-git-send-email-acme@infradead.org>
References: <1295106045-31192-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used in the upcoming 'perf test' entry for the evlist mmap
routines.

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
 tools/perf/builtin-top.c |   56 ++---------------------------------------
 tools/perf/util/evlist.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |    4 +++
 3 files changed, 69 insertions(+), 53 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index eca916f..4901277 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1099,67 +1099,17 @@ static void event__process_sample(const event_t *self,
 
 static void perf_session__mmap_read_cpu(struct perf_session *self, int cpu)
 {
-	struct perf_mmap *md = &evsel_list->mmap[cpu];
-	unsigned int head = perf_mmap__read_head(md);
-	unsigned int old = md->prev;
-	unsigned char *data = md->base + page_size;
 	struct sample_data sample;
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
-
-		/*
-		 * head points to a known good entry, start there.
-		 */
-		old = head;
-	}
-
-	for (; old != head;) {
-		event_t *event = (event_t *)&data[old & md->mask];
-
-		event_t event_copy;
-
-		size_t size = event->header.size;
-
-		/*
-		 * Event straddles the mmap boundary -- header should always
-		 * be inside due to u64 alignment of output.
-		 */
-		if ((old & md->mask) + size != ((old + size) & md->mask)) {
-			unsigned int offset = old;
-			unsigned int len = min(sizeof(*event), size), cpy;
-			void *dst = &event_copy;
-
-			do {
-				cpy = min(md->mask + 1 - (offset & md->mask), len);
-				memcpy(dst, &data[offset & md->mask], cpy);
-				offset += cpy;
-				dst += cpy;
-				len -= cpy;
-			} while (len);
-
-			event = &event_copy;
-		}
+	event_t *event;
 
+	while ((event = perf_evlist__read_on_cpu(evsel_list, cpu)) != NULL) {
 		event__parse_sample(event, self, &sample);
+
 		if (event->header.type == PERF_RECORD_SAMPLE)
 			event__process_sample(event, &sample, self);
 		else
 			event__process(event, &sample, self);
-		old += size;
 	}
-
-	md->prev = old;
 }
 
 static void perf_session__mmap_read(struct perf_session *self)
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index deb82a4..4b3b84c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -95,3 +95,65 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 			return sid->evsel;
 	return NULL;
 }
+
+event_t *perf_evlist__read_on_cpu(struct perf_evlist *evlist, int cpu)
+{
+	/* XXX Move this to perf.c, making it generally available */
+	unsigned int page_size = sysconf(_SC_PAGE_SIZE);
+	struct perf_mmap *md = &evlist->mmap[cpu];
+	unsigned int head = perf_mmap__read_head(md);
+	unsigned int old = md->prev;
+	unsigned char *data = md->base + page_size;
+	event_t *event = NULL;
+	int diff;
+
+	/*
+	 * If we're further behind than half the buffer, there's a chance
+	 * the writer will bite our tail and mess up the samples under us.
+	 *
+	 * If we somehow ended up ahead of the head, we got messed up.
+	 *
+	 * In either case, truncate and restart at head.
+	 */
+	diff = head - old;
+	if (diff > md->mask / 2 || diff < 0) {
+		fprintf(stderr, "WARNING: failed to keep up with mmap data.\n");
+
+		/*
+		 * head points to a known good entry, start there.
+		 */
+		old = head;
+	}
+
+	if (old != head) {
+		size_t size;
+
+		event = (event_t *)&data[old & md->mask];
+		size = event->header.size;
+
+		/*
+		 * Event straddles the mmap boundary -- header should always
+		 * be inside due to u64 alignment of output.
+		 */
+		if ((old & md->mask) + size != ((old + size) & md->mask)) {
+			unsigned int offset = old;
+			unsigned int len = min(sizeof(*event), size), cpy;
+			void *dst = &evlist->event_copy;
+
+			do {
+				cpy = min(md->mask + 1 - (offset & md->mask), len);
+				memcpy(dst, &data[offset & md->mask], cpy);
+				offset += cpy;
+				dst += cpy;
+				len -= cpy;
+			} while (len);
+
+			event = &evlist->event_copy;
+		}
+
+		old += size;
+	}
+
+	md->prev = old;
+	return event;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index dbfcc79..2871206 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -3,6 +3,7 @@
 
 #include <linux/list.h>
 #include "../perf.h"
+#include "event.h"
 
 struct pollfd;
 
@@ -15,6 +16,7 @@ struct perf_evlist {
 	int		 nr_entries;
 	int		 nr_fds;
 	int		 mmap_len;
+	event_t		 event_copy;
 	struct perf_mmap *mmap;
 	struct pollfd	 *pollfd;
 };
@@ -32,4 +34,6 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
+event_t *perf_evlist__read_on_cpu(struct perf_evlist *self, int cpu);
+
 #endif /* __PERF_EVLIST_H */
-- 
1.6.2.5

