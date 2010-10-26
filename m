Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab0JZKXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:23:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:34444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab0JZKXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:23:48 -0400
Date: Tue, 26 Oct 2010 10:23:19 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, davem@davemloft.net,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, davem@davemloft.net,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf python scripting: Improve the syscalls-by-pid script
Message-ID: <tip-a64fa198ba1cd232871710c37476e006ed5516ed@git.kernel.org>
Git-Commit-ID: a64fa198ba1cd232871710c37476e006ed5516ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 10:23:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a64fa198ba1cd232871710c37476e006ed5516ed
Gitweb:     http://git.kernel.org/tip/a64fa198ba1cd232871710c37476e006ed5516ed
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 25 Oct 2010 18:44:09 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Oct 2010 18:48:15 -0200

perf python scripting: Improve the syscalls-by-pid script

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
