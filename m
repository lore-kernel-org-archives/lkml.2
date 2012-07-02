Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2GBSIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:08:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39165 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab2GBSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:08:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf kvm: Fix regression with guest machine creation
Date: Mon,  2 Jul 2012 15:07:50 -0300
Message-Id: <1341252471-7834-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341252471-7834-1-git-send-email-acme@infradead.org>
References: <1341252471-7834-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Commit 743eb868657bdb1b26c7b24077ca21c67c82c777 reworked when the
machines were created. Prior to this commit guest machines could be
created in perf_event__process_kernel_mmap() while processing kernel
MMAP events. This commit assumes that the machines exist by the time
perf_session_deliver_event is called (e.g., during processing of build
id events) - which is not always correct.

One example is the use of default guest args (--guestkallsyms and
--guestmodules) for short times where no samples hit within a guest
module. For this case no build id is added to the file header. No build
id == no machine created. That leads to the next example -- the use of
no-buildid (-B) on the record for all perf-kvm invocations. In both
cases perf report dies with a SEGFAULT of the form:

(gdb) bt
0  0x000000000046dd7b in machine__mmap_name (self=0x0, bf=0x7fffffffbd20 "q\021", size=4096) at util/map.c:715
1  0x0000000000444161 in perf_event__process_kernel_mmap (tool=0x7fffffffdd80, event=0x7ffff7fb4120, machine=0x0) at util/event.c:562
2  0x0000000000444642 in perf_event__process_mmap (tool=0x7fffffffdd80, event=0x7ffff7fb4120, sample=0x7fffffffd210, machine=0x0)
    at util/event.c:668
3  0x0000000000470e0b in perf_session_deliver_event (session=0x915ca0, event=0x7ffff7fb4120, sample=0x7fffffffd210, tool=0x7fffffffdd80,
    file_offset=8480) at util/session.c:979
4  0x000000000047032e in flush_sample_queue (s=0x915ca0, tool=0x7fffffffdd80) at util/session.c:679
5  0x0000000000471c8d in __perf_session__process_events (session=0x915ca0, data_offset=400, data_size=150448, file_size=150848, tool=
    0x7fffffffdd80) at util/session.c:1363
6  0x0000000000471d42 in perf_session__process_events (self=0x915ca0, tool=0x7fffffffdd80) at util/session.c:1379
7  0x000000000042484a in __cmd_report (rep=0x7fffffffdd80) at builtin-report.c:368
8  0x0000000000425bf1 in cmd_report (argc=0, argv=0x915b00, prefix=0x0) at builtin-report.c:756
9  0x0000000000438505 in __cmd_report (argc=4, argv=0x7fffffffe260) at builtin-kvm.c:84
10 0x000000000043882a in cmd_kvm (argc=4, argv=0x7fffffffe260, prefix=0x0) at builtin-kvm.c:131
11 0x00000000004152cd in run_builtin (p=0x7a54e8, argc=9, argv=0x7fffffffe260) at perf.c:273
12 0x00000000004154c7 in handle_internal_command (argc=9, argv=0x7fffffffe260) at perf.c:345
13 0x0000000000415613 in run_argv (argcp=0x7fffffffe14c, argv=0x7fffffffe140) at perf.c:389
14 0x0000000000415899 in main (argc=9, argv=0x7fffffffe260) at perf.c:487

Fix by allowing the machine to be created in perf_session_deliver_event.

Tested with --guestmount option and default guest args, with and without
-B arg on record for both and for short (10 seconds) and long (10
minutes) windows.

Reported-by: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1341180697-64515-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c3e399b..56142d0 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -926,7 +926,7 @@ static struct machine *
 		else
 			pid = event->ip.pid;
 
-		return perf_session__find_machine(session, pid);
+		return perf_session__findnew_machine(session, pid);
 	}
 
 	return perf_session__find_host_machine(session);
-- 
1.7.1

