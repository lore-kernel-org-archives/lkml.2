Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1AYRYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:24:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1AYRWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 29/29] perf evsel: Introduce perf_evsel__{in,ex}it
Date: Tue, 25 Jan 2011 15:21:52 -0200
Message-Id: <1295976112-2796-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Out of the {con,des}structor, as in interpreted language bindings we will
need to go back from the wrapper object to the real thing. In that case
using container_of will save us to have an extra pointer in the perf_evsel
struct.

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
 tools/perf/util/evlist.c |   29 ++++++++++++++++++++---------
 tools/perf/util/evlist.h |    2 ++
 tools/perf/util/evsel.c  |   22 ++++++++++++++++------
 tools/perf/util/evsel.h  |    3 +++
 4 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4b3b84c..df0610e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -6,17 +6,21 @@
 #include <linux/bitops.h>
 #include <linux/hash.h>
 
+void perf_evlist__init(struct perf_evlist *evlist)
+{
+	int i;
+
+	for (i = 0; i < PERF_EVLIST__HLIST_SIZE; ++i)
+		INIT_HLIST_HEAD(&evlist->heads[i]);
+	INIT_LIST_HEAD(&evlist->entries);
+}
+
 struct perf_evlist *perf_evlist__new(void)
 {
 	struct perf_evlist *evlist = zalloc(sizeof(*evlist));
 
-	if (evlist != NULL) {
-		int i;
-
-		for (i = 0; i < PERF_EVLIST__HLIST_SIZE; ++i)
-			INIT_HLIST_HEAD(&evlist->heads[i]);
-		INIT_LIST_HEAD(&evlist->entries);
-	}
+	if (evlist != NULL)
+		perf_evlist__init(evlist);
 
 	return evlist;
 }
@@ -33,11 +37,18 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 	evlist->nr_entries = 0;
 }
 
-void perf_evlist__delete(struct perf_evlist *evlist)
+void perf_evlist__exit(struct perf_evlist *evlist)
 {
-	perf_evlist__purge(evlist);
 	free(evlist->mmap);
 	free(evlist->pollfd);
+	evlist->mmap = NULL;
+	evlist->pollfd = NULL;
+}
+
+void perf_evlist__delete(struct perf_evlist *evlist)
+{
+	perf_evlist__purge(evlist);
+	perf_evlist__exit(evlist);
 	free(evlist);
 }
 
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 2871206..acbe48e 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -24,6 +24,8 @@ struct perf_evlist {
 struct perf_evsel;
 
 struct perf_evlist *perf_evlist__new(void);
+void perf_evlist__init(struct perf_evlist *evlist);
+void perf_evlist__exit(struct perf_evlist *evlist);
 void perf_evlist__delete(struct perf_evlist *evlist);
 
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a85ae12..76ab553 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -14,15 +14,20 @@
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->id, x, y)
 
+void perf_evsel__init(struct perf_evsel *evsel,
+		      struct perf_event_attr *attr, int idx)
+{
+	evsel->idx	   = idx;
+	evsel->attr	   = *attr;
+	INIT_LIST_HEAD(&evsel->node);
+}
+
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
 
-	if (evsel != NULL) {
-		evsel->idx	   = idx;
-		evsel->attr	   = *attr;
-		INIT_LIST_HEAD(&evsel->node);
-	}
+	if (evsel != NULL)
+		perf_evsel__init(evsel, attr, idx);
 
 	return evsel;
 }
@@ -87,11 +92,16 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist, int ncpus)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
-void perf_evsel__delete(struct perf_evsel *evsel)
+void perf_evsel__exit(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
 	xyarray__delete(evsel->fd);
 	xyarray__delete(evsel->id);
+}
+
+void perf_evsel__delete(struct perf_evsel *evsel)
+{
+	perf_evsel__exit(evsel);
 	free(evsel);
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 667ee4e..7962e75 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -52,6 +52,9 @@ struct thread_map;
 struct perf_evlist;
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
+void perf_evsel__init(struct perf_evsel *evsel,
+		      struct perf_event_attr *attr, int idx);
+void perf_evsel__exit(struct perf_evsel *evsel);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
-- 
1.6.2.5

