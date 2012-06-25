Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2FYEhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 00:37:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56613 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2FYEho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 00:37:44 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: psuriset@linux.vnet.ibm.com, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] perf kvm: fix segfault with default guest arguments
Date: Sun, 24 Jun 2012 22:37:35 -0600
Message-Id: <1340599055-89633-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File generated with:
$ perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms
    --guestmodules=/tmp/guest-modules record -a

The report command:
$ perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms
    --guestmodules=/tmp/guest-modules report

dies with a SEGFAULT:
Program received signal SIGSEGV, Segmentation fault.
0x000000000046dd7b in machine__mmap_name (self=0x0, bf=0x7fffffffbd20 "q\021", size=4096) at util/map.c:715
715			snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);

(gdb) bt
    at util/event.c:668
    file_offset=8480) at util/session.c:979
    0x7fffffffdd80) at util/session.c:1363

If no samples hit within a guest module then no build id events are written
to the header during the record. On the report side this cases no 'machine'
to be generated for the default guest (pid == 0) leading to a
machine == NULL in perf_session_deliver_event.

perf's handling of default kallsyms and guest-modules needs to be reworked.
Until then perf should at least not segfault.

Reported-by: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/session.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c3e399b..3999d5e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -976,6 +976,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 		}
 		return tool->sample(tool, event, sample, evsel, machine);
 	case PERF_RECORD_MMAP:
+		if (machine == NULL)
+			return 0;
 		return tool->mmap(tool, event, sample, machine);
 	case PERF_RECORD_COMM:
 		return tool->comm(tool, event, sample, machine);
-- 
1.7.10.1

