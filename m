Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1DKRgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632Ab1DKRf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:35:59 -0400
Date: Mon, 11 Apr 2011 14:35:36 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, efault@gmx.de,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf evsel: Fix inverted test for fixing up
	attr.inherit flag
Message-ID: <20110411173536.GA29895@ghostprotocols.net>
References: <new-submission> <tip-e603dc15072c7fec0ae263597e6dabc3bb4c5c5b@git.kernel.org> <1302357942.9086.1281.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1302357942.9086.1281.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Sat, Apr 09, 2011 at 04:05:42PM +0200, Peter Zijlstra escreveu:
> On Tue, 2011-02-22 at 09:10 +0000, tip-bot for Arnaldo Carvalho de Melo
> wrote:
> > Commit-ID:  e603dc15072c7fec0ae263597e6dabc3bb4c5c5b
> > Gitweb:     http://git.kernel.org/tip/e603dc15072c7fec0ae263597e6dabc3bb4c5c5b
> > Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> > AuthorDate: Mon, 21 Feb 2011 16:05:50 -0300
> > Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> > CommitDate: Mon, 21 Feb 2011 22:27:59 -0300
> > 
> > perf evsel: Fix inverted test for fixing up attr.inherit flag
> > 
> > The kernel refuses mmapping an event with the inherit flag set for
> > something that is systemwide (cpu == -1), and the evsel layer got this
> > reversed at some point, fix it.
> > 
> > +		 * Proper fix is not to pass 'inherit' to perf_evsel__open*,
> > +		 * but a 'flags' parameter, with 'group' folded there as well,
> > +		 * then introduce a PERF_O_{MMAP,GROUP,INHERIT} enum, and if
> > +		 * O_MMAP is set, emit a warning if cpu < 0 and O_INHERIT is
> > +		 * set. Lets go for the minimal fix first tho.
> > +		 */
> > +		evsel->attr.inherit = (cpus->map[cpu] >= 0) && inherit;
 
> This wrecked perf-stat, perf-stat doesn't mmap and its perfectly fine
> for it to use task-bound counters with inheritance.

Can you check if the patch below fixes this? An acked-by or tested-by
tag would be mucho appreciated.

- Arnaldo

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-evsel-Fix-use-of-inherit-in-non-mmap-case.patch"

>From 6bb91a9b3ca76ad0311d72989655a2b31ef2ef4b Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 11 Apr 2011 09:33:59 -0300
Subject: [PATCH 1/1] perf evsel: Fix use of inherit in non mmap case

perf stat doesn't mmap and its perfectly fine for it to use task-bound
counters with inheritance.

So don't do any change in the perf_evsel__open parameters, leaving the
syscall itself to validate this.

When the mmap fails perf_evlist__mmap will just emit a warning if this
is the failure reason.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/n/tip-zkjs8vstfnq9yq9r2jkh8kz0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    3 +++
 tools/perf/util/evlist.c    |   14 ++++++++++----
 tools/perf/util/evsel.c     |   15 ++-------------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 17d1dcb..426f4f4 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -251,6 +251,9 @@ static void open_counters(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos;
 
+	if (evlist->cpus->map[0] < 0)
+		no_inherit = true;
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
 		/*
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d852cef..45da8d1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -12,6 +12,7 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "util.h"
+#include "debug.h"
 
 #include <sys/mman.h>
 
@@ -250,15 +251,19 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist, int cpu, int prot,
-			       int mask, int fd)
+static int __perf_evlist__mmap(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			       int cpu, int prot, int mask, int fd)
 {
 	evlist->mmap[cpu].prev = 0;
 	evlist->mmap[cpu].mask = mask;
 	evlist->mmap[cpu].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[cpu].base == MAP_FAILED)
+	if (evlist->mmap[cpu].base == MAP_FAILED) {
+		if (evlist->cpus->map[cpu] == -1 && evsel->attr.inherit)
+			ui__warning("Inherit is not allowed on per-task "
+				    "events using mmap.\n");
 		return -1;
+	}
 
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
@@ -312,7 +317,8 @@ int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite)
 					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT,
 						  FD(first_evsel, cpu, 0)) != 0)
 						goto out_unmap;
-				} else if (__perf_evlist__mmap(evlist, cpu, prot, mask, fd) < 0)
+				} else if (__perf_evlist__mmap(evlist, evsel, cpu,
+							       prot, mask, fd) < 0)
 					goto out_unmap;
 
 				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 662596a..0feffc9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -190,21 +190,10 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		pid = evsel->cgrp->fd;
 	}
 
+	evsel->attr.inherit = inherit;
+
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		int group_fd = -1;
-		/*
-		 * Don't allow mmap() of inherited per-task counters. This
-		 * would create a performance issue due to all children writing
-		 * to the same buffer.
-		 *
-		 * FIXME:
-		 * Proper fix is not to pass 'inherit' to perf_evsel__open*,
-		 * but a 'flags' parameter, with 'group' folded there as well,
-		 * then introduce a PERF_O_{MMAP,GROUP,INHERIT} enum, and if
-		 * O_MMAP is set, emit a warning if cpu < 0 and O_INHERIT is
-		 * set. Lets go for the minimal fix first tho.
-		 */
-		evsel->attr.inherit = (cpus->map[cpu] >= 0) && inherit;
 
 		for (thread = 0; thread < threads->nr; thread++) {
 
-- 
1.6.2.5


--AqsLC8rIMeq19msA--
