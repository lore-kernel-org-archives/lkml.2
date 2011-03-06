Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1CFUtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:49:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1CFUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:48:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/6] perf evlist: Split perf_evlist__id_hash
Date: Sun,  6 Mar 2011 17:48:25 -0300
Message-Id: <1299444507-26549-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299444507-26549-1-git-send-email-acme@infradead.org>
References: <1299444507-26549-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The previous situation was to receive an fd from where to read the event
ID.

Spin off a routine for when we have the ID handy, not having to read it
from some fd.

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
 tools/perf/util/evlist.c |   28 ++++++++++++++++++----------
 tools/perf/util/evlist.h |    3 +++
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 030ae7f..190c64c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -106,12 +106,24 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 	evlist->nr_fds++;
 }
 
-static int perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
-			       int cpu, int thread, int fd)
+void perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			  int cpu, int thread, u64 id)
+{
+	int hash;
+	struct perf_sample_id *sid = SID(evsel, cpu, thread);
+
+	sid->id = id;
+	sid->evsel = evsel;
+	hash = hash_64(sid->id, PERF_EVLIST__HLIST_BITS);
+	hlist_add_head(&sid->node, &evlist->heads[hash]);
+}
+
+static int perf_evlist__id_hash_fd(struct perf_evlist *evlist,
+				   struct perf_evsel *evsel,
+				   int cpu, int thread, int fd)
 {
-	struct perf_sample_id *sid;
 	u64 read_data[4] = { 0, };
-	int hash, id_idx = 1; /* The first entry is the counter value */
+	int id_idx = 1; /* The first entry is the counter value */
 
 	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
 	    read(fd, &read_data, sizeof(read_data)) == -1)
@@ -122,11 +134,7 @@ static int perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *e
 	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
 		++id_idx;
 
-	sid = SID(evsel, cpu, thread);
-	sid->id = read_data[id_idx];
-	sid->evsel = evsel;
-	hash = hash_64(sid->id, PERF_EVLIST__HLIST_BITS);
-	hlist_add_head(&sid->node, &evlist->heads[hash]);
+	perf_evlist__id_hash(evlist, evsel, cpu, thread, read_data[id_idx]);
 	return 0;
 }
 
@@ -300,7 +308,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 					goto out_unmap;
 
 				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-				    perf_evlist__id_hash(evlist, evsel, cpu, thread, fd) < 0)
+				    perf_evlist__id_hash_fd(evlist, evsel, cpu, thread, fd) < 0)
 					goto out_unmap;
 			}
 		}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index b75805a..078d512 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -38,6 +38,9 @@ void perf_evlist__delete(struct perf_evlist *evlist);
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 
+void perf_evlist__id_hash(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			  int cpu, int thread, u64 id);
+
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist);
 void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
-- 
1.6.2.5

