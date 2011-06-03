Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1FCQ0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:26:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44979 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab1FCQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:26:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf evlist: Remove dependency on debug routines
Date: Fri,  3 Jun 2011 13:26:00 -0300
Message-Id: <1307118363-24092-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1307118363-24092-1-git-send-email-acme@infradead.org>
References: <1307118363-24092-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So far we avoided having to link debug.o in the python binding, keep it
that way by not using ui__warning() in evlist.c.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4wtew8hd3g7ejnlehtspys2t@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 50aa348..04c8a60 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -12,7 +12,6 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "util.h"
-#include "debug.h"
 
 #include <sys/mman.h>
 
@@ -257,19 +256,15 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist, struct perf_evsel *evsel,
+static int __perf_evlist__mmap(struct perf_evlist *evlist,
 			       int idx, int prot, int mask, int fd)
 {
 	evlist->mmap[idx].prev = 0;
 	evlist->mmap[idx].mask = mask;
 	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[idx].base == MAP_FAILED) {
-		if (evlist->cpus->map[idx] == -1 && evsel->attr.inherit)
-			ui__warning("Inherit is not allowed on per-task "
-				    "events using mmap.\n");
+	if (evlist->mmap[idx].base == MAP_FAILED)
 		return -1;
-	}
 
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
@@ -289,7 +284,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 
 				if (output == -1) {
 					output = fd;
-					if (__perf_evlist__mmap(evlist, evsel, cpu,
+					if (__perf_evlist__mmap(evlist, cpu,
 								prot, mask, output) < 0)
 						goto out_unmap;
 				} else {
@@ -329,7 +324,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 
 			if (output == -1) {
 				output = fd;
-				if (__perf_evlist__mmap(evlist, evsel, thread,
+				if (__perf_evlist__mmap(evlist, thread,
 							prot, mask, output) < 0)
 					goto out_unmap;
 			} else {
-- 
1.6.2.5

