Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1BVBbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 20:31:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:51993 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1BVBbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 20:31:12 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf evsel: Fix inverted test for fixing up attr.inherit flag
Date: Mon, 21 Feb 2011 22:31:02 -0300
Message-Id: <1298338262-26258-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298338262-26258-1-git-send-email-acme@infradead.org>
References: <1298338262-26258-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 
-- 
1.6.2.5

