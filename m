Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1BVJKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:10:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:35311 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1BVJKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:10:47 -0500
Date: Tue, 22 Feb 2011 09:10:21 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Fix inverted test for fixing up attr.inherit flag
Message-ID: <tip-e603dc15072c7fec0ae263597e6dabc3bb4c5c5b@git.kernel.org>
Git-Commit-ID: e603dc15072c7fec0ae263597e6dabc3bb4c5c5b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 22 Feb 2011 09:10:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e603dc15072c7fec0ae263597e6dabc3bb4c5c5b
Gitweb:     http://git.kernel.org/tip/e603dc15072c7fec0ae263597e6dabc3bb4c5c5b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 21 Feb 2011 16:05:50 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Feb 2011 22:27:59 -0300

perf evsel: Fix inverted test for fixing up attr.inherit flag

The kernel refuses mmapping an event with the inherit flag set for
something that is systemwide (cpu == -1), and the evsel layer got this
reversed at some point, fix it.

The symtom was that the --pid and --tid parameters for 'perf record' and
'perf top' returned with -EINVAL, like:

 # /tmp/build-perf/perf record -v -fo/tmp/perf.data -p 1042
   Warning:  ... trying to fall back to cpu-clock-ticks

   Fatal: failed to mmap with 22 (Invalid argument)

Reported-by: David Ahern <dsahern@gmail.com>
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
 tools/perf/util/evsel.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 63cadaf..8083d51 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -179,8 +179,19 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		int group_fd = -1;
-
-		evsel->attr.inherit = (cpus->map[cpu] < 0) && inherit;
+		/*
+		 * Don't allow mmap() of inherited per-task counters. This
+		 * would create a performance issue due to all children writing
+		 * to the same buffer.
+		 *
+		 * FIXME:
+		 * Proper fix is not to pass 'inherit' to perf_evsel__open*,
+		 * but a 'flags' parameter, with 'group' folded there as well,
+		 * then introduce a PERF_O_{MMAP,GROUP,INHERIT} enum, and if
+		 * O_MMAP is set, emit a warning if cpu < 0 and O_INHERIT is
+		 * set. Lets go for the minimal fix first tho.
+		 */
+		evsel->attr.inherit = (cpus->map[cpu] >= 0) && inherit;
 
 		for (thread = 0; thread < threads->nr; thread++) {
 
