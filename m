Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1FCNf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:35:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:57749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1FCNf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:35:58 -0400
Date: Fri, 3 Jun 2011 13:35:44 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-4wtew8hd3g7ejnlehtspys2t@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Remove dependency on debug routines
Git-Commit-ID: bccdaba044a445eb2c391295587aa47977994777
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 13:35:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bccdaba044a445eb2c391295587aa47977994777
Gitweb:     http://git.kernel.org/tip/bccdaba044a445eb2c391295587aa47977994777
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 2 Jun 2011 10:39:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 2 Jun 2011 10:41:41 -0300

perf evlist: Remove dependency on debug routines

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
