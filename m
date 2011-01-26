Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1AZHZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:25:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:52926 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab1AZHZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:25:35 -0500
Date: Wed, 26 Jan 2011 07:25:12 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Introduce perf_evsel__{in,ex}it
Message-ID: <tip-ef1d1af28ca37fdbc2745da040529cd2953c1af5@git.kernel.org>
Git-Commit-ID: ef1d1af28ca37fdbc2745da040529cd2953c1af5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:25:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef1d1af28ca37fdbc2745da040529cd2953c1af5
Gitweb:     http://git.kernel.org/tip/ef1d1af28ca37fdbc2745da040529cd2953c1af5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 18 Jan 2011 21:41:45 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Jan 2011 13:18:05 -0200

perf evsel: Introduce perf_evsel__{in,ex}it

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
