Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0J0LCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:02:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:45610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab0J0LCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:02:41 -0400
Date: Wed, 27 Oct 2010 11:02:16 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf python scripting: Add futex-contention script
Message-ID: <tip-00204c3396469f407bac56e1475ea16e4a279b13@git.kernel.org>
Git-Commit-ID: 00204c3396469f407bac56e1475ea16e4a279b13
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 11:02:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00204c3396469f407bac56e1475ea16e4a279b13
Gitweb:     http://git.kernel.org/tip/00204c3396469f407bac56e1475ea16e4a279b13
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 26 Oct 2010 17:07:33 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 26 Oct 2010 17:07:33 -0200

perf python scripting: Add futex-contention script

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
