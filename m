Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1CHJoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:44:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:46172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab1CHJo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:44:27 -0500
Date: Tue, 8 Mar 2011 09:43:56 GMT
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
Subject: [tip:perf/core] perf evlist: Split perf_evlist__id_hash
Message-ID: <tip-3d3b5e95997208067c963923db90ed1517565d14@git.kernel.org>
Git-Commit-ID: 3d3b5e95997208067c963923db90ed1517565d14
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Mar 2011 09:43:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d3b5e95997208067c963923db90ed1517565d14
Gitweb:     http://git.kernel.org/tip/3d3b5e95997208067c963923db90ed1517565d14
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 4 Mar 2011 22:29:39 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 6 Mar 2011 13:10:45 -0300

perf evlist: Split perf_evlist__id_hash

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
 
