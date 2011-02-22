Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1BVJKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:10:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:35302 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab1BVJKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:10:34 -0500
Date: Tue, 22 Feb 2011 09:09:55 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix error propagation leading to segfault
Message-ID: <tip-fbee632d0ca9f4073a3fefb9a843eac8af036b0f@git.kernel.org>
Git-Commit-ID: fbee632d0ca9f4073a3fefb9a843eac8af036b0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 22 Feb 2011 09:09:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbee632d0ca9f4073a3fefb9a843eac8af036b0f
Gitweb:     http://git.kernel.org/tip/fbee632d0ca9f4073a3fefb9a843eac8af036b0f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 21 Feb 2011 13:23:57 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Feb 2011 22:21:27 -0300

perf probe: Fix error propagation leading to segfault

There are two hunks in this patch that stops probe processing as soon as one
error is found, breaking out of loops, the other fix an error propagation that
should return a negative error number but instead was returning the result of
"ret < 0", which is 1 and thus made several error checks fail because they test
agains < 0.

The problem could be triggered by asking for a variable that was optimized out,
fact that should stop the whole probe processing but instead was segfaulting
while installing broken probes:

[root@emilia ~]# probe perf_mmap:55 user_lock_limit
Failed to find the location of user_lock_limit at this address.
 Perhaps, it has been optimized out.
Failed to find 'user_lock_limit' in this function.
Add new events:
  probe:perf_mmap      (on perf_mmap:55 with user_lock_limit)
  probe:perf_mmap_1    (on perf_mmap:55 with user_lock_limit)
Segmentation fault (core dumped)
[root@emilia ~]# perf probe -l
  probe:perf_mmap      (on perf_mmap:55@git/linux/kernel/perf_event.c with user_lock_limit)
  probe:perf_mmap_1    (on perf_mmap:55@git/linux/kernel/perf_event.c with user_lock_limit)
[root@emilia ~]#

After the fix:

[root@emilia ~]# probe perf_mmap:55 user_lock_limit
Failed to find the location of user_lock_limit at this address.
 Perhaps, it has been optimized out.
Failed to find 'user_lock_limit' in this function.
  Error: Failed to add events. (-2)
[root@emilia ~]#

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
 tools/perf/util/probe-event.c  |    5 ++++-
 tools/perf/util/probe-finder.c |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0e3ea13..369ddc6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1832,9 +1832,12 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 	}
 
 	/* Loop 2: add all events */
-	for (i = 0; i < npevs && ret >= 0; i++)
+	for (i = 0; i < npevs && ret >= 0; i++) {
 		ret = __add_probe_trace_events(pkgs[i].pev, pkgs[i].tevs,
 						pkgs[i].ntevs, force_add);
+		if (ret < 0)
+			break;
+	}
 end:
 	/* Loop 3: cleanup and free trace events  */
 	for (i = 0; i < npevs; i++) {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index fe461f6..eecbdca 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1262,7 +1262,7 @@ static int probe_point_line_walker(const char *fname, int lineno,
 	ret = call_probe_finder(NULL, pf);
 
 	/* Continue if no error, because the line will be in inline function */
-	return ret < 0 ?: 0;
+	return ret < 0 ? ret : 0;
 }
 
 /* Find probe point from its line number */
@@ -1484,6 +1484,8 @@ static int find_probes(int fd, struct probe_finder *pf)
 				pf->lno = pp->line;
 				ret = find_probe_point_by_line(pf);
 			}
+			if (ret != DWARF_CB_OK)
+				break;
 		}
 		off = noff;
 	}
