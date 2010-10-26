Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0JZA34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:29:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:53581 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0JZA3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:29:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/5] perf python scripting: Improve the syscalls-by-pid script
Date: Mon, 25 Oct 2010 22:29:16 -0200
Message-Id: <1288052957-14087-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1288052957-14087-1-git-send-email-acme@infradead.org>
References: <1288052957-14087-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

. Print message at script start telling how to get te summary
. Print the syscall names
. Accept both pid (if numeric) or COMM name

Now it looks like this:

[root@emilia tmp]# perf trace syscall-counts-by-pid
Press control+C to stop and show the summary
^C
syscall events by comm/pid:

comm [pid]/syscalls                            count
----------------------------------------  ----------

automount [1670]
  futex                                            2

sshd [2322]
  rt_sigprocmask                                   4
  select                                           2
  write                                            1
  read                                             1

perf [15178]
  read                                          2506
  open                                           794
  close                                          769
  write                                          240
  getdents                                       112
  lseek                                           16
  stat                                             9
  perf_counter_open                                5
  fcntl                                            5
  mmap                                             5
  statfs                                           2

perf [15179]
  read                                         56701
  open                                           499
  stat                                           176
  fstat                                          149
  close                                          109
  mmap                                            98
  brk                                             75
  rt_sigaction                                    66
  munmap                                          42
  mprotect                                        24
  lstat                                            7
  lseek                                            5
  getdents                                         4
  ioctl                                            3
  readlink                                         2
  futex                                            1
  statfs                                           1
  getegid                                          1
  geteuid                                          1
  getgid                                           1
  getuid                                           1
  getrlimit                                        1
  fcntl                                            1
  uname                                            1
  write                                            1
[root@emilia tmp]# fg
-bash: fg: current: no such job
[root@emilia tmp]# perf trace syscall-counts-by-pid 2322
Press control+C to stop and show the summary
^C
syscall events by comm/pid:

comm [pid]/syscalls                            count
----------------------------------------  ----------

sshd [2322]
  rt_sigprocmask                                   4
  select                                           2
  write                                            1
  read                                             1
[root@emilia tmp]# perf trace syscall-counts-by-pid sshd
Press control+C to stop and show the summary
^C
syscall events for sshd:

comm [pid]/syscalls                            count
----------------------------------------  ----------

sshd [2322]
  rt_sigprocmask                                   4
  select                                           2
  write                                            1
  read                                             1
[root@emilia tmp]#

Cc: David S. Miller <davem@davemloft.net>
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
 tools/perf/scripts/python/syscall-counts-by-pid.py |   21 ++++++++++++-------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/perf/scripts/python/syscall-counts-by-pid.py b/tools/perf/scripts/python/syscall-counts-by-pid.py
index af722d6..d1ee3ec 100644
--- a/tools/perf/scripts/python/syscall-counts-by-pid.py
+++ b/tools/perf/scripts/python/syscall-counts-by-pid.py
@@ -5,29 +5,33 @@
 # Displays system-wide system call totals, broken down by syscall.
 # If a [comm] arg is specified, only syscalls called by [comm] are displayed.
 
-import os
-import sys
+import os, sys
 
 sys.path.append(os.environ['PERF_EXEC_PATH'] + \
 	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
 
 from perf_trace_context import *
 from Core import *
+from Util import syscall_name
 
 usage = "perf trace -s syscall-counts-by-pid.py [comm]\n";
 
 for_comm = None
+for_pid = None
 
 if len(sys.argv) > 2:
 	sys.exit(usage)
 
 if len(sys.argv) > 1:
-	for_comm = sys.argv[1]
+	try:
+		for_pid = int(sys.argv[1])
+	except:
+		for_comm = sys.argv[1]
 
 syscalls = autodict()
 
 def trace_begin():
-	pass
+	print "Press control+C to stop and show the summary"
 
 def trace_end():
 	print_syscall_totals()
@@ -35,9 +39,10 @@ def trace_end():
 def raw_syscalls__sys_enter(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
 	id, args):
-	if for_comm is not None:
-		if common_comm != for_comm:
-			return
+
+	if (for_comm and common_comm != for_comm) or \
+	   (for_pid  and common_pid  != for_pid ):
+		return
 	try:
 		syscalls[common_comm][common_pid][id] += 1
 	except TypeError:
@@ -61,4 +66,4 @@ def print_syscall_totals():
 		    id_keys = syscalls[comm][pid].keys()
 		    for id, val in sorted(syscalls[comm][pid].iteritems(), \
 				  key = lambda(k, v): (v, k),  reverse = True):
-			    print "  %-38d  %10d\n" % (id, val),
+			    print "  %-38s  %10d\n" % (syscall_name(id), val),
-- 
1.6.2.5

