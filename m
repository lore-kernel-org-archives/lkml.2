Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab0KSVaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:30:13 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59359 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0KSVaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:30:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/4] perf python scripting: Add futex-contention script
Date: Fri, 19 Nov 2010 19:29:46 -0200
Message-Id: <1290202186-25352-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290202186-25352-1-git-send-email-acme@infradead.org>
References: <1290202186-25352-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The equivalent to this SystemTAP script:

http://sourceware.org/systemtap/wiki/WSFutexContention

[root@doppio ~]# perf trace futex-contention
Press control+C to stop and show the summary
^Cnpviewer.bin[15242] lock 7f0a8be19104 contended 29 times, 72806 avg ns
npviewer.bin[15242] lock 7f0a8be19130 contended 2 times, 1355 avg ns
synergyc[17245] lock f127f4 contended 1 times, 1830569 avg ns
firefox[15116] lock 7f2b7238af0c contended 168 times, 1230390 avg ns
synergyc[17245] lock f2fc20 contended 1 times, 33149 avg ns
npviewer.bin[15255] lock 7f0a8be19074 contended 155 times, 73047 avg ns
npviewer.bin[15255] lock 7f0a8be190a0 contended 127 times, 7088 avg ns
synergyc[17247] lock f12854 contended 1 times, 46741 avg ns
synergyc[17245] lock f12610 contended 1 times, 7358 avg ns
[root@doppio ~]#

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   18 +++++++
 .../scripts/python/bin/futex-contention-record     |    2 +
 .../scripts/python/bin/futex-contention-report     |    4 ++
 tools/perf/scripts/python/futex-contention.py      |   50 ++++++++++++++++++++
 4 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/futex-contention-record
 create mode 100644 tools/perf/scripts/python/bin/futex-contention-report
 create mode 100644 tools/perf/scripts/python/futex-contention.py

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
index 99ff1b7..13cc02b 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
@@ -8,6 +8,12 @@
 
 import errno, os
 
+FUTEX_WAIT = 0
+FUTEX_WAKE = 1
+FUTEX_PRIVATE_FLAG = 128
+FUTEX_CLOCK_REALTIME = 256
+FUTEX_CMD_MASK = ~(FUTEX_PRIVATE_FLAG | FUTEX_CLOCK_REALTIME)
+
 NSECS_PER_SEC    = 1000000000
 
 def avg(total, n):
@@ -26,6 +32,18 @@ def nsecs_str(nsecs):
     str = "%5u.%09u" % (nsecs_secs(nsecs), nsecs_nsecs(nsecs)),
     return str
 
+def add_stats(dict, key, value):
+	if not dict.has_key(key):
+		dict[key] = (value, value, value, 1)
+	else:
+		min, max, avg, count = dict[key]
+		if value < min:
+			min = value
+		if value > max:
+			max = value
+		avg = (avg + value) / 2
+		dict[key] = (min, max, avg, count + 1)
+
 def clear_term():
     print("\x1b[H\x1b[2J")
 
diff --git a/tools/perf/scripts/python/bin/futex-contention-record b/tools/perf/scripts/python/bin/futex-contention-record
new file mode 100644
index 0000000..5ecbb43
--- /dev/null
+++ b/tools/perf/scripts/python/bin/futex-contention-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -a -e syscalls:sys_enter_futex -e syscalls:sys_exit_futex $@
diff --git a/tools/perf/scripts/python/bin/futex-contention-report b/tools/perf/scripts/python/bin/futex-contention-report
new file mode 100644
index 0000000..c826813
--- /dev/null
+++ b/tools/perf/scripts/python/bin/futex-contention-report
@@ -0,0 +1,4 @@
+#!/bin/bash
+# description: futext contention measurement
+
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/futex-contention.py
diff --git a/tools/perf/scripts/python/futex-contention.py b/tools/perf/scripts/python/futex-contention.py
new file mode 100644
index 0000000..11e70a3
--- /dev/null
+++ b/tools/perf/scripts/python/futex-contention.py
@@ -0,0 +1,50 @@
+# futex contention
+# (c) 2010, Arnaldo Carvalho de Melo <acme@redhat.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# Translation of:
+#
+# http://sourceware.org/systemtap/wiki/WSFutexContention
+#
+# to perf python scripting.
+#
+# Measures futex contention
+
+import os, sys
+sys.path.append(os.environ['PERF_EXEC_PATH'] + '/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+from Util import *
+
+process_names = {}
+thread_thislock = {}
+thread_blocktime = {}
+
+lock_waits = {} # long-lived stats on (tid,lock) blockage elapsed time
+process_names = {} # long-lived pid-to-execname mapping
+
+def syscalls__sys_enter_futex(event, ctxt, cpu, s, ns, tid, comm,
+			      nr, uaddr, op, val, utime, uaddr2, val3):
+	cmd = op & FUTEX_CMD_MASK
+	if cmd != FUTEX_WAIT:
+		return # we don't care about originators of WAKE events
+
+	process_names[tid] = comm
+	thread_thislock[tid] = uaddr
+	thread_blocktime[tid] = nsecs(s, ns)
+
+def syscalls__sys_exit_futex(event, ctxt, cpu, s, ns, tid, comm,
+			     nr, ret):
+	if thread_blocktime.has_key(tid):
+		elapsed = nsecs(s, ns) - thread_blocktime[tid]
+		add_stats(lock_waits, (tid, thread_thislock[tid]), elapsed)
+		del thread_blocktime[tid]
+		del thread_thislock[tid]
+
+def trace_begin():
+	print "Press control+C to stop and show the summary"
+
+def trace_end():
+	for (tid, lock) in lock_waits:
+		min, max, avg, count = lock_waits[tid, lock]
+		print "%s[%d] lock %x contended %d times, %d avg ns" % \
+		      (process_names[tid], tid, lock, count, avg)
+
-- 
1.6.2.5

