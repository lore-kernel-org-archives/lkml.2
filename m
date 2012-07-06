Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2GFQCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:02:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64560 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2GFQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:02:29 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf lock: fix segfault with info subcommand following move to libtraceevent
Date: Fri,  6 Jul 2012 10:02:18 -0600
Message-Id: <1341590538-19523-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 'perf lock info' on a "random" perf.data file crashes:

0  0x00000000004a5618 in __parse_common (pevent=0x0, data=0x0, size=0xa0, offset=0x9c, name=
    0x556e02 "common_type") at /opt/sw/ahern/kernels/kernel.git/tools/lib/traceevent/event-parse.c:2851
1  0x00000000004a56a7 in trace_parse_common_type (pevent=0x0, data=0x0)
    at /opt/sw/ahern/kernels/kernel.git/tools/lib/traceevent/event-parse.c:2861
2  0x00000000004a7e42 in pevent_data_type (pevent=0x0, rec=0x7fffffffddf0)
    at /opt/sw/ahern/kernels/kernel.git/tools/lib/traceevent/event-parse.c:3952
3  0x0000000000473f37 in trace_parse_common_type (data=0x0) at util/trace-event-parse.c:158
4  0x00000000004376cd in process_raw_event (data=0x0, cpu=-1, timestamp=533548521126805, thread=
    0x918450) at builtin-lock.c:727
5  0x0000000000437df4 in process_sample_event (tool=0x7ab300, event=0x7ffff7ff9dd8, sample=
    0x7fffffffdf60, evsel=0x917d90, machine=0x9161c0) at builtin-lock.c:863
6  0x0000000000470d04 in perf_session_deliver_event (session=0x916160, event=0x7ffff7ff9dd8, sample=
    0x7fffffffdf60, tool=0x7ab300, file_offset=11736) at util/session.c:977
7  0x000000000047024a in flush_sample_queue (s=0x916160, tool=0x7ab300) at util/session.c:679
8  0x0000000000471ba9 in __perf_session__process_events (session=0x916160, data_offset=400, data_size=
    11576, file_size=11976, tool=0x7ab300) at util/session.c:1363
9  0x0000000000471c5e in perf_session__process_events (self=0x916160, tool=0x7ab300)
    at util/session.c:1379
10 0x0000000000437e80 in read_events () at builtin-lock.c:880
11 0x0000000000438275 in cmd_lock (argc=0, argv=0x7fffffffe420, prefix=0x0) at builtin-lock.c:10

In this case the data file has cycles events, not traces and hence nothing
to do with lock tracepoints. Nonetheless, perf-lock should not crash. The
crash started with commit aaf045f72335653b24784d6042be8e4aee114403 - ie.,
the move to libtraceevent.

With this patch you get the more user friendly:
$ perf lock info
  Fatal: Unknown type of information

Signed-off-by: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/builtin-lock.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index fd53319..55f7961 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -877,6 +877,9 @@ static int read_events(void)
 	if (!session)
 		die("Initializing perf session failed\n");
 
+	if (!perf_session__has_traces(session, "lock record"))
+		exit(1);
+
 	return perf_session__process_events(session, &eops);
 }
 
-- 
1.7.10.1

