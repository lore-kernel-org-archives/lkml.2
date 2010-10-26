Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab0JZKWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:22:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:34348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab0JZKWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:22:44 -0400
Date: Tue, 26 Oct 2010 10:22:10 GMT
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
Subject: [tip:perf/urgent] perf python scripting: Improve the failed-syscalls-by-pid script
Message-ID: <tip-6cc7361440e499abb3a30cdbcfedad03e43c92ae@git.kernel.org>
Git-Commit-ID: 6cc7361440e499abb3a30cdbcfedad03e43c92ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 10:22:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6cc7361440e499abb3a30cdbcfedad03e43c92ae
Gitweb:     http://git.kernel.org/tip/6cc7361440e499abb3a30cdbcfedad03e43c92ae
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 25 Oct 2010 15:15:10 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Oct 2010 18:46:41 -0200

perf python scripting: Improve the failed-syscalls-by-pid script

. Print message at script start telling how to get te summary
. Print the syscall name using the audit-lib-python package, if
  installed
. Print the errno string
. Accept both pid (if numeric) or COMM name

Now it looks like this:

[root@emilia ~]# perf trace failed-syscalls-by-pid
Press control+C to stop and show the summary
^C
syscall errors:

comm [pid]                           count
------------------------------  ----------

automount [1670]
  syscall: futex
    err = ETIMEDOUT                     39

irqbalance [1462]
  syscall: openat
    err = ENOENT                         4

perf [7888]
  syscall: lseek
    err = ESPIPE                         1
  syscall: open
    err = ENOENT                        24

perf [7889]
  syscall: ioctl
    err = EINVAL                         1
  syscall: readlink
    err = EINVAL                         2
  syscall: open
    err = ENOENT                       389
  syscall: stat
    err = ENOENT                       141
  syscall: lseek
    err = ESPIPE                         3
[root@emilia ~]#

[root@emilia ~]# perf trace failed-syscalls-by-pid 1670
Press control+C to stop and show the summary
^C
syscall errors:

comm [pid]                           count
------------------------------  ----------

automount [1670]
  syscall: futex
    err = ETIMEDOUT                      2
[root@emilia ~]#
[root@emilia ~]#
[root@emilia ~]#
[root@emilia ~]# perf trace failed-syscalls-by-pid automount
Press control+C to stop and show the summary
^C
syscall errors for automount:

comm [pid]                           count
------------------------------  ----------

automount [1669]
  syscall: futex
    err = ETIMEDOUT                      1

automount [1670]
  syscall: futex
    err = ETIMEDOUT                      5
[root@emilia ~]#

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
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   37 ++++++++++++++++++++
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   21 +++++++----
 2 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
index 9689bc0..9d15f48 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
@@ -6,6 +6,8 @@
 # Public License ("GPL") version 2 as published by the Free Software
 # Foundation.
 
+import errno, os
+
 NSECS_PER_SEC    = 1000000000
 
 def avg(total, n):
@@ -26,3 +28,38 @@ def nsecs_str(nsecs):
 
 def clear_term():
     print("\x1b[H\x1b[2J")
+
+audit_package_warned = False
+
+try:
+	import audit
+	machine_to_id = {
+		'x86_64': audit.MACH_86_64,
+		'alpha'	: audit.MACH_ALPHA,
+		'armeb'	: audit.MACH_ARMEB,
+		'ia64'	: audit.MACH_IA64,
+		'ppc'	: audit.MACH_PPC,
+		'ppc64'	: audit.MACH_PPC64,
+		's390'	: audit.MACH_S390,
+		's390x'	: audit.MACH_S390X,
+		'i386'	: audit.MACH_X86,
+		'i586'	: audit.MACH_X86,
+		'i686'	: audit.MACH_X86,
+	}
+	machine_id = machine_to_id[os.uname()[4]]
+except:
+	if not audit_package_warned:
+		audit_package_warned = True
+		print "Install the audit-libs-python package to get syscall names"
+
+def syscall_name(id):
+	try:
+		return audit.audit_syscall_to_name(id, machine_id)
+	except:
+		return str(id)
+
+def strerror(nr):
+	try:
+		return errno.errorcode[abs(nr)]
+	except:
+		return "Unknown %d errno" % nr
diff --git a/tools/perf/scripts/python/failed-syscalls-by-pid.py b/tools/perf/scripts/python/failed-syscalls-by-pid.py
index 0ca0227..acd7848 100644
--- a/tools/perf/scripts/python/failed-syscalls-by-pid.py
+++ b/tools/perf/scripts/python/failed-syscalls-by-pid.py
@@ -13,21 +13,26 @@ sys.path.append(os.environ['PERF_EXEC_PATH'] + \
 
 from perf_trace_context import *
 from Core import *
+from Util import *
 
-usage = "perf trace -s syscall-counts-by-pid.py [comm]\n";
+usage = "perf trace -s syscall-counts-by-pid.py [comm|pid]\n";
 
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
 	print_error_totals()
@@ -35,9 +40,9 @@ def trace_end():
 def raw_syscalls__sys_exit(event_name, context, common_cpu,
 	common_secs, common_nsecs, common_pid, common_comm,
 	id, ret):
-	if for_comm is not None:
-		if common_comm != for_comm:
-			return
+	if (for_comm and common_comm != for_comm) or \
+	   (for_pid  and common_pid  != for_pid ):
+		return
 
 	if ret < 0:
 		try:
@@ -62,7 +67,7 @@ def print_error_totals():
 		    print "\n%s [%d]\n" % (comm, pid),
 		    id_keys = syscalls[comm][pid].keys()
 		    for id in id_keys:
-			    print "  syscall: %-16d\n" % (id),
+			    print "  syscall: %-16s\n" % syscall_name(id),
 			    ret_keys = syscalls[comm][pid][id].keys()
 			    for ret, val in sorted(syscalls[comm][pid][id].iteritems(), key = lambda(k, v): (v, k),  reverse = True):
-				    print "    err = %-20d  %10d\n" % (ret, val),
+				    print "    err = %-20s  %10d\n" % (strerror(ret), val),
