Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1BVSx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:53:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:43467 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1BVSx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:53:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf probe: Remove redundant checks
Date: Tue, 22 Feb 2011 15:53:09 -0300
Message-Id: <1298400790-29453-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298400790-29453-1-git-send-email-acme@infradead.org>
References: <1298400790-29453-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

While fixing an error propagating problem in f809b25 I added two
redundant checks.

I did that because I didn't expect the checks to be on the while and for
loop condition expression, where they are tested before we run the loop,
where the 'ret' variable is set.

So remove it from there and leave it just after it is actually set,
eliminating unneded tests.

Reported-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |    2 +-
 tools/perf/util/probe-finder.c |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 369ddc6..5ddee66 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1832,7 +1832,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 	}
 
 	/* Loop 2: add all events */
-	for (i = 0; i < npevs && ret >= 0; i++) {
+	for (i = 0; i < npevs; i++) {
 		ret = __add_probe_trace_events(pkgs[i].pev, pkgs[i].tevs,
 						pkgs[i].ntevs, force_add);
 		if (ret < 0)
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index eecbdca..17f9c4a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1462,8 +1462,7 @@ static int find_probes(int fd, struct probe_finder *pf)
 	off = 0;
 	line_list__init(&pf->lcache);
 	/* Loop on CUs (Compilation Unit) */
-	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) &&
-	       ret >= 0) {
+	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
 		diep = dwarf_offdie(dbg, off + cuhl, &pf->cu_die);
 		if (!diep)
@@ -1484,7 +1483,7 @@ static int find_probes(int fd, struct probe_finder *pf)
 				pf->lno = pp->line;
 				ret = find_probe_point_by_line(pf);
 			}
-			if (ret != DWARF_CB_OK)
+			if (ret < 0)
 				break;
 		}
 		off = noff;
-- 
1.6.2.5

