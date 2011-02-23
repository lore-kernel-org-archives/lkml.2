Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1BWHfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:35:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:52646 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab1BWHfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:35:23 -0500
Date: Wed, 23 Feb 2011 07:34:45 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Remove redundant checks
Message-ID: <tip-8635bf6ea3402154eec64763e6ed14972013c1c1@git.kernel.org>
Git-Commit-ID: 8635bf6ea3402154eec64763e6ed14972013c1c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 07:34:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8635bf6ea3402154eec64763e6ed14972013c1c1
Gitweb:     http://git.kernel.org/tip/8635bf6ea3402154eec64763e6ed14972013c1c1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 22 Feb 2011 06:56:18 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 Feb 2011 07:02:07 -0300

perf probe: Remove redundant checks

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
